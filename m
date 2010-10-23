Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758181Ab0JWSnz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Oct 2010 14:43:55 -0400
Received: from mx1.fusionio.com ([64.244.102.30]:39650 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758116Ab0JWSny (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Oct 2010 14:43:54 -0400
X-ASG-Debug-ID: 1287859432-169668200001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4CC32CE3.2090202@fusionio.com>
Date: Sat, 23 Oct 2010 20:43:47 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Tejun Heo <tj@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Vivek Goyal <vgoyal@redhat.com>
Subject: [GIT PULL] Throtl bug (was Re: [origin tree boot failure] Re: [GIT
 PULL] core block bits for  2.6.37-rc1)
References: <4CC143F5.3060202@fusionio.com> <20101023152959.GA20930@elte.hu> <4CC31283.1060607@fusionio.com> <4CC318AE.8010209@fusionio.com> <20101023182127.GA4160@elte.hu>
X-ASG-Orig-Subj: [GIT PULL] Throtl bug (was Re: [origin tree boot failure] Re: [GIT
 PULL] core block bits for  2.6.37-rc1)
In-Reply-To: <20101023182127.GA4160@elte.hu>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1287859432
X-Barracuda-URL: http://10.101.1.180:8000/cgi-mod/mark.cgi
X-Barracuda-Bayes: INNOCENT GLOBAL 0.4965 1.0000 0.0000
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.44531
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-10-23 20:21, Ingo Molnar wrote:
> 
> * Jens Axboe <jaxboe@fusionio.com> wrote:
> 
>>> Looks like a fairly straight forward case of uninitialized memory and 
>>> blk_sync_queue() -> throtl_shutdown_timer() -> cancel_delayed_work_sync().
>>>
>>> Will get that fixed up.
>>
>> It frees q->td in blk_cleanup_queue(), but doesn't clear q->td. When the final put 
>> happens, blk_sync_queue() is called and then ends up doing the 
>> cancel_delayed_work_sync() on freed memory.
>>
>> Two possible fixes:
>>
>> - Clear ->td when the queue is goin dead. May require other ->td == NULL
>>   checks in the code, so I opted for:
>>
>> - Move the free to when the queue is really going away, post doing the
>>   blk_sync_queue() call.
>>
>> The below should fix it.
>>
>> Signed-off-by: Jens Axboe <jaxboe@fusionio.com>
> 
> This did the trick, thanks Jens!

Great, thanks for testing/reporting! I added your reported/tested-by.

Linus, please pull this single fix, better get this out the door since
I'll be travelling very shortly.


  git://git.kernel.dk/linux-2.6-block.git for-2.6.37/core

Jens Axboe (1):
      block: fix use-after-free bug in blk throttle code

 block/blk-core.c  |    2 --
 block/blk-sysfs.c |    2 ++
 2 files changed, 2 insertions(+), 2 deletions(-)

-- 
Jens Axboe

