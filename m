Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756008Ab2DNTP4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2012 15:15:56 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:53219 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755865Ab2DNTPV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2012 15:15:21 -0400
From: Sasha Levin <levinsasha928@gmail.com>
To: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        peterz@infradead.org, mingo@elte.hu, hpa@zytor.com, tglx@linutronix.de,
        srivatsa.bhat@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, Sasha Levin <levinsasha928@gmail.com>
Subject: [RFC 2/3] sched: add type checks to for_each_cpu_mask()
Date: Sat, 14 Apr 2012 18:14:44 -0400
Message-Id: <1334441685-4438-3-git-send-email-levinsasha928@gmail.com>
X-Mailer: git-send-email 1.7.8.5
In-Reply-To: <1334441685-4438-1-git-send-email-levinsasha928@gmail.com>
References: <1334441685-4438-1-git-send-email-levinsasha928@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add type checks to assert that 'mask' is 'struct cpumask *'. This check
would have detected the bug fixed in e3831ed ("sched: Fix incorrect usage
of for_each_cpu_mask() in select_fallback_rq()"):

kernel/sched/core.c: In function 'select_fallback_rq':
kernel/sched/core.c:1273:2: warning: comparison of distinct pointer types lacks a cast
kernel/sched/core.c:1284:3: warning: comparison of distinct pointer types lacks a cast

Signed-off-by: Sasha Levin <levinsasha928@gmail.com>
---
 include/linux/cpumask.h |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/include/linux/cpumask.h b/include/linux/cpumask.h
index a2c819d..58fd022 100644
--- a/include/linux/cpumask.h
+++ b/include/linux/cpumask.h
@@ -799,7 +799,8 @@ static inline const struct cpumask *get_cpu_mask(unsigned int cpu)
 #define first_cpu(src)		({ (void)(src); 0; })
 #define next_cpu(n, src)	({ (void)(src); 1; })
 #define any_online_cpu(mask)	0
-#define for_each_cpu_mask(cpu, mask)	\
+#define for_each_cpu_mask(cpu, mask)		\
+	typecheck(struct cpumask *, (mask));	\
 	for ((cpu) = 0; (cpu) < 1; (cpu)++, (void)mask)
 #else /* NR_CPUS > 1 */
 int __first_cpu(const cpumask_t *srcp);
@@ -809,6 +810,7 @@ int __next_cpu(int n, const cpumask_t *srcp);
 #define next_cpu(n, src)	__next_cpu((n), &(src))
 #define any_online_cpu(mask) cpumask_any_and(&mask, cpu_online_mask)
 #define for_each_cpu_mask(cpu, mask)			\
+	typecheck(struct cpumask *, (mask));		\
 	for ((cpu) = -1;				\
 		(cpu) = next_cpu((cpu), (mask)),	\
 		(cpu) < NR_CPUS; )
-- 
1.7.8.5

