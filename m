Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932706Ab1EFAcZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 20:32:25 -0400
Received: from kroah.org ([198.145.64.141]:37578 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932666Ab1EFA1f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 20:27:35 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Thu May  5 17:26:09 2011
Message-Id: <20110506002609.298518501@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 05 May 2011 17:25:42 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jeff Layton <jlayton@redhat.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [21/43] nfs: dont lose MS_SYNCHRONOUS on remount of noac mount
In-Reply-To: <20110506002625.GA20426@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-longterm review patch.  If anyone has any objections, please let us know.

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

---
 fs/nfs/super.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/fs/nfs/super.c
+++ b/fs/nfs/super.c
@@ -1981,6 +1981,15 @@ nfs_remount(struct super_block *sb, int
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


