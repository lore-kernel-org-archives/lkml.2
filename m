Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932127Ab0ERUoF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 16:44:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6771 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932087Ab0ERUoB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 16:44:01 -0400
Date: Tue, 18 May 2010 16:43:30 -0400
From: Jason Baron <jbaron@redhat.com>
To: eranian@googlemail.com
Cc: linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, mingo@elte.hu,
       paulus@samba.org, perfmon2-devel@lists.sf.net
Subject: [PATCH] perf: fix cmpxchg warning in perf_event_amd.c
Message-ID: <20100518204330.GA30624@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm getting the following warnings:

In file included from arch/x86/kernel/cpu/perf_event.c:1343:
arch/x86/kernel/cpu/perf_event_amd.c: In function
‘amd_put_event_constraints’:
arch/x86/kernel/cpu/perf_event_amd.c:167: warning: value computed is not
used

Since cmpxchg returns a value, we need to use it. We can use it to test if its
equal to "event".

thanks,

-Jason

Signed-off-by: Jason Baron <jbaron@redhat.com>
---
 arch/x86/kernel/cpu/perf_event_amd.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_amd.c b/arch/x86/kernel/cpu/perf_event_amd.c
index 611df11..e13ce4a 100644
--- a/arch/x86/kernel/cpu/perf_event_amd.c
+++ b/arch/x86/kernel/cpu/perf_event_amd.c
@@ -163,10 +163,8 @@ static void amd_put_event_constraints(struct cpu_hw_events *cpuc,
 	 * when we come here
 	 */
 	for (i = 0; i < x86_pmu.num_counters; i++) {
-		if (nb->owners[i] == event) {
-			cmpxchg(nb->owners+i, event, NULL);
+		if (cmpxchg(nb->owners+i, event, NULL) == event)
 			break;
-		}
 	}
 }
 
-- 
1.7.0.1

