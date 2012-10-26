Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932441Ab2JZLjB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 07:39:01 -0400
Received: from mga09.intel.com ([134.134.136.24]:33495 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932348Ab2JZLi5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 07:38:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,654,1344236400"; 
   d="scan'208";a="232881268"
From: "Zhang, Yanmin" <yanmin.zhang@intel.com>
To: Thomas Gleixner <tglx@linutronix.de>, "He, Bo" <bo.he@intel.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        "yanmin_zhang@linux.intel.com" <yanmin_zhang@linux.intel.com>
Subject: RE: [PATCH] hrtimer:__run_hrtimer races with enqueue_hrtimer
Thread-Topic: [PATCH] hrtimer:__run_hrtimer races with enqueue_hrtimer
Thread-Index: AQHNs2Aab8EnwpwuWkWQn5ENsDW7f5fLdSwQ
Date: Fri, 26 Oct 2012 11:38:52 +0000
Message-ID: <144086DDB7BB6D429C79280EB1C804D41687C9@SHSMSX101.ccr.corp.intel.com>
References: <1351219917.28400.6.camel@hebo>
 <alpine.LFD.2.02.1210261147000.2756@ionos>
In-Reply-To: <alpine.LFD.2.02.1210261147000.2756@ionos>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>-----Original Message-----
>From: Thomas Gleixner [mailto:tglx@linutronix.de]
>Sent: Friday, October 26, 2012 5:55 PM
>To: He, Bo
>Cc: linux-kernel@vger.kernel.org; Peter Zijlstra; Ingo Molnar;
>yanmin_zhang@linux.intel.com; Zhang, Yanmin
>Subject: Re: [PATCH] hrtimer:__run_hrtimer races with enqueue_hrtimer
>
>On Fri, 26 Oct 2012, he, bo wrote:
>> From: Yanmin Zhang <yanmin.zhang@intel.com>
>>
>> We hit a kernel panic at __run_hrtimer=>BUG_ON(timer->state !=
>HRTIMER_STATE_CALLBACK).
>> <2>[   10.226053, 3] kernel BUG at
>/home/android/xiaobing/ymz/r4/hardware/intel/linux-2.6/kernel/hrtimer.c:1228
>!
>>
>> Basically, __run_hrtimer has a race with enqueue_hrtimer. When
>> __run_hrtimer calls the timer callback fn, another thread might call
>> enqueue_hrtimer or hrtimer_start to requeue it, and the timer->state
>> is equal to HRTIMER_STATE_CALLBACK|HRTIMER_STATE_ENQUEUED, which
>> causes the BUG_ON(timer->state != HRTIMER_STATE_CALLBACK) checking
>> fails.
>>
>> The patch fixes it by checking only bit HRTIMER_STATE_CALLBACK.
>
>This does not fix it. It makes it worse.
Thanks for your kind comments. We found that and sent V2 at https://lkml.org/lkml/2012/10/26/172.

>
>> Signed-off-by: Yanmin Zhang <yanmin.zhang@intel.com>
>> Reviewed-by: He, Bo <bo.he@intel.com>
>> ---
>>  kernel/hrtimer.c |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
>> index 6db7a5e..6280184 100644
>> --- a/kernel/hrtimer.c
>> +++ b/kernel/hrtimer.c
>> @@ -1235,7 +1235,7 @@ static void __run_hrtimer(struct hrtimer *timer,
>ktime_t *now)
>>  	 * hrtimer_start_range_ns() or in hrtimer_interrupt()
>>  	 */
>>  	if (restart != HRTIMER_NORESTART) {
>> -		BUG_ON(timer->state != HRTIMER_STATE_CALLBACK);
>> +		BUG_ON(!(timer->state & HRTIMER_STATE_CALLBACK));
>>  		enqueue_hrtimer(timer, base);
>>  	}
>
>What you are allowing here is enqueueing an already enqueued timer
>again. I don't know why this does not explode elsewhere, but that's
>probably pure luck. It's not allowed to double enqueue a timer.
You are right.

>
>So no, this is not a solution. The problem is not in the core timer
>code, the problem is in the code which uses that timer.
>
>Your code is returning HRTIMER_RESTART from the timer callback and at
>the same time it starts the timer from some other context. That's what
>needs to be fixed.
The timer user should fix it. But could we also change hrtimer to make it more stable?
At least, instead of panic, could we print some information and go ahead to let kernel
continue?

Thanks,
Yanmin


