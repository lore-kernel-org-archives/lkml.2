Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932544Ab1BYKZr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 05:25:47 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:39248 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932510Ab1BYKZp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 05:25:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent;
        b=beY0n9EJ5qszYZr2FOXDkwlKnGQ8fpWoHadG0ho4TBgiAMnLpYMR87XxviXFwknx2Z
         4pto15LiXSjpQcSZcP1aPL+V/zqXKdZfx9jcKFL2nnz3QX1lIr7Z009aX5vn6JENlmb2
         Z4H7ajDSTYFKtaPrh6ySc6JWF+8fOQeqeUbk0=
Date: Fri, 25 Feb 2011 13:25:29 +0300
From: Dan Carpenter <error27@gmail.com>
To: Evgeniy Dushistov <dushistov@mail.ru>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] ufs: truncated values handling 64 bit metadata
Message-ID: <20110225102529.GB1936@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Evgeniy Dushistov <dushistov@mail.ru>, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Originally i_lastfrag was 32 bits but then we added support for handling
64 bit metadata and it became a 64 bit variable.  That was during 2007,
in 54fb996ac15c "[PATCH] ufs2 write: block allocation update".
Unfortunately these casts got left behind so the value got truncated to
32 bit again.

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/fs/ufs/balloc.c b/fs/ufs/balloc.c
index 46f7a80..100d2ee 100644
--- a/fs/ufs/balloc.c
+++ b/fs/ufs/balloc.c
@@ -424,7 +424,7 @@ u64 ufs_new_fragments(struct inode *inode, void *p, u64 fragment,
 			ufs_cpu_to_data_ptr(sb, p, result);
 			*err = 0;
 			UFS_I(inode)->i_lastfrag =
-				max_t(u32, UFS_I(inode)->i_lastfrag,
+				max_t(u64, UFS_I(inode)->i_lastfrag,
 				      fragment + count);
 			ufs_clear_frags(inode, result + oldcount,
 					newcount - oldcount, locked_page != NULL);
@@ -440,7 +440,7 @@ u64 ufs_new_fragments(struct inode *inode, void *p, u64 fragment,
 	result = ufs_add_fragments (inode, tmp, oldcount, newcount, err);
 	if (result) {
 		*err = 0;
-		UFS_I(inode)->i_lastfrag = max_t(u32, UFS_I(inode)->i_lastfrag, fragment + count);
+		UFS_I(inode)->i_lastfrag = max_t(u64, UFS_I(inode)->i_lastfrag, fragment + count);
 		ufs_clear_frags(inode, result + oldcount, newcount - oldcount,
 				locked_page != NULL);
 		unlock_super(sb);
@@ -479,7 +479,7 @@ u64 ufs_new_fragments(struct inode *inode, void *p, u64 fragment,
 				   uspi->s_sbbase + result, locked_page);
 		ufs_cpu_to_data_ptr(sb, p, result);
 		*err = 0;
-		UFS_I(inode)->i_lastfrag = max_t(u32, UFS_I(inode)->i_lastfrag, fragment + count);
+		UFS_I(inode)->i_lastfrag = max_t(u64, UFS_I(inode)->i_lastfrag, fragment + count);
 		unlock_super(sb);
 		if (newcount < request)
 			ufs_free_fragments (inode, result + newcount, request - newcount);
diff --git a/fs/ufs/truncate.c b/fs/ufs/truncate.c
index a58f915..9b2a193 100644
--- a/fs/ufs/truncate.c
+++ b/fs/ufs/truncate.c
@@ -85,7 +85,7 @@ static int ufs_trunc_direct(struct inode *inode)
 	retry = 0;
 	
 	frag1 = DIRECT_FRAGMENT;
-	frag4 = min_t(u32, UFS_NDIR_FRAGMENT, ufsi->i_lastfrag);
+	frag4 = min_t(u64, UFS_NDIR_FRAGMENT, ufsi->i_lastfrag);
 	frag2 = ((frag1 & uspi->s_fpbmask) ? ((frag1 | uspi->s_fpbmask) + 1) : frag1);
 	frag3 = frag4 & ~uspi->s_fpbmask;
 	block1 = block2 = 0;
