Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934223Ab3AIV0z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 16:26:55 -0500
Received: from mail.kernel.org ([198.145.19.201]:42566 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933299Ab3AIUjJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 15:39:09 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        NeilBrown <neilb@suse.de>,
        Trond Myklebust <Trond.Myklebust@netapp.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [ 055/123] vfs: d_obtain_alias() needs to use "/" as default name.
Date: Wed,  9 Jan 2013 12:34:54 -0800
Message-Id: <20130109201505.612963793@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130109201458.392601412@linuxfoundation.org>
References: <20130109201458.392601412@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: NeilBrown <neilb@suse.de>

commit b911a6bdeef5848c468597d040e3407e0aee04ce upstream.

NFS appears to use d_obtain_alias() to create the root dentry rather than
d_make_root.  This can cause 'prepend_path()' to complain that the root
has a weird name if an NFS filesystem is lazily unmounted.  e.g.  if
"/mnt" is an NFS mount then

 { cd /mnt; umount -l /mnt ; ls -l /proc/self/cwd; }

will cause a WARN message like
   WARNING: at /home/git/linux/fs/dcache.c:2624 prepend_path+0x1d7/0x1e0()
   ...
   Root dentry has weird name <>

to appear in kernel logs.

So change d_obtain_alias() to use "/" rather than "" as the anonymous
name.

Signed-off-by: NeilBrown <neilb@suse.de>
Cc: Trond Myklebust <Trond.Myklebust@netapp.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/dcache.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -1583,7 +1583,7 @@ EXPORT_SYMBOL(d_find_any_alias);
  */
 struct dentry *d_obtain_alias(struct inode *inode)
 {
-	static const struct qstr anonstring = { .name = "" };
+	static const struct qstr anonstring = QSTR_INIT("/", 1);
 	struct dentry *tmp;
 	struct dentry *res;
 


