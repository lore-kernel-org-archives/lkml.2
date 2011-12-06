Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753872Ab1LFTPW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 14:15:22 -0500
Received: from mga09.intel.com ([134.134.136.24]:61668 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752806Ab1LFTPT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 14:15:19 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="84135619"
Subject: Re: [patch v3 3/6] sched, nohz: sched group, domain aware nohz idle
 load balancing
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Venki Pallipadi <venki@google.com>, Mike Galbraith <efault@gmx.de>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Tim Chen <tim.c.chen@linux.jf.intel.com>,
        "Shi, Alex" <alex.shi@intel.com>
Date: Tue, 06 Dec 2011 11:19:37 -0800
In-Reply-To: <20111206063736.GA18040@linux.vnet.ibm.com>
References: <20111202010731.344451602@sbsiddha-desk.sc.intel.com>
	 <20111202010832.602203411@sbsiddha-desk.sc.intel.com>
	 <20111206063736.GA18040@linux.vnet.ibm.com>
Organization: Intel Corp
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1323199177.1984.12.camel@sbsiddha-desk.sc.intel.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-12-05 at 22:37 -0800, Srivatsa Vaddagiri wrote:
> * Suresh Siddha <suresh.b.siddha@intel.com> [2011-12-01 17:07:34]:
> 
> > @@ -5090,7 +5019,7 @@ static void nohz_idle_balance(int this_c
> >  		goto end;
> > 
> >  	for_each_cpu(balance_cpu, nohz.idle_cpus_mask) {
> > -		if (balance_cpu == this_cpu)
> > +		if (balance_cpu == this_cpu || !idle_cpu(this_cpu))
> >  			continue;
> 
> Hmm ..did you mean to use '!idle_cpu(balance_cpu)' there?

Thanks for reviewing closely. yes, it was a typo. Peter, please queue up
this fix.
---

From: Suresh Siddha <suresh.b.siddha@intel.com>
Subject: sched, nohz: fix the idle cpu check in nohz_idle_balance

cpu bit in the nohz.idle_cpu_mask are reset in the first busy tick after
exiting idle. So during nohz_idle_balance(), intention is to double
check if the cpu that is part of the idle_cpu_mask is indeed idle before
going ahead in performing idle balance for that cpu.

Fix the cpu typo in the idle_cpu() check during nohz_idle_balance().

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---
 kernel/sched/fair.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 65a6f8b..0bcd144 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -5019,7 +5019,7 @@ static void nohz_idle_balance(int this_cpu, enum cpu_idle_type idle)
 		goto end;
 
 	for_each_cpu(balance_cpu, nohz.idle_cpus_mask) {
-		if (balance_cpu == this_cpu || !idle_cpu(this_cpu))
+		if (balance_cpu == this_cpu || !idle_cpu(balance_cpu))
 			continue;
 
 		/*


