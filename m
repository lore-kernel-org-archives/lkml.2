Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753830Ab0EQGEw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 02:04:52 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:36744 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753068Ab0EQGEu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 02:04:50 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: cpumask: fix compat getaffinity
Cc: kosaki.motohiro@jp.fujitsu.com, Milton Miller <miltonm@bga.com>,
       Arnd Bergmann <arnd@arndb.de>, Greg KH <greg@kroah.com>,
       linux-kernel@vger.kernel.org, stable@vger.kernel.org, anton@samba.org
In-Reply-To: <201005142209.14473.rusty@rustcorp.com.au>
References: <1273653045_3386@mail4.comsite.net> <201005142209.14473.rusty@rustcorp.com.au>
Message-Id: <20100517134320.A190.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Mon, 17 May 2010 15:04:44 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Wed, 12 May 2010 06:00:45 pm Milton Miller wrote:
> > 
> > At least for parsing, we need to allocate and parse NR_CPUS until
> > all places like arch/powerpc/platforms/pseries/xics.c that compare a
> > user-supplied mask to CPUMASK_ALL are eliminated.
> 
> Good point.  Anton will want to fix those anyway for CONFIG_CPUMASK_OFFSTACK,
> too, but that's the reason the parsing uses nr_cpumask_bits.
> 
> > > Would it make sense to use my initial patch for -stable, which reverts
> > > the ABI back to before the change that caused the problem, but apply
> > > the correct fix (changing the ABI throughout) for future releases?
> > 
> > This would definitly be the conservative fix.
> 
> Instead of changing back to NR_CPUS which will break libnuma for
> CPUMASK_OFFSTACK, how about changing it to nr_cpumask_bits and having an
> explicit comment above it:

Yes and No.

1) sched_getaffinity syscall is used from glibc and libnuma.
2) glibc doesn't use the return value almostly. glibc emulate it as NR_CPUS=1024.
3) Now, both sched_getaffinity() and compat_sys_sched_getaffinity() have nr_cpu_ids thing.
4) But only compat_sys_sched_getaffinity() hit libnuma problem.

I think It mean compat_sys_sched_getaffinity() should behave as sched_getaffinity().
IOW, libnuma assume compat_sys_sched_getaffinity() return len args or NR_CPUS.
then, following patch do it. I confirmed the patch works with or without CPUMASK_OFFSTACK.  

So, My proposal is
	1) merge both mine and yours to linus tree
	2) but backport only mine


How do you think?


==========================================================
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: [PATCH] cpumask: fix compat getaffinity

Commit a45185d2d "cpumask: convert kernel/compat.c" broke
libnuma, which abuses sched_getaffinity to find out NR_CPUS
in order to parse /sys/devices/system/node/node*/cpumap.

On NUMA systems with less than 32 possibly CPUs, the
current compat_sys_sched_getaffinity now returns '4'
instead of the actual NR_CPUS/8, which makes libnuma
bail out when parsing the cpumap.

The libnuma call sched_getaffinity(0, bitmap, 4096)
at first. It mean the libnuma expect the return value of
sched_getaffinity() is either len argument or NR_CPUS.
But it doesn't expect to return nr_cpu_ids.

Strictly speaking, userland requirement are

1) Glibc assume the return value mean the lengh of initialized
   of mask argument. E.g. if sched_getaffinity(1024) return 128,
   glibc make zero fill rest 896 byte.
2) Libnuma assume the return value can be used to guess NR_CPUS
   in kernel. It assume len-arg<NR_CPUS makes -EINVAL. But
   it try len=4096 at first and 4096 is always bigger than
   NR_CPUS. Then, if we remove strange min_length normalization,
   we never hit -EINVAL case.

sched_getaffinity() already solved this issue. This patch
adapt compat_sys_sched_getaffinity() as it.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 kernel/compat.c |   25 +++++++++++--------------
 1 files changed, 11 insertions(+), 14 deletions(-)

diff --git a/kernel/compat.c b/kernel/compat.c
index 7f40e92..5adab05 100644
--- a/kernel/compat.c
+++ b/kernel/compat.c
@@ -495,29 +495,26 @@ asmlinkage long compat_sys_sched_getaffinity(compat_pid_t pid, unsigned int len,
 {
 	int ret;
 	cpumask_var_t mask;
-	unsigned long *k;
-	unsigned int min_length = cpumask_size();
-
-	if (nr_cpu_ids <= BITS_PER_COMPAT_LONG)
-		min_length = sizeof(compat_ulong_t);
 
-	if (len < min_length)
+	if ((len * BITS_PER_BYTE) < nr_cpu_ids)
+		return -EINVAL;
+	if (len & (sizeof(compat_ulong_t)-1))
 		return -EINVAL;
 
 	if (!alloc_cpumask_var(&mask, GFP_KERNEL))
 		return -ENOMEM;
 
 	ret = sched_getaffinity(pid, mask);
-	if (ret < 0)
-		goto out;
+	if (ret == 0) {
+		size_t retlen = min_t(size_t, len, cpumask_size());
 
-	k = cpumask_bits(mask);
-	ret = compat_put_bitmap(user_mask_ptr, k, min_length * 8);
-	if (ret == 0)
-		ret = min_length;
-
-out:
+		if (compat_put_bitmap(user_mask_ptr, cpumask_bits(mask), retlen * 8))
+			ret = -EFAULT;
+		else
+			ret = retlen;
+	}
 	free_cpumask_var(mask);
+
 	return ret;
 }
 
-- 
1.6.5.2







