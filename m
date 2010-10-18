Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933075Ab0JRTVt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 15:21:49 -0400
Received: from hera.kernel.org ([140.211.167.34]:35099 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756831Ab0JRTVs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 15:21:48 -0400
Date: Mon, 18 Oct 2010 19:21:26 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        fweisbec@gmail.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <20101014203625.501657727@chello.nl>
References: <20101014203625.501657727@chello.nl>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] jump_label: Add atomic_t interface
Message-ID: <tip-8b92538d84e50062560ba33adbaed7887b6e4a42@git.kernel.org>
Git-Commit-ID: 8b92538d84e50062560ba33adbaed7887b6e4a42
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 18 Oct 2010 19:21:27 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8b92538d84e50062560ba33adbaed7887b6e4a42
Gitweb:     http://git.kernel.org/tip/8b92538d84e50062560ba33adbaed7887b6e4a42
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Thu, 14 Oct 2010 21:39:02 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 18 Oct 2010 19:58:57 +0200

jump_label: Add atomic_t interface

Add an interface to allow usage of jump_labels with atomic counters.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <20101014203625.501657727@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/jump_label_ref.h |   44 ++++++++++++++++++++++++++++++++++++++++
 1 files changed, 44 insertions(+), 0 deletions(-)

diff --git a/include/linux/jump_label_ref.h b/include/linux/jump_label_ref.h
new file mode 100644
index 0000000..e5d012a
--- /dev/null
+++ b/include/linux/jump_label_ref.h
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
