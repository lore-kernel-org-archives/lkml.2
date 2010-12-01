Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753178Ab0LAAUy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 19:20:54 -0500
Received: from mga01.intel.com ([192.55.52.88]:32983 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753121Ab0LAAUv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 19:20:51 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,282,1288594800"; 
   d="scan'208";a="631797965"
From: "Luck, Tony" <tony.luck@intel.com>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Cc: tglx@linutronix.de, mingo@elte.hu, greg@kroah.com,
        akpm@linux-foundation.org, ying.huang@intel.com,
        "Borislav Petkov" <bp@alien8.de>, "David Miller" <davem@davemloft.net>,
        "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
        "Jim Keniston" <jkenisto@linux.vnet.ibm.com>,
        "Kyungmin Park" <kmpark@infradead.org>,
        "Geert Uytterhoeven" <geert@linux-m68k.org>
Subject: [RFC] persistent store (version 2) (part 1 of 2)
Date: Tue, 30 Nov 2010 16:20:50 -0800
Message-Id: <4cf594e21679631af0@agluck-desktop.sc.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here's version 2 with most of the fixes suggested in the discussion
for version 1 (see http://marc.info/?l=linux-arch&m=129045078803118&w=2).

Stuff that I haven't done:

1) Still has the "daft" echo filename > erase to clear entries from the
persistent store.  I looked hard at /sys and can't see how to get a
notification for an unlink(2). If I'm missing something, would somebody
please send me a clue. If this is a fatal flaw - then this will have to
move to debugfs (or turn into its own filesystem type). But I'd really
prefer to not give up the convenience of /sys

2) Did not implement Jim's suggestion to save OOPs ... I'm not at
all sure how to let the user configure this. mtdoops.c has a module
parameter for it - but I gave up on letting pstore be a module ...
it needs to be initialized before the platform driver, and there doesn't
seem to be much point in having it be unloadable.

I did write the ERST platform hooks (they are part 2 of 2, but I'd advise
the faint of heart not to look too closely at the ACPI/APEI'isms involved).
Here's a sample of what it looks like (with a debug call to panic() from
the pstore_erase() function added for testing purposes):

$ cd /sys/firmware/pstore
$ ls -l
total 0
-r--r--r-- 1 root root 7896 Nov 30 15:38 dmesg-1
--w------- 1 root root    0 Nov 30 15:38 erase
$ cat dmesg-1 | tail -12
<4>[  201.840197] mtrr: type mismatch for 90000000,2000000 old: write-back new: write-combining
<0>[ 1044.792139] Kernel panic - not syncing: Testing pstore
<4>[ 1044.792147] Pid: 7634, comm: bash Not tainted 2.6.36-rc6 #13
<4>[ 1044.792150] Call Trace:
<4>[ 1044.792166]  [<ffffffff815c7266>] panic+0xbc/0x1c6
<4>[ 1044.792176]  [<ffffffff810e6c50>] ? get_write_access+0x1e/0x50
<4>[ 1044.792182]  [<ffffffff810ea77d>] ? do_filp_open+0x1f4/0x594
<4>[ 1044.792193]  [<ffffffff814d72f5>] pstore_erase+0x41/0x14f
<4>[ 1044.792199]  [<ffffffff8112fbf2>] write+0x11e/0x160
<4>[ 1044.792208]  [<ffffffff810dec87>] vfs_write+0xb3/0x13a
<4>[ 1044.792213]  [<ffffffff810deddc>] sys_write+0x4c/0x73
<4>[ 1044.792222]  [<ffffffff81002bdb>] system_call_fastpath+0x16/0x1b

-Tony

---

diff --git a/drivers/firmware/Kconfig b/drivers/firmware/Kconfig
index e8b6a13..a5575a1 100644
--- a/drivers/firmware/Kconfig
+++ b/drivers/firmware/Kconfig
@@ -134,4 +134,16 @@ config ISCSI_IBFT
 	  detect iSCSI boot parameters dynamically during system boot, say Y.
 	  Otherwise, say N.
 
