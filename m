Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754041Ab2A3BNm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jan 2012 20:13:42 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:47353 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753200Ab2A3BNj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jan 2012 20:13:39 -0500
Date: Mon, 30 Jan 2012 05:13:36 +0400
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Arve =?utf-8?B?SGrDuG5uZXbDpWc=?= <arve@android.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, San Mehat <san@google.com>,
        Colin Cross <ccross@android.com>, Oleg Nesterov <oleg@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        linux-kernel@vger.kernel.org, kernel-team@android.com,
        linaro-kernel@lists.linaro.org
Subject: [PATCH 2/3] pids: Introduce for_each_tgid() macro
Message-ID: <20120130011336.GB30274@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just a handy macro. This patch converts procfs user to this new
macro, plus android lowmemorykiller driver will use it as well.

Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>
---
 fs/proc/base.c      |    4 +---
 include/linux/pid.h |    5 +++++
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index 84b8625..e815d63 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -3367,9 +3367,7 @@ int proc_pid_readdir(struct file * filp, void * dirent, filldir_t filldir)
 	ns = filp->f_dentry->d_sb->s_fs_info;
 	iter.task = NULL;
 	iter.tgid = filp->f_pos - TGID_OFFSET;
-	for (iter = next_tgid(ns, iter);
-	     iter.task;
-	     iter.tgid += 1, iter = next_tgid(ns, iter)) {
+	for_each_tgid(ns, iter) {
 		if (has_pid_permissions(ns, iter.task, 2))
 			__filldir = filldir;
 		else
diff --git a/include/linux/pid.h b/include/linux/pid.h
index 33e350b..da87cae 100644
--- a/include/linux/pid.h
+++ b/include/linux/pid.h
@@ -206,4 +206,9 @@ struct tgid_iter {
 
 struct tgid_iter next_tgid(struct pid_namespace *ns, struct tgid_iter iter);
 
+#define for_each_tgid(ns, iter)					\
+	for (iter = next_tgid(ns, iter);			\
+	     iter.task;						\
+	     iter.tgid += 1, iter = next_tgid(ns, iter))	\
+
 #endif /* _LINUX_PID_H */
-- 
1.7.7

