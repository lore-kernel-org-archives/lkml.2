Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753665Ab0EHQLG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 May 2010 12:11:06 -0400
Received: from hera.kernel.org ([140.211.167.34]:57782 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752952Ab0EHQLC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 May 2010 12:11:02 -0400
Date: Sat, 8 May 2010 16:10:36 GMT
From: tip-bot for Cyrill Gorcunov <gorcunov@openvz.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       gorcunov@openvz.org, peterz@infradead.org, fweisbec@gmail.com,
       ming.m.lin@intel.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, gorcunov@openvz.org, peterz@infradead.org,
       ming.m.lin@intel.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20100508112717.315897547@openvz.org>
References: <20100508112717.315897547@openvz.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] x86, perf: P4 PMU -- check for proper event index in RAW events
Message-ID: <tip-c7993165ef0c1d636ca05f4787739f8414584e6d@git.kernel.org>
Git-Commit-ID: c7993165ef0c1d636ca05f4787739f8414584e6d
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 08 May 2010 16:10:36 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c7993165ef0c1d636ca05f4787739f8414584e6d
Gitweb:     http://git.kernel.org/tip/c7993165ef0c1d636ca05f4787739f8414584e6d
Author:     Cyrill Gorcunov <gorcunov@openvz.org>
AuthorDate: Sat, 8 May 2010 15:25:54 +0400
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 8 May 2010 14:17:53 +0200

x86, perf: P4 PMU -- check for proper event index in RAW events

RAW events are special and we should be ready for user passing
in insane event index values.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Lin Ming <ming.m.lin@intel.com>
LKML-Reference: <20100508112717.315897547@openvz.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/perf_event_p4.c |   11 ++++++++++-
 1 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_p4.c b/arch/x86/kernel/cpu/perf_event_p4.c
index b8c2d37..a603930 100644
--- a/arch/x86/kernel/cpu/perf_event_p4.c
+++ b/arch/x86/kernel/cpu/perf_event_p4.c
@@ -418,6 +418,7 @@ static int p4_hw_config(struct perf_event *event)
 {
 	int cpu = get_cpu();
 	int rc = 0;
+	unsigned int evnt;
 	u32 escr, cccr;
 
 	/*
@@ -436,6 +437,14 @@ static int p4_hw_config(struct perf_event *event)
 		event->hw.config = p4_set_ht_bit(event->hw.config);
 
 	if (event->attr.type == PERF_TYPE_RAW) {
+
+		/* user data may have out-of-bound event index */
+		evnt = p4_config_unpack_event(event->attr.config);
+		if (evnt >= ARRAY_SIZE(p4_event_bind_map)) {
+			rc = -EINVAL;
+			goto out;
+		}
+
 		/*
 		 * We don't control raw events so it's up to the caller
 		 * to pass sane values (and we don't count the thread number
@@ -451,8 +460,8 @@ static int p4_hw_config(struct perf_event *event)
 	}
 
 	rc = x86_setup_perfctr(event);
+out:
 	put_cpu();
-
 	return rc;
 }
 
