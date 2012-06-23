Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754185Ab2FWDYR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 23:24:17 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:35689 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751722Ab2FWDYQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 23:24:16 -0400
MIME-Version: 1.0
In-Reply-To: <CAN_1RdvqJRig8vZW_gcvNVKYNo7ROmEKxAs7qu1N6XE4+Pspjg@mail.gmail.com>
References: <CAN_1RdvqJRig8vZW_gcvNVKYNo7ROmEKxAs7qu1N6XE4+Pspjg@mail.gmail.com>
Date: Sat, 23 Jun 2012 11:24:13 +0800
Message-ID: <CAN_1RdtqN+xjehHtqWCP61=vzez8tRWdc2jWeTh+Ft10wXRUGA@mail.gmail.com>
Subject: [PATCH] Implement uhook(call kernel func from userspace) driver
From: Peiyong Feng <peiyong.feng.kernel@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

This patch implement the uhook kernel driver. Here are some ideals and
explanations:

1. What is uhook

uhook(userspace kernel hook) means call kernel function from
userspace. That is to say, we can

write a function in kernel space and call it in userspace while the
kernel Image is running. For example:


I write  a function in kernel, like following:

+int uhook_unlock(void)
+{
+       printk(KERN_INFO"Unlock mutex\n");
+       mutex_unlock(&uhook_global->mutex);
+       return -1;
+}
+EXPORT_SYMBOL_GPL(uhook_test);

I can call it from userspace using uhook application:

uhook --type run uhook_test


2. What we can do with uhook

The most exciting feature of uhook is that we call kernel function in
userspace while kernel is running.
So,

A. We can using uhook to dump value of kernel argument when some thing
goes wrong. Especially when
the device driver cannot work correctly, we can dump some device
registers to examine what is going on.

B. We can implement some switch in kernel to control if branch. For example:

if (branch_control) {
     balabalabala......
     .....
}

We can dynamic change the value of branch_control to let kernel run
the specific code or not.

C. Whatever you want kernel do.



3. Compare to /proc or /sys file system

Kernel has some component like /proc and /sys file system to perform
the communication between kernel
and user space. But they are so complex that we must write some code
very time we want to use them. However,
with uhook, we just need to insmod the uhook.ko, then call the kernel
function whenever and wherever.


4. TODO

A. This version of uhook, can just support kernel function prototype
like int func(void). I donot know how to deal
with the function that has many argument and variable return type.

B. The user space applicantion: uhook, is just a test, so poor, cannot
process complex command option, I am still
working on it



-----------------------------------------------------------------------------------------------------------------------------------


>From 0aeb2765532829f0b5cfdde57de964f1620bb5ca Mon Sep 17 00:00:00 2001
From: bigfeng12 <peiyong.feng.kernel@gmail.com>
Date: Sat, 23 Jun 2012 10:31:20 +0800
Subject: [PATCH] Implement uhook(call kernel func from userspace) driver

Signed-off-by: bigfeng12 <peiyong.feng.kernel@gmail.com>
---
 drivers/staging/uhook/Kconfig  |    3 +
 drivers/staging/uhook/Makefile |    1 +
 drivers/staging/uhook/uhook.c  |  307 ++++++++++++++++++++++++++++++++++++++++
 tools/uhook/Makefile           |    2 +
 tools/uhook/uuhook.c           |   89 ++++++++++++
 5 files changed, 402 insertions(+), 0 deletions(-)
 create mode 100644 drivers/staging/uhook/Kconfig
 create mode 100644 drivers/staging/uhook/Makefile
 create mode 100644 drivers/staging/uhook/uhook.c
 create mode 100644 tools/uhook/Makefile
 create mode 100644 tools/uhook/uuhook.c

