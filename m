Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754457Ab1L0O2t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Dec 2011 09:28:49 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:39890 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754391Ab1L0O2o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Dec 2011 09:28:44 -0500
From: Namhyung Kim <namhyung@gmail.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH -block/for-next 0/2] blktrace: bio-based device tracing improvement v3
Date: Tue, 27 Dec 2011 23:28:31 +0900
Message-Id: <1324996113-1837-1-git-send-email-namhyung@gmail.com>
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

Changes from v2:
 * rebased on current block/for-next

Changes from v1:
 * kill __bio_endio()
 * use BIO_IN_FLIGHT flag

Any feedbacks are welcome.

Thanks.


Namhyung Kim (2):
  block: introduce BIO_IN_FLIGHT flag
  block: don't export block_bio_complete tracepoint

 block/blk-core.c          |    6 +++++-
 drivers/md/dm.c           |    1 -
 fs/bio.c                  |    7 +++++++
 include/linux/blk_types.h |    1 +
 4 files changed, 13 insertions(+), 2 deletions(-)

--
1.7.6

