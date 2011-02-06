Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754567Ab1BFXqK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 18:46:10 -0500
Received: from 1wt.eu ([62.212.114.60]:60310 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754552Ab1BFXqI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 18:46:08 -0500
Message-Id: <20110206232253.039606823@pcw.home.local>
User-Agent: quilt/0.48-1
Date: Mon, 07 Feb 2011 00:23:04 +0100
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: Sergey Vlasov <vsu@altlinux.ru>,
        Trond Myklebust <Trond.Myklebust@netapp.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, Willy Tarreau <w@1wt.eu>
Subject: [PATCH 12/23] NFS: Fix fcntl F_GETLK not reporting some conflicts
In-Reply-To: <4beed4da27f06efb2c13d6ed48850634@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27.58-stable review patch.  If anyone has any objections, please let us know.

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
Signed-off-by: Willy Tarreau <w@1wt.eu>

---
 fs/nfs/file.c |    2 ++
 1 file changed, 2 insertions(+)

Index: longterm-2.6.27/fs/nfs/file.c
===================================================================
--- longterm-2.6.27.orig/fs/nfs/file.c	2011-01-29 11:19:14.707063734 +0100
+++ longterm-2.6.27/fs/nfs/file.c	2011-01-29 11:27:16.154063024 +0100
@@ -552,6 +552,7 @@
 {
 	struct inode *inode = filp->f_mapping->host;
 	int status = 0;
+	unsigned int saved_type = fl->fl_type;
 
 	lock_kernel();
 	/* Try local locking first */
@@ -560,6 +561,7 @@
 		/* found a conflict */
 		goto out;
 	}
+	fl->fl_type = saved_type;
 
 	if (nfs_have_delegation(inode, FMODE_READ))
 		goto out_noconflict;