diff --git a/drivers/staging/uhook/Kconfig b/drivers/staging/uhook/Kconfig
new file mode 100644
index 0000000..074aeb8
--- /dev/null
+++ b/drivers/staging/uhook/Kconfig
@@ -0,0 +1,3 @@
+config UHOOK
+       tristate "Call kernel func from user space(uhook) driver"
+       default n
diff --git a/drivers/staging/uhook/Makefile b/drivers/staging/uhook/Makefile
new file mode 100644
index 0000000..d0d7d74
--- /dev/null
+++ b/drivers/staging/uhook/Makefile
@@ -0,0 +1 @@
+obj-$(CONFIG_UHOOK)    += uhook.o
diff --git a/drivers/staging/uhook/uhook.c b/drivers/staging/uhook/uhook.c
new file mode 100644
index 0000000..3f77443
--- /dev/null
+++ b/drivers/staging/uhook/uhook.c
@@ -0,0 +1,307 @@
+#include <linux/sched.h>
+#include <linux/module.h>
+#include <linux/fs.h>
+#include <linux/miscdevice.h>
+#include <linux/uaccess.h>
+#include <linux/poll.h>
+#include <linux/slab.h>
+#include <linux/time.h>
+#include <linux/vmalloc.h>
+#include <linux/kallsyms.h>
+
+#include <asm/ioctls.h>
+
+/*struct uhook*/
+#define   MAX_ARGV_LEN  512                    /*The length of the
buffer used to staorge argv*/
+#define   UHOOK_STA_LEN         32                     /*The length
of the buffer used to staorge argv*/
+
+
+#define   UHOOKCMD_QUERY_FUNC  1               /*CMD used to query if
there is a
symbal in kernel*/
+#define   UHOOKCMD_QUERY_VAL   2               /*CMD used to query
the value of a
argument in kernel*/
+#define   UHOOKCMD_RUN         3               /*CMD used to run the
func in kernel*/
+
+
+
+struct uhook{
+       char            fun_name[KSYM_NAME_LEN];/*function name called
from userspace*/
+       char            argv[MAX_ARGV_LEN];     /*argv of function*/
+       int             argc;                   /*number of arg*/
+       int             ret;                    /*return value*/
+       char            status[UHOOK_STA_LEN];  /*status of kernel func run*/
+       unsigned long   addr;                   /*Address of the kernel symbal*/
+};
+
+struct uhook_desc{
+       struct miscdevice       misc;           /*The misc device*/
+       struct mutex            mutex;          /*mutex used to protect*/
+};
+
+static struct uhook_desc *uhook_global;
+
+int uhook_unlock(void)
+{
+       printk(KERN_INFO"Unlock mutex\n");
+       mutex_unlock(&uhook_global->mutex);
+       return -1;
+}
+
+int  uhook_test(void)
+{
+       printk(">>>>>>>>>>uhook test sucessfully<<<<<<<<<<<<<<<<<<<\n");
+       return -1;
+}
+EXPORT_SYMBOL_GPL(uhook_test);
+EXPORT_SYMBOL_GPL(uhook_unlock);
+
+
+static ssize_t uhook_read(struct file *file, char __user *buf,
+                          size_t count, loff_t *pos)
+{
+       return 0;
+}
+
+
+
+static ssize_t uhook_aio_write(struct kiocb *iocb, const struct iovec *iov,
+                        unsigned long nr_segs, loff_t ppos)
+{
+       return 0;
+}
+
+
+
+static int uhook_open(struct inode *inode, struct file *file)
+{
+
+       file->private_data = uhook_global;
+       printk(KERN_INFO"Open uhook device success\n");
+       return 0;
+}
+
+static int uhook_release(struct inode *ignored, struct file *file)
+{
+       return 0;
+}
+
+
+static long uhook_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
+{
+       struct uhook_desc *desc = file->private_data;
+       struct uhook *tmp = (struct uhook *)arg;
+
+       /*Status of kernel function run*/
+       char *exsit = "exsit";
+       char *noexsit = "no-exsit";
+       char *success = "success";
+       char *fail = "fail";
+
+       struct uhook    uhook;
+       unsigned long addr;
+       int ret = 0;
+       int val = 0;
+
+       memset(&uhook, 0, sizeof(struct uhook));
+       mutex_lock(&desc->mutex);
+
+       switch (cmd) {
+       case UHOOKCMD_QUERY_FUNC:
+               if (copy_from_user(&uhook, (struct uhook __user *)arg,
sizeof(struct uhook))) {
+                       mutex_unlock(&desc->mutex);
+                       return -EFAULT;
+               }
+               addr = kallsyms_lookup_name(uhook.fun_name);
+               if (addr) {
+                       if (copy_to_user(&tmp->addr, &addr,
sizeof(unsigned long))) {
+                               mutex_unlock(&desc->mutex);
+                               return -EFAULT;
+                       }
+                       ret = 0;
+                       if (copy_to_user(&tmp->ret, &ret,
sizeof(unsigned long))) {
+                               mutex_unlock(&desc->mutex);
+                               return -EFAULT;
+                       }
+                       if (copy_to_user(tmp->status, exsit, strlen(exsit))) {
+                               mutex_unlock(&desc->mutex);
+                               return -EFAULT;
+                       }
+                       mutex_unlock(&desc->mutex);
+
+               } else {
+                       ret = -1;
+                       if (copy_to_user(&tmp->addr, &ret,
sizeof(unsigned long))) {
+                               mutex_unlock(&desc->mutex);
+                               return -EFAULT;
+                       }
+                       if (copy_to_user(&tmp->ret, &ret, sizeof(int))) {
+                               mutex_unlock(&desc->mutex);
+                               return -EFAULT;
+                       }
+                       if (copy_to_user(tmp->status, noexsit,
strlen(noexsit))) {
+                               mutex_unlock(&desc->mutex);
+                               return -EFAULT;
+                       }
+                       mutex_unlock(&desc->mutex);
+               }
+               break;
+       case UHOOKCMD_QUERY_VAL:
+       /*TODO:
+        * this version of uhook can just return the int value(4 byte for 32
bit system)
+        * from kernel space to user space. And if the value is -1,
how to deal it?*/
+               if (copy_from_user(&uhook, (struct uhook __user *)arg,
sizeof(struct uhook))) {
+                       mutex_unlock(&desc->mutex);
+                       return -EFAULT;
+               }
+               addr = kallsyms_lookup_name(uhook.fun_name);
+               if (addr) {
+                       val = *(int *)addr;
+                       if (copy_to_user(&tmp->addr, &addr,
sizeof(unsigned long))) {
+                               mutex_unlock(&desc->mutex);
+                               return -EFAULT;
+                       }
+                       if (copy_to_user(&tmp->ret, &val, sizeof(int))) {
+                               mutex_unlock(&desc->mutex);
+                               return -EFAULT;
+                       }
+                       if (copy_to_user(tmp->status, success,
strlen(success))) {
+                               mutex_unlock(&desc->mutex);
+                               return -EFAULT;
+                       }
+                       mutex_unlock(&desc->mutex);
+               } else {
+                       ret = -1;
+                       if (copy_to_user(&tmp->addr, &ret,
sizeof(unsigned long))) {
+                               mutex_unlock(&desc->mutex);
+                               return -EFAULT;
+                       }
+                       if (copy_to_user(&tmp->ret, &ret, sizeof(int))) {
+                               mutex_unlock(&desc->mutex);
+                               return -EFAULT;
+                       }
+                       if (copy_to_user(tmp->status, fail, strlen(fail))) {
+                               mutex_unlock(&desc->mutex);
+                               return -EFAULT;
+                       }
+                       mutex_unlock(&desc->mutex);
+               }
+               break;
+       case UHOOKCMD_RUN:
+       /*This is the point. Call kernel space function from user space
+        * TODO:
+        * This version of uhook can just support function type like:
+        * int func(void)*/
+               if (copy_from_user(&uhook, (struct uhook __user *)arg,
sizeof(struct uhook))) {
+                       mutex_unlock(&desc->mutex);
+                       return -EFAULT;
+               }
+               addr = kallsyms_lookup_name(uhook.fun_name);
+               if (addr) {
+                       int (*func)(void);
+                       func = (int (*)(void))addr;
+                       ret = func();
+
+                       if (copy_to_user(&tmp->addr, &addr,
sizeof(unsigned long))) {
+                               mutex_unlock(&desc->mutex);
+                               return -EFAULT;
+                       }
+                       if (copy_to_user(&tmp->ret, &ret, sizeof(int))) {
+                               mutex_unlock(&desc->mutex);
+                               return -EFAULT;
+                       }
+                       if (copy_to_user(tmp->status, success,
strlen(success))) {
+                               mutex_unlock(&desc->mutex);
+                               return -EFAULT;
+                       }
+                       mutex_unlock(&desc->mutex);
+               } else {
+                       ret = -1;
+
+                       if (copy_to_user(&tmp->addr, &ret,
sizeof(unsigned long))) {
+                               mutex_unlock(&desc->mutex);
+                               return -EFAULT;
+                       }
+                       if (copy_to_user(&tmp->ret, &ret, sizeof(int))) {
+                               mutex_unlock(&desc->mutex);
+                               return -EFAULT;
+                       }
+                       if (copy_to_user(tmp->status, noexsit,
strlen(noexsit))) {
+                               mutex_unlock(&desc->mutex);
+                               return -EFAULT;
+                       }
+                       mutex_unlock(&desc->mutex);
+               }
+               break;
+       default:
+               printk(KERN_ERR"Unknown cmd\n");
+       }
+
+       mutex_unlock(&desc->mutex);
+
+       return ret;
+}
+
+static const struct file_operations uhook_fops = {
+       .owner = THIS_MODULE,
+       .read = uhook_read,
+       .aio_write = uhook_aio_write,
+       .unlocked_ioctl = uhook_ioctl,
+       .compat_ioctl = uhook_ioctl,
+       .open = uhook_open,
+       .release = uhook_release,
+};
+
+static int __init uhook_init(char *uhook_name)
+{
+       uhook_global = kzalloc(sizeof(struct uhook_desc), GFP_KERNEL);
+       int ret = 0;
+       if (!uhook_global)
+               return -ENOMEM;
+
+       /*Do some initilization*/
+       mutex_init(&uhook_global->mutex);
+
+       uhook_global->misc.minor = MISC_DYNAMIC_MINOR;
+       uhook_global->misc.name = kstrdup(uhook_name, GFP_KERNEL);
+       if (uhook_global->misc.name == NULL) {
+               ret = -ENOMEM;
+               goto out_free;
+       }
+
+       uhook_global->misc.fops = &uhook_fops;
+       uhook_global->misc.parent = NULL;
+
+       /*Register the misc device for uhook */
+       ret = misc_register(&uhook_global->misc);
+       if (unlikely(ret)) {
+               printk(KERN_ERR "uhook: failed to register misc "
+                      "device for log '%s'!\n", uhook_global->misc.name);
+               goto out_free;
+       }
+
+       printk(KERN_INFO "uhook: created:'%s'\n",
+              uhook_global->misc.name);
+
+       return 0;
+
+out_free:
+       kfree(uhook_global);
+
+       return ret;
+}
+static int __init uhook_dev_init(void)
+{
+       if (uhook_init("uhook")) {
+               printk(KERN_ERR"uhook init failed\n");
+               return -1;
+       }
+       printk(KERN_INFO"uhook init success\n");
+       return 0;
+}
+
+static void __exit uhook_dev_deinit(void)
+{
+       misc_deregister(&uhook_global->misc);
+       kfree(uhook_global);
+}
+MODULE_LICENSE("GPL");
+module_init(uhook_dev_init);
+module_exit(uhook_dev_deinit);
diff --git a/tools/uhook/Makefile b/tools/uhook/Makefile
new file mode 100644
index 0000000..4862fc0
--- /dev/null
+++ b/tools/uhook/Makefile
@@ -0,0 +1,2 @@
+all:
+       gcc uuhook.c -o uhook
diff --git a/tools/uhook/uuhook.c b/tools/uhook/uuhook.c
new file mode 100644
index 0000000..87d088d
--- /dev/null
+++ b/tools/uhook/uuhook.c
@@ -0,0 +1,89 @@
+#include <stdio.h>
+#include <string.h>
+#include <unistd.h>
+#include <stdlib.h>
+
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <fcntl.h>
+
+/*struct uhook*/
+#define   MAX_ARGV_LEN  512                    /*The length of the
buffer used to staorge argv*/
+#define   UHOOK_STA_LEN         32                     /*The length
of the buffer used to staorge argv*/
+#define   KSYM_NAME_LEN  128
+struct uhook{
+       char            fun_name[KSYM_NAME_LEN];/*function name called
from userspace*/
+       char            argv[MAX_ARGV_LEN];     /*argv of function*/
+       int             argc;                   /*number of arg*/
+       int             ret;                    /*return value*/
+       char            status[UHOOK_STA_LEN];  /*status of kernel func run*/
+       unsigned long   addr;                   /*Address of kernel symbal*/
+};
+
+
+#define   UHOOKCMD_QUERY_FUNC  1               /*CMD used to query if
there is a
symbal in kernel*/
+#define   UHOOKCMD_QUERY_VAL   2               /*CMD used to query
the value of a
argument in kernel*/
+#define   UHOOKCMD_RUN         3               /*CMD used to run the
func in kernel*/
+
+#define          DEV_NAME              "/dev/uhook"
+
+static int parse_cmd(char *cmd)
+{
+       if (strcmp(cmd, "query") == 0) {
+               return UHOOKCMD_QUERY_FUNC;
+       }
+       if (strcmp(cmd, "run") == 0) {
+               return UHOOKCMD_RUN;
+       }
+       if (strcmp(cmd, "query_val") == 0) {
+               return UHOOKCMD_QUERY_VAL;
+       }
+}
+
+static int parse_result(struct uhook *uhook, char *cmd)
+{
+       printf("The ret of cmd(%s) is %d\n", cmd, uhook->ret);
+       printf("The address of ksymbal(%s) is 0x%x\n",
uhook->fun_name, uhook->addr);
+       printf("The status of ksymbal(%s) run is %s\n", uhook->fun_name,
uhook->status);
+}
+
+static void build_uhook(struct uhook *uhook, char *name)
+{
+       strcpy(uhook->fun_name, name);
+}
+/*
+ * call type:
+ * uhook    --type     run             func
+ * argv[0] argv[1]     argv[2]         argv[3]
+ * */
+int main(int argc, char **argv)
+{
+
+       int uhook_fd = open(DEV_NAME, O_RDWR);
+       struct uhook    uhook;
+       memset(&uhook, 0, sizeof(struct uhook));
+
+       switch(parse_cmd(argv[2])) {
+
+       case UHOOKCMD_QUERY_FUNC:
+               build_uhook(&uhook, argv[3]);
+               ioctl(uhook_fd, UHOOKCMD_QUERY_FUNC, &uhook);
+               parse_result(&uhook, "query");
+               break;
+       case UHOOKCMD_RUN:
+               build_uhook(&uhook, argv[3]);
+               ioctl(uhook_fd, UHOOKCMD_RUN, &uhook);
+               parse_result(&uhook, "run");
+               break;
+       case UHOOKCMD_QUERY_VAL:
+               build_uhook(&uhook, argv[3]);
+               ioctl(uhook_fd, UHOOKCMD_QUERY_VAL, &uhook);
+               parse_result(&uhook, "query val");
+               break;
+       default:
+               printf("Unkown cmd\n");
+       }
+       close(uhook_fd);
+       return 0;
+}
+
--
1.7.7.6
