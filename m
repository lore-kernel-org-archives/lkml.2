Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757691Ab0ITV1S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 17:27:18 -0400
Received: from cantor.suse.de ([195.135.220.2]:58085 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757647Ab0ITV1Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 17:27:16 -0400
From: Andreas Gruenbacher <agruen@suse.de>
Organization: SUSE Labs, Novell Inc.
To: Valerie Aurora <vaurora@redhat.com>
Subject: Re: [PATCH 01/34] VFS: Make clone_mnt() and copy_tree() return error codes
Date: Mon, 20 Sep 2010 23:26:42 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.34-12-desktop; KDE/4.4.4; x86_64; ; )
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
        Miklos Szeredi <miklos@szeredi.hu>,
        Christoph Hellwig <hch@infradead.org>, Nick Piggin <npiggin@kernel.dk>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
References: <1284675145-4391-1-git-send-email-vaurora@redhat.com> <1284675145-4391-2-git-send-email-vaurora@redhat.com>
In-Reply-To: <1284675145-4391-2-git-send-email-vaurora@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201009202326.43538.agruen@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

collect_mounts() now also returns error pointers instead of NULL upon
failure:

diff --git a/kernel/audit_tree.c b/kernel/audit_tree.c
index 46a57b5..898da28 100644
--- a/kernel/audit_tree.c
+++ b/kernel/audit_tree.c
@@ -579,7 +579,7 @@ void audit_trim_trees(void)
 
 		root_mnt = collect_mounts(&path);
 		path_put(&path);
-		if (!root_mnt)
+		if (IS_ERR(root_mnt))
 			goto skip_it;
 
 		spin_lock(&hash_lock);
@@ -651,8 +651,8 @@ int audit_add_tree_rule(struct audit_krule *rule)
 		goto Err;
 	mnt = collect_mounts(&path);
 	path_put(&path);
-	if (!mnt) {
-		err = -ENOMEM;
+	if (IS_ERR(mnt)) {
+		err = PTR_ERR(mnt);
 		goto Err;
 	}
 
@@ -701,8 +701,8 @@ int audit_tag_tree(char *old, char *new)
 		return err;
 	tagged = collect_mounts(&path2);
 	path_put(&path2);
-	if (!tagged)
-		return -ENOMEM;
+	if (IS_ERR(tagged))
+		return PTR_ERR(tagged);
 
 	err = kern_path(old, 0, &path1);
 	if (err) {
-- 
1.7.3.rc2
