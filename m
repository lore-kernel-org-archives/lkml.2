Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752015Ab1BZJXS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Feb 2011 04:23:18 -0500
Received: from slow3-v.mail.gandi.net ([217.70.178.89]:53075 "EHLO
	slow3-v.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751938Ab1BZJXL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Feb 2011 04:23:11 -0500
X-WhiteListed: mail was accepted with no delay
X-WhiteListed: mail was accepted with no delay
X-WhiteListed: mail was accepted with no delay
X-WhiteListed: mail was accepted with no delay
X-Originating-IP: 217.70.178.37
X-Originating-IP: 82.241.209.44
From: Corentin Chary <corentincj@iksaif.net>
To: Matthew Garrett <mjg@redhat.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Corentin Chary <corentincj@iksaif.net>,
        acpi4asus-user@lists.sourceforge.net (open list:ASUS NOTEBOOKS AN...),
        platform-driver-x86@vger.kernel.org (open list:ASUS NOTEBOOKS AN...),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 10/14] asus-wmi: allow debugfs interface to call arbitrary method
Date: Sat, 26 Feb 2011 10:20:39 +0100
Message-Id: <1298712045-17671-11-git-send-email-corentincj@iksaif.net>
X-Mailer: git-send-email 1.7.4
In-Reply-To: <1298712045-17671-1-git-send-email-corentincj@iksaif.net>
References: <1298712045-17671-1-git-send-email-corentincj@iksaif.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Also add some # format flags to debugfs output.

Signed-off-by: Corentin Chary <corentincj@iksaif.net>
---
 drivers/platform/x86/asus-wmi.c |   47 +++++++++++++++++++++++++++++++++++++-
 1 files changed, 45 insertions(+), 2 deletions(-)

diff --git a/drivers/platform/x86/asus-wmi.c b/drivers/platform/x86/asus-wmi.c
index 88596ea..9095c28 100644
--- a/drivers/platform/x86/asus-wmi.c
+++ b/drivers/platform/x86/asus-wmi.c
@@ -112,11 +112,14 @@ struct bios_args {
  * <platform>/    - debugfs root directory
  *   dev_id      - current dev_id
  *   ctrl_param  - current ctrl_param
+ *   method_id   - current method_id
  *   devs        - call DEVS(dev_id, ctrl_param) and print result
  *   dsts        - call DSTS(dev_id)  and print result
+ *   call        - call method_id(dev_id, ctrl_param) and print result
  */
 struct asus_wmi_debug {
 	struct dentry *root;
+	u32 method_id;
 	u32 dev_id;
 	u32 ctrl_param;
 };
@@ -1138,7 +1141,7 @@ static int show_dsts(struct seq_file *m, void *data)
 	if (err < 0)
 		return err;
 
-	seq_printf(m, "DSTS(%x) = %x\n", asus->debug.dev_id, retval);
+	seq_printf(m, "DSTS(%#x) = %#x\n", asus->debug.dev_id, retval);
 
 	return 0;
 }
@@ -1155,15 +1158,50 @@ static int show_devs(struct seq_file *m, void *data)
 	if (err < 0)
 		return err;
 
-	seq_printf(m, "DEVS(%x, %x) = %x\n", asus->debug.dev_id,
+	seq_printf(m, "DEVS(%#x, %#x) = %#x\n", asus->debug.dev_id,
 		   asus->debug.ctrl_param, retval);
 
 	return 0;
 }
 
+static int show_call(struct seq_file *m, void *data)
+{
+	struct asus_wmi *asus = m->private;
+	struct bios_args args = {
+		.arg0 = asus->debug.dev_id,
+		.arg1 = asus->debug.ctrl_param,
+	};
+	struct acpi_buffer input = { (acpi_size) sizeof(args), &args };
+	struct acpi_buffer output = { ACPI_ALLOCATE_BUFFER, NULL };
+	union acpi_object *obj;
+	acpi_status status;
+
+	status = wmi_evaluate_method(ASUS_WMI_MGMT_GUID,
+				     1, asus->debug.method_id,
+				     &input, &output);
+
+	if (ACPI_FAILURE(status))
+		return -EIO;
+
+	obj = (union acpi_object *)output.pointer;
+	if (obj && obj->type == ACPI_TYPE_INTEGER)
+		seq_printf(m, "%#x(%#x, %#x) = %#x\n", asus->debug.method_id,
+			   asus->debug.dev_id, asus->debug.ctrl_param,
+			   (u32) obj->integer.value);
+	else
+		seq_printf(m, "%#x(%#x, %#x) = t:%d\n", asus->debug.method_id,
+			   asus->debug.dev_id, asus->debug.ctrl_param,
+			   obj->type);
+
+	kfree(obj);
+
+	return 0;
+}
+
 static struct asus_wmi_debugfs_node asus_wmi_debug_files[] = {
 	{NULL, "devs", show_devs},
 	{NULL, "dsts", show_dsts},
+	{NULL, "call", show_call},
 };
 
 static int asus_wmi_debugfs_open(struct inode *inode, struct file *file)
@@ -1197,6 +1235,11 @@ static int asus_wmi_debugfs_init(struct asus_wmi *asus)
 		goto error_debugfs;
 	}
 
+	dent = debugfs_create_x32("method_id", S_IRUGO | S_IWUSR,
+				  asus->debug.root, &asus->debug.method_id);
+	if (!dent)
+		goto error_debugfs;
+
 	dent = debugfs_create_x32("dev_id", S_IRUGO | S_IWUSR,
 				  asus->debug.root, &asus->debug.dev_id);
 	if (!dent)
-- 
1.7.4

