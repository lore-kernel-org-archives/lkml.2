Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760552Ab2IGL0W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 07:26:22 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:46519 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760514Ab2IGLX7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 07:23:59 -0400
From: Jeff Layton <jlayton@redhat.com>
To: eparis@redhat.com, viro@zeniv.linux.org.uk
Cc: linux-audit@redhat.com, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, bfields@fieldses.org
Subject: [PATCH v6 03/10] audit: no need to walk list in audit_inode if name is NULL
Date: Fri,  7 Sep 2012 07:23:40 -0400
Message-Id: <1347017027-17167-4-git-send-email-jlayton@redhat.com>
X-Mailer: git-send-email 1.7.11.4
In-Reply-To: <1347017027-17167-1-git-send-email-jlayton@redhat.com>
References: <1347017027-17167-1-git-send-email-jlayton@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If name is NULL then the condition in the loop will never be true. Also,
with this change, we can eliminate the check for n->name == NULL since
the equivalence check will never be true if it is.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 kernel/auditsc.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index 5c45b9b..4099440 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -2161,11 +2161,15 @@ void __audit_inode(const char *name, const struct dentry *dentry)
 	if (!context->in_syscall)
 		return;
 
+	if (!name)
+		goto out_alloc;
+
 	list_for_each_entry_reverse(n, &context->names_list, list) {
-		if (n->name && (n->name == name))
+		if (n->name == name)
 			goto out;
 	}
 
+out_alloc:
 	/* unable to find the name from a previous getname() */
 	n = audit_alloc_name(context);
 	if (!n)
-- 
1.7.11.4

