Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751806Ab1EJSst (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 14:48:49 -0400
Received: from relay2.sgi.com ([192.48.179.30]:50169 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750865Ab1EJSss (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 14:48:48 -0400
From: Alex Elder <aelder@sgi.com>
Message-Id: <201105101848.p4AImgJF021856@stout.americas.sgi.com>
Date: Tue, 10 May 2011 13:48:41 -0500
To: torvalds@linux-foundation.org
Subject: [GIT PULL] XFS update for 2.6.39
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com, akpm@linux-foundation.org
User-Agent: Heirloom mailx 12.5 7/5/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

I'm very sorry I couldn't provide you these regression fixes before
yesterday.  They do address regressions that are pretty important
so I hope you'll consider pulling them for inclusion in 2.6.39.

The first one fixes a problem that can cause reclaim to stall on an
XFS allocation group, which prevents inode cache shrinking from
making progress and ultimately can cause the OOM killer to kick in.

The other four address small but distinct problems that can lead to
filesystem hangs when attempting to grant log space:
- The only real change in the first of these is the "goto out_done"
  that causes a block of common code to be used for a case that was
  not clearing a flag as it should.
- The second of these fixes an off-by-one condition check problem.
- The third addresses a few problems that can arise due to unsafe
  assignment of 64-bit values on 32-bit architectures.
- The last one is the most subtle.  Previously a flag bit was
  getting cleared conditionally but not atomically.  A second
  location used test_and_set_bit() to conditionally set the flag.
  The flag could get cleared in the one spot just after a successful
  test and set in another; the net result basically hung the
  affected filesystem.  The fix modifies the non-atomic spot to
  clear the flag unconditionally, then re-set it using atomic
  test-and-set it if appropriate.

Dave Chinner deserves a lot of credit for sorting through
these--especially the intersecting causes of the common "filesystem
hang" symptom that the last four address.

Thanks a lot.

					-Alex

The following changes since commit 693d92a1bbc9e42681c42ed190bd42b636ca876f:

  Linux 2.6.39-rc7 (2011-05-09 19:33:54 -0700)

are available in the git repository at:
  git://oss.sgi.com/xfs/xfs for-linus

Dave Chinner (5):
      xfs: ensure reclaim cursor is reset correctly at end of AG
      xfs: exit AIL push work correctly when AIL is empty
      xfs: always push the AIL to the target
      xfs: make AIL target updates and compares 32bit safe.
      xfs: fix race condition in AIL push trigger

 fs/xfs/linux-2.6/xfs_sync.c |    1 +
 fs/xfs/xfs_trans_ail.c      |   47 +++++++++++++++++++++++-------------------
 2 files changed, 27 insertions(+), 21 deletions(-)
