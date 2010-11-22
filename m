Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757547Ab0KVULS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 15:11:18 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54405 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755512Ab0KVULQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 15:11:16 -0500
Date: Mon, 22 Nov 2010 12:10:49 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: gerald.schaefer@de.ibm.com
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: [PATCH] mutex: Introduce arch_mutex_cpu_relax()
Message-Id: <20101122121049.01c4690a.akpm@linux-foundation.org>
In-Reply-To: <1290437256.7455.4.camel@thinkpad>
References: <1290437256.7455.4.camel@thinkpad>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Nov 2010 15:47:36 +0100
Gerald Schaefer <gerald.schaefer@de.ibm.com> wrote:

> From: Gerald Schaefer <gerald.schaefer@de.ibm.com>
> 
> The spinning mutex implementation uses cpu_relax() in busy loops as a
> compiler barrier. Depending on the architecture, cpu_relax() may do more
> than needed in this specific mutex spin loops. On System z we also give
> up the time slice of the virtual cpu in cpu_relax(), which prevents
> effective spinning on the mutex.
> 
> This patch replaces cpu_relax() in the spinning mutex code with
> arch_mutex_cpu_relax(), which can be defined by each architecture that
> selects HAVE_ARCH_MUTEX_CPU_RELAX. The default is still cpu_relax(), so
> this patch should not affect other architectures than System z for now.
> 
> ...
>
> --- a/include/linux/mutex.h
> +++ b/include/linux/mutex.h
> @@ -160,4 +160,8 @@ extern int mutex_trylock(struct mutex *l
>  extern void mutex_unlock(struct mutex *lock);
>  extern int atomic_dec_and_mutex_lock(atomic_t *cnt, struct mutex *lock);
>  
> +#ifndef CONFIG_HAVE_ARCH_MUTEX_CPU_RELAX
> +#define arch_mutex_cpu_relax()	cpu_relax()
> +#endif

A simpler way of doing this is to remove the CONFIG_ variable
altogether and do 

#ifndef arch_mutex_cpu_relax
#define arch_mutex_cpu_relax()	cpu_relax()
#endif

When doing this, one should be clear about _which_ arch file has the
responsibility of defining arch_mutex_cpu_relax, and make sure that
this arch file is reliably included in the .c file.
