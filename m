Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754983Ab0LOSzb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 13:55:31 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:15229 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754833Ab0LOSyz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 13:54:55 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6198"; a="66752330"
From: Niranjana Vishwanathapura <nvishwan@codeaurora.org>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Cc: linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Niranjana Vishwanathapura <nvishwan@codeaurora.org>
Subject: [PATCH 5/5] msm: rpc: ping modem client driver
Date: Wed, 15 Dec 2010 10:54:10 -0800
Message-Id: <1292439250-11985-6-git-send-email-nvishwan@codeaurora.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1292439250-11985-1-git-send-email-nvishwan@codeaurora.org>
References: <1292439250-11985-1-git-send-email-nvishwan@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ping rpc client driver which talks to remote Ping rpc server.
This is a test module to ensure working of rpc clients from kernel.

Signed-off-by: Niranjana Vishwanathapura <nvishwan@codeaurora.org>
---
 drivers/misc/Kconfig                   |    7 +
 drivers/misc/Makefile                  |    1 +
 drivers/misc/msm_ping_mdm_rpc_client.c |  268 ++++++++++++++++++++++++++++++++
 3 files changed, 276 insertions(+), 0 deletions(-)
 create mode 100644 drivers/misc/msm_ping_mdm_rpc_client.c

diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
index 345e79c..f5c9b25 100644
--- a/drivers/misc/Kconfig
+++ b/drivers/misc/Kconfig
@@ -467,6 +467,13 @@ config MSM_RPCSERVER_WATCHDOG
 	help
 	  The dog_keepalive server handles watchdog events.
 
+config MSM_RPC_PING
+	depends on MSM_ONCRPCROUTER && DEBUG_FS
+	default n
+	bool "MSM rpc ping"
+	help
+	  Implements MSM rpc ping test module.
+
 source "drivers/misc/c2port/Kconfig"
 source "drivers/misc/eeprom/Kconfig"
 source "drivers/misc/cb710/Kconfig"
diff --git a/drivers/misc/Makefile b/drivers/misc/Makefile
index 432ad7f..2f272f6 100644
--- a/drivers/misc/Makefile
+++ b/drivers/misc/Makefile
@@ -46,3 +46,4 @@ obj-$(CONFIG_MSM_ONCRPCROUTER)	+= msm_smd_rpcrouter.o
 obj-$(CONFIG_MSM_ONCRPCROUTER)	+= msm_smd_rpcrouter_device.o
 obj-$(CONFIG_MSM_ONCRPCROUTER)	+= msm_smd_rpcrouter_servers.o
 obj-$(CONFIG_MSM_RPCSERVER_WATCHDOG)	+= msm_rpc_server_dog_keepalive.o
