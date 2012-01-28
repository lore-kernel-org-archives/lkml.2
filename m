Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752824Ab2A1MFh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jan 2012 07:05:37 -0500
Received: from terminus.zytor.com ([198.137.202.10]:56490 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752406Ab2A1MFg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jan 2012 07:05:36 -0500
Date: Sat, 28 Jan 2012 04:05:19 -0800
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Message-ID: <tip-h02wu6kabpoojxf03wke704k@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        akpm@linux-foundation.org, a.p.zijlstra@chello.nl, jbaron@redhat.com,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, akpm@linux-foundation.org, tglx@linutronix.de,
        jbaron@redhat.com, mingo@elte.hu
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] jump_label: Add some documentation
Git-Commit-ID: efb3040d481a1594592b1defb4526c406c7a4751
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Sat, 28 Jan 2012 04:05:25 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  efb3040d481a1594592b1defb4526c406c7a4751
Gitweb:     http://git.kernel.org/tip/efb3040d481a1594592b1defb4526c406c7a4751
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Thu, 26 Jan 2012 13:32:15 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 27 Jan 2012 12:14:46 +0100

jump_label: Add some documentation

akpm figured we could do with a blub explaining what static_branch()
is and why it lives...

Grumpily-requested-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Jason Baron <jbaron@redhat.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/n/tip-h02wu6kabpoojxf03wke704k@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/jump_label.h |   32 ++++++++++++++++++++++++++++++++
 1 files changed, 32 insertions(+), 0 deletions(-)

diff --git a/include/linux/jump_label.h b/include/linux/jump_label.h
index 5ce8b14..f7c6958 100644
--- a/include/linux/jump_label.h
+++ b/include/linux/jump_label.h
@@ -1,6 +1,38 @@
 #ifndef _LINUX_JUMP_LABEL_H
 #define _LINUX_JUMP_LABEL_H
 
+/*
+ * Jump label support
+ *
+ * Copyright (C) 2009-2012 Jason Baron <jbaron@redhat.com>
+ * Copyright (C) 2011-2012 Peter Zijlstra <pzijlstr@redhat.com>
+ *
+ * Jump labels provide an interface to generate dynamic branches using
+ * self-modifying code. Assuming toolchain and architecture support the result
+ * of a "if (static_branch(&key))" statement is a unconditional branch (which
+ * defaults to false - and the true block is placed out of line).
+ *
+ * However at runtime we can change the 'static' branch target using
+ * jump_label_{inc,dec}(). These function as a 'reference' count on the key
+ * object and for as long as there are references all branches referring to
+ * that particular key will point to the (out of line) true block.
+ *
+ * Since this relies on modifying code the jump_label_{inc,dec}() functions
+ * must be considered absolute slow paths (machine wide synchronization etc.).
+ * OTOH, since the affected branches are unconditional their runtime overhead
+ * will be absolutely minimal, esp. in the default (off) case where the total
+ * effect is a single NOP of appropriate size. The on case will patch in a jump
+ * to the out-of-line block.
+ *
+ * When the control is directly exposed to userspace it is prudent to delay the
+ * decrement to avoid high frequency code modifications which can (and do)
+ * cause significant performance degradation. Struct jump_label_key_deferred and
+ * jump_label_dec_deferred() provide for this.
+ *
+ * Lacking toolchain and or architecture support, it falls back to a simple
+ * conditional branch.
+ */
+
 #include <linux/types.h>
 #include <linux/compiler.h>
 #include <linux/workqueue.h>
