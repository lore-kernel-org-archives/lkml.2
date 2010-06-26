Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752624Ab0FZIcH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jun 2010 04:32:07 -0400
Received: from hera.kernel.org ([140.211.167.34]:53394 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752269Ab0FZIcC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jun 2010 04:32:02 -0400
Message-ID: <4C25BAD2.4070705@kernel.org>
Date: Sat, 26 Jun 2010 10:31:14 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100317 SUSE/3.0.4-1.1.1 Thunderbird/3.0.4
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: mingo@elte.hu, tglx@linutronix.de, bphilips@suse.de, yinghai@kernel.org,
       akpm@linux-foundation.org, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       stern@rowland.harvard.edu, gregkh@suse.de, khali@linux-fr.org
Subject: Re: [PATCH 11/12] libata: use IRQ expecting
References: <1276443098-20653-1-git-send-email-tj@kernel.org> <1276443098-20653-12-git-send-email-tj@kernel.org> <4C23F6C1.7070603@garzik.org> <4C245E50.7090701@kernel.org> <4C2577F2.4030005@garzik.org>
In-Reply-To: <4C2577F2.4030005@garzik.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 26 Jun 2010 08:31:20 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Jeff.

On 06/26/2010 05:45 AM, Jeff Garzik wrote:
> No, it's not.  ata_qc_complete() is an indicator that _one_ completion
> event occurred, not _all_ completion events for that port.

Well, it can indicte the start of cluster of completions, which is the
necessary information anyway.  From the second call on, it's a simple
flag test and return.  I doubt it will affect anything even w/ high
performance SSDs but please read on.

> Converting drivers to use ata_qc_complete_multiple() completely misses
> the point:  ata_qc_complete_multiple() is doing exactly the same thing
> as those drivers:  calling ata_qc_complete() in a loop.

The point of ata_qc_complete_multiple() is giving libata core layer
better visibility into how commands are being executed, which in turn
allows (continued below)

> ata_qc_complete() is -- as its name implies -- completing a single qc.
> Your patch introduces an unconditional controller-wide unexpect_irq()
> call.  It's a layering violation.
> 
> You can trivially trace through ata_qc_complete_multiple() after patch
> #11 is applied, and see the result...  for $N completion bits passed to
> ata_qc_complete_multiple(), you call
>     unexpect_irq()
>     expect_irq()
> in rapid succession $N times, once for each ata_qc_complete() call in
> the loop of ata_qc_complete_multiple().  For something that is not
> needed for modern SATA controllers.

ata_qc_complete_multiple() call [un]expect_irq() only once by
introducing an internal completion function w/o irq expect handling,
say ata_qc_complete_raw() and making both ata_qc_complete() and
ata_qc_complete_multiple() simple wrapper around it w/ irq expect
handling.

> The preferred solution would be something that only touches legacy
> controllers, namely:
> 
> *) create ata_port_complete(), with the implementation
> 
>     ata_qc_complete()
>     unexpect_irq()
> 
> *) then call ata_port_complete() in the legacy code that needs
> unexpect_irq()
> 
> We don't want to  burden modern SATA drivers with the overhead of
> dealing with silly PATA/SATA1 legacy irq nastiness, particularly the
> ugliness of calling

I think we're much better off applying it to all the drivers.  IRQ
expecting is very cheap and scalable and there definitely are plenty
of IRQ delivery problems with modern controllers although their
patterns tend to be different from legacy ones.  Plus, it will also be
useful for power state predictions.

>     unexpect_irq() + expect_irq()
> 
> for a number of NCQ commands, in a tight loop!

As I wrote above, I don't think N*unexpect_irq() really matters but
with ata_qc_complete_multiple() conversion, there will only be single
pair of expect/unexpect for each cluster of completions anyway.

Thanks.

-- 
tejun
