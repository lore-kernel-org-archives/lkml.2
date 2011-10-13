Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755602Ab1JMPeR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 11:34:17 -0400
Received: from relay3.sgi.com ([192.48.152.1]:57002 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751140Ab1JMPeQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 11:34:16 -0400
From: Alex Elder <aelder@sgi.com>
Message-Id: <201110131534.p9DFYAgh032034@stout.americas.sgi.com>
Date: Thu, 13 Oct 2011 10:34:10 -0500
To: torvalds@linux-foundation.org
Subject: [GIT PULL] XFS update for 3.1
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com, akpm@linux-foundation.org
User-Agent: Heirloom mailx 12.5 7/5/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull the following XFS changes for Linux 3.1.

In trying to track down the source of an XFS hang related to active
item pushing Christoph Hellwig identified three contributing
problems, addressed in the commits below.
- The first was that a "last pushed log sequence number" value was
  being updated when it should not have been.
- The second is that it is possible for a buffer containing inodes
  to be found pinned at the time it gets pushed, and that could
  cause pushing to stall.
- The third is related to the switch to using a workqueue for AIL
  pushing, which made it possible for pushing to get starved behind
  syncing activity.  At this late point in the cycle, the best
  course of action was to revert to using a kernel thread as was
  done previously.
The last change is simply adding tracepoints; feel free to exclude
it if you see fit.

These changes have not been through a linux-next build; portions of
them are incompatible with the XFS code that's being included there.
I have done builds and repeated tests with them however and expect
no problems.

Thank you.

					-Alex

The following changes since commit 65112dccf8a113737684366349d7f9ec373ddc47:

  Merge git://git.samba.org/sfrench/cifs-2.6 (2011-10-10 14:53:11 +1200)

are available in the git repository at:

  git://oss.sgi.com/xfs/xfs for-linus

Christoph Hellwig (4):
      xfs: do not update xa_last_pushed_lsn for locked items
      xfs: force the log if we encounter pinned buffers in .iop_pushbuf
      xfs: revert to using a kthread for AIL pushing
      xfs: add AIL pushing tracepoints

 fs/xfs/xfs_buf_item.c   |    3 +-
 fs/xfs/xfs_dquot_item.c |   10 ++++--
 fs/xfs/xfs_inode_item.c |   10 ++++--
 fs/xfs/xfs_linux.h      |    2 +
 fs/xfs/xfs_super.c      |   13 +------
 fs/xfs/xfs_trace.h      |   37 +++++++++++++++++++
 fs/xfs/xfs_trans.h      |    2 +-
 fs/xfs/xfs_trans_ail.c  |   91 +++++++++++++++++++++++++++++------------------
 fs/xfs/xfs_trans_priv.h |    8 +----
 9 files changed, 114 insertions(+), 62 deletions(-)
