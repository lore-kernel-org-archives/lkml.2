Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753198Ab1HAP4G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 11:56:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30160 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753089Ab1HAPz6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 11:55:58 -0400
Date: Mon, 1 Aug 2011 11:55:23 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>
Cc: Dave Chinner <david@fromorbit.com>, Moyer Jeff Moyer <jmoyer@redhat.com>,
        Shaohua Li <shaohua.li@intel.com>
Subject: [PATCH] cfq-iosched: Add some more documentation about idling
Message-ID: <20110801155523.GE3805@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are always questions about why CFQ is idling on various conditions.
Recent ones is Christoph asking again why to idle on REQ_NOIDLE. His
assertion is that XFS is relying more and more on workqueues and is
concerned that CFQ idling on IO from every workqueue will impact
XFS badly.

So he suggested that I add some more documentation about CFQ idling
and that can provide more clarity on the topic and also gives an
opprotunity to poke a hole in theory and lead to improvements.

So here is my attempt at that. Any comments are welcome.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 Documentation/block/cfq-iosched.txt |   70 +++++++++++++++++++++++++++++++++++
 1 files changed, 70 insertions(+), 0 deletions(-)

diff --git a/Documentation/block/cfq-iosched.txt b/Documentation/block/cfq-iosched.txt
index e578fee..7ce81b8 100644
--- a/Documentation/block/cfq-iosched.txt
+++ b/Documentation/block/cfq-iosched.txt
@@ -43,3 +43,73 @@ If one sets slice_idle=0 and if storage supports NCQ, CFQ internally switches
 to IOPS mode and starts providing fairness in terms of number of requests
 dispatched. Note that this mode switching takes effect only for group
 scheduling. For non-cgroup users nothing should change.
+
+CFQ IO scheduler Idling Theory
+==============================
+Idling on a queue is primarily about waiting for next request to come on
+same queue after completion of a request. In this process CFQ will not
+dispatch requests from other cfq queues even if requests are pending
+there.
+
+The rationale behind idling is that it can cut down on number of seeks
+on rotational media. For example, if a process is doing dependent
+sequential reads (next read will come on only after completion of previous
+one), then not dispatching request from other queue sould help as we
+did not move the disk head and kept on dispatching sequential IO from
+one queue.
+
+CFQ does not do idling on all the queues. It primarily tries to do idling
+on queues which are doing synchronous sequential IO. The synchronous
+queues which are not doing sequential IO are put on a separate service
+tree (called sync-noidle tree) where we do not idle on individual
+cfq queue, but idle on the whole tree or IOW, idle on a group of cfq
+queues.
+
+CFQ has following tree service trees and various queues are put on these
+trees.
+
+	sync-idle	sync-noidle	async 
+
+All cfq queues doing synchronous sequential IO go on to sync-idle tree.
+On this tree we idle on each queue individually.
+
+All synchronous non-sequential queues go on sync-noidle tree. Also any
+request which are marked with REQ_NOIDLE go on this service tree.
+
+All async writes go on async service tree. There is no idling on async
+queues.
+
+FAQ
+===
+Q1. Why to idle at all on queues marked with REQ_NOIDLE.
+
+A1. We only do group idle on queues marked with REQ_NOIDLE. This helps in
+    providing isolation with all the sync-idle queues. Otherwise in presence
+    of many sequential readers, other synchronous IO might not get fair
+    share of disk.
+
+    For example, if there are 10 sequential readers doing IO and they get
+    100ms each. If a REQ_NOIDLE request comes in, it will be scheduled
+    roughly after 1 second. If after completion of REQ_NOIDLE request we
+    do not idle, and after a couple of mili seconds a another REQ_NOIDLE
+    request comes in, again it will be scheduled after 1second. Repeat it
+    and notice how a workload can lose its disk share and suffer due to
+    multiple sequnetial readers.
+
+    fsync can generate dependent IO where bunch of data is written in the
+    context of fsync, and later some journaling data is written. Journaling
+    data comes in only after fsync has finished its IO (atleast for ext4
+    that seemed to be the case). Now if one decides not to idle on fsync
+    thread due to REQ_NOIDLE, then next journaling write will not get
+    scheduled for another second. A process doing small fsync, will suffer
+    badly in presence of multiple sequntial readers.
+
+    Hence doing group idling on threads using REQ_NOIDLE flag on requests
+    provides isolation from multiple sequntial readers and at the same
+    time we do not idle on individual threads. 
+
+Q2. When to specify REQ_NOIDLE
+A2. I would think whenever one is doing synchronous write and not expecting
+    more writes to be dispatched from same context soon, should be able
+    to specify REQ_NOIDLE on writes and that probably should work well for
+    most of the cases. 
-- 
1.7.4.4

