Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757044Ab1DVXcu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Apr 2011 19:32:50 -0400
Received: from mga09.intel.com ([134.134.136.24]:18323 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757021Ab1DVXco (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Apr 2011 19:32:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,256,1301900400"; 
   d="scan'208";a="632852637"
From: james_p_freyensee@linux.intel.com
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, suhail.ahmed@intel.com,
        james_p_freyensee@linux.intel.com, christophe.guerard@intel.com
Subject: [PATCH 4/4] n_tracerouter and n_tracesink ldisc additions.
Date: Fri, 22 Apr 2011 16:32:30 -0700
Message-Id: <1303515150-1718-5-git-send-email-james_p_freyensee@linux.intel.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <james_p_freyensee@linux.intel.com>
References: <james_p_freyensee@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: J Freyensee <james_p_freyensee@linux.intel.com>

The n_tracerouter and n_tracesink line discpline drivers use the
Linux tty line discpline framework to route trace data coming
from a tty port (say UART for example) to the trace sink line
discipline driver and to another tty port(say USB).  Those
these two line discipline drivers can be used together,
independently from pti.c, they are part of the original
implementation solution of the MIPI P1149.7, compact JTAG, PTI
solution for Intel mobile platforms starting with the
Medfield platform.

Signed-off-by: J Freyensee <james_p_freyensee@linux.intel.com>
---
 drivers/tty/Kconfig         |   31 ++++++
 drivers/tty/Makefile        |    2 +
 drivers/tty/n_tracerouter.c |  243 ++++++++++++++++++++++++++++++++++++++++++
 drivers/tty/n_tracesink.c   |  246 +++++++++++++++++++++++++++++++++++++++++++
 drivers/tty/n_tracesink.h   |   36 +++++++
 include/linux/tty.h         |    2 +
 6 files changed, 560 insertions(+), 0 deletions(-)
 create mode 100644 drivers/tty/n_tracerouter.c
 create mode 100644 drivers/tty/n_tracesink.c
 create mode 100644 drivers/tty/n_tracesink.h

diff --git a/drivers/tty/Kconfig b/drivers/tty/Kconfig
index 3fd7199..2e5f2f2 100644
--- a/drivers/tty/Kconfig
+++ b/drivers/tty/Kconfig
@@ -319,3 +319,34 @@ config N_GSM
 	  This line discipline provides support for the GSM MUX protocol and
 	  presents the mux as a set of 61 individual tty devices.
 
+config TRACE_ROUTER
+	tristate "Trace data router for MIPI P1149.7 cJTAG standard"
+	depends on TRACE_SINK
+	default n
+	help
+	  The trace router uses the Linux tty line discipline framework to
+	  route trace data coming from a tty port (say UART for example) to
+	  the trace sink line discipline driver and to another tty port(say 
+	  USB). This is part of a solution for the MIPI P1149.7, compact JTAG,
+	  standard, which is for debugging mobile devices. The PTI driver in
+	  drivers/misc/pti.c defines the majority of this MIPI solution.
+
+	  You should select this driver if the target kernel is meant for
+	  a mobile device containing a modem.  Then you will need to select
+	  "Trace data sink for MIPI P1149.7 cJTAG standard" line discipline
+	  driver.
+
+config TRACE_SINK
+	tristate "Trace data sink for MIPI P1149.7 cJTAG standard"
+	default n
+	help
+	  The trace sink uses the Linux line discipline framework to receive
+	  trace data coming from the trace router line discipline driver
+	  to a user-defined tty port target, like USB.
+	  This is to provide a way to extract modem trace data on
+	  devices that do not have a PTI HW module, or just need modem
+	  trace data to come out of a different HW output port.
+	  This is part of a solution for the P1149.7, compact JTAG, standard.
+
+	  If you select this option, you need to select
+	  "Trace data router for MIPI P1149.7 cJTAG standard".
diff --git a/drivers/tty/Makefile b/drivers/tty/Makefile
index 690522f..ea89b0b 100644
--- a/drivers/tty/Makefile
+++ b/drivers/tty/Makefile
@@ -6,6 +6,8 @@ obj-$(CONFIG_AUDIT)		+= tty_audit.o
 obj-$(CONFIG_MAGIC_SYSRQ)	+= sysrq.o
 obj-$(CONFIG_N_HDLC)		+= n_hdlc.o
 obj-$(CONFIG_N_GSM)		+= n_gsm.o
+obj-$(CONFIG_TRACE_ROUTER)	+= n_tracerouter.o
+obj-$(CONFIG_TRACE_SINK)	+= n_tracesink.o
 obj-$(CONFIG_R3964)		+= n_r3964.o
 
 obj-y				+= vt/
diff --git a/drivers/tty/n_tracerouter.c b/drivers/tty/n_tracerouter.c
new file mode 100644
index 0000000..94f330a
--- /dev/null
+++ b/drivers/tty/n_tracerouter.c
@@ -0,0 +1,243 @@
+/*
+ *  n_tracerouter.c - Trace data router through tty space
+ *
+ *  Copyright (C) Intel 2011
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
+ * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+ *
+ * This trace router uses the Linux line discipline framework to route
+ * trace data coming from a HW Modem to a PTI (Parallel Trace Module) port.
+ * The solution is not specific to a HW modem and this line disciple can
+ * be used to route any stream of data in kernel space.
+ * This is part of a solution for the P1149.7, compact JTAG, standard.
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
+#include "n_tracesink.h"
+
+/*
+ * Other ldisc drivers use 65536 which basically means,
+ * 'I can always accept 64k' and flow control is off.
+ * This number is deemed appropriate for this driver.
+ */
+#define RECEIVE_ROOM	65536
+#define DRIVERNAME	"n_tracerouter"
+
+/*
+ * struct to hold private configuration data for this ldisc.
+ * opencalled is used to hold if this ldisc has been opened.
+ * kref_tty holds the tty reference the ldisc sits on top of.
+ */
+struct tracerouter_data {
+	u8 opencalled;
+	struct tty_struct *kref_tty;
+};
+static struct tracerouter_data *tr_data;
+
+/* lock for when tty reference is being used */
+static DEFINE_MUTEX(routelock);
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
+		if (tr_data->kref_tty == NULL) {
+			retval = -EFAULT;
+		} else {
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
+	mutex_lock(&routelock);
+	WARN_ON(tptr->kref_tty != tr_data->kref_tty);
+	tty_driver_flush_buffer(tty);
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
+/*
+ * Flush buffer is not impelemented as the ldisc has no internal buffering
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
+	tr_data = kzalloc(sizeof(struct tracerouter_data), GFP_KERNEL);
+	if (tr_data == NULL)
+		return -ENOMEM;
+
+
+	/* Note N_TRACEROUTER is defined in linux/tty.h */
+	retval = tty_register_ldisc(N_TRACEROUTER, &tty_ptirouter_ldisc);
+	if (retval < 0) {
+		pr_err("%s: Registration failed: %d\n", __func__, retval);
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
+		pr_err("%s: Unregistration failed: %d\n", __func__,  retval);
+}
+
+module_init(n_tracerouter_init);
+module_exit(n_tracerouter_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Jay Freyensee");
+MODULE_ALIAS_LDISC(N_TRACEROUTER);
+MODULE_DESCRIPTION("Trace router ldisc driver");
diff --git a/drivers/tty/n_tracesink.c b/drivers/tty/n_tracesink.c
new file mode 100644
index 0000000..c4e6c0f
--- /dev/null
+++ b/drivers/tty/n_tracesink.c
@@ -0,0 +1,246 @@
+/*
+ *  n_tracesink.c - Trace data router and sink path through tty space.
+ *
+ *  Copyright (C) Intel 2011
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
+ * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+ *
+ * The trace sink uses the Linux line discipline framework to receive
+ * trace data coming from the PTI source line discipline driver
+ * to a user-desired tty port, like USB.
+ * This is to provide a way to extract modem trace data on
+ * devices that do not have a PTI HW module, or just need modem
+ * trace data to come out of a different HW output port.
+ * This is part of a solution for the P1149.7, compact JTAG, standard.
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
+#include <asm-generic/bug.h>
+#include "n_tracesink.h"
+
+/*
+ * Other ldisc drivers use 65536 which basically means,
+ * 'I can always accept 64k' and flow control is off.
+ * This number is deemed appropriate for this driver.
+ */
+#define RECEIVE_ROOM	65536
+#define DRIVERNAME	"n_tracesink"
+
+/*
+ * there is a quirk with this ldisc is he can write data
+ * to a tty from anyone calling his kernel API, which
+ * meets customer requirements in the drivers/misc/pti.c
+ * project.  So he needs to know when he can and cannot write when
+ * the API is called. In theory, the API can be called
+ * after an init() but before a successful open() which
+ * would crash the system if tty is not checked.
+ */
+static struct tty_struct *this_tty;
+static DEFINE_MUTEX(writelock);
+
+/**
+ * n_tracesink_open() - Called when a tty is opened by a SW entity.
+ * @tty: terminal device to the ldisc.
+ *
+ * Return:
+ *      0 for success,
+ *      -EFAULT = couldn't get a tty kref n_tracesink will sit
+ *       on top of
+ *      -EEXIST = open() called successfully once and it cannot
+ *      be called again.
+ *
+ * Caveats: open() should only be successful the first time a
+ * SW entity calls it.
+ */
+static int n_tracesink_open(struct tty_struct *tty)
+{
+	int retval = -EEXIST;
+
+	mutex_lock(&writelock);
+	if (this_tty == NULL) {
+
+		this_tty = tty_kref_get(tty);
+
+		if (this_tty == NULL)
+			retval = -EFAULT;
+		else {
+			tty->disc_data = this_tty;
+			tty_driver_flush_buffer(tty);
+			retval = 0;
+		}
+	}
+	mutex_unlock(&writelock);
+
+	return retval;
+}
+
+/**
+ * n_tracesink_close() - close connection
+ * @tty: terminal device to the ldisc.
+ *
+ * Called when a software entity wants to close a connection.
+ */
+static void n_tracesink_close(struct tty_struct *tty)
+{
+
+	mutex_lock(&writelock);
+	tty_driver_flush_buffer(tty);
+	tty_kref_put(this_tty);
+	this_tty = NULL;
+	tty->disc_data = NULL;
+	mutex_unlock(&writelock);
+
+}
+
+/**
+ * n_tracesink_read() - read request from user space
+ * @tty:  terminal device passed into the ldisc.
+ * @file: pointer to open file object.
+ * @buf:  pointer to the data buffer that gets eventually returned.
+ * @nr:   number of bytes of the data buffer that is returned.
+ *
+ * function that allows read() functionality in userspace. By default if this
+ * is not implemented it returns -EIO. This module is functioning like a
+ * router via n_tracesink_receivebuf(), and there is no real requirement
+ * to implement this function. However, an error return value other than
+ * -EIO should be used just to show that there was an intent not to have
+ * this function implemented.  Return value based on read() man pages.
+ *
+ * Return:
+ *	 -EINVAL
+ */
+static ssize_t n_tracesink_read(struct tty_struct *tty, struct file *file,
+				unsigned char __user *buf, size_t nr) {
+	return -EINVAL;
+}
+
+/**
+ * n_tracesink_write() - Function that allows write() in userspace.
+ * @tty:  terminal device passed into the ldisc.
+ * @file: pointer to open file object.
+ * @buf:  pointer to the data buffer that gets eventually returned.
+ * @nr:   number of bytes of the data buffer that is returned.
+ *
+ * By default if this is not implemented, it returns -EIO.
+ * This should not be implemented, ever, because
+ * 1. this driver is functioning like a router via
+ *    n_tracesink_receivebuf()
+ * 2. No writes to HW will ever go through this line discpline driver.
+ * However, an error return value other than -EIO should be used
+ * just to show that there was an intent not to have this function
+ * implemented.  Return value based on write() man pages.
+ *
+ * Return:
+ *	-EINVAL
+ */
+static ssize_t n_tracesink_write(struct tty_struct *tty, struct file *file,
+				 const unsigned char *buf, size_t nr) {
+	return -EINVAL;
+}
+
+/**
+ * n_tracesink_datadrain() - Kernel API function used to route
+ *			     trace debugging data to user-defined
+ *			     port like USB.
+ *
+ * @buf:   Trace debuging data buffer to write to tty target
+ *         port. Null value will return with no write occurring.
+ * @count: Size of buf. Value of 0 or a negative number will
+ *         return with no write occuring.
+ *
+ * Caveat: If this line discipline does not set the tty it sits
+ * on top of via an open() call, this API function will not
+ * call the tty's write() call because it will have no pointer
+ * to call the write().
+ */
+void n_tracesink_datadrain(u8 *buf, int count)
+{
+	mutex_lock(&writelock);
+
+	if ((buf != NULL) && (count > 0) && (this_tty != NULL))
+		this_tty->ops->write(this_tty, buf, count);
+
+	mutex_unlock(&writelock);
+}
+EXPORT_SYMBOL_GPL(n_tracesink_datadrain);
+
+/*
+ * Flush buffer is not impelemented as the ldisc has no internal buffering
+ * so the tty_driver_flush_buffer() is sufficient for this driver's needs.
+ */
+
+/*
+ * tty_ldisc function operations for this driver.
+ */
+static struct tty_ldisc_ops tty_n_tracesink = {
+	.owner		= THIS_MODULE,
+	.magic		= TTY_LDISC_MAGIC,
+	.name		= DRIVERNAME,
+	.open		= n_tracesink_open,
+	.close		= n_tracesink_close,
+	.read		= n_tracesink_read,
+	.write		= n_tracesink_write
+};
+
+/**
+ * n_tracesink_init-	module initialisation
+ *
+ * Registers this module as a line discipline driver.
+ *
+ * Return:
+ *	0 for success, any other value error.
+ */
+static int __init n_tracesink_init(void)
+{
+	int retval;
+
+	/* Note N_TRACESINK is defined in linux/tty.h */
+	retval = tty_register_ldisc(N_TRACESINK, &tty_n_tracesink);
+
+	if (retval < 0)
+		pr_err("%s: Registration failed: %d\n", __func__, retval);
+
+	return retval;
+}
+
+/**
+ * n_tracesink_exit -	module unload
+ *
+ * Removes this module as a line discipline driver.
+ */
+static void __exit n_tracesink_exit(void)
+{
+	int retval;
+
+	retval = tty_unregister_ldisc(N_TRACESINK);
+
+	if (retval < 0)
+		pr_err("%s: Unregistration failed: %d\n", __func__,  retval);
+}
+
+module_init(n_tracesink_init);
+module_exit(n_tracesink_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Jay Freyensee");
+MODULE_ALIAS_LDISC(N_TRACESINK);
+MODULE_DESCRIPTION("Trace sink ldisc driver");
diff --git a/drivers/tty/n_tracesink.h b/drivers/tty/n_tracesink.h
new file mode 100644
index 0000000..a68bb44
--- /dev/null
+++ b/drivers/tty/n_tracesink.h
@@ -0,0 +1,36 @@
+/*
+ *  n_tracesink.h - Kernel driver API to route trace data in kernel space.
+ *
+ *  Copyright (C) Intel 2011
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
+ * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+ *
+ * The PTI (Parallel Trace Interface) driver directs trace data routed from
+ * various parts in the system out through the Intel Penwell PTI port and
+ * out of the mobile device for analysis with a debugging tool
+ * (Lauterbach, Fido). This is part of a solution for the MIPI P1149.7,
+ * compact JTAG, standard.
+ *
+ * This header file is used by n_tracerouter to be able to send the
+ * data of it's tty port to the tty port this module sits.  This
+ * mechanism can also be used independent of the PTI module.
+ *
+ */
+
+#ifndef N_TRACESINK_H_
+#define N_TRACESINK_H_
+
+void n_tracesink_datadrain(u8 *buf, int count);
+
+#endif
diff --git a/include/linux/tty.h b/include/linux/tty.h
index 9f469c7..fbf17de 100644
--- a/include/linux/tty.h
+++ b/include/linux/tty.h
@@ -50,6 +50,8 @@
 #define N_CAIF		20      /* CAIF protocol for talking to modems */
 #define N_GSM0710	21	/* GSM 0710 Mux */
 #define N_TI_WL		22	/* for TI's WL BT, FM, GPS combo chips */
+#define N_TRACESINK	23	/* Trace data routing for MIPI P1149.7 */
+#define N_TRACEROUTER	24	/* Trace data routing for MIPI P1149.7 */
 
 /*
  * This character is the same as _POSIX_VDISABLE: it cannot be used as
-- 
1.7.2.3

