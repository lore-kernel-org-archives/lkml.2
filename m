Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759018Ab1FWJDO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 05:03:14 -0400
Received: from casper.infradead.org ([85.118.1.10]:60949 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755834Ab1FWJDN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 05:03:13 -0400
Subject: Re: power increase issue on light load
From: Peter Zijlstra <peterz@infradead.org>
To: "Alex,Shi" <alex.shi@intel.com>
Cc: ncrao@google.com, mingo@elte.hu, "Chen, Tim C" <tim.c.chen@intel.com>,
        "Li, Shaohua" <shaohua.li@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <1308797024.23204.95.camel@debian>
References: <1308797024.23204.95.camel@debian>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 23 Jun 2011 11:02:28 +0200
Message-ID: <1308819748.1022.69.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-06-23 at 10:43 +0800, Alex,Shi wrote:
> commit c8b281161dfa4bb5d5be63fb036ce19347b88c63 causes light load
> benchmark use more than 10% system power on platform NHM-EP and laptop
> Thinkpad T410 etc. The benchmarks are specpower and bltk office. 
> 
> I tried to track this issue, but only find deep C sate time reduced
> much, about from 90% to 30~40%, the C0 or C1 state increase much on
> different machines. 
> 
> Powertop just hints RES interrupts has a bit more. but when I try "perf
> probe native_smp_send_reschedule". I didn't find much. 
> 
> I also checked the /proc/schedstat, just can sure the load_balance was
> called a bit more frequency. but pull_task() was called really rare. 
> 
> 
> The following are the /proc/schedstat increased number in about 300' when do bltk-office. 
> The getting command is here:
> #on a 16 LCPU system, with 3 level domain, 0,1,2, so all domain number
> is 48, the domain statistic number is 2 + 36, so fs=38,
> 
> $cat /proc/schedstat > schedstat ; sleep x ; cat /proc/schedstat >>
> schedstat ; cat schedstat | grep domain | sed '49 i \\n' |  awk -v fs=38
> 'BEGIN { RS=""; FS=" " } { if ( NR ==1) for (i=0; i<NF; i++)
> { value1[i]=$i ; } ;  if ( NR ==2) for (i=0; i<NF; i++) { value2[i]=
> $i } } END {ORS=" ";  for (i=0;i<NF;i++){ if (i%fs == 0)  ll="\n"; else
> ll=""; print value2[i] - value1[i]  ll  };  print "\n" }'

/proc/schedstat is already a massive pain to interpret and then you go
and mangle things even more and expect me to try and understand that
crap? I don't think so, life is too short.

> BTW, the imbalance increasing is due to the SCALE increase about 1024. 

> Any ideas of this? 

What happens if you try something like the below. Increased imbalance
might lead to more load-balance action, which might lead to more task
migration/waking up of cpus etc.

If the below makes any difference, Nikhil's changes have a funny that
needs to be caught.

---
 include/linux/sched.h |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index a837b20..84121d6 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -808,15 +808,9 @@ enum cpu_idle_type {
  * when BITS_PER_LONG <= 32 are pretty high and the returns do not justify the
  * increased costs.
  */
-#if BITS_PER_LONG > 32
-# define SCHED_LOAD_RESOLUTION	10
-# define scale_load(w)		((w) << SCHED_LOAD_RESOLUTION)
-# define scale_load_down(w)	((w) >> SCHED_LOAD_RESOLUTION)
-#else
 # define SCHED_LOAD_RESOLUTION	0
 # define scale_load(w)		(w)
 # define scale_load_down(w)	(w)
-#endif
 
 #define SCHED_LOAD_SHIFT	(10 + SCHED_LOAD_RESOLUTION)
 #define SCHED_LOAD_SCALE	(1L << SCHED_LOAD_SHIFT)

