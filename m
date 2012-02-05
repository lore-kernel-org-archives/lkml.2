Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754757Ab2BEW1E (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Feb 2012 17:27:04 -0500
Received: from 1wt.eu ([62.212.114.60]:62067 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754433Ab2BEW0w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Feb 2012 17:26:52 -0500
Message-Id: <20120205220952.741215868@pcw.home.local>
User-Agent: quilt/0.48-1
Date: Sun, 05 Feb 2012 23:11:06 +0100
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: James Bottomley <James.Bottomley@suse.de>,
        Jens Axboe <jaxboe@fusionio.com>, Greg KH <gregkh@linuxfoundation.org>
Subject: [PATCH 77/91] block: add proper state guards to __elv_next_request
In-Reply-To: <0635750f5f06ed2ca212b91fcb5c4483@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-longterm review patch.  If anyone has any objections, please let us know.

------------------

commit 0a58e077eb600d1efd7e54ad9926a75a39d7f8ae upstream.

blk_cleanup_queue() calls elevator_exit() and after this, we can't
touch the elevator without oopsing.  __elv_next_request() must check
for this state because in the refcounted queue model, we can still
call it after blk_cleanup_queue() has been called.

This was reported as causing an oops attributable to scsi.

[WT: in 2.6.27, __elv_next_request() is in elevator.c]

Signed-off-by: James Bottomley <James.Bottomley@suse.de>
Signed-off-by: Jens Axboe <jaxboe@fusionio.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 block/clk.h |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

Index: longterm-2.6.27/block/elevator.c
===================================================================
--- longterm-2.6.27.orig/block/elevator.c	2012-02-05 22:34:32.624915301 +0100
+++ longterm-2.6.27/block/elevator.c	2012-02-05 22:34:45.849915230 +0100
@@ -729,7 +729,8 @@
 				return rq;
 		}
 
-		if (!q->elevator->ops->elevator_dispatch_fn(q, 0))
+		if (test_bit(QUEUE_FLAG_DEAD, &q->queue_flags) ||
+		    !q->elevator->ops->elevator_dispatch_fn(q, 0))
 			return NULL;
 	}
 }


