Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756685Ab1KPQZV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 11:25:21 -0500
Received: from mtaout03-winn.ispmail.ntl.com ([81.103.221.49]:24343 "EHLO
	mtaout03-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755472Ab1KPQZS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 11:25:18 -0500
X-Greylist: delayed 707 seconds by postgrey-1.27 at vger.kernel.org; Wed, 16 Nov 2011 11:25:18 EST
From: Daniel Drake <dsd@laptop.org>
To: x86@kernel.org
To: tglx@linutronix.de
To: mingo@redhat.com
To: hpa@zytor.com
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Cc: dilinger@queued.net
Cc: pgf@laptop.org
Subject: [PATCH resend] x86, olpc: add debugfs interface for EC commands
Message-Id: <20111116162511.E38309D401E@zog.reactivated.net>
Date: Wed, 16 Nov 2011 16:25:11 +0000 (GMT)
X-Cloudmark-Analysis: v=1.1 cv=R50lirqlHffDPPkwUlkuVa99MrvKdVWo//yz83qex8g= c=1 sm=0 a=zUtE6SkQdYoA:10 a=vJ1w_8FsMGIA:10 a=Op-mwl0xAAAA:8 a=z9N-Lmhe6hI0i5wcIpgA:9 a=lRrSHur630LihywNtb8A:7 a=d4CUUju0HPYA:10 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a debugfs interface for sending commands to the OLPC EC and reading
their responses. This is useful for EC development and debugging.

Based on code by Paul Fox.

Signed-off-by: Daniel Drake <dsd@laptop.org>
---
 arch/x86/platform/olpc/olpc.c |  101 +++++++++++++++++++++++++++++++++++++++++
 1 files changed, 101 insertions(+), 0 deletions(-)

Resending after 4 weeks with no feedback.

diff --git a/arch/x86/platform/olpc/olpc.c b/arch/x86/platform/olpc/olpc.c
index 7cce722..860aff9 100644
--- a/arch/x86/platform/olpc/olpc.c
+++ b/arch/x86/platform/olpc/olpc.c
@@ -20,6 +20,7 @@
 #include <linux/platform_device.h>
 #include <linux/of.h>
 #include <linux/syscore_ops.h>
+#include <linux/debugfs.h>
 
 #include <asm/geode.h>
 #include <asm/setup.h>
@@ -31,6 +32,13 @@ EXPORT_SYMBOL_GPL(olpc_platform_info);
 
 static DEFINE_SPINLOCK(ec_lock);
 
+/* debugfs interface to EC commands */
+#define EC_MAX_CMD_ARGS (5 + 1)	/* cmd byte + 5 args */
+#define EC_MAX_CMD_REPLY (8)
+static struct dentry *ec_debugfs_dir;
+static unsigned char ec_debugfs_resp[EC_MAX_CMD_REPLY];
+static unsigned int ec_debugfs_resp_bytes;
+
 /* EC event mask to be applied during suspend (defining wakeup sources). */
 static u16 ec_wakeup_mask;
 
@@ -269,6 +277,98 @@ int olpc_ec_sci_query(u16 *sci_value)
 }
 EXPORT_SYMBOL_GPL(olpc_ec_sci_query);
 
