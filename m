Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759726Ab2EIOgw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 10:36:52 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41139 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758033Ab2EIOgv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 10:36:51 -0400
Date: Wed, 9 May 2012 07:36:32 -0700
From: tip-bot for Robert Richter <robert.richter@amd.com>
Message-ID: <tip-7caaf4d8241feecafb87919402b0a6dbb1b71d9e@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        robert.richter@amd.com, a.p.zijlstra@chello.nl, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        robert.richter@amd.com, a.p.zijlstra@chello.nl, tglx@linutronix.de
In-Reply-To: <1333390758-10893-10-git-send-email-robert.richter@amd.com>
References: <1333390758-10893-10-git-send-email-robert.richter@amd.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf/x86-ibs:
  Extend hw period that triggers overflow
Git-Commit-ID: 7caaf4d8241feecafb87919402b0a6dbb1b71d9e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 09 May 2012 07:36:38 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7caaf4d8241feecafb87919402b0a6dbb1b71d9e
Gitweb:     http://git.kernel.org/tip/7caaf4d8241feecafb87919402b0a6dbb1b71d9e
Author:     Robert Richter <robert.richter@amd.com>
AuthorDate: Mon, 2 Apr 2012 20:19:15 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 9 May 2012 15:23:15 +0200

perf/x86-ibs: Extend hw period that triggers overflow

If the last hw period is too short we might hit the irq handler which
biases the results. Thus try to have a max last period that triggers
the sw overflow.

Signed-off-by: Robert Richter <robert.richter@amd.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1333390758-10893-10-git-send-email-robert.richter@amd.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/cpu/perf_event_amd_ibs.c |   15 +++++++++++++--
 1 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_amd_ibs.c b/arch/x86/kernel/cpu/perf_event_amd_ibs.c
index 3e32908..cb51a3e 100644
--- a/arch/x86/kernel/cpu/perf_event_amd_ibs.c
+++ b/arch/x86/kernel/cpu/perf_event_amd_ibs.c
@@ -85,8 +85,19 @@ perf_event_set_period(struct hw_perf_event *hwc, u64 min, u64 max, u64 *hw_perio
 		overflow = 1;
 	}
 
-	if (left > max)
-		left = max;
+	/*
+	 * If the hw period that triggers the sw overflow is too short
+	 * we might hit the irq handler. This biases the results.
+	 * Thus we shorten the next-to-last period and set the last
+	 * period to the max period.
+	 */
+	if (left > max) {
+		left -= max;
+		if (left > max)
+			left = max;
+		else if (left < min)
+			left = min;
+	}
 
 	*hw_period = (u64)left;
 
