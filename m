Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756431Ab0IGLll (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 07:41:41 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:54544 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756492Ab0IGLlc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 07:41:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=rgCYaYGi0awRNIDvi744/GVVat29pF9RIO3f0Fz35OvM5SU8oNpO1nSVpC+WOLmtrR
         kK0KaRTbjAqxtsqeYoS0b/0pLOiQk8fMmsSEVOvai5hp5ThLNANeJIyP5/aL6o1Oe/xD
         N78WYPQzRitNLb4HA/awoceE/2pimVYYP+8/U=
From: Brian Gerst <brgerst@gmail.com>
To: tj@kernel.org
Cc: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] percpu: Optimize __get_cpu_var()
Date: Tue,  7 Sep 2010 07:41:10 -0400
Message-Id: <1283859670-6687-3-git-send-email-brgerst@gmail.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <1283859670-6687-1-git-send-email-brgerst@gmail.com>
References: <1283859670-6687-1-git-send-email-brgerst@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Redefine __get_cpu_var() using this_cpu_ptr() which can be
arch-optimized.

Signed-off-by: Brian Gerst <brgerst@gmail.com>
---
 include/asm-generic/percpu.h |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/include/asm-generic/percpu.h b/include/asm-generic/percpu.h
index 5820fcb..c6e2c2d 100644
--- a/include/asm-generic/percpu.h
+++ b/include/asm-generic/percpu.h
@@ -55,10 +55,6 @@ extern unsigned long __per_cpu_offset[NR_CPUS];
  */
 #define per_cpu(var, cpu) \
 	(*SHIFT_PERCPU_PTR(&(var), per_cpu_offset(cpu)))
-#define __get_cpu_var(var) \
-	(*SHIFT_PERCPU_PTR(&(var), my_cpu_offset))
-#define __raw_get_cpu_var(var) \
-	(*SHIFT_PERCPU_PTR(&(var), __my_cpu_offset))
 
 #ifndef __this_cpu_ptr
 #define __this_cpu_ptr(ptr) SHIFT_PERCPU_PTR(ptr, __my_cpu_offset)
@@ -69,6 +65,9 @@ extern unsigned long __per_cpu_offset[NR_CPUS];
 #define this_cpu_ptr(ptr) __this_cpu_ptr(ptr)
 #endif
 
+#define __get_cpu_var(var) (*this_cpu_ptr(&(var)))
+#define __raw_get_cpu_var(var) (*__this_cpu_ptr(&(var)))
+
 #ifdef CONFIG_HAVE_SETUP_PER_CPU_AREA
 extern void setup_per_cpu_areas(void);
 #endif
-- 
1.7.2.2

