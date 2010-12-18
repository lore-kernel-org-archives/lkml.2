Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756410Ab0LRPZr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Dec 2010 10:25:47 -0500
Received: from mail-bw0-f45.google.com ([209.85.214.45]:62457 "EHLO
	mail-bw0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752327Ab0LRPY3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Dec 2010 10:24:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=Q347hLJnr1XF93szL15arTnRZ/wBs1z+egMJqt2lSvia8RdJbm7ClVdsY9ZxNd66hL
         On/TraljNc4omLiL7RAK893xpNx5AtaXdxzo/4K9VkfGQ89pcgzudGs4Mw9ofqGw5W9b
         XUorMxwQ6R5y0qunrzcDu6mgu7mRurZ7S1c2g=
From: Tejun Heo <tj@kernel.org>
To: penberg@cs.helsinki.fi, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, eric.dumazet@gmail.com, hpa@zytor.com,
        mathieu.desnoyers@efficios.com
Cc: Christoph Lameter <cl@linux.com>, Tejun Heo <tj@kernel.org>
Subject: [PATCH 1/6] percpu: Generic support for this_cpu_add, sub, dec, inc_return
Date: Sat, 18 Dec 2010 16:24:07 +0100
Message-Id: <1292685852-12469-2-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1292685852-12469-1-git-send-email-tj@kernel.org>
References: <1292685852-12469-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christoph Lameter <cl@linux.com>

Introduce generic support for this_cpu_add_return etc.

The fallback is to realize these operations with simpler __this_cpu_ops.

tj: - Reformatted __cpu_size_call_return2() to make it more consistent
      with its neighbors.
    - Dropped unnecessary temp variable ret__ from
      __this_cpu_generic_add_return().

Reviewed-by: Tejun Heo <tj@kernel.org>
Reviewed-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Acked-by: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: Christoph Lameter <cl@linux.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
---
 include/linux/percpu.h |   71 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 71 insertions(+), 0 deletions(-)

diff --git a/include/linux/percpu.h b/include/linux/percpu.h
index 5095b83..4d593de 100644
--- a/include/linux/percpu.h
+++ b/include/linux/percpu.h
@@ -240,6 +240,21 @@ extern void __bad_size_call_parameter(void);
 	pscr_ret__;							\
 })
 
+#define __pcpu_size_call_return2(stem, variable, ...)			\
+({									\
+	typeof(variable) pscr2_ret__;					\
+	__verify_pcpu_ptr(&(variable));					\
+	switch(sizeof(variable)) {					\
+	case 1: pscr2_ret__ = stem##1(variable, __VA_ARGS__); break;	\
+	case 2: pscr2_ret__ = stem##2(variable, __VA_ARGS__); break;	\
+	case 4: pscr2_ret__ = stem##4(variable, __VA_ARGS__); break;	\
+	case 8: pscr2_ret__ = stem##8(variable, __VA_ARGS__); break;	\
+	default:							\
+		__bad_size_call_parameter(); break;			\
+	}								\
+	pscr2_ret__;							\
+})
+
 #define __pcpu_size_call(stem, variable, ...)				\
 do {									\
 	__verify_pcpu_ptr(&(variable));					\
@@ -529,6 +544,62 @@ do {									\
 # define __this_cpu_xor(pcp, val)	__pcpu_size_call(__this_cpu_xor_, (pcp), (val))
 #endif
 
+#define _this_cpu_generic_add_return(pcp, val)				\
+({									\
+	typeof(pcp) ret__;						\
+	preempt_disable();						\
+	__this_cpu_add(pcp, val);					\
+	ret__ = __this_cpu_read(pcp);					\
+	preempt_enable();						\
+	ret__;								\
+})
+
+#ifndef this_cpu_add_return
+# ifndef this_cpu_add_return_1
+#  define this_cpu_add_return_1(pcp, val)	_this_cpu_generic_add_return(pcp, val)
+# endif
+# ifndef this_cpu_add_return_2
+#  define this_cpu_add_return_2(pcp, val)	_this_cpu_generic_add_return(pcp, val)
+# endif
+# ifndef this_cpu_add_return_4
+#  define this_cpu_add_return_4(pcp, val)	_this_cpu_generic_add_return(pcp, val)
+# endif
+# ifndef this_cpu_add_return_8
+#  define this_cpu_add_return_8(pcp, val)	_this_cpu_generic_add_return(pcp, val)
+# endif
+# define this_cpu_add_return(pcp, val)	__pcpu_size_call_return2(this_cpu_add_return_, pcp, val)
+#endif
+
+#define this_cpu_sub_return(pcp, val)	this_cpu_add_return(pcp, -(val))
+#define this_cpu_inc_return(pcp)	this_cpu_add_return(pcp, 1)
+#define this_cpu_dec_return(pcp)	this_cpu_add_return(pcp, -1)
+
+#define __this_cpu_generic_add_return(pcp, val)				\
+({									\
+	__this_cpu_add(pcp, val);					\
+	__this_cpu_read(pcp);						\
+})
+
+#ifndef __this_cpu_add_return
+# ifndef __this_cpu_add_return_1
+#  define __this_cpu_add_return_1(pcp, val)	__this_cpu_generic_add_return(pcp, val)
+# endif
+# ifndef __this_cpu_add_return_2
+#  define __this_cpu_add_return_2(pcp, val)	__this_cpu_generic_add_return(pcp, val)
+# endif
+# ifndef __this_cpu_add_return_4
+#  define __this_cpu_add_return_4(pcp, val)	__this_cpu_generic_add_return(pcp, val)
+# endif
+# ifndef __this_cpu_add_return_8
+#  define __this_cpu_add_return_8(pcp, val)	__this_cpu_generic_add_return(pcp, val)
+# endif
+# define __this_cpu_add_return(pcp, val)	__pcpu_size_call_return2(this_cpu_add_return_, pcp, val)
+#endif
+
+#define __this_cpu_sub_return(pcp, val)	this_cpu_add_return(pcp, -(val))
+#define __this_cpu_inc_return(pcp)	this_cpu_add_return(pcp, 1)
+#define __this_cpu_dec_return(pcp)	this_cpu_add_return(pcp, -1)
+
 /*
  * IRQ safe versions of the per cpu RMW operations. Note that these operations
  * are *not* safe against modification of the same variable from another
-- 
1.7.1

