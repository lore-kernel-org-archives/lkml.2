Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754865Ab0LOSy4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 13:54:56 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:15229 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754820Ab0LOSyw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 13:54:52 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6198"; a="66752294"
From: Niranjana Vishwanathapura <nvishwan@codeaurora.org>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Cc: linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Niranjana Vishwanathapura <nvishwan@codeaurora.org>,
        San Mehat <san@android.com>
Subject: [PATCH 3/5] msm: rpc: Add support for RPC servers
Date: Wed, 15 Dec 2010 10:54:08 -0800
Message-Id: <1292439250-11985-4-git-send-email-nvishwan@codeaurora.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1292439250-11985-1-git-send-email-nvishwan@codeaurora.org>
References: <1292439250-11985-1-git-send-email-nvishwan@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for RPC servers on host processor so that
clients on remote processor can talk to it.

Cc: San Mehat <san@android.com>
Signed-off-by: Niranjana Vishwanathapura <nvishwan@codeaurora.org>
---
 drivers/misc/Makefile                    |    1 +
 drivers/misc/msm_rpcrouter.h             |   17 +++
 drivers/misc/msm_smd_rpcrouter.c         |   43 ++++++
 drivers/misc/msm_smd_rpcrouter_servers.c |  221 ++++++++++++++++++++++++++++++
 4 files changed, 282 insertions(+), 0 deletions(-)
 create mode 100644 drivers/misc/msm_smd_rpcrouter_servers.c

diff --git a/drivers/misc/Makefile b/drivers/misc/Makefile
index d7a00e4..8f1dbf4 100644
--- a/drivers/misc/Makefile
+++ b/drivers/misc/Makefile
@@ -44,3 +44,4 @@ obj-y				+= ti-st/
 obj-$(CONFIG_AB8500_PWM)	+= ab8500-pwm.o
 obj-$(CONFIG_MSM_ONCRPCROUTER)	+= msm_smd_rpcrouter.o
 obj-$(CONFIG_MSM_ONCRPCROUTER)	+= msm_smd_rpcrouter_device.o
+obj-$(CONFIG_MSM_ONCRPCROUTER)	+= msm_smd_rpcrouter_servers.o
diff --git a/drivers/misc/msm_rpcrouter.h b/drivers/misc/msm_rpcrouter.h
index 935e714..2c83a74 100644
--- a/drivers/misc/msm_rpcrouter.h
+++ b/drivers/misc/msm_rpcrouter.h
@@ -132,6 +132,10 @@ int msm_rpc_read(struct msm_rpc_endpoint *ept,
 		 void **data, unsigned len, long timeout);
 void msm_rpc_setup_req(struct rpc_request_hdr *hdr,
 		       uint32_t prog, uint32_t vers, uint32_t proc);
+int msm_rpc_register_server(struct msm_rpc_endpoint *ept,
+			    uint32_t prog, uint32_t vers);
+int msm_rpc_unregister_server(struct msm_rpc_endpoint *ept,
+			      uint32_t prog, uint32_t vers);
 
 /* simple blocking rpc call
  *
@@ -148,4 +152,17 @@ int msm_rpc_call(struct msm_rpc_endpoint *ept, uint32_t proc,
 		 void *request, int request_size,
 		 long timeout);
 
+struct msm_rpc_server {
+	struct list_head list;
+	uint32_t flags;
+
+	uint32_t prog;
+	uint32_t vers;
+
+	int (*rpc_call)(struct msm_rpc_server *server,
+			struct rpc_request_hdr *req, unsigned len);
+};
+
+int msm_rpc_create_server(struct msm_rpc_server *server);
+
 #endif /* _MSM_RPCROUTER_H */
diff --git a/drivers/misc/msm_smd_rpcrouter.c b/drivers/misc/msm_smd_rpcrouter.c
index eaaf79e..93b0731 100644
--- a/drivers/misc/msm_smd_rpcrouter.c
+++ b/drivers/misc/msm_smd_rpcrouter.c
@@ -1196,6 +1196,49 @@ uint32_t msm_rpc_get_vers(struct msm_rpc_endpoint *ept)
 }
 EXPORT_SYMBOL(msm_rpc_get_vers);
 
