Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756117Ab0HXVsv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 17:48:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13253 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755718Ab0HXVsu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 17:48:50 -0400
Date: Tue, 24 Aug 2010 17:48:25 -0400
From: Don Zickus <dzickus@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Robert Richter <robert.richter@amd.com>,
        Cyrill Gorcunov <gorcunov@gmail.com>, Lin Ming <ming.m.lin@intel.com>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Huang, Ying" <ying.huang@intel.com>, Yinghai Lu <yinghai@kernel.org>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH -v3] perf, x86: try to handle unknown nmis with running
 perfctrs
Message-ID: <20100824214825.GE4879@redhat.com>
References: <1282214753.1926.4669.camel@laptop>
 <20100819141240.GO4879@redhat.com>
 <1282228033.2605.204.camel@laptop>
 <20100820015017.GA4879@redhat.com>
 <20100820081605.GD17551@elte.hu>
 <1282298651.2605.769.camel@laptop>
 <20100820123901.GE4879@redhat.com>
 <20100820132737.GD3321@elte.hu>
 <20100820135118.GI4879@redhat.com>
 <20100820141703.GA29697@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100820141703.GA29697@elte.hu>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 20, 2010 at 04:17:03PM +0200, Ingo Molnar wrote:
> 
> it's not working so well, i'm getting:
> 
>  Uhhuh. NMI received for unknown reason 00 on CPU 9.
>  Do you have a strange power saving mode enabled?
>  Dazed and confused, but trying to continue
> 
> on a nehalem box, after a perf top and perf stat run.

After applying the patch below, I ran the following commands on my nehalem
box without reproducing what you are seeing.  Any thing else I can run
that might trigger it? (I also ran them on an amd phenom quad-core box).

I used 2.6.32-rc2 plus Robert's and 2 of PeterZ's patches.

perf top
perf stat -a -e cycles -e instructions -e cache-references -e cache-misses -e branch-misses -- sleep 5
perf record -f -a -e cycles -e instructions -e cache-references -e cache-misses -e branch-misses -- sleep 5

Cheers,
Don


>From 198be1044fa603bc9582a5c19134fdf9a433fff0 Mon Sep 17 00:00:00 2001
From: Don Zickus <dzickus@redhat.com>
Date: Tue, 24 Aug 2010 17:43:17 -0400
Subject: [PATCH] [x86] perf: rename nmi variable to avoid clash with entry point

There is already an entry point named .nmi in entry.S and that seems to clash
with the per_cpu variable nmi defined in commit f3a860d8.  Renaming this
variable avoids the namespace collision.

Signed-off-by: Don Zickus <dzickus@redhat.com>
---
 arch/x86/kernel/cpu/perf_event.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index dd2fceb..2a05ea4 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -1205,7 +1205,7 @@ struct pmu_nmi_state {
 	int		handled;
 };
 
-static DEFINE_PER_CPU(struct pmu_nmi_state, nmi);
+static DEFINE_PER_CPU_PAGE_ALIGNED(struct pmu_nmi_state, pmu_nmi);
 
 static int __kprobes
 perf_event_nmi_handler(struct notifier_block *self,
@@ -1224,7 +1224,7 @@ perf_event_nmi_handler(struct notifier_block *self,
 		break;
 	case DIE_NMIUNKNOWN:
 		this_nmi = percpu_read(irq_stat.__nmi_count);
-		if (this_nmi != __get_cpu_var(nmi).marked)
+		if (this_nmi != __get_cpu_var(pmu_nmi).marked)
 			/* let the kernel handle the unknown nmi */
 			return NOTIFY_DONE;
 		/*
@@ -1248,8 +1248,8 @@ perf_event_nmi_handler(struct notifier_block *self,
 	this_nmi = percpu_read(irq_stat.__nmi_count);
 	if ((handled > 1) ||
 		/* the next nmi could be a back-to-back nmi */
-	    ((__get_cpu_var(nmi).marked == this_nmi) &&
-	     (__get_cpu_var(nmi).handled > 1))) {
+	    ((__get_cpu_var(pmu_nmi).marked == this_nmi) &&
+	     (__get_cpu_var(pmu_nmi).handled > 1))) {
 		/*
 		 * We could have two subsequent back-to-back nmis: The
 		 * first handles more than one counter, the 2nd
@@ -1260,8 +1260,8 @@ perf_event_nmi_handler(struct notifier_block *self,
 		 * handling more than one counter. We will mark the
 		 * next (3rd) and then drop it if unhandled.
 		 */
-		__get_cpu_var(nmi).marked	= this_nmi + 1;
-		__get_cpu_var(nmi).handled	= handled;
+		__get_cpu_var(pmu_nmi).marked	= this_nmi + 1;
+		__get_cpu_var(pmu_nmi).handled	= handled;
 	}
 
 	return NOTIFY_STOP;
-- 
1.7.2.1

