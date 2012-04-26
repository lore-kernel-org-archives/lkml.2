Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756046Ab2DZMQn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 08:16:43 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52704 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752598Ab2DZMQl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 08:16:41 -0400
Date: Thu, 26 Apr 2012 05:16:23 -0700
From: tip-bot for Michael Ellerman <michael@ellerman.id.au>
Message-ID: <tip-724b6daa13e100067c30cfc4d1ad06629609dc4e@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, michael@ellerman.id.au, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, michael@ellerman.id.au, tglx@linutronix.de
In-Reply-To: <1334109253-31329-1-git-send-email-michael@ellerman.id.au>
References: <1334109253-31329-1-git-send-email-michael@ellerman.id.au>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf: Fix perf_event_for_each() to use sibling
Git-Commit-ID: 724b6daa13e100067c30cfc4d1ad06629609dc4e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 26 Apr 2012 05:16:30 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  724b6daa13e100067c30cfc4d1ad06629609dc4e
Gitweb:     http://git.kernel.org/tip/724b6daa13e100067c30cfc4d1ad06629609dc4e
Author:     Michael Ellerman <michael@ellerman.id.au>
AuthorDate: Wed, 11 Apr 2012 11:54:13 +1000
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 26 Apr 2012 13:51:31 +0200

perf: Fix perf_event_for_each() to use sibling

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
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1334109253-31329-1-git-send-email-michael@ellerman.id.au
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/events/core.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index a6a9ec4..fd126f8 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -3183,7 +3183,7 @@ static void perf_event_for_each(struct perf_event *event,
 	perf_event_for_each_child(event, func);
 	func(event);
 	list_for_each_entry(sibling, &event->sibling_list, group_entry)
-		perf_event_for_each_child(event, func);
+		perf_event_for_each_child(sibling, func);
 	mutex_unlock(&ctx->mutex);
 }
 
