Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752362Ab2GSMmq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 08:42:46 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:43029 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752066Ab2GSMmk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 08:42:40 -0400
X-AuditID: b753bd60-932c5ba0000047ca-6a-500800be7951
X-AuditID: b753bd60-932c5ba0000047ca-6a-500800be7951
From: Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com>
Subject: [PATCH -v2 4/6] fuse: add a sysfs parameter to control the maximum
 request size
To: Miklos Szeredi <miklos@szeredi.hu>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Muthukumar R <muthur@gmail.com>
Cc: fuse-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-doc@vger.kernel.org,
        yrl.pp-manager.tt@hitachi.com,
        Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com>,
        Miklos Szeredi <miklos@szeredi.hu>, Nikolaus Rath <Nikolaus@rath.org>,
        Liu Yuan <namei.unix@gmail.com>, Has-Wen Nienhuys <hanwen@xs4all.nl>
Date: Thu, 19 Jul 2012 21:49:48 +0900
Message-ID: <20120719124948.6250.8088.stgit@ltc137.sdl.hitachi.co.jp>
In-Reply-To: <20120719124851.6250.43316.stgit@ltc137.sdl.hitachi.co.jp>
References: <20120719124851.6250.43316.stgit@ltc137.sdl.hitachi.co.jp>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a max_pages_per_req sysfs paramater to limit the maximum
read/write request size. It can be changed to arbitrary number
between 32 and the nr_pages equivalent to pipe_max_size, and the
32 pages are set by default.

The sysfs parameter control is required, as follows.

* The libfuse should change the current MIN_BUFSIZE limitation
  according to the current maximum request size in FUSE. If not,
  the libfuse must always set MIN_BUFSIZE to the maximum request
  limit (= [nr_pages (equivalent to pipe_max_size) * 4KB + 0x1000]),
  which leads to waste of memory.

* It is easy to find and set the paramter to the optimized value
  in order to improve the read/write throughput, since the
  maximum request limit does not always provides the highest
  throughput.

So, it is necessary to get and set the maximum size from userspace.

Existing FUSE mounts must be remounted for this change to take
effect.

Signed-off-by: Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>
Cc: Nikolaus Rath <Nikolaus@rath.org>
Cc: Liu Yuan <namei.unix@gmail.com>
Cc: Has-Wen Nienhuys <hanwen@xs4all.nl>
---

 fs/fuse/inode.c |   58 +++++++++++++++++++++++++++++++++++++++++++++++++++----
 1 files changed, 54 insertions(+), 4 deletions(-)

diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
index f7f3c5d..5f84a40 100644
--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -47,6 +47,14 @@ MODULE_PARM_DESC(max_user_congthresh,
  "Global limit for the maximum congestion threshold an "
  "unprivileged user can set");
 
+/**
+ * Maximum number of pages allocated for struct fuse_req.
+ * It can be changed via sysfs to arbitrary number between
+ * FUSE_DEFAULT_MAX_PAGES_PER_REQ and nr_pages equivalent
+ * to pipe_max_size.
+ */
+static unsigned sysfs_max_req_pages = FUSE_DEFAULT_MAX_PAGES_PER_REQ;
+
 #define FUSE_SUPER_MAGIC 0x65735546
 
 #define FUSE_DEFAULT_BLKSIZE 512
@@ -779,11 +787,8 @@ static int set_global_limit(const char *val, struct kernel_param *kp)
 
 static void set_conn_max_pages(struct fuse_conn *fc, unsigned max_pages)
 {
-	unsigned pipe_max_size = pipe_get_max_size();
-	unsigned pipe_max_pages = DIV_ROUND_UP(pipe_max_size, PAGE_SIZE);
-
 	if (max_pages > fc->max_pages) {
-		fc->max_pages = min_t(unsigned, pipe_max_pages, max_pages);
+		fc->max_pages = min_t(unsigned, sysfs_max_req_pages, max_pages);
 		fc->fuse_req_size = sizeof(struct fuse_req) +
 				    fc->max_pages * sizeof(struct page *);
 	}
@@ -1205,6 +1210,45 @@ static void fuse_fs_cleanup(void)
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
+	unsigned pipe_max_size = pipe_get_max_size();
+	unsigned pipe_max_pages = DIV_ROUND_UP(pipe_max_size, PAGE_SIZE);
+
+	err = kstrtoul(skip_spaces(buf), 0, &t);
+	if (err)
+		return err;
+
+	t = max_t(unsigned long, t, FUSE_DEFAULT_MAX_PAGES_PER_REQ);
+	t = min_t(unsigned long, t, pipe_max_pages);
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
@@ -1221,8 +1265,14 @@ static int fuse_sysfs_init(void)
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

