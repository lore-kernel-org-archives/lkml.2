Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757469Ab1ANCeI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 21:34:08 -0500
Received: from mtoichi11.ns.itscom.net ([219.110.2.181]:63081 "EHLO
	mtoichi11.ns.itscom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752242Ab1ANCd7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 21:33:59 -0500
From: "J. R. Okajima" <hooanon05@yahoo.co.jp>
Subject: Re: vfs-scale, nd->inode after __do_follow_link()
To: Nick Piggin <npiggin@gmail.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-kernel@vger.kernel.org
In-Reply-To: <7352.1294971049@jrobl>
References: <7352.1294971049@jrobl>
Date: Fri, 14 Jan 2011 11:33:56 +0900
Message-ID: <7830.1294972436@jrobl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


"J. R. Okajima":
> Isn't it path.dentry->d_inode instead of nd.inode?

There is another one just after.

J. R. Okajima

diff --git a/fs/namei.c b/fs/namei.c
index 5bb7588..03e45ae 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2356,8 +2374,9 @@ reval:
 			goto exit_dput;
 		error = __do_follow_link(&path, &nd, &cookie);
 		if (unlikely(error)) {
-			if (!IS_ERR(cookie) && nd.inode->i_op->put_link)
-				nd.inode->i_op->put_link(path.dentry, &nd, cookie);
+			struct inode *i = path.dentry->d_inode;
+			if (!IS_ERR(cookie) && i->i_op->put_link)
+				i->i_op->put_link(path.dentry, &nd, cookie);
 			/* nd.path had been dropped */
 			nd.path = path;
 			goto out_path;
@@ -2365,8 +2384,11 @@ reval:
 		holder = path;
 		nd.flags &= ~LOOKUP_PARENT;
 		filp = do_last(&nd, &path, open_flag, acc_mode, mode, pathname);
-		if (nd.inode->i_op->put_link)
-			nd.inode->i_op->put_link(holder.dentry, &nd, cookie);
+		{
+			struct inode *i = holder.dentry->d_inode;
+			if (i->i_op->put_link)
+				i->i_op->put_link(holder.dentry, &nd, cookie);
+		}
 		path_put(&holder);
 	}
 out:
