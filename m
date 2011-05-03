Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754630Ab1ECTIL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 15:08:11 -0400
Received: from mo-p00-ob.rzone.de ([81.169.146.162]:54932 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754317Ab1ECTIK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 15:08:10 -0400
X-RZG-AUTH: :P2EQZWCpfu+qG7CngxMFH1J+zrwiavkK6tmQaLfmwtM48/lq0M7oFPE=
X-RZG-CLASS-ID: mo00
Date: Tue, 3 May 2011 21:08:06 +0200
From: Olaf Hering <olaf@aepfle.de>
To: linux-kernel@vger.kernel.org, kexec@lists.infradead.org
Cc: akpm@linux-foundation.org
Subject: [PATCH] add hook to read_from_oldmem() to check for non-ram pages
Message-ID: <20110503190806.GA12485@aepfle.de>
References: <20110407095646.GA30788@aepfle.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20110407095646.GA30788@aepfle.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The balloon driver in a Xen guest frees guest pages and marks them as
mmio. When the kernel crashes and the crash kernel attempts to read the
oldmem via /proc/vmcore a read from ballooned pages will generate 100%
load in dom0 because Xen asks qemu-dm for the page content. Since the
reads come in as 8byte requests each ballooned page is tried 512 times.

With this change a hook can be registered which checks wether the given
pfn is really ram. The hook has to return a value > 0 for ram pages, a
value < 0 on error (because the hypercall is not known) and 0 for
non-ram pages.

This will reduce the time to read /proc/vmcore.  Without this change a
512M guest with 128M crashkernel region needs 200 seconds to read it,
with this change it takes just 2 seconds.


Signed-off-by: Olaf Hering <olaf@aepfle.de>

---
 fs/proc/vmcore.c           |   50 ++++++++++++++++++++++++++++++++++++++++++---
 include/linux/crash_dump.h |    5 ++++
 2 files changed, 52 insertions(+), 3 deletions(-)

Index: linux-2.6.39-rc5/fs/proc/vmcore.c
===================================================================
--- linux-2.6.39-rc5.orig/fs/proc/vmcore.c
+++ linux-2.6.39-rc5/fs/proc/vmcore.c
@@ -18,6 +18,7 @@
 #include <linux/init.h>
 #include <linux/crash_dump.h>
 #include <linux/list.h>
+#include <linux/wait.h>
 #include <asm/uaccess.h>
 #include <asm/io.h>
 
@@ -35,6 +36,44 @@ static u64 vmcore_size;
 
 static struct proc_dir_entry *proc_vmcore = NULL;
 
+/* returns > 0 for RAM pages, 0 for non-RAM pages, < 0 on error */
+static int (*oldmem_pfn_is_ram)(unsigned long pfn);
+static DECLARE_WAIT_QUEUE_HEAD(oldmem_fn_waitq);
+static atomic_t oldmem_fn_refcount = ATOMIC_INIT(0);
+
+void register_oldmem_pfn_is_ram(int (*fn)(unsigned long))
+{
+	if (oldmem_pfn_is_ram == NULL)
+		oldmem_pfn_is_ram = fn;
+}
+
+void unregister_oldmem_pfn_is_ram(void)
+{
+	wait_event(oldmem_fn_waitq, atomic_read(&oldmem_fn_refcount) == 0);
+	oldmem_pfn_is_ram = NULL;
+	wmb();
+}
+
+static int pfn_is_ram(unsigned long pfn)
+{
+	int (*fn)(unsigned long);
+	/* pfn is ram unless fn() checks pagetype */
+	int ret = 1;
+
+	atomic_inc(&oldmem_fn_refcount);
+	smp_mb__after_atomic_inc();
+	fn = oldmem_pfn_is_ram;
+	if (fn)
+		ret = fn(pfn);
+	if (atomic_dec_and_test(&oldmem_fn_refcount))
+		wake_up(&oldmem_fn_waitq);
+
+	return ret;
+}
+
+EXPORT_SYMBOL_GPL(register_oldmem_pfn_is_ram);
+EXPORT_SYMBOL_GPL(unregister_oldmem_pfn_is_ram);
+
 /* Reads a page from the oldmem device from given offset. */
 static ssize_t read_from_oldmem(char *buf, size_t count,
 				u64 *ppos, int userbuf)
@@ -55,9 +94,14 @@ static ssize_t read_from_oldmem(char *bu
 		else
 			nr_bytes = count;
 
-		tmp = copy_oldmem_page(pfn, buf, nr_bytes, offset, userbuf);
-		if (tmp < 0)
-			return tmp;
+		/* if pfn is not ram, return zeros for spares dump files */
+		if (pfn_is_ram(pfn) == 0)
+			memset(buf, 0, nr_bytes);
+		else {
+			tmp = copy_oldmem_page(pfn, buf, nr_bytes, offset, userbuf);
+			if (tmp < 0)
+				return tmp;
+		}
 		*ppos += nr_bytes;
 		count -= nr_bytes;
 		buf += nr_bytes;
Index: linux-2.6.39-rc5/include/linux/crash_dump.h
===================================================================
--- linux-2.6.39-rc5.orig/include/linux/crash_dump.h
+++ linux-2.6.39-rc5/include/linux/crash_dump.h
@@ -66,6 +66,11 @@ static inline void vmcore_unusable(void)
 	if (is_kdump_kernel())
 		elfcorehdr_addr = ELFCORE_ADDR_ERR;
 }
+
+#define HAVE_OLDMEM_PFN_IS_RAM 1
+extern void register_oldmem_pfn_is_ram(int (*fn)(unsigned long));
+extern void unregister_oldmem_pfn_is_ram(void);
+
 #else /* !CONFIG_CRASH_DUMP */
 static inline int is_kdump_kernel(void) { return 0; }
 #endif /* CONFIG_CRASH_DUMP */
