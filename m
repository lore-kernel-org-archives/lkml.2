Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752856Ab2ADGkj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 01:40:39 -0500
Received: from mga03.intel.com ([143.182.124.21]:28165 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751471Ab2ADGk0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 01:40:26 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="92142411"
Message-Id: <20120104065454.297272010@sli10-conroe.sh.intel.com>
User-Agent: quilt/0.48-1
Date: Wed, 04 Jan 2012 14:53:40 +0800
From: Shaohua Li <shaohua.li@intel.com>
To: linux-kernel@vger.kernel.org
Cc: axboe@kernel.dk, vgoyal@redhat.com, jmoyer@redhat.com,
        Shaohua Li <shaohua.li@intel.com>
Subject: [RFC 3/3]block: fiops read/write request scale
References: <20120104065337.230911609@sli10-conroe.sh.intel.com>
Content-Disposition: inline; filename=fiops-rw-scale.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

read/write speed of Flash based storage usually is different. Add a scale
to differenate read and write. Also add a tunable, so user can assign
different scale for read and write. This can also be used to bias read
or write in the system

Signed-off-by: Shaohua Li <shaohua.li@intel.com>
---
 block/fiops-iosched.c |   69 +++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 68 insertions(+), 1 deletion(-)

Index: linux/block/fiops-iosched.c
===================================================================
--- linux.orig/block/fiops-iosched.c	2012-01-04 14:01:26.000000000 +0800
+++ linux/block/fiops-iosched.c	2012-01-04 14:05:48.000000000 +0800
@@ -15,6 +15,9 @@
 #define VIOS_SCALE_SHIFT 10
 #define VIOS_SCALE (1 << VIOS_SCALE_SHIFT)
 
+#define VIOS_READ_SCALE (1)
+#define VIOS_WRITE_SCALE (1)
+
 struct fiops_rb_root {
 	struct rb_root rb;
 	struct rb_node *left;
@@ -32,6 +35,9 @@ struct fiops_data {
 	unsigned int busy_queues;
 
 	struct work_struct unplug_work;
+
+	unsigned int read_scale;
+	unsigned int write_scale;
 };
 
 struct fiops_ioc {
@@ -268,7 +274,10 @@ static void fiops_remove_request(struct
 static u64 fiops_scaled_vios(struct fiops_data *fiopsd,
 	struct fiops_ioc *ioc, struct request *rq)
 {
-	return VIOS_SCALE;
+	if (rq_data_dir(rq) == READ)
+		return VIOS_SCALE;
+	else
+		return VIOS_SCALE * fiopsd->write_scale / fiopsd->read_scale;
 }
 
 /* return vios dispatched */
@@ -540,6 +549,9 @@ static void *fiops_init_queue(struct req
 
 	INIT_WORK(&fiopsd->unplug_work, fiops_kick_queue);
 
+	fiopsd->read_scale = VIOS_READ_SCALE;
+	fiopsd->write_scale = VIOS_WRITE_SCALE;
+
 	return fiopsd;
 }
 
@@ -610,6 +622,60 @@ static struct ioc_builder ioc_builder =
 	.cic_exit = fiops_exit_cic,
 };
 
+/*
+ * sysfs parts below -->
+ */
+static ssize_t
+fiops_var_show(unsigned int var, char *page)
+{
+	return sprintf(page, "%d\n", var);
+}
+
+static ssize_t
+fiops_var_store(unsigned int *var, const char *page, size_t count)
+{
+	char *p = (char *) page;
+
+	*var = simple_strtoul(p, &p, 10);
+	return count;
+}
+
+#define SHOW_FUNCTION(__FUNC, __VAR)					\
+static ssize_t __FUNC(struct elevator_queue *e, char *page)		\
+{									\
+	struct fiops_data *fiopsd = e->elevator_data;			\
+	return fiops_var_show(__VAR, (page));				\
+}
+SHOW_FUNCTION(fiops_read_scale_show, fiopsd->read_scale);
+SHOW_FUNCTION(fiops_write_scale_show, fiopsd->write_scale);
+#undef SHOW_FUNCTION
+
+#define STORE_FUNCTION(__FUNC, __PTR, MIN, MAX)				\
+static ssize_t __FUNC(struct elevator_queue *e, const char *page, size_t count)	\
+{									\
+	struct fiops_data *fiopsd = e->elevator_data;			\
+	unsigned int __data;						\
+	int ret = fiops_var_store(&__data, (page), count);		\
+	if (__data < (MIN))						\
+		__data = (MIN);						\
+	else if (__data > (MAX))					\
+		__data = (MAX);						\
+	*(__PTR) = __data;						\
+	return ret;							\
+}
+STORE_FUNCTION(fiops_read_scale_store, &fiopsd->read_scale, 1, 100);
+STORE_FUNCTION(fiops_write_scale_store, &fiopsd->write_scale, 1, 100);
+#undef STORE_FUNCTION
+
+#define FIOPS_ATTR(name) \
+	__ATTR(name, S_IRUGO|S_IWUSR, fiops_##name##_show, fiops_##name##_store)
+
+static struct elv_fs_entry fiops_attrs[] = {
+	FIOPS_ATTR(read_scale),
+	FIOPS_ATTR(write_scale),
+	__ATTR_NULL
+};
+
 static struct elevator_type iosched_fiops = {
 	.ops = {
 		.elevator_merge_fn =		fiops_merge,
@@ -626,6 +692,7 @@ static struct elevator_type iosched_fiop
 		.elevator_exit_fn =		fiops_exit_queue,
 		.trim =				queue_data_free_io_context,
 	},
+	.elevator_attrs =	fiops_attrs,
 	.elevator_name =	"fiops",
 	.elevator_owner =	THIS_MODULE,
 };

