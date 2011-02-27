Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752209Ab1B0Vhk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Feb 2011 16:37:40 -0500
Received: from cantor2.suse.de ([195.135.220.15]:33179 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751889Ab1B0Vgu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Feb 2011 16:36:50 -0500
From: Thomas Renninger <trenn@suse.de>
Cc: trenn@suse.de, lenb@kernel.org, mingo@elte.hu,
        linux-kernel@vger.kernel.org, mgross@linux.intel.com
Subject: [PATCH] pm_qos: Make pm_qos settings readable
Date: Sun, 27 Feb 2011 22:36:44 +0100
Message-Id: <1298842606-55712-4-git-send-email-trenn@suse.de>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1298842606-55712-1-git-send-email-trenn@suse.de>
References: <1298842606-55712-1-git-send-email-trenn@suse.de>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have a machine where entering deep C-states broke.
pm_qos was a hot candidate, but I couldn't find any way to double
check without the need of recompiling.

While in this case it was a driver bug (ath9k):
https://bugzilla.kernel.org/show_bug.cgi?id=27532

powertop or others may want to read out cpu_dma_latency
restrictions which could be the cause of preventing a machine
entering deeper C-states.

Output with this patch:

# default value of 2000 * USEC_PER_SEC (0x77359400)
cat /dev/network_latency |hexdump
0000000 9400 7735
0000004

# value of 55 us which is the reason for not entering C2
cat /dev/cpu_dma_latency |hexdump
0000000 0037 0000
0000004

There is no reason to hide this info -> make pm_qos files readable.

Signed-off-by: Thomas Renninger <trenn@suse.de>
CC: mgross@linux.intel.com
CC: mingo@elte.hu
---
 kernel/pm_qos_params.c |   24 ++++++++++++++++++++++++
 1 files changed, 24 insertions(+), 0 deletions(-)

diff --git a/kernel/pm_qos_params.c b/kernel/pm_qos_params.c
index aeaa7f8..0da058b 100644
--- a/kernel/pm_qos_params.c
+++ b/kernel/pm_qos_params.c
@@ -103,11 +103,14 @@ static struct pm_qos_object *pm_qos_array[] = {
 
 static ssize_t pm_qos_power_write(struct file *filp, const char __user *buf,
 		size_t count, loff_t *f_pos);
+static ssize_t pm_qos_power_read(struct file *filp, char __user *buf,
+		size_t count, loff_t *f_pos);
 static int pm_qos_power_open(struct inode *inode, struct file *filp);
 static int pm_qos_power_release(struct inode *inode, struct file *filp);
 
 static const struct file_operations pm_qos_power_fops = {
 	.write = pm_qos_power_write,
+	.read = pm_qos_power_read,
 	.open = pm_qos_power_open,
 	.release = pm_qos_power_release,
 	.llseek = noop_llseek,
@@ -376,6 +379,27 @@ static int pm_qos_power_release(struct inode *inode, struct file *filp)
 }
 
 
+static ssize_t pm_qos_power_read(struct file *filp, char __user *buf,
+		size_t count, loff_t *f_pos)
+{
+	s32 value;
+	unsigned long flags;
+	struct pm_qos_object *o;
+	struct pm_qos_request_list *pm_qos_req = filp->private_data;;
+
+	if (!pm_qos_req)
+		return -EINVAL;
+	if (!pm_qos_request_active(pm_qos_req))
+		return -EINVAL;
+
+	o = pm_qos_array[pm_qos_req->pm_qos_class];
+	spin_lock_irqsave(&pm_qos_lock, flags);
+	value = pm_qos_get_value(o);
+	spin_unlock_irqrestore(&pm_qos_lock, flags);
+
+	return simple_read_from_buffer(buf, count, f_pos, &value, sizeof(s32));
+}
+
 static ssize_t pm_qos_power_write(struct file *filp, const char __user *buf,
 		size_t count, loff_t *f_pos)
 {
-- 
1.7.3.4

