Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756555Ab0ENNwy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 09:52:54 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:48110 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751277Ab0ENNww (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 09:52:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=b9G29nBUqQwV08I4cQIULTY4kUlcWEXkCbn8TSRq5W5pWBeLcbg08wyS5F6kl/aaKM
         EjqhM2nNjVQinE50rKQpp2PmHBzYEPbCHQwem2mSQiIlby8mpTb75nCY8f3cHRRHJiL6
         yH3QccQ8SYkGlCGLsHCcvlFiRlTDmeWfp1Ado=
Date: Fri, 14 May 2010 17:52:40 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Lin Ming <ming.m.lin@intel.com>,
       Jaswinder Singh Rajput <jaswinderlinux@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: Performance Events hangs with Intel P4 system
Message-ID: <20100514135240.GA4952@lenovo>
References: <AANLkTimKHkgWJJOOICzQ4TL3mbL-lvYEocwBSe3XSBVR@mail.gmail.com> <AANLkTiktLXqHhop21ePIXF2kaVQbm3DIHZpLrEQOMA1e@mail.gmail.com> <AANLkTimCjt0R7A23xTrmToTqTcF4ZW4sNWtjMwjVIVqe@mail.gmail.com> <AANLkTinbrhuGqHss_aML3EAccOq792GUZtqzzjQqzG6I@mail.gmail.com> <AANLkTimVmlPfRFu8Wo2KL1pyF6qtTSQriawvrKcsMe9Y@mail.gmail.com> <AANLkTimrHGq1kZwPev7gBZu6Hqxlhe0ZscSKjEinZtcf@mail.gmail.com> <AANLkTik-gIjZu60pFWEhhe8MolQITrtk0wfpvSUCLnrD@mail.gmail.com> <AANLkTinPcjUyPyUP4L7opELEbLZy-tXxkbm-nqe8Co0f@mail.gmail.com> <1273834571.3530.82.camel@minggr.sh.intel.com> <20100514115655.GA18069@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100514115655.GA18069@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 14, 2010 at 01:56:55PM +0200, Ingo Molnar wrote:
> 
> * Lin Ming <ming.m.lin@intel.com> wrote:
> 
> > p4_event_bind::cntr is "unsigned char".
> > But p4_next_cntr has return type of "int".
> > So the explicit conversion is needed to get the correct result. 
> 
> > @@ -780,7 +780,7 @@ static int p4_pmu_schedule_events(struct cpu_hw_events *cpuc, int n, int *assign
> >  		if (unlikely(escr_idx == -1))
> >  			goto done;
> >  
> > -		if (hwc->idx != -1 && !p4_should_swap_ts(hwc->config, cpu)) {
> > +		if (hwc->idx != (unsigned char)-1 && !p4_should_swap_ts(hwc->config, cpu)) {
> 
> That cast is _extremely_ ugly. Please fix the signedness of the types instead.
> 
> 	Ingo
> 

Ingo, what about this one? Jaswinder could you give it a shot (untested)?

	-- Cyrill
---
[PATCH -tip/master] x86,perf: P4 PMU - fix counters allocation logic and sign issue

Jaswinder reported GP:
|
| Message from syslogd@ht at May 14 09:39:32 ...
| kernel:[  314.908612] EIP: [<c100ccca>]
| x86_perf_event_set_period+0x19d/0x1b2 SS:ESP 0068:edac3d70
|

Ming has narrowed it down to comparation issue between signed/unsigned values.
As result event index reaches value 255 which in turn leads to GP fault.

Also it was found that p4_next_cntr has a broken logic and should return
counter index if only it was not yet borrowed for another event.

Reported-by: Jaswinder Singh Rajput <jaswinderlinux@gmail.com>
Reported-by: Lin Ming <ming.m.lin@intel.com>
Bisected-by: Lin Ming <ming.m.lin@intel.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Ingo Molnar <mingo@elte.hu>
CC: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
---
 arch/x86/kernel/cpu/perf_event_p4.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

Index: linux-2.6.git/arch/x86/kernel/cpu/perf_event_p4.c
=====================================================================
--- linux-2.6.git.orig/arch/x86/kernel/cpu/perf_event_p4.c
+++ linux-2.6.git/arch/x86/kernel/cpu/perf_event_p4.c
@@ -18,7 +18,7 @@
 struct p4_event_bind {
 	unsigned int opcode;			/* Event code and ESCR selector */
 	unsigned int escr_msr[2];		/* ESCR MSR for this event */
-	unsigned char cntr[2][P4_CNTR_LIMIT];	/* counter index (offset), -1 on abscence */
+	char cntr[2][P4_CNTR_LIMIT];		/* counter index (offset), -1 on abscence */
 };
 
 struct p4_cache_event_bind {
@@ -747,11 +747,11 @@ static int p4_get_escr_idx(unsigned int 
 static int p4_next_cntr(int thread, unsigned long *used_mask,
 			struct p4_event_bind *bind)
 {
-	int i = 0, j;
+	int i, j;
 
 	for (i = 0; i < P4_CNTR_LIMIT; i++) {
-		j = bind->cntr[thread][i++];
-		if (j == -1 || !test_bit(j, used_mask))
+		j = (int)bind->cntr[thread][i];
+		if (j != -1 && !test_bit(j, used_mask))
 			return j;
 	}
 
