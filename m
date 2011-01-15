Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751518Ab1AONqW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Jan 2011 08:46:22 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:38580 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750839Ab1AONqV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Jan 2011 08:46:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent;
        b=Sm6higfJKrzsJ8g/NMrSooVs+QiCqwAch4dYGdnGCukWrLCfDqpFlh+eFni+91Gu+n
         JnCSpAvwO5RFBLV/fi+m6CcBzSCO2++gzPypv602RJ/d6KBmyHg5+protD62N1rq6vSR
         DMjM3TAwTzXNLThwYw4RuUSXUziXDuz1y7OL4=
Date: Sat, 15 Jan 2011 16:46:05 +0300
From: Dan Carpenter <error27@gmail.com>
To: reiserfs-devel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] reiserfs: potential ERR_PTR dereference
Message-ID: <20110115134605.GB2721@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	reiserfs-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

reiserfs_iget() returns an ERR_PTR on allocation failures.  All the
other callers check for it so we should check here too.

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/fs/reiserfs/super.c b/fs/reiserfs/super.c
index 0aab04f..6949b98 100644
--- a/fs/reiserfs/super.c
+++ b/fs/reiserfs/super.c
@@ -237,7 +237,7 @@ static int finish_unfinished(struct super_block *s)
 		pathrelse(&path);
 
 		inode = reiserfs_iget(s, &obj_key);
-		if (!inode) {
+		if (IS_ERR_OR_NULL(inode)) {
 			/* the unlink almost completed, it just did not manage to remove
 			   "save" link and release objectid */
 			reiserfs_warning(s, "vs-2180", "iget failed for %K",