+obj-$(CONFIG_MSM_RPC_PING)		+= msm_ping_mdm_rpc_client.o
diff --git a/drivers/misc/msm_ping_mdm_rpc_client.c b/drivers/misc/msm_ping_mdm_rpc_client.c
new file mode 100644
index 0000000..cc21b4c
--- /dev/null
+++ b/drivers/misc/msm_ping_mdm_rpc_client.c
@@ -0,0 +1,268 @@
+/* Copyright (c) 2010, Code Aurora Forum. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
+ * 02110-1301, USA.
+ *
+ */
+
+/*
+ * SMD RPC PING MODEM Driver
+ */
+
+#define pr_fmt(fmt) "%s: " fmt, __func__
+
+#include <linux/kernel.h>
+#include <linux/err.h>
+#include <linux/fs.h>
+#include <linux/sched.h>
+#include <linux/slab.h>
+#include <linux/debugfs.h>
+#include <linux/uaccess.h>
+
+#include "msm_rpcrouter.h"
+
+#define PING_MDM_PROG  0x30000081
+#define PING_MDM_VERS  0x00010001
+
+#define PING_MDM_NULL_PROC               0
+#define PING_MDM_REGISTER_DATA_PROC      4
+
+#define PING_MDM_DATA_CB_PROC            1
+#define PING_MDM_CB_PROC                 2
+
+static DEFINE_MUTEX(ping_mdm_lock);
+
+struct ping_mdm_data_arg {
+	uint32_t *data;
+	uint32_t size;
+};
+
+struct ping_mdm_data_ret {
+	uint32_t result;
+};
+
+static int ping_mdm_data_register(struct msm_rpc_endpoint *ep,
+				  struct ping_mdm_data_arg *arg,
+				  struct ping_mdm_data_ret *ret)
+{
+	void *req, *reply;
+	uint32_t *tmp;
+	uint32_t req_size, reply_size;
+	int rc, i;
+
+	mutex_lock(&ping_mdm_lock);
+	req_size =  sizeof(struct rpc_request_hdr) +
+			(arg->size * sizeof(uint32_t)) +
+			(2 * sizeof(uint32_t));
+	req = kzalloc(req_size, GFP_KERNEL);
+	if (!req) {
+		mutex_unlock(&ping_mdm_lock);
+		return -ENOMEM;
+	}
+
+	reply_size = sizeof(struct rpc_reply_hdr) + sizeof(uint32_t);
+	reply = kzalloc(reply_size, GFP_KERNEL);
+	if (!reply) {
+		kfree(req);
+		mutex_unlock(&ping_mdm_lock);
+		return -ENOMEM;
+	}
+
+	tmp = req + sizeof(struct rpc_request_hdr);
+	*(tmp++) = cpu_to_be32(arg->size);
+
+	for (i = 0; i < arg->size; i++)
+		*(tmp++) = cpu_to_be32(arg->data[i]);
+
+	*(tmp++) = cpu_to_be32(arg->size);
+
+	rc = msm_rpc_call_reply(ep, PING_MDM_REGISTER_DATA_PROC,
+				req, req_size, reply, reply_size, -1);
+	tmp = reply + sizeof(struct rpc_reply_hdr);
+	if (rc > 0) {
+		rc = 0;
+		ret->result = be32_to_cpu(*tmp);
+	}
+
+	mutex_unlock(&ping_mdm_lock);
+	kfree(req);
+	kfree(reply);
+	return rc;
+}
+
+static int ping_mdm_null(struct msm_rpc_endpoint *ep)
+{
+	int rc;
+	struct rpc_request_hdr req;
+
+	mutex_lock(&ping_mdm_lock);
+	rc = msm_rpc_call(ep, PING_MDM_NULL_PROC, &req, sizeof(req), -1);
+	mutex_unlock(&ping_mdm_lock);
+	return rc;
+}
+
+static int ping_mdm_close(struct msm_rpc_endpoint *ep)
+{
+	mutex_lock(&ping_mdm_lock);
+	msm_rpc_close(ep);
+	mutex_unlock(&ping_mdm_lock);
+
+	pr_info("disconnected from remote ping server\n");
+	return 0;
+}
+
+static struct msm_rpc_endpoint *ping_mdm_init(void)
+{
+	struct msm_rpc_endpoint *ep;
+
+	mutex_lock(&ping_mdm_lock);
+	ep = msm_rpc_connect(PING_MDM_PROG, PING_MDM_VERS, 0);
+	mutex_unlock(&ping_mdm_lock);
+	return ep;
+}
+
+#define PING_TEST_DATA_REG_BUF_SIZE  64
+#define PING_TEST_CMD_BUF_SIZE       64
+
+static struct dentry *dent;
+static int32_t test_res;
+struct msm_rpc_endpoint *endpoint;
+
+static int ping_mdm_data_register_test(void)
+{
+	int i, rc = 0;
+	uint32_t my_data[PING_TEST_DATA_REG_BUF_SIZE];
+	uint32_t my_sum = 0;
+	struct ping_mdm_data_arg data_arg;
+	struct ping_mdm_data_ret data_ret;
+
+	for (i = 0; i < PING_TEST_DATA_REG_BUF_SIZE; i++) {
+		my_data[i] = (42 + i);
+		my_sum ^= (42 + i);
+	}
+
+	data_arg.data = my_data;
+	data_arg.size = PING_TEST_DATA_REG_BUF_SIZE;
+	data_ret.result = 0;
+
+	rc = ping_mdm_data_register(endpoint, &data_arg, &data_ret);
+	if (rc)
+		return rc;
+
+	if (my_sum != data_ret.result) {
+		pr_err("sum mismatch %d %d\n", my_sum, data_ret.result);
+		rc = -1;
+	}
+
+	return rc;
+}
+
+static int ping_mdm_null_test(void)
+{
+	return ping_mdm_null(endpoint);
+}
+
+static int ping_test_release(struct inode *ip, struct file *fp)
+{
+	return ping_mdm_close(endpoint);
+}
+
+static int ping_test_open(struct inode *ip, struct file *fp)
+{
+	int rc = 0;
+
+	endpoint = ping_mdm_init();
+	if (IS_ERR(endpoint)) {
+		pr_err("couldn't open ping client\n");
+		rc = PTR_ERR(endpoint);
+	} else
+		pr_info("connected to remote ping server\n");
+
+	return rc;
+}
+
+static ssize_t ping_test_read(struct file *fp, char __user *buf,
+			size_t count, loff_t *pos)
+{
+	char _buf[16];
+
+	snprintf(_buf, sizeof(_buf), "%i\n", test_res);
+
+	return simple_read_from_buffer(buf, count, pos, _buf, strlen(_buf));
+}
+
+static ssize_t ping_test_write(struct file *fp, const char __user *buf,
+			 size_t count, loff_t *pos)
+{
+	unsigned char cmd[PING_TEST_CMD_BUF_SIZE];
+	int len;
+
+	if (count < 1)
+		return 0;
+
+	len = count > (PING_TEST_CMD_BUF_SIZE - 1) ?
+			(PING_TEST_CMD_BUF_SIZE - 1) : count;
+
+	if (copy_from_user(cmd, buf, len))
+		return -EFAULT;
+
+	cmd[len] = 0;
+
+	/* lazy */
+	if (cmd[len-1] == '\n') {
+		cmd[len-1] = 0;
+		len--;
+	}
+
+	if (!strncmp(cmd, "null_test", PING_TEST_CMD_BUF_SIZE))
+		test_res = ping_mdm_null_test();
+	else if (!strncmp(cmd, "data_reg_test", PING_TEST_CMD_BUF_SIZE))
+		test_res = ping_mdm_data_register_test();
+	else
+		test_res = -EINVAL;
+
+	if (test_res >= 0) {
+		test_res = 0;
+		pr_info("test %s passed\n", cmd);
+	} else
+		pr_info("test %s failed %d\n", cmd, test_res);
+
+	return count;
+}
+
+static const struct file_operations debug_ops = {
+	.owner = THIS_MODULE,
+	.open = ping_test_open,
+	.read = ping_test_read,
+	.write = ping_test_write,
+	.release = ping_test_release,
+};
+
+static void __exit ping_test_exit(void)
+{
+	debugfs_remove(dent);
+}
+
+static int __init ping_test_init(void)
+{
+	dent = debugfs_create_file("ping_mdm", 0444, 0, NULL, &debug_ops);
+	test_res = 0;
+	return 0;
+}
+
+module_init(ping_test_init);
+module_exit(ping_test_exit);
+
+MODULE_DESCRIPTION("PING TEST Driver");
+MODULE_LICENSE("GPL v2");
-- 
1.5.6.3

Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
