Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753215Ab0EHL1b (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 May 2010 07:27:31 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:36017 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752707Ab0EHL1X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 May 2010 07:27:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:user-agent:date:from:to:cc:subject:references
         :content-disposition;
        b=nDAd712o0T7OsjoYXNqrejHFjIvNqwOSPenDhwXR5ORhgsai4LDiEsv+2+yoAikYg2
         Pv+/CbbtmO2k25RTcjzQOZeWMQjJGQub/aRCtYPlwd9w2ML2U2IE23V9C5/DBLbjjA+Z
         ooeFt1jz83TGSO5KHNp2Z6PG1J5I7wdzQMY/4=
Message-Id: <20100508112716.741423821@openvz.org>
User-Agent: quilt/0.47-1
Date: Sat, 08 May 2010 15:25:51 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Lin Ming <ming.m.lin@intel.com>,
       Robert Richter <robert.richter@amd.com>,
       Cyrill Gorcunov <gorcunov@openvz.org>
Subject: [patch 1/4] x86,perf: P4 PMU -- configurate predefined events
References: <20100508112550.187421916@openvz.org>
Content-Disposition: inline; filename=x86-perf-p4-repir-raw
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If an event is not RAW we should exit p4_hw_config
early but call x86_setup_perfctr as well.

CC: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>
CC: Frederic Weisbecker <fweisbec@gmail.com>
CC: Lin Ming <ming.m.lin@intel.com>
CC: Robert Richter <robert.richter@amd.com>
Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
---

Robert, if only I'm not missing something this is
a side effect of commit 9d0fcba67e47ff398a6fa86476d4884d472dc98a,
wonders why don't we hit it earlier. Am I wrong?

 arch/x86/kernel/cpu/perf_event_p4.c |   29 ++++++++++++++---------------
 1 file changed, 14 insertions(+), 15 deletions(-)

Index: linux-2.6.git/arch/x86/kernel/cpu/perf_event_p4.c
=====================================================================
--- linux-2.6.git.orig/arch/x86/kernel/cpu/perf_event_p4.c
+++ linux-2.6.git/arch/x86/kernel/cpu/perf_event_p4.c
@@ -439,21 +439,20 @@ static int p4_hw_config(struct perf_even
 	if (p4_ht_active() && p4_ht_thread(cpu))
 		event->hw.config = p4_set_ht_bit(event->hw.config);
 
-	if (event->attr.type != PERF_TYPE_RAW)
-		return 0;
-
-	/*
-	 * We don't control raw events so it's up to the caller
-	 * to pass sane values (and we don't count the thread number
-	 * on HT machine but allow HT-compatible specifics to be
-	 * passed on)
-	 *
-	 * XXX: HT wide things should check perf_paranoid_cpu() &&
-	 *      CAP_SYS_ADMIN
-	 */
-	event->hw.config |= event->attr.config &
-		(p4_config_pack_escr(P4_ESCR_MASK_HT) |
-		 p4_config_pack_cccr(P4_CCCR_MASK_HT));
+	if (event->attr.type == PERF_TYPE_RAW) {
+		/*
+		 * We don't control raw events so it's up to the caller
+		 * to pass sane values (and we don't count the thread number
+		 * on HT machine but allow HT-compatible specifics to be
+		 * passed on)
+		 *
+		 * XXX: HT wide things should check perf_paranoid_cpu() &&
+		 *      CAP_SYS_ADMIN
+		 */
+		event->hw.config |= event->attr.config &
+			(p4_config_pack_escr(P4_ESCR_MASK_HT) |
+			 p4_config_pack_cccr(P4_CCCR_MASK_HT));
+	}
 
 	return x86_setup_perfctr(event);
 }

