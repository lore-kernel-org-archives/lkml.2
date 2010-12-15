Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755006Ab0LOSz6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 13:55:58 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:15229 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754682Ab0LOSyu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 13:54:50 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6198"; a="66752273"
From: Niranjana Vishwanathapura <nvishwan@codeaurora.org>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Cc: linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Niranjana Vishwanathapura <nvishwan@codeaurora.org>,
        San Mehat <san@android.com>
Subject: [PATCH 2/5] msm: rpc: Add userspace rpc support.
Date: Wed, 15 Dec 2010 10:54:07 -0800
Message-Id: <1292439250-11985-3-git-send-email-nvishwan@codeaurora.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1292439250-11985-1-git-send-email-nvishwan@codeaurora.org>
References: <1292439250-11985-1-git-send-email-nvishwan@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow rpc clients in userspace to communicate with
rpc server in remote processor.

Cc: San Mehat <san@android.com>
Signed-off-by: Niranjana Vishwanathapura <nvishwan@codeaurora.org>
---
 drivers/misc/Makefile                   |    1 +
 drivers/misc/msm_smd_rpcrouter.c        |   53 ++---
 drivers/misc/msm_smd_rpcrouter.h        |   18 ++
 drivers/misc/msm_smd_rpcrouter_device.c |  347 +++++++++++++++++++++++++++++++
 include/linux/msm_rpcrouter.h           |   36 ++++
 5 files changed, 426 insertions(+), 29 deletions(-)
 create mode 100644 drivers/misc/msm_smd_rpcrouter_device.c
 create mode 100644 include/linux/msm_rpcrouter.h

diff --git a/drivers/misc/Makefile b/drivers/misc/Makefile
index 3bb65b1..d7a00e4 100644
--- a/drivers/misc/Makefile
+++ b/drivers/misc/Makefile
@@ -43,3 +43,4 @@ obj-$(CONFIG_PCH_PHUB)		+= pch_phub.o
 obj-y				+= ti-st/
 obj-$(CONFIG_AB8500_PWM)	+= ab8500-pwm.o
 obj-$(CONFIG_MSM_ONCRPCROUTER)	+= msm_smd_rpcrouter.o
+obj-$(CONFIG_MSM_ONCRPCROUTER)	+= msm_smd_rpcrouter_device.o
diff --git a/drivers/misc/msm_smd_rpcrouter.c b/drivers/misc/msm_smd_rpcrouter.c
index c0aed22..eaaf79e 100644
--- a/drivers/misc/msm_smd_rpcrouter.c
+++ b/drivers/misc/msm_smd_rpcrouter.c
@@ -106,9 +106,6 @@ static struct platform_device rpcrouter_pdev = {
 	.id		= -1,
 };
 
