Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030508Ab2COOuc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 10:50:32 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:55023 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030267Ab2COOu1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 10:50:27 -0400
From: Cong Wang <xiyou.wangcong@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Dennis1.Chen@amd.com,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Alexander Viro <viro@zeniv.linux.org.uk>, NeilBrown <neilb@suse.de>,
        Kay Sievers <kay.sievers@vrfy.org>, Joe Perches <joe@perches.com>,
        linux-fsdevel@vger.kernel.org
Subject: [PATCH 5/7] module: take rcu_read_lock_sched() for /proc read
Date: Thu, 15 Mar 2012 22:48:59 +0800
Message-Id: <1331822941-19938-5-git-send-email-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1331822941-19938-1-git-send-email-xiyou.wangcong@gmail.com>
References: <1331822941-19938-1-git-send-email-xiyou.wangcong@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the seq file operations, it still hold module_mutex for just reading
the module list, switch to rcu_read_lock_sched() too.

A new function seq_list_start_rcu() is introduced for this.

Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>

---
 fs/seq_file.c            |   12 ++++++++++++
 include/linux/seq_file.h |    2 ++
 kernel/module.c          |    6 +++---
 3 files changed, 17 insertions(+), 3 deletions(-)

diff --git a/fs/seq_file.c b/fs/seq_file.c
index 4023d6b..5b01e04 100644
--- a/fs/seq_file.c
+++ b/fs/seq_file.c
@@ -674,6 +674,18 @@ struct list_head *seq_list_start(struct list_head *head, loff_t pos)
 }
 EXPORT_SYMBOL(seq_list_start);
 
+struct list_head *seq_list_start_rcu(struct list_head *head, loff_t pos)
+{
+	struct list_head *lh = head;
+
+	list_for_each_continue_rcu(lh, head)
+		if (pos-- == 0)
+			return lh;
+
+	return NULL;
+}
+EXPORT_SYMBOL(seq_list_start_rcu);
+
 struct list_head *seq_list_start_head(struct list_head *head, loff_t pos)
 {
 	if (!pos)
diff --git a/include/linux/seq_file.h b/include/linux/seq_file.h
index 44f1514..7848189 100644
--- a/include/linux/seq_file.h
+++ b/include/linux/seq_file.h
@@ -130,6 +130,8 @@ int seq_release_private(struct inode *, struct file *);
 
 extern struct list_head *seq_list_start(struct list_head *head,
 		loff_t pos);
+extern struct list_head *seq_list_start_rcu(struct list_head *head,
+		loff_t pos);
 extern struct list_head *seq_list_start_head(struct list_head *head,
 		loff_t pos);
 extern struct list_head *seq_list_next(void *v, struct list_head *head,
diff --git a/kernel/module.c b/kernel/module.c
index 73e1f95..06e7dc5 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -3313,8 +3313,8 @@ static char *module_flags(struct module *mod, char *buf)
 /* Called by the /proc file system to return a list of modules. */
 static void *m_start(struct seq_file *m, loff_t *pos)
 {
-	mutex_lock(&module_mutex);
-	return seq_list_start(&modules, *pos);
+	rcu_read_lock_sched();
+	return seq_list_start_rcu(&modules, *pos);
 }
 
 static void *m_next(struct seq_file *m, void *p, loff_t *pos)
@@ -3324,7 +3324,7 @@ static void *m_next(struct seq_file *m, void *p, loff_t *pos)
 
 static void m_stop(struct seq_file *m, void *p)
 {
-	mutex_unlock(&module_mutex);
+	rcu_read_unlock_sched();
 }
 
 static int m_show(struct seq_file *m, void *p)
-- 
1.7.7.6

