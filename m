Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754942Ab0LOSzM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 13:55:12 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:50446 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754868Ab0LOSy4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 13:54:56 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6198"; a="66961178"
From: Niranjana Vishwanathapura <nvishwan@codeaurora.org>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Cc: linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Niranjana Vishwanathapura <nvishwan@codeaurora.org>,
        San Mehat <san@android.com>
Subject: [PATCH 1/5] msm: rpc: shared memory rpc router
Date: Wed, 15 Dec 2010 10:54:06 -0800
Message-Id: <1292439250-11985-2-git-send-email-nvishwan@codeaurora.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1292439250-11985-1-git-send-email-nvishwan@codeaurora.org>
References: <1292439250-11985-1-git-send-email-nvishwan@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The RPC router provides access to the RPC services running on
the baseband core from kernel.

Cc: San Mehat <san@android.com>
Signed-off-by: Niranjana Vishwanathapura <nvishwan@codeaurora.org>
---
 drivers/misc/Kconfig             |    8 +
 drivers/misc/Makefile            |    1 +
 drivers/misc/msm_rpcrouter.h     |  151 +++++
 drivers/misc/msm_smd_rpcrouter.c | 1255 ++++++++++++++++++++++++++++++++++++++
 drivers/misc/msm_smd_rpcrouter.h |  184 ++++++
 5 files changed, 1599 insertions(+), 0 deletions(-)
 create mode 100644 drivers/misc/msm_rpcrouter.h
 create mode 100644 drivers/misc/msm_smd_rpcrouter.c
 create mode 100644 drivers/misc/msm_smd_rpcrouter.h

diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
index 4d073f1..651836d 100644
--- a/drivers/misc/Kconfig
+++ b/drivers/misc/Kconfig
@@ -452,6 +452,14 @@ config PCH_PHUB
 	  To compile this driver as a module, choose M here: the module will
 	  be called pch_phub.
 
+config MSM_ONCRPCROUTER
+	depends on MSM_SMD
+	default n
+	bool "MSM ONCRPC router support"
+	help
+	  Support for the MSM ONCRPC router for rpc communitation with
+	  baseband processor.
+
 source "drivers/misc/c2port/Kconfig"
 source "drivers/misc/eeprom/Kconfig"
 source "drivers/misc/cb710/Kconfig"
diff --git a/drivers/misc/Makefile b/drivers/misc/Makefile
index 98009cc..3bb65b1 100644
--- a/drivers/misc/Makefile
+++ b/drivers/misc/Makefile
@@ -42,3 +42,4 @@ obj-$(CONFIG_ARM_CHARLCD)	+= arm-charlcd.o
 obj-$(CONFIG_PCH_PHUB)		+= pch_phub.o
 obj-y				+= ti-st/
 obj-$(CONFIG_AB8500_PWM)	+= ab8500-pwm.o
