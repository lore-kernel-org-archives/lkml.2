Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754825Ab0ESAhx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 20:37:53 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:51603 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752565Ab0ESAhv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 20:37:51 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH] cpumask: fix compat getaffinity
Cc: kosaki.motohiro@jp.fujitsu.com, Greg KH <greg@kroah.com>,
       Milton Miller <miltonm@bga.com>, Ken Werner <ken.werner@web.de>,
       Andi Kleen <andi@firstfloor.org>, Rusty Russell <rusty@rustcorp.com.au>,
       Arnd Bergmann <arnd@arndb.de>, stable@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Message-Id: <20100519091544.8813.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Wed, 19 May 2010 09:37:41 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Is there any chance to merge this patch at this merge window?
Now, Ken and PS3 community suffer from the regression of 
commit a45185d2d. And I and Rusty agreed the following fix is sufficient.


==============================================
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
Acked-by: Rusty Russell <rusty@rustcorp.com.au>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Reported-by: Ken Werner <ken.werner@web.de>
Cc: stable@kernel.org
Cc: Andi Kleen <andi@firstfloor.org>
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









