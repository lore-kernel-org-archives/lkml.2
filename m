Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753777Ab1GZUcr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 16:32:47 -0400
Received: from cobra.newdream.net ([66.33.216.30]:44176 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753248Ab1GZUcp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 16:32:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws; d=newdream.net; h=date:from:to:cc
	:subject:message-id:mime-version:content-type; q=dns; s=
	newdream.net; b=AU0H6qk25FNA0I9akdOzB/QqzL+CviYU2Uw4hgFryK/B6cRL
	UEroXR3mWTgkYwWW5PVX+vnhNBktdkzN3HSLgazgIeIY7sqMJVZJVk6dAzYmhJKz
	VCTz3GpQO+4Dgc6JUvkI7qYi/d9DtfUGGddmfHKYloOurnMVZevS7J6aDHU=
Date: Tue, 26 Jul 2011 13:36:37 -0700 (PDT)
From: Sage Weil <sage@newdream.net>
To: torvalds@linux-foundation.org
cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        ceph-devel@vger.kernel.org
Subject: [GIT PULL] Ceph updates for 3.1-rc1
Message-ID: <Pine.LNX.4.64.1107261152440.2593@cobra.newdream.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull the following Ceph updates from

  git://git.kernel.org/pub/scm/linux/kernel/git/sage/ceph-client.git for-linus

Lots of different things here.  There is some code cleanup with the file 
flags, a few snapshot metadata writeback fixes, a fix for unnecessary 
timeouts on heavily loaded clusters, and a fix for dentry leases.  There 
are many fixes for bugs Al turned up: a fix and cleanup in the open intent 
code, and several fixes for d_parent use without the appropriate locks (a 
full code audit caught a few more).  RBD devices now clean up on the 
server when they are unmapped, rbd request sizes are now larger, and the 
ceph readahead window is set up properly.

Thanks!
sage


Greg Farnum (1):
      ceph: report f_bfree based on kb_avail rather than diffing.

Josh Durgin (1):
      rbd: set blk_queue request sizes to object size

Sage Weil (19):
      ceph: add flags field to file_info
      ceph: add F_SYNC file flag to force sync (non-O_DIRECT) io
      ceph: use flag bit for at_end readdir flag
      ceph: fix snap writeback when racing with writes
      ceph: only queue capsnap if caps are dirty
      libceph: don't time out osd requests that haven't been received
      ceph: avoid carrying Fw cap during write into page cache
      ceph: fix bad parent_inode calc in ceph_lookup_open
      ceph: only link open operations to directory unsafe list if O_CREAT|O_TRUNC
      ceph: fix ceph_lookup_open intent usage
      ceph: ignore lease mask
      ceph: set dir complete frag after adding capability
      ceph: handle racing calls to ceph_init_dentry
      ceph: protect access to d_parent
      ceph: protect d_parent access in ceph_d_revalidate
      ceph: avoid d_parent in ceph_dentry_hash; fix ceph_encode_fh() hashing bug
      ceph: document locking for ceph_set_dentry_offset
      ceph: explicitly reference rename old_dentry parent dir in request
      ceph: document unlocked d_parent accesses

Yehuda Sadeh (2):
      rbd: cancel watch request when releasing the device
      ceph: set up readahead size when rsize is not passed

 drivers/block/rbd.c            |   46 +++++++++++++++-
 fs/ceph/debugfs.c              |    2 +-
 fs/ceph/dir.c                  |  116 +++++++++++++++++++++++++---------------
 fs/ceph/export.c               |   24 +++++---
 fs/ceph/file.c                 |   61 +++++++++++++++------
 fs/ceph/inode.c                |   48 +++++++++-------
 fs/ceph/ioctl.c                |   15 +++++-
 fs/ceph/ioctl.h                |    1 +
 fs/ceph/mds_client.c           |   56 +++++++++++---------
 fs/ceph/mds_client.h           |    3 +-
 fs/ceph/snap.c                 |   25 +++++++--
 fs/ceph/super.c                |    7 ++-
 fs/ceph/super.h                |   20 +++----
 fs/ceph/xattr.c                |    8 ++-
 include/linux/ceph/messenger.h |    1 +
 net/ceph/messenger.c           |   12 ++---
 net/ceph/osd_client.c          |    6 ++
 17 files changed, 306 insertions(+), 145 deletions(-)
