Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753079Ab1LTH0i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 02:26:38 -0500
Received: from mailx.hitachi.co.jp ([133.145.228.49]:54570 "EHLO
	mailx.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752812Ab1LTH0Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 02:26:25 -0500
X-AuditID: b753bd60-9fe84ba000000655-01-4ef03815cca8
X-AuditID: b753bd60-9fe84ba000000655-01-4ef03815cca8
Date: Tue, 20 Dec 2011 16:24:16 +0900
From: YOSHIDA Masanori <masanori.yoshida.tv@hitachi.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        hpa@zytor.com, x86@kernel.org, linux-kernel@vger.kernel.org
Cc: hpa@zytor.com, Andrew Morton <akpm@linux-foundation.org>,
        Andy Lutomirski <luto@mit.edu>,
        Borislav Petkov <borislav.petkov@amd.com>,
        Ingo Molnar <mingo@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Kevin Hilman <khilman@ti.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Michal Marek <mmarek@suse.cz>, Rik van Riel <riel@redhat.com>,
        Tejun Heo <tj@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        YOSHIDA Masanori <masanori.yoshida.tv@hitachi.com>,
        Yinghai Lu <yinghai@kernel.org>, linux-kernel@vger.kernel.org,
        x86@kernel.org, frank.rowand@am.sony.com, jan.kiszka@web.de,
        yrl.pp-manager.tt@hitachi.com,
        YOSHIDA Masanori <masanori.yoshida.tv@hitachi.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Marek <mmarek@suse.cz>, Kevin Hilman <khilman@ti.com>,
        Borislav Petkov <borislav.petkov@amd.com>,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH 5/5] livedump: Add memory dumping functionality
Message-ID: <20111220072416.GF9220@t3500.sdl.hitachi.co.jp>
References: <20111220072028.9113.74876.stgit@t3500.sdl.hitachi.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111220072028.9113.74876.stgit@t3500.sdl.hitachi.co.jp>
User-Agent: StGIT/0.14.3
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch realizes memory dumping of kernel space. All dumped memory image
is saved on memory once. To do so, this patch allocates about 50% of RAM at
the initialization.

This patch also adds read/lseek operations to the "livedump" misc device to
provide user land with means to read the dumped data. The standard dump
analysis tool "crash" can analyze the dumped data via these operations.

The previous patch made it possible to define hook functions that specify
which pages to write-protect and how to handle pages. This patch defines
the hooks functions as follows.

- fn_select_pages:
    Selects all normal RAM pages, which are marked as E820_RAM.

    Also selects pages of physical memory address from 0 to
    CONFIG_X86_RESERVE_LOW. This range is usually used by BIOS,
    but crash also uses this range of memory.

    Pages which contain this patch's own stuffs (e.g. Allocated pages to
    store dumped image) are not selected because they are not needed for
    memory dump analysis.
    However, this patch's own stuffs are not necessarily aligned to 4K.
    Therefore, first and last pages can contain together data other than
    this patch's stuffs. I call such pages as "edge pages".
    Edge pages are selected here, but all of them area handled during the
    stop-machine because they are "sensitive pages".

- fn_handle_page:
    Saves a faulting page onto the above allocated area.

- fn_handle_sensitive_pages:
    Handles edge pages as described above.

Signed-off-by: YOSHIDA Masanori <masanori.yoshida.tv@hitachi.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Marek <mmarek@suse.cz>
Cc: Kevin Hilman <khilman@ti.com>
Cc: Borislav Petkov <borislav.petkov@amd.com>
Cc: linux-kernel@vger.kernel.org
---

 kernel/Makefile           |    2 
 kernel/livedump-memdump.c |  227 +++++++++++++++++++++++++++++++++++++++++++++
 kernel/livedump-memdump.h |   45 +++++++++
 kernel/livedump.c         |   13 ++-
 4 files changed, 285 insertions(+), 2 deletions(-)
 create mode 100644 kernel/livedump-memdump.c
 create mode 100644 kernel/livedump-memdump.h

diff --git a/kernel/Makefile b/kernel/Makefile
index 7d858e4..72efb90 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -109,7 +109,7 @@ obj-$(CONFIG_USER_RETURN_NOTIFIER) += user-return-notifier.o
 obj-$(CONFIG_PADATA) += padata.o
 obj-$(CONFIG_CRASH_DUMP) += crash_dump.o
 obj-$(CONFIG_JUMP_LABEL) += jump_label.o
-obj-$(CONFIG_LIVEDUMP) += livedump.o
+obj-$(CONFIG_LIVEDUMP) += livedump.o livedump-memdump.o
 
 ifneq ($(CONFIG_SCHED_OMIT_FRAME_POINTER),y)
 # According to Alan Modra <alan@linuxcare.com.au>, the -fno-omit-frame-pointer is
