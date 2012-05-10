Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758309Ab2EJJqV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 05:46:21 -0400
Received: from casper.infradead.org ([85.118.1.10]:52454 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758201Ab2EJJqU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 05:46:20 -0400
Message-ID: <1336643166.2527.86.camel@twins>
Subject: Re: [PATCH] sched: Make nr_uninterruptible count a signed value
From: Peter Zijlstra <peterz@infradead.org>
To: Michael Wang <wangyun@linux.vnet.ibm.com>
Cc: Diwakar Tundlam <dtundlam@nvidia.com>, "'Ingo Molnar'" <mingo@kernel.org>,
        "'David Rientjes'" <rientjes@google.com>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        Peter De Schrijver <pdeschrijver@nvidia.com>
Date: Thu, 10 May 2012 11:46:06 +0200
In-Reply-To: <4FAB38ED.5050200@linux.vnet.ibm.com>
References: <1DD7BFEDD3147247B1355BEFEFE46652379C3DF10C@HQMAIL04.nvidia.com>
	 <1336514192.8226.52.camel@twins>
	 <1DD7BFEDD3147247B1355BEFEFE46652379C3DF10D@HQMAIL04.nvidia.com>
	 <1336516020.8226.57.camel@twins> <1336516174.8226.59.camel@twins>
	 <1DD7BFEDD3147247B1355BEFEFE46652379C3DF10E@HQMAIL04.nvidia.com>
	 <1336551100.27020.84.camel@laptop> <4FAB38ED.5050200@linux.vnet.ibm.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Or something like the below.. I recently changed nr_running to int (see
c82513e51) so P(nr_running) would also benefit.

---
 kernel/sched/debug.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/debug.c b/kernel/sched/debug.c
index 31e4f61..954fabf 100644
--- a/kernel/sched/debug.c
+++ b/kernel/sched/debug.c
@@ -260,8 +260,14 @@ static void print_cpu(struct seq_file *m, int cpu)
 	SEQ_printf(m, "\ncpu#%d\n", cpu);
 #endif
 
-#define P(x) \
-	SEQ_printf(m, "  .%-30s: %Ld\n", #x, (long long)(rq->x))
+#define P(x)								\
+do {									\
+	if (sizeof(rq->x) == 4)						\
+		SEQ_printf(m, "  .%-30s: %ld\n", #x, (long)(rq->x));	\
+	else								\
+		SEQ_printf(m, "  .%-30s: %Ld\n", #x, (long long)(rq->x));\
+} while (0)
+		
 #define PN(x) \
 	SEQ_printf(m, "  .%-30s: %Ld.%06ld\n", #x, SPLIT_NS(rq->x))
 

