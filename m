Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933867Ab0GORUt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 13:20:49 -0400
Received: from straum.hexapodia.org ([207.7.131.186]:44410 "EHLO
	straum.hexapodia.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758625Ab0GORUs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 13:20:48 -0400
Date: Thu, 15 Jul 2010 10:20:48 -0700
From: Andy Isaacson <adi@hexapodia.org>
To: linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Jens Axboe <jens.axboe@oracle.com>,
        Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH 2/2] blktrace: unlink blk directory on final trace close
Message-ID: <20100715172048.GC12953@hexapodia.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100715171937.GA12953@hexapodia.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

blktrace fails to completely clean up after itself if BLKTRACESTOP is
called before the final trace file is closed:

% blktrace /dev/sdb &
% exec 6</sys/kernel/debug/block/sdb/trace0
% kill %1
% find /sys/kernel/debug/block/
/sys/kernel/debug/block/
/sys/kernel/debug/block/sdb
/sys/kernel/debug/block/sdb/trace0
% exec 6<&-
% find /sys/kernel/debug/block/
/sys/kernel/debug/block/
/sys/kernel/debug/block/sdb

The proper fix is to move cleanup from BLKTRACESTOP to the close
routine, but that's nontrivial, so here's a simple fix to remove
debug/block/<dev> when the last trace%d file is closed.

Cc: stable@kernel.org
Signed-off-by: Andy Isaacson <adi@hexapodia.org>
---
 kernel/trace/blktrace.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/kernel/trace/blktrace.c b/kernel/trace/blktrace.c
index 347fe8e..9b78930 100644
--- a/kernel/trace/blktrace.c
+++ b/kernel/trace/blktrace.c
@@ -383,8 +383,12 @@ static int blk_subbuf_start_callback(struct rchan_buf *buf, void *subbuf,
 
 static int blk_remove_buf_file_callback(struct dentry *dentry)
 {
+	struct dentry *parent = dentry->d_parent;
 	debugfs_remove(dentry);
 
+	if (simple_empty(parent))
+		debugfs_remove(parent);
+
 	return 0;
 }
 
-- 
1.7.1
