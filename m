Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752165Ab0F1K1s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 06:27:48 -0400
Received: from ozlabs.org ([203.10.76.45]:47973 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751589Ab0F1K1p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 06:27:45 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [PATCH 5/5] cpumask: reduce cpumask_size
Date: Mon, 28 Jun 2010 19:57:33 +0930
User-Agent: KMail/1.13.2 (Linux/2.6.32-22-generic; KDE/4.4.2; i686; ; )
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Arnd Bergmann <arnd@arndb.de>, anton@samba.org,
       Mike Travis <travis@sgi.com>
References: <201006252235.16647.rusty@rustcorp.com.au> <20100628114425.3881.A69D9226@jp.fujitsu.com>
In-Reply-To: <20100628114425.3881.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201006281957.34403.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Jun 2010 12:42:23 pm KOSAKI Motohiro wrote:
> > Now we're sure noone is using old cpumask operators, nor *cpumask, we can
> > allocate less bits safely.  This reduces the memory usage of off-stack
> > cpumasks when CONFIG_CPUMASK_OFFSTACK=y but we don't have NR_CPUS actual
> > cpus.
> 
> I have to say I'm sorry. Probably I broke your assumption.
> If this patch applied, we reintroduce exposing nr_cpu_ids issue and
> break libnuma again. I think following change is necessary too.
> 
> Or, Am I missing something?

I cc'd you because I remembered you being involved in that libnuma issue
and couldn't remember the details.

Unfortunately, this solution doesn't work:

> diff --git a/kernel/sched.c b/kernel/sched.c
> index 18faf4d..c14acad 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -4823,7 +4823,9 @@ SYSCALL_DEFINE3(sched_getaffinity, pid_t, pid, unsigned int, len,
> 
>         ret = sched_getaffinity(pid, mask);
>         if (ret == 0) {
> -               size_t retlen = min_t(size_t, len, cpumask_size());
> +               size_t retlen = min_t(size_t, len,
> +                                     BITS_TO_LONGS(NR_CPUS) * sizeof(long));
> 

Since mask is a cpumask_var_t, only cpumask_size() is allocated.  We can't
copy NR_CPUS bits.

But I think it's OK, anyway.  libnuma is broken because it gets upset if the
number of cpus it reads from /sys/.../cpumap is more than the cpumask size
returned from sys_sched_getaffinity.

Currently, getaffinity returns cpumask_size() (ie. based on NR_CPUS), and
the printing routines use nr_cpumask_bits (ie. based on NR_CPUS for 
!CPUMASK_OFFSTACK, nr_cpu_ids for CPUMASK_OFFSTACK).

(libnuma is OK on CONFIG_CPUMASK_OFFSTACK=y because the sysfs output is
*shorter* than expected.  I checked the code).

With this patch, cpumask_size() becomes based on nr_cpumask_bits, so both
getaffinity and sysfs are using the same basis.

Do you agree?
Rusty.
