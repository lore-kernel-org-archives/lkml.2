Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932119Ab2JWOfX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 10:35:23 -0400
Received: from mga01.intel.com ([192.55.52.88]:12890 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754994Ab2JWOfR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 10:35:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,635,1344236400"; 
   d="scan'208";a="239012028"
Message-ID: <5086A3D1.7080709@linux.intel.com>
Date: Tue, 23 Oct 2012 07:04:01 -0700
From: Darren Hart <dvhart@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121009 Thunderbird/16.0
MIME-Version: 1.0
To: Siddhesh Poyarekar <siddhesh.poyarekar@gmail.com>
CC: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] [RESEND 2] Take over futex of dead task only if FUTEX_WAITERS
 is not set
References: <CAAHN_R1O3asyJGXqjs5qt0b_qGR6S6RuM+E_85VaEoWAyAMheQ@mail.gmail.com> <1350876034-22023-1-git-send-email-siddhesh.poyarekar@gmail.com>
In-Reply-To: <1350876034-22023-1-git-send-email-siddhesh.poyarekar@gmail.com>
X-Enigmail-Version: 1.4.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Siddesh,

Thanks for the patch and your work to isolate it in the glibc bug 14076.

On 10/21/2012 08:20 PM, Siddhesh Poyarekar wrote:
> In futex_lock_pi_atomic, we consider that if the value in the futex
> variable is 0 with additional flags, then it is safe for takeover
> since the owner of the futex is dead.  However, when FUTEX_WAITERS is
> set in the futex value, handle_futex_death calls futex_wake to wake up
> one task. 

It shouldn't for PI mutexes. It should just set the FUTEX_OWNER_DIED flag,
maintaining the FUTEX_WAITERS flag, and exit.

int handle_futex_death(...
...
		/*
		 * Wake robust non-PI futexes here. The wakeup of
		 * PI futexes happens in exit_pi_state():
		 */
		if (!pi && (uval & FUTEX_WAITERS))
			futex_wake(uaddr, 1, 1, FUTEX_BITSET_MATCH_ANY);

There may still be an issue, as the commentary around exit_pi_state_list()
doesn't inspire confidence.

--
Darren

> Hence the assumption in futex_lock_pi_atomic is not correct.
> The correct assumption is that a futex may be considered safe for a
> takeover if The FUTEX_OWNER_DIED bit is set, the TID bits are 0 and
> the FUTEX_WAITERS bit is not set.
> 
> The race described above can be seen in the reproducer in the
> following glibc bug report:
> 
> http://sourceware.org/bugzilla/show_bug.cgi?id=14076
> 
> Signed-off-by: Siddhesh Poyarekar <siddhesh.poyarekar@gmail.com>
> ---
>  kernel/futex.c |    7 ++++++-
>  1 files changed, 6 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/futex.c b/kernel/futex.c
> index 3717e7b..9aa2d5a 100644
> --- a/kernel/futex.c
> +++ b/kernel/futex.c
> @@ -760,9 +760,14 @@ retry:
>  	 * case. We also do an unconditional take over, when the owner
>  	 * of the futex died.
>  	 *
> +	 * We do not take over the futex if FUTEX_WAITERS is set because we
> +	 * could end up waking two tasks, the current one and the one that the
> +	 * futex death event wakes in handle_futex_death.
> +	 *
>  	 * This is safe as we are protected by the hash bucket lock !
>  	 */
> -	if (unlikely(ownerdied || !(curval & FUTEX_TID_MASK))) {
> +	if (unlikely(ownerdied ||
> +			!(curval & (FUTEX_TID_MASK | FUTEX_WAITERS)))) {
>  		/* Keep the OWNER_DIED bit */
>  		newval = (curval & ~FUTEX_TID_MASK) | vpid;
>  		ownerdied = 0;
> 

-- 
Darren Hart
Intel Open Source Technology Center
Yocto Project - Technical Lead - Linux Kernel
