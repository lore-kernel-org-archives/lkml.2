Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755721Ab1BHTfX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 14:35:23 -0500
Received: from mga09.intel.com ([134.134.136.24]:43704 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755691Ab1BHTfS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 14:35:18 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,443,1291622400"; 
   d="scan'208";a="705461256"
From: james_p_freyensee@linux.intel.com
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, suhail.ahmed@intel.com,
        james_p_freyensee@linux.intel.com
Subject: [PATCH 10/12] n_tracerouter ldisc driver.
Date: Tue,  8 Feb 2011 11:34:55 -0800
Message-Id: <1297193697-5417-11-git-send-email-james_p_freyensee@linux.intel.com>
X-Mailer: git-send-email 1.6.6.1
In-Reply-To: <1297193697-5417-10-git-send-email-james_p_freyensee@linux.intel.com>
References: <james_p_freyensee@linux.intel.com>
 <1297193697-5417-1-git-send-email-james_p_freyensee@linux.intel.com>
 <1297193697-5417-2-git-send-email-james_p_freyensee@linux.intel.com>
 <1297193697-5417-3-git-send-email-james_p_freyensee@linux.intel.com>
 <1297193697-5417-4-git-send-email-james_p_freyensee@linux.intel.com>
 <1297193697-5417-5-git-send-email-james_p_freyensee@linux.intel.com>
 <1297193697-5417-6-git-send-email-james_p_freyensee@linux.intel.com>
 <1297193697-5417-7-git-send-email-james_p_freyensee@linux.intel.com>
 <1297193697-5417-8-git-send-email-james_p_freyensee@linux.intel.com>
 <1297193697-5417-9-git-send-email-james_p_freyensee@linux.intel.com>
 <1297193697-5417-10-git-send-email-james_p_freyensee@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: J Freyensee <james_p_freyensee@linux.intel.com>

This patch adds the n_tracerouter ldisc driver.  It is part
of the Intel-Atom PTI implementation solution.

Signed-off-by: J Freyensee <james_p_freyensee@linux.intel.com>
---
 drivers/tty/n_tracerouter.c |  264 +++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 264 insertions(+), 0 deletions(-)
 create mode 100644 drivers/tty/n_tracerouter.c

diff --git a/drivers/tty/n_tracerouter.c b/drivers/tty/n_tracerouter.c
new file mode 100644
index 0000000..1bb8c9e
--- /dev/null
+++ b/drivers/tty/n_tracerouter.c
@@ -0,0 +1,264 @@
+/*
+ *  n_tracerouter.c - Trace data router through tty space
+ *
+ *  Copyright (C) Intel 2010
+ *
+ * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2
+ *  as published by the Free Software Foundation.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; if not, write to the Free Software
+ *  Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
+ *  02110-1301, USA
+ *
+ * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+ *
+ * This trace router uses the Linux line discipline framework to route
+ * trace data coming from a HW Modem to a PTI (Parallel Trace Module) port.
+ * The solution is not specific to a HW modem and this line disciple can
+ * be used to route any stream of data in kernel space.
+ * This is part of a solution for the P1149.7, compact JTAG, standard.
+ *
+ */
+
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/types.h>
+#include <linux/ioctl.h>
+#include <linux/tty.h>
+#include <linux/tty_ldisc.h>
+#include <linux/errno.h>
+#include <linux/string.h>
+#include <linux/mutex.h>
+#include <linux/slab.h>
+#include <asm-generic/bug.h>
+#include <linux/n_tracesink.h>
+
+/* Other ldisc drivers use 65536 which basically means,
+ * 'I can always accept 64k' and flow control is off.
+ * This number is deemed appropriate for this driver.
+ */
+
+#define RECEIVE_ROOM	65536
+#define DRIVERNAME	"n_tracerouter"
+
+/* struct to hold private configuration data for this ldisc.
+ * opencalled is used to hold if this ldisc has been opened.
+ * kref_tty holds the tty reference the ldisc sits on top of.
+ */
+struct tracerouter_data {
+	u8 opencalled;
+	struct tty_struct *kref_tty;
+};
+static struct tracerouter_data *tr_data;
+
+/* lock for ioctl() setting of tracerouter_data values */
+static DEFINE_MUTEX(routelock);
+
+/**
+ * tracerouter_alloc
+ *
+ * Allocates the structure needed for this ldisc.
+ */
+static struct tracerouter_data *tracerouter_alloc(void)
+{
+	struct tracerouter_data *tptr = kzalloc(
+					sizeof(struct tracerouter_data),
+					GFP_KERNEL);
+	if (tptr == NULL)
+		return NULL;
+	tptr->opencalled = 0;
+	return tptr;
+}
+
+/**
+ * n_tracerouter_open() - Called when a tty is opened by a SW entity.
+ * @tty: terminal device to the ldisc.
+ *
+ * Return:
+ *      0 for success.
+ *
+ * Caveats: This should only be opened one time per SW entity.
+ */
+static int n_tracerouter_open(struct tty_struct *tty)
+{
+	int retval = -EEXIST;
+
+	mutex_lock(&routelock);
+	if (tr_data->opencalled == 0) {
+
+		tr_data->kref_tty = tty_kref_get(tty);
+		if (tr_data->kref_tty == NULL)
+			retval = -EFAULT;
+		else {
+			tr_data->opencalled = 1;
+			tty->disc_data      = tr_data;
+			tty->receive_room   = RECEIVE_ROOM;
+			tty_driver_flush_buffer(tty);
+			retval = 0;
+		}
+	}
+	mutex_unlock(&routelock);
+	return retval;
+}
+
+/**
+ * n_tracerouter_close() - close connection
+ * @tty: terminal device to the ldisc.
+ *
+ * Called when a software entity wants to close a connection.
+ */
+static void n_tracerouter_close(struct tty_struct *tty)
+{
+	struct tracerouter_data *tptr = tty->disc_data;
+
+	WARN_ON(tptr->kref_tty != tr_data->kref_tty);
+	tty_driver_flush_buffer(tty);
+	mutex_lock(&routelock);
+	tty_kref_put(tr_data->kref_tty);
+	tr_data->kref_tty = NULL;
+	tr_data->opencalled = 0;
+	tty->disc_data = NULL;
+	mutex_unlock(&routelock);
+}
+
+/**
+ * n_tracerouter_read() - read request from user space
+ * @tty:  terminal device passed into the ldisc.
+ * @file: pointer to open file object.
+ * @buf:  pointer to the data buffer that gets eventually returned.
+ * @nr:   number of bytes of the data buffer that is returned.
+ *
+ * function that allows read() functionality in userspace. By default if this
+ * is not implemented it returns -EIO. This module is functioning like a
+ * router via n_tracerouter_receivebuf(), and there is no real requirement
+ * to implement this function. However, an error return value other than
+ * -EIO should be used just to show that there was an intent not to have
+ * this function implemented.  Return value based on read() man pages.
+ *
+ * Return:
+ *	 -EINVAL
+ */
+static ssize_t n_tracerouter_read(struct tty_struct *tty, struct file *file,
+				  unsigned char __user *buf, size_t nr) {
+	return -EINVAL;
+}
+
+/**
+ * n_tracerouter_write() - Function that allows write() in userspace.
+ * @tty:  terminal device passed into the ldisc.
+ * @file: pointer to open file object.
+ * @buf:  pointer to the data buffer that gets eventually returned.
+ * @nr:   number of bytes of the data buffer that is returned.
+ *
+ * By default if this is not implemented, it returns -EIO.
+ * This should not be implemented, ever, because
+ * 1. this driver is functioning like a router via
+ *    n_tracerouter_receivebuf()
+ * 2. No writes to HW will ever go through this line discpline driver.
+ * However, an error return value other than -EIO should be used
+ * just to show that there was an intent not to have this function
+ * implemented.  Return value based on write() man pages.
+ *
+ * Return:
+ *	-EINVAL
+ */
+static ssize_t n_tracerouter_write(struct tty_struct *tty, struct file *file,
+				   const unsigned char *buf, size_t nr) {
+	return -EINVAL;
+}
+
+/**
+ * n_tracerouter_receivebuf() - Routing function for driver.
+ * @tty: terminal device passed into the ldisc.  It's assumed
+ *       tty will never be NULL.
+ * @cp:  buffer, block of characters to be eventually read by
+ *       someone, somewhere (user read() call or some kernel function).
+ * @fp:  flag buffer.
+ * @count: number of characters (aka, bytes) in cp.
+ *
+ * This function takes the input buffer, cp, and passes it to
+ * an external API function for processing.
+ */
+static void n_tracerouter_receivebuf(struct tty_struct *tty,
+					const unsigned char *cp,
+					char *fp, int count)
+{
+	mutex_lock(&routelock);
+	n_tracesink_datadrain((u8 *) cp, count);
+	mutex_unlock(&routelock);
+}
+
+/* Flush buffer is not impelemented as the ldisc has no internal buffering
+ * so the tty_driver_flush_buffer() is sufficient for this driver's needs.
+ */
+
+static struct tty_ldisc_ops tty_ptirouter_ldisc = {
+	.owner		= THIS_MODULE,
+	.magic		= TTY_LDISC_MAGIC,
+	.name		= DRIVERNAME,
+	.open		= n_tracerouter_open,
+	.close		= n_tracerouter_close,
+	.read		= n_tracerouter_read,
+	.write		= n_tracerouter_write,
+	.receive_buf	= n_tracerouter_receivebuf
+};
+
+/**
+ * n_tracerouter_init		-	module initialisation
+ *
+ * Registers this module as a line discipline driver.
+ *
+ * Return:
+ *	0 for success, any other value error.
+ */
+static int __init n_tracerouter_init(void)
+{
+	int retval;
+
+	tr_data = tracerouter_alloc();
+	if (tr_data == NULL)
+		return -ENOMEM;
+
+	/* Note N_TRACEROUTER is defined in linux/tty.h */
+	retval = tty_register_ldisc(N_TRACEROUTER, &tty_ptirouter_ldisc);
+	if (retval < 0) {
+		pr_err("%s: Registration failed: %d\n",
+					__func__, retval);
+		kfree(tr_data);
+	}
+	return retval;
+}
+
+/**
+ * n_tracerouter_exit -	-	module unload
+ *
+ * Removes this module as a line discipline driver.
+ */
+static void __exit n_tracerouter_exit(void)
+{
+	int retval;
+
+	kfree(tr_data);
+	retval = tty_unregister_ldisc(N_TRACEROUTER);
+	if (retval < 0)
+		pr_err("%s: Unregistration failed: %d\n",
+					__func__,  retval);
+}
+
+module_init(n_tracerouter_init);
+module_exit(n_tracerouter_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Jay Freyensee");
+MODULE_ALIAS_LDISC(N_TRACEROUTER);
+MODULE_DESCRIPTION("Trace router ldisc driver");
-- 
1.6.6.1

