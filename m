Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755497Ab1CQUqw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 16:46:52 -0400
Received: from mga02.intel.com ([134.134.136.20]:27858 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755155Ab1CQUqt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 16:46:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,201,1299484800"; 
   d="scan'208";a="614329788"
Message-ID: <4D827326.1040208@linux.intel.com>
Date: Thu, 17 Mar 2011 13:46:30 -0700
From: Darren Hart <dvhart@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110223 Lightning/1.0b2 Thunderbird/3.1.8
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: Re: [PATCH 1/2] WARN_ON_SMP(): Allow use in if statements on UP
References: <20110317192105.308382309@goodmis.org> <20110317192208.444147791@goodmis.org>
In-Reply-To: <20110317192208.444147791@goodmis.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 03/17/2011 12:21 PM, Steven Rostedt wrote:
> From: Steven Rostedt<srostedt@redhat.com>
>
> Both WARN_ON() and WARN_ON_SMP() should be able to be used in
> an if statement.
>
> 	if (WARN_ON_SMP(foo)) { ... }
>
> Because WARN_ON_SMP() is defined as a do { } while (0) on UP,
> it can not be used this way.
>
> Convert it to the same form that WARN_ON() is, even when
> CONFIG_SMP is off.
>
> Signed-off-by: Steven Rostedt<rostedt@goodmis.org>
> ---
>   include/asm-generic/bug.h |   28 +++++++++++++++++++++++++++-
>   1 files changed, 27 insertions(+), 1 deletions(-)
>
> diff --git a/include/asm-generic/bug.h b/include/asm-generic/bug.h
> index c2c9ba0..ac2f48a 100644
> --- a/include/asm-generic/bug.h
> +++ b/include/asm-generic/bug.h
> @@ -165,10 +165,36 @@ extern void warn_slowpath_null(const char *file, const int line);
>   #define WARN_ON_RATELIMIT(condition, state)			\
>   		WARN_ON((condition)&&  __ratelimit(state))
>
> +/*
> + * WARN_ON_SMP() is for cases that the warning is either
> + * meaningless for !SMP or may even cause failures.
> + * This is usually used for cases that we have
> + * WARN_ON(!spin_is_locked(&lock)) checks, as spin_is_locked()
> + * returns 0 for uniprocessor settings.
> + * It can be also be used with values that are only defined

Typo: can be also be

--
Darren

> + * on SMP:
> + *
> + * struct foo {
> + *  [...]
> + * #ifdef CONFIG_SMP
> + *	int bar;
> + * #endif
> + * };
> + *
> + * void func(struct foo *zoot)
> + * {
> + *	WARN_ON_SMP(!zoot->bar);
> + *
> + * For CONFIG_SMP, WARN_ON_SMP() should act the same as WARN_ON(),
> + * and should be a nop and return false for uniprocessor.
> + *
> + * if (WARN_ON_SMP(x)) returns true only when CONFIG_SMP is set
> + * and x is true.
> + */
>   #ifdef CONFIG_SMP
>   # define WARN_ON_SMP(x)			WARN_ON(x)
>   #else
> -# define WARN_ON_SMP(x)			do { } while (0)
> +# define WARN_ON_SMP(x)			({0;})
>   #endif
>
>   #endif
> -- 1.7.2.3

-- 
Darren Hart
Intel Open Source Technology Center
Yocto Project - Linux Kernel
