Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752795Ab2KILgo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 06:36:44 -0500
Received: from zimbra.linbit.com ([212.69.161.123]:46831 "EHLO
	zimbra.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751413Ab2KILgm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 06:36:42 -0500
From: Philipp Reisner <philipp.reisner@linbit.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com, linux-kernel@vger.kernel.org
Subject: [GIT PULL] drbd-8.4.2 for the linux-3.8 merge window
Date: Fri, 09 Nov 2012 12:36:39 +0100
Message-ID: <3042269.jrNem7z1LI@fat-tyre>
User-Agent: KMail/4.8.5 (Linux/3.2.0-32-generic; KDE/4.8.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jens,

Please pull drbd-8.4.2 into your for-3.8/drivers branch.

The most noticeable change is the support for multiple replicated
volumes in a single DRBD connection.

This release requires new drbd userland tools >= 8.4.0 (available
since July 2011).
8.4.x is network protocol compatible with all previous releaes.
This release brings a new meta-data format. Forward (8.3 -> 8.4)
conversion happens complete seamless. Backward conversion
is done by a single command (drbdadm apply-al res).

The "recent changes" chapter of our user's guide describes all
changes in detail:
http://www.drbd.org/users-guide/ap-recent-changes.html

Changelog

8.4.2 (api:genl1/proto:86-100)
--------
 * Go into inconsistent disk state with on-io-error=pass-on policy
 * Timeouts for requests processing on the peer (previously that
   worked only if the data socket was congested)
 * Conflicting write detection is now based on an interval tree,
   removed the hash-tables (necessary for the unlimited BIO sizes)
 * Support for multiple volumes (minors, block devices) per connection;
   up to 65536 volumes per connection supported
 * Reduced IO latencies during some state changes (esp. start resync)
 * New on disk format for the AL: double capacity; 4k aligned IO; same space
 * Multiple AL changes in a single transaction (precondition for
   unlimited BIO sizes)
 * DRBD no longer imposes any limit on BIO sizes
 * Removed DRBD's limits on the number of minor devices
 * DRBD's minors can now be removed (not only unconfigured)
 * Switched the user space interface form connector to generic netlink
 * The wire-protocol is now a regular connection option, which can be
   changed while the device is online
 * IO freezing/thawing is done on connection (all volumes) level
 * fencing is done on connection (all volumes) level
 * Enforce application of activity log after primary crash in user space
 * New default values (compared to drbd-8.3) for: minor-count, ko-count, al-extents,
   c-plan-ahead, c-fill-target, c-min-rate, use-rle, on-io-error
 * Optional load balancing for read requests: new keyword "read-balance"
 * New option 'al-updates no' to disable writing transactions into the
   activity log. It is use full if you prefer a full sync after a primary
   crash, for improved performance of a spread out random write work load
 * Expose the data generation identifies via sysfs


Jens, regarding the code:

It has the sysfs bits in again. The reason for that is that we want to
expose more information by that, and remove the /proc/drbd with the
next evolutionary step. -- In case this is a show stopper, let me
remove the sysfs bits.


Here is the git-pull-request test: 
(The patch subjects removed to make the mail more digestible)

The following changes since commit ccae7868b0c5697508a541c531cf96b361d62c1c:

  drbd: log request sector offset and size for IO errors (2012-10-30 08:39:18 +0100)

are available in the git repository at:

  git://git.drbd.org/linux-drbd.git for-jens_drbd-8.4.2

for you to fetch changes up to e877f7fdc0b1052b0e881e61f9290268eb21aa2f:

  drbd: use copy_highpage (2012-11-09 12:06:44 +0100)

----------------------------------------------------------------
Akinobu Mita (1):
      drbd: use copy_highpage

Andreas Gruenbacher (210):
      drbd: Get rid of req_validator_fn typedef
	[...]

David Howells (1):
      DRBD: Fix comparison always false warning due to long/long long compare

Jing Wang (1):
      drbd: check return of kmalloc in receive_uuids

Lars Ellenberg (138):
      drbd: simplify condition in drbd_may_do_local_read()
	[...]

Philipp Marek (1):
      drbd: pass some more information to userspace.

Philipp Reisner (234):
      idr: idr_for_each_entry() macro
	[...]

 drivers/block/drbd/Makefile        |    2 +
 drivers/block/drbd/drbd_actlog.c   |  689 +++----
 drivers/block/drbd/drbd_bitmap.c   |  227 ++-
 drivers/block/drbd/drbd_int.h      | 1399 ++++++-------
 drivers/block/drbd/drbd_interval.c |  207 ++
 drivers/block/drbd/drbd_interval.h |   40 +
 drivers/block/drbd/drbd_main.c     | 3918 ++++++++++++++----------------------
 drivers/block/drbd/drbd_nl.c       | 3391 ++++++++++++++++++-------------
 drivers/block/drbd/drbd_nla.c      |   55 +
 drivers/block/drbd/drbd_nla.h      |    8 +
 drivers/block/drbd/drbd_proc.c     |   33 +-
 drivers/block/drbd/drbd_receiver.c | 3883 ++++++++++++++++++++---------------
 drivers/block/drbd/drbd_req.c      | 1569 +++++++--------
 drivers/block/drbd/drbd_req.h      |  187 +-
 drivers/block/drbd/drbd_state.c    | 1857 +++++++++++++++++
 drivers/block/drbd/drbd_state.h    |  161 ++
 drivers/block/drbd/drbd_strings.c  |    1 +
 drivers/block/drbd/drbd_sysfs.c    |   86 +
 drivers/block/drbd/drbd_worker.c   | 1168 ++++++-----
 drivers/block/drbd/drbd_wrappers.h |   11 +-
 include/linux/drbd.h               |   81 +-
 include/linux/drbd_genl.h          |  378 ++++
 include/linux/drbd_genl_api.h      |   55 +
 include/linux/drbd_limits.h        |   90 +-
 include/linux/drbd_nl.h            |  164 --
 include/linux/drbd_tag_magic.h     |   84 -
 include/linux/genl_magic_func.h    |  422 ++++
 include/linux/genl_magic_struct.h  |  277 +++
 include/linux/idr.h                |   11 +
 include/linux/lru_cache.h          |   67 +-
 lib/lru_cache.c                    |  359 ++--
 31 files changed, 12238 insertions(+), 8642 deletions(-)
 create mode 100644 drivers/block/drbd/drbd_interval.c
 create mode 100644 drivers/block/drbd/drbd_interval.h
 create mode 100644 drivers/block/drbd/drbd_nla.c
 create mode 100644 drivers/block/drbd/drbd_nla.h
 create mode 100644 drivers/block/drbd/drbd_state.c
 create mode 100644 drivers/block/drbd/drbd_state.h
 create mode 100644 drivers/block/drbd/drbd_sysfs.c
 create mode 100644 include/linux/drbd_genl.h
 create mode 100644 include/linux/drbd_genl_api.h
 delete mode 100644 include/linux/drbd_nl.h
 delete mode 100644 include/linux/drbd_tag_magic.h
 create mode 100644 include/linux/genl_magic_func.h
 create mode 100644 include/linux/genl_magic_struct.h

Best regards,
 Philipp
