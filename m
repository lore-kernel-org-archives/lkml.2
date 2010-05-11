Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757639Ab0EKJFU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 05:05:20 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:49336 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755946Ab0EKJFS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 05:05:18 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: cpumask: fix compat getaffinity
Date: Tue, 11 May 2010 11:05:03 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.31-19-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, stable@kernel.org,
       Andi Kleen <andi@firstfloor.org>, Ken Werner <ken.werner@web.de>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
References: <201005071445.50147.arnd@arndb.de> <201005081111.08720.arnd@arndb.de> <201005110913.49162.rusty@rustcorp.com.au>
In-Reply-To: <201005110913.49162.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201005111105.03475.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/faiCo7oYelOAAEaRggP5mTMX4z80Ba2OdkjS
 7wry9EbQizhfRiVQdHjbEeLYdAYxPywQ+35y8LjAmSFSrykmXn
 AYGWNFDCoGXsjJthvxZTg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 11 May 2010, Rusty Russell wrote:
> cpumask: use nr_cpu_ids for printing and parsing cpumasks
> 
> Commit a45185d2d "cpumask: convert kernel/compat.c" broke
> libnuma, which abuses sched_getaffinity to find out NR_CPUS
> in order to parse /sys/devices/system/node/node*/cpumap.
> 
> However, the result now returned reflects nr_cpu_ids, and
> cpumask_scnprintf et al. use nr_cpumask_bits which is NR_CPUS (for
> CONFIG_CPUMASK_OFFSTACK=n) or nr_cpu_ids (for
> CONFIG_CPUMASK_OFFSTACK=y).
> 
> We should use nr_cpu_ids consistently.
> 
> Reported-by: Arnd Bergmann <arnd@arndb.de>
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
> Cc: stable@kernel.org

It looks like this changes fixes the compat case, but now
the native system call would be inconsistent with the
sysfs output. 

Wouldn't you also need something like the change below
to make the return value of sched_getaffinity() independent
of NR_CPUS?

Signed-off-by: Arnd Bergmann <arnd@arndb.de>

--- a/kernel/compat.c
+++ b/kernel/compat.c
@@ -495,12 +495,9 @@ asmlinkage long compat_sys_sched_getaffinity(compat_pid_t pid, unsigned int len,
 	int ret;
 	cpumask_var_t mask;
 	unsigned long *k;
-	unsigned int min_length = cpumask_size();
+	size_t size = BITS_TO_COMPAT_LONGS(nr_cpu_ids) * sizeof(compat_ulong_t);
 
-	if (nr_cpu_ids <= BITS_PER_COMPAT_LONG)
-		min_length = sizeof(compat_ulong_t);
-
-	if (len < min_length)
+	if (len < size)
 		return -EINVAL;
 
 	if (!alloc_cpumask_var(&mask, GFP_KERNEL))
@@ -511,9 +508,9 @@ asmlinkage long compat_sys_sched_getaffinity(compat_pid_t pid, unsigned int len,
 		goto out;
 
 	k = cpumask_bits(mask);
-	ret = compat_put_bitmap(user_mask_ptr, k, min_length * 8);
+	ret = compat_put_bitmap(user_mask_ptr, k, size * 8);
 	if (ret == 0)
-		ret = min_length;
+		ret = size;
 
 out:
 	free_cpumask_var(mask);
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -6693,8 +6693,9 @@ SYSCALL_DEFINE3(sched_getaffinity, pid_t, pid, unsigned int, len,
 {
 	int ret;
 	cpumask_var_t mask;
+	size_t size = BITS_TO_LONGS(nr_cpu_ids) * sizeof(long);
 
-	if (len < cpumask_size())
+	if (len < size)
 		return -EINVAL;
 
 	if (!alloc_cpumask_var(&mask, GFP_KERNEL))
@@ -6702,10 +6703,10 @@ SYSCALL_DEFINE3(sched_getaffinity, pid_t, pid, unsigned int, len,
 
 	ret = sched_getaffinity(pid, mask);
 	if (ret == 0) {
-		if (copy_to_user(user_mask_ptr, mask, cpumask_size()))
+		if (copy_to_user(user_mask_ptr, mask, size))
 			ret = -EFAULT;
 		else
-			ret = cpumask_size();
+			ret = size;
 	}
 	free_cpumask_var(mask);
 
