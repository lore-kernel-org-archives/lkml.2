Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964828Ab2AEQo1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 11:44:27 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1026 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932711Ab2AEQoY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 11:44:24 -0500
From: David Teigland <teigland@redhat.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 0/5] dlm and gfs2 patches for 3.3
Date: Thu,  5 Jan 2012 10:44:12 -0600
Message-Id: <1325781857-7938-1-git-send-email-teigland@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These are dlm and gfs2 patches from -next proposed for 3.3.  The gfs2 part
still needs an ack from Steve W, so it could be dropped.  The patches add
a major feature to the dlm and gfs2 that allows gfs2 mounters and recovery
to be managed directly within the kernel, via the dlm, rather than in
userland.  This new feature is not used by current dlm_controld and
gfs_controld daemons, but will be enabled by a new dlm_controld version
under development.


Bob Peterson (1):
      dlm: convert rsb list to rb_tree

David Teigland (4):
      dlm: move recovery barrier calls
      dlm: add node slots and generation
      dlm: add recovery callbacks
      gfs2: dlm based recovery coordination


 fs/dlm/config.c             |  130 ++++---
 fs/dlm/config.h             |   17 +-
 fs/dlm/debug_fs.c           |   28 +-
 fs/dlm/dir.c                |    1 -
 fs/dlm/dlm_internal.h       |   60 +++-
 fs/dlm/lock.c               |   87 +++-
 fs/dlm/lockspace.c          |   71 +++-
 fs/dlm/member.c             |  486 ++++++++++++++++++----
 fs/dlm/member.h             |   10 +-
 fs/dlm/rcom.c               |   99 ++++-
 fs/dlm/rcom.h               |    2 +-
 fs/dlm/recover.c            |   87 +++-
 fs/dlm/recoverd.c           |   53 ++-
 fs/dlm/user.c               |    5 +-
 fs/gfs2/glock.c             |    2 +-
 fs/gfs2/glock.h             |    7 +-
 fs/gfs2/incore.h            |   58 +++-
 fs/gfs2/lock_dlm.c          |  993 ++++++++++++++++++++++++++++++++++++++++++-
 fs/gfs2/main.c              |   10 +
 fs/gfs2/ops_fstype.c        |   29 +-
 fs/gfs2/recovery.c          |    4 +
 fs/gfs2/sys.c               |   33 +-
 fs/gfs2/sys.h               |    2 +
 fs/ocfs2/stack_user.c       |    4 +-
 include/linux/dlm.h         |   71 +++-
 include/linux/gfs2_ondisk.h |    2 +
 26 files changed, 2039 insertions(+), 312 deletions(-)


commit 68557b104bcf95f2e17aa591409eaecf2a08e55c
Author: David Teigland <teigland@redhat.com>
Date:   Tue Dec 20 17:03:04 2011 -0600

    gfs2: dlm based recovery coordination
    
    This new method of managing recovery is an alternative to
    the previous approach of using the userland gfs_controld.
    
    - use dlm slot numbers to assign journal id's
    - use dlm recovery callbacks to initiate journal recovery
    - use a dlm lock to determine the first node to mount fs
    - use a dlm lock to track journals that need recovery
    
    Signed-off-by: David Teigland <teigland@redhat.com>

commit 60f98d1839376d30e13f3e452dce2433fad3060e
Author: David Teigland <teigland@redhat.com>
Date:   Wed Nov 2 14:30:58 2011 -0500

    dlm: add recovery callbacks
    
    These new callbacks notify the dlm user about lock recovery.
    GFS2, and possibly others, need to be aware of when the dlm
    will be doing lock recovery for a failed lockspace member.
    
    In the past, this coordination has been done between dlm and
    file system daemons in userspace, which then direct their
    kernel counterparts.  These callbacks allow the same
    coordination directly, and more simply.
    
    Signed-off-by: David Teigland <teigland@redhat.com>

commit 757a42719635495779462514458bbfbf12a37dac
Author: David Teigland <teigland@redhat.com>
Date:   Thu Oct 20 13:26:28 2011 -0500

    dlm: add node slots and generation
    
    Slot numbers are assigned to nodes when they join the lockspace.
    The slot number chosen is the minimum unused value starting at 1.
    Once a node is assigned a slot, that slot number will not change
    while the node remains a lockspace member.  If the node leaves
    and rejoins it can be assigned a new slot number.
    
    A new generation number is also added to a lockspace.  It is
    set and incremented during each recovery along with the slot
    collection/assignment.
    
    The slot numbers will be passed to gfs2 which will use them as
    journal id's.
    
    Signed-off-by: David Teigland <teigland@redhat.com>

commit f95a34c66554235b70a681fcd9feebc195f7ec0e
Author: David Teigland <teigland@redhat.com>
Date:   Fri Oct 14 12:34:58 2011 -0500

    dlm: move recovery barrier calls
    
    Put all the calls to recovery barriers in the same function
    to clarify where they each happen.  Should not change any behavior.
    Also modify some recovery debug lines to make them consistent.
    
    Signed-off-by: David Teigland <teigland@redhat.com>

commit 9beb3bf5a92bb8fc6503f844bf0772df29f14a02
Author: Bob Peterson <rpeterso@redhat.com>
Date:   Wed Oct 26 15:24:55 2011 -0500

    dlm: convert rsb list to rb_tree
    
    Change the linked lists to rb_tree's in the rsb
    hash table to speed up searches.  Slow rsb searches
    were having a large impact on gfs2 performance due
    to the large number of dlm locks gfs2 uses.
    
    Signed-off-by: Bob Peterson <rpeterso@redhat.com>
    Signed-off-by: David Teigland <teigland@redhat.com>

