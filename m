Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754550Ab1E1Pmc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 May 2011 11:42:32 -0400
Received: from hera.kernel.org ([140.211.167.34]:50328 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753535Ab1E1Pma (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 May 2011 11:42:30 -0400
Date: Sat, 28 May 2011 15:42:13 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Message-ID: <tip-2euus3f3x3dyvdk52cjxw8zu@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, stable@kernel.org, tglx@linutronix.de,
        vweaver1@eecs.utk.edu, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, stable@kernel.org, tglx@linutronix.de,
        vweaver1@eecs.utk.edu, mingo@elte.hu
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf: Fix SIGIO handling
Git-Commit-ID: f506b3dc0ec454a16d40cab9ee5d75435b39dc50
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 28 May 2011 15:42:15 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f506b3dc0ec454a16d40cab9ee5d75435b39dc50
Gitweb:     http://git.kernel.org/tip/f506b3dc0ec454a16d40cab9ee5d75435b39dc50
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Thu, 26 May 2011 17:02:53 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 28 May 2011 17:04:59 +0200

perf: Fix SIGIO handling

Vince noticed that unless we mmap() a buffer, SIGIO gets lost. So
explicitly push the wakeup (including signals) when requested.

Reported-by: Vince Weaver <vweaver1@eecs.utk.edu>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: <stable@kernel.org>
Link: http://lkml.kernel.org/n/tip-2euus3f3x3dyvdk52cjxw8zu@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/events/core.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index c09767f..d863b3c 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -5028,6 +5028,14 @@ static int __perf_event_overflow(struct perf_event *event, int nmi,
 	else
 		perf_event_output(event, nmi, data, regs);
 
+	if (event->fasync && event->pending_kill) {
+		if (nmi) {
+			event->pending_wakeup = 1;
+			irq_work_queue(&event->pending);
+		} else
+			perf_event_wakeup(event);
+	}
+
 	return ret;
 }
 
