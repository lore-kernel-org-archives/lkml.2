Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753959Ab0ENK5O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 06:57:14 -0400
Received: from mga11.intel.com ([192.55.52.93]:13483 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751696Ab0ENK5N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 06:57:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,229,1272870000"; 
   d="scan'208";a="798431387"
Subject: Re: Performance Events hangs with Intel P4 system
From: Lin Ming <ming.m.lin@intel.com>
To: Cyrill Gorcunov <gorcunov@gmail.com>, Ingo Molnar <mingo@elte.hu>
Cc: Jaswinder Singh Rajput <jaswinderlinux@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <AANLkTinPcjUyPyUP4L7opELEbLZy-tXxkbm-nqe8Co0f@mail.gmail.com>
References: <AANLkTimKHkgWJJOOICzQ4TL3mbL-lvYEocwBSe3XSBVR@mail.gmail.com>
	 <AANLkTiktLXqHhop21ePIXF2kaVQbm3DIHZpLrEQOMA1e@mail.gmail.com>
	 <AANLkTimCjt0R7A23xTrmToTqTcF4ZW4sNWtjMwjVIVqe@mail.gmail.com>
	 <AANLkTinbrhuGqHss_aML3EAccOq792GUZtqzzjQqzG6I@mail.gmail.com>
	 <AANLkTimVmlPfRFu8Wo2KL1pyF6qtTSQriawvrKcsMe9Y@mail.gmail.com>
	 <AANLkTimrHGq1kZwPev7gBZu6Hqxlhe0ZscSKjEinZtcf@mail.gmail.com>
	 <AANLkTik-gIjZu60pFWEhhe8MolQITrtk0wfpvSUCLnrD@mail.gmail.com>
	 <AANLkTinPcjUyPyUP4L7opELEbLZy-tXxkbm-nqe8Co0f@mail.gmail.com>
Content-Type: text/plain
Date: Fri, 14 May 2010 18:56:11 +0800
Message-Id: <1273834571.3530.82.camel@minggr.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 (2.24.1-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-05-14 at 18:04 +0800, Cyrill Gorcunov wrote:
> On Friday, May 14, 2010, Cyrill Gorcunov <gorcunov@gmail.com> wrote:
> > On Friday, May 14, 2010, Jaswinder Singh Rajput
> > <jaswinderlinux@gmail.com> wrote:
> >> Hello Cyrill,
> >>
> >> On Fri, May 14, 2010 at 11:53 AM, Cyrill Gorcunov <gorcunov@gmail.com> wrote:
> >>> On Friday, May 14, 2010, Cyrill Gorcunov <gorcunov@gmail.com> wrote:
> >>>>> Message from syslogd@ht at May 14 09:39:32 ...
> >>>>>  kernel:[  thanks Jaswinder, i'll take a look, meanwhile if you get a chance to
> >>>> test latest -tip/master it would be great
> >>>>
> >>>
> >>> it's found that we have problem in cache events, we're working on
> >>> that, thanks for report!
> >>>
> >>
> >> Great !!
> >>
> >> If you need any help from my side, please let me know. Even though it
> >> is very hot here, I will try my best ;-)
> >>
> >> Thanks,
> >> --
> >> Jaswinder Singh.
> >>
> >
> > Ming is narrowing down the guilty commit. I thought about my last
> > patch related to escr hashing, but it shouldn't bring such effect.
> > Hmm...
> >
> 
> Jaswander, if you manage to bisect it -- this would be just great.

Hi, Jaswinder 

Below patch fixes the regression on my P4 machine.
Would you please have a try it?

Thanks.
---

Subject: [PATCH] x86, perf: P4 PMU -- fix wrong compare

p4_event_bind::cntr is "unsigned char".
But p4_next_cntr has return type of "int".
So the explicit conversion is needed to get the correct result. 

Signed-off-by: Lin Ming <ming.m.lin@intel.com>
---
 arch/x86/kernel/cpu/perf_event_p4.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_p4.c b/arch/x86/kernel/cpu/perf_event_p4.c
index cb875b1..9358793 100644
--- a/arch/x86/kernel/cpu/perf_event_p4.c
+++ b/arch/x86/kernel/cpu/perf_event_p4.c
@@ -780,7 +780,7 @@ static int p4_pmu_schedule_events(struct cpu_hw_events *cpuc, int n, int *assign
 		if (unlikely(escr_idx == -1))
 			goto done;
 
-		if (hwc->idx != -1 && !p4_should_swap_ts(hwc->config, cpu)) {
+		if (hwc->idx != (unsigned char)-1 && !p4_should_swap_ts(hwc->config, cpu)) {
 			cntr_idx = hwc->idx;
 			if (assign)
 				assign[i] = hwc->idx;
@@ -788,7 +788,7 @@ static int p4_pmu_schedule_events(struct cpu_hw_events *cpuc, int n, int *assign
 		}
 
 		cntr_idx = p4_next_cntr(thread, used_mask, bind);
-		if (cntr_idx == -1 || test_bit(escr_idx, escr_mask))
+		if (cntr_idx == (unsigned char)-1 || test_bit(escr_idx, escr_mask))
 			goto done;
 
 		p4_pmu_swap_config_ts(hwc, cpu);


