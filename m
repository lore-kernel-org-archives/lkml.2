Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753978Ab0ILUbu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Sep 2010 16:31:50 -0400
Received: from smtp-out.google.com ([216.239.44.51]:39392 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753888Ab0ILUbs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Sep 2010 16:31:48 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
	b=Ih15zqjzkv8K2d5GftMrhYykotosolPxfvMHcolXsYG5PDp9WJMIsMDCx3wVgDGvK
	bNmaBV821UVeYalRjqFZw==
From: Michael Rubin <mrubin@google.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org
Cc: fengguang.wu@intel.com, jack@suse.cz, riel@redhat.com,
        akpm@linux-foundation.org, david@fromorbit.com,
        kosaki.motohiro@jp.fujitsu.com, npiggin@kernel.dk, hch@lst.de,
        axboe@kernel.dk, Michael Rubin <mrubin@google.com>
Subject: [PATCH 4/5] writeback: Adding /sys/devices/system/node/<node>/vmstat
Date: Sun, 12 Sep 2010 13:30:39 -0700
Message-Id: <1284323440-23205-5-git-send-email-mrubin@google.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1284323440-23205-1-git-send-email-mrubin@google.com>
References: <1284323440-23205-1-git-send-email-mrubin@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For NUMA node systems it is important to have visibility in memory
characteristics. Two of the /proc/vmstat values "nr_cleaned" and
"nr_dirtied" are added here.

	# cat /sys/devices/system/node/node20/vmstat
	nr_cleaned 0
	nr_dirtied 0

Signed-off-by: Michael Rubin <mrubin@google.com>
---
 drivers/base/node.c |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/drivers/base/node.c b/drivers/base/node.c
index 2872e86..6aaccd9 100644
--- a/drivers/base/node.c
+++ b/drivers/base/node.c
@@ -160,6 +160,18 @@ static ssize_t node_read_numastat(struct sys_device * dev,
 }
 static SYSDEV_ATTR(numastat, S_IRUGO, node_read_numastat, NULL);
 
+static ssize_t node_read_vmstat(struct sys_device *dev,
+				struct sysdev_attribute *attr, char *buf)
+{
+	int nid = dev->id;
+	return sprintf(buf,
+		"nr_written %lu\n"
+		"nr_dirtied %lu\n",
+		node_page_state(nid, NR_WRITTEN),
+		node_page_state(nid, NR_FILE_DIRTIED));
+}
+static SYSDEV_ATTR(vmstat, S_IRUGO, node_read_vmstat, NULL);
+
 static ssize_t node_read_distance(struct sys_device * dev,
 			struct sysdev_attribute *attr, char * buf)
 {
@@ -243,6 +255,7 @@ int register_node(struct node *node, int num, struct node *parent)
 		sysdev_create_file(&node->sysdev, &attr_meminfo);
 		sysdev_create_file(&node->sysdev, &attr_numastat);
 		sysdev_create_file(&node->sysdev, &attr_distance);
+		sysdev_create_file(&node->sysdev, &attr_vmstat);
 
 		scan_unevictable_register_node(node);
 
@@ -267,6 +280,7 @@ void unregister_node(struct node *node)
 	sysdev_remove_file(&node->sysdev, &attr_meminfo);
 	sysdev_remove_file(&node->sysdev, &attr_numastat);
 	sysdev_remove_file(&node->sysdev, &attr_distance);
+	sysdev_remove_file(&node->sysdev, &attr_vmstat);
 
 	scan_unevictable_unregister_node(node);
 	hugetlb_unregister_node(node);		/* no-op, if memoryless node */
-- 
1.7.1

