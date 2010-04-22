Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752760Ab0DVJSn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 05:18:43 -0400
Received: from mga03.intel.com ([143.182.124.21]:12727 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751179Ab0DVJSm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 05:18:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.52,255,1270450800"; 
   d="scan'208";a="268789623"
Subject: Re: [RFC][PATCH 1/4] perf: core, add group scheduling
 transactional APIs
From: Lin Ming <ming.m.lin@intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, "eranian@gmail.com" <eranian@gmail.com>,
       "Gary.Mohr@Bull.com" <Gary.Mohr@bull.com>,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       "arjan@linux.intel.com" <arjan@linux.intel.com>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Paul Mackerras <paulus@samba.org>,
       "David S. Miller" <davem@davemloft.net>,
       lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <1271924699.1776.316.camel@laptop>
References: <1271922662.30535.107.camel@minggr.sh.intel.com>
	 <1271924699.1776.316.camel@laptop>
Content-Type: text/plain
Date: Thu, 22 Apr 2010 17:19:02 +0800
Message-Id: <1271927943.3412.4.camel@minggr.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 (2.24.1-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-04-22 at 16:24 +0800, Peter Zijlstra wrote:
> On Thu, 2010-04-22 at 15:51 +0800, Lin Ming wrote:
> > +       if (pmu->commit_txn) {
> > +               ret = pmu->commit_txn(pmu);
> > +               if (!ret) {
> > +                       if (pmu->stop_txn)
> > +                               pmu->stop_txn(pmu);
> > +
> > +                       return 0;
> > +               }
> > +       } 
> 
> I think we can mandate that if one of the _txn methods is available,
> they all are, it would be weird otherwise.
> 

How about below?

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index ffd2360..72ea25c 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -635,12 +635,16 @@ group_sched_in(struct perf_event *group_event,
 {
 	struct perf_event *event, *partial_group = NULL;
 	const struct pmu *pmu = group_event->pmu;
+	bool txn = false;
 	int ret;
 
 	if (group_event->state == PERF_EVENT_STATE_OFF)
 		return 0;
 
 	if (pmu->start_txn)
+		txn = true;
+
+	if (txn)
 		pmu->start_txn(pmu);
 
 	if (event_sched_in(group_event, cpuctx, ctx))
@@ -656,18 +660,17 @@ group_sched_in(struct perf_event *group_event,
 		}
 	}
 
-	if (pmu->commit_txn) {
+	if (txn) {
 		ret = pmu->commit_txn(pmu);
 		if (!ret) {
-			if (pmu->stop_txn)
-				pmu->stop_txn(pmu);
+			pmu->stop_txn(pmu);
 
 			return 0;
 		}
 	}
 
 group_error:
-	if (pmu->stop_txn)
+	if (txn)
 		pmu->stop_txn(pmu);
 
 	/*


