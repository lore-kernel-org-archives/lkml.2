Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932495Ab1EHWmE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 May 2011 18:42:04 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:45747 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932588Ab1EHWlz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 May 2011 18:41:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=BqDCH7Qw1il14OKIy7RCq4aCvrzzJJ4Wn1pL6QtOXqItaepOAbLxLHcOh9kDhXDVha
         f5cNbh3IHCTBkOfiO8CrPWVxDCvcgts0adi5TFTKLmADxKQG6dqtp4AARkmeIte3uYxI
         p8yOXg4GVE5u403+82oCaEAkB2gGCdhoLLOSI=
From: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: netdev@vger.kernel.org, Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
Subject: [v2 072/115] sysctl: simplify ->permissions hook
Date: Mon,  9 May 2011 00:39:24 +0200
Message-Id: <1304894407-32201-73-git-send-email-lucian.grijincu@gmail.com>
X-Mailer: git-send-email 1.7.5.134.g1c08b
In-Reply-To: <1304894407-32201-1-git-send-email-lucian.grijincu@gmail.com>
References: <1304894407-32201-1-git-send-email-lucian.grijincu@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The @root parameter was not used at all.

The @namespaces parameter was used to transmit current->nsproxy. We
can access current->nsproxy directly in the ->permissions function, no
need to send it.

Signed-off-by: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
---
 include/linux/sysctl.h |    3 +--
 kernel/sysctl.c        |    2 +-
 net/sysctl_net.c       |    9 +++------
 3 files changed, 5 insertions(+), 9 deletions(-)

diff --git a/include/linux/sysctl.h b/include/linux/sysctl.h
index e265880..1af4ed5 100644
--- a/include/linux/sysctl.h
+++ b/include/linux/sysctl.h
@@ -1034,8 +1034,7 @@ struct ctl_table_root {
 	struct ctl_table_set default_set;
 	struct ctl_table_set *(*lookup)(struct ctl_table_root *root,
 					   struct nsproxy *namespaces);
-	int (*permissions)(struct ctl_table_root *root,
-			struct nsproxy *namespaces, struct ctl_table *table);
+	int (*permissions)(struct ctl_table *table);
 };
 
 /* struct ctl_table_header is used to maintain dynamic lists of
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 1281827..6e4e32b 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -1664,7 +1664,7 @@ int sysctl_perm(struct ctl_table_root *root, struct ctl_table *table, int op)
 	int mode;
 
 	if (root->permissions)
-		mode = root->permissions(root, current->nsproxy, table);
+		mode = root->permissions(table);
 	else
 		mode = table->mode;
 
diff --git a/net/sysctl_net.c b/net/sysctl_net.c
index 1197d9c..1c0cb57 100644
--- a/net/sysctl_net.c
+++ b/net/sysctl_net.c
@@ -41,9 +41,7 @@ static int is_seen(struct ctl_table_set *set)
 }
 
 /* Return standard mode bits for table entry. */
-static int net_ctl_permissions(struct ctl_table_root *root,
-			       struct nsproxy *nsproxy,
-			       struct ctl_table *table)
+static int net_ctl_permissions(struct ctl_table *table)
 {
 	/* Allow network administrator to have same access as root. */
 	if (capable(CAP_NET_ADMIN)) {
@@ -58,10 +56,9 @@ static struct ctl_table_root net_sysctl_root = {
 	.permissions = net_ctl_permissions,
 };
 
-static int net_ctl_ro_header_perms(struct ctl_table_root *root,
-		struct nsproxy *namespaces, struct ctl_table *table)
+static int net_ctl_ro_header_perms(ctl_table *table)
 {
-	if (net_eq(namespaces->net_ns, &init_net))
+	if (net_eq(current->nsproxy->net_ns, &init_net))
 		return table->mode;
 	else
 		return table->mode & ~0222;
-- 
1.7.5.134.g1c08b

