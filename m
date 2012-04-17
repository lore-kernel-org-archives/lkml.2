Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751575Ab2DQS2b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 14:28:31 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:47500 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751026Ab2DQS22 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 14:28:28 -0400
Date: Tue, 17 Apr 2012 19:28:26 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [git pull] vfs and fs fixes
Message-ID: <20120417182825.GX6589@ZenIV.linux.org.uk>
References: <20120417052511.GU6589@ZenIV.linux.org.uk>
 <CA+55aFw75=Mtq1njQ9vNmNsGuTPbpUhLHnb7YBLmCZs4Q5ByMA@mail.gmail.com>
 <20120417180129.GW6589@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120417180129.GW6589@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 17, 2012 at 07:01:29PM +0100, Al Viro wrote:

> It isn't.  Hell knows - I wonder if taking s_vfs_rename_mutex in all cases
> in lock_rename() would be the right thing to do; it would remove the
> problem, but might cost us too much contention...

Actually, it's even worse.  ext4_move_extents() locks a _pair_ of
->i_mutex (having checked that both are non-directories first).  In
i_ino order.  So the only plausible ordering would be
	* directories by tree order (with s_vfs_rename_mutex held to
stabilize the tree topology)
	* non-directories after all directories, ordered in some consistent
way.  Which would have to be by inumber if we want to leave ext4 code
as-is.

Bruce: for now I'm dropping that patch.  We _might_ take ext4
mutex_inode_double_lock() into fs/namei.c and have it used by
vfs_rename_other(), but I'm not convinced that this is the right
thing to do.  Is there any other sane way to deal with nfsd problem?
i_mutex is already used for more things than I'd like...

Linus: I've removed that sucker from the queue; it should propagate to
git.kernel.org in a few.  Could you pull the rest?  Same place, the stats
are below:

Shortlog:
Al Viro (12):
      nfsd: fix b0rken error value for setattr on read-only mount
      nfsd: fix error values returned by nfsd4_lockt() when nfsd_open() fails
      nfsd: fix endianness breakage in TEST_STATEID handling
      nfsd: fix error value on allocation failure in nfsd4_decode_test_stateid()
      nfsd: fix compose_entry_fh() failure exits
      ext4: fix endianness breakage in ext4_split_extent_at()
      btrfs: btrfs_root_readonly() broken on big-endian
      ocfs2: ->l_next_free_req breakage on big-endian
      ocfs: ->rl_used breakage on big-endian
      ocfs2: ->rl_count endianness breakage
      ocfs2: ->e_leaf_clusters endianness breakage
      lockd: fix the endianness bug

Diffstat:
 fs/btrfs/ctree.h        |    2 +-
 fs/ext4/extents.c       |    2 +-
 fs/lockd/clnt4xdr.c     |    2 +-
 fs/lockd/clntxdr.c      |    2 +-
 fs/nfsd/nfs3xdr.c       |   22 ++++++++--------------
 fs/nfsd/nfs4proc.c      |    7 ++++---
 fs/nfsd/nfs4state.c     |   23 +++++++++--------------
 fs/nfsd/nfs4xdr.c       |    4 ++--
 fs/ocfs2/alloc.c        |    2 +-
 fs/ocfs2/refcounttree.c |   12 ++++++------
 fs/ocfs2/suballoc.c     |    4 ++--
 11 files changed, 36 insertions(+), 46 deletions(-)
