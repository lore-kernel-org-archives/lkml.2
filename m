Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756353Ab2DZMST (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 08:18:19 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52722 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755436Ab2DZMSR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 08:18:17 -0400
Date: Thu, 26 Apr 2012 05:18:04 -0700
From: tip-bot for Robert Richter <robert.richter@amd.com>
Message-ID: <tip-5f09fc688936705b2020ca247df39ee27283668a@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        robert.richter@amd.com, a.p.zijlstra@chello.nl, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        robert.richter@amd.com, a.p.zijlstra@chello.nl, tglx@linutronix.de
In-Reply-To: <1333643084-26776-3-git-send-email-robert.richter@amd.com>
References: <1333643084-26776-3-git-send-email-robert.richter@amd.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf/x86: Fix cmpxchg()
  usage in amd_put_event_constraints()
Git-Commit-ID: 5f09fc688936705b2020ca247df39ee27283668a
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 26 Apr 2012 05:18:09 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5f09fc688936705b2020ca247df39ee27283668a
Gitweb:     http://git.kernel.org/tip/5f09fc688936705b2020ca247df39ee27283668a
Author:     Robert Richter <robert.richter@amd.com>
AuthorDate: Thu, 5 Apr 2012 18:24:42 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 26 Apr 2012 13:52:51 +0200

perf/x86: Fix cmpxchg() usage in amd_put_event_constraints()

Now the return value of cmpxchg() is used to match an event. The
change removes the duplicate event comparison and traverses the list
until an event was removed. This also fixes the following warning:

 arch/x86/kernel/cpu/perf_event_amd.c:170: warning: value computed is not used

Signed-off-by: Robert Richter <robert.richter@amd.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1333643084-26776-3-git-send-email-robert.richter@amd.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/cpu/perf_event_amd.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_amd.c b/arch/x86/kernel/cpu/perf_event_amd.c
index 95e7fe1..589286f 100644
--- a/arch/x86/kernel/cpu/perf_event_amd.c
+++ b/arch/x86/kernel/cpu/perf_event_amd.c
@@ -205,10 +205,8 @@ static void amd_put_event_constraints(struct cpu_hw_events *cpuc,
 	 * when we come here
 	 */
 	for (i = 0; i < x86_pmu.num_counters; i++) {
-		if (nb->owners[i] == event) {
-			cmpxchg(nb->owners+i, event, NULL);
+		if (cmpxchg(nb->owners + i, event, NULL) == event)
 			break;
-		}
 	}
 }
 
