Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756951Ab2D3VEn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 17:04:43 -0400
Received: from www.linutronix.de ([62.245.132.108]:36079 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754769Ab2D3VEl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 17:04:41 -0400
Date: Mon, 30 Apr 2012 23:04:39 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Sam Ravnborg <sam@ravnborg.org>
cc: LKML <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [patch 23/29] sparc: Use generic init_task
In-Reply-To: <alpine.LFD.2.02.1204302239000.6271@ionos>
Message-ID: <alpine.LFD.2.02.1204302303390.6271@ionos>
References: <20120430194725.763322463@linutronix.de> <20120430194846.989528598@linutronix.de> <20120430203538.GA8876@merkur.ravnborg.org> <alpine.LFD.2.02.1204302239000.6271@ionos>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Apr 2012, Thomas Gleixner wrote:
> On Mon, 30 Apr 2012, Sam Ravnborg wrote:
> > This breaks sparc build as it has the following in arch/sparc/Makefile:
> > 
> >     head-y                 += arch/sparc/kernel/init_task.o
> 
> Hrmm, I thought I had catched all of this nonsense.

Updated version below.

Thanks,

	tglx

-------------------->
Subject: sparc: Use generic init_task
From: Thomas Gleixner <tglx@linutronix.de>
Date: Mon, 30 Apr 2012 16:48:55 +0200

Same code. Use the generic version. The special Makefile treatment is
pointless anyway as init_task.o contains only data which is handled by
the linker script. So no point on being treated like head text.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: "David S. Miller" <davem@davemloft.net>
---
 arch/sparc/Kconfig            |    1 +
 arch/sparc/Makefile           |    1 -
 arch/sparc/kernel/Makefile    |    1 -
 arch/sparc/kernel/init_task.c |   22 ----------------------
 4 files changed, 1 insertion(+), 24 deletions(-)

Index: tip/arch/sparc/Kconfig
===================================================================
--- tip.orig/arch/sparc/Kconfig
+++ tip/arch/sparc/Kconfig
@@ -31,6 +31,7 @@ config SPARC
 	select GENERIC_PCI_IOMAP
 	select HAVE_NMI_WATCHDOG if SPARC64
 	select GENERIC_SMP_IDLE_THREAD
+	select HAVE_GENERIC_INIT_TASK
 
 config SPARC32
 	def_bool !64BIT
Index: tip/arch/sparc/Makefile
===================================================================
--- tip.orig/arch/sparc/Makefile
+++ tip/arch/sparc/Makefile
@@ -62,7 +62,6 @@ endif
 endif
 
 head-y                 := arch/sparc/kernel/head_$(BITS).o
-head-y                 += arch/sparc/kernel/init_task.o
 
 core-y                 += arch/sparc/kernel/
 core-y                 += arch/sparc/mm/ arch/sparc/math-emu/
Index: tip/arch/sparc/kernel/Makefile
===================================================================
--- tip.orig/arch/sparc/kernel/Makefile
+++ tip/arch/sparc/kernel/Makefile
@@ -6,7 +6,6 @@ asflags-y := -ansi
 ccflags-y := -Werror
 
 extra-y     := head_$(BITS).o
-extra-y     += init_task.o
 
 # Undefine sparc when processing vmlinux.lds - it is used
 # And teach CPP we are doing $(BITS) builds (for this case)
Index: tip/arch/sparc/kernel/init_task.c
===================================================================
--- tip.orig/arch/sparc/kernel/init_task.c
+++ /dev/null
@@ -1,22 +0,0 @@
-#include <linux/mm.h>
-#include <linux/fs.h>
-#include <linux/module.h>
-#include <linux/sched.h>
-#include <linux/init_task.h>
-#include <linux/mqueue.h>
-
-#include <asm/pgtable.h>
-#include <asm/uaccess.h>
-
-static struct signal_struct init_signals = INIT_SIGNALS(init_signals);
-static struct sighand_struct init_sighand = INIT_SIGHAND(init_sighand);
-struct task_struct init_task = INIT_TASK(init_task);
-EXPORT_SYMBOL(init_task);
-
-/* .text section in head.S is aligned at 8k boundary and this gets linked
- * right after that so that the init_thread_union is aligned properly as well.
- * If this is not aligned on a 8k boundary, then you should change code
- * in etrap.S which assumes it.
- */
-union thread_union init_thread_union __init_task_data =
-	{ INIT_THREAD_INFO(init_task) };
