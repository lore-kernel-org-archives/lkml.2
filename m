Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755356Ab0FALHY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 07:07:24 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:64082 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753411Ab0FALHW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 07:07:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=to:cc:from:subject:date:message-id:user-agent:mime-version
         :content-type:content-transfer-encoding;
        b=qR8Yakfc8Id4AmES1l92zSscmB7qOfEiZD2oBhcBPMmy7+FYTct0T3L/joWzPC42Yz
         mr/TrzW4/8/RbsGXWqxnpYmm0XgUjzSh05zRdoMQJVIb5nlHBpFu0PdIziq/7K5vgV6B
         m6ld7AZfQihcS/7ARlTQjpz6GgedkmQSBuREw=
To: linux-kernel@vger.kernel.org
From: Maxim Uvarov <muvarov@gmail.com>
Subject: [PATCH] Kernel panic buffer (or printk on system crash)
Date: Tue, 01 Jun 2010 15:06:42 +0400
Message-ID: <20100601110642.20699.73338.stgit@muvarov>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Maxim Uvarov <muvarov@gmail.com>

Hello everybody,
	These days I was in debugging FS code and made this
	small debugging tool for my needs. It works like cycle buffer
	for printk and prints after die() or panic(). Probably it
	would be useful to someone else.

Signed-off-by: Maxim Uvarov <muvarov@gmail.com>
---

 arch/x86/kernel/dumpstack.c |    4 ++++
 include/linux/pbuffer.h     |    6 ++++++
 kernel/panic.c              |    4 ++++
 lib/Kconfig.debug           |   21 ++++++++++++++++++++
 lib/Makefile                |    1 +
 lib/pbuffer.c               |   45 +++++++++++++++++++++++++++++++++++++++++++
 6 files changed, 81 insertions(+), 0 deletions(-)
 create mode 100644 include/linux/pbuffer.h
 create mode 100644 lib/pbuffer.c

diff --git a/arch/x86/kernel/dumpstack.c b/arch/x86/kernel/dumpstack.c
index c89a386..313b2ba 100644
--- a/arch/x86/kernel/dumpstack.c
+++ b/arch/x86/kernel/dumpstack.c
@@ -15,6 +15,7 @@
 #include <linux/bug.h>
 #include <linux/nmi.h>
 #include <linux/sysfs.h>
+#include <linux/pbuffer.h>
 
 #include <asm/stacktrace.h>
 
@@ -272,6 +273,9 @@ int __kprobes __die(const char *str, struct pt_regs *regs, long err)
 	unsigned short ss;
 	unsigned long sp;
 #endif
+#ifdef CONFIG_DEBUG_PBUFFER
+	pbuf_print_panic();
+#endif
 	printk(KERN_EMERG "%s: %04lx [#%d] ", str, err & 0xffff, ++die_counter);
 #ifdef CONFIG_PREEMPT
 	printk("PREEMPT ");
diff --git a/include/linux/pbuffer.h b/include/linux/pbuffer.h
new file mode 100644
index 0000000..47b2c4e
--- /dev/null
+++ b/include/linux/pbuffer.h
@@ -0,0 +1,6 @@
+asmlinkage void pbuf_add(const char *fmt, ...)
+	__attribute__ ((format (printf, 1, 2)));
+void pbuf_print_panic(void);
+
+#define PBUF_FLINE pbuf_add("%s():%d\n", __func__, __LINE__);
+
diff --git a/kernel/panic.c b/kernel/panic.c
index 3b16cd9..42c25cb 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -23,6 +23,7 @@
 #include <linux/init.h>
 #include <linux/nmi.h>
 #include <linux/dmi.h>
+#include <linux/pbuffer.h>
 
 int panic_on_oops;
 static unsigned long tainted_mask;
@@ -93,6 +94,9 @@ NORET_TYPE void panic(const char * fmt, ...)
 	vsnprintf(buf, sizeof(buf), fmt, args);
 	va_end(args);
 	printk(KERN_EMERG "Kernel panic - not syncing: %s\n",buf);
+#ifdef CONFIG_DEBUG_PBUFFER
+	pbuf_print_panic();
+#endif
 #ifdef CONFIG_DEBUG_BUGVERBOSE
 	dump_stack();
 #endif
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index e722e9d..9f65397 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -1122,3 +1122,24 @@ source "samples/Kconfig"
 source "lib/Kconfig.kgdb"
 
 source "lib/Kconfig.kmemcheck"
+
+config DEBUG_PBUFFER
+	bool "Enable panic buffer"
+	depends on DEBUG_KERNEL && EXPERIMENTAL
+	help
+	 Special buffer is used to be printed after system panic. It's useful
+	 for debugging complex functions which have a lot of inlines and cycles
+	 and recursions. I.e. where usage printk is not effective. It works
+	 like printk but prints buffer only after kernel panic.
+	 pbuf_add() - function with printk interface used to add messages to
+	 panic buffer. For example you can use the following macro:
+	 #define PBUF_FLINE pbuf_add("%s():%d\n", __FUNCTION__, __LINE__);
+
+config DEBUG_PBUFFER_NLINES
+	int "Number of pbuffer lines"
+	depends on DEBUG_PBUFFER
+	range 0 1024
+	default 10
+	help
+	 Number of lines to be printed after panic.
+
diff --git a/lib/Makefile b/lib/Makefile
index 3f1062c..2d4be91 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -48,6 +48,7 @@ obj-$(CONFIG_BTREE) += btree.o
 obj-$(CONFIG_DEBUG_PREEMPT) += smp_processor_id.o
 obj-$(CONFIG_DEBUG_LIST) += list_debug.o
 obj-$(CONFIG_DEBUG_OBJECTS) += debugobjects.o
+obj-$(CONFIG_DEBUG_PBUFFER) += pbuffer.o
 
 ifneq ($(CONFIG_HAVE_DEC_LOCK),y)
   lib-y += dec_and_lock.o
diff --git a/lib/pbuffer.c b/lib/pbuffer.c
new file mode 100644
index 0000000..a981e57
--- /dev/null
+++ b/lib/pbuffer.c
@@ -0,0 +1,45 @@
+#include <linux/kernel.h>
+#include <linux/string.h>
+#include <linux/spinlock.h>
+#include <linux/pbuffer.h>
+
+#define PBUFLINES CONFIG_DEBUG_PBUFFER_NLINES
+static char pbuffer[PBUFLINES][256];
+static int pos;
+static DEFINE_SPINLOCK(pbuf_lock);
+static int stop;
+
+asmlinkage void pbuf_add(const char *fmt, ...)
+{
+	va_list args;
+
+	spin_lock(&pbuf_lock);
+	if (stop)
+		goto out;
+	pos++;
+	if (pos >= PBUFLINES)
+		pos = 0;
+
+	va_start(args, fmt);
+	vsnprintf(&pbuffer[pos][0], 256, fmt, args);
+	va_end(args);
+out:
+	spin_unlock(&pbuf_lock);
+}
+
+void pbuf_print_panic()
+{
+	int i;
+	int num = PBUFLINES;
+
+	printk(KERN_EMERG "Panic buffer:\n");
+	spin_lock(&pbuf_lock);
+	stop = 1;
+	for (i = pos; i >= 0; i--, num--)
+		printk(KERN_EMERG "PB%03d: %s", num, &pbuffer[i][0]);
+
+	for (i = (PBUFLINES - 1); i > pos; i--, num--)
+		printk(KERN_EMERG "PB%03d: %s", num, &pbuffer[i][0]);
+	spin_unlock(&pbuf_lock);
+
+}


Best regards,
Maxim Uvarov.


