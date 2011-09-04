Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753823Ab1IDNQ3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Sep 2011 09:16:29 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:56529 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753252Ab1IDNQV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Sep 2011 09:16:21 -0400
From: Namhyung Kim <namhyung@gmail.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/3] blktrace: bio-based device tracing improvement
Date: Sun,  4 Sep 2011 22:15:09 +0900
Message-Id: <1315142112-2430-1-git-send-email-namhyung@gmail.com>
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
nested block I/O handling routines) so that we should recognize such
cases to prevent duplicated reports. In this series, BIO_IN_FLIGHT flag
is introduced and used for that purpose.

Note that (bio-based) dm already supported completion report by adding
the tracepoint into the path manually. With this patches, it will be
converted to use generic mechanism.

Changes from v1:
 * kill __bio_endio()
 * use BIO_IN_FLIGHT flag

Any feedbacks are welcome.

Thanks.

Namhyung Kim (3):
  block: move trace_block_bio_remap() before blk_partition_remap
  block: introduce BIO_IN_FLIGHT flag
  block: don't export block_bio_complete tracepoint

 block/blk-core.c          |   12 ++++++++----
 drivers/md/dm.c           |    1 -
 fs/bio.c                  |    9 +++++++++
 include/linux/blk_types.h |    1 +
 4 files changed, 18 insertions(+), 5 deletions(-)

-- 
1.7.6

