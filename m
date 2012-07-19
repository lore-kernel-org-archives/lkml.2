Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753145Ab2GSMnr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 08:43:47 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:37492 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752600Ab2GSMmt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 08:42:49 -0400
X-AuditID: b753bd60-a3089ba000000655-e1-500800c7eaaa
X-AuditID: b753bd60-a3089ba000000655-e1-500800c7eaaa
From: Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com>
Subject: [PATCH -v2 5/6] fuse: set default global limit considering tunable
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
Date: Thu, 19 Jul 2012 21:49:58 +0900
Message-ID: <20120719124958.6250.26758.stgit@ltc137.sdl.hitachi.co.jp>
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

Set default global limits for backgrounded requests and congestion
threshold considering the tunable maximum request size.

They are calculated using size of fuse_req structure, which is
variable due to it. This patch sets them according to the current
request size unless they are set via mod_param by the system
administrator.

Signed-off-by: Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>
Cc: Nikolaus Rath <Nikolaus@rath.org>
Cc: Liu Yuan <namei.unix@gmail.com>
Cc: Has-Wen Nienhuys <hanwen@xs4all.nl>
---

 fs/fuse/fuse_i.h |    4 +++
 fs/fuse/inode.c  |   62 ++++++++++++++++++++++++++++++++++++++++++++----------
 2 files changed, 55 insertions(+), 11 deletions(-)

diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
index 46df615..2dda6eb 100644
--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -27,6 +27,10 @@
 /** Default number of pages that can be used in a single read/write request */
 #define FUSE_DEFAULT_MAX_PAGES_PER_REQ 32
 
+/** Maximum size of struct fuse_req */
+#define FUSE_CURRENT_REQ_SIZE (sizeof(struct fuse_req) +\
+			       sysfs_max_req_pages * sizeof(struct page *))
+
 /** Bias for fi->writectr, meaning new writepages must not be sent */
 #define FUSE_NOWRITE INT_MIN
 
diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
index 5f84a40..dc0302f 100644
--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -29,25 +29,36 @@ static struct kmem_cache *fuse_inode_cachep;
 struct list_head fuse_conn_list;
 DEFINE_MUTEX(fuse_mutex);
 
-static int set_global_limit(const char *val, struct kernel_param *kp);
+static int set_global_limit_bgreq(const char *val, struct kernel_param *kp);
+static int set_global_limit_thresh(const char *val, struct kernel_param *kp);
 
 unsigned max_user_bgreq;
-module_param_call(max_user_bgreq, set_global_limit, param_get_uint,
-		  &max_user_bgreq, 0644);
+module_param_call(max_user_bgreq, set_global_limit_bgreq,
+		  param_get_uint, &max_user_bgreq, 0644);
 __MODULE_PARM_TYPE(max_user_bgreq, "uint");
 MODULE_PARM_DESC(max_user_bgreq,
  "Global limit for the maximum number of backgrounded requests an "
  "unprivileged user can set");
 
 unsigned max_user_congthresh;
-module_param_call(max_user_congthresh, set_global_limit, param_get_uint,
-		  &max_user_congthresh, 0644);
+module_param_call(max_user_congthresh, set_global_limit_thresh,
+		  param_get_uint, &max_user_congthresh, 0644);
 __MODULE_PARM_TYPE(max_user_congthresh, "uint");
 MODULE_PARM_DESC(max_user_congthresh,
  "Global limit for the maximum congestion threshold an "
  "unprivileged user can set");
 
 /**
+ * The flags below are used in order to distinguish how to set
+ * max_user_bgreq and max_user_congthresh, respectively. They
+ * should be used if they are set via mod_param. If not, we should
+ * check their current limitation using check_global_limit() any
+ * time due to the tunable read/write request size.
+ */
+static bool mod_param_set_flg_bgreq;
+static bool mod_param_set_flg_thresh;
+
+/**
  * Maximum number of pages allocated for struct fuse_req.
  * It can be changed via sysfs to arbitrary number between
  * FUSE_DEFAULT_MAX_PAGES_PER_REQ and nr_pages equivalent
@@ -766,13 +777,39 @@ static void sanitize_global_limit(unsigned *limit)
 {
 	if (*limit == 0)
 		*limit = ((num_physpages << PAGE_SHIFT) >> 13) /
-			 sizeof(struct fuse_req);
+			 FUSE_CURRENT_REQ_SIZE;
 
 	if (*limit >= 1 << 16)
 		*limit = (1 << 16) - 1;
 }
 
-static int set_global_limit(const char *val, struct kernel_param *kp)
+static void check_global_limit(unsigned *limit, bool mod_param_flg)
+{
+	if (!mod_param_flg) {
+		unsigned cur_global_limit = 0;
+
+		sanitize_global_limit(&cur_global_limit);
+		*limit = cur_global_limit;
+	}
+}
+
+static int set_global_limit_bgreq(const char *val, struct kernel_param *kp)
+{
+	int rv;
+
+	rv = param_set_uint(val, kp);
+	if (rv)
+		return rv;
+
+	sanitize_global_limit((unsigned *)kp->arg);
+
+	/* max_user_bgreq is set via mod_param */
+	mod_param_set_flg_bgreq = true;
+
+	return 0;
+}
+
+static int set_global_limit_thresh(const char *val, struct kernel_param *kp)
 {
 	int rv;
 
@@ -782,6 +819,9 @@ static int set_global_limit(const char *val, struct kernel_param *kp)
 
 	sanitize_global_limit((unsigned *)kp->arg);
 
+	/* max_user_congthresh is set via mod_param */
+	mod_param_set_flg_thresh = true;
+
 	return 0;
 }
 
@@ -801,8 +841,8 @@ static void process_init_limits(struct fuse_conn *fc, struct fuse_init_out *arg)
 	if (arg->minor < 13)
 		return;
 
-	sanitize_global_limit(&max_user_bgreq);
-	sanitize_global_limit(&max_user_congthresh);
+	check_global_limit(&max_user_bgreq, mod_param_set_flg_bgreq);
+	check_global_limit(&max_user_congthresh, mod_param_set_flg_thresh);
 
 	if (arg->max_background) {
 		fc->max_background = arg->max_background;
@@ -1309,8 +1349,8 @@ static int __init fuse_init(void)
 	if (res)
 		goto err_sysfs_cleanup;
 
-	sanitize_global_limit(&max_user_bgreq);
-	sanitize_global_limit(&max_user_congthresh);
+	check_global_limit(&max_user_bgreq, mod_param_set_flg_bgreq);
+	check_global_limit(&max_user_congthresh, mod_param_set_flg_thresh);
 
 	return 0;
 

