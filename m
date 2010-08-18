Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753327Ab0HRNj4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 09:39:56 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:50054 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753308Ab0HRNjy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 09:39:54 -0400
To: viro@ZenIV.linux.org.uk
CC: jkmalinen@gmail.com, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
In-reply-to: <E1OlimD-0006YS-3T@pomaz-ex.szeredi.hu> (message from Miklos
	Szeredi on Wed, 18 Aug 2010 15:33:57 +0200)
Subject: Re: [PATCH] uml: fix hostfs lookup
References: <E1OlimD-0006YS-3T@pomaz-ex.szeredi.hu>
Message-Id: <E1Olirt-0006aI-DV@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 18 Aug 2010 15:39:49 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oops, sorry.  Off-by-one bug crept in there.

Updated patch follows.

Thanks,
Miklos

----
Subject: uml: fix hostfs lookup

From: Miklos Szeredi <mszeredi@suse.cz>

commit e9193059 (hostfs: fix races in dentry_name() and inode_name())
broke hostfs lookup.

The cause of the bug was that strncpy() zero fills the whole buffer.

Replace strncpy() with memcpy() and replace open coded memory move
with memmove().

Reported-by: Jouni Malinen <jkmalinen@gmail.com>
Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/hostfs/hostfs_kern.c |   14 +++-----------
 1 file changed, 3 insertions(+), 11 deletions(-)

Index: linux-2.6/fs/hostfs/hostfs_kern.c
===================================================================
--- linux-2.6.orig/fs/hostfs/hostfs_kern.c	2010-08-18 15:09:07.000000000 +0200
+++ linux-2.6/fs/hostfs/hostfs_kern.c	2010-08-18 15:36:34.000000000 +0200
@@ -100,20 +100,12 @@ static char *__dentry_name(struct dentry
 
 	root = dentry->d_sb->s_fs_info;
 	len = strlen(root);
-	if (IS_ERR(p)) {
+	if (IS_ERR(p) || len > p - name) {
 		__putname(name);
 		return NULL;
 	}
-	strncpy(name, root, PATH_MAX);
-	if (len > p - name) {
-		__putname(name);
-		return NULL;
-	}
-	if (p > name + len) {
-		char *s = name + len;
-		while ((*s++ = *p++) != '\0')
-			;
-	}
+	memcpy(name, root, len);
+	memmove(name + len, p, PATH_MAX - (p - name));
 	return name;
 }
 
