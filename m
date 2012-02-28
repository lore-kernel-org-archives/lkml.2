Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757146Ab2B1Nbz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 08:31:55 -0500
Received: from ozlabs.org ([203.10.76.45]:52272 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754129Ab2B1Nby (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 08:31:54 -0500
From: Michael Ellerman <michael@ellerman.id.au>
To: <linux-kernel@vger.kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH] perf: Fix perf_event_for_each() to use sibling
Date: Wed, 29 Feb 2012 00:31:32 +1100
Message-Id: <1330435892-31518-1-git-send-email-michael@ellerman.id.au>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In perf_event_for_each() we call a function on an event, and then
iterate over the siblings of the event.

However we don't call the function on the siblings, we call it
repeatedly on the original event - it seems "obvious" that we should
be calling it with sibling as the argument.

It looks like this broke in commit 75f937f24bd9 ("Fix ctx->mutex
vs counter->mutex inversion").

The only effect of the bug is that the PERF_IOC_FLAG_GROUP parameter
to the ioctls doesn't work.

Signed-off-by: Michael Ellerman <michael@ellerman.id.au>
---

This one seems so simple that I keep thinking I've missed something,
I'm sure someone will tell me if I have ;)

AFAICS tools/perf never exercises this, ie. it always individually
enables counters - which might explain how it could be broken and
no one has noticed.
---
 kernel/events/core.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 1b5c081..b82121b 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -3097,7 +3097,7 @@ static void perf_event_for_each(struct perf_event *event,
 	perf_event_for_each_child(event, func);
 	func(event);
 	list_for_each_entry(sibling, &event->sibling_list, group_entry)
-		perf_event_for_each_child(event, func);
+		perf_event_for_each_child(sibling, func);
 	mutex_unlock(&ctx->mutex);
 }
 
-- 
1.7.5.4

