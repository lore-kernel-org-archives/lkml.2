Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754553Ab1HKXy7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 19:54:59 -0400
Received: from ns1.jhcomp.cz ([178.23.218.35]:60696 "EHLO
	jhcinternet.jhcomp.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754481Ab1HKXy6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 19:54:58 -0400
X-Greylist: delayed 576 seconds by postgrey-1.27 at vger.kernel.org; Thu, 11 Aug 2011 19:54:57 EDT
From: Tonda <as@strmilov.cz>
To: viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Module hiding files controlled by sysfs
Date: Fri, 12 Aug 2011 01:55:03 +0200
Message-Id: <1313106903-18702-1-git-send-email-as@strmilov.cz>
X-Mailer: git-send-email 1.6.2.5
Signed-off-by: Tonda <as@strmilov.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

diff --git a/fs/hidefiles/hidefiles.c b/fs/hidefiles/hidefiles.c
--- a/fs/hidefiles/hidefiles.c
+++ b/fs/hidefiles/hidefiles.c
@@ -0,0 +1,289 @@
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/namei.h>
+#include <linux/path.h>
+#include <linux/dirent.h>
+#include <linux/slab.h>
+#include <linux/fs.h>
+#include <linux/file.h>
+#include <linux/uaccess.h>
+#include <linux/syscalls.h>
+#include <asm/page.h>
+#include <linux/unistd.h>
+#include <linux/semaphore.h>
+#include <linux/kobject.h>
+
+MODULE_LICENSE("GPL");
+
+static unsigned long sys_call_table = 0x01234567;
+
+void **_sys_call_table;
+
+module_param(sys_call_table, ulong, 0);
+
+static int *parentinodes;
+
+static int *childinodes;
+
+static int inodecount;
+
+static int parent(int inoda)
+{
+	int i;
+	for (i = 0; i < inodecount; ++i)
+		if (parentinodes[i] == inoda)
+			return 1;
+	return 0;
+}
+
+static int child(int parent, int inoda)
+{
+	int i;
+	for (i = 0; i < inodecount; ++i)
+		if (parentinodes[i] == parent && childinodes[i] == inoda)
+			return 1;
+	return 0;
+}
+
+struct old_linux_dirent {
+	long  d_ino;              /* inode number */
+	off_t d_off;              /* offset to this old_linux_dirent */
+	unsigned short d_reclen;  /* length of this d_name */
+	char  d_name[NAME_MAX+1]; /* filename (null-terminated) */
+};
+
+asmlinkage long (*puvodni_getdents) (unsigned int fd,
+	struct old_linux_dirent *dirent, unsigned int count);
+asmlinkage long (*puvodni_getdents64) (unsigned int fd,
+	struct linux_dirent64 *dirent, unsigned int count);
+
+asmlinkage long novy_getdents(unsigned int fd,
+	struct old_linux_dirent *dirent, unsigned int count)
+{
+	struct file *file;
+
+	file = fget(fd);
+
+	if (file) {
+		if (parent(file->f_path.dentry->d_inode->i_ino)) {
+			int vysledek, offset, i;
+			struct old_linux_dirent *tmp;
+			vysledek = puvodni_getdents(fd, dirent, count);
+			offset = 0;
+			while (offset < vysledek) {
+				tmp = (struct old_linux_dirent *)
+					(offset+((char *)dirent));
+				if (child(file->f_path.dentry->d_inode->i_ino,
+					tmp->d_ino)) {
+					unsigned short reclen = tmp->d_reclen;
+					char *pole = (char *)tmp;
+					for (i = 0; i < vysledek-offset; ++i)
+						pole[i] = pole[i+reclen];
+					vysledek -= reclen;
+					}
+				offset += tmp->d_reclen;
+			}
+			return vysledek;
+		}
+	}
+
+	return puvodni_getdents(fd, dirent, count);
+}
+
+asmlinkage long novy_getdents64(unsigned int fd,
+	struct linux_dirent64 *dirent, unsigned int count)
+{
+	struct file *file;
+
+	file = fget(fd);
+
+	if (file) {
+		if (parent(file->f_path.dentry->d_inode->i_ino)) {
+			int vysledek, offset, i;
+			struct linux_dirent64 *tmp;
+			vysledek = puvodni_getdents64(fd, dirent, count);
+			offset = 0;
+			while (offset < vysledek) {
+				tmp = (struct linux_dirent64 *)
+					(offset+((char *)dirent));
+				if (child(file->f_path.dentry->d_inode->i_ino,
+					tmp->d_ino)) {
+					unsigned short reclen = tmp->d_reclen;
+					char *pole = (char *)tmp;
+					for (i = 0; i < vysledek-offset; ++i)
+						pole[i] = pole[i+reclen];
+					vysledek -= reclen;
+					}
+				offset += tmp->d_reclen;
+			}
+			return vysledek;
+		}
+	}
+
+	return puvodni_getdents64(fd, dirent, count);
+}
+
+#define WRITEABLE 0x00010000
+
+static void disable_write_protection(void)
+{
+	unsigned long value;
+	asm volatile("mov %%cr0,%0" : "=r"(value));
+	value &= (~WRITEABLE);
+	asm volatile("mov %0,%%cr0" : : "r"(value));
+}
+
+static void enable_write_protection(void)
+{
+	unsigned long value;
+	asm volatile("mov %%cr0,%0" : "=r"(value));
+	value |= WRITEABLE;
+	asm volatile ("mov %0,%%cr0" : : "r"(value));
+}
+
+static void refresh_inodes(char *filename)
+{
+	struct path nd;
+	int delka, res, i, k, j;
+	int *newchildinodes;
+	int *newparentinodes;
+	int *oldinodes;
+
+	res = kern_path(filename, 0, &nd);
+	if (res)
+		return;
+
+	newchildinodes = kmalloc(sizeof(int)*(inodecount+1), GFP_KERNEL);
+	for (i = 0; i < inodecount; ++i)
+		newchildinodes[i] = childinodes[i];
+	newchildinodes[inodecount] = nd.dentry->d_inode->i_ino;
+
+	delka = strlen(filename);
+	if (filename[delka-1] == '/') {
+		filename[delka-1] = '\0';
+		--delka;
+	}
+
+	k = 0;
+	for (j = 0; j < delka; ++j)
+		if (filename[j] == '/')
+			k = j;
+
+	for (j = k; j < delka; ++j)
+		filename[j] = '\0';
+
+	res = kern_path(filename, 0, &nd);
+
+	newparentinodes = kmalloc(sizeof(int)*(inodecount+1), GFP_KERNEL);
+	for (i = 0; i < inodecount; ++i)
+		newparentinodes[i] = parentinodes[i];
+	newparentinodes[inodecount] = nd.dentry->d_inode->i_ino;
+
+	oldinodes = childinodes;
+	childinodes = newchildinodes;
+	if (inodecount)
+		kfree(oldinodes);
+
+	oldinodes = parentinodes;
+	parentinodes = newparentinodes;
+	if (inodecount)
+		kfree(oldinodes);
+
+	++inodecount;
+}
+
+static ssize_t store(struct kobject *kobj,
+	struct attribute *attr, const char *buffer, size_t size)
+{
+	int i;
+	char *filename;
+	filename = kmalloc(size+1, GFP_KERNEL);
+	for (i = 0; i < size; ++i)
+		filename[i] = buffer[i];
+	filename[size] = '\0';
+	if (size > 0 && filename[size-1] == '\n')
+		filename[size-1] = '\0';
+	if (!strcmp(filename, "reset")) {
+		if (inodecount) {
+			kfree(childinodes);
+			kfree(parentinodes);
+		}
+		inodecount = 0;
+	} else
+		refresh_inodes(filename);
+	kfree(filename);
+	return size;
+}
+
+static const struct sysfs_ops so = {
+	.store = store,
+};
+
+static const struct attribute attr = {
+	.name = "filename",
+	.mode = S_IWUSR,
+};
+
+static struct kobj_type khid = {
+	.sysfs_ops = &so,
+};
+
+static struct kobject kobj;
+
+static int __init start(void)
+{
+
+	if (sys_call_table == 0x01234567) {
+		printk(KERN_WARNING "sys_call_table parameter was not");
+		printk(KERN_WARNING " specified!\nread its value from");
+		printk(KERN_WARNING " System_map file file, and insert");
+		printk(KERN_WARNING " the module again!\n");
+		return -1;
+	}
+
+	inodecount = 0;
+
+	memset(&kobj, 0, sizeof(struct kobject));
+
+	kobject_init(&kobj, &khid);
+	if (kobject_add(&kobj, NULL, "tohide") < 0)
+		printk(KERN_ERR "kobject_add failed");
+	if (sysfs_create_file(&kobj, &attr) < 0)
+		printk(KERN_ERR "sysfs_create_file failed");
+
+	_sys_call_table = (void **)sys_call_table;
+
+	disable_write_protection();
+
+	puvodni_getdents = (void *)_sys_call_table[__NR_getdents];
+	_sys_call_table[__NR_getdents] = (void *)novy_getdents;
+
+	puvodni_getdents64 = (void *)_sys_call_table[__NR_getdents64];
+	_sys_call_table[__NR_getdents64] = (void *)novy_getdents64;
+
+	enable_write_protection();
+
+	return 0;
+}
+
+static void konec(void)
+{
+
+	disable_write_protection();
+
+	_sys_call_table[__NR_getdents] = (void *)puvodni_getdents;
+	_sys_call_table[__NR_getdents64] = (void *)puvodni_getdents64;
+
+	enable_write_protection();
+
+	if (inodecount) {
+		kfree(parentinodes);
+		kfree(childinodes);
+	}
+
+	kobject_del(&kobj);
+}
+
+module_init(start);
+module_exit(konec);
diff --git a/fs/hidefiles/Makefile b/fs/hidefiles/Makefile
--- a/fs/hidefiles/Makefile
+++ b/fs/hidefiles/Makefile
@@ -0,0 +1 @@
+obj-$(CONFIG_HIDEFILES)		+= hidefiles.o
diff --git a/fs/Kconfig b/fs/Kconfig
--- a/fs/Kconfig
+++ b/fs/Kconfig
@@ -253,4 +253,8 @@
 source "fs/nls/Kconfig"
 source "fs/dlm/Kconfig"
 
+config HIDEFILES
+	tristate "Hide files"
+	depends on m
+
 endmenu
diff --git a/fs/Makefile b/fs/Makefile
--- a/fs/Makefile
+++ b/fs/Makefile
@@ -124,3 +124,4 @@
 obj-$(CONFIG_EXOFS_FS)          += exofs/
 obj-$(CONFIG_CEPH_FS)		+= ceph/
 obj-$(CONFIG_PSTORE)		+= pstore/
+obj-$(CONFIG_HIDEFILES)		+= hidefiles/
