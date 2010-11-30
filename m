Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754310Ab0K3Q4A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 11:56:00 -0500
Received: from mx1.redhat.com ([209.132.183.28]:27370 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751468Ab0K3Qz7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 11:55:59 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: linux-kernel@vger.kernel.org, jaxboe@fusionio.com
Cc: vgoyal@redhat.com, jmoyer@redhat.com, oleg@redhat.com, jmarchan@redhat.com
Subject: [PATCH 1/2] blk-throttle: Trim/adjust slice_end once a bio has been dispatched
Date: Tue, 30 Nov 2010 11:55:56 -0500
Message-Id: <1291136157-2732-2-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1291136157-2732-1-git-send-email-vgoyal@redhat.com>
References: <1291136157-2732-1-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

o During some testing I did following and noticed throttling stops working.

        - Put a very low limit on a cgroup, say 1 byte per second.
        - Start some reads, this will set slice_end to a very high value.
        - Change the limit to higher value say 1MB/s
        - Now IO unthrottles and finishes as expected.
        - Try to do the read again but IO is not limited to 1MB/s as expected.

o What is happening.
        - Initially low value of limit sets slice_end to a very high value.
        - During updation of limit, slice_end is not being truncated.
        - Very high value of slice_end leads to keeping the existing slice
          valid for a very long time and new slice does not start.
        - tg_may_dispatch() is called in blk_throtle_bio(), and trim_slice()
          is not called in this path. So slice_start is some old value and
          practically we are able to do huge amount of IO.

o There are many ways it can be fixed. I have fixed it by trying to
  adjust/cleanup slice_end in trim_slice(). Generally we extend slices if bio
  is big and can't be dispatched in one slice. After dispatch of bio, readjust
  the slice_end to make sure we don't end up with huge values.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 block/blk-throttle.c |   16 ++++++++++++++++
 1 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index 004be80..2d134b7 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -355,6 +355,12 @@ throtl_start_new_slice(struct throtl_data *td, struct throtl_grp *tg, bool rw)
 			tg->slice_end[rw], jiffies);
 }
 
+static inline void throtl_set_slice_end(struct throtl_data *td,
+		struct throtl_grp *tg, bool rw, unsigned long jiffy_end)
+{
+	tg->slice_end[rw] = roundup(jiffy_end, throtl_slice);
+}
+
 static inline void throtl_extend_slice(struct throtl_data *td,
 		struct throtl_grp *tg, bool rw, unsigned long jiffy_end)
 {
@@ -391,6 +397,16 @@ throtl_trim_slice(struct throtl_data *td, struct throtl_grp *tg, bool rw)
 	if (throtl_slice_used(td, tg, rw))
 		return;
 
+	/*
+	 * A bio has been dispatched. Also adjust slice_end. It might happen
+	 * that initially cgroup limit was very low resulting in high
+	 * slice_end, but later limit was bumped up and bio was dispached
+	 * sooner, then we need to reduce slice_end. A high bogus slice_end
+	 * is bad because it does not allow new slice to start.
+	 */
+
+	throtl_set_slice_end(td, tg, rw, jiffies + throtl_slice);
+
 	time_elapsed = jiffies - tg->slice_start[rw];
 
 	nr_slices = time_elapsed / throtl_slice;
-- 
1.7.2.3

