Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754540Ab1EHWtt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 May 2011 18:49:49 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:47696 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932582Ab1EHWlw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 May 2011 18:41:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=AhKexHoMqYPF1G1un19gJJ3uH1yS0ftBoSepAYND6cg9rXFAGTfkqrETBzSw4bmrLy
         4eONg7iKwVGm6MOCjeYYo1dy91D+YmWusWe3J6CLmjFRpDIGICLvZReENnGbWoDW0fuC
         ylcvFSpsxu7WxnciPazCGtnjvgpZo5yNZ/EWo=
From: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: netdev@vger.kernel.org, Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
Subject: [v2 071/115] sysctl: rename (un)use_table to __sysctl_(un)use_header
Date: Mon,  9 May 2011 00:39:23 +0200
Message-Id: <1304894407-32201-72-git-send-email-lucian.grijincu@gmail.com>
X-Mailer: git-send-email 1.7.5.134.g1c08b
In-Reply-To: <1304894407-32201-1-git-send-email-lucian.grijincu@gmail.com>
References: <1304894407-32201-1-git-send-email-lucian.grijincu@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The former names were not semantically correct, as the use/unuse was
related to the header, not the table. Also this makes it clearer that
sysctl_use_header and __sysctl_use_header are related (one takes the
spin lock inside and the other doesn't).

Signed-off-by: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
---
 kernel/sysctl.c |   21 ++++++++++-----------
 1 files changed, 10 insertions(+), 11 deletions(-)

diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index caafbb8..1281827 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -1490,16 +1490,16 @@ static struct ctl_table dev_table[] = {
 static DEFINE_SPINLOCK(sysctl_lock);
 
 /* called under sysctl_lock */
-static int use_table(struct ctl_table_header *p)
+static struct ctl_table_header *__sysctl_use_header(struct ctl_table_header *head)
 {
-	if (unlikely(p->unregistering))
-		return 0;
-	p->ctl_use_refs++;
-	return 1;
+	if (unlikely(head->unregistering))
+		return ERR_PTR(-ENOENT);
+	head->ctl_use_refs++;
+	return head;
 }
 
 /* called under sysctl_lock */
-static void unuse_table(struct ctl_table_header *p)
+static void __sysctl_unuse_header(struct ctl_table_header *p)
 {
 	if (!--p->ctl_use_refs)
 		if (unlikely(p->unregistering))
@@ -1511,8 +1511,7 @@ struct ctl_table_header *sysctl_use_header(struct ctl_table_header *head)
 	if (!head)
 		head = &root_table_header;
 	spin_lock(&sysctl_lock);
-	if (!use_table(head))
-		head = ERR_PTR(-ENOENT);
+	head = __sysctl_use_header(head);
 	spin_unlock(&sysctl_lock);
 	return head;
 }
@@ -1522,7 +1521,7 @@ void sysctl_unuse_header(struct ctl_table_header *head)
 	if (!head)
 		return;
 	spin_lock(&sysctl_lock);
-	unuse_table(head);
+	__sysctl_unuse_header(head);
 	spin_unlock(&sysctl_lock);
 }
 
@@ -1600,14 +1599,14 @@ struct ctl_table_header *__sysctl_use_next_header(struct nsproxy *namespaces,
 	if (prev) {
 		head = prev;
 		tmp = &prev->ctl_entry;
-		unuse_table(prev);
+		__sysctl_unuse_header(prev);
 		goto next;
 	}
 	tmp = &root_table_header.ctl_entry;
 	for (;;) {
 		head = list_entry(tmp, struct ctl_table_header, ctl_entry);
 
-		if (!use_table(head))
+		if (IS_ERR(__sysctl_use_header(head)))
 			goto next;
 		spin_unlock(&sysctl_lock);
 		return head;
-- 
1.7.5.134.g1c08b