+obj-$(CONFIG_MSM_ONCRPCROUTER)	+= msm_smd_rpcrouter.o
diff --git a/drivers/misc/msm_rpcrouter.h b/drivers/misc/msm_rpcrouter.h
new file mode 100644
index 0000000..935e714
--- /dev/null
+++ b/drivers/misc/msm_rpcrouter.h
@@ -0,0 +1,151 @@
+/** drivers/misc/msm_rpcrouter.h
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
+
+#ifndef _MSM_RPCROUTER_H
+#define _MSM_RPCROUTER_H
+
+#include <linux/types.h>
+#include <linux/list.h>
+#include <linux/platform_device.h>
+
+/* RPC API version structure
+ * Version bit 31 : 1->hashkey versioning,
+ *                  0->major-minor (backward compatible) versioning
+ * hashkey versioning:
+ *   Version bits 31-0 hashkey
+ * major-minor (backward compatible) versioning
+ *   Version bits 30-28 reserved (no match)
+ *   Version bits 27-16 major (must match)
+ *   Version bits 15-0  minor (greater or equal)
+ */
+#define RPC_VERSION_MODE_MASK  0x80000000
+#define RPC_VERSION_MAJOR_MASK 0x0fff0000
+#define RPC_VERSION_MAJOR_OFFSET 16
+#define RPC_VERSION_MINOR_MASK 0x0000ffff
+
+#define MSM_RPC_VERS(major, minor)					\
+	((uint32_t)((((major) << RPC_VERSION_MAJOR_OFFSET) &		\
+		RPC_VERSION_MAJOR_MASK) |				\
+	((minor) & RPC_VERSION_MINOR_MASK)))
+#define MSM_RPC_GET_MAJOR(vers) (((vers) & RPC_VERSION_MAJOR_MASK) >>	\
+					RPC_VERSION_MAJOR_OFFSET)
+#define MSM_RPC_GET_MINOR(vers) ((vers) & RPC_VERSION_MINOR_MASK)
+
+struct msm_rpc_endpoint;
+
+struct rpcsvr_platform_device {
+	struct platform_device base;
+	uint32_t prog;
+	uint32_t vers;
+};
+
+#define RPC_DATA_IN	0
+/*
+ * Structures for sending / receiving direct RPC requests
+ * XXX: Any cred/verif lengths > 0 not supported
+ */
+
+struct rpc_request_hdr {
+	uint32_t xid;
+	uint32_t type;	/* 0 */
+	uint32_t rpc_vers; /* 2 */
+	uint32_t prog;
+	uint32_t vers;
+	uint32_t procedure;
+	uint32_t cred_flavor;
+	uint32_t cred_length;
+	uint32_t verf_flavor;
+	uint32_t verf_length;
+};
+
+struct rpc_reply_progmismatch_data {
+	uint32_t low;
+	uint32_t high;
+};
+
+struct rpc_denied_reply_hdr {
+};
+
+struct rpc_accepted_reply_hdr {
+	uint32_t verf_flavor;
+	uint32_t verf_length;
+	uint32_t accept_stat;
+#define RPC_ACCEPTSTAT_SUCCESS 0
+#define RPC_ACCEPTSTAT_PROG_UNAVAIL 1
+#define RPC_ACCEPTSTAT_PROG_MISMATCH 2
+#define RPC_ACCEPTSTAT_PROC_UNAVAIL 3
+#define RPC_ACCEPTSTAT_GARBAGE_ARGS 4
+#define RPC_ACCEPTSTAT_SYSTEM_ERR 5
+#define RPC_ACCEPTSTAT_PROG_LOCKED 6
+	/*
+	 * Following data is dependant on accept_stat
+	 * If ACCEPTSTAT == PROG_MISMATCH then there is a
+	 * 'rpc_reply_progmismatch_data' structure following the header.
+	 * Otherwise the data is procedure specific
+	 */
+};
+
+struct rpc_reply_hdr {
+	uint32_t xid;
+	uint32_t type;
+	uint32_t reply_stat;
+#define RPCMSG_REPLYSTAT_ACCEPTED 0
+#define RPCMSG_REPLYSTAT_DENIED 1
+	union {
+		struct rpc_accepted_reply_hdr acc_hdr;
+		struct rpc_denied_reply_hdr dny_hdr;
+	} data;
+};
+
+/* flags for msm_rpc_connect() */
+#define MSM_RPC_UNINTERRUPTIBLE 0x0001
+#define MSM_RPC_ENABLE_RECEIVE (0x10000)
+
+/* use IS_ERR() to check for failure */
+struct msm_rpc_endpoint *msm_rpc_open(void);
+/* Connect with the specified server version */
+struct msm_rpc_endpoint *msm_rpc_connect(uint32_t prog, uint32_t vers,
+					 unsigned flags);
+uint32_t msm_rpc_get_vers(struct msm_rpc_endpoint *ept);
+/* check if server version can handle client requested version */
+int msm_rpc_is_compatible_version(uint32_t server_version,
+				  uint32_t client_version);
+
+int msm_rpc_close(struct msm_rpc_endpoint *ept);
+int msm_rpc_write(struct msm_rpc_endpoint *ept,
+		  void *data, int len);
+int msm_rpc_read(struct msm_rpc_endpoint *ept,
+		 void **data, unsigned len, long timeout);
+void msm_rpc_setup_req(struct rpc_request_hdr *hdr,
+		       uint32_t prog, uint32_t vers, uint32_t proc);
+
+/* simple blocking rpc call
+ *
+ * request is mandatory and must have a rpc_request_hdr
+ * at the start.  The header will be filled out for you.
+ *
+ * reply provides a buffer for replies of reply_max_size
+ */
+int msm_rpc_call_reply(struct msm_rpc_endpoint *ept, uint32_t proc,
+		       void *request, int request_size,
+		       void *reply, int reply_max_size,
+		       long timeout);
+int msm_rpc_call(struct msm_rpc_endpoint *ept, uint32_t proc,
+		 void *request, int request_size,
+		 long timeout);
+
+#endif /* _MSM_RPCROUTER_H */
diff --git a/drivers/misc/msm_smd_rpcrouter.c b/drivers/misc/msm_smd_rpcrouter.c
new file mode 100644
index 0000000..c0aed22
--- /dev/null
+++ b/drivers/misc/msm_smd_rpcrouter.c
@@ -0,0 +1,1255 @@
+/* drivers/misc/msm_smd_rpcrouter.c
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
+
+/* TODO: handle cases where smd_write() will tempfail due to full fifo */
+/* TODO: thread priority? schedule a work to bump it? */
+/* TODO: maybe make server_list_lock a mutex */
+/* TODO: pool fragments to avoid kmalloc/kfree churn */
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/slab.h>
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
+#include <linux/poll.h>
+#include <linux/uaccess.h>
+#include <asm/byteorder.h>
+#include <linux/platform_device.h>
+#include <linux/uaccess.h>
+
+#include <asm/byteorder.h>
+
+#include <mach/msm_smd.h>
+#include "msm_smd_rpcrouter.h"
+
+#define TRACE_R2R_MSG 0
+#define TRACE_RPC_MSG 0
+#define MSM_RPCROUTER_DEBUG 0
+
+/* Diagnostic messages */
+#define DIAG(x...) printk(KERN_DEBUG "[RR] ERROR " x)
+
+/* Debug messages */
+#if MSM_RPCROUTER_DEBUG
+#define D(x...) printk(KERN_DEBUG x)
+#else
+#define D(x...) do {} while (0)
+#endif
+
+/* Router-to-Router messages */
+#if TRACE_R2R_MSG
+#define RR(x...) printk(KERN_DEBUG "[RR] "x)
+#else
+#define RR(x...) do {} while (0)
+#endif
+
+/* RPC Read/Write (IO) messages */
+#if TRACE_RPC_MSG
+#define IO(x...) printk(KERN_DEBUG "[RPC] "x)
+#else
+#define IO(x...) do {} while (0)
+#endif
+
+static LIST_HEAD(local_endpoints);
+static LIST_HEAD(remote_endpoints);
+
+static LIST_HEAD(server_list);
+
+static smd_channel_t *smd_channel;
+static int initialized;
+static wait_queue_head_t newserver_wait;
+static wait_queue_head_t smd_wait;
+
+static DEFINE_SPINLOCK(local_endpoints_lock);
+static DEFINE_SPINLOCK(remote_endpoints_lock);
+static DEFINE_SPINLOCK(server_list_lock);
+static DEFINE_SPINLOCK(smd_lock);
+
+static struct workqueue_struct *rpcrouter_workqueue;
+static int rpcrouter_need_len;
+
+static atomic_t next_xid = ATOMIC_INIT(1);
+static atomic_t next_mid = ATOMIC_INIT(0);
+
+static void do_read_data(struct work_struct *work);
+static void do_create_pdevs(struct work_struct *work);
+static void do_create_rpcrouter_pdev(struct work_struct *work);
+
+static DECLARE_WORK(work_read_data, do_read_data);
+static DECLARE_WORK(work_create_pdevs, do_create_pdevs);
+static DECLARE_WORK(work_create_rpcrouter_pdev, do_create_rpcrouter_pdev);
+
+static struct platform_device rpcrouter_pdev = {
+	.name		= "oncrpc_router",
+	.id		= -1,
+};
+
+static int __msm_rpc_read(struct msm_rpc_endpoint *ept,
+			  struct rr_fragment **frag,
+			  unsigned len, long timeout);
+
+static int rpcrouter_send_control_msg(union rr_control_msg *msg)
+{
+	struct rr_header hdr;
+	unsigned long flags;
+	int need;
+
+	if (!(msg->cmd == RPCROUTER_CTRL_CMD_HELLO) && !initialized) {
+		printk(KERN_ERR "rpcrouter_send_control_msg(): Warning, "
+		       "router not initialized\n");
+		return -EINVAL;
+	}
+
+	hdr.version = RPCROUTER_VERSION;
+	hdr.type = msg->cmd;
+	hdr.src_pid = RPCROUTER_PID_LOCAL;
+	hdr.src_cid = RPCROUTER_ROUTER_ADDRESS;
+	hdr.confirm_rx = 0;
+	hdr.size = sizeof(*msg);
+	hdr.dst_pid = 0;
+	hdr.dst_cid = RPCROUTER_ROUTER_ADDRESS;
+
+	/* TODO: what if channel is full? */
+
+	need = sizeof(hdr) + hdr.size;
+	spin_lock_irqsave(&smd_lock, flags);
+	while (smd_write_avail(smd_channel) < need) {
+		spin_unlock_irqrestore(&smd_lock, flags);
+		msleep(250);
+		spin_lock_irqsave(&smd_lock, flags);
+	}
+	smd_write(smd_channel, &hdr, sizeof(hdr));
+	smd_write(smd_channel, msg, hdr.size);
+	spin_unlock_irqrestore(&smd_lock, flags);
+	return 0;
+}
+
+static struct rr_server *rpcrouter_create_server(uint32_t pid,
+							uint32_t cid,
+							uint32_t prog,
+							uint32_t ver)
+{
+	struct rr_server *server;
+	unsigned long flags;
+
+	server = kzalloc(sizeof(struct rr_server), GFP_KERNEL);
+	if (!server)
+		return ERR_PTR(-ENOMEM);
+
+	server->pid = pid;
+	server->cid = cid;
+	server->prog = prog;
+	server->vers = ver;
+
+	spin_lock_irqsave(&server_list_lock, flags);
+	list_add_tail(&server->list, &server_list);
+	spin_unlock_irqrestore(&server_list_lock, flags);
+
+	return server;
+}
+
+static void rpcrouter_destroy_server(struct rr_server *server)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&server_list_lock, flags);
+	list_del(&server->list);
+	spin_unlock_irqrestore(&server_list_lock, flags);
+	kfree(server);
+}
+
+static struct rr_server *rpcrouter_lookup_server(uint32_t prog, uint32_t ver)
+{
+	struct rr_server *server;
+	unsigned long flags;
+
+	spin_lock_irqsave(&server_list_lock, flags);
+	list_for_each_entry(server, &server_list, list) {
+		if (server->prog == prog
+		 && server->vers == ver) {
+			spin_unlock_irqrestore(&server_list_lock, flags);
+			return server;
+		}
+	}
+	spin_unlock_irqrestore(&server_list_lock, flags);
+	return NULL;
+}
+
+static struct rr_server *rpcrouter_lookup_server_by_dev(dev_t dev)
+{
+	struct rr_server *server;
+	unsigned long flags;
+
+	spin_lock_irqsave(&server_list_lock, flags);
+	list_for_each_entry(server, &server_list, list) {
+		if (server->device_number == dev) {
+			spin_unlock_irqrestore(&server_list_lock, flags);
+			return server;
+		}
+	}
+	spin_unlock_irqrestore(&server_list_lock, flags);
+	return NULL;
+}
+
+struct msm_rpc_endpoint *msm_rpcrouter_create_local_endpoint(dev_t dev)
+{
+	struct msm_rpc_endpoint *ept;
+	unsigned long flags;
+	int i;
+
+	ept = kmalloc(sizeof(struct msm_rpc_endpoint), GFP_KERNEL);
+	if (!ept)
+		return NULL;
+	memset(ept, 0, sizeof(struct msm_rpc_endpoint));
+
+	/* mark no reply outstanding */
+	ept->next_rroute = 0;
+	spin_lock_init(&ept->rroute_lock);
+	for (i = 0; i < MAX_REPLY_ROUTE; i++)
+		ept->rroute[i].pid = 0xffffffff;
+
+	ept->cid = (uint32_t) ept;
+	ept->pid = RPCROUTER_PID_LOCAL;
+	ept->dev = dev;
+
+	if (dev != MKDEV(0, 0)) {
+		struct rr_server *srv;
+		/*
+		 * This is a userspace client which opened
+		 * a program/ver devicenode. Bind the client
+		 * to that destination
+		 */
+		srv = rpcrouter_lookup_server_by_dev(dev);
+		/* TODO: bug? really? */
+		BUG_ON(!srv);
+
+		ept->dst_pid = srv->pid;
+		ept->dst_cid = srv->cid;
+		ept->dst_prog = cpu_to_be32(srv->prog);
+		ept->dst_vers = cpu_to_be32(srv->vers);
+		ept->flags |= MSM_RPC_ENABLE_RECEIVE;
+
+		D("Creating local ept %p @ %08x:%08x\n",
+		  ept, srv->prog, srv->vers);
+	} else {
+		/* mark not connected */
+		ept->dst_pid = 0xffffffff;
+		D("Creating a master local ept %p\n", ept);
+	}
+
+	init_waitqueue_head(&ept->wait_q);
+	INIT_LIST_HEAD(&ept->read_q);
+	spin_lock_init(&ept->read_q_lock);
+	INIT_LIST_HEAD(&ept->incomplete);
+
+	spin_lock_irqsave(&local_endpoints_lock, flags);
+	list_add_tail(&ept->list, &local_endpoints);
+	spin_unlock_irqrestore(&local_endpoints_lock, flags);
+	return ept;
+}
+
+int msm_rpcrouter_destroy_local_endpoint(struct msm_rpc_endpoint *ept)
+{
+	int rc;
+	union rr_control_msg msg;
+
+	msg.cmd = RPCROUTER_CTRL_CMD_REMOVE_CLIENT;
+	msg.cli.pid = ept->pid;
+	msg.cli.cid = ept->cid;
+
+	RR("x REMOVE_CLIENT id=%d:%08x\n", ept->pid, ept->cid);
+	rc = rpcrouter_send_control_msg(&msg);
+	if (rc < 0)
+		return rc;
+
+	list_del(&ept->list);
+	kfree(ept);
+	return 0;
+}
+
+static int rpcrouter_create_remote_endpoint(uint32_t cid)
+{
+	struct rr_remote_endpoint *new_c;
+	unsigned long flags;
+
+	new_c = kmalloc(sizeof(struct rr_remote_endpoint), GFP_KERNEL);
+	if (!new_c)
+		return -ENOMEM;
+	memset(new_c, 0, sizeof(struct rr_remote_endpoint));
+
+	new_c->cid = cid;
+	new_c->pid = RPCROUTER_PID_REMOTE;
+	init_waitqueue_head(&new_c->quota_wait);
+	spin_lock_init(&new_c->quota_lock);
+
+	spin_lock_irqsave(&remote_endpoints_lock, flags);
+	list_add_tail(&new_c->list, &remote_endpoints);
+	spin_unlock_irqrestore(&remote_endpoints_lock, flags);
+	return 0;
+}
+
+static struct msm_rpc_endpoint *rpcrouter_lookup_local_endpoint(uint32_t cid)
+{
+	struct msm_rpc_endpoint *ept;
+	unsigned long flags;
+
+	spin_lock_irqsave(&local_endpoints_lock, flags);
+	list_for_each_entry(ept, &local_endpoints, list) {
+		if (ept->cid == cid) {
+			spin_unlock_irqrestore(&local_endpoints_lock, flags);
+			return ept;
+		}
+	}
+	spin_unlock_irqrestore(&local_endpoints_lock, flags);
+	return NULL;
+}
+
+static struct rr_remote_endpoint *rpcrouter_lookup_remote_endpoint(uint32_t cid)
+{
+	struct rr_remote_endpoint *ept;
+	unsigned long flags;
+
+	spin_lock_irqsave(&remote_endpoints_lock, flags);
+	list_for_each_entry(ept, &remote_endpoints, list) {
+		if (ept->cid == cid) {
+			spin_unlock_irqrestore(&remote_endpoints_lock, flags);
+			return ept;
+		}
+	}
+	spin_unlock_irqrestore(&remote_endpoints_lock, flags);
+	return NULL;
+}
+
+static int process_control_msg(union rr_control_msg *msg, int len)
+{
+	union rr_control_msg ctl;
+	struct rr_server *server;
+	struct rr_remote_endpoint *r_ept;
+	int rc = 0;
+	unsigned long flags;
+
+	if (len != sizeof(*msg)) {
+		printk(KERN_ERR "rpcrouter: r2r msg size %d != %d\n",
+		       len, sizeof(*msg));
+		return -EINVAL;
+	}
+
+	switch (msg->cmd) {
+	case RPCROUTER_CTRL_CMD_HELLO:
+		RR("o HELLO\n");
+
+		RR("x HELLO\n");
+		memset(&ctl, 0, sizeof(ctl));
+		ctl.cmd = RPCROUTER_CTRL_CMD_HELLO;
+		rpcrouter_send_control_msg(&ctl);
+
+		initialized = 1;
+
+		/* Send list of servers one at a time */
+		ctl.cmd = RPCROUTER_CTRL_CMD_NEW_SERVER;
+
+		/* TODO: long time to hold a spinlock... */
+		spin_lock_irqsave(&server_list_lock, flags);
+		list_for_each_entry(server, &server_list, list) {
+			ctl.srv.pid = server->pid;
+			ctl.srv.cid = server->cid;
+			ctl.srv.prog = server->prog;
+			ctl.srv.vers = server->vers;
+
+			RR("x NEW_SERVER id=%d:%08x prog=%08x:%08x\n",
+			   server->pid, server->cid,
+			   server->prog, server->vers);
+
+			rpcrouter_send_control_msg(&ctl);
+		}
+		spin_unlock_irqrestore(&server_list_lock, flags);
+
+		queue_work(rpcrouter_workqueue, &work_create_rpcrouter_pdev);
+		break;
+
+	case RPCROUTER_CTRL_CMD_RESUME_TX:
+		RR("o RESUME_TX id=%d:%08x\n", msg->cli.pid, msg->cli.cid);
+
+		r_ept = rpcrouter_lookup_remote_endpoint(msg->cli.cid);
+		if (!r_ept) {
+			printk(KERN_ERR
+			       "rpcrouter: Unable to resume client\n");
+			break;
+		}
+		spin_lock_irqsave(&r_ept->quota_lock, flags);
+		r_ept->tx_quota_cntr = 0;
+		spin_unlock_irqrestore(&r_ept->quota_lock, flags);
+		wake_up(&r_ept->quota_wait);
+		break;
+
+	case RPCROUTER_CTRL_CMD_NEW_SERVER:
+		RR("o NEW_SERVER id=%d:%08x prog=%08x:%08x\n",
+		   msg->srv.pid, msg->srv.cid, msg->srv.prog, msg->srv.vers);
+
+		server = rpcrouter_lookup_server(msg->srv.prog, msg->srv.vers);
+
+		if (!server) {
+			server = rpcrouter_create_server(
+				msg->srv.pid, msg->srv.cid,
+				msg->srv.prog, msg->srv.vers);
+			if (!server)
+				return -ENOMEM;
+			/*
+			 * XXX: Verify that its okay to add the
+			 * client to our remote client list
+			 * if we get a NEW_SERVER notification
+			 */
+			if (!rpcrouter_lookup_remote_endpoint(msg->srv.cid)) {
+				rc = rpcrouter_create_remote_endpoint(
+					msg->srv.cid);
+				if (rc < 0)
+					printk(KERN_ERR
+						"rpcrouter:Client create"
+						"error (%d)\n", rc);
+			}
+			schedule_work(&work_create_pdevs);
+			wake_up(&newserver_wait);
+		} else {
+			if ((server->pid == msg->srv.pid) &&
+			    (server->cid == msg->srv.cid)) {
+				printk(KERN_ERR "rpcrouter: Duplicate svr\n");
+			} else {
+				server->pid = msg->srv.pid;
+				server->cid = msg->srv.cid;
+			}
+		}
+		break;
+
+	case RPCROUTER_CTRL_CMD_REMOVE_SERVER:
+		RR("o REMOVE_SERVER prog=%08x:%d\n",
+		   msg->srv.prog, msg->srv.vers);
+		server = rpcrouter_lookup_server(msg->srv.prog, msg->srv.vers);
+		if (server)
+			rpcrouter_destroy_server(server);
+		break;
+
+	case RPCROUTER_CTRL_CMD_REMOVE_CLIENT:
+		RR("o REMOVE_CLIENT id=%d:%08x\n", msg->cli.pid, msg->cli.cid);
+		if (msg->cli.pid != RPCROUTER_PID_REMOTE) {
+			printk(KERN_ERR
+			       "rpcrouter: Denying remote removal of "
+			       "local client\n");
+			break;
+		}
+		r_ept = rpcrouter_lookup_remote_endpoint(msg->cli.cid);
+		if (r_ept) {
+			spin_lock_irqsave(&remote_endpoints_lock, flags);
+			list_del(&r_ept->list);
+			spin_unlock_irqrestore(&remote_endpoints_lock, flags);
+			kfree(r_ept);
+		}
+
+		/* Notify local clients of this event */
+		printk(KERN_ERR "rpcrouter: LOCAL NOTIFICATION NOT IMP\n");
+		rc = -ENOSYS;
+
+		break;
+	default:
+		RR("o UNKNOWN(%08x)\n", msg->cmd);
+		rc = -ENOSYS;
+	}
+
+	return rc;
+}
+
+static void do_create_rpcrouter_pdev(struct work_struct *work)
+{
+	platform_device_register(&rpcrouter_pdev);
+}
+
+/* for backward compatible version type (31st bit cleared)
+ * clearing minor number (lower 16 bits) in device name
+ * is neccessary for driver binding
+ */
+static int msm_rpcrouter_create_server_pdev(struct rr_server *server)
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
+static void do_create_pdevs(struct work_struct *work)
+{
+	unsigned long flags;
+	struct rr_server *server;
+
+	/* TODO: race if destroyed while being registered */
+	spin_lock_irqsave(&server_list_lock, flags);
+	list_for_each_entry(server, &server_list, list) {
+		if (server->pid == RPCROUTER_PID_REMOTE) {
+			if (server->pdev_name[0] == 0) {
+				spin_unlock_irqrestore(&server_list_lock,
+						       flags);
+				msm_rpcrouter_create_server_pdev(server);
+				schedule_work(&work_create_pdevs);
+				return;
+			}
+		}
+	}
+	spin_unlock_irqrestore(&server_list_lock, flags);
+}
+
+static void rpcrouter_smdnotify(void *_dev, unsigned event)
+{
+	if (event != SMD_EVENT_DATA)
+		return;
+
+	if (smd_read_avail(smd_channel) >= rpcrouter_need_len)
+		wake_up(&smd_wait);
+}
+
+static void *rr_malloc(unsigned sz)
+{
+	void *ptr = kmalloc(sz, GFP_KERNEL);
+	if (ptr)
+		return ptr;
+
+	printk(KERN_ERR "rpcrouter: kmalloc of %d failed, retrying...\n", sz);
+	do {
+		msleep(100);
+		ptr = kmalloc(sz, GFP_KERNEL);
+	} while (!ptr);
+
+	return ptr;
+}
+
+/* TODO: deal with channel teardown / restore */
+static int rr_read(void *data, int len)
+{
+	int rc;
+	unsigned long flags;
+
+	for (;;) {
+		spin_lock_irqsave(&smd_lock, flags);
+		if (smd_read_avail(smd_channel) >= len) {
+			rc = smd_read(smd_channel, data, len);
+			spin_unlock_irqrestore(&smd_lock, flags);
+			if (rc == len)
+				return 0;
+			else
+				return -EIO;
+		}
+		rpcrouter_need_len = len;
+		spin_unlock_irqrestore(&smd_lock, flags);
+
+		do {
+			rc = wait_event_interruptible(smd_wait,
+					smd_read_avail(smd_channel) >= len);
+		} while (rc < 0);
+	}
+	return 0;
+}
+
+static uint32_t r2r_buf[RPCROUTER_MSGSIZE_MAX];
+
+static void do_read_data(struct work_struct *work)
+{
+	struct rr_header hdr;
+	struct rr_packet *pkt;
+	struct rr_fragment *frag;
+	struct msm_rpc_endpoint *ept;
+	uint32_t pm, mid;
+	unsigned long flags;
+
+	if (rr_read(&hdr, sizeof(hdr)))
+		goto fail_io;
+
+	RR("- ver=%d type=%d src=%d:%08x crx=%d siz=%d dst=%d:%08x\n",
+	   hdr.version, hdr.type, hdr.src_pid, hdr.src_cid,
+	   hdr.confirm_rx, hdr.size, hdr.dst_pid, hdr.dst_cid);
+
+	if (hdr.version != RPCROUTER_VERSION) {
+		DIAG("version %d != %d\n", hdr.version, RPCROUTER_VERSION);
+		goto fail_data;
+	}
+	if (hdr.size > RPCROUTER_MSGSIZE_MAX) {
+		DIAG("msg size %d > max %d\n", hdr.size, RPCROUTER_MSGSIZE_MAX);
+		goto fail_data;
+	}
+
+	if (hdr.dst_cid == RPCROUTER_ROUTER_ADDRESS) {
+		if (rr_read(r2r_buf, hdr.size))
+			goto fail_io;
+		process_control_msg((void *) r2r_buf, hdr.size);
+		goto done;
+	}
+
+	if (hdr.size < sizeof(pm)) {
+		DIAG("runt packet (no pacmark)\n");
+		goto fail_data;
+	}
+	if (rr_read(&pm, sizeof(pm)))
+		goto fail_io;
+
+	hdr.size -= sizeof(pm);
+
+	frag = rr_malloc(hdr.size + sizeof(*frag));
+	frag->next = NULL;
+	frag->length = hdr.size;
+	if (rr_read(frag->data, hdr.size))
+		goto fail_io;
+
+	ept = rpcrouter_lookup_local_endpoint(hdr.dst_cid);
+	if (!ept) {
+		DIAG("no local ept for cid %08x\n", hdr.dst_cid);
+		kfree(frag);
+		goto done;
+	}
+
+	/* See if there is already a partial packet that matches our mid
+	 * and if so, append this fragment to that packet.
+	 */
+	mid = PACMARK_MID(pm);
+	list_for_each_entry(pkt, &ept->incomplete, list) {
+		if (pkt->mid == mid) {
+			pkt->last->next = frag;
+			pkt->last = frag;
+			pkt->length += frag->length;
+			if (PACMARK_LAST(pm)) {
+				list_del(&pkt->list);
+				goto packet_complete;
+			}
+			goto done;
+		}
+	}
+	/* This mid is new -- create a packet for it, and put it on
+	 * the incomplete list if this fragment is not a last fragment,
+	 * otherwise put it on the read queue.
+	 */
+	pkt = rr_malloc(sizeof(struct rr_packet));
+	pkt->first = frag;
+	pkt->last = frag;
+	memcpy(&pkt->hdr, &hdr, sizeof(hdr));
+	pkt->mid = mid;
+	pkt->length = frag->length;
+	if (!PACMARK_LAST(pm)) {
+		list_add_tail(&pkt->list, &ept->incomplete);
+		goto done;
+	}
+
+packet_complete:
+	spin_lock_irqsave(&ept->read_q_lock, flags);
+	if (ept->flags & MSM_RPC_ENABLE_RECEIVE) {
+		list_add_tail(&pkt->list, &ept->read_q);
+		wake_up(&ept->wait_q);
+	} else {
+		pr_warning("smd_rpcrouter: Unexpected incoming data on %08x:%08x\n",
+				be32_to_cpu(ept->dst_prog),
+				be32_to_cpu(ept->dst_vers));
+	}
+	spin_unlock_irqrestore(&ept->read_q_lock, flags);
+done:
+
+	if (hdr.confirm_rx) {
+		union rr_control_msg msg;
+
+		msg.cmd = RPCROUTER_CTRL_CMD_RESUME_TX;
+		msg.cli.pid = hdr.dst_pid;
+		msg.cli.cid = hdr.dst_cid;
+
+		RR("x RESUME_TX id=%d:%08x\n", msg.cli.pid, msg.cli.cid);
+		rpcrouter_send_control_msg(&msg);
+	}
+
+	queue_work(rpcrouter_workqueue, &work_read_data);
+	return;
+
+fail_io:
+fail_data:
+	printk(KERN_ERR "rpc_router has died\n");
+}
+
+void msm_rpc_setup_req(struct rpc_request_hdr *hdr, uint32_t prog,
+		       uint32_t vers, uint32_t proc)
+{
+	memset(hdr, 0, sizeof(struct rpc_request_hdr));
+	hdr->xid = cpu_to_be32(atomic_add_return(1, &next_xid));
+	hdr->rpc_vers = cpu_to_be32(2);
+	hdr->prog = cpu_to_be32(prog);
+	hdr->vers = cpu_to_be32(vers);
+	hdr->procedure = cpu_to_be32(proc);
+}
+
+struct msm_rpc_endpoint *msm_rpc_open(void)
+{
+	struct msm_rpc_endpoint *ept;
+
+	ept = msm_rpcrouter_create_local_endpoint(MKDEV(0, 0));
+	if (ept == NULL)
+		return ERR_PTR(-ENOMEM);
+
+	return ept;
+}
+
+int msm_rpc_close(struct msm_rpc_endpoint *ept)
+{
+	return msm_rpcrouter_destroy_local_endpoint(ept);
+}
+EXPORT_SYMBOL(msm_rpc_close);
+
+static int msm_rpc_write_pkt(struct msm_rpc_endpoint *ept,
+			     struct rr_remote_endpoint *r_ept,
+			     struct rr_header *hdr,
+			     uint32_t pacmark,
+			     void *buffer, int count)
+{
+	DEFINE_WAIT(__wait);
+	unsigned long flags;
+	int needed;
+
+	for (;;) {
+		prepare_to_wait(&r_ept->quota_wait, &__wait,
+				TASK_INTERRUPTIBLE);
+		spin_lock_irqsave(&r_ept->quota_lock, flags);
+		if (r_ept->tx_quota_cntr < RPCROUTER_DEFAULT_RX_QUOTA)
+			break;
+		if (signal_pending(current) &&
+		    (!(ept->flags & MSM_RPC_UNINTERRUPTIBLE)))
+			break;
+		spin_unlock_irqrestore(&r_ept->quota_lock, flags);
+		schedule();
+	}
+	finish_wait(&r_ept->quota_wait, &__wait);
+
+	if (signal_pending(current) &&
+	    (!(ept->flags & MSM_RPC_UNINTERRUPTIBLE))) {
+		spin_unlock_irqrestore(&r_ept->quota_lock, flags);
+		return -ERESTARTSYS;
+	}
+	r_ept->tx_quota_cntr++;
+	if (r_ept->tx_quota_cntr == RPCROUTER_DEFAULT_RX_QUOTA)
+		hdr->confirm_rx = 1;
+
+	spin_unlock_irqrestore(&r_ept->quota_lock, flags);
+
+	spin_lock_irqsave(&smd_lock, flags);
+
+	needed = sizeof(*hdr) + hdr->size;
+	while (smd_write_avail(smd_channel) < needed) {
+		spin_unlock_irqrestore(&smd_lock, flags);
+		msleep(250);
+		spin_lock_irqsave(&smd_lock, flags);
+	}
+
+	/* TODO: deal with full fifo */
+	smd_write(smd_channel, hdr, sizeof(*hdr));
+	smd_write(smd_channel, &pacmark, sizeof(pacmark));
+	smd_write(smd_channel, buffer, count);
+
+	spin_unlock_irqrestore(&smd_lock, flags);
+
+	return 0;
+}
+
+int msm_rpc_write(struct msm_rpc_endpoint *ept, void *buffer, int count)
+{
+	struct rr_header hdr;
+	uint32_t pacmark;
+	uint32_t mid;
+	struct rpc_request_hdr *rq = buffer;
+	struct rr_remote_endpoint *r_ept;
+	unsigned long flags;
+	int ret;
+	int total;
+
+	/* snoop the RPC packet and enforce permissions */
+
+	/* has to have at least the xid and type fields */
+	if (count < ((sizeof(uint32_t)) * 2)) {
+		printk(KERN_ERR "rr_write: rejecting runt packet\n");
+		return -EINVAL;
+	}
+
+	if (rq->type == 0) {
+		/* RPC CALL */
+		if (count < ((sizeof(uint32_t)) * 6)) {
+			printk(KERN_ERR
+			       "rr_write: rejecting runt call packet\n");
+			return -EINVAL;
+		}
+		if (ept->dst_pid == 0xffffffff) {
+			printk(KERN_ERR "rr_write: not connected\n");
+			return -ENOTCONN;
+		}
+
+		if ((ept->dst_prog != rq->prog) ||
+			!msm_rpc_is_compatible_version(
+					be32_to_cpu(ept->dst_vers),
+					be32_to_cpu(rq->vers))) {
+			printk(KERN_ERR
+			       "rr_write: cannot write to %08x:%d "
+			       "(bound to %08x:%d)\n",
+			       be32_to_cpu(rq->prog), be32_to_cpu(rq->vers),
+			       be32_to_cpu(ept->dst_prog),
+			       be32_to_cpu(ept->dst_vers));
+			return -EINVAL;
+		}
+		hdr.dst_pid = ept->dst_pid;
+		hdr.dst_cid = ept->dst_cid;
+		IO("CALL on ept %p to %08x:%08x @ %d:%08x (%d bytes)"
+		   "(xid %x proc %x)\n",
+		   ept,
+		   be32_to_cpu(rq->prog), be32_to_cpu(rq->vers),
+		   ept->dst_pid, ept->dst_cid, count,
+		   be32_to_cpu(rq->xid), be32_to_cpu(rq->procedure));
+	} else {
+		/* RPC REPLY */
+		spin_lock_irqsave(&ept->rroute_lock, flags);
+		for (ret = 0; ret < MAX_REPLY_ROUTE; ret++)
+			if (ept->rroute[ret].xid == rq->xid) {
+				if (ept->rroute[ret].pid == 0xffffffff)
+					continue;
+				hdr.dst_pid = ept->rroute[ret].pid;
+				hdr.dst_cid = ept->rroute[ret].cid;
+				/* consume this reply */
+				ept->rroute[ret].pid = 0xffffffff;
+				spin_unlock_irqrestore(&ept->rroute_lock,
+						       flags);
+				goto found_rroute;
+			}
+
+		spin_unlock_irqrestore(&ept->rroute_lock, flags);
+		printk(KERN_ERR "rr_write: rejecting packet w/ bad xid\n");
+		return -EINVAL;
+
+found_rroute:
+		IO("REPLY on ept %p to xid=%d @ %d:%08x (%d bytes)\n",
+		   ept,
+		   be32_to_cpu(rq->xid), hdr.dst_pid, hdr.dst_cid, count);
+	}
+
+	r_ept = rpcrouter_lookup_remote_endpoint(hdr.dst_cid);
+
+	if (!r_ept) {
+		printk(KERN_ERR
+			"msm_rpc_write(): No route to ept "
+			"[PID %x CID %x]\n", hdr.dst_pid, hdr.dst_cid);
+		return -EHOSTUNREACH;
+	}
+
+	/* Create routing header */
+	hdr.type = RPCROUTER_CTRL_CMD_DATA;
+	hdr.version = RPCROUTER_VERSION;
+	hdr.src_pid = ept->pid;
+	hdr.src_cid = ept->cid;
+
+	total = count;
+
+	mid = atomic_add_return(1, &next_mid) & 0xFF;
+
+	while (count > 0) {
+		unsigned xfer;
+
+		if (count > RPCROUTER_DATASIZE_MAX)
+			xfer = RPCROUTER_DATASIZE_MAX;
+		else
+			xfer = count;
+
+		hdr.confirm_rx = 0;
+		hdr.size = xfer + sizeof(uint32_t);
+
+		/* total == count -> must be first packet
+		 * xfer == count -> must be last packet
+		 */
+		pacmark = PACMARK(xfer, mid, (total == count), (xfer == count));
+
+		ret = msm_rpc_write_pkt(ept, r_ept, &hdr,
+					pacmark, buffer, xfer);
+		if (ret < 0)
+			return ret;
+
+		buffer += xfer;
+		count -= xfer;
+	}
+
+	return total;
+}
+EXPORT_SYMBOL(msm_rpc_write);
+
+/*
+ * NOTE: It is the responsibility of the caller to kfree buffer
+ */
+int msm_rpc_read(struct msm_rpc_endpoint *ept, void **buffer,
+		 unsigned user_len, long timeout)
+{
+	struct rr_fragment *frag, *next;
+	char *buf;
+	int rc;
+
+	rc = __msm_rpc_read(ept, &frag, user_len, timeout);
+	if (rc <= 0)
+		return rc;
+
+	/* single-fragment messages conveniently can be
+	 * returned as-is (the buffer is at the front)
+	 */
+	if (frag->next == 0) {
+		*buffer = (void *) frag;
+		return rc;
+	}
+
+	/* multi-fragment messages, we have to do it the
+	 * hard way, which is rather disgusting right now
+	 */
+	buf = rr_malloc(rc);
+	*buffer = buf;
+
+	while (frag != NULL) {
+		memcpy(buf, frag->data, frag->length);
+		next = frag->next;
+		buf += frag->length;
+		kfree(frag);
+		frag = next;
+	}
+
+	return rc;
+}
+
+int msm_rpc_call(struct msm_rpc_endpoint *ept, uint32_t proc,
+		 void *_request, int request_size,
+		 long timeout)
+{
+	return msm_rpc_call_reply(ept, proc,
+				  _request, request_size,
+				  NULL, 0, timeout);
+}
+EXPORT_SYMBOL(msm_rpc_call);
+
+int msm_rpc_call_reply(struct msm_rpc_endpoint *ept, uint32_t proc,
+		       void *_request, int request_size,
+		       void *_reply, int reply_size,
+		       long timeout)
+{
+	struct rpc_request_hdr *req = _request;
+	struct rpc_reply_hdr *reply;
+	int rc;
+
+	if (request_size < sizeof(*req))
+		return -ETOOSMALL;
+
+	if (ept->dst_pid == 0xffffffff)
+		return -ENOTCONN;
+
+	/* We can't use msm_rpc_setup_req() here, because dst_prog and
+	 * dst_vers here are already in BE.
+	 */
+	memset(req, 0, sizeof(*req));
+	req->xid = cpu_to_be32(atomic_add_return(1, &next_xid));
+	req->rpc_vers = cpu_to_be32(2);
+	req->prog = ept->dst_prog;
+	req->vers = ept->dst_vers;
+	req->procedure = cpu_to_be32(proc);
+
+	/* Allow replys to be added to the queue */
+	ept->flags |= MSM_RPC_ENABLE_RECEIVE;
+
+	rc = msm_rpc_write(ept, req, request_size);
+	if (rc < 0)
+		goto error;
+
+	for (;;) {
+		rc = msm_rpc_read(ept, (void *) &reply, -1, timeout);
+		if (rc < 0)
+			goto error;
+		if (rc < (3 * sizeof(uint32_t))) {
+			rc = -EIO;
+			break;
+		}
+		/* we should not get CALL packets -- ignore them */
+		if (reply->type == 0) {
+			kfree(reply);
+			continue;
+		}
+		/* If an earlier call timed out, we could get the (no
+		 * longer wanted) reply for it.  Ignore replies that
+		 * we don't expect.
+		 */
+		if (reply->xid != req->xid) {
+			kfree(reply);
+			continue;
+		}
+		if (reply->reply_stat != 0) {
+			rc = -EPERM;
+			break;
+		}
+		if (reply->data.acc_hdr.accept_stat != 0) {
+			rc = -EINVAL;
+			break;
+		}
+		if (_reply == NULL) {
+			rc = 0;
+			break;
+		}
+		if (rc > reply_size)
+			rc = -ENOMEM;
+		else
+			memcpy(_reply, reply, rc);
+
+		break;
+	}
+	kfree(reply);
+error:
+	ept->flags &= ~MSM_RPC_ENABLE_RECEIVE;
+	return rc;
+}
+EXPORT_SYMBOL(msm_rpc_call_reply);
+
+
+static inline int ept_packet_available(struct msm_rpc_endpoint *ept)
+{
+	unsigned long flags;
+	int ret;
+	spin_lock_irqsave(&ept->read_q_lock, flags);
+	ret = !list_empty(&ept->read_q);
+	spin_unlock_irqrestore(&ept->read_q_lock, flags);
+	return ret;
+}
+
+static int __msm_rpc_read(struct msm_rpc_endpoint *ept,
+			  struct rr_fragment **frag_ret,
+			  unsigned len, long timeout)
+{
+	struct rr_packet *pkt;
+	struct rpc_request_hdr *rq;
+	DEFINE_WAIT(__wait);
+	unsigned long flags;
+	int rc;
+
+	IO("READ on ept %p\n", ept);
+
+	if (ept->flags & MSM_RPC_UNINTERRUPTIBLE) {
+		if (timeout < 0) {
+			wait_event(ept->wait_q, ept_packet_available(ept));
+		} else {
+			rc = wait_event_timeout(
+				ept->wait_q, ept_packet_available(ept),
+				timeout);
+			if (rc == 0)
+				return -ETIMEDOUT;
+		}
+	} else {
+		if (timeout < 0) {
+			rc = wait_event_interruptible(
+				ept->wait_q, ept_packet_available(ept));
+			if (rc < 0)
+				return rc;
+		} else {
+			rc = wait_event_interruptible_timeout(
+				ept->wait_q, ept_packet_available(ept),
+				timeout);
+			if (rc == 0)
+				return -ETIMEDOUT;
+			else if (rc < 0)
+				return rc;
+		}
+	}
+
+	spin_lock_irqsave(&ept->read_q_lock, flags);
+	if (list_empty(&ept->read_q)) {
+		spin_unlock_irqrestore(&ept->read_q_lock, flags);
+		return -EAGAIN;
+	}
+	pkt = list_first_entry(&ept->read_q, struct rr_packet, list);
+	if (pkt->length > len) {
+		spin_unlock_irqrestore(&ept->read_q_lock, flags);
+		return -ETOOSMALL;
+	}
+	list_del(&pkt->list);
+	spin_unlock_irqrestore(&ept->read_q_lock, flags);
+
+	rc = pkt->length;
+
+	*frag_ret = pkt->first;
+	rq = (void *) pkt->first->data;
+	if ((rc >= ((sizeof(uint32_t)) * 3)) && (rq->type == 0)) {
+		IO("READ on ept %p is a CALL on %08x:%08x proc %d xid %d\n",
+			ept, be32_to_cpu(rq->prog), be32_to_cpu(rq->vers),
+			be32_to_cpu(rq->procedure),
+			be32_to_cpu(rq->xid));
+		/* RPC CALL */
+		spin_lock_irqsave(&ept->rroute_lock, flags);
+		if (ept->rroute[ept->next_rroute].pid != 0xffffffff) {
+			printk(KERN_WARNING
+			       "rr_read: lost previous reply xid...\n");
+		}
+		ept->rroute[ept->next_rroute].pid = pkt->hdr.src_pid;
+		ept->rroute[ept->next_rroute].cid = pkt->hdr.src_cid;
+		ept->rroute[ept->next_rroute].xid = rq->xid;
+		ept->next_rroute = (ept->next_rroute + 1) &
+					(MAX_REPLY_ROUTE - 1);
+		spin_unlock_irqrestore(&ept->rroute_lock, flags);
+	}
+#if TRACE_RPC_MSG
+	else if ((rc >= ((sizeof(uint32_t)) * 3)) && (rq->type == 1))
+		IO("READ on ept %p is a REPLY\n", ept);
+	else
+		IO("READ on ept %p (%d bytes)\n", ept, rc);
+#endif
+
+	kfree(pkt);
+	return rc;
+}
+
+int msm_rpc_is_compatible_version(uint32_t server_version,
+				  uint32_t client_version)
+{
+	if ((server_version & RPC_VERSION_MODE_MASK) !=
+	    (client_version & RPC_VERSION_MODE_MASK))
+		return 0;
+
+	if (server_version & RPC_VERSION_MODE_MASK)
+		return server_version == client_version;
+
+	return ((server_version & RPC_VERSION_MAJOR_MASK) ==
+		(client_version & RPC_VERSION_MAJOR_MASK)) &&
+		((server_version & RPC_VERSION_MINOR_MASK) >=
+		(client_version & RPC_VERSION_MINOR_MASK));
+}
+EXPORT_SYMBOL(msm_rpc_is_compatible_version);
+
+static int msm_rpc_get_compatible_server(uint32_t prog,
+					uint32_t ver,
+					uint32_t *found_vers)
+{
+	struct rr_server *server;
+	unsigned long     flags;
+	if (found_vers == NULL)
+		return 0;
+
+	spin_lock_irqsave(&server_list_lock, flags);
+	list_for_each_entry(server, &server_list, list) {
+		if ((server->prog == prog) &&
+		    msm_rpc_is_compatible_version(server->vers, ver)) {
+			*found_vers = server->vers;
+			spin_unlock_irqrestore(&server_list_lock, flags);
+			return 0;
+		}
+	}
+	spin_unlock_irqrestore(&server_list_lock, flags);
+	return -1;
+}
+
+struct msm_rpc_endpoint *msm_rpc_connect(uint32_t prog, uint32_t vers,
+					 unsigned flags)
+{
+	struct msm_rpc_endpoint *ept;
+	struct rr_server *server;
+
+	if (!(vers & RPC_VERSION_MODE_MASK)) {
+		uint32_t found_vers;
+		if (msm_rpc_get_compatible_server(prog, vers, &found_vers) < 0)
+			return ERR_PTR(-EHOSTUNREACH);
+		if (found_vers != vers) {
+			D("RPC using new version %08x:{%08x --> %08x}\n",
+			  prog, vers, found_vers);
+			vers = found_vers;
+		}
+	}
+
+	server = rpcrouter_lookup_server(prog, vers);
+	if (!server)
+		return ERR_PTR(-EHOSTUNREACH);
+
+	ept = msm_rpc_open();
+	if (IS_ERR(ept))
+		return ept;
+
+	ept->flags = flags;
+	ept->dst_pid = server->pid;
+	ept->dst_cid = server->cid;
+	ept->dst_prog = cpu_to_be32(prog);
+	ept->dst_vers = cpu_to_be32(vers);
+
+	return ept;
+}
+EXPORT_SYMBOL(msm_rpc_connect);
+
+uint32_t msm_rpc_get_vers(struct msm_rpc_endpoint *ept)
+{
+	return be32_to_cpu(ept->dst_vers);
+}
+EXPORT_SYMBOL(msm_rpc_get_vers);
+
+static int msm_rpcrouter_probe(struct platform_device *pdev)
+{
+	int rc;
+
+	/* Initialize what we need to start processing */
+	INIT_LIST_HEAD(&local_endpoints);
+	INIT_LIST_HEAD(&remote_endpoints);
+
+	init_waitqueue_head(&newserver_wait);
+	init_waitqueue_head(&smd_wait);
+
+	rpcrouter_workqueue = create_singlethread_workqueue("rpcrouter");
+	if (!rpcrouter_workqueue)
+		return -ENOMEM;
+
+	/* Open up SMD channel 2 */
+	initialized = 0;
+	rc = smd_open("SMD_RPCCALL", &smd_channel, NULL, rpcrouter_smdnotify);
+	if (rc < 0)
+		goto fail_destroy_workqueue;
+
+	queue_work(rpcrouter_workqueue, &work_read_data);
+	return 0;
+
+fail_destroy_workqueue:
+	destroy_workqueue(rpcrouter_workqueue);
+	return rc;
+}
+
+static struct platform_driver msm_smd_channel2_driver = {
+	.probe		= msm_rpcrouter_probe,
+	.driver		= {
+			.name	= "SMD_RPCCALL",
+			.owner	= THIS_MODULE,
+	},
+};
+
+static int __init rpcrouter_init(void)
+{
+	return platform_driver_register(&msm_smd_channel2_driver);
+}
+
+module_init(rpcrouter_init);
+MODULE_DESCRIPTION("MSM RPC Router");
+MODULE_AUTHOR("San Mehat <san@android.com>");
+MODULE_LICENSE("GPL");
diff --git a/drivers/misc/msm_smd_rpcrouter.h b/drivers/misc/msm_smd_rpcrouter.h
new file mode 100644
index 0000000..4d3adeb
--- /dev/null
+++ b/drivers/misc/msm_smd_rpcrouter.h
@@ -0,0 +1,184 @@
+/** drivers/misc/msm_smd_rpcrouter.h
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
+
+#ifndef _MSM_SMD_RPCROUTER_H
+#define _MSM_SMD_RPCROUTER_H
+
+#include <linux/types.h>
+#include <linux/list.h>
+#include <linux/cdev.h>
+#include <linux/platform_device.h>
+
+#include <mach/msm_smd.h>
+#include "msm_rpcrouter.h"
+
+/* definitions for the R2R wire protcol */
+
+#define RPCROUTER_VERSION			1
+#define RPCROUTER_PROCESSORS_MAX		4
+#define RPCROUTER_MSGSIZE_MAX			512
+#define RPCROUTER_DATASIZE_MAX			500
+
+#define RPCROUTER_CLIENT_BCAST_ID		0xffffffff
+#define RPCROUTER_ROUTER_ADDRESS		0xfffffffe
+
+#define RPCROUTER_PID_LOCAL			1
+#define RPCROUTER_PID_REMOTE			0
+
+#define RPCROUTER_CTRL_CMD_DATA			1
+#define RPCROUTER_CTRL_CMD_HELLO		2
+#define RPCROUTER_CTRL_CMD_BYE			3
+#define RPCROUTER_CTRL_CMD_NEW_SERVER		4
+#define RPCROUTER_CTRL_CMD_REMOVE_SERVER	5
+#define RPCROUTER_CTRL_CMD_REMOVE_CLIENT	6
+#define RPCROUTER_CTRL_CMD_RESUME_TX		7
+#define RPCROUTER_CTRL_CMD_EXIT			8
+
+#define RPCROUTER_DEFAULT_RX_QUOTA	5
+
+union rr_control_msg {
+	uint32_t cmd;
+	struct {
+		uint32_t cmd;
+		uint32_t prog;
+		uint32_t vers;
+		uint32_t pid;
+		uint32_t cid;
+	} srv;
+	struct {
+		uint32_t cmd;
+		uint32_t pid;
+		uint32_t cid;
+	} cli;
+};
+
+struct rr_header {
+	uint32_t version;
+	uint32_t type;
+	uint32_t src_pid;
+	uint32_t src_cid;
+	uint32_t confirm_rx;
+	uint32_t size;
+	uint32_t dst_pid;
+	uint32_t dst_cid;
+};
+
+/* internals */
+
+#define RPCROUTER_MAX_REMOTE_SERVERS		100
+
+struct rr_fragment {
+	unsigned char data[RPCROUTER_MSGSIZE_MAX];
+	uint32_t length;
+	struct rr_fragment *next;
+};
+
+struct rr_packet {
+	struct list_head list;
+	struct rr_fragment *first;
+	struct rr_fragment *last;
+	struct rr_header hdr;
+	uint32_t mid;
+	uint32_t length;
+};
+
+#define PACMARK_LAST(n) ((n) & 0x80000000)
+#define PACMARK_MID(n)  (((n) >> 16) & 0xFF)
+#define PACMARK_LEN(n)  ((n) & 0xFFFF)
+
+static inline uint32_t PACMARK(uint32_t len, uint32_t mid, uint32_t first,
+			       uint32_t last)
+{
+	return (len & 0xFFFF) |
+	  ((mid & 0xFF) << 16) |
+	  ((!!first) << 30) |
+	  ((!!last) << 31);
+}
+
+struct rr_server {
+	struct list_head list;
+
+	uint32_t pid;
+	uint32_t cid;
+	uint32_t prog;
+	uint32_t vers;
+
+	dev_t device_number;
+	struct cdev cdev;
+	struct device *device;
+	struct rpcsvr_platform_device p_device;
+	char pdev_name[32];
+};
+
+struct rr_remote_endpoint {
+	uint32_t pid;
+	uint32_t cid;
+
+	int tx_quota_cntr;
+	spinlock_t quota_lock;
+	wait_queue_head_t quota_wait;
+
+	struct list_head list;
+};
+
+struct msm_reply_route {
+	uint32_t xid;
+	uint32_t pid;
+	uint32_t cid;
+	uint32_t unused;
+};
+
+#define MAX_REPLY_ROUTE 4
+
+struct msm_rpc_endpoint {
+	struct list_head list;
+
+	/* incomplete packets waiting for assembly */
+	struct list_head incomplete;
+
+	/* complete packets waiting to be read */
+	struct list_head read_q;
+	spinlock_t read_q_lock;
+	wait_queue_head_t wait_q;
+	unsigned flags;
+
+	/* endpoint address */
+	uint32_t pid;
+	uint32_t cid;
+
+	/* bound remote address
+	 * if not connected (dst_pid == 0xffffffff) RPC_CALL writes fail
+	 * RPC_CALLs must be to the prog/vers below or they will fail
+	 */
+	uint32_t dst_pid;
+	uint32_t dst_cid;
+	uint32_t dst_prog; /* be32 */
+	uint32_t dst_vers; /* be32 */
+
+	/* RPC_REPLY writes must be routed to the pid/cid of the
+	 * RPC_CALL they are in reply to.  Keep a cache of valid
+	 * xid/pid/cid groups.  pid 0xffffffff -> not valid.
+	 */
+	unsigned next_rroute;
+	struct msm_reply_route rroute[MAX_REPLY_ROUTE];
+	spinlock_t rroute_lock;
+
+	/* device node if this endpoint is accessed via userspace */
+	dev_t dev;
+};
+
+#endif /* _MSM_SMD_RPCROUTER_H */
-- 
1.5.6.3

Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
