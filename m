Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934995Ab2DLX3s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 19:29:48 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:33833 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934972Ab2DLX3q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 19:29:46 -0400
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk
Cc: vgoyal@redhat.com, ctalbott@google.com, rni@google.com,
        linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        containers@lists.linux-foundation.org
Subject: [PATCHSET] block: per-queue policy activation
Date: Thu, 12 Apr 2012 16:29:32 -0700
Message-Id: <1334273380-30233-1-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

It seems that we're *finally* nearing the end of the long blkcg API
cleanup.  With all the previous updates, blkcg code is now clean &
modular enough to implement per-queue policy activation.

Upto now, blkcg assumed that all policies are active on all queues
which simply isn't true - cfq policy is only applicable to queues
which are using cfq as the elevator.  Also, for transition purposes,
the current implementation clears all !root blkgs blkgs across
elevator switch and policy [de]registration in racy manner.

This patchset implements per-queue policy activation.  Static policy
ID is replaced with dynamic registration and each policy should be
activated and deactivated explicitly on each queue.  On activation,
the matching policy data are created on all existing blkgs.  On
deactivation, the matching policy data are removed from all existing
blkgs.  blkg printing skips blkg-policy combination which is disabled
and trying to configure a policy on a blkg which doesn't have the
policy enabled would return -EINVAL instead of creating an unused
dummy configuration.

 0001-blkcg-kill-blkio_list-and-replace-blkio_list_lock-wi.patch
 0002-blkcg-use-pol-instead-of-plid-in-update_root_blkg_pd.patch
 0003-blkcg-remove-static-policy-ID-enums.patch
 0004-blkcg-make-blkg_conf_prep-take-pol-and-return-with-q.patch
 0005-blkcg-make-sure-blkg_lookup-returns-NULL-if-q-is-byp.patch
 0006-blkcg-add-request_queue-root_blkg.patch
 0007-blkcg-implement-per-queue-policy-activation.patch
 0008-blkcg-drop-stuff-unused-after-per-queue-policy-activ.patch

0001-0003 removes static policy IDs.

0004-0006 are prep patches.

0007 implements per-queue policy activation.

0008 drops unnecessary stuff.

This patchset is on top of the current block/for-3.5/core 5bc4afb1ec
"blkcg: drop BLKCG_STAT_{PRIV|POL|OFF} macros" and also available in
the following git branch.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git blkcg-pols

diffstat follows.

 block/blk-cgroup.c     |  424 ++++++++++++++++++++++++++++++-------------------
 block/blk-cgroup.h     |   43 ++--
 block/blk-core.c       |    4 
 block/blk-throttle.c   |   78 +++------
 block/cfq-iosched.c    |   71 ++++----
 block/elevator.c       |    2 
 include/linux/blkdev.h |   10 +
 7 files changed, 367 insertions(+), 265 deletions(-)

Thanks.

--
tejun
