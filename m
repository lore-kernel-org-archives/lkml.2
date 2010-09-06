Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755120Ab0IFAvd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Sep 2010 20:51:33 -0400
Received: from cantor.suse.de ([195.135.220.2]:50950 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755008Ab0IFAva (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Sep 2010 20:51:30 -0400
From: NeilBrown <neilb@suse.de>
To: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 06 Sep 2010 10:50:28 +1000
Subject: [PATCH 03/10] ovl: use correct seek function for directories.
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <20100906005028.20775.30276.stgit@localhost.localdomain>
In-Reply-To: <20100906004829.20775.68828.stgit@localhost.localdomain>
References: <20100906004829.20775.68828.stgit@localhost.localdomain>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is incorrect to call generic_llseek_file on a file from a different
filesystem.  For that we must use the seek function that the
filesystem defines, which is called by vfs_llseek.

Also, we only want to seek the realfile when is_real is true.
Otherwise we just want to update our own f_pos pointer, so use
generic_llseek_file for that.

Signed-off-by: NeilBrown <neilb@suse.de>
---
 fs/overlayfs/overlayfs.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/overlayfs/overlayfs.c b/fs/overlayfs/overlayfs.c
index 4e032e8..306de45 100644
--- a/fs/overlayfs/overlayfs.c
+++ b/fs/overlayfs/overlayfs.c
@@ -307,8 +307,11 @@ static loff_t ovl_dir_llseek(struct file *file, loff_t offset, int origin)
 	loff_t res;
 	struct ovl_dir_file *od = file->private_data;
 
-	res = generic_file_llseek(od->realfile, offset, origin);
-	file->f_pos = od->realfile->f_pos;
+	if (od->is_real) {
+		res = vfs_llseek(od->realfile, offset, origin);
+		file->f_pos = od->realfile->f_pos;
+	} else
+		res = generic_file_llseek(file, offset, origin);
 
 	return res;
 }


