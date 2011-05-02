Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757545Ab1EBKWe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 06:22:34 -0400
Received: from mo-p00-ob.rzone.de ([81.169.146.161]:43767 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757082Ab1EBKWd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 06:22:33 -0400
X-RZG-AUTH: :P2EQZWCpfu+qG7CngxMFH1J+zrwiavkK6tmQaLfmztM8TOFHiy0KFkQ=
X-RZG-CLASS-ID: mo00
Date: Mon, 2 May 2011 12:22:30 +0200
From: Olaf Hering <olaf@aepfle.de>
To: linux-kernel@vger.kernel.org, kexec@lists.infradead.org
Subject: Re: dynamic oldmem in kdump kernel
Message-ID: <20110502102230.GA9497@aepfle.de>
References: <20110407095646.GA30788@aepfle.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20110407095646.GA30788@aepfle.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 07, Olaf Hering wrote:

> Recently kdump for pv-on-hvm Xen guests was implemented by me.
> 
> One issue remains:
> The xen_balloon driver in the guest frees guest pages and gives them
> back to the hypervisor. These pages are marked as mmio in the
> hypervisor. During a read of such a page via the /proc/vmcore interface
> the hypervisor calls the qemu-dm process. qemu-dm tries to map the page,
> this attempt fails because the page is not backed by ram and 0xff is
> returned. All this generates high load in dom0 because the reads come
> as 8byte requests.
> 
> There seems to be no way to make the crash kernel aware of the state of
> individual pages in the crashed kernel, it is not aware of memory
> ballooning. And doing that from within the "kernel to crash" seems error
> prone. Since over time the fragmentation will increase, it would be best
> if the crash kernel itself queries the state of oldmem pages. 


Here is a version that works for me.

A hook is called for each pfn. If the hook returns 0 the pfn is not ram,
and the range is cleared, for sparse vmcore files.
Otherwise the pfn is handled as ram. In the worst case each read attempt
will be handled by qemu-dm process which causes just some load in dom0.


This patch still lacks locking.
How can I make sure unregister_oldmem_pfn_is_ram() is not called while
the loop in read_from_oldmem() is still active?
Is there an example of similar code already in the kernel?

Olaf

---
 fs/proc/vmcore.c           |   29 ++++++++++++++++++++++++++---
 include/linux/crash_dump.h |    5 +++++
 2 files changed, 31 insertions(+), 3 deletions(-)

Index: linux-2.6.39-rc5/fs/proc/vmcore.c
===================================================================
--- linux-2.6.39-rc5.orig/fs/proc/vmcore.c
+++ linux-2.6.39-rc5/fs/proc/vmcore.c
@@ -35,6 +35,22 @@ static u64 vmcore_size;
 
 static struct proc_dir_entry *proc_vmcore = NULL;
 
+/* returns > 0 for RAM pages, 0 for non-RAM pages, < 0 on error */
+static int (*oldmem_pfn_is_ram)(unsigned long pfn);
+
+void register_oldmem_pfn_is_ram(int (*fn)(unsigned long))
+{
+	oldmem_pfn_is_ram = fn;
+}
+
+void unregister_oldmem_pfn_is_ram(void)
+{
+	oldmem_pfn_is_ram = NULL;
+}
+
+EXPORT_SYMBOL_GPL(register_oldmem_pfn_is_ram);
+EXPORT_SYMBOL_GPL(unregister_oldmem_pfn_is_ram);
+
 /* Reads a page from the oldmem device from given offset. */
 static ssize_t read_from_oldmem(char *buf, size_t count,
 				u64 *ppos, int userbuf)
@@ -42,6 +58,7 @@ static ssize_t read_from_oldmem(char *bu
 	unsigned long pfn, offset;
 	size_t nr_bytes;
 	ssize_t read = 0, tmp;
+	int (*fn)(unsigned long);
 
 	if (!count)
 		return 0;
@@ -55,9 +72,15 @@ static ssize_t read_from_oldmem(char *bu
 		else
 			nr_bytes = count;
 
-		tmp = copy_oldmem_page(pfn, buf, nr_bytes, offset, userbuf);
-		if (tmp < 0)
-			return tmp;
+		fn = oldmem_pfn_is_ram;
+		/* if pfn is not ram, return zeros for spares dump files */
+		if (fn && fn(pfn) == 0)
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
