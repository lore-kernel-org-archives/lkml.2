Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754012Ab1AFVwZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 16:52:25 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:17695 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751087Ab1AFVwY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 16:52:24 -0500
Date: Thu, 6 Jan 2011 22:52:22 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-fsdevel@vger.kernel.org
cc: linux-kernel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH][rfc] xattr acl: Suspicious use of potentially null
 pointer.
Message-ID: <alpine.LNX.2.00.1101062247420.13988@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


In posix_acl_from_xattr() we have this at the head of the function:

  		posix_acl_xattr_header *header = (posix_acl_xattr_header *)value;
   		posix_acl_xattr_entry *entry = (posix_acl_xattr_entry *)(header+1), *end;

Since 'value' is passed in by the caller and may be NULL, the second line 
looks suspicious to me - taking a potentially NULL pointer (at least 
btrfs will pass something allocated with kmalloc() which may be NULL), 
adding one to it and casting it does not seem like it would always be such 
a hot idea.

How about rewriting it as per the patch below?


Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 xattr_acl.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)
diff --git a/fs/xattr_acl.c b/fs/xattr_acl.c
index 8d5a506..ff0a3e6 100644
--- a/fs/xattr_acl.c
+++ b/fs/xattr_acl.c
@@ -17,14 +17,18 @@
 struct posix_acl *
 posix_acl_from_xattr(const void *value, size_t size)
 {
-	posix_acl_xattr_header *header = (posix_acl_xattr_header *)value;
-	posix_acl_xattr_entry *entry = (posix_acl_xattr_entry *)(header+1), *end;
+	posix_acl_xattr_header *header;
+	posix_acl_xattr_entry *entry, *end;
 	int count;
 	struct posix_acl *acl;
 	struct posix_acl_entry *acl_e;
 
 	if (!value)
 		return NULL;
+
+	header = (posix_acl_xattr_header *)value;
+	entry = (posix_acl_xattr_entry *)(header+1)
+
 	if (size < sizeof(posix_acl_xattr_header))
 		 return ERR_PTR(-EINVAL);
 	if (header->a_version != cpu_to_le32(POSIX_ACL_XATTR_VERSION))
@@ -35,12 +39,12 @@ posix_acl_from_xattr(const void *value, size_t size)
 		return ERR_PTR(-EINVAL);
 	if (count == 0)
 		return NULL;
-	
+
 	acl = posix_acl_alloc(count, GFP_NOFS);
 	if (!acl)
 		return ERR_PTR(-ENOMEM);
 	acl_e = acl->a_entries;
-	
+
 	for (end = entry + count; entry != end; acl_e++, entry++) {
 		acl_e->e_tag  = le16_to_cpu(entry->e_tag);
 		acl_e->e_perm = le16_to_cpu(entry->e_perm);



-- 
Jesper Juhl <jj@chaosbits.net>            http://www.chaosbits.net/
Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please.

