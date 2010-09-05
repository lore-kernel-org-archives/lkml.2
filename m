Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752676Ab0IELpF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Sep 2010 07:45:05 -0400
Received: from cantor2.suse.de ([195.135.220.15]:44407 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751043Ab0IELpD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Sep 2010 07:45:03 -0400
Date: Sun, 5 Sep 2010 21:44:52 +1000
From: Neil Brown <neilb@suse.de>
To: "J. R. Okajima" <hooanon05@yahoo.co.jp>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, vaurora@redhat.com,
        viro@zeniv.linux.org.uk
Subject: Re: [PATCH 0/6] overlay filesystem prototype
Message-ID: <20100905214452.797527a7@notabene>
In-Reply-To: <20970.1283683030@jrobl>
References: <20100903134116.039612691@szeredi.hu>
	<20970.1283683030@jrobl>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 05 Sep 2010 19:37:10 +0900
"J. R. Okajima" <hooanon05@yahoo.co.jp> wrote:

> 
> Miklos Szeredi:
> > Changes since the last version:
> 	:::
> >  - get write ref on the upper layer on mount unless the overlay
> >    itself is mounted read-only
> 
> I think it a good approach.
> Although it may be harmless, write-ref will not be put when a user
> executes,
> - mount -o ro /overlay
             ^remount,   I assume
> - umount /overlay
> It will be easy to fix by implementing s_op->remount().

Something like this?

(I have a few other patches queued up, but haven't tested anything properly
yet).

NeilBrown

>From 3a9e1d4f07c5d6fd18cc165537107dd31233ec1f Mon Sep 17 00:00:00 2001
From: NeilBrown <neilb@suse.de>
Date: Sat, 4 Sep 2010 09:17:54 +1000
Subject: [PATCH] ovl: minimal remount support.

As overlayfs reflects the 'readonly' mount status in write-access to
the upper filesystem, we must handle remount and either drop or take
write access when the ro status changes.

Signed-off-by: NeilBrown <neilb@suse.de>

diff --git a/fs/overlayfs/overlayfs.c b/fs/overlayfs/overlayfs.c
index 0ddfeec..4e032e8 100644
--- a/fs/overlayfs/overlayfs.c
+++ b/fs/overlayfs/overlayfs.c
@@ -1685,8 +1685,28 @@ static void ovl_put_super(struct super_block *sb)
 	kfree(ufs);
 }
 
+static int ovl_remount_fs(struct super_block *sb, int *flagsp, char *data)
+{
+	int flags = *flagsp;
+	struct ovl_fs *ufs = sb->s_fs_info;
+
+	/* When remounting rw or ro, we need to adjust the write access to the
+	 * upper fs.
+	 */
+	if (((flags ^ sb->s_flags) & MS_RDONLY) == 0)
+		/* No change to readonly status */
+		return 0;
+
+	if (flags & MS_RDONLY) {
+		mnt_drop_write(ufs->upper_mnt);
+		return 0;
+	} else
+		return mnt_want_write(ufs->upper_mnt);
+}
+
 static const struct super_operations ovl_super_operations = {
 	.put_super	= ovl_put_super,
+	.remount_fs	= ovl_remount_fs,
 };
 
 struct ovl_config {
