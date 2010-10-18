Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932911Ab0JRTUA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 15:20:00 -0400
Received: from hera.kernel.org ([140.211.167.34]:59438 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932134Ab0JRTT7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 15:19:59 -0400
Date: Mon, 18 Oct 2010 19:19:31 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, matt@console-pimps.org, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, matt@console-pimps.org, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <1287135757.29097.1368.camel@twins>
References: <1287135757.29097.1368.camel@twins>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf: Fix group moving
Message-ID: <tip-74c3337c2fc6389d3a57a622a936036b6db6b2e8@git.kernel.org>
Git-Commit-ID: 74c3337c2fc6389d3a57a622a936036b6db6b2e8
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 18 Oct 2010 19:19:33 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  74c3337c2fc6389d3a57a622a936036b6db6b2e8
Gitweb:     http://git.kernel.org/tip/74c3337c2fc6389d3a57a622a936036b6db6b2e8
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Fri, 15 Oct 2010 11:40:29 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 18 Oct 2010 19:58:51 +0200

perf: Fix group moving

Matt found we trigger the WARN_ON_ONCE() in perf_group_attach() when we take
the move_group path in perf_event_open().

Since we cannot de-construct the group (we rely on it to move the events), we
have to simply ignore the double attach. The group state is context invariant
and doesn't need changing.

Reported-by: Matt Fleming <matt@console-pimps.org>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1287135757.29097.1368.camel@twins>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/perf_event.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 99b9700..346dc0e 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -315,7 +315,12 @@ static void perf_group_attach(struct perf_event *event)
 {
 	struct perf_event *group_leader = event->group_leader;
 
-	WARN_ON_ONCE(event->attach_state & PERF_ATTACH_GROUP);
+	/*
+	 * We can have double attach due to group movement in perf_event_open.
+	 */
+	if (event->attach_state & PERF_ATTACH_GROUP)
+		return;
+
 	event->attach_state |= PERF_ATTACH_GROUP;
 
 	if (group_leader == event)
