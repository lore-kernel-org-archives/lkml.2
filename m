Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759699Ab2EIOgG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 10:36:06 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41128 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759683Ab2EIOgB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 10:36:01 -0400
Date: Wed, 9 May 2012 07:35:42 -0700
From: tip-bot for Robert Richter <robert.richter@amd.com>
Message-ID: <tip-fc006cf7cc7471e1bdf34e40111971e03622af6c@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        robert.richter@amd.com, a.p.zijlstra@chello.nl, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        robert.richter@amd.com, a.p.zijlstra@chello.nl, tglx@linutronix.de
In-Reply-To: <1333390758-10893-9-git-send-email-robert.richter@amd.com>
References: <1333390758-10893-9-git-send-email-robert.richter@amd.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf/x86-ibs:
  Trigger overflow if remaining period is too small
Git-Commit-ID: fc006cf7cc7471e1bdf34e40111971e03622af6c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 09 May 2012 07:35:49 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  fc006cf7cc7471e1bdf34e40111971e03622af6c
Gitweb:     http://git.kernel.org/tip/fc006cf7cc7471e1bdf34e40111971e03622af6c
Author:     Robert Richter <robert.richter@amd.com>
AuthorDate: Mon, 2 Apr 2012 20:19:14 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 9 May 2012 15:23:15 +0200

perf/x86-ibs: Trigger overflow if remaining period is too small

There are cases where the remaining period is smaller than the minimal
possible value. In this case the counter is restarted with the minimal
period. This is of no use as the interrupt handler will trigger
immediately again and most likely hits itself. This biases the
results.

So, if the remaining period is within the min range, we better do not
restart the counter and instead trigger the overflow.

Signed-off-by: Robert Richter <robert.richter@amd.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1333390758-10893-9-git-send-email-robert.richter@amd.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/cpu/perf_event_amd_ibs.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_amd_ibs.c b/arch/x86/kernel/cpu/perf_event_amd_ibs.c
index 29a1bff..3e32908 100644
--- a/arch/x86/kernel/cpu/perf_event_amd_ibs.c
+++ b/arch/x86/kernel/cpu/perf_event_amd_ibs.c
@@ -78,16 +78,13 @@ perf_event_set_period(struct hw_perf_event *hwc, u64 min, u64 max, u64 *hw_perio
 		overflow = 1;
 	}
 
-	if (unlikely(left <= 0)) {
+	if (unlikely(left < (s64)min)) {
 		left += period;
 		local64_set(&hwc->period_left, left);
 		hwc->last_period = period;
 		overflow = 1;
 	}
 
-	if (unlikely(left < min))
-		left = min;
-
 	if (left > max)
 		left = max;
 
