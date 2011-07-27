Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753955Ab1G0AkI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 20:40:08 -0400
Received: from mga09.intel.com ([134.134.136.24]:52724 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753656Ab1G0AfJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 20:35:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,272,1309762800"; 
   d="scan'208";a="30471086"
From: Andi Kleen <andi@firstfloor.org>
References: <20110726534.972201586@firstfloor.org>
In-Reply-To: <20110726534.972201586@firstfloor.org>
To: jlayton@redhat.com, Trond.Myklebust@netapp.com, gregkh@suse.de,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, stable@kernel.org,
        tim.bird@am.sony.com, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH] [16/98] nfs: don't lose MS_SYNCHRONOUS on remount of noac mount
Message-Id: <20110727003508.422A92403FF@tassilo.jf.intel.com>
Date: Tue, 26 Jul 2011 17:35:08 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Jeff Layton <jlayton@redhat.com>

commit 26c4c170731f00008f4317a2888a0a07ac99d90d upstream.

On a remount, the VFS layer will clear the MS_SYNCHRONOUS bit on the
assumption that the flags on the mount syscall will have it set if the
remounted fs is supposed to keep it.

In the case of "noac" though, MS_SYNCHRONOUS is implied. A remount of
such a mount will lose the MS_SYNCHRONOUS flag since "sync" isn't part
of the mount options.

Reported-by: Max Matveev <makc@redhat.com>
Signed-off-by: Jeff Layton <jlayton@redhat.com>
Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 fs/nfs/super.c |    9 +++++++++
 1 file changed, 9 insertions(+)

Index: linux-2.6.35.y/fs/nfs/super.c
===================================================================
--- linux-2.6.35.y.orig/fs/nfs/super.c
+++ linux-2.6.35.y/fs/nfs/super.c
@@ -2001,6 +2001,15 @@ nfs_remount(struct super_block *sb, int 
 	if (error < 0)
 		goto out;
 
+	/*
+	 * noac is a special case. It implies -o sync, but that's not
+	 * necessarily reflected in the mtab options. do_remount_sb
+	 * will clear MS_SYNCHRONOUS if -o sync wasn't specified in the
+	 * remount options, so we have to explicitly reset it.
+	 */
+	if (data->flags & NFS_MOUNT_NOAC)
+		*flags |= MS_SYNCHRONOUS;
+
 	/* compare new mount options with old ones */
 	error = nfs_compare_remount_data(nfss, data);
 out:
