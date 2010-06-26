Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753529Ab0FZDwe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jun 2010 23:52:34 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:56898 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753380Ab0FZDwb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jun 2010 23:52:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=DDq/uPcpEXBgAGx24LjIGLlchLpaYqKBRJH6wly8iY2iNAtVP76nIkzDMIcwgR9Dxz
         5nAuZS2rgBNwgY3CkfKJbVX0tOnrfYCr76GzXYVkVH7Hf5frQ0Pyxd0qx7z/1Y3gdrkU
         iEbaX0fKDA4GT8+cSKPyLFXls/hSvNlulJGeU=
Message-ID: <4C2577F2.4030005@garzik.org>
Date: Fri, 25 Jun 2010 23:45:54 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: mingo@elte.hu, tglx@linutronix.de, bphilips@suse.de, yinghai@kernel.org,
       akpm@linux-foundation.org, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       stern@rowland.harvard.edu, gregkh@suse.de, khali@linux-fr.org
Subject: Re: [PATCH 11/12] libata: use IRQ expecting
References: <1276443098-20653-1-git-send-email-tj@kernel.org> <1276443098-20653-12-git-send-email-tj@kernel.org> <4C23F6C1.7070603@garzik.org> <4C245E50.7090701@kernel.org>
In-Reply-To: <4C245E50.7090701@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/25/2010 03:44 AM, Tejun Heo wrote:
> I still think calling unexpect_irq() from ata_qc_complete() is correct
> as ata_qc_complete() is always a good indicator of completion events.

No, it's not.  ata_qc_complete() is an indicator that _one_ completion 
event occurred, not _all_ completion events for that port.

Converting drivers to use ata_qc_complete_multiple() completely misses 
the point:  ata_qc_complete_multiple() is doing exactly the same thing 
as those drivers:  calling ata_qc_complete() in a loop.

ata_qc_complete() is -- as its name implies -- completing a single qc. 
Your patch introduces an unconditional controller-wide unexpect_irq() 
call.  It's a layering violation.

You can trivially trace through ata_qc_complete_multiple() after patch 
#11 is applied, and see the result...  for $N completion bits passed to 
ata_qc_complete_multiple(), you call
	unexpect_irq()
	expect_irq()
in rapid succession $N times, once for each ata_qc_complete() call in 
the loop of ata_qc_complete_multiple().  For something that is not 
needed for modern SATA controllers.

The preferred solution would be something that only touches legacy 
controllers, namely:

*) create ata_port_complete(), with the implementation

	ata_qc_complete()
	unexpect_irq()

*) then call ata_port_complete() in the legacy code that needs 
unexpect_irq()

We don't want to  burden modern SATA drivers with the overhead of 
dealing with silly PATA/SATA1 legacy irq nastiness, particularly the 
ugliness of calling

	unexpect_irq() + expect_irq()

for a number of NCQ commands, in a tight loop!

	Jeff





