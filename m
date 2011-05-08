Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756197Ab1EHWvg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 May 2011 18:51:36 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:41043 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932454Ab1EHWln (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 May 2011 18:41:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Io1qp3wm8UhWUruaElxoZvz9RBJqMXG1G7qzGEQnjoXkZ9W3pyueB7fxhjjJCkbAkF
         9KrLvk1/1MU6Pc6bDeUYj7ufCJVdDDA1rf6AqUn0pDu7dnS06FC6lxyndySpZkP2nRTv
         2yyewB9w52KquqpRzOZinPdaegA6Do135kPwQ=
From: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: netdev@vger.kernel.org, Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
Subject: [v2 064/115] sysctl: sysctl_head_grab defaults to root header on NULL
Date: Mon,  9 May 2011 00:39:16 +0200
Message-Id: <1304894407-32201-65-git-send-email-lucian.grijincu@gmail.com>
X-Mailer: git-send-email 1.7.5.134.g1c08b
In-Reply-To: <1304894407-32201-1-git-send-email-lucian.grijincu@gmail.com>
References: <1304894407-32201-1-git-send-email-lucian.grijincu@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The code that could send NULL to sysctl_head_grab is grab_header
because for the root sysctl directory ('/proc/sys/')
PROC_I(inode)->sysctl is NULL.

For it we used to return root_table_header indirectly through a call
to sysctl_head_next(NULL). Now we default to the root header here.

The BUG() has not been triggered until now so we can assume no one
else is sending NULL here.

Signed-off-by: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
---
 fs/proc/proc_sysctl.c |    5 +----
 kernel/sysctl.c       |    2 +-
 2 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/fs/proc/proc_sysctl.c b/fs/proc/proc_sysctl.c
index d1640bc..93962b0 100644
--- a/fs/proc/proc_sysctl.c
+++ b/fs/proc/proc_sysctl.c
@@ -64,10 +64,7 @@ static struct ctl_table *find_in_table(struct ctl_table *p, struct qstr *name)
 
 static struct ctl_table_header *grab_header(struct inode *inode)
 {
-	if (PROC_I(inode)->sysctl)
-		return sysctl_head_grab(PROC_I(inode)->sysctl);
-	else
-		return sysctl_head_next(NULL);
+	return sysctl_head_grab(PROC_I(inode)->sysctl);
 }
 
 static struct dentry *proc_sys_lookup(struct inode *dir, struct dentry *dentry,
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 0450d3d..8b56695 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -1554,7 +1554,7 @@ void sysctl_head_put(struct ctl_table_header *head)
 struct ctl_table_header *sysctl_head_grab(struct ctl_table_header *head)
 {
 	if (!head)
-		BUG();
+		head = &root_table_header;
 	spin_lock(&sysctl_lock);
 	if (!use_table(head))
 		head = ERR_PTR(-ENOENT);
-- 
1.7.5.134.g1c08b

