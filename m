Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934548Ab0KQIIX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 03:08:23 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:43218 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758033Ab0KQIIW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 03:08:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=VSuQ74ydPcFMpTHOTtyqkULT9bNSAlsTUv8Th3L+73wqPNt1tF3XpIWYaxCSQGNw74
         g+lwA6A6HWYRC2NMNFU1eFJtzTul96QJHie9OHIaCzhK88AXxjXE2U3rdgpDzVHUl6ZH
         YF7WImttNXcWTcIQLYZHbf42/dNrxCCy/8zs4=
Message-ID: <4CE38D70.4010507@garzik.org>
Date: Wed, 17 Nov 2010 03:08:16 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101027 Fedora/3.1.6-1.fc13 Thunderbird/3.1.6
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] libata: remove unlock+relock cycle in ata_scsi_queuecmd
References: <20101117062958.GA2894@havoc.gtf.org> <AANLkTikQysiwSV_m38vKaEuPQ=NH10o2s69d=aNGOhLr@mail.gmail.com>
In-Reply-To: <AANLkTikQysiwSV_m38vKaEuPQ=NH10o2s69d=aNGOhLr@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/17/2010 01:44 AM, Linus Torvalds wrote:
> On Tue, Nov 16, 2010 at 10:29 PM, Jeff Garzik<jeff@garzik.org>  wrote:
>>
>> +       spin_lock(shost->host_lock);
>> +       scsi_cmd_get_serial(shost, cmd);
>>         spin_unlock(shost->host_lock);
>
> This is just sad.
>
> How important is that serial number? So important that we need to do a
> spinlock over it here? And it _must_ be per-shost?

Quite unimportant.  Quoting James from 
http://marc.info/?l=linux-kernel&m=128949079704323&w=2
> There are only a few drivers left that actually make use of a serial
> number.  Of those, the only modern ones are qla4, lpfc, mpt2sas and
> megaraid.
>
> So the next logical step seems to be eliminate the overloading of the
> serial number zero value, which removes the last mid-layer use (dpt_i2o
> seems to abuse this unnecessarily as well), then the serial number code
> can be pushed down into the queuecommand routines of only those drivers
> that actually use it.  None of the modern ones seems to have a
> legitimate use, so I think their uses can mostly be eliminated.  Thus,
> we might be able to get away with a simple queuecommand push down and
> never bother with atomics for this (since it's unlikely the legacy users
> would convert away from a lock wrapping their queuecommand routines).


Looking solely at the SCSI code (ie. ignoring LLD code), it seems like 
the magic number zero for serial_number is signaling a boolean condition 
"are we an EH command?"

EH tests this at the very beginning of the abort/reset/explode error 
handling sequence, presumably to avoid recursive EH invocations 
(scsi_try_to_abort_cmd).

So maybe an EH expert (Tejun?) can correct me here, but I think we may 
be able to completely the lock/get-serial/unlock sequence from libata, 
as long as scsi_init_cmd_errh() reliably sets an "I am an EH command" flag.

Would be nice if true...

	Jeff


