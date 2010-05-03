Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932114Ab0ECXhq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 May 2010 19:37:46 -0400
Received: from cantor.suse.de ([195.135.220.2]:43669 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759911Ab0ECXhn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 May 2010 19:37:43 -0400
Date: Tue, 4 May 2010 09:37:31 +1000
From: Neil Brown <neilb@suse.de>
To: Valerie Aurora <vaurora@redhat.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
       Jan Blunck <jblunck@suse.de>, David Woodhouse <dwmw2@infradead.org>,
       linux-nfs@vger.kernel.org, "J. Bruce Fields" <bfields@fieldses.org>
Subject: Re: [PATCH 05/39] whiteout/NFSD: Don't return information about
 whiteouts to userspace
Message-ID: <20100504093731.3a45ff5f@notabene.brown>
In-Reply-To: <1272928358-20854-6-git-send-email-vaurora@redhat.com>
References: <1272928358-20854-1-git-send-email-vaurora@redhat.com>
	<1272928358-20854-6-git-send-email-vaurora@redhat.com>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.7; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon,  3 May 2010 16:12:04 -0700
Valerie Aurora <vaurora@redhat.com> wrote:

> From: Jan Blunck <jblunck@suse.de>
> 
> Userspace isn't ready for handling another file type, so silently drop
> whiteout directory entries before they leave the kernel.

Feels very intrusive doesn't it....

Have you considered something like the following?

NeilBrown

diff --git a/fs/readdir.c b/fs/readdir.c
index 7723401..4c5b347 100644
--- a/fs/readdir.c
+++ b/fs/readdir.c
@@ -19,10 +19,26 @@
 
 #include <asm/uaccess.h>
 
+struct readdir_info {
+	filldir_t filler;
+	void *data;
+};
+
+static int white_out(void *vrdi, const char *name, int namlen,
+		     loff_t offset, u64 ino, unsigned int d_type)
+{
+	struct readdir_info *rdi = vrdi;
+	if (d_type == DT_WHT)
+		return 0;
+	return rdi->filler(rdi->data, name, namlen, offset, info, d_type);
+}
+
 int vfs_readdir(struct file *file, filldir_t filler, void *buf)
 {
 	struct inode *inode = file->f_path.dentry->d_inode;
 	int res = -ENOTDIR;
+	struct readir_info rdi = { filler, buf };
+
 	if (!file->f_op || !file->f_op->readdir)
 		goto out;
 
@@ -36,7 +52,7 @@ int vfs_readdir(struct file *file, filldir_t filler, void *buf)
 
 	res = -ENOENT;
 	if (!IS_DEADDIR(inode)) {
-		res = file->f_op->readdir(file, buf, filler);
+		res = file->f_op->readdir(file, &rdi, white_out);
 		file_accessed(file);
 	}
 	mutex_unlock(&inode->i_mutex);
