Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756219Ab2K1XXr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 18:23:47 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44391 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753543Ab2K1XXq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 18:23:46 -0500
From: Jeff Moyer <jmoyer@redhat.com>
To: Jens Axboe <jaxboe@fusionio.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: [patch] bdi: add a user-tunable cpu_list for the bdi flusher threads
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Wed, 28 Nov 2012 18:23:41 -0500
Message-ID: <x49boehtipu.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

In realtime environments, it may be desirable to keep the per-bdi
flusher threads from running on certain cpus.  This patch adds a
cpu_list file to /sys/class/bdi/* to enable this.  The default is to tie
the flusher threads to the same numa node as the backing device (though
I could be convinced to make it a mask of all cpus to avoid a change in
behaviour).

Comments, as always, are appreciated.

Cheers,
Jeff

Signed-off-by: Jeff Moyer <jmoyer@redhat.com>

diff --git a/include/linux/backing-dev.h b/include/linux/backing-dev.h
index 2a9a9ab..68263e0 100644
--- a/include/linux/backing-dev.h
+++ b/include/linux/backing-dev.h
@@ -18,6 +18,7 @@
 #include <linux/writeback.h>
 #include <linux/atomic.h>
 #include <linux/sysctl.h>
+#include <linux/mutex.h>
 
 struct page;
 struct device;
@@ -105,6 +106,9 @@ struct backing_dev_info {
 
 	struct timer_list laptop_mode_wb_timer;
 
+	cpumask_t *flusher_cpumask; /* used for writeback thread scheduling */
+	struct mutex flusher_cpumask_mutex;
+
 #ifdef CONFIG_DEBUG_FS
 	struct dentry *debug_dir;
 	struct dentry *debug_stats;
diff --git a/mm/backing-dev.c b/mm/backing-dev.c
index d3ca2b3..c4f7dde 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -10,6 +10,7 @@
 #include <linux/module.h>
 #include <linux/writeback.h>
 #include <linux/device.h>
+#include <linux/slab.h>
 #include <trace/events/writeback.h>
 
 static atomic_long_t bdi_seq = ATOMIC_LONG_INIT(0);
@@ -221,12 +222,59 @@ static ssize_t max_ratio_store(struct device *dev,
 }
 BDI_SHOW(max_ratio, bdi->max_ratio)
 
+static ssize_t cpu_list_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t count)
+{
+	struct backing_dev_info *bdi = dev_get_drvdata(dev);
+	struct bdi_writeback *wb = &bdi->wb;
+	cpumask_var_t newmask;
+	ssize_t ret;
+	struct task_struct *task;
+
+	if (!alloc_cpumask_var(&newmask, GFP_KERNEL))
+		return -ENOMEM;
+
+	ret = cpulist_parse(buf, newmask);
+	if (!ret) {
+		spin_lock(&bdi->wb_lock);
+		task = wb->task;
+		get_task_struct(task);
+		spin_unlock(&bdi->wb_lock);
+		if (task)
+			ret = set_cpus_allowed_ptr(task, newmask);
+		put_task_struct(task);
+		if (ret == 0) {
+			mutex_lock(&bdi->flusher_cpumask_mutex);
+			cpumask_copy(bdi->flusher_cpumask, newmask);
+			mutex_unlock(&bdi->flusher_cpumask_mutex);
+			ret = count;
+		}
+	}
+	free_cpumask_var(newmask);
+
+	return ret;
+}
+
+static ssize_t cpu_list_show(struct device *dev,
+		struct device_attribute *attr, char *page)
+{
+	struct backing_dev_info *bdi = dev_get_drvdata(dev);
+	ssize_t ret;
+
+	mutex_lock(&bdi->flusher_cpumask_mutex);
+	ret = cpulist_scnprintf(page, PAGE_SIZE-1, bdi->flusher_cpumask);
+	mutex_unlock(&bdi->flusher_cpumask_mutex);
+
+	return ret;
+}
+
 #define __ATTR_RW(attr) __ATTR(attr, 0644, attr##_show, attr##_store)
 
 static struct device_attribute bdi_dev_attrs[] = {
 	__ATTR_RW(read_ahead_kb),
 	__ATTR_RW(min_ratio),
 	__ATTR_RW(max_ratio),
+	__ATTR_RW(cpu_list),
 	__ATTR_NULL,
 };
 
@@ -428,6 +476,7 @@ static int bdi_forker_thread(void *ptr)
 				writeback_inodes_wb(&bdi->wb, 1024,
 						    WB_REASON_FORKER_THREAD);
 			} else {
+				int ret;
 				/*
 				 * The spinlock makes sure we do not lose
 				 * wake-ups when racing with 'bdi_queue_work()'.
@@ -437,6 +486,14 @@ static int bdi_forker_thread(void *ptr)
 				spin_lock_bh(&bdi->wb_lock);
 				bdi->wb.task = task;
 				spin_unlock_bh(&bdi->wb_lock);
+				mutex_lock(&bdi->flusher_cpumask_mutex);
+				ret = set_cpus_allowed_ptr(task,
+							bdi->flusher_cpumask);
+				mutex_unlock(&bdi->flusher_cpumask_mutex);
+				if (ret)
+					printk_once("%s: failed to bind flusher"
+						    " thread %s, error %d\n",
+						    __func__, task->comm, ret);
 				wake_up_process(task);
 			}
 			bdi_clear_pending(bdi);
@@ -509,6 +566,17 @@ int bdi_register(struct backing_dev_info *bdi, struct device *parent,
 						dev_name(dev));
 		if (IS_ERR(wb->task))
 			return PTR_ERR(wb->task);
+	} else {
+		int node;
+		/*
+		 * Set up a default cpumask for the flusher threads that
+		 * includes all cpus on the same numa node as the device.
+		 * The mask may be overridden via sysfs.
+		 */
+		node = dev_to_node(bdi->dev);
+		if (node != NUMA_NO_NODE)
+			cpumask_copy(bdi->flusher_cpumask,
+				     cpumask_of_node(node));
 	}
 
 	bdi_debug_register(bdi, dev_name(dev));
@@ -634,6 +702,15 @@ int bdi_init(struct backing_dev_info *bdi)
 
 	bdi_wb_init(&bdi->wb, bdi);
 
+	if (!bdi_cap_flush_forker(bdi)) {
+		bdi->flusher_cpumask = kmalloc(sizeof(cpumask_t), GFP_KERNEL);
+		if (!bdi->flusher_cpumask)
+			return -ENOMEM;
+		cpumask_setall(bdi->flusher_cpumask);
+		mutex_init(&bdi->flusher_cpumask_mutex);
+	} else
+		bdi->flusher_cpumask = NULL;
+
 	for (i = 0; i < NR_BDI_STAT_ITEMS; i++) {
 		err = percpu_counter_init(&bdi->bdi_stat[i], 0);
 		if (err)
@@ -683,6 +760,8 @@ void bdi_destroy(struct backing_dev_info *bdi)
 
 	bdi_unregister(bdi);
 
+	kfree(bdi->flusher_cpumask);
+
 	/*
 	 * If bdi_unregister() had already been called earlier, the
 	 * wakeup_timer could still be armed because bdi_prune_sb()
