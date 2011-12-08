Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751550Ab1LHMQs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 07:16:48 -0500
Received: from mx1.redhat.com ([209.132.183.28]:57558 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750760Ab1LHMQr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 07:16:47 -0500
Date: Thu, 8 Dec 2011 13:16:41 +0100
From: Petr Holasek <pholasek@redhat.com>
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Anton Arapov <anton@redhat.com>
Subject: [PATCH v3] NUMA x86: add constraints check for nid parameters
Message-ID: <20111208121640.GA2229@dhcp-27-244.brq.redhat.com>
References: <1322739907-4695-1-git-send-email-pholasek@redhat.com>
 <20111201133451.5fc1ee7b.akpm@linux-foundation.org>
 <20111201231441.GA3293@stainedmachine.redhat.com>
 <20111201152851.7e39f034.akpm@linux-foundation.org>
 <20111202105538.GB2188@dhcp-27-244.brq.redhat.com>
 <alpine.DEB.2.00.1112061233330.28251@chino.kir.corp.google.com>
 <20111207194311.GB26060@dhcp-27-244.brq.redhat.com>
 <alpine.DEB.2.00.1112071342450.27360@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1112071342450.27360@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds constraints checks for numa_set_distance()
function. It emits warning and avoids a store to a negative
index in numa_distance[] array. Negative ids can be passed when
pxm-to-nids mapping is not properly filled while parsing the SRAT.

Signed-off-by: Petr Holasek <pholasek@redhat.com>
---
 arch/x86/mm/numa.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/arch/x86/mm/numa.c b/arch/x86/mm/numa.c
index fbeaaf4..cdc0054 100644
--- a/arch/x86/mm/numa.c
+++ b/arch/x86/mm/numa.c
@@ -430,8 +430,9 @@ static int __init numa_alloc_distance(void)
  * calls are ignored until the distance table is reset with
  * numa_reset_distance().
  *
- * If @from or @to is higher than the highest known node at the time of
- * table creation or @distance doesn't make sense, the call is ignored.
+ * If @from or @to is higher than the highest known node or lower than zero
+ * at the time of table creation or @distance doesn't make sense, the call
+ * is ignored.
  * This is to allow simplification of specific NUMA config implementations.
  */
 void __init numa_set_distance(int from, int to, int distance)
@@ -439,8 +440,9 @@ void __init numa_set_distance(int from, int to, int distance)
 	if (!numa_distance && numa_alloc_distance() < 0)
 		return;
 
-	if (from >= numa_distance_cnt || to >= numa_distance_cnt) {
-		printk_once(KERN_DEBUG "NUMA: Debug: distance out of bound, from=%d to=%d distance=%d\n",
+	if (from >= numa_distance_cnt || to >= numa_distance_cnt ||
+			from < 0 || to < 0) {
+		pr_warn_once("NUMA: Warning: node ids are out of bound, from=%d to=%d distance=%d\n",
 			    from, to, distance);
 		return;
 	}
-- 
1.7.6.4

