Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932308Ab0JNWOl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 18:14:41 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35507 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756177Ab0JNWOk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 18:14:40 -0400
Date: Thu, 14 Oct 2010 15:13:49 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: gerald.schaefer@de.ibm.com
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: [PATCH] mutex: Introduce mutex_cpu_relax()
Message-Id: <20101014151349.826b5271.akpm@linux-foundation.org>
In-Reply-To: <1287078025.8344.56.camel@thinkpad>
References: <1287070392.8344.15.camel@thinkpad>
	<1287071960.29097.284.camel@twins>
	<1287077465.8344.47.camel@thinkpad>
	<1287078025.8344.56.camel@thinkpad>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Oct 2010 19:40:25 +0200
Gerald Schaefer <gerald.schaefer@de.ibm.com> wrote:

> From: Gerald Schaefer <gerald.schaefer@de.ibm.com>
> 
> The spinning mutex implementation uses cpu_relax() in busy loops as a
> compiler barrier. Depending on the architecture, cpu_relax() may do more
> than needed in this specific mutex spin loops. On System z we also give
> up the time slice of the virtual cpu in cpu_relax(), which prevents
> effective spinning on the mutex.
> 
> This patch replaces cpu_relax() in the spinning mutex code with a new
> function mutex_cpu_relax(), which can be defined by each architecture
> that selects HAVE_MUTEX_CPU_RELAX. The default is still cpu_relax(), so
> this patch should not affect other architectures than System z for now.
> 
> Signed-off-by: Gerald Schaefer <gerald.schaefer@de.ibm.com>
> ---
>  arch/Kconfig                  |    3 +++
>  arch/s390/Kconfig             |    1 +
>  arch/s390/include/asm/mutex.h |    2 ++
>  include/linux/mutex.h         |    4 ++++
>  kernel/mutex.c                |    2 +-
>  kernel/sched.c                |    2 +-
>  6 files changed, 12 insertions(+), 2 deletions(-)
> 
> --- a/arch/Kconfig
> +++ b/arch/Kconfig
> @@ -158,4 +158,7 @@ config HAVE_PERF_EVENTS_NMI
>  	  subsystem.  Also has support for calculating CPU cycle events
>  	  to determine how many clock cycles in a given period.
>  
> +config HAVE_MUTEX_CPU_RELAX
> +	bool
> +
>  source "kernel/gcov/Kconfig"
> --- a/arch/s390/Kconfig
> +++ b/arch/s390/Kconfig
> @@ -100,6 +100,7 @@ config S390
>  	select HAVE_KERNEL_BZIP2
>  	select HAVE_KERNEL_LZMA
>  	select HAVE_KERNEL_LZO
> +	select HAVE_MUTEX_CPU_RELAX
>  	select ARCH_INLINE_SPIN_TRYLOCK
>  	select ARCH_INLINE_SPIN_TRYLOCK_BH
>  	select ARCH_INLINE_SPIN_LOCK

We could just omit the HAVE_MUTEX_CPU_RELAX

> --- a/arch/s390/include/asm/mutex.h
> +++ b/arch/s390/include/asm/mutex.h
> @@ -7,3 +7,5 @@
>   */
>  
>  #include <asm-generic/mutex-dec.h>
> +
> +#define mutex_cpu_relax()	barrier()
> --- a/include/linux/mutex.h
> +++ b/include/linux/mutex.h
> @@ -160,4 +160,8 @@ extern int mutex_trylock(struct mutex *l
>  extern void mutex_unlock(struct mutex *lock);
>  extern int atomic_dec_and_mutex_lock(atomic_t *cnt, struct mutex *lock);
>  
> +#ifndef CONFIG_HAVE_MUTEX_CPU_RELAX
> +#define mutex_cpu_relax()	cpu_relax()
> +#endif

and do `#ifndef mutex_cpu_relax' here.  That's a pretty common trick. 
It's best to add a comment telling people which arch header file should
define mutex_cpu_relax, so everyone does it the same way.

It should perhaps be called arch_mutex_cpu_relax().