+int msm_rpc_register_server(struct msm_rpc_endpoint *ept,
+			    uint32_t prog, uint32_t vers)
+{
+	int rc;
+	union rr_control_msg msg;
+	struct rr_server *server;
+
+	server = rpcrouter_create_server(ept->pid, ept->cid,
+					 prog, vers);
+	if (!server)
+		return -ENODEV;
+
+	msg.srv.cmd = RPCROUTER_CTRL_CMD_NEW_SERVER;
+	msg.srv.pid = ept->pid;
+	msg.srv.cid = ept->cid;
+	msg.srv.prog = prog;
+	msg.srv.vers = vers;
+
+	RR("x NEW_SERVER id=%d:%08x prog=%08x:%08x\n",
+	   ept->pid, ept->cid, prog, vers);
+
+	rc = rpcrouter_send_control_msg(&msg);
+	if (rc < 0)
+		return rc;
+
+	ept->flags |= MSM_RPC_ENABLE_RECEIVE;
+	return 0;
+}
+
+int msm_rpc_unregister_server(struct msm_rpc_endpoint *ept,
+			      uint32_t prog, uint32_t vers)
+{
+	struct rr_server *server;
+	server = rpcrouter_lookup_server(prog, vers);
+
+	if (!server)
+		return -ENOENT;
+
+	ept->flags &= ~MSM_RPC_ENABLE_RECEIVE;
+	rpcrouter_destroy_server(server);
+	return 0;
+}
+
 static int msm_rpcrouter_probe(struct platform_device *pdev)
 {
 	int rc;
diff --git a/drivers/misc/msm_smd_rpcrouter_servers.c b/drivers/misc/msm_smd_rpcrouter_servers.c
new file mode 100644
index 0000000..f5e10c5
--- /dev/null
+++ b/drivers/misc/msm_smd_rpcrouter_servers.c
@@ -0,0 +1,221 @@
+/* drivers/misc/msm_smd_rpcrouter_servers.c
+ *
+ * Copyright (C) 2007 Google, Inc.
+ * Copyright (c) 2010, Code Aurora Forum. All rights reserved.
+ * Author: Iliyan Malchev <ibm@android.com>
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
+#include <linux/fs.h>
+#include <linux/kthread.h>
+#include <linux/delay.h>
+#include <linux/platform_device.h>
+
+#include <linux/msm_rpcrouter.h>
+#include <linux/uaccess.h>
+
+#include "msm_rpcrouter.h"
+#include "msm_smd_rpcrouter.h"
+
+static struct msm_rpc_endpoint *endpoint;
+
+#define FLAG_REGISTERED 0x0001
+
+static LIST_HEAD(rpc_server_list);
+static DEFINE_MUTEX(rpc_server_list_lock);
+static int rpc_servers_active;
+
+static void rpc_server_register(struct msm_rpc_server *server)
+{
+	int rc;
+	rc = msm_rpc_register_server(endpoint, server->prog, server->vers);
+	if (rc < 0)
+		printk(KERN_ERR "[rpcserver] error registering %p @ %08x:%d\n",
+		       server, server->prog, server->vers);
+}
+
+static struct msm_rpc_server *rpc_server_find(uint32_t prog, uint32_t vers)
+{
+	struct msm_rpc_server *server;
+
+	mutex_lock(&rpc_server_list_lock);
+	list_for_each_entry(server, &rpc_server_list, list) {
+		if ((server->prog == prog) &&
+		    msm_rpc_is_compatible_version(server->vers, vers)) {
+			mutex_unlock(&rpc_server_list_lock);
+			return server;
+		}
+	}
+	mutex_unlock(&rpc_server_list_lock);
+	return NULL;
+}
+
+static void rpc_server_register_all(void)
+{
+	struct msm_rpc_server *server;
+
+	mutex_lock(&rpc_server_list_lock);
+	list_for_each_entry(server, &rpc_server_list, list) {
+		if (!(server->flags & FLAG_REGISTERED)) {
+			rpc_server_register(server);
+			server->flags |= FLAG_REGISTERED;
+		}
+	}
+	mutex_unlock(&rpc_server_list_lock);
+}
+
+int msm_rpc_create_server(struct msm_rpc_server *server)
+{
+	/* make sure we're in a sane state first */
+	server->flags = 0;
+	INIT_LIST_HEAD(&server->list);
+
+	mutex_lock(&rpc_server_list_lock);
+	list_add(&server->list, &rpc_server_list);
+	if (rpc_servers_active) {
+		rpc_server_register(server);
+		server->flags |= FLAG_REGISTERED;
+	}
+	mutex_unlock(&rpc_server_list_lock);
+
+	return 0;
+}
+
+static int rpc_send_accepted_void_reply(struct msm_rpc_endpoint *client,
+					uint32_t xid, uint32_t accept_status)
+{
+	int rc = 0;
+	uint8_t reply_buf[sizeof(struct rpc_reply_hdr)];
+	struct rpc_reply_hdr *reply = (struct rpc_reply_hdr *)reply_buf;
+
+	reply->xid = cpu_to_be32(xid);
+	reply->type = cpu_to_be32(1); /* reply */
+	reply->reply_stat = cpu_to_be32(RPCMSG_REPLYSTAT_ACCEPTED);
+
+	reply->data.acc_hdr.accept_stat = cpu_to_be32(accept_status);
+	reply->data.acc_hdr.verf_flavor = 0;
+	reply->data.acc_hdr.verf_length = 0;
+
+	rc = msm_rpc_write(client, reply_buf, sizeof(reply_buf));
+	if (rc < 0)
+		printk(KERN_ERR
+		       "%s: could not write response: %d\n", __func__, rc);
+
+	return rc;
+}
+
+static int rpc_servers_thread(void *data)
+{
+	void *buffer;
+	struct rpc_request_hdr *req;
+	struct msm_rpc_server *server;
+	int rc;
+
+	for (;;) {
+		rc = wait_event_interruptible(endpoint->wait_q,
+						!list_empty(&endpoint->read_q));
+		rc = msm_rpc_read(endpoint, &buffer, -1, -1);
+		if (rc < 0) {
+			printk(KERN_ERR "%s: could not read: %d\n",
+			       __func__, rc);
+			break;
+		}
+		req = (struct rpc_request_hdr *)buffer;
+
+		req->type = be32_to_cpu(req->type);
+		req->xid = be32_to_cpu(req->xid);
+		req->rpc_vers = be32_to_cpu(req->rpc_vers);
+		req->prog = be32_to_cpu(req->prog);
+		req->vers = be32_to_cpu(req->vers);
+		req->procedure = be32_to_cpu(req->procedure);
+
+		server = rpc_server_find(req->prog, req->vers);
+
+		if (req->rpc_vers != 2)
+			continue;
+		if (req->type != 0)
+			continue;
+		if (!server) {
+			rpc_send_accepted_void_reply(
+				endpoint, req->xid,
+				RPC_ACCEPTSTAT_PROG_UNAVAIL);
+			continue;
+		}
+
+		rc = server->rpc_call(server, req, rc);
+
+		switch (rc) {
+		case 0:
+			rpc_send_accepted_void_reply(
+				endpoint, req->xid,
+				RPC_ACCEPTSTAT_SUCCESS);
+			break;
+		default:
+			rpc_send_accepted_void_reply(
+				endpoint, req->xid,
+				RPC_ACCEPTSTAT_PROG_UNAVAIL);
+			break;
+		}
+
+		kfree(buffer);
+	}
+
+	do_exit(0);
+}
+
+static int rpcservers_probe(struct platform_device *pdev)
+{
+	struct task_struct *server_thread;
+
+	endpoint = msm_rpc_open();
+	if (IS_ERR(endpoint))
+		return PTR_ERR(endpoint);
+
+	/* we're online -- register any servers installed beforehand */
+	rpc_servers_active = 1;
+	rpc_server_register_all();
+
+	/* start the kernel thread */
+	server_thread = kthread_run(rpc_servers_thread, NULL, "krpcserversd");
+	if (IS_ERR(server_thread))
+		return PTR_ERR(server_thread);
+
+	return 0;
+}
+
+static struct platform_driver rpcservers_driver = {
+	.probe	= rpcservers_probe,
+	.driver	= {
+		.name	= "oncrpc_router",
+		.owner	= THIS_MODULE,
+	},
+};
+
+static int __init rpc_servers_init(void)
+{
+	return platform_driver_register(&rpcservers_driver);
+}
+
+module_init(rpc_servers_init);
+
+MODULE_DESCRIPTION("MSM RPC Servers");
+MODULE_AUTHOR("Iliyan Malchev <ibm@android.com>");
+MODULE_LICENSE("GPL");
-- 
1.5.6.3

Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
