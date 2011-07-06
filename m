Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754880Ab1GFRAp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 13:00:45 -0400
Received: from mga02.intel.com ([134.134.136.20]:49484 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754714Ab1GFRAo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 13:00:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,488,1304319600"; 
   d="scan'208";a="24047978"
Message-ID: <4E1494A8.7070109@linux.intel.com>
Date: Wed, 06 Jul 2011 10:00:24 -0700
From: Darren Hart <dvhart@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110424 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: vitalivanov@gmail.com
CC: Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/4] futex: warning corrections
References: <1309821688.4527.10.camel@vitaliy-Vostro-1400>
In-Reply-To: <1309821688.4527.10.camel@vitaliy-Vostro-1400>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/04/2011 04:21 PM, Vitaliy Ivanov wrote:
> From 3f7997d71fe2b5cb16e2913928f68023855d786d Mon Sep 17 00:00:00 2001
> From: Vitaliy Ivanov <vitalivanov@gmail.com>
> Date: Tue, 5 Jul 2011 02:07:42 +0300
> Subject: [PATCH 4/4] futex: warning corrections
> MIME-Version: 1.0
> Content-Type: text/plain; charset=UTF-8
> Content-Transfer-Encoding: 8bit
>

Hi Vitaliy,

Thanks for looking to fix these warnings. Note that the compiler isn't
always aware of some of the subtleties involved with things like
cmpxchg. In cases where it thinks there may be an uninitialized usage,
be sure to confirm it is possible before adding the overhead of an
assignment to a hot path.

None of these assignments are necessary. Consider using __maybe_unused
instead.

--
Darren


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
> ---
>  kernel/futex.c |    8 ++++----
>  1 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/kernel/futex.c b/kernel/futex.c
> index fe28dc2..516ebf9 100644
> --- a/kernel/futex.c
> +++ b/kernel/futex.c
> @@ -825,7 +825,7 @@ static int wake_futex_pi(u32 __user *uaddr, u32 uval, struct futex_q *this)
>  {
>  	struct task_struct *new_owner;
>  	struct futex_pi_state *pi_state = this->pi_state;
> -	u32 curval, newval;
> +	u32 curval = 0, newval;
>  
>  	if (!pi_state)
>  		return -EINVAL;
> @@ -887,7 +887,7 @@ static int wake_futex_pi(u32 __user *uaddr, u32 uval, struct futex_q *this)
>  
>  static int unlock_futex_pi(u32 __user *uaddr, u32 uval)
>  {
> -	u32 oldval;
> +	u32 oldval = 0;
>  
>  	/*
>  	 * There is no waiter, so we unlock the futex. The owner died
> @@ -1546,7 +1546,7 @@ static int fixup_pi_state_owner(u32 __user *uaddr, struct futex_q *q,
>  	u32 newtid = task_pid_vnr(newowner) | FUTEX_WAITERS;
>  	struct futex_pi_state *pi_state = q->pi_state;
>  	struct task_struct *oldowner = pi_state->owner;
> -	u32 uval, curval, newval;
> +	u32 uval, curval = 0, newval;
>  	int ret;
>  
>  	/* Owner died? */
> @@ -2451,7 +2451,7 @@ err_unlock:
>   */
>  int handle_futex_death(u32 __user *uaddr, struct task_struct *curr, int pi)
>  {
> -	u32 uval, nval, mval;
> +	u32 uval, nval = 0, mval;
>  
>  retry:
>  	if (get_user(uval, uaddr))

-- 
Darren Hart
Intel Open Source Technology Center
Yocto Project - Linux Kernel
