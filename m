Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932253Ab0EYKyu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 06:54:50 -0400
Received: from bld-mail14.adl6.internode.on.net ([150.101.137.99]:36821 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756543Ab0EYKys (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 06:54:48 -0400
From: Dave Chinner <david@fromorbit.com>
To: linux-kernel@vger.kernel.org
Cc: xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
       tytso@mit.edu, jens.axboe@oracle.com
Subject: [PATCH 0/6] writeback: tracing and fixes
Date: Tue, 25 May 2010 20:54:06 +1000
Message-Id: <1274784852-30502-1-git-send-email-david@fromorbit.com>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This series contains the initial writeback tracing patches from
Jens, as well as the extensions I added to provide visibility into
writeback control structures as the are used by the writeback code.
The visibility given is sufficient to understand what is happening
in the writeback path - what path is writing data, what path is
blocking on congestion, etc, and to determine the differences in
behaviour for different sync modes and calling contexts. This
tracing really needs to be integrated into mainline so that anyone
can improve the tracing as they use it to track down problems in our
convoluted writeback paths.

The remaining patches are fixes to problems that the new tracing
highlighted.

Version 2:
- included ext4 write_cache_pages separation patch from Ted Ts'o.
- moved CREATE_TRACE_POINTS into fs-writeback.c as suggested by
  Christoph Hellwig.
- moved include of trace/events/writeback.h until after structure
  definitions in fs-writeback.c
- manually revert changes made to write_cache_pages() in
  17bc6c30cf6bfffd816bdc53682dd46fc34a2cf4 that caused the
  regression.  This restores the convention that if the fs writes
  back more than a single page, it subtracts (nr_written - 1) from
  wbc->nr_to_write, as suggested by Andrew Morton.
- added patch to prevent sync from looping in write_cache_pages
  chasing a moving tail when an appending write workload is running
  concurrently with sync.

