Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761576Ab0HGMZr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Aug 2010 08:25:47 -0400
Received: from hera.kernel.org ([140.211.167.34]:36955 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753053Ab0HGMZp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Aug 2010 08:25:45 -0400
Message-ID: <4C5D50AF.2070906@kernel.org>
Date: Sat, 07 Aug 2010 14:25:19 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.8) Gecko/20100802 Thunderbird/3.1.2
MIME-Version: 1.0
To: Namhyung Kim <namhyung@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: percpu: handle __percpu notations in UP accessors
References: <1281119187-12640-1-git-send-email-namhyung@gmail.com>
In-Reply-To: <1281119187-12640-1-git-send-email-namhyung@gmail.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 07 Aug 2010 12:25:44 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 18cb2aef91b37dbce2bec2f39bb1dddd0e9dd838 Mon Sep 17 00:00:00 2001
From: Namhyung Kim <namhyung@gmail.com>
Date: Sat, 7 Aug 2010 03:26:23 +0900

UP accessors didn't take care of __percpu notations leading to a lot
of spurious sparse warnings on UP configurations.  Fix it.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
---
Applied to wq#for-next w/ slight commit description and whitespace
updates.

Thanks.

 include/asm-generic/percpu.h |   15 ++++++++++-----
 include/linux/percpu.h       |    2 +-
 2 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/include/asm-generic/percpu.h b/include/asm-generic/percpu.h
index b5043a9..08923b6 100644
--- a/include/asm-generic/percpu.h
+++ b/include/asm-generic/percpu.h
@@ -70,11 +70,16 @@ extern void setup_per_cpu_areas(void);

 #else /* ! SMP */

-#define per_cpu(var, cpu)			(*((void)(cpu), &(var)))
-#define __get_cpu_var(var)			(var)
-#define __raw_get_cpu_var(var)			(var)
-#define this_cpu_ptr(ptr) per_cpu_ptr(ptr, 0)
-#define __this_cpu_ptr(ptr) this_cpu_ptr(ptr)
+#define VERIFY_PERCPU_PTR(__p) ({			\
+	__verify_pcpu_ptr((__p));			\
+	(typeof(*(__p)) __kernel __force *)(__p);	\
+})
+
+#define per_cpu(var, cpu)	(*((void)(cpu), VERIFY_PERCPU_PTR(&(var))))
+#define __get_cpu_var(var)	(*VERIFY_PERCPU_PTR(&(var)))
+#define __raw_get_cpu_var(var)	(*VERIFY_PERCPU_PTR(&(var)))
+#define this_cpu_ptr(ptr)	per_cpu_ptr(ptr, 0)
+#define __this_cpu_ptr(ptr)	this_cpu_ptr(ptr)

 #endif	/* SMP */

diff --git a/include/linux/percpu.h b/include/linux/percpu.h
index b8b9084..49466b1 100644
--- a/include/linux/percpu.h
+++ b/include/linux/percpu.h
@@ -149,7 +149,7 @@ extern void __init percpu_init_late(void);

 #else /* CONFIG_SMP */

-#define per_cpu_ptr(ptr, cpu) ({ (void)(cpu); (ptr); })
+#define per_cpu_ptr(ptr, cpu) ({ (void)(cpu); VERIFY_PERCPU_PTR((ptr)); })

 /* can't distinguish from other static vars, always false */
 static inline bool is_kernel_percpu_address(unsigned long addr)
-- 
1.7.1

