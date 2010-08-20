Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752992Ab0HTRDE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 13:03:04 -0400
Received: from mga02.intel.com ([134.134.136.20]:40067 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751467Ab0HTRDC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 13:03:02 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,239,1280732400"; 
   d="scan'208";a="547218446"
Subject: Re: [PATCH  1/1] mutex: prevent optimistic spinning from spinning
 longer than neccessary (Repost)
From: Tim Chen <tim.c.chen@linux.intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        =?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        peterz@infradead.org, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        Tony Luck <tony.luck@intel.com>
In-Reply-To: <20100820131920.GC3321@elte.hu>
References: <1282168827.9542.72.camel@schen9-DESK>
	 <20100819110511.GA16264@elte.hu>
	 <1877.10.21.68.23.1282256686.squirrel@linux.intel.com>
	 <20100820131920.GC3321@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 20 Aug 2010 09:54:35 -0700
Message-ID: <1282323276.9675.6.camel@schen9-DESK>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-08-20 at 15:19 +0200, Ingo Molnar wrote:

> 
> Thanks! The performance results you've posted so far IMO more than justifies 
> its inclusion.
> 
> 	Ingo

Thanks to everyone for your review.  I've updated the patch to add
comments explaining the change per suggestion from Andrew.

Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>
diff --git a/kernel/sched.c b/kernel/sched.c
index 41541d7..3747d04 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -3865,8 +3865,15 @@ int mutex_spin_on_owner(struct mutex *lock, struct thread_info *owner)
 		/*
 		 * Owner changed, break to re-assess state.
 		 */
-		if (lock->owner != owner)
+		if (lock->owner != owner) {
+			/* if lock has switched to a different owner,
+			 * we have heavy contention. Return 0 to
+			 * quit optimistic spinning and not contend further.
+			 */
+			if (lock->owner)
+				return 0;
 			break;
+		}
 
 		/*
 		 * Is that owner really running on that cpu?


