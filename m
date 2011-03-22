Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756154Ab1CVAnz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 20:43:55 -0400
Received: from cobra.newdream.net ([66.33.216.30]:54383 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754833Ab1CVAnO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 20:43:14 -0400
From: Sage Weil <sage@newdream.net>
To: linux-fsdevel@vger.kernel.org, viro@ZenIV.linux.org.uk
Cc: linux-kernel@vger.kernel.org, ceph-devel@vger.kernel.org
Subject: 
Date: Mon, 21 Mar 2011 17:48:17 -0700
Message-Id: <1300754901-4284-1-git-send-email-sage@newdream.net>
X-Mailer: git-send-email 1.7.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sage Weil <sage@newdream.net> Date: Mon, 21 Mar 2011 15:51:04 

The Ceph client is told by the server when it has the entire contents of 
a directory in cache, and is notified prior to any changes.  However, 
the current VFS interfaces simply do not allow the fs to take advantage 
of the known-valid cached content in a non-racy way.  To do so, the fs 
needs some notification prior to dentries being dropped out of the 
dcache (e.g. due to memory pressure).  Instead, Ceph is currently forced 
to talk to the server, which is quite frustrating (and slow).

The first patch addes a new d_prune dentry_operation that is called 
before the VFS throws dentries out of cache (specifically, before the 
victim dentry is unhashed).  The next two patches make the necessary 
changes in the Ceph fs code to safely clear a D_COMPLETE flag in the 
directory dentry's d_fsdata when a child is pruned.  The third patch 
specifically compensates for calls to dentry_unhash() in vfs_rmdir() and 
vfs_rename_dir().  The last patch adjusts the Ceph fs code to take 
advantage of the new flag.  That change is pretty simple because most of 
the infrastructure is already in place (we were previously relying on 
d_release for racy notification of pruning).

Adding this interface would more or less codify the idea that the VFS 
shouldn't unhash random dentries without first calling d_prune.  There 
are currently two places where the VFS currently unhashes: vfs_rmdir and 
vfs_rename_dir both call dentry_unhash(), which is there to make it easy 
for simple file systems to avoid races with directory removal and 
lookups.  That could arguably be pushed down into those file systems, 
but it's a more delicate cleanup.

Is the d_prune d_op a reasonable VFS interface extension?  Is it 
acceptable in its current form?

Thanks!
sage


See also
  git://git.kernel.org/pub/scm/linux/kernel/git/sage/ceph-client.git d_prune


Sage Weil (4):
  vfs: add d_prune dentry operation
  ceph: clear parent D_COMPLETE flag when on dentry prune
  ceph: compensate for dentry_unhash() calls in vfs_rmdir() and
    vfs_rename_dir()
  ceph: use new D_COMPLETE dentry flag

 Documentation/filesystems/Locking |    1 +
 fs/ceph/caps.c                    |    8 +--
 fs/ceph/dir.c                     |  110 ++++++++++++++++++++++++++++++++-----
 fs/ceph/inode.c                   |    9 +--
 fs/ceph/mds_client.c              |    6 +-
 fs/ceph/super.h                   |   23 +++++++-
 fs/dcache.c                       |    8 +++
 include/linux/dcache.h            |    3 +
 8 files changed, 139 insertions(+), 29 deletions(-)


