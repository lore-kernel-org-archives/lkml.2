Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752436Ab1BBAnU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 19:43:20 -0500
Received: from mga14.intel.com ([143.182.124.37]:16719 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752387Ab1BBAnS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 19:43:18 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,412,1291622400"; 
   d="scan'208";a="382960331"
From: Andi Kleen <andi@firstfloor.org>
References: <20110201443.618138584@firstfloor.org>
In-Reply-To: <20110201443.618138584@firstfloor.org>
To: vsu@altlinux.ru, amorozov@etersoft.ru, Trond.Myklebust@netapp.com,
        gregkh@suse.de, ak@linux.intel.com, linux-kernel@vger.kernel.org,
        stable@kernel.org
Subject: [PATCH] [14/139] NFS: Fix fcntl F_GETLK not reporting some conflicts
Message-Id: <20110202004328.619F53E09BD@tassilo.jf.intel.com>
Date: Tue,  1 Feb 2011 16:43:28 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 fs/nfs/file.c |    2 ++
 1 file changed, 2 insertions(+)

Index: linux-2.6.35.y/fs/nfs/file.c
===================================================================
--- linux-2.6.35.y.orig/fs/nfs/file.c
+++ linux-2.6.35.y/fs/nfs/file.c
@@ -696,6 +696,7 @@ static int do_getlk(struct file *filp, i
 {
 	struct inode *inode = filp->f_mapping->host;
 	int status = 0;
+	unsigned int saved_type = fl->fl_type;
 
 	/* Try local locking first */
 	posix_test_lock(filp, fl);
@@ -703,6 +704,7 @@ static int do_getlk(struct file *filp, i
 		/* found a conflict */
 		goto out;
 	}
+	fl->fl_type = saved_type;
 
 	if (nfs_have_delegation(inode, FMODE_READ))
 		goto out_noconflict;
