Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754288Ab2A3HHa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 02:07:30 -0500
Received: from mga14.intel.com ([143.182.124.37]:5268 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752385Ab2A3HHZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 02:07:25 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="61168562"
Message-Id: <20120130070634.429072908@sli10-conroe.sh.intel.com>
User-Agent: quilt/0.48-1
Date: Mon, 30 Jan 2012 15:02:15 +0800
From: Shaohua Li <shaohua.li@intel.com>
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, vgoyal@redhat.com, david@fromorbit.com,
        jack@suse.cz, zhu.yanhai@gmail.com, namhyung.kim@lge.com,
        shaohua.li@intel.com
Subject: [patch v2 2/8]block: fiops read/write request scale
References: <20120130070213.793690895@sli10-conroe.sh.intel.com>
Content-Disposition: inline; filename=fiops-rw-scale.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

read/write speed of Flash based storage usually is different. For example,
in my SSD maxium thoughput of read is about 3 times faster than that of
write. Add a scale to differenate read and write. Also add a tunable, so
user can assign different scale for read and write.

By default, the scale is 1:1, which means the scale is a noop.

Signed-off-by: Shaohua Li <shaohua.li@intel.com>
---
 block/fiops-iosched.c |   71 +++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 70 insertions(+), 1 deletion(-)

Index: linux/block/fiops-iosched.c
===================================================================
--- linux.orig/block/fiops-iosched.c	2012-01-18 14:33:32.000000000 +0800
+++ linux/block/fiops-iosched.c	2012-01-18 14:33:51.000000000 +0800
@@ -15,6 +15,9 @@
 #define VIOS_SCALE_SHIFT 10
 #define VIOS_SCALE (1 << VIOS_SCALE_SHIFT)
 
+#define VIOS_READ_SCALE (1)
+#define VIOS_WRITE_SCALE (1)
+
 struct fiops_rb_root {
 	struct rb_root rb;
 	struct rb_node *left;
@@ -33,6 +36,9 @@ struct fiops_data {
 	unsigned int in_flight[2];
 
 	struct work_struct unplug_work;
+
+	unsigned int read_scale;
+	unsigned int write_scale;
 };
 
 struct fiops_ioc {
@@ -280,7 +286,12 @@ static void fiops_remove_request(struct
 static u64 fiops_scaled_vios(struct fiops_data *fiopsd,
 	struct fiops_ioc *ioc, struct request *rq)
 {
-	return VIOS_SCALE;
+	int vios = VIOS_SCALE;
+
+	if (rq_data_dir(rq) == WRITE)
+		vios = vios * fiopsd->write_scale / fiopsd->read_scale;
+
+	return vios;
 }
 
 /* return vios dispatched */
@@ -500,6 +511,9 @@ static void *fiops_init_queue(struct req
 
 	INIT_WORK(&fiopsd->unplug_work, fiops_kick_queue);
 
+	fiopsd->read_scale = VIOS_READ_SCALE;
+	fiopsd->write_scale = VIOS_WRITE_SCALE;
+
 	return fiopsd;
 }
 
@@ -517,6 +531,60 @@ static void fiops_init_icq(struct io_cq
 	ioc->pid = current->pid;
 }
 
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
@@ -534,6 +602,7 @@ static struct elevator_type iosched_fiop
 	},
 	.icq_size	=	sizeof(struct fiops_ioc),
 	.icq_align	=	__alignof__(struct fiops_ioc),
+	.elevator_attrs =	fiops_attrs,
 	.elevator_name =	"fiops",
 	.elevator_owner =	THIS_MODULE,
 };

