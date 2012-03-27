Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755585Ab2C0TvR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 15:51:17 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43282 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754400Ab2C0TvN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 15:51:13 -0400
Date: Tue, 27 Mar 2012 12:50:49 -0700
From: tip-bot for Daniel Drake <dsd@laptop.org>
Message-ID: <tip-a3c8121b8724c3d496dc00201ab40e8313edcf0d@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        dsd@laptop.org, dilinger@queued.net, tglx@linutronix.de,
        pgf@laptop.org
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        dsd@laptop.org, dilinger@queued.net, tglx@linutronix.de,
        pgf@laptop.org
In-Reply-To: <20120327150740.667D09D401E@zog.reactivated.net>
References: <20120327150740.667D09D401E@zog.reactivated.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86/olpc: Add debugfs interface for EC commands
Git-Commit-ID: a3c8121b8724c3d496dc00201ab40e8313edcf0d
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 27 Mar 2012 12:50:57 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a3c8121b8724c3d496dc00201ab40e8313edcf0d
Gitweb:     http://git.kernel.org/tip/a3c8121b8724c3d496dc00201ab40e8313edcf0d
Author:     Daniel Drake <dsd@laptop.org>
AuthorDate: Tue, 27 Mar 2012 16:07:40 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 27 Mar 2012 20:54:52 +0200

x86/olpc: Add debugfs interface for EC commands

Add a debugfs interface for sending commands to the OLPC
Embedded Controller (EC) and reading the responses.  The EC
provides functionality for machine identification, battery and
AC control, wakeup control, etc.

Having a debugfs interface available is useful for EC
development and debugging.

Based on code by Paul Fox (who also approves of the end result).

Signed-off-by: Daniel Drake <dsd@laptop.org>
Acked-by: Paul Fox <pgf@laptop.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andres Salomon <dilinger@queued.net>
Link: http://lkml.kernel.org/r/20120327150740.667D09D401E@zog.reactivated.net
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 Documentation/ABI/testing/debugfs-olpc |   16 +++++
 arch/x86/platform/olpc/olpc.c          |   97 ++++++++++++++++++++++++++++++++
 2 files changed, 113 insertions(+), 0 deletions(-)

diff --git a/Documentation/ABI/testing/debugfs-olpc b/Documentation/ABI/testing/debugfs-olpc
new file mode 100644
index 0000000..bd76cc6
--- /dev/null
+++ b/Documentation/ABI/testing/debugfs-olpc
@@ -0,0 +1,16 @@
+What:		/sys/kernel/debug/olpc-ec/cmd
+Date:		Dec 2011
+KernelVersion:	3.4
+Contact:	devel@lists.laptop.org
+Description:
+
+A generic interface for executing OLPC Embedded Controller commands and
+reading their responses.
+
+To execute a command, write data with the format: CC:N A A A A
+CC is the (hex) command, N is the count of expected reply bytes, and A A A A
+are optional (hex) arguments.
+
+To read the response (if any), read from the generic node after executing
+a command. Hex reply bytes will be returned, *whether or not* they came from
+the immediately previous command.
diff --git a/arch/x86/platform/olpc/olpc.c b/arch/x86/platform/olpc/olpc.c
index 7cce722..a4bee53 100644
--- a/arch/x86/platform/olpc/olpc.c
+++ b/arch/x86/platform/olpc/olpc.c
@@ -20,6 +20,8 @@
 #include <linux/platform_device.h>
 #include <linux/of.h>
 #include <linux/syscore_ops.h>
+#include <linux/debugfs.h>
+#include <linux/mutex.h>
 
 #include <asm/geode.h>
 #include <asm/setup.h>
@@ -31,6 +33,15 @@ EXPORT_SYMBOL_GPL(olpc_platform_info);
 
 static DEFINE_SPINLOCK(ec_lock);
 
+/* debugfs interface to EC commands */
+#define EC_MAX_CMD_ARGS (5 + 1)	/* cmd byte + 5 args */
+#define EC_MAX_CMD_REPLY (8)
+
+static struct dentry *ec_debugfs_dir;
+static DEFINE_MUTEX(ec_debugfs_cmd_lock);
+static unsigned char ec_debugfs_resp[EC_MAX_CMD_REPLY];
+static unsigned int ec_debugfs_resp_bytes;
+
 /* EC event mask to be applied during suspend (defining wakeup sources). */
 static u16 ec_wakeup_mask;
 
@@ -269,6 +280,91 @@ int olpc_ec_sci_query(u16 *sci_value)
 }
 EXPORT_SYMBOL_GPL(olpc_ec_sci_query);
 
