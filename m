Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752968Ab0EHL11 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 May 2010 07:27:27 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:58825 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752934Ab0EHL1X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 May 2010 07:27:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:user-agent:date:from:to:cc:subject:references
         :content-disposition;
        b=IgdQxROuFCzks3rzkBYADTzBCOI/A/z2zTVeg4L/E+03ABXOXWvhE54pEiIc3L0LfS
         GJ4gAI/kBIilwvKNeurqdBibwF6V45EYtL/veaLkc3B98cPPWgmiaG1wEfOT6eTKRnzp
         0FckrNu5Dd21BNdk0tAVLspMTxoYgnhoM1DSY=
Message-Id: <20100508112717.315897547@openvz.org>
User-Agent: quilt/0.47-1
Date: Sat, 08 May 2010 15:25:54 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Lin Ming <ming.m.lin@intel.com>, Cyrill Gorcunov <gorcunov@openvz.org>
Subject: [patch 4/4] x86,perf: P4 PMU -- check for proper event index in RAW events
References: <20100508112550.187421916@openvz.org>
Content-Disposition: inline; filename=x86-perf-p4-raw-index
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

RAW events are special and we should be ready for user passing
insane event index.

CC: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>
CC: Frederic Weisbecker <fweisbec@gmail.com>
CC: Lin Ming <ming.m.lin@intel.com>
Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
---
 arch/x86/kernel/cpu/perf_event_p4.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

Index: linux-2.6.git/arch/x86/kernel/cpu/perf_event_p4.c
=====================================================================
--- linux-2.6.git.orig/arch/x86/kernel/cpu/perf_event_p4.c
+++ linux-2.6.git/arch/x86/kernel/cpu/perf_event_p4.c
@@ -418,6 +418,7 @@ static int p4_hw_config(struct perf_even
 {
 	int cpu = get_cpu();
 	int rc = 0;
+	unsigned int evnt;
 	u32 escr, cccr;
 
 	/*
@@ -436,6 +437,14 @@ static int p4_hw_config(struct perf_even
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
@@ -451,8 +460,8 @@ static int p4_hw_config(struct perf_even
 	}
 
 	rc = x86_setup_perfctr(event);
+out:
 	put_cpu();
-
 	return rc;
 }
 

