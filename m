Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752189Ab1CGIHn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 03:07:43 -0500
Received: from mx1.fusionio.com ([64.244.102.30]:48246 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750972Ab1CGIHk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 03:07:40 -0500
X-ASG-Debug-ID: 1299485259-03d6a54f6015990001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4D749247.3020105@fusionio.com>
Date: Mon, 7 Mar 2011 09:07:35 +0100
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Shaohua Li <shli@kernel.org>
CC: Mike Snitzer <snitzer@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hch@infradead.org" <hch@infradead.org>
Subject: Re: [PATCH 05/10] block: remove per-queue plugging
References: <1295659049-2688-1-git-send-email-jaxboe@fusionio.com>	<1295659049-2688-6-git-send-email-jaxboe@fusionio.com>	<AANLkTin8FoXX6oqUyW+scwhadyX-TfW16_oKjvngU9-m@mail.gmail.com>	<20110303221353.GA10366@redhat.com>	<AANLkTi=MfDzf+-eLbysoP-ZiXX6cV_tVxYE14Vr8FSak@mail.gmail.com>	<20110304214359.GA18442@redhat.com>	<4D715E8A.5070006@fusionio.com> <AANLkTi=GNGpA+j18xTNHhUed9TYaDJaT+OkyNBA=L+AO@mail.gmail.com>
X-ASG-Orig-Subj: Re: [PATCH 05/10] block: remove per-queue plugging
In-Reply-To: <AANLkTi=GNGpA+j18xTNHhUed9TYaDJaT+OkyNBA=L+AO@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1299485259
X-Barracuda-URL: http://10.101.1.180:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.57294
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-03-07 01:54, Shaohua Li wrote:
> 2011/3/5 Jens Axboe <jaxboe@fusionio.com>:
>> On 2011-03-04 22:43, Mike Snitzer wrote:
>>> On Fri, Mar 04 2011 at  8:02am -0500,
>>> Shaohua Li <shli@kernel.org> wrote:
>>>
>>>> 2011/3/4 Mike Snitzer <snitzer@redhat.com>:
>>>>> I'm now hitting a lockdep issue, while running a 'for-2.6.39/stack-plug'
>>>>> kernel, when I try an fsync heavy workload to a request-based mpath
>>>>> device (the kernel ultimately goes down in flames, I've yet to look at
>>>>> the crashdump I took)
>>>>>
>>>>>
>>>>> =======================================================
>>>>> [ INFO: possible circular locking dependency detected ]
>>>>> 2.6.38-rc6-snitm+ #2
>>>>> -------------------------------------------------------
>>>>> ffsb/3110 is trying to acquire lock:
>>>>>  (&(&q->__queue_lock)->rlock){..-...}, at: [<ffffffff811b4c4d>] flush_plug_list+0xbc/0x135
>>>>>
>>>>> but task is already holding lock:
>>>>>  (&rq->lock){-.-.-.}, at: [<ffffffff8137132f>] schedule+0x16a/0x725
>>>>>
>>>>> which lock already depends on the new lock.
>>>> I hit this too. Can you check if attached debug patch fixes it?
>>>
>>> Fixes it for me.
>>
>> The preempt bit in block/ should not be needed. Can you check whether
>> it's the moving of the flush in sched.c that does the trick?
> yes, it's not related to the lockdep issue. but I think we still need
> it. if there is a preempt  between attempt_plub_merge(), we do queue
> flush, then we might hit an incomplete list of request->biotail. Am I
> missing anything?

Ah, so it is needed with the other fix you proposed, since we do flush
on preempt then. If we only do the flush on going to sleep, then we
don't need that preemption disable in that section.

-- 
Jens Axboe