+config PSTORE
+	bool "Persistant store support via /sys"
+	default n
+	help
+	  This option enables generic access to platform level persistent
+	  storage via /sys/firmware/pstore.  Only useful if you have a
+	  platform level driver that registers with pstore to provide
+	  the data, so you probably should just go say "Y" (or "M") to
+	  a platform specific persistent store driver (e.g. ACPI_APEI on
+	  X86) which will select this for you.  If you don't have a platform
+	  persistent store driver, say N.
+
 endmenu
diff --git a/drivers/firmware/Makefile b/drivers/firmware/Makefile
index 1c3c173..ba19784 100644
--- a/drivers/firmware/Makefile
+++ b/drivers/firmware/Makefile
@@ -11,3 +11,4 @@ obj-$(CONFIG_DMIID)		+= dmi-id.o
 obj-$(CONFIG_ISCSI_IBFT_FIND)	+= iscsi_ibft_find.o
 obj-$(CONFIG_ISCSI_IBFT)	+= iscsi_ibft.o
 obj-$(CONFIG_FIRMWARE_MEMMAP)	+= memmap.o
+obj-$(CONFIG_PSTORE)		+= pstore.o
diff --git a/drivers/firmware/pstore.c b/drivers/firmware/pstore.c
new file mode 100644
index 0000000..ef590db
--- /dev/null
+++ b/drivers/firmware/pstore.c
@@ -0,0 +1,294 @@
+/*
+ * Persistent Storage - pstore.c
+ *
+ * Copyright (C) 2010 Intel Corporation <tony.luck@intel.com>
+ *
+ * This code is the generic layer to export data records from platform
+ * level persistent storage via sysfs.
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2 as
+ *  published by the Free Software Foundation.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; if not, write to the Free Software
+ *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ */
+
+#include <linux/atomic.h>
+#include <linux/types.h>
+#include <linux/errno.h>
+#include <linux/init.h>
+#include <linux/kmsg_dump.h>
+#include <linux/module.h>
+#include <linux/pstore.h>
+#include <linux/string.h>
+#include <linux/sysfs.h>
+#include <linux/slab.h>
+#include <linux/uaccess.h>
+
+MODULE_AUTHOR("Tony Luck <tony.luck@intel.com>");
+MODULE_DESCRIPTION("sysfs interface to persistent storage");
+MODULE_LICENSE("GPL");
+
+static DEFINE_SPINLOCK(pstore_lock);
+static LIST_HEAD(pstore_list);
+static struct kset *pstore_kset;
+
+#define	PSTORE_NAMELEN	16
+
+struct pstore_entry {
+	struct	bin_attribute attr;
+	char	name[PSTORE_NAMELEN];
+	u64	id;
+	int	type;
+	int	size;
+	struct	list_head list;
+	char	data[];
+};
+
+static int pstore_create_sysfs_entry(struct pstore_entry *new_pstore);
+
+static struct pstore_info *psinfo;
+
+static char *pstore_buf;
+
+/*
+ * callback from kmsg_dump. (s2,l2) has the most recently
+ * written bytes, older bytes are in (s1,l1). Save as much
+ * as we can from the end of the buffer.
+ */
+static void
+pstore_dump(struct kmsg_dumper *dumper, enum kmsg_dump_reason reason,
+	    const char *s1, unsigned long l1,
+	    const char *s2, unsigned long l2)
+{
+	unsigned long s1_start, s2_start;
+	unsigned long l1_cpy, l2_cpy;
+	char *dst = pstore_buf + psinfo->header_size;
+
+	/* Don't dump oopses to persistent store */
+	if (reason == KMSG_DUMP_OOPS)
+		return;
+
+	l2_cpy = min(l2, psinfo->data_size);
+	l1_cpy = min(l1, psinfo->data_size - l2_cpy);
+
+	s2_start = l2 - l2_cpy;
+	s1_start = l1 - l1_cpy;
+
+	memcpy(dst, s1 + s1_start, l1_cpy);
+	memcpy(dst + l1_cpy, s2 + s2_start, l2_cpy);
+
+	psinfo->writer(PSTORE_TYPE_DMESG, pstore_buf, l1_cpy + l2_cpy);
+}
+
+static struct kmsg_dumper pstore_dumper = {
+	.dump = pstore_dump,
+};
+
+/*
+ * platform specific persistent storage driver registers with
+ * us here. Read out all the records right away and install
+ * them in /sys.  Register with kmsg_dump to save last part
+ * of console log on panic.
+ */
+int
+pstore_register(struct pstore_info *psi)
+{
+	struct pstore_entry	*new_pstore;
+	unsigned long		size, ps_maxsize;
+	u64			id;
+	int			rc = 0, type;
+
+	spin_lock(&pstore_lock);
+	if (psinfo) {
+		spin_unlock(&pstore_lock);
+		return -EBUSY;
+	}
+	if (!psi->reader || !psi->writer || !psi->eraser) {
+		spin_unlock(&pstore_lock);
+		return -EINVAL;
+	}
+	psinfo = psi;
+	spin_unlock(&pstore_lock);
+
+	ps_maxsize = psi->header_size + psi->data_size + psi->footer_size;
+	pstore_buf = kzalloc(ps_maxsize, GFP_KERNEL);
+	if (!pstore_buf)
+		return -ENOMEM;
+
+	for (;;) {
+		if (psi->reader(&id, &type, pstore_buf, &size) <= 0)
+			break;
+		new_pstore = kzalloc(sizeof(struct pstore_entry) + size,
+				     GFP_KERNEL);
+		if (!new_pstore) {
+			rc = -ENOMEM;
+			break;
+		}
+		new_pstore->id = id;
+		new_pstore->type = type;
+		new_pstore->size = size;
+		memcpy(new_pstore->data, pstore_buf + psi->header_size, size);
+		if (pstore_create_sysfs_entry(new_pstore)) {
+			kfree(new_pstore);
+			rc =  -EINVAL;
+			break;
+		}
+	}
+
+	kobject_uevent(&pstore_kset->kobj, KOBJ_ADD);
+
+	kmsg_dump_register(&pstore_dumper);
+
+	return rc;
+}
+EXPORT_SYMBOL_GPL(pstore_register);
+
+int
+pstore_write(int type, char *buf, unsigned long size)
+{
+	if (size > psinfo->data_size)
+		return -EFBIG;
+
+	memcpy(pstore_buf + psinfo->header_size, buf, size);
+	return psinfo->writer(type, pstore_buf, size);
+}
+EXPORT_SYMBOL_GPL(pstore_write);
+
+#define to_pstore_entry(obj)  container_of(obj, struct pstore_entry, attr)
+
+/*
+ * "read" function for files containing persistent store records
+ */
+static ssize_t pstore_show(struct file *filp, struct kobject *kobj,
+			   struct bin_attribute *bin_attr, char *buf,
+			   loff_t offset, size_t count)
+{
+	struct pstore_entry *ps = to_pstore_entry(bin_attr);
+
+	return memory_read_from_buffer(buf, count, &offset,
+			ps->data, ps->size);
+}
+
+/*
+ * Erase records by writing their filename to the "erase" file. E.g.
+ *	# echo "dmesg-0" > erase
+ */
+static ssize_t pstore_erase(struct file *filp, struct kobject *kobj,
+			    struct bin_attribute *bin_attr,
+			    char *buf, loff_t pos, size_t count)
+{
+	struct pstore_entry *search_pstore, *n;
+	int len1, len2, found = 0;
+
+	len1 = count;
+	if (buf[len1 - 1] == '\n')
+		len1--;
+
+	spin_lock(&pstore_lock);
+
+	/*
+	 * Find this record
+	 */
+	list_for_each_entry_safe(search_pstore, n, &pstore_list, list) {
+		len2 = strlen(search_pstore->name);
+		if (len1 == len2 && memcmp(buf, search_pstore->name,
+					   len1) == 0) {
+			found = 1;
+			break;
+		}
+	}
+	if (!found) {
+		spin_unlock(&pstore_lock);
+		return -EINVAL;
+	}
+
+	if (psinfo->eraser(search_pstore->id)) {
+		spin_unlock(&pstore_lock);
+		return -EIO;
+	}
+
+	list_del(&search_pstore->list);
+
+	spin_unlock(&pstore_lock);
+
+	sysfs_remove_bin_file(&pstore_kset->kobj, &search_pstore->attr);
+
+	kfree(search_pstore);
+
+	return count;
+}
+
+static struct bin_attribute attr_erase = {
+	.attr = {.name = "erase", .mode = 0200},
+	.write = pstore_erase,
+};
+
+static int
+pstore_create_sysfs_entry(struct pstore_entry *new_pstore)
+{
+	static	atomic_t	next;
+	int	error, seq;
+
+	seq = atomic_add_return(1, &next);
+
+	switch (new_pstore->type) {
+	case PSTORE_TYPE_DMESG:
+		sprintf(new_pstore->name, "dmesg-%d", seq);
+		break;
+	case PSTORE_TYPE_MCE:
+		sprintf(new_pstore->name, "mce-%d", seq);
+		break;
+	default:
+		sprintf(new_pstore->name, "type%d-%d", new_pstore->type, seq);
+		break;
+	}
+
+	sysfs_attr_init(&new_pstore->attr.attr);
+	new_pstore->attr.size = new_pstore->size;
+	new_pstore->attr.read = pstore_show;
+	new_pstore->attr.attr.name = new_pstore->name;
+	new_pstore->attr.attr.mode = 0444;
+	error = sysfs_create_bin_file(&pstore_kset->kobj, &new_pstore->attr);
+	if (!error) {
+		spin_lock(&pstore_lock);
+		list_add(&new_pstore->list, &pstore_list);
+		spin_unlock(&pstore_lock);
+	}
+	return error;
+}
+
+static int __init
+pstore_init(void)
+{
+	int error = 0;
+
+	/* Register the pstore directory at /sys/firmware/pstore */
+	pstore_kset = kset_create_and_add("pstore", NULL, firmware_kobj);
+	if (!pstore_kset) {
+		printk(KERN_ERR "pstore: Subsystem registration failed.\n");
+		return -ENOMEM;
+	}
+
+	/*
+	 * Add attribute to allow records to be erased from persistent store
+	 */
+	error = sysfs_create_bin_file(&pstore_kset->kobj,
+				      &attr_erase);
+	if (error) {
+		printk(KERN_ERR "pstore: unable to create 'erase' sysfs file"
+				" due to error %d\n", error);
+		kset_unregister(pstore_kset);
+	}
+
+	return error;
+}
+
+subsys_initcall(pstore_init);
diff --git a/include/linux/pstore.h b/include/linux/pstore.h
new file mode 100644
index 0000000..cba8a0b
--- /dev/null
+++ b/include/linux/pstore.h
@@ -0,0 +1,54 @@
+/*
+ * Persistent Storage - pstore.h
+ *
+ * Copyright (C) 2010 Intel Corporation <tony.luck@intel.com>
+ *
+ * This code is the generic layer to export data records from platform
+ * level persistent storage via sysfs.
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2 as
+ *  published by the Free Software Foundation.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; if not, write to the Free Software
+ *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ */
+#ifndef _LINUX_PSTORE_H
+#define _LINUX_PSTORE_H
+
+/* types */
+#define	PSTORE_TYPE_DMESG	0
+#define	PSTORE_TYPE_MCE		1
+
+struct pstore_info {
+	unsigned long	header_size;
+	unsigned long	data_size;
+	unsigned long	footer_size;
+	int	(*reader)(u64 *id, int *type, void *buf, unsigned long *size);
+	int	(*writer)(int type, void *buf, unsigned long size);
+	int	(*eraser)(u64 id);
+};
+
+#if defined(CONFIG_PSTORE) || defined(CONFIG_PSTORE_MODULE)
+extern int pstore_register(struct pstore_info *);
+extern int pstore_write(int type, char *buf, unsigned long size);
+#else
+static inline int
+pstore_register(struct pstore_info *psi)
+{
+	return -ENODEV;
+}
+static inline int
+pstore_write(int type, char *buf, unsigned long size)
+{
+	return -ENODEV;
+}
+#endif
+
+#endif /*_LINUX_PSTORE_H*/
