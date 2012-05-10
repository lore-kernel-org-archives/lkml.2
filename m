Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759464Ab2EJMZz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 08:25:55 -0400
Received: from zimbra.linbit.com ([212.69.161.123]:43898 "EHLO
	zimbra.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755267Ab2EJMZx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 08:25:53 -0400
X-Greylist: delayed 409 seconds by postgrey-1.27 at vger.kernel.org; Thu, 10 May 2012 08:25:53 EDT
From: Philipp Reisner <philipp.reisner@linbit.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org, drbd-dev@lists.linbit.com
Subject: [GIT PULL] drbd-8.3 updates
Date: Thu, 10 May 2012 14:19:02 +0200
Message-ID: <4277851.LeAnKnANCB@fat-tyre>
Organization: LINBIT
User-Agent: KMail/4.7.3 (Linux/3.0.0-16-generic; KDE/4.7.4; i686; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jens,

This are the updates we have in the drbd-8.3 tree. They are intended
for your "for-3.5/drivers" drivers branch.

These changes include one new feature:
 * Allow detach from frozen backing devices with the new --force option;
   configurable timeout for backing devices by the new disk-timeout option

And huge number of bug fixes:
 * Fixed a write ordering problem on SyncTarget nodes for a write
   to a block that gets resynced at the same time. The bug can
   only be triggered with a device that has a firmware that
   actually reorders writes to the same block
 * Fixed a race between disconnect and receive_state, that could cause
   a IO lockup
 * Fixed resend/resubmit for requests with disk or network timeout
 * Make sure that hard state changed do not disturb the connection
   establishing process (I.e. detach due to an IO error). When the
   bug was triggered it caused a retry in the connect process
 * Postpone soft state changes to no disturb the connection
   establishing process (I.e. becoming primary). When the bug
   was triggered it could cause both nodes going into SyncSource state
 * Fixed a refcount leak that could cause failures when trying to
   unload a protocol family modules, that was used by DRBD
 * Dedicated page pool for meta data IOs
 * Deny normal detach (as opposed to --forced) if the user tries
   to detach from the last UpToDate disk in the resource
 * Fixed a possible protocol error that could be caused by
   "unusual" BIOs.
 * Enforce the disk-timeout option also on meta-data IO operations
 * Implemented stable bitmap pages when we do a full write out of
   the bitmap
 * Fixed a rare compatibility issue with DRBD's older than 8.3.7
   when negotiating the bio_size
 * Fixed a rare race condition where an empty resync could stall with
   if pause/unpause events happen in parallel
 * Made the re-establishing of connections quicker, if it got a broken pipe
   once. Previously there was a bug in the code caused it to waste the first
   successful established connection after a broken pipe event.

PS: I am postponing the drbd-8.4 for mainline for one or two kernel
    development cycles more (the ~400 patchets set).

Best regards,
 Philipp

The following changes since commit 0b7877d4eea3f93e3dd941999522bbd8c538cb53:

  Merge tag 'v3.4-rc5' into for-3.5/core (2012-05-01 14:29:55 +0200)

are available in the git repository at:

  git@git.drbd.org:linux-drbd for-jens

Andreas Gruenbacher (1):
      drbd: drbd_nl_resize(): Fix missing put_ldev() on error path

Arne Redlich (1):
      drbd: bm_page_async_io: properly initialize page->private

Cong Wang (1):
      drbd: check MODULE for THIS_MODULE

David Howells (1):
      DRBD: Fix comparison always false warning due to long/long long compare

Lars Ellenberg (31):
      drbd: cosmetic: fix accidental division instead of modulo when pretty printing
      drbd: spelling fix: too small
      drbd: allow ping-timeout of up to 30 seconds
      drbd: downgraded error printk to info
      drbd: change some GFP_KERNEL to GFP_NOIO
      drbd: fix "stalled" empty resync
      drbd: fix harmless race to not trigger an ASSERT
      drbd: fix spurious meta data IO "error"
      drbd: send intermediate state change results to the peer
      drbd: fix potential spinlock deadlock
      drbd: fix race between disconnect and receive_state
      drbd: Fix module refcount leak in drbd_accept()
      drbd: add missing part_round_stats to _drbd_start_io_acct
      drbd: fix potential data corruption and protocol error
      drbd: remove now unused seq_num member from struct drbd_request
      drbd: missing wakeup after drbd_rs_del_all
      drbd: remove some very outdated comments
      drbd: remove unused static helper function
      drbd: don't pretend that barrier_nr == 0 was special
      drbd: make OOS_HANDED_TO_NETWORK its own case
      drbd: fix READ_RETRY_REMOTE_CANCELED to not complete if device is suspended
      drbd: fix WRITE_ACKED_BY_PEER_AND_SIS to not set RQ_NET_DONE
      drbd: move put_ldev from __req_mod() to the endio callback
      drbd: fix resend/resubmit of frozen IO
      drbd: fix race between drbdadm invalidate/verify and finishing resync
      drbd: allow bitmap to change during writeout from resync_finished
      drbd: add page pool to be used for meta data IO
      drbd: use the newly introduced page pool for bitmap IO
      drbd: remove unused define
      drbd: introduce a bio_set to allocate housekeeping bios from
      drbd: grammar fix in log message

Philipp Reisner (30):
      drbd: Lower log priority for an event that is definitely not an error
      drbd: Only print sanitize state's warnings, if the state change happens
      drbd: Improve compatibility with drbd's older than 8.3.7
      drbd: Keep a reference to barrier acked requests
      drbd: Immediately allow completion of IOs, that wait for IO completions on a failed disk
      drbd: moved md_io into mdev
      drbd: Replaced md_io_mutex by an atomic: md_io_in_use
      drbd: Implemented wait_until_done_or_disk_failure()
      drbd: Keep a reference to the bio until the completion handler finished
      drbd: Hold a reference to ldev while doing meta-data IO
      drbd: Added a kref to bm_aio_ctx
      drbd: Bitmap IO functions can now return prematurely if the disk breaks
      drbd: Allow new IOs while the local disk in in FAILED state
      drbd: Force flag for the detach operation
      drbd: Implemented the disk-timeout option
      drbd: Fixed current UUID generation
      drbd: Consider that the no-data-condition could be in connected state
      drbd: detach must not try to abort non-local requests from drbd-8.4
      drbd: Cleanup all epoch objects upon connection loss
      drbd: Bugfix for the connection behavior
      drbd: Derive sync-UUIDs only from the bitmap-uuid if it is non-zero
      drbd: Fixed a race condition between detach and start of resync
      drbd: Fixed an obvious copy-n-paste mistake
      drbd: Do not send state packets while lower than C_CONNECTED cstate
      drbd: Consider the disk-timeout also for meta-data IO operations
      drbd: Fix a potential race that could case data inconsistency
      drbd: Fix a potential write ordering issue on SyncTarget nodes
      drbd: Delay/reject other state changes while establishing a connection
      drbd: Ensure that data_size is not 0 before using data_size-1 as index
      drbd: Restore the request restart logic

 drivers/block/drbd/drbd_actlog.c   |  104 ++++++++---
 drivers/block/drbd/drbd_bitmap.c   |  146 +++++++++++----
 drivers/block/drbd/drbd_int.h      |   90 ++++++----
 drivers/block/drbd/drbd_main.c     |  357 +++++++++++++++++++++++++++---------
 drivers/block/drbd/drbd_nl.c       |   48 ++++-
 drivers/block/drbd/drbd_proc.c     |    2 +-
 drivers/block/drbd/drbd_receiver.c |   95 ++++++++---
 drivers/block/drbd/drbd_req.c      |  132 +++++++++-----
 drivers/block/drbd/drbd_req.h      |   19 ++-
 drivers/block/drbd/drbd_worker.c   |   31 +++-
 include/linux/drbd.h               |    6 +-
 include/linux/drbd_limits.h        |    7 +-
 include/linux/drbd_nl.h            |    5 +-
 13 files changed, 754 insertions(+), 288 deletions(-)

-- 
: Dipl-Ing Philipp Reisner
: LINBIT | Your Way to High Availability
: Tel: +43-1-8178292-50, Fax: +43-1-8178292-82
: http://www.linbit.com

DRBD(R) and LINBIT(R) are registered trademarks of LINBIT, Austria.

