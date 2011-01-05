Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753236Ab1AEXLo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 18:11:44 -0500
Received: from kroah.org ([198.145.64.141]:50729 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753080Ab1AEXGU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 18:06:20 -0500
X-Mailbox-Line: From gregkh@clark.site Wed Jan  5 15:03:24 2011
Message-Id: <20110105230324.525851041@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 05 Jan 2011 15:00:29 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Sergey Vlasov <vsu@altlinux.ru>,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [11/49] NFS: Fix fcntl F_GETLK not reporting some conflicts
In-Reply-To: <20110105230438.GA26241@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Sergey Vlasov <vsu@altlinux.ru>

commit 21ac19d484a8ffb66f64487846c8d53afef04d2b upstream.

The commit 129a84de2347002f09721cda3155ccfd19fade40 (locks: fix F_GETLK
regression (failure to find conflicts)) fixed the posix_test_lock()
function by itself, however, its usage in NFS changed by the commit
9d6a8c5c213e34c475e72b245a8eb709258e968c (locks: give posix_test_lock
same interface as ->lock) remained broken - subsequent NFS-specific
locking code received F_UNLCK instead of the user-specified lock type.
To fix the problem, fl->fl_type needs to be saved before the
posix_test_lock() call and restored if no local conflicts were reported.

Reference: https://bugzilla.kernel.org/show_bug.cgi?id=23892
Tested-by: Alexander Morozov <amorozov@etersoft.ru>
Signed-off-by: Sergey Vlasov <vsu@altlinux.ru>
Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/nfs/file.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/nfs/file.c
+++ b/fs/nfs/file.c
@@ -680,6 +680,7 @@ static int do_getlk(struct file *filp, i
 {
 	struct inode *inode = filp->f_mapping->host;
 	int status = 0;
+	unsigned int saved_type = fl->fl_type;
 
 	/* Try local locking first */
 	posix_test_lock(filp, fl);
@@ -687,6 +688,7 @@ static int do_getlk(struct file *filp, i
 		/* found a conflict */
 		goto out;
 	}
+	fl->fl_type = saved_type;
 
 	if (nfs_have_delegation(inode, FMODE_READ))
 		goto out_noconflict;


