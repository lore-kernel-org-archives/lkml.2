Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756158Ab0JNVLn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 17:11:43 -0400
Received: from casper.infradead.org ([85.118.1.10]:44595 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755927Ab0JNVKU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 17:10:20 -0400
Message-Id: <20101014203625.501657727@chello.nl>
User-Agent: quilt/0.47-1
Date: Thu, 14 Oct 2010 22:34:09 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
        Jason Baron <jbaron@redhat.com>
Cc: linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>,
        Mike Galbraith <efault@gmx.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [RFC][PATCH 5/7] jump_label: atomic_t interface
References: <20101014203404.222133139@chello.nl>
Content-Disposition: inline; filename=jump_label_ref.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add an interface to allow usage of jump_labels with atomic counters

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/jump_label_ref.h |   44 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 44 insertions(+)

Index: linux-2.6/include/linux/jump_label_ref.h
===================================================================
--- /dev/null
+++ linux-2.6/include/linux/jump_label_ref.h
@@ -0,0 +1,44 @@
+#ifndef _LINUX_JUMP_LABEL_REF_H
+#define _LINUX_JUMP_LABEL_REF_H
+
+#include <linux/jump_label.h>
+#include <asm/atomic.h>
+
+#ifdef HAVE_JUMP_LABEL
+
+static inline void jump_label_inc(atomic_t *key)
+{
+	if (atomic_add_return(1, key) == 1)
+		jump_label_enable(key);
+}
+
+static inline void jump_label_dec(atomic_t *key)
+{
+	if (atomic_dec_and_test(key))
+		jump_label_disable(key);
+}
+
+#else /* !HAVE_JUMP_LABEL */
+
+static inline void jump_label_inc(atomic_t *key)
+{
+	atomic_inc(key);
+}
+
+static inline void jump_label_dec(atomic_t *key)
+{
+	atomic_dec(key);
+}
+
+#undef JUMP_LABEL
+#define JUMP_LABEL(key, label)						\
+do {									\
+	if (unlikely(__builtin_choose_expr(				\
+	      __builtin_types_compatible_p(typeof(key), atomic_t *),	\
+	      atomic_read((atomic_t *)(key)), *(key))))			\
+		goto label;						\
+} while (0)
+
+#endif /* HAVE_JUMP_LABEL */
+
+#endif /* _LINUX_JUMP_LABEL_REF_H */


