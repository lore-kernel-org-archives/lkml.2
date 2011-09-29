Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755682Ab1I2LCx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 07:02:53 -0400
Received: from service87.mimecast.com ([91.220.42.44]:35180 "HELO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755336Ab1I2LCu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 07:02:50 -0400
Subject: [PATCH 4/4] kmemleak: Report previously found leaks even after an
 error
To: linux-kernel@vger.kernel.org
From: Catalin Marinas <catalin.marinas@arm.com>
Date: Thu, 29 Sep 2011 12:02:39 +0100
Message-ID: <20110929110239.10660.95998.stgit@e102109-lin.cambridge.arm.com>
In-Reply-To: <20110929105940.10660.76130.stgit@e102109-lin.cambridge.arm.com>
References: <20110929105940.10660.76130.stgit@e102109-lin.cambridge.arm.com>
User-Agent: StGit/0.15-118-g0cb4
MIME-Version: 1.0
X-OriginalArrivalTime: 29 Sep 2011 11:02:48.0144 (UTC) FILETIME=[52D03500:01CC7E97]
X-MC-Unique: 111092912024809301
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If an error fatal to kmemleak (like memory allocation failure) happens,
kmemleak disables itself but it also removes the access to any
previously found memory leaks. This patch allows read-only access to the
kmemleak debugfs interface but disables any other action.

Repored-by: Nick Bowler <nbowler@elliptictech.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
---
 mm/kmemleak.c |   22 +++++++++++++---------
 1 files changed, 13 insertions(+), 9 deletions(-)

diff --git a/mm/kmemleak.c b/mm/kmemleak.c
index e6dd17b..381b67a 100644
--- a/mm/kmemleak.c
+++ b/mm/kmemleak.c
@@ -1473,9 +1473,6 @@ static const struct seq_operations kmemleak_seq_ops = {
 
 static int kmemleak_open(struct inode *inode, struct file *file)
 {
-	if (!atomic_read(&kmemleak_enabled))
-		return -EBUSY;
-
 	return seq_open(file, &kmemleak_seq_ops);
 }
 
@@ -1549,6 +1546,9 @@ static ssize_t kmemleak_write(struct file *file, const char __user *user_buf,
 	int buf_size;
 	int ret;
 
+	if (!atomic_read(&kmemleak_enabled))
+		return -EBUSY;
+
 	buf_size = min(size, (sizeof(buf) - 1));
 	if (strncpy_from_user(buf, user_buf, buf_size) < 0)
 		return -EFAULT;
@@ -1608,20 +1608,24 @@ static const struct file_operations kmemleak_fops = {
 };
 
 /*
- * Perform the freeing of the kmemleak internal objects after waiting for any
- * current memory scan to complete.
+ * Stop the memory scanning thread and free the kmemleak internal objects if
+ * no previous scan thread (otherwise, kmemleak may still have some useful
+ * information on memory leaks).
  */
 static void kmemleak_do_cleanup(struct work_struct *work)
 {
 	struct kmemleak_object *object;
+	bool cleanup = scan_thread == NULL;
 
 	mutex_lock(&scan_mutex);
 	stop_scan_thread();
 
-	rcu_read_lock();
-	list_for_each_entry_rcu(object, &object_list, object_list)
-		delete_object_full(object->pointer);
-	rcu_read_unlock();
+	if (cleanup) {
+		rcu_read_lock();
+		list_for_each_entry_rcu(object, &object_list, object_list)
+			delete_object_full(object->pointer);
+		rcu_read_unlock();
+	}
 	mutex_unlock(&scan_mutex);
 }
 