+static ssize_t ec_gen_write(struct file *file, const char __user *buf,
+			    size_t size, loff_t *ppos)
+{
+	int i, m;
+	unsigned char ec_cmd[EC_MAX_CMD_ARGS];
+	unsigned int ec_cmd_int[EC_MAX_CMD_ARGS];
+	char cmdbuf[64];
+	int ec_cmd_bytes;
+
+	size = simple_write_to_buffer(cmdbuf, sizeof(cmdbuf), ppos, buf, size);
+
+	m = sscanf(cmdbuf, "%x:%u %x %x %x %x %x", &ec_cmd_int[0],
+		   &ec_debugfs_resp_bytes,
+		   &ec_cmd_int[1], &ec_cmd_int[2], &ec_cmd_int[3],
+		   &ec_cmd_int[4], &ec_cmd_int[5]);
+	if (m <= 0 || ec_debugfs_resp_bytes > EC_MAX_CMD_REPLY) {
+		printk(KERN_DEBUG "olpc-ec: bad ec cmd:  "
+		       "cmd:response-count [arg1 [arg2 ...]]\n");
+		return -EINVAL;
+	}
+
+	/* convert scanf'd ints to char */
+	for (i = 0; i < EC_MAX_CMD_ARGS; i++)
+		ec_cmd[i] = ec_cmd_int[i];
+
+	ec_cmd_bytes = m - 2;
+
+	printk(KERN_DEBUG "olpc-ec: debugfs cmd 0x%02x with %d args "
+	       "%02x %02x %02x %02x %02x, want %d returns\n",
+	       ec_cmd[0], ec_cmd_bytes, ec_cmd[1], ec_cmd[2], ec_cmd[3],
+	       ec_cmd[4], ec_cmd[5], ec_debugfs_resp_bytes);
+
+	olpc_ec_cmd((unsigned char) ec_cmd[0],
+		(ec_cmd_bytes == 0) ? NULL : &ec_cmd[1],
+		ec_cmd_bytes, ec_debugfs_resp, ec_debugfs_resp_bytes);
+
+	printk(KERN_DEBUG "olpc-ec: response "
+	       "%02x %02x %02x %02x %02x %02x %02x %02x (%d bytes expected)\n",
+	       ec_debugfs_resp[0], ec_debugfs_resp[1], ec_debugfs_resp[2],
+	       ec_debugfs_resp[3], ec_debugfs_resp[4], ec_debugfs_resp[5],
+	       ec_debugfs_resp[6], ec_debugfs_resp[7], ec_debugfs_resp_bytes);
+
+	return size;
+}
+
+static ssize_t ec_gen_read(struct file *file, char __user *buf,
+			   size_t size, loff_t *ppos)
+{
+	unsigned int i, r;
+	char *rp;
+	char respbuf[64];
+
+	rp = respbuf;
+	rp += sprintf(rp, "%02x", ec_debugfs_resp[0]);
+	for (i = 1; i < ec_debugfs_resp_bytes; i++)
+		rp += sprintf(rp, ", %02x", ec_debugfs_resp[i]);
+	rp += sprintf(rp, "\n");
+
+	r = rp - respbuf;
+
+	return simple_read_from_buffer(buf, size, ppos, respbuf, r);
+}
+
+static const struct file_operations ec_debugfs_genops = {
+	.write	 = ec_gen_write,
+	.read	 = ec_gen_read,
+};
+
+static char ec_debugfs_help_text[] =
+	"generic write:   CC:N A A A A ...\n"
+	" CC is the (hex) command, N is the (optional) count of expected\n"
+	" reply bytes, and A A A A are optional (hex) arguments.\n"
+	"generic read:  will show hex reply bytes, *whether or not* they\n"
+	" came from the immediately previous command\n";
+
+static struct debugfs_blob_wrapper ec_debugfs_help = {
+	ec_debugfs_help_text,
+	sizeof(ec_debugfs_help_text)
+};
+
+static void setup_debugfs(void)
+{
+	ec_debugfs_dir = debugfs_create_dir("olpc-ec", 0);
+	if (ec_debugfs_dir == ERR_PTR(-ENODEV))
+		return;
+
+	debugfs_create_file("generic", 0600, ec_debugfs_dir, NULL,
+			    &ec_debugfs_genops);
+
+	debugfs_create_blob("help", 0444, ec_debugfs_dir, &ec_debugfs_help);
+}
+
 static int olpc_ec_suspend(void)
 {
 	return olpc_ec_mask_write(ec_wakeup_mask);
@@ -372,6 +472,7 @@ static int __init olpc_init(void)
 	}
 
 	register_syscore_ops(&olpc_syscore_ops);
+	setup_debugfs();
 
 	return 0;
 }
-- 
1.7.7.1

