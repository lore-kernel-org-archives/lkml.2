Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755329Ab0EVPt0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 May 2010 11:49:26 -0400
Received: from cobra.newdream.net ([66.33.216.30]:39690 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752248Ab0EVPtW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 May 2010 11:49:22 -0400
Date: Sat, 22 May 2010 08:52:51 -0700 (PDT)
From: Sage Weil <sage@newdream.net>
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
cc: ceph-devel@vger.kernel.org
Subject: [GIT PULL] Ceph updates for 2.6.35-rc1
Message-ID: <Pine.LNX.4.64.1005211517270.18940@cobra.newdream.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull the following Ceph updates for 2.6.35 from

  git://git.kernel.org/pub/scm/linux/kernel/git/sage/ceph-client.git for-linus

There is a lot of code cleanup, a handful of bug fixes, some improvement 
in the MDS reconnect process, a (backward compatible) protocol 
improvement, and some improvement in the way memory is preallocated to 
avoid ENOMEM at awkward times.

Thanks!
sage

---

Cheng Renquan (2):
      ceph: handle kzalloc() failure
      ceph: use ceph_sb_to_client instead of ceph_client

Dan Carpenter (3):
      ceph: cleanup: remove dead code
      ceph: d_obtain_alias() returns ERR_PTR()
      ceph: cleanup: remove unused assignement

Henry C Chang (1):
      ceph: listxattr should compare version by >=

Huang Weiyi (1):
      ceph: remove unused #includes

Julia Lawall (1):
      ceph: Use kzalloc

Sage Weil (45):
      ceph: clean up mds reply, error handling
      ceph: fix race between aborted requests and fill_trace
      ceph: invalidate affected dentry leases on aborted requests
      ceph: simplify page setup for incoming data
      ceph: reduce build_path debug output
      ceph: fix theoretically possible double-put on connection
      ceph: clean up statfs
      ceph: drop unnecessary msgpool for mon_client auth_reply
      ceph: drop unnecessary msgpool for mon_client subscribe_ack
      ceph: rewrite msgpool using mempool_t
      ceph: make ceph_msg_new return NULL on failure; clean up, fix callers
      ceph: simplify ceph_msg_new
      ceph: clean up connection reset
      ceph: wait for both monmap and osdmap when opening session
      ceph: osdtimeout=0 for now timeout
      ceph: include auth method in error messages
      ceph: fix memory leak due to possible dentry init race
      ceph: name msgpools; useful error messages
      ceph: close messenger race
      ceph: fix xattr dangling pointer / double free
      ceph: set next_offset on readdir finish
      ceph: skip set_dentry_offset work if directory not I_COMPLETE
      ceph: don't clobber i_max_offset on already complete dir
      ceph: set dn offset when spliced
      ceph: clean up mount options, ->show_options()
      ceph: adjust masked struct_v variable names
      ceph: skip mds sync on forced unmount
      ceph: name bdi ceph-%d instead of major:minor
      ceph: clean up cap release loop vs spinlock
      ceph: drop src address(es) from message header [new protocol feature]
      ceph: dicard cap releases on mds restart
      ceph: only send cap releases when mds is OPEN|HUNG
      ceph: wait for mds OPEN reply to indicate reconnect success
      ceph: clean up send_mds_reconnect interface
      ceph: attempt mds reconnect if mds closes our session
      ceph: throw out dirty caps metadata, data on session teardown
      ceph: use ceph. prefix for virtual xattrs
      ceph: resync headers with userland
      ceph: save peer feature bits in connection structure
      ceph: cope with out of order (unsafe after safe) mds reply
      ceph: use common helper for aborted dir request invalidation
      ceph: cleanup pool op strings
      ceph: specify max_bytes on readdir replies
      ceph: avoid resending queued message to monitor
      ceph: reuse mon subscribe message instead of allocated anew

Stephen Rothwell (1):
      ceph: update for removal of kref_set

Tobias Klauser (1):
      ceph: Storage class should be before const qualifier

Yehuda Sadeh (4):
      ceph: use __page_cache_alloc and add_to_page_cache_lru
      ceph: wake up mount thread when getting osdmap
      ceph: make mon client statfs handling more generic
      ceph: all allocation functions should get gfp_mask

 fs/ceph/addr.c         |   11 +-
 fs/ceph/auth.c         |    9 +-
 fs/ceph/auth.h         |    2 +
 fs/ceph/auth_none.c    |    1 +
 fs/ceph/auth_x.c       |   19 ++-
 fs/ceph/caps.c         |   24 ++--
 fs/ceph/ceph_fs.h      |   62 +++++++-
 fs/ceph/ceph_strings.c |   16 ++-
 fs/ceph/debugfs.c      |   13 +-
 fs/ceph/dir.c          |   45 ++++--
 fs/ceph/export.c       |   14 +-
 fs/ceph/file.c         |   16 +-
 fs/ceph/inode.c        |   97 +++++++------
 fs/ceph/ioctl.c        |    2 +-
 fs/ceph/mds_client.c   |  385 +++++++++++++++++++++++++++++------------------
 fs/ceph/mds_client.h   |    6 +-
 fs/ceph/messenger.c    |   91 +++++-------
 fs/ceph/messenger.h    |   10 +-
 fs/ceph/mon_client.c   |  257 +++++++++++++++++++--------------
 fs/ceph/mon_client.h   |   27 ++--
 fs/ceph/msgpool.c      |  180 ++++-------------------
 fs/ceph/msgpool.h      |   12 +-
 fs/ceph/msgr.h         |   21 +++-
 fs/ceph/osd_client.c   |   98 +++++--------
 fs/ceph/pagelist.c     |    2 +-
 fs/ceph/rados.h        |   23 +++-
 fs/ceph/snap.c         |    2 +-
 fs/ceph/super.c        |  125 ++++++++++------
 fs/ceph/super.h        |   30 ++--
 fs/ceph/xattr.c        |   35 ++---
 30 files changed, 876 insertions(+), 759 deletions(-)
