Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755615Ab1EFNU3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 09:20:29 -0400
Received: from mo-p00-ob.rzone.de ([81.169.146.161]:54636 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755056Ab1EFNU1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 09:20:27 -0400
X-RZG-AUTH: :P2EQZWCpfu+qG7CngxMFH1J+zrwiavkK6tmQaLfmwtM48/lk2s7oFj0=
X-RZG-CLASS-ID: mo00
Date: Fri, 6 May 2011 15:20:24 +0200
From: Olaf Hering <olaf@aepfle.de>
To: linux-kernel@vger.kernel.org, kexec@lists.infradead.org
Cc: akpm@linux-foundation.org
Subject: [PATCH v2] add hook to read_from_oldmem() to check for non-ram pages
Message-ID: <20110506132024.GA19233@aepfle.de>
References: <20110407095646.GA30788@aepfle.de>
 <20110503190806.GA12485@aepfle.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20110503190806.GA12485@aepfle.de>
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
v2:
 remove refcounting, called function has to take care of module refcounting
 add comments to pfn_is_ram()
 register_oldmem_pfn_is_ram() returns -EBUSY if a function is already registerd
 move exports close to exported function
 update prototypes to include 'pfn'

 fs/proc/vmcore.c           |   52 ++++++++++++++++++++++++++++++++++++++++++---
 include/linux/crash_dump.h |    5 ++++
 2 files changed, 54 insertions(+), 3 deletions(-)

Index: linux-2.6.39-rc6/fs/proc/vmcore.c
===================================================================
--- linux-2.6.39-rc6.orig/fs/proc/vmcore.c
+++ linux-2.6.39-rc6/fs/proc/vmcore.c
@@ -35,6 +35,46 @@ static u64 vmcore_size;
 
 static struct proc_dir_entry *proc_vmcore = NULL;
 
+/*
+ * Returns > 0 for RAM pages, 0 for non-RAM pages, < 0 on error
+ * The called function has to take care of module refcounting.
+ */
+static int (*oldmem_pfn_is_ram)(unsigned long pfn);
+
+int register_oldmem_pfn_is_ram(int (*fn)(unsigned long pfn))
+{
+	if (oldmem_pfn_is_ram)
+		return -EBUSY;
+	oldmem_pfn_is_ram = fn;
+	return 0;
+}
+EXPORT_SYMBOL_GPL(register_oldmem_pfn_is_ram);
+
+void unregister_oldmem_pfn_is_ram(void)
+{
+	oldmem_pfn_is_ram = NULL;
+	wmb();
+}
+EXPORT_SYMBOL_GPL(unregister_oldmem_pfn_is_ram);
+
+static int pfn_is_ram(unsigned long pfn)
+{
+	int (*fn)(unsigned long pfn);
+	/* pfn is ram unless fn() checks pagetype */
+	int ret = 1;
+
+	/*
+	 * Ask hypervisor if the pfn is really ram.
+	 * A ballooned page contains no data and reading from such a page
+	 * will cause high load in the hypervisor.
+	 */
+	fn = oldmem_pfn_is_ram;
+	if (fn)
+		ret = fn(pfn);
+
+	return ret;
+}
+
 /* Reads a page from the oldmem device from given offset. */
 static ssize_t read_from_oldmem(char *buf, size_t count,
 				u64 *ppos, int userbuf)
@@ -55,9 +95,15 @@ static ssize_t read_from_oldmem(char *bu
 		else
 			nr_bytes = count;
 
-		tmp = copy_oldmem_page(pfn, buf, nr_bytes, offset, userbuf);
-		if (tmp < 0)
-			return tmp;
+		/* If pfn is not ram, return zeros for sparse dump files */
+		if (pfn_is_ram(pfn) == 0)
+			memset(buf, 0, nr_bytes);
+		else {
+			tmp = copy_oldmem_page(pfn, buf, nr_bytes,
+						offset, userbuf);
+			if (tmp < 0)
+				return tmp;
+		}
 		*ppos += nr_bytes;
 		count -= nr_bytes;
 		buf += nr_bytes;
Index: linux-2.6.39-rc6/include/linux/crash_dump.h
===================================================================
--- linux-2.6.39-rc6.orig/include/linux/crash_dump.h
+++ linux-2.6.39-rc6/include/linux/crash_dump.h
@@ -66,6 +66,11 @@ static inline void vmcore_unusable(void)
 	if (is_kdump_kernel())
 		elfcorehdr_addr = ELFCORE_ADDR_ERR;
 }
+
+#define HAVE_OLDMEM_PFN_IS_RAM 1
+extern int register_oldmem_pfn_is_ram(int (*fn)(unsigned long pfn));
+extern void unregister_oldmem_pfn_is_ram(void);
+
 #else /* !CONFIG_CRASH_DUMP */
 static inline int is_kdump_kernel(void) { return 0; }
 #endif /* CONFIG_CRASH_DUMP */
