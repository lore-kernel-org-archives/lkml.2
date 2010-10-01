Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752114Ab0JAQCM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 12:02:12 -0400
Received: from am1ehsobe003.messaging.microsoft.com ([213.199.154.206]:59659
	"EHLO AM1EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751908Ab0JAQCH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 12:02:07 -0400
X-SpamScore: 1
X-BigFish: VS1(zzzz1202hzz8275bhz32i87h2a8h66h)
X-Spam-TCS-SCL: 5:0
X-FB-SS: 0,
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L9MCH4-02-D85-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>,
        oprofile-list <oprofile-list@lists.sourceforge.net>,
        Will Deacon <will.deacon@arm.com>,
        Matt Fleming <matt@console-pimps.org>,
        Robert Richter <robert.richter@amd.com>
Subject: [PATCH 3/5] oprofile, ARM: Rework op_create_counter()
Date: Fri, 1 Oct 2010 17:56:25 +0200
Message-ID: <1285948587-24521-4-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <1285948587-24521-1-git-send-email-robert.richter@amd.com>
References: <1285948587-24521-1-git-send-email-robert.richter@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch simplifies op_create_counter(). Removing if/else if paths
and return code variable by direct returning from function.

Cc: Will Deacon <will.deacon@arm.com>
Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/arm/oprofile/common.c |   20 ++++++++++----------
 1 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/arch/arm/oprofile/common.c b/arch/arm/oprofile/common.c
index 7ae9eeb..cec9305 100644
--- a/arch/arm/oprofile/common.c
+++ b/arch/arm/oprofile/common.c
@@ -89,28 +89,28 @@ static void op_perf_setup(void)
 
 static int op_create_counter(int cpu, int event)
 {
-	int ret = 0;
 	struct perf_event *pevent;
 
-	if (!counter_config[event].enabled || (perf_events[cpu][event] != NULL))
-		return ret;
+	if (!counter_config[event].enabled || perf_events[cpu][event])
+		return 0;
 
 	pevent = perf_event_create_kernel_counter(&counter_config[event].attr,
 						  cpu, -1,
 						  op_overflow_handler);
 
-	if (IS_ERR(pevent)) {
-		ret = PTR_ERR(pevent);
-	} else if (pevent->state != PERF_EVENT_STATE_ACTIVE) {
+	if (IS_ERR(pevent))
+		return PTR_ERR(pevent);
+
+	if (pevent->state != PERF_EVENT_STATE_ACTIVE) {
 		perf_event_release_kernel(pevent);
 		pr_warning("oprofile: failed to enable event %d "
 				"on CPU %d\n", event, cpu);
-		ret = -EBUSY;
-	} else {
-		perf_events[cpu][event] = pevent;
+		return -EBUSY;
 	}
 
-	return ret;
+	perf_events[cpu][event] = pevent;
+
+	return 0;
 }
 
 static void op_destroy_counter(int cpu, int event)
-- 
1.7.2.2


