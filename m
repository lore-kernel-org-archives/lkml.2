Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932546Ab2GEKqP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 06:46:15 -0400
Received: from mailxx.hitachi.co.jp ([133.145.228.50]:49874 "EHLO
	mailxx.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755676Ab2GEKqL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 06:46:11 -0400
X-AuditID: b753bd60-90ac1ba0000047ca-ab-4ff56fef400c
X-AuditID: b753bd60-90ac1ba0000047ca-ab-4ff56fef400c
From: Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com>
Subject: [RFC PATCH 4/5] fuse: add a sysfs parameter to control maximum
 request size
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: fuse-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, yrl.pp-manager.tt@hitachi.com,
        Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com>,
        Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 05 Jul 2012 19:51:07 +0900
Message-ID: <20120705105107.17812.40720.stgit@ltc137.sdl.hitachi.co.jp>
In-Reply-To: <20120705105017.17812.95542.stgit@ltc137.sdl.hitachi.co.jp>
References: <20120705105017.17812.95542.stgit@ltc137.sdl.hitachi.co.jp>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The tunable maximum read/write request size changes the size of
fuse request when max_read/max_write mount option is specified.

The libfuse should change the current MIN_BUFSIZE limitation
according to the current maximum request size. If not, the
libfuse must always set MIN_BUFSIZE to the maximum request limit
(= [256 pages * 4KB + 0x1000] in current implementation), which
leads to waste of memory. So, it is necessary to get it from
userspace.

This patch adds a sysfs parameter to achieve it. It can be
changed from 32 to 256 pages and the 32 pages are set by default.

When we want to increase the maximum request size, it is required
to change this parameter before mounting FUSE filesystems.

Signed-off-by: Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>
---

 fs/fuse/inode.c |   53 +++++++++++++++++++++++++++++++++++++++++++++++++++--
 1 files changed, 51 insertions(+), 2 deletions(-)

diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
index d8d302a..50b78c6 100644
--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -47,6 +47,13 @@ MODULE_PARM_DESC(max_user_congthresh,
  "Global limit for the maximum congestion threshold an "
  "unprivileged user can set");
 
+/**
+ * Maximum number of pages allocated for struct fuse_req.
+ * It can be changed via sysfs from FUSE_DEFAULT_MAX_PAGES_PER_REQ
+ * to FUSE_MAX_PAGES_PER_REQ.
+ */
+static unsigned sysfs_max_req_pages = FUSE_DEFAULT_MAX_PAGES_PER_REQ;
+
 #define FUSE_SUPER_MAGIC 0x65735546
 
 #define FUSE_DEFAULT_BLKSIZE 512
@@ -780,8 +787,7 @@ static int set_global_limit(const char *val, struct kernel_param *kp)
 static void set_conn_max_pages(struct fuse_conn *fc, unsigned max_pages)
 {
 	if (max_pages > fc->max_pages) {
-		fc->max_pages = min_t(unsigned, FUSE_MAX_PAGES_PER_REQ,
-				      max_pages);
+		fc->max_pages = min_t(unsigned, sysfs_max_req_pages, max_pages);
 		fc->fuse_req_size = sizeof(struct fuse_req) +
 				    fc->max_pages * sizeof(struct page *);
 	}
@@ -1203,6 +1209,43 @@ static void fuse_fs_cleanup(void)
 static struct kobject *fuse_kobj;
 static struct kobject *connections_kobj;
 
+static ssize_t max_req_pages_show(struct kobject *kobj,
+				  struct kobj_attribute *attr, char *buf)
+{
+	return sprintf(buf, "%u\n", sysfs_max_req_pages);
+}
+
+static ssize_t max_req_pages_store(struct kobject *kobj,
+				   struct kobj_attribute *attr,
+				   const char *buf, size_t count)
+{
+	int err;
+	unsigned long t;
+
+	err = kstrtoul(skip_spaces(buf), 0, &t);
+	if (err)
+		return err;
+
+	t = max_t(unsigned long, t, FUSE_DEFAULT_MAX_PAGES_PER_REQ);
+	t = min_t(unsigned long, t, FUSE_MAX_PAGES_PER_REQ);
+
+	sysfs_max_req_pages = t;
+	return count;
+}
+
+static struct kobj_attribute max_req_pages_attr =
+	__ATTR(max_pages_per_req, 0644, max_req_pages_show,
+	       max_req_pages_store);
+
+static struct attribute *fuse_attrs[] = {
+	&max_req_pages_attr.attr,
+	NULL,
+};
+
+static struct attribute_group fuse_attr_grp = {
+	.attrs = fuse_attrs,
+};
+
 static int fuse_sysfs_init(void)
 {
 	int err;
@@ -1219,8 +1262,14 @@ static int fuse_sysfs_init(void)
 		goto out_fuse_unregister;
 	}
 
+	err = sysfs_create_group(fuse_kobj, &fuse_attr_grp);
+	if (err)
+		goto out_conn_unregister;
+
 	return 0;
 
+ out_conn_unregister:
+	kobject_put(connections_kobj);
  out_fuse_unregister:
 	kobject_put(fuse_kobj);
  out_err:

