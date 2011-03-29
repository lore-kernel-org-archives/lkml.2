Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753412Ab1C2N7r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 09:59:47 -0400
Received: from mx1.fusionio.com ([64.244.102.30]:35521 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751866Ab1C2N7q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 09:59:46 -0400
X-ASG-Debug-ID: 1301407185-03d6a5732913a30001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4D91E5CE.1080803@fusionio.com>
Date: Tue, 29 Mar 2011 15:59:42 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Rob Landley <rlandley@parallels.com>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>
Subject: Re: Commit 7eaceaccab5f40 causing boot hang.
References: <4D9179EE.9040707@parallels.com> <4D917DB1.9030300@fusionio.com> <4D919DE5.1010509@parallels.com>
X-ASG-Orig-Subj: Re: Commit 7eaceaccab5f40 causing boot hang.
In-Reply-To: <4D919DE5.1010509@parallels.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1301407185
X-Barracuda-URL: http://10.101.1.180:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.59315
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-03-29 10:52, Rob Landley wrote:
> On 03/29/2011 01:35 AM, Jens Axboe wrote:
>> On 2011-03-29 08:19, Rob Landley wrote:
>>> Using the attached config (run through oldconfig and holding down
>>> enter), 2.6.38 boots but current -git hangs.  I've bisected it to this
>>> commit:
>>>
>>> 7eaceaccab5f40bbfda044629a6298616aeaed50 is the first bad commit
>>> commit 7eaceaccab5f40bbfda044629a6298616aeaed50
>>> Author: Jens Axboe <jaxboe@fusionio.com>
>>> Date:   Thu Mar 10 08:52:07 2011 +0100
>>>
>>>     block: remove per-queue plugging
>>>
>>>     Code has been converted over to the new explicit on-stack plugging,
>>>     and delay users have been converted to use the new API for that.
>>>     So lets kill off the old plugging along with aops->sync_page().
>>>
>>>     Signed-off-by: Jens Axboe <jaxboe@fusionio.com>
>>>
>>> I suspect it broke CONFIG_IDE_GD_ATA.  (The symptoms change a bit in
>>> later versions, when that was first introduced it hung right after
>>> discovering hda, now it makes it to freeing kernel memory and then hangs
>>> trying to launch init.  But "the disk hangs a lot" still seems to
>>> describe the problem.)
>>
>> That is the case even with 9ced0b95b3993660e7990cf6bf68c1a80f31544e,
>> which was otherwise supposed to fix this queue stall?
>>
> 
> The first time I tried it, that version did manage to launch init, and
> then hung two lines later with ".udev/ already exists on the static
> /dev! ..." and the cursor still on the end of that line.  Could be an
> unrelated bug, hard to tell.
> 
> I tried it three more times and it hung right after "freeing unused
> kernel memory", with no output from init.  (I also tried adding
> "init=/bin/bash" to the kernel command line and it still hung after the
> "freeing unused kernel memory" line, with no output from bash.  Pressed
> a lot of keys, nothing echoed back.)
> 
> This is an improvement over hanging earlier in the boot, but userspace
> isn't really happy at the moment.
> 
> I'm booting all this under kvm or qemu, by the way:
> 
> qemu-system-x86_64 -m 1024 -kernel arch/x86/boot/bzImage \
>   -hda ~/sid.ext3 -append "root=/dev/hda rw"
> 
> Sometimes with init=/bin/bash in that last quoted bit.  The root
> filesystem's debian sid but that's probably not relevant because it
> worked fine with .38.

Does this help?

diff --git a/drivers/ide/ide-io.c b/drivers/ide/ide-io.c
index 0e406d73..ca27d30 100644
--- a/drivers/ide/ide-io.c
+++ b/drivers/ide/ide-io.c
@@ -570,8 +570,7 @@ void ide_requeue_and_plug(ide_drive_t *drive, struct request *rq)
 	spin_unlock_irqrestore(q->queue_lock, flags);
 
 	/* Use 3ms as that was the old plug delay */
-	if (rq)
-		blk_delay_queue(q, 3);
+	blk_delay_queue(q, 3);
 }
 
 static int drive_is_ready(ide_drive_t *drive)

-- 
Jens Axboe

