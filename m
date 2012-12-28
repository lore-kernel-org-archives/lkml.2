Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754654Ab2L1TR6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 14:17:58 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55108 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754586Ab2L1TRq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 14:17:46 -0500
Message-Id: <20121228190358.888854459@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 28 Dec 2012 20:05:53 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        NeilBrown <neilb@suse.de>,
        Trond Myklebust <Trond.Myklebust@netapp.com>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: [ 143/173] vfs: d_obtain_alias() needs to use "/" as default name.
In-Reply-To: <20121228190330.025298996@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.217.219.220
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
[bwh: Backported to 3.2: use named initialisers instead of QSTR_INIT()]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/dcache.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -1492,7 +1492,7 @@ static struct dentry * d_find_any_alias(
  */
 struct dentry *d_obtain_alias(struct inode *inode)
 {
-	static const struct qstr anonstring = { .name = "" };
+	static const struct qstr anonstring = { .name = "/", .len = 1 };
 	struct dentry *tmp;
 	struct dentry *res;
 