diff --git a/kernel/livedump-memdump.c b/kernel/livedump-memdump.c
new file mode 100644
index 0000000..a283848
--- /dev/null
+++ b/kernel/livedump-memdump.c
@@ -0,0 +1,227 @@
+/* livedump-memdump.c - Live Dump's memory dumping management
+ * Copyright (C) 2011 Hitachi, Ltd.
+ * Author: YOSHIDA Masanori <masanori.yoshida.tv@hitachi.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
+ * MA  02110-1301, USA.
+ */
+
+#include "livedump-memdump.h"
+#include <asm/wrprotect.h>
+
+#include <linux/sched.h>
+#include <linux/mm.h>
+#include <linux/uaccess.h>
+
+/* memdump's stuffs */
+static struct memdump {
+	spinlock_t lock;
+	unsigned long alloced;
+	unsigned long used;
+} memdump;
+
+static void **pages;	/* allocated pages */
+static void **pagemap;	/* mapping from PFN to page */
+
+int livedump_memdump_init(void)
+{
+	int ret;
+	unsigned long i;
+
+	spin_lock_init(&memdump.lock);
+	memdump.alloced = num_physpages / 2 + 1;
+
+	ret = -ENOMEM;
+	pages = vmalloc(sizeof(void *) * memdump.alloced);
+	if (!pages)
+		goto err;
+	for (i = 0; i < memdump.alloced; i++) {
+		pages[i] = (void *)__get_free_page(GFP_KERNEL);
+		if (!pages[i])
+			goto err;
+	}
+
+	ret = -ENOMEM;
+	pagemap = vmalloc(sizeof(void *) * num_physpages);
+	if (!pagemap)
+		goto err;
+	memset(pagemap, 0, sizeof(void *) * num_physpages);
+
+	return 0;
+err:
+	livedump_memdump_uninit();
+	return ret;
+}
+
+void livedump_memdump_uninit(void)
+{
+	if (pagemap) {
+		vfree(pagemap);
+		pagemap = NULL;
+	}
+	if (pages) {
+		unsigned long i;
+		for (i = 0; i < memdump.alloced; i++)
+			if (pages[i])
+				free_page((unsigned long)pages[i]);
+			else
+				break;
+		vfree(pages);
+		pages = NULL;
+	}
+	memdump.used = 0;
+	memdump.alloced = 0;
+	spin_lock_init(&memdump.lock);
+}
+
+/* livedump_memdump_select_pages
+ *
+ * Selects pages to protect.
+ *
+ * The following pages are selected.
+ *  - Pages marked as RAM by E820
+ *  - Pages of low memory used by BIOS (needed for crash to work normally)
+ *
+ * Pages that contain memdump's stuffs are unselected (eliminated from
+ * selection).
+ *
+ * On the other hand, because vmap areas are not write-protected,
+ * we don't have to unselect pagemap.
+ */
+int livedump_memdump_select_pages(unsigned long *pgbmp)
+{
+	unsigned long pfn, i;
+
+	/* Select all RAM pages */
+	for (pfn = 0; pfn < num_physpages; pfn++) {
+		if (e820_any_mapped(pfn << PAGE_SHIFT,
+				    (pfn + 1) << PAGE_SHIFT,
+				    E820_RAM))
+			set_bit(pfn, pgbmp);
+		cond_resched();
+	}
+
+	/* Essential area for executing crash with livedump */
+	bitmap_set(pgbmp, 0, (CONFIG_X86_RESERVE_LOW << 10) >> PAGE_SHIFT);
+
+	/* Unselect memdump stuffs (not needed against vmap areas) */
+	wrprotect_unselect_pages_but_edges(pgbmp,
+			(unsigned long)&memdump, sizeof(memdump));
+	for (i = 0; i < memdump.alloced; i++) {
+		clear_bit(__pa(pages[i]) >> PAGE_SHIFT, pgbmp);
+		cond_resched();
+	}
+
+	return 0;
+}
+
+/* livedump_memdump_handle_sensitive_pages
+ *
+ * Edge pages possibly contain both memdump's stuffs and something else.
+ * Such pages must not be unselected in advance.
+ * In fact, they should be handled during the stop-machine state.
+ *
+ * memdump_handle_sensitive_pages hook function is called to do this.
+ */
+void livedump_memdump_handle_sensitive_pages(unsigned long *pgbmp)
+{
+	wrprotect_handle_only_edges(pgbmp, livedump_memdump_handle_page,
+			(unsigned long)&memdump, sizeof(memdump));
+}
+
+void livedump_memdump_handle_page(unsigned long pfn)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&memdump.lock, flags);
+	if (WARN(memdump.used >= memdump.alloced,
+				"livedump: Out of memory of memdump.\n"))
+		goto out;
+	pagemap[pfn] = pages[memdump.used++];
+	memcpy(pagemap[pfn], pfn_to_kaddr(pfn), PAGE_SIZE);
+out:
+	spin_unlock_irqrestore(&memdump.lock, flags);
+}
+
+static void *memdump_page(unsigned long pfn)
+{
+	void *p = pagemap[pfn];
+	if (p)
+		return p;
+	return empty_zero_page;
+}
+
+loff_t livedump_memdump_sys_llseek(struct file *file, loff_t offset, int origin)
+{
+	loff_t retval;
+
+	switch (origin) {
+	case SEEK_SET:
+		break;
+	case SEEK_END:
+		offset += PFN_PHYS(num_physpages);
+		break;
+	case SEEK_CUR:
+		if (offset == 0) {
+			retval = file->f_pos;
+			goto out;
+		}
+		offset += file->f_pos;
+		break;
+	case SEEK_DATA:
+	case SEEK_HOLE:
+		retval = -ENOSYS;
+		goto out;
+	default:
+		retval = -EINVAL;
+		goto out;
+	}
+	retval = -EINVAL;
+	if (offset >= 0) {
+		if (offset != file->f_pos) {
+			file->f_pos = offset;
+			file->f_version = 0;
+		}
+		retval = offset;
+	}
+out:
+	return retval;
+}
+
+ssize_t livedump_memdump_sys_read(
+		struct file *file, char __user *buf, size_t count, loff_t *ppos)
+{
+	loff_t pos = *ppos;
+
+	if (pos >= PFN_PHYS(num_physpages))
+		return 0;
+	if (count > PFN_PHYS(num_physpages) - pos)
+		count = PFN_PHYS(num_physpages) - pos;
+
+	while (count) {
+		void *p = memdump_page(pos >> PAGE_SHIFT);
+		unsigned long off = pos & ~PAGE_MASK;
+		unsigned long len = min(count, PAGE_SIZE - off);
+		if (copy_to_user(buf, p + off, len))
+			return -EFAULT;
+		buf += len;
+		pos += len;
+		count -= len;
+	}
+
+	pos -= *ppos;
+	*ppos += pos;
+	return pos;
+}
diff --git a/kernel/livedump-memdump.h b/kernel/livedump-memdump.h
new file mode 100644
index 0000000..e8a5bae
--- /dev/null
+++ b/kernel/livedump-memdump.h
@@ -0,0 +1,45 @@
+/* livedump-memdump.h - Live Dump's memory dumping management
+ * Copyright (C) 2011 Hitachi, Ltd.
+ * Author: YOSHIDA Masanori <masanori.yoshida.tv@hitachi.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
+ * MA  02110-1301, USA.
+ */
+
+#ifndef _LIVEDUMP_MEMDUMP_H
+#define _LIVEDUMP_MEMDUMP_H
+
+#include <linux/fs.h>
+
+extern int livedump_memdump_init(void);
+
+extern void livedump_memdump_uninit(void);
+
+extern int livedump_memdump_select_pages(unsigned long *pgbmp);
+
+extern void livedump_memdump_handle_sensitive_pages(unsigned long *pgbmp);
+
+extern void livedump_memdump_handle_page(unsigned long pfn);
+
+extern loff_t livedump_memdump_sys_llseek(
+		struct file *file, loff_t offset, int origin);
+
+extern ssize_t livedump_memdump_sys_read(
+		struct file *file,
+		char __user *buf,
+		size_t len,
+		loff_t *ppos);
+
+#endif /* _LIVEDUMP_MEMDUMP_H */
diff --git a/kernel/livedump.c b/kernel/livedump.c
index 99b49b9..7bef9c8 100644
--- a/kernel/livedump.c
+++ b/kernel/livedump.c
@@ -18,6 +18,7 @@
  * MA  02110-1301, USA.
  */
 
+#include "livedump-memdump.h"
 #include <asm/wrprotect.h>
 
 #include <linux/module.h>
@@ -36,13 +37,21 @@
 static void do_uninit(void)
 {
 	wrprotect_uninit();
+	livedump_memdump_uninit();
 }
 
 static int do_init(void)
 {
 	int ret;
 
-	ret = wrprotect_init(NULL, NULL, NULL);
+	ret = livedump_memdump_init();
+	if (WARN(ret, "livedump: Failed to initialize Dump manager.\n"))
+		goto err;
+
+	ret = wrprotect_init(
+			livedump_memdump_select_pages,
+			livedump_memdump_handle_sensitive_pages,
+			livedump_memdump_handle_page);
 	if (WARN(ret, "livedump: Failed to initialize Protection manager.\n"))
 		goto err;
 
@@ -89,6 +98,8 @@ static const struct file_operations livedump_fops = {
 	.unlocked_ioctl = livedump_ioctl,
 	.open = livedump_open,
 	.release = livedump_release,
+	.read = livedump_memdump_sys_read,
+	.llseek = livedump_memdump_sys_llseek,
 };
 static struct miscdevice livedump_misc = {
 	.minor = MISC_DYNAMIC_MINOR,

