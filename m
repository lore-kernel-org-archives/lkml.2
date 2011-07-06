Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753273Ab1GFW3d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 18:29:33 -0400
Received: from mga03.intel.com ([143.182.124.21]:42801 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751729Ab1GFW3c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 18:29:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,489,1304319600"; 
   d="scan'208";a="23503160"
Message-ID: <4E14E1C6.1010202@linux.intel.com>
Date: Wed, 06 Jul 2011 15:29:26 -0700
From: Darren Hart <dvhart@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110424 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: vitalivanov@gmail.com
CC: Jiri Kosina <jkosina@suse.cz>, Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        lkml <linux-kernel@vger.kernel.org>,
        "trivial@kernel.org" <trivial@kernel.org>
Subject: Re: [PATCH 4/4] futex: warning corrections
References: <1309821688.4527.10.camel@vitaliy-Vostro-1400>	 <4E1494A8.7070109@linux.intel.com> <1309986669.27362.3.camel@vitaliy-Vostro-1400>
In-Reply-To: <1309986669.27362.3.camel@vitaliy-Vostro-1400>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 07/06/2011 02:11 PM, Vitaliy Ivanov wrote:
> On Wed, 2011-07-06 at 10:00 -0700, Darren Hart wrote:
>> On 07/04/2011 04:21 PM, Vitaliy Ivanov wrote:
>>> From 3f7997d71fe2b5cb16e2913928f68023855d786d Mon Sep 17 00:00:00 2001
>>> From: Vitaliy Ivanov <vitalivanov@gmail.com>
>>> Date: Tue, 5 Jul 2011 02:07:42 +0300
>>> Subject: [PATCH 4/4] futex: warning corrections
>> Hi Vitaliy,
>>
>> Thanks for looking to fix these warnings. Note that the compiler isn't
>> always aware of some of the subtleties involved with things like
>> cmpxchg. In cases where it thinks there may be an uninitialized usage,
>> be sure to confirm it is possible before adding the overhead of an
>> assignment to a hot path.
>>
>> None of these assignments are necessary. Consider using __maybe_unused
>> instead.
> 
> Darren,
> 
> Actually unused and uninitialized are different issues. __maybe_unused won't help in this case but there is another trick used in kernel for this:
> 


Heh, duh. I recently worked with __maybe_unused and uninitialized_var(),
and got them crossed in my head.


> #define uninitialized_var(x) x = x


Yes, this is the right approach.


> 
> So, here is updated patch.
> 
> From 8eeaa5a97697bcc606aea23d32028aea7b271a96 Mon Sep 17 00:00:00 2001
> From: Vitaliy Ivanov <vitalivanov@gmail.com>
> Date: Thu, 7 Jul 2011 00:05:05 +0300
> Subject: [PATCH] futex: uninitialized warning corrections
> MIME-Version: 1.0
> Content-Type: text/plain; charset=UTF-8
> Content-Transfer-Encoding: 8bit
> 
> kernel/futex.c: In function ‘fixup_pi_state_owner.clone.17’:
> kernel/futex.c:1582:6: warning: ‘curval’ may be used uninitialized in this function
> kernel/futex.c: In function ‘handle_futex_death’:
> kernel/futex.c:2486:6: warning: ‘nval’ may be used uninitialized in this function
> kernel/futex.c: In function ‘do_futex’:
> kernel/futex.c:863:11: warning: ‘curval’ may be used uninitialized in this function
> kernel/futex.c:828:6: note: ‘curval’ was declared here
> kernel/futex.c:898:5: warning: ‘oldval’ may be used uninitialized in this function
> kernel/futex.c:890:6: note: ‘oldval’ was declared here
> 
> Signed-off-by: Vitaliy Ivanov <vitalivanov@gmail.com>

Please include a blurb in the commit message as to why you used
uninitialized_var() rather than just assigning it. This will save people
the time of wondering why, and me the time of nacking "it's simpler to
just initialize to zero" patches :-)

Acked-by: Darren Hart <dvhart@linux.intel.com>


> ---
>  kernel/futex.c |    8 ++++----
>  1 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/kernel/futex.c b/kernel/futex.c
> index fe28dc2..efb8e5b 100644
> --- a/kernel/futex.c
> +++ b/kernel/futex.c
> @@ -825,7 +825,7 @@ static int wake_futex_pi(u32 __user *uaddr, u32 uval, struct futex_q *this)
>  {
>  	struct task_struct *new_owner;
>  	struct futex_pi_state *pi_state = this->pi_state;
> -	u32 curval, newval;
> +	u32 uninitialized_var(curval), newval;
>  
>  	if (!pi_state)
>  		return -EINVAL;
> @@ -887,7 +887,7 @@ static int wake_futex_pi(u32 __user *uaddr, u32 uval, struct futex_q *this)
>  
>  static int unlock_futex_pi(u32 __user *uaddr, u32 uval)
>  {
> -	u32 oldval;
> +	u32 uninitialized_var(oldval);
>  
>  	/*
>  	 * There is no waiter, so we unlock the futex. The owner died
> @@ -1546,7 +1546,7 @@ static int fixup_pi_state_owner(u32 __user *uaddr, struct futex_q *q,
>  	u32 newtid = task_pid_vnr(newowner) | FUTEX_WAITERS;
>  	struct futex_pi_state *pi_state = q->pi_state;
>  	struct task_struct *oldowner = pi_state->owner;
> -	u32 uval, curval, newval;
> +	u32 uval, uninitialized_var(curval), newval;
>  	int ret;
>  
>  	/* Owner died? */
> @@ -2451,7 +2451,7 @@ err_unlock:
>   */
>  int handle_futex_death(u32 __user *uaddr, struct task_struct *curr, int pi)
>  {
> -	u32 uval, nval, mval;
> +	u32 uval, uninitialized_var(nval), mval;
>  
>  retry:
>  	if (get_user(uval, uaddr))

-- 
Darren Hart
Intel Open Source Technology Center
Yocto Project - Linux Kernel
