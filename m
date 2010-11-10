Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756875Ab0KJQOy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 11:14:54 -0500
Received: from mga01.intel.com ([192.55.52.88]:14830 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756405Ab0KJQOw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 11:14:52 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,178,1288594800"; 
   d="scan'208";a="856161416"
Message-ID: <4CDAC4FB.8040905@linux.intel.com>
Date: Wed, 10 Nov 2010 08:14:51 -0800
From: Darren Hart <dvhart@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101027 Lightning/1.0b2 Thunderbird/3.1.6
MIME-Version: 1.0
To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        eric.dumazet@gmail.com, jkacur@redhat.com, dvhart@linux.intel.com,
        peterz@infradead.org, matt@console-pimps.org,
        u.kleine-koenig@pengutronix.de, tglx@linutronix.de, mingo@elte.hu
CC: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:core/urgent] futex: Address compiler warnings in exit_robust_list
References: <1288897200-13008-1-git-send-email-dvhart@linux.intel.com> <tip-4c115e951d80aff126468adaec7a6c7854f61ab8@git.kernel.org>
In-Reply-To: <tip-4c115e951d80aff126468adaec7a6c7854f61ab8@git.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/10/2010 04:30 AM, tip-bot for Darren Hart wrote:
> Commit-ID:  4c115e951d80aff126468adaec7a6c7854f61ab8
> Gitweb:     http://git.kernel.org/tip/4c115e951d80aff126468adaec7a6c7854f61ab8
> Author:     Darren Hart<dvhart@linux.intel.com>
> AuthorDate: Thu, 4 Nov 2010 15:00:00 -0400
> Committer:  Thomas Gleixner<tglx@linutronix.de>
> CommitDate: Wed, 10 Nov 2010 13:27:50 +0100
>
> futex: Address compiler warnings in exit_robust_list
>
> Since commit 1dcc41bb (futex: Change 3rd arg of fetch_robust_entry()
> to unsigned int*) some gcc versions decided to emit the following
> warning:
>
> kernel/futex.c: In function ‘exit_robust_list’:
> kernel/futex.c:2492: warning: ‘next_pi’ may be used uninitialized in this function
>
> The commit did not introduce the warning as gcc should have warned
> before that commit as well. It's just gcc being silly.


I agree that it should not have - but I did the bisect and this is the 
patch where the warning was first observed. I agree that it is still gcc 
being silly, and I don't know why it treats uninitialized ints different 
than uninitialized unsigned ints (or why it thinks this value is every 
used uninitialized for that matter).

Thanks for catching the compat-futex.c

--
Darren

>
> The code path really can't result in next_pi being unitialized (or
> should not), but let's keep the build clean. Annotate next_pi as an
> uninitialized_var.
>
> [ tglx: Addressed the same issue in futex_compat.c and massaged the
>    	changelog ]
>
> Signed-off-by: Darren Hart<dvhart@linux.intel.com>
> Tested-by: Matt Fleming<matt@console-pimps.org>
> Tested-by: Uwe Kleine-König<u.kleine-koenig@pengutronix.de>
> Cc: Peter Zijlstra<peterz@infradead.org>
> Cc: Eric Dumazet<eric.dumazet@gmail.com>
> Cc: John Kacur<jkacur@redhat.com>
> Cc: Ingo Molnar<mingo@elte.hu>
> LKML-Reference:<1288897200-13008-1-git-send-email-dvhart@linux.intel.com>
> Signed-off-by: Thomas Gleixner<tglx@linutronix.de>
> ---
>   kernel/futex.c        |    3 ++-
>   kernel/futex_compat.c |    3 ++-
>   2 files changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/kernel/futex.c b/kernel/futex.c
> index 6c683b3..40a8777 100644
> --- a/kernel/futex.c
> +++ b/kernel/futex.c
> @@ -2489,7 +2489,8 @@ void exit_robust_list(struct task_struct *curr)
>   {
>   	struct robust_list_head __user *head = curr->robust_list;
>   	struct robust_list __user *entry, *next_entry, *pending;
> -	unsigned int limit = ROBUST_LIST_LIMIT, pi, next_pi, pip;
> +	unsigned int limit = ROBUST_LIST_LIMIT, pi, pip;
> +	unsigned int uninitialized_var(next_pi);
>   	unsigned long futex_offset;
>   	int rc;
>
> diff --git a/kernel/futex_compat.c b/kernel/futex_compat.c
> index 06da4df..a7934ac 100644
> --- a/kernel/futex_compat.c
> +++ b/kernel/futex_compat.c
> @@ -49,7 +49,8 @@ void compat_exit_robust_list(struct task_struct *curr)
>   {
>   	struct compat_robust_list_head __user *head = curr->compat_robust_list;
>   	struct robust_list __user *entry, *next_entry, *pending;
> -	unsigned int limit = ROBUST_LIST_LIMIT, pi, next_pi, pip;
> +	unsigned int limit = ROBUST_LIST_LIMIT, pi, pip;
> +	unsigned int uninitialized_var(next_pi);
>   	compat_uptr_t uentry, next_uentry, upending;
>   	compat_long_t futex_offset;
>   	int rc;


-- 
Darren Hart
Embedded Linux Kernel
