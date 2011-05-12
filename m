Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753602Ab1ELBYg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 21:24:36 -0400
Received: from cobra.newdream.net ([66.33.216.30]:54289 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751026Ab1ELBYc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 21:24:32 -0400
From: Sage Weil <sage@newdream.net>
To: viro@ZenIV.linux.org.uk, hch@lst.de
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        ceph-devel@vger.kernel.org, Sage Weil <sage@newdream.net>
Subject: [PATCH 0/3] d_prune
Date: Wed, 11 May 2011 18:43:33 -0700
Message-Id: <1305164616-26597-1-git-send-email-sage@newdream.net>
X-Mailer: git-send-email 1.7.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Ceph client is told by the server when it has the entire contents of 
a directory in cache, and is notified prior to any changes.  However, 
the current VFS infrastructure does not allow the client to handle a 
lookup on a non-existent entry in a non-racy way.

The first patch addes a new d_prune dentry_operation that is called 
before the VFS throws dentries out of cache (specifically, before the 
victim dentry is unhashed).  The next two patches make the necessary 
changes in the Ceph fs code to safely clear a D_COMPLETE flag on the 
directory dentry when a child is pruned.  The third patch specifically 
compensates for calls to dentry_unhash() in vfs_rmdir() and 
vfs_rename_dir().  The last patch adjusts the Ceph fs code to take 
advantage of the new flag.  That change is pretty simple because most of 
the infrastructure is already in place (we were previously relying on 
d_release for notification of pruning in a racy way).

Adding this interface would more or less codify the idea that the VFS 
shouldn't unhash random dentries without first calling d_prune.  There 
are currently two places where the VFS currently unhashes: vfs_rmdir and 
vfs_rename_dir both call dentry_unhash(), which is there to make it easy 
for simple file systems to avoid races with directory removal and 
lookups.  That could arguably be pushed down into those file systems, 
but it's a more delicate cleanup.



Sage Weil (3):
  vfs: add d_prune dentry operation
  ceph: clear parent D_COMPLETE flag when on dentry prune
  ceph: switch I_COMPLETE to D_COMPLETE

 Documentation/filesystems/Locking |    1 +
 fs/ceph/caps.c                    |    8 +--
 fs/ceph/dir.c                     |   87 +++++++++++++++++++++++++++++++++----
 fs/ceph/inode.c                   |    9 ++--
 fs/ceph/mds_client.c              |    6 +-
 fs/ceph/super.h                   |   23 +++++++++-
 fs/dcache.c                       |    8 +++
 include/linux/dcache.h            |    3 +
 8 files changed, 121 insertions(+), 24 deletions(-)

