Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932528Ab1CRRqe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 13:46:34 -0400
Received: from mail6.webfaction.com ([74.55.86.74]:60604 "EHLO
	smtp.webfaction.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932477Ab1CRRqS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 13:46:18 -0400
From: Tony Ibbs <tibs@tonyibbs.co.uk>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Linux-embedded <linux-embedded@vger.kernel.org>,
        Tibs at Kynesim <tibs@kynesim.co.uk>,
        Richard Watts <rrw@kynesim.co.uk>,
        Grant Likely <grant.likely@secretlab.ca>,
        Tony Ibbs <tibs@tonyibbs.co.uk>
Subject: [PATCH 10/11] KBUS report state to userspace
Date: Fri, 18 Mar 2011 17:21:19 +0000
Message-Id: <667f715f19ff4543cedc10361db357ce844e73b1.1300450604.git.tibs@tonyibbs.co.uk>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <c6d9cea99c649d41ae838838a0e8da3807b98e64.1300450604.git.tibs@tonyibbs.co.uk>
References: <cover.1300450604.git.tibs@tonyibbs.co.uk>
 <273ee9658cbcbe19adfa0d7b30082d8966e70afc.1300450604.git.tibs@tonyibbs.co.uk>
 <979f23cd5f8a9ac727f17ad359ee487cbccbf7f6.1300450604.git.tibs@tonyibbs.co.uk>
 <c28914a66ae5526f18c331475298e7ef05bf57c7.1300450604.git.tibs@tonyibbs.co.uk>
 <ffc9b735a3b61c51881c108235155384a6e6f56c.1300450604.git.tibs@tonyibbs.co.uk>
 <e1e0c80ed995eccd4881081f5a769acb148b267b.1300450604.git.tibs@tonyibbs.co.uk>
 <023b39071aff3abc8e63336be501742333ceeced.1300450604.git.tibs@tonyibbs.co.uk>
 <6038dbd7e203bc102bd5d33ad9f1aa4f204a3a2e.1300450604.git.tibs@tonyibbs.co.uk>
 <100daf735e4bcf057ca5e84c391f04fa7dea1aaf.1300450604.git.tibs@tonyibbs.co.uk>
 <c6d9cea99c649d41ae838838a0e8da3807b98e64.1300450604.git.tibs@tonyibbs.co.uk>
In-Reply-To: <cover.1300450604.git.tibs@tonyibbs.co.uk>
References: <cover.1300450604.git.tibs@tonyibbs.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This introduces two pseudo-files which expose some of the current
KBUS internal state. The bindings file, in particular, is used
in the KBUS test scripts (which are part of the userspace Python
binding).

Signed-off-by: Tony Ibbs <tibs@tonyibbs.co.uk>
---
 ipc/kbus_report.c |  256 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 256 insertions(+), 0 deletions(-)
 create mode 100644 ipc/kbus_report.c

diff --git a/ipc/kbus_report.c b/ipc/kbus_report.c
new file mode 100644
index 0000000..ba07254
--- /dev/null
+++ b/ipc/kbus_report.c
@@ -0,0 +1,256 @@
+/* KBUS kernel module - general reporting to userspace
+ */
+
+/*
+ * ***** BEGIN LICENSE BLOCK *****
+ * Version: MPL 1.1
+ *
+ * The contents of this file are subject to the Mozilla Public License Version
+ * 1.1 (the "License"); you may not use this file except in compliance with
+ * the License. You may obtain a copy of the License at
+ * http://www.mozilla.org/MPL/
+ *
+ * Software distributed under the License is distributed on an "AS IS" basis,
+ * WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
+ * for the specific language governing rights and limitations under the
+ * License.
+ *
+ * The Original Code is the KBUS Lightweight Linux-kernel mediated
+ * message system
+ *
+ * The Initial Developer of the Original Code is Kynesim, Cambridge UK.
+ * Portions created by the Initial Developer are Copyright (C) 2009
+ * the Initial Developer. All Rights Reserved.
+ *
+ * Contributor(s):
+ *   Kynesim, Cambridge UK
+ *   Tony Ibbs <tibs@tonyibbs.co.uk>
+ *
+ * Alternatively, the contents of this file may be used under the terms of the
+ * GNU Public License version 2 (the "GPL"), in which case the provisions of
+ * the GPL are applicable instead of the above.  If you wish to allow the use
+ * of your version of this file only under the terms of the GPL and not to
+ * allow others to use your version of this file under the MPL, indicate your
+ * decision by deleting the provisions above and replace them with the notice
+ * and other provisions required by the GPL.  If you do not delete the
+ * provisions above, a recipient may use your version of this file under either
+ * the MPL or the GPL.
+ *
+ * ***** END LICENSE BLOCK *****
+ */
+
+#include <linux/module.h>
+#include <linux/cdev.h>
+#include <linux/proc_fs.h>
+#include <linux/seq_file.h>
+
+#include <linux/kbus_defns.h>
+#include "kbus_internal.h"
+
+/* /proc */
+static struct proc_dir_entry *kbus_proc_dir;
+static struct proc_dir_entry *kbus_proc_file_bindings;
+static struct proc_dir_entry *kbus_proc_file_stats;
+
+/* What's the symbolic name of a message part? */
+static const char *kbus_msg_part_name(enum kbus_msg_parts p)
+{
+	switch (p) {
+	case KBUS_PART_HDR:	return "HDR";
+	case KBUS_PART_NAME:	return "NAME";
+	case KBUS_PART_NPAD:	return "NPAD";
+	case KBUS_PART_DATA:	return "DATA";
+	case KBUS_PART_DPAD:	return "DPAD";
+	case KBUS_PART_FINAL_GUARD:	return "FINAL";
+	}
+
+	pr_err("kbus: unhandled enum lookup %d in "
+		   "kbus_msg_part_name - memory corruption?", p);
+	return "???";
+}
+
+/*
+ * Report on the current bindings, via /proc/kbus/bindings
+ */
+
+static int kbus_binding_seq_show(struct seq_file *s, void *v __always_unused)
+{
+	int ii;
+	int kbus_num_devices;
+	struct kbus_dev **kbus_devices;
+
+	kbus_get_device_data(&kbus_num_devices, &kbus_devices);
+
+	/* We report on all of the KBUS devices */
+	for (ii = 0; ii < kbus_num_devices; ii++) {
+		struct kbus_dev *dev = kbus_devices[ii];
+
+		struct kbus_message_binding *ptr;
+		struct kbus_message_binding *next;
+
+		if (mutex_lock_interruptible(&dev->mux))
+			return -ERESTARTSYS;
+
+		seq_printf(s,
+			   "# <device> is bound to <Ksock-ID> in <process-PID>"
+			   " as <Replier|Listener> for <message-name>\n");
+
+		list_for_each_entry_safe(ptr, next, &dev->bound_message_list,
+					 list) {
+			seq_printf(s, "%3u: %8u %8lu  %c  %.*s\n", dev->index,
+				   ptr->bound_to_id,
+				   (long unsigned)ptr->bound_to->pid,
+				   (ptr->is_replier ? 'R' : 'L'),
+				   ptr->name_len, ptr->name);
+		}
+
+		mutex_unlock(&dev->mux);
+	}
+	return 0;
+}
+
+static int kbus_proc_bindings_open(struct inode *inode __always_unused,
+				   struct file *file)
+{
+	return single_open(file, kbus_binding_seq_show, NULL);
+}
+
+static const struct file_operations kbus_proc_binding_file_ops = {
+	.owner = THIS_MODULE,
+	.open = kbus_proc_bindings_open,
+	.read = seq_read,
+	.llseek = seq_lseek,
+	.release = seq_release
+};
+
+static struct proc_dir_entry
+*kbus_create_proc_binding_file(struct proc_dir_entry *directory)
+{
+	struct proc_dir_entry *entry =
+	    create_proc_entry("bindings", 0, directory);
+	if (entry)
+		entry->proc_fops = &kbus_proc_binding_file_ops;
+	return entry;
+}
+
+/*
+ * Report on whatever statistics seem like they might be useful,
+ * via /proc/kbus/stats
+ */
+
+static int kbus_stats_seq_show(struct seq_file *s, void *v __always_unused)
+{
+	int ii;
+	int kbus_num_devices;
+	struct kbus_dev **kbus_devices;
+
+	kbus_get_device_data(&kbus_num_devices, &kbus_devices);
+
+	/* We report on all of the KBUS devices */
+	for (ii = 0; ii < kbus_num_devices; ii++) {
+		struct kbus_dev *dev = kbus_devices[ii];
+
+		struct kbus_private_data *ptr;
+		struct kbus_private_data *next;
+
+		if (mutex_lock_interruptible(&dev->mux))
+			return -ERESTARTSYS;
+
+		seq_printf(s,
+			 "dev %2u: next ksock %u next msg %u "
+			 "unsent unbindings %u%s\n",
+			 dev->index, dev->next_ksock_id,
+			 dev->next_msg_serial_num,
+			 dev->unsent_unbind_msg_count,
+			 (dev->unsent_unbind_is_tragic ? "(gone tragic)" : ""));
+
+		list_for_each_entry_safe(ptr, next,
+					 &dev->open_ksock_list, list) {
+
+			u32 left = kbus_lenleft(ptr);
+			u32 total;
+			if (ptr->read.msg)
+				total =
+				    KBUS_ENTIRE_MSG_LEN(ptr->read.msg->name_len,
+						ptr->read.msg->data_len);
+			else
+				total = 0;
+
+			seq_printf(s, "    ksock %u last msg %u:%u "
+					"queue %u of %u\n",
+				   ptr->id, ptr->last_msg_id_sent.network_id,
+				   ptr->last_msg_id_sent.serial_num,
+				   ptr->message_count, ptr->max_messages);
+
+			seq_printf(s, "      read byte %u of %u, "
+				"wrote byte %u of %s (%sfinished), "
+				"%ssending\n",
+				   (total - left), total, ptr->write.pos,
+				   kbus_msg_part_name(ptr->write.which),
+				   ptr->write.is_finished ? "" : "not ",
+				   ptr->sending ? "" : "not ");
+
+			seq_printf(s, "      outstanding requests %u "
+					"(size %u, max %u), "
+					"unsent replies %u (max %u)\n",
+					ptr->outstanding_requests.count,
+					ptr->outstanding_requests.size,
+					ptr->outstanding_requests.max_count,
+					ptr->num_replies_unsent,
+					ptr->max_replies_unsent);
+		}
+		mutex_unlock(&dev->mux);
+	}
+
+	return 0;
+}
+
+static int kbus_proc_stats_open(struct inode *inode __always_unused,
+				struct file *file)
+{
+	return single_open(file, kbus_stats_seq_show, NULL);
+}
+
+static const struct file_operations kbus_proc_stats_file_ops = {
+	.owner = THIS_MODULE,
+	.open = kbus_proc_stats_open,
+	.read = seq_read,
+	.llseek = seq_lseek,
+	.release = seq_release
+};
+
+static struct proc_dir_entry
+*kbus_create_proc_stats_file(struct proc_dir_entry *directory)
+{
+	struct proc_dir_entry *entry = create_proc_entry("stats", 0, directory);
+	if (entry)
+		entry->proc_fops = &kbus_proc_stats_file_ops;
+	return entry;
+}
+
+/* ========================================================================= */
+
+extern void kbus_setup_reporting(void)
+{
+	/* Within the /proc/kbus directory, we have: */
+	kbus_proc_dir = proc_mkdir("kbus", NULL);
+	if (kbus_proc_dir) {
+		/* /proc/kbus/bindings -- message name bindings */
+		kbus_proc_file_bindings =
+		    kbus_create_proc_binding_file(kbus_proc_dir);
+		/* /proc/kbus/stats -- miscellaneous statistics */
+		kbus_proc_file_stats =
+		    kbus_create_proc_stats_file(kbus_proc_dir);
+	}
+}
+
+extern void kbus_remove_reporting(void)
+{
+	if (kbus_proc_dir) {
+		if (kbus_proc_file_bindings)
+			remove_proc_entry("bindings", kbus_proc_dir);
+		if (kbus_proc_file_stats)
+			remove_proc_entry("stats", kbus_proc_dir);
+		remove_proc_entry("kbus", NULL);
+	}
+}
-- 
1.7.4.1

