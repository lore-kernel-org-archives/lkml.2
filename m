Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750988Ab0IGEH2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 00:07:28 -0400
Received: from hera.kernel.org ([140.211.167.34]:60370 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750738Ab0IGEHZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 00:07:25 -0400
Date: Tue, 7 Sep 2010 04:06:58 GMT
From: tip-bot for Alexander van Heukelum <heukelum@fastmail.fm>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        tj@kernel.org, heukelum@fastmail.fm, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        heukelum@fastmail.fm, tj@kernel.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1283799222.15941.1393621887@webmail.messagingengine.com>
References: <1283799222.15941.1393621887@webmail.messagingengine.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/irq] x86, 32-bit: Align percpu area and irq stacks to THREAD_SIZE
Message-ID: <tip-fe8e0c25cad28e8858ecfa5863333c70685a6811@git.kernel.org>
Git-Commit-ID: fe8e0c25cad28e8858ecfa5863333c70685a6811
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 07 Sep 2010 04:06:59 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  fe8e0c25cad28e8858ecfa5863333c70685a6811
Gitweb:     http://git.kernel.org/tip/fe8e0c25cad28e8858ecfa5863333c70685a6811
Author:     Alexander van Heukelum <heukelum@fastmail.fm>
AuthorDate: Mon, 6 Sep 2010 20:53:42 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 7 Sep 2010 05:07:00 +0200

x86, 32-bit: Align percpu area and irq stacks to THREAD_SIZE

The irq stacks, located in the percpu-area, need to be
THREAD_SIZE aligned. Add the infrastucture to align percpu
variables to larger-than-pagesize amounts within the percpu
area, and use it to specify the alignment for the irq stacks.
Also align the percpu area itself to THREAD_SIZE.

This should make irq stacks work with 8K THREAD_SIZE.

Signed-off-by: Alexander van Heukelum <heukelum@fastmail.fm>
Cc: Tejun Heo <tj@kernel.org>
Cc: hch@lst.de
LKML-Reference: <1283799222.15941.1393621887@webmail.messagingengine.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/irq_32.c      |    4 ++--
 arch/x86/kernel/vmlinux.lds.S |    2 +-
 include/linux/percpu-defs.h   |   12 ++++++++++++
 3 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/irq_32.c b/arch/x86/kernel/irq_32.c
index 3b5609f..50fbbe6 100644
--- a/arch/x86/kernel/irq_32.c
+++ b/arch/x86/kernel/irq_32.c
@@ -60,8 +60,8 @@ union irq_ctx {
 static DEFINE_PER_CPU(union irq_ctx *, hardirq_ctx);
 static DEFINE_PER_CPU(union irq_ctx *, softirq_ctx);
 
-static DEFINE_PER_CPU_PAGE_ALIGNED(union irq_ctx, hardirq_stack);
-static DEFINE_PER_CPU_PAGE_ALIGNED(union irq_ctx, softirq_stack);
+static DEFINE_PER_CPU_MULTIPAGE_ALIGNED(union irq_ctx, hardirq_stack, THREAD_SIZE);
+static DEFINE_PER_CPU_MULTIPAGE_ALIGNED(union irq_ctx, softirq_stack, THREAD_SIZE);
 
 static void call_on_stack(void *func, void *stack)
 {
diff --git a/arch/x86/kernel/vmlinux.lds.S b/arch/x86/kernel/vmlinux.lds.S
index d0bb522..bb89947 100644
--- a/arch/x86/kernel/vmlinux.lds.S
+++ b/arch/x86/kernel/vmlinux.lds.S
@@ -273,7 +273,7 @@ SECTIONS
 	}
 
 #if !defined(CONFIG_X86_64) || !defined(CONFIG_SMP)
-	PERCPU(PAGE_SIZE)
+	PERCPU(THREAD_SIZE)
 #endif
 
 	. = ALIGN(PAGE_SIZE);
diff --git a/include/linux/percpu-defs.h b/include/linux/percpu-defs.h
index ce2dc65..ab20d11 100644
--- a/include/linux/percpu-defs.h
+++ b/include/linux/percpu-defs.h
@@ -139,6 +139,18 @@
 	__aligned(PAGE_SIZE)
 
 /*
+ * Declaration/definition used for large per-CPU variables that must be
+ * aligned to something larger than the pagesize.
+ */
+#define DECLARE_PER_CPU_MULTIPAGE_ALIGNED(type, name, size)		\
+	DECLARE_PER_CPU_SECTION(type, name, "..page_aligned")		\
+	__aligned(size)
+
+#define DEFINE_PER_CPU_MULTIPAGE_ALIGNED(type, name, size)		\
+	DEFINE_PER_CPU_SECTION(type, name, "..page_aligned")		\
+	__aligned(size)
+
+/*
  * Intermodule exports for per-CPU variables.  sparse forgets about
  * address space across EXPORT_SYMBOL(), change EXPORT_SYMBOL() to
  * noop if __CHECKER__.
