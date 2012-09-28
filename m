Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755956Ab2I1EjE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 00:39:04 -0400
Received: from mga03.intel.com ([143.182.124.21]:54227 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750984Ab2I1Ebx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 00:31:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,498,1344236400"; 
   d="scan'208";a="198218538"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org, a.p.zijlstra@chello.nl, eranian@google.com,
        acme@redhat.com, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 04/31] perf, core: Add generic intx/intx_checkpointed counter modifiers
Date: Thu, 27 Sep 2012 21:31:09 -0700
Message-Id: <1348806696-31170-5-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1348806696-31170-1-git-send-email-andi@firstfloor.org>
References: <1348806696-31170-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Expose INTX (count in transaction only, :t) and INTX_CHECKPOINTED
(on transaction abort restore counter, :c) attributes as generic perf event
attributes. These are important for measuring basic hardware transactional behaviour.

They also need to be handled in a special way in the Haswell port, so it's useful
to have them as generic attributes.

Typically they would be used as a group with:

{cycles,cycles:t,cycles:ct}

Then:

Total cycles = cycles
Percent cycles in transaction = (cycles:t/cycles)*100
Percent cycles in transaction lost due to aborts = ((cycles:t-cycles:ct) / cycles)*100

This gives a quick overview of the transactional execution.

Used in followon patches.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 include/linux/perf_event.h |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 33ed9d6..4c2adfa 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -251,11 +251,14 @@ struct perf_event_attr {
 				precise_ip     :  2, /* skid constraint       */
 				mmap_data      :  1, /* non-exec mmap data    */
 				sample_id_all  :  1, /* sample_type all events */
-
 				exclude_host   :  1, /* don't count in host   */
 				exclude_guest  :  1, /* don't count in guest  */
+				intx           :  1, /* count inside transaction */
+				intx_checkpointed :  1, /* checkpointed in transaction */
+
+
 
-				__reserved_1   : 43;
+				__reserved_1   : 41;
 
 	union {
 		__u32		wakeup_events;	  /* wakeup every n events */
-- 
1.7.7.6

