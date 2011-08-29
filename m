Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752544Ab1H2Dtw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Aug 2011 23:49:52 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:35432 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752194Ab1H2Dtq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Aug 2011 23:49:46 -0400
From: Namhyung Kim <namhyung@gmail.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/6] blktrace: bio-based device tracing improvement
Date: Mon, 29 Aug 2011 12:47:34 +0900
Message-Id: <1314589660-2918-1-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

The blktrace is used to report block device activities to user space
using kernel tracepoint but it was focused to block I/O request struct.
Thus bio-based devices (i.e. loop, ram, md, ...) which don't make use
of the request structure could not be supported well - the tool only
can detect a limited number of events such as queuing, cloning and
remapping but it cannot know when the I/O activity is completed.

bio_endio(), the I/O completion callback, can be used to fix this
problem by adding appropriate tracepoint in it. However it was called
from other paths too (normal request-based block devices and some of
nested block I/O handling routines) so that we should split such cases
to remove duplicated reports. In this series, __bio_endio() (and its
helper __bio_io_error) was introduced and converted for that purpose.

Note that (bio-based) dm already supported completion report by adding
the tracepoint into the path manually. With this patches, it will be
converted to use generic mechanism.

This patch set is based on v3.1-rc3.
Patch 1 is to correct remapping information and independent to others.
Patch 2 is the core of this series and Patch 3-5 are mechanical converts.
Patch 6 removes manual use of the tracepoint in dm.

Any feedbacks are welcome.

Thanks.


Namhyung Kim (6):
  block: move trace_block_bio_remap() before blk_partition_remap
  block: introduce __bio_endio()
  bounce: convert to __bio_endio() for bounced bio's
  bio-integrity: convert to __bio_endio()
  Btrfs: convert to __bio_endio()
  dm: get rid of block_bio_complete tracepoint

 block/blk-core.c       |   11 +++++------
 drivers/md/dm.c        |    1 -
 fs/bio-integrity.c     |    4 ++--
 fs/bio.c               |   19 +++++++++++++++++++
 fs/btrfs/compression.c |    4 ++--
 fs/btrfs/disk-io.c     |    2 +-
 fs/btrfs/inode.c       |    8 ++++----
 fs/btrfs/volumes.c     |    4 ++--
 include/linux/bio.h    |    2 ++
 mm/bounce.c            |    2 +-
 10 files changed, 38 insertions(+), 19 deletions(-)

-- 
1.7.6

