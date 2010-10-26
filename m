Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933163Ab0JZMp6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 08:45:58 -0400
Received: from hera.kernel.org ([140.211.167.34]:58428 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932481Ab0JZMp4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 08:45:56 -0400
Message-ID: <4CC6CD4D.3010501@kernel.org>
Date: Tue, 26 Oct 2010 14:45:01 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.11) Gecko/20101013 Lightning/1.0b2 Thunderbird/3.1.5
MIME-Version: 1.0
To: torvalds@osdl.org, Alexander van Heukelum <heukelum@fastmail.fm>
CC: David Howells <dhowells@redhat.com>, akpm@linux-foundation.org,
        linux-am33-list@redhat.com, linux-kernel@vger.kernel.org,
        Akira Takeuchi <takeuchi.akr@jp.panasonic.com>,
        Mark Salter <msalter@redhat.com>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH] x86, percpu: revert commit fe8e0c25
References: <4CC69B22.2050708@kernel.org> <20101025224111.7798.38960.stgit@warthog.procyon.org.uk> <12101.1288088542@redhat.com> <4CC6C62F.1000804@kernel.org> <4CC6C941.2080003@kernel.org>
In-Reply-To: <4CC6C941.2080003@kernel.org>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 26 Oct 2010 12:45:04 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit fe8e0c25 (x86, 32-bit: Align percpu area and irq stacks to
THREAD_SIZE) aligned PERCPU section to THREAD_SIZE which can be larger
than PAGE_SIZE, introduced DEFINE_PER_CPU_MULTIPAGE_ALIGNED() and used
it to make irq stacks aligned to THREAD_SIZE on x86_32.

This won't work.  The PERCPU output section is used as the template to
prepare the percpu area and the actual percpu area is _alwasy_ aligned
to PAGE_SIZE whether the source area is aligned to larger size or not.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Alexander van Heukelum <heukelum@fastmail.fm>
Cc: Ingo Molnar <mingo@elte.hu>
---
Sorry about not catching this earlier.  If x86_32 irq stacks need
percpu areas with larger alignment, it needs to implement it itself by
either explicitly allocating more space for padding or allocating
stack area manually for each CPU.  I don't think it is justifiable to
make generic percpu allocator honor alignments larger than PAGE_SIZE
for this case.

Thanks.

 arch/x86/kernel/irq_32.c      |    4 ++--
 arch/x86/kernel/vmlinux.lds.S |    2 +-
 include/linux/percpu-defs.h   |   12 ------------
 3 files changed, 3 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kernel/irq_32.c b/arch/x86/kernel/irq_32.c
index 50fbbe6..3b5609f 100644
--- a/arch/x86/kernel/irq_32.c
+++ b/arch/x86/kernel/irq_32.c
@@ -60,8 +60,8 @@ union irq_ctx {
 static DEFINE_PER_CPU(union irq_ctx *, hardirq_ctx);
 static DEFINE_PER_CPU(union irq_ctx *, softirq_ctx);

-static DEFINE_PER_CPU_MULTIPAGE_ALIGNED(union irq_ctx, hardirq_stack, THREAD_SIZE);
-static DEFINE_PER_CPU_MULTIPAGE_ALIGNED(union irq_ctx, softirq_stack, THREAD_SIZE);
+static DEFINE_PER_CPU_PAGE_ALIGNED(union irq_ctx, hardirq_stack);
+static DEFINE_PER_CPU_PAGE_ALIGNED(union irq_ctx, softirq_stack);

 static void call_on_stack(void *func, void *stack)
 {
diff --git a/arch/x86/kernel/vmlinux.lds.S b/arch/x86/kernel/vmlinux.lds.S
index e03530a..38e2b67 100644
--- a/arch/x86/kernel/vmlinux.lds.S
+++ b/arch/x86/kernel/vmlinux.lds.S
@@ -301,7 +301,7 @@ SECTIONS
 	}

 #if !defined(CONFIG_X86_64) || !defined(CONFIG_SMP)
-	PERCPU(THREAD_SIZE)
+	PERCPU(PAGE_SIZE)
 #endif

 	. = ALIGN(PAGE_SIZE);
diff --git a/include/linux/percpu-defs.h b/include/linux/percpu-defs.h
index 018db9a..27ef6b1 100644
--- a/include/linux/percpu-defs.h
+++ b/include/linux/percpu-defs.h
@@ -148,18 +148,6 @@
 	DEFINE_PER_CPU_SECTION(type, name, "..readmostly")

 /*
- * Declaration/definition used for large per-CPU variables that must be
- * aligned to something larger than the pagesize.
- */
-#define DECLARE_PER_CPU_MULTIPAGE_ALIGNED(type, name, size)		\
-	DECLARE_PER_CPU_SECTION(type, name, "..page_aligned")		\
-	__aligned(size)
-
-#define DEFINE_PER_CPU_MULTIPAGE_ALIGNED(type, name, size)		\
-	DEFINE_PER_CPU_SECTION(type, name, "..page_aligned")		\
-	__aligned(size)
-
-/*
  * Intermodule exports for per-CPU variables.  sparse forgets about
  * address space across EXPORT_SYMBOL(), change EXPORT_SYMBOL() to
  * noop if __CHECKER__.