+static ssize_t ec_debugfs_cmd_write(struct file *file, const char __user *buf,
+				    size_t size, loff_t *ppos)
+{
+	int i, m;
+	unsigned char ec_cmd[EC_MAX_CMD_ARGS];
+	unsigned int ec_cmd_int[EC_MAX_CMD_ARGS];
+	char cmdbuf[64];
+	int ec_cmd_bytes;
+
+	mutex_lock(&ec_debugfs_cmd_lock);
+
+	size = simple_write_to_buffer(cmdbuf, sizeof(cmdbuf), ppos, buf, size);
+
+	m = sscanf(cmdbuf, "%x:%u %x %x %x %x %x", &ec_cmd_int[0],
+		   &ec_debugfs_resp_bytes,
+		   &ec_cmd_int[1], &ec_cmd_int[2], &ec_cmd_int[3],
+		   &ec_cmd_int[4], &ec_cmd_int[5]);
+	if (m < 2 || ec_debugfs_resp_bytes > EC_MAX_CMD_REPLY) {
+		/* reset to prevent overflow on read */
+		ec_debugfs_resp_bytes = 0;
+
+		printk(KERN_DEBUG "olpc-ec: bad ec cmd:  "
+		       "cmd:response-count [arg1 [arg2 ...]]\n");
+		size = -EINVAL;
+		goto out;
+	}
+
+	/* convert scanf'd ints to char */
+	ec_cmd_bytes = m - 2;
+	for (i = 0; i <= ec_cmd_bytes; i++)
+		ec_cmd[i] = ec_cmd_int[i];
+
+	printk(KERN_DEBUG "olpc-ec: debugfs cmd 0x%02x with %d args "
+	       "%02x %02x %02x %02x %02x, want %d returns\n",
+	       ec_cmd[0], ec_cmd_bytes, ec_cmd[1], ec_cmd[2], ec_cmd[3],
+	       ec_cmd[4], ec_cmd[5], ec_debugfs_resp_bytes);
+
+	olpc_ec_cmd(ec_cmd[0], (ec_cmd_bytes == 0) ? NULL : &ec_cmd[1],
+		    ec_cmd_bytes, ec_debugfs_resp, ec_debugfs_resp_bytes);
+
+	printk(KERN_DEBUG "olpc-ec: response "
+	       "%02x %02x %02x %02x %02x %02x %02x %02x (%d bytes expected)\n",
+	       ec_debugfs_resp[0], ec_debugfs_resp[1], ec_debugfs_resp[2],
+	       ec_debugfs_resp[3], ec_debugfs_resp[4], ec_debugfs_resp[5],
+	       ec_debugfs_resp[6], ec_debugfs_resp[7], ec_debugfs_resp_bytes);
+
+out:
+	mutex_unlock(&ec_debugfs_cmd_lock);
+	return size;
+}
+
+static ssize_t ec_debugfs_cmd_read(struct file *file, char __user *buf,
+				   size_t size, loff_t *ppos)
+{
+	unsigned int i, r;
+	char *rp;
+	char respbuf[64];
+
+	mutex_lock(&ec_debugfs_cmd_lock);
+	rp = respbuf;
+	rp += sprintf(rp, "%02x", ec_debugfs_resp[0]);
+	for (i = 1; i < ec_debugfs_resp_bytes; i++)
+		rp += sprintf(rp, ", %02x", ec_debugfs_resp[i]);
+	mutex_unlock(&ec_debugfs_cmd_lock);
+	rp += sprintf(rp, "\n");
+
+	r = rp - respbuf;
+	return simple_read_from_buffer(buf, size, ppos, respbuf, r);
+}
+
+static const struct file_operations ec_debugfs_genops = {
+	.write	 = ec_debugfs_cmd_write,
+	.read	 = ec_debugfs_cmd_read,
+};
+
+static void setup_debugfs(void)
+{
+	ec_debugfs_dir = debugfs_create_dir("olpc-ec", 0);
+	if (ec_debugfs_dir == ERR_PTR(-ENODEV))
+		return;
+
+	debugfs_create_file("cmd", 0600, ec_debugfs_dir, NULL,
+			    &ec_debugfs_genops);
+}
+
 static int olpc_ec_suspend(void)
 {
 	return olpc_ec_mask_write(ec_wakeup_mask);
@@ -372,6 +468,7 @@ static int __init olpc_init(void)
 	}
 
 	register_syscore_ops(&olpc_syscore_ops);
+	setup_debugfs();
 
 	return 0;
 }
