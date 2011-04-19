Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754021Ab1DSJJq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 05:09:46 -0400
Received: from mx2.fusionio.com ([64.244.102.31]:45369 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752382Ab1DSJJo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 05:09:44 -0400
X-ASG-Debug-ID: 1303204182-01de284cf8165230001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4DAD5156.2050300@fusionio.com>
Date: Tue, 19 Apr 2011 11:09:42 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Bart Van Assche <bvanassche@acm.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>, Neil Brown <neilb@suse.de>
Subject: Re: [Bug #32982] Kernel locks up a few minutes after boot
References: <OlQwC5HnRsN.A.ULB.OGuqNB@chimera> <_H4l51C1wXN.A.yDC.yGuqNB@chimera> <BANLkTimeaHwBiZoz=isCM=qtBxoxaBqDUw@mail.gmail.com> <BANLkTi=1jO73DXDTD50bVpU82qphVKmRCw@mail.gmail.com> <4DAC2429.5000105@fusionio.com> <BANLkTinCWWYqnksxevho9TN3u6ZC_Rjzwg@mail.gmail.com> <4DAC82E6.3020809@fusionio.com> <BANLkTimaekpwmK+z=ePE+XSP6GUteidwfw@mail.gmail.com>
X-ASG-Orig-Subj: Re: [Bug #32982] Kernel locks up a few minutes after boot
In-Reply-To: <BANLkTimaekpwmK+z=ePE+XSP6GUteidwfw@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1303204182
X-Barracuda-URL: http://10.101.1.181:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.61296
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-04-18 20:32, Bart Van Assche wrote:
> On Mon, Apr 18, 2011 at 8:28 PM, Jens Axboe <jaxboe@fusionio.com> wrote:
>> On 2011-04-18 20:21, Bart Van Assche wrote:
>>> a performance regression in the block layer not related to the md
>>> issue. If I run a small block IOPS test on a block device created by
>>> ib_srp (NOOP scheduler) I see about 11% less IOPS than with 2.6.38.3
>>> (155.000 IOPS with 2.6.38.3 and 140.000 IOPS with 2.6.39-rc3+).
>>
>> That's not good. What's the test case?
> 
> Nothing more than a fio IOPS test:
> 
> fio --bs=512 --ioengine=libaio --buffered=0 --rw=read --thread
> --iodepth=64 --numjobs=2 --loops=10000 --group_reporting --size=1G
>     --gtod_reduce=1 --name=iops-test --filename=/dev/${dev} --invalidate=1

Bart, can you try the below:

diff --git a/block/blk-core.c b/block/blk-core.c
index 5fa3dd2..9b41da1 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -307,11 +307,7 @@ void __blk_run_queue(struct request_queue *q)
 	 * Only recurse once to avoid overrunning the stack, let the unplug
 	 * handling reinvoke the handler shortly if we already got there.
 	 */
-	if (!queue_flag_test_and_set(QUEUE_FLAG_REENTER, q)) {
-		q->request_fn(q);
-		queue_flag_clear(QUEUE_FLAG_REENTER, q);
-	} else
-		queue_delayed_work(kblockd_workqueue, &q->delay_work, 0);
+	q->request_fn(q);
 }
 EXPORT_SYMBOL(__blk_run_queue);
 

-- 
Jens Axboe

