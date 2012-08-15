Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756231Ab2HOTtG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 15:49:06 -0400
Received: from mail1.windriver.com ([147.11.146.13]:62730 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756211Ab2HOTtC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 15:49:02 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 007/165] perf: overflow/perf_count_sw_cpu_clock crashes recent kernels
Date: Wed, 15 Aug 2012 15:45:51 -0400
Message-ID: <1345060109-9187-8-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.12.rc2
In-Reply-To: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
References: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Zijlstra <a.p.zijlstra@chello.nl>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

The below patch is for -stable only, upstream has a much larger patch
that contains the below hunk in commit a8b0ca17b80e92faab46ee7179ba9e99ccb61233

Vince found that under certain circumstances software event overflows
go wrong and deadlock. Avoid trying to delete a timer from the timer
callback.

Reported-by: Vince Weaver <vweaver1@eecs.utk.edu>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
[PG: backport from 2.6.32 queue, see https://lkml.org/lkml/2011/8/3/125 ]
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 kernel/perf_event.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index b203546..540c26b 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -3907,12 +3907,8 @@ static int __perf_event_overflow(struct perf_event *event, int nmi,
 	if (events && atomic_dec_and_test(&event->event_limit)) {
 		ret = 1;
 		event->pending_kill = POLL_HUP;
-		if (nmi) {
-			event->pending_disable = 1;
-			perf_pending_queue(&event->pending,
-					   perf_pending_event);
-		} else
-			perf_event_disable(event);
+		event->pending_disable = 1;
+		perf_pending_queue(&event->pending, perf_pending_event);
 	}
 
 	if (event->overflow_handler)
-- 
1.7.12.rc2