-static int __msm_rpc_read(struct msm_rpc_endpoint *ept,
-			  struct rr_fragment **frag,
-			  unsigned len, long timeout);
 
 static int rpcrouter_send_control_msg(union rr_control_msg *msg)
 {
@@ -153,6 +150,7 @@ static struct rr_server *rpcrouter_create_server(uint32_t pid,
 {
 	struct rr_server *server;
 	unsigned long flags;
+	int rc;
 
 	server = kzalloc(sizeof(struct rr_server), GFP_KERNEL);
 	if (!server)
@@ -167,7 +165,18 @@ static struct rr_server *rpcrouter_create_server(uint32_t pid,
 	list_add_tail(&server->list, &server_list);
 	spin_unlock_irqrestore(&server_list_lock, flags);
 
+	if (pid == RPCROUTER_PID_REMOTE) {
+		rc = msm_rpcrouter_create_server_cdev(server);
+		if (rc < 0)
+			goto out_fail;
+	}
 	return server;
+out_fail:
+	spin_lock_irqsave(&server_list_lock, flags);
+	list_del(&server->list);
+	spin_unlock_irqrestore(&server_list_lock, flags);
+	kfree(server);
+	return ERR_PTR(rc);
 }
 
 static void rpcrouter_destroy_server(struct rr_server *server)
@@ -177,6 +186,7 @@ static void rpcrouter_destroy_server(struct rr_server *server)
 	spin_lock_irqsave(&server_list_lock, flags);
 	list_del(&server->list);
 	spin_unlock_irqrestore(&server_list_lock, flags);
+	device_destroy(msm_rpcrouter_class, server->device_number);
 	kfree(server);
 }
 
@@ -234,7 +244,7 @@ struct msm_rpc_endpoint *msm_rpcrouter_create_local_endpoint(dev_t dev)
 	ept->pid = RPCROUTER_PID_LOCAL;
 	ept->dev = dev;
 
-	if (dev != MKDEV(0, 0)) {
+	if ((dev != msm_rpcrouter_devno) && (dev != MKDEV(0, 0))) {
 		struct rr_server *srv;
 		/*
 		 * This is a userspace client which opened
@@ -484,27 +494,6 @@ static void do_create_rpcrouter_pdev(struct work_struct *work)
 	platform_device_register(&rpcrouter_pdev);
 }
 
-/* for backward compatible version type (31st bit cleared)
- * clearing minor number (lower 16 bits) in device name
- * is neccessary for driver binding
- */
-static int msm_rpcrouter_create_server_pdev(struct rr_server *server)
-{
-	sprintf(server->pdev_name, "rs%.8x:%.8x",
-		server->prog,
-		(server->vers & RPC_VERSION_MODE_MASK) ? server->vers :
-		(server->vers & RPC_VERSION_MAJOR_MASK));
-
-	server->p_device.base.id = -1;
-	server->p_device.base.name = server->pdev_name;
-
-	server->p_device.prog = server->prog;
-	server->p_device.vers = server->vers;
-
-	platform_device_register(&server->p_device.base);
-	return 0;
-}
-
 static void do_create_pdevs(struct work_struct *work)
 {
 	unsigned long flags;
@@ -1042,9 +1031,9 @@ static inline int ept_packet_available(struct msm_rpc_endpoint *ept)
 	return ret;
 }
 
-static int __msm_rpc_read(struct msm_rpc_endpoint *ept,
-			  struct rr_fragment **frag_ret,
-			  unsigned len, long timeout)
+int __msm_rpc_read(struct msm_rpc_endpoint *ept,
+		   struct rr_fragment **frag_ret,
+		   unsigned len, long timeout)
 {
 	struct rr_packet *pkt;
 	struct rpc_request_hdr *rq;
@@ -1222,15 +1211,21 @@ static int msm_rpcrouter_probe(struct platform_device *pdev)
 	if (!rpcrouter_workqueue)
 		return -ENOMEM;
 
+	rc = msm_rpcrouter_init_devices();
+	if (rc < 0)
+		goto fail_destroy_workqueue;
+
 	/* Open up SMD channel 2 */
 	initialized = 0;
 	rc = smd_open("SMD_RPCCALL", &smd_channel, NULL, rpcrouter_smdnotify);
 	if (rc < 0)
-		goto fail_destroy_workqueue;
+		goto fail_remove_devices;
 
 	queue_work(rpcrouter_workqueue, &work_read_data);
 	return 0;
 
+fail_remove_devices:
+	msm_rpcrouter_exit_devices();
 fail_destroy_workqueue:
 	destroy_workqueue(rpcrouter_workqueue);
 	return rc;
diff --git a/drivers/misc/msm_smd_rpcrouter.h b/drivers/misc/msm_smd_rpcrouter.h
index 4d3adeb..dd915f5 100644
--- a/drivers/misc/msm_smd_rpcrouter.h
+++ b/drivers/misc/msm_smd_rpcrouter.h
@@ -181,4 +181,22 @@ struct msm_rpc_endpoint {
 	dev_t dev;
 };
 
+/* shared between smd_rpcrouter*.c */
+
+int __msm_rpc_read(struct msm_rpc_endpoint *ept,
+		   struct rr_fragment **frag,
+		   unsigned len, long timeout);
+
+struct msm_rpc_endpoint *msm_rpcrouter_create_local_endpoint(dev_t dev);
+int msm_rpcrouter_destroy_local_endpoint(struct msm_rpc_endpoint *ept);
+
+int msm_rpcrouter_create_server_cdev(struct rr_server *server);
+int msm_rpcrouter_create_server_pdev(struct rr_server *server);
+
+int msm_rpcrouter_init_devices(void);
+void msm_rpcrouter_exit_devices(void);
+
+extern dev_t msm_rpcrouter_devno;
+extern struct class *msm_rpcrouter_class;
+
 #endif /* _MSM_SMD_RPCROUTER_H */
diff --git a/drivers/misc/msm_smd_rpcrouter_device.c b/drivers/misc/msm_smd_rpcrouter_device.c
new file mode 100644
index 0000000..840f20d
--- /dev/null
+++ b/drivers/misc/msm_smd_rpcrouter_device.c
@@ -0,0 +1,347 @@
+/* drivers/misc/msm_smd_rpcrouter_device.c
+ *
+ * Copyright (C) 2007 Google, Inc.
+ * Copyright (c) 2010, Code Aurora Forum. All rights reserved.
+ * Author: San Mehat <san@android.com>
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.	 See the
+ * GNU General Public License for more details.
+ *
+ */
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/string.h>
+#include <linux/errno.h>
+#include <linux/cdev.h>
+#include <linux/init.h>
+#include <linux/device.h>
+#include <linux/types.h>
+#include <linux/delay.h>
+#include <linux/fs.h>
+#include <linux/err.h>
+#include <linux/sched.h>
+#include <linux/slab.h>
+#include <linux/poll.h>
+#include <linux/platform_device.h>
+#include <linux/uaccess.h>
+#include <linux/msm_rpcrouter.h>
+
+#include <asm/byteorder.h>
+
+#include "msm_smd_rpcrouter.h"
+
+#define SAFETY_MEM_SIZE 65536
+
+/* Next minor # available for a remote server */
+static int next_minor = 1;
+
+struct class *msm_rpcrouter_class;
+dev_t msm_rpcrouter_devno;
+
+static struct cdev rpcrouter_cdev;
+static struct device *rpcrouter_device;
+
+static int rpcrouter_open(struct inode *inode, struct file *filp)
+{
+	int rc;
+	struct msm_rpc_endpoint *ept;
+
+	rc = nonseekable_open(inode, filp);
+	if (rc < 0)
+		return rc;
+
+	ept = msm_rpcrouter_create_local_endpoint(inode->i_rdev);
+	if (!ept)
+		return -ENOMEM;
+
+	filp->private_data = ept;
+	return 0;
+}
+
+static int rpcrouter_release(struct inode *inode, struct file *filp)
+{
+	struct msm_rpc_endpoint *ept;
+	ept = (struct msm_rpc_endpoint *) filp->private_data;
+
+	return msm_rpcrouter_destroy_local_endpoint(ept);
+}
+
+static ssize_t rpcrouter_read(struct file *filp, char __user *buf,
+			      size_t count, loff_t *ppos)
+{
+	struct msm_rpc_endpoint *ept;
+	struct rr_fragment *frag, *next;
+	int rc;
+
+	ept = (struct msm_rpc_endpoint *) filp->private_data;
+
+	rc = __msm_rpc_read(ept, &frag, count, -1);
+	if (rc < 0)
+		return rc;
+
+	count = rc;
+
+	while (frag != NULL) {
+		if (copy_to_user(buf, frag->data, frag->length)) {
+			printk(KERN_ERR "rpcrouter: "
+			       "could not copy all read data to user!\n");
+			rc = -EFAULT;
+		}
+		buf += frag->length;
+		next = frag->next;
+		kfree(frag);
+		frag = next;
+	}
+
+	return rc;
+}
+
+static ssize_t rpcrouter_write(struct file *filp, const char __user *buf,
+				size_t count, loff_t *ppos)
+{
+	struct msm_rpc_endpoint	*ept;
+	int rc = 0;
+	void *k_buffer;
+
+	ept = (struct msm_rpc_endpoint *) filp->private_data;
+
+	/* A check for safety, this seems non-standard */
+	if (count > SAFETY_MEM_SIZE)
+		return -EINVAL;
+
+	k_buffer = kmalloc(count, GFP_KERNEL);
+	if (!k_buffer)
+		return -ENOMEM;
+
+	if (copy_from_user(k_buffer, buf, count)) {
+		rc = -EFAULT;
+		goto write_out_free;
+	}
+
+	rc = msm_rpc_write(ept, k_buffer, count);
+	if (rc < 0)
+		goto write_out_free;
+
+	rc = count;
+write_out_free:
+	kfree(k_buffer);
+	return rc;
+}
+
+static unsigned int rpcrouter_poll(struct file *filp,
+				   struct poll_table_struct *wait)
+{
+	struct msm_rpc_endpoint *ept;
+	unsigned mask = 0;
+	ept = (struct msm_rpc_endpoint *) filp->private_data;
+
+	/* If there's data already in the read queue, return POLLIN.
+	 * Else, wait for the requested amount of time, and check again.
+	 */
+
+	if (!list_empty(&ept->read_q))
+		mask |= POLLIN;
+
+	if (!mask) {
+		poll_wait(filp, &ept->wait_q, wait);
+		if (!list_empty(&ept->read_q))
+			mask |= POLLIN;
+	}
+
+	return mask;
+}
+
+static long rpcrouter_ioctl(struct file *filp, unsigned int cmd,
+			    unsigned long arg)
+{
+	struct msm_rpc_endpoint *ept;
+	int rc = 0;
+	uint32_t n;
+
+	ept = (struct msm_rpc_endpoint *) filp->private_data;
+	switch (cmd) {
+
+	case RPC_ROUTER_IOCTL_GET_VERSION:
+		n = RPC_ROUTER_VERSION_V1;
+		rc = put_user(n, (unsigned int *) arg);
+		break;
+
+	case RPC_ROUTER_IOCTL_GET_MTU:
+		/* the pacmark word reduces the actual payload
+		 * possible per message
+		 */
+		n = RPCROUTER_MSGSIZE_MAX - sizeof(uint32_t);
+		rc = put_user(n, (unsigned int *) arg);
+		break;
+
+	case RPC_ROUTER_IOCTL_GET_MINOR_VERSION:
+		n = MSM_RPC_GET_MINOR(msm_rpc_get_vers(ept));
+		rc = put_user(n, (unsigned int *)arg);
+		break;
+
+	default:
+		rc = -EINVAL;
+		break;
+	}
+
+	return rc;
+}
+
+static const struct file_operations rpcrouter_server_fops = {
+	.owner	 = THIS_MODULE,
+	.open	 = rpcrouter_open,
+	.release = rpcrouter_release,
+	.read	 = rpcrouter_read,
+	.write	 = rpcrouter_write,
+	.poll    = rpcrouter_poll,
+	.unlocked_ioctl	 = rpcrouter_ioctl,
+};
+
+static const struct file_operations rpcrouter_router_fops = {
+	.owner	 = THIS_MODULE,
+	.open	 = rpcrouter_open,
+	.release = rpcrouter_release,
+	.read	 = rpcrouter_read,
+	.write	 = rpcrouter_write,
+	.poll    = rpcrouter_poll,
+	.unlocked_ioctl = rpcrouter_ioctl,
+};
+
+int msm_rpcrouter_create_server_cdev(struct rr_server *server)
+{
+	int rc;
+	uint32_t dev_vers;
+
+	if (next_minor == RPCROUTER_MAX_REMOTE_SERVERS) {
+		printk(KERN_ERR
+		       "rpcrouter: Minor numbers exhausted - Increase "
+		       "RPCROUTER_MAX_REMOTE_SERVERS\n");
+		return -ENOBUFS;
+	}
+
+	/* Servers with bit 31 set are remote msm servers with hashkey version.
+	 * Servers with bit 31 not set are remote msm servers with
+	 * backwards compatible version type in which case the minor number
+	 * (lower 16 bits) is set to zero.
+	 *
+	 */
+	if ((server->vers & RPC_VERSION_MODE_MASK))
+		dev_vers = server->vers;
+	else
+		dev_vers = server->vers & RPC_VERSION_MAJOR_MASK;
+
+	server->device_number =
+		MKDEV(MAJOR(msm_rpcrouter_devno), next_minor++);
+
+	server->device =
+		device_create(msm_rpcrouter_class, rpcrouter_device,
+			      server->device_number, NULL, "%.8x:%.8x",
+			      server->prog, dev_vers);
+	if (IS_ERR(server->device)) {
+		printk(KERN_ERR
+		       "rpcrouter: Unable to create device (%ld)\n",
+		       PTR_ERR(server->device));
+		return PTR_ERR(server->device);;
+	}
+
+	cdev_init(&server->cdev, &rpcrouter_server_fops);
+	server->cdev.owner = THIS_MODULE;
+
+	rc = cdev_add(&server->cdev, server->device_number, 1);
+	if (rc < 0) {
+		printk(KERN_ERR
+		       "rpcrouter: Unable to add chrdev (%d)\n", rc);
+		device_destroy(msm_rpcrouter_class, server->device_number);
+		return rc;
+	}
+	return 0;
+}
+
+/* for backward compatible version type (31st bit cleared)
+ * clearing minor number (lower 16 bits) in device name
+ * is neccessary for driver binding
+ */
+int msm_rpcrouter_create_server_pdev(struct rr_server *server)
+{
+	sprintf(server->pdev_name, "rs%.8x:%.8x",
+		server->prog,
+		(server->vers & RPC_VERSION_MODE_MASK) ? server->vers :
+		(server->vers & RPC_VERSION_MAJOR_MASK));
+
+	server->p_device.base.id = -1;
+	server->p_device.base.name = server->pdev_name;
+
+	server->p_device.prog = server->prog;
+	server->p_device.vers = server->vers;
+
+	platform_device_register(&server->p_device.base);
+	return 0;
+}
+
+int msm_rpcrouter_init_devices(void)
+{
+	int rc;
+	int major;
+
+	/* Create the device nodes */
+	msm_rpcrouter_class = class_create(THIS_MODULE, "oncrpc");
+	if (IS_ERR(msm_rpcrouter_class)) {
+		rc = -ENOMEM;
+		printk(KERN_ERR
+		       "rpcrouter: failed to create oncrpc class\n");
+		goto fail;
+	}
+
+	rc = alloc_chrdev_region(&msm_rpcrouter_devno, 0,
+				 RPCROUTER_MAX_REMOTE_SERVERS + 1,
+				 "oncrpc");
+	if (rc < 0) {
+		printk(KERN_ERR
+		       "rpcrouter: Failed to alloc chardev region (%d)\n", rc);
+		goto fail_destroy_class;
+	}
+
+	major = MAJOR(msm_rpcrouter_devno);
+	rpcrouter_device = device_create(msm_rpcrouter_class, NULL,
+					 msm_rpcrouter_devno, NULL, "%.8x:%d",
+					 0, 0);
+	if (IS_ERR(rpcrouter_device)) {
+		rc = -ENOMEM;
+		goto fail_unregister_cdev_region;
+	}
+
+	cdev_init(&rpcrouter_cdev, &rpcrouter_router_fops);
+	rpcrouter_cdev.owner = THIS_MODULE;
+
+	rc = cdev_add(&rpcrouter_cdev, msm_rpcrouter_devno, 1);
+	if (rc < 0)
+		goto fail_destroy_device;
+
+	return 0;
+
+fail_destroy_device:
+	device_destroy(msm_rpcrouter_class, msm_rpcrouter_devno);
+fail_unregister_cdev_region:
+	unregister_chrdev_region(msm_rpcrouter_devno,
+				 RPCROUTER_MAX_REMOTE_SERVERS + 1);
+fail_destroy_class:
+	class_destroy(msm_rpcrouter_class);
+fail:
+	return rc;
+}
+
+void msm_rpcrouter_exit_devices(void)
+{
+	cdev_del(&rpcrouter_cdev);
+	device_destroy(msm_rpcrouter_class, msm_rpcrouter_devno);
+	unregister_chrdev_region(msm_rpcrouter_devno,
+				 RPCROUTER_MAX_REMOTE_SERVERS + 1);
+	class_destroy(msm_rpcrouter_class);
+}
+
diff --git a/include/linux/msm_rpcrouter.h b/include/linux/msm_rpcrouter.h
new file mode 100644
index 0000000..e6749ac
--- /dev/null
+++ b/include/linux/msm_rpcrouter.h
@@ -0,0 +1,36 @@
+/* include/linux/msm_rpcrouter.h
+ *
+ * Copyright (C) 2007 Google, Inc.
+ * Copyright (c) 2010, Code Aurora Forum. All rights reserved.
+ * Author: San Mehat <san@android.com>
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+#ifndef __LINUX_MSM_RPCROUTER_H
+#define __LINUX_MSM_RPCROUTER_H
+
+#include <linux/types.h>
+#include <linux/ioctl.h>
+
+#define RPC_ROUTER_VERSION_V1 0x00010000
+
+#define RPC_ROUTER_IOCTL_MAGIC (0xC1)
+
+#define RPC_ROUTER_IOCTL_GET_VERSION \
+	_IOR(RPC_ROUTER_IOCTL_MAGIC, 0, unsigned int)
+
+#define RPC_ROUTER_IOCTL_GET_MTU \
+	_IOR(RPC_ROUTER_IOCTL_MAGIC, 1, unsigned int)
+
+#define RPC_ROUTER_IOCTL_GET_MINOR_VERSION \
+	_IOW(RPC_ROUTER_IOCTL_MAGIC, 2, unsigned int)
+
+#endif /* __LINUX_MSM_RPCROUTER_H */
-- 
1.5.6.3

Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
