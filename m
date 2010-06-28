Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755907Ab0F1DM3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jun 2010 23:12:29 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:33942 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753330Ab0F1DM0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jun 2010 23:12:26 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH 5/5] cpumask: reduce cpumask_size
Cc: kosaki.motohiro@jp.fujitsu.com, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
       anton@samba.org, Mike Travis <travis@sgi.com>
In-Reply-To: <201006252235.16647.rusty@rustcorp.com.au>
References: <201006252235.16647.rusty@rustcorp.com.au>
Message-Id: <20100628114425.3881.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Mon, 28 Jun 2010 12:12:23 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Now we're sure noone is using old cpumask operators, nor *cpumask, we can
> allocate less bits safely.  This reduces the memory usage of off-stack
> cpumasks when CONFIG_CPUMASK_OFFSTACK=y but we don't have NR_CPUS actual
> cpus.

I have to say I'm sorry. Probably I broke your assumption.
If this patch applied, we reintroduce exposing nr_cpu_ids issue and
break libnuma again. I think following change is necessary too.

Or, Am I missing something?

==================================================================
diff --git a/kernel/compat.c b/kernel/compat.c
index 5adab05..5fbee3e 100644
--- a/kernel/compat.c
+++ b/kernel/compat.c
@@ -506,7 +506,8 @@ asmlinkage long compat_sys_sched_getaffinity(compat_pid_t pid, unsigned int len,

        ret = sched_getaffinity(pid, mask);
        if (ret == 0) {
-               size_t retlen = min_t(size_t, len, cpumask_size());
+               size_t retlen = min_t(size_t, len,
+                                     BITS_TO_LONGS(NR_CPUS) * sizeof(long));

                if (compat_put_bitmap(user_mask_ptr, cpumask_bits(mask), retlen * 8))
                        ret = -EFAULT;
diff --git a/kernel/sched.c b/kernel/sched.c
index 18faf4d..c14acad 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -4823,7 +4823,9 @@ SYSCALL_DEFINE3(sched_getaffinity, pid_t, pid, unsigned int, len,

        ret = sched_getaffinity(pid, mask);
        if (ret == 0) {
-               size_t retlen = min_t(size_t, len, cpumask_size());
+               size_t retlen = min_t(size_t, len,
+                                     BITS_TO_LONGS(NR_CPUS) * sizeof(long));


> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: anton@samba.org
> Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Cc: Mike Travis <travis@sgi.com>
> ---
>  include/linux/cpumask.h |    6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/include/linux/cpumask.h b/include/linux/cpumask.h
> --- a/include/linux/cpumask.h
> +++ b/include/linux/cpumask.h
> @@ -1014,13 +1014,11 @@ static inline int cpulist_parse(const ch
>  /**
>   * cpumask_size - size to allocate for a 'struct cpumask' in bytes
>   *
> - * This will eventually be a runtime variable, depending on nr_cpu_ids.
> + * This can be a runtime variable, depending on nr_cpu_ids.
>   */
>  static inline size_t cpumask_size(void)
>  {
> -	/* FIXME: Once all cpumask assignments are eliminated, this
> -	 * can be nr_cpumask_bits */
> -	return BITS_TO_LONGS(NR_CPUS) * sizeof(long);
> +	return BITS_TO_LONGS(nr_cpumask_bits) * sizeof(long);
>  }
>  
>  /*
> 



