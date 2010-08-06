Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761796Ab0HFS1L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 14:27:11 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:53928 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761781Ab0HFS1F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 14:27:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=D7ALu3UptCP+9YYB/iQPanx4AwlQjPr2gb8YvhwwsrNXILAlR5GcM6NaBuwJPcCbPm
         stK6PwW3gCmWydRZeqn4VSLGr0uOBbp/JxKlaG9FGYKjrL2MNbcynR38uK0DPxL6Gtku
         wYfsAMiKfcYdXnSmvuKQ5SvFR5h7NRNzjjeI8=
From: Namhyung Kim <namhyung@gmail.com>
To: tj@kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/5] percpu: add sanity check for UP
Date: Sat,  7 Aug 2010 03:26:23 +0900
Message-Id: <1281119187-12640-1-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

add sanity check for percpu accessors on UP.
This removes lots of sparse warnings.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 include/asm-generic/percpu.h |   12 +++++++++---
 include/linux/percpu.h       |    2 +-
 2 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/include/asm-generic/percpu.h b/include/asm-generic/percpu.h
index b5043a9..50ac3ac 100644
--- a/include/asm-generic/percpu.h
+++ b/include/asm-generic/percpu.h
@@ -70,9 +70,15 @@ extern void setup_per_cpu_areas(void);
 
 #else /* ! SMP */
 
-#define per_cpu(var, cpu)			(*((void)(cpu), &(var)))
-#define __get_cpu_var(var)			(var)
-#define __raw_get_cpu_var(var)			(var)
+#define VERIFY_PERCPU_PTR(__p) ({			\
+	__verify_pcpu_ptr((__p));			\
+	(typeof(*(__p)) __kernel __force *) (__p);	\
+})
+
+#define per_cpu(var, cpu) \
+	(*((void)(cpu), VERIFY_PERCPU_PTR(&(var))))
+#define __get_cpu_var(var)		(*VERIFY_PERCPU_PTR(&(var)))
+#define __raw_get_cpu_var(var)		(*VERIFY_PERCPU_PTR(&(var)))
 #define this_cpu_ptr(ptr) per_cpu_ptr(ptr, 0)
 #define __this_cpu_ptr(ptr) this_cpu_ptr(ptr)
 
diff --git a/include/linux/percpu.h b/include/linux/percpu.h
index d3a38d6..bc36301 100644
--- a/include/linux/percpu.h
+++ b/include/linux/percpu.h
@@ -143,7 +143,7 @@ extern void __init setup_per_cpu_areas(void);
 
 #else /* CONFIG_SMP */
 
-#define per_cpu_ptr(ptr, cpu) ({ (void)(cpu); (ptr); })
+#define per_cpu_ptr(ptr, cpu) ({ (void)(cpu); VERIFY_PERCPU_PTR((ptr)); })
 
 /* can't distinguish from other static vars, always false */
 static inline bool is_kernel_percpu_address(unsigned long addr)
-- 
1.7.0.4

