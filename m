Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934227Ab1FXAly (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 20:41:54 -0400
Received: from mga02.intel.com ([134.134.136.20]:22716 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932752Ab1FXAlw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 20:41:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,416,1304319600"; 
   d="scan'208";a="19055657"
Subject: Re: power increase issue on light load
From: "Alex,Shi" <alex.shi@intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "ncrao@google.com" <ncrao@google.com>, "mingo@elte.hu" <mingo@elte.hu>,
        "Chen, Tim C" <tim.c.chen@intel.com>,
        "Li, Shaohua" <shaohua.li@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        len.brown@intel.com
In-Reply-To: <1308819748.1022.69.camel@twins>
References: <1308797024.23204.95.camel@debian>
	 <1308819748.1022.69.camel@twins>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 24 Jun 2011 08:41:39 +0800
Message-ID: <1308876099.23204.124.camel@debian>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-06-23 at 17:02 +0800, Peter Zijlstra wrote:
> On Thu, 2011-06-23 at 10:43 +0800, Alex,Shi wrote:
> > commit c8b281161dfa4bb5d5be63fb036ce19347b88c63 causes light load
> > benchmark use more than 10% system power on platform NHM-EP and laptop
> > Thinkpad T410 etc. The benchmarks are specpower and bltk office. 
> > 
> > I tried to track this issue, but only find deep C sate time reduced
> > much, about from 90% to 30~40%, the C0 or C1 state increase much on
> > different machines. 
> > 
> > Powertop just hints RES interrupts has a bit more. but when I try "perf
> > probe native_smp_send_reschedule". I didn't find much. 
> > 
> > I also checked the /proc/schedstat, just can sure the load_balance was
> > called a bit more frequency. but pull_task() was called really rare. 
> > 
> > 
> > The following are the /proc/schedstat increased number in about 300' when do bltk-office. 
> > The getting command is here:
> > #on a 16 LCPU system, with 3 level domain, 0,1,2, so all domain number
> > is 48, the domain statistic number is 2 + 36, so fs=38,
> > 
> > $cat /proc/schedstat > schedstat ; sleep x ; cat /proc/schedstat >>
> > schedstat ; cat schedstat | grep domain | sed '49 i \\n' |  awk -v fs=38
> > 'BEGIN { RS=""; FS=" " } { if ( NR ==1) for (i=0; i<NF; i++)
> > { value1[i]=$i ; } ;  if ( NR ==2) for (i=0; i<NF; i++) { value2[i]=
> > $i } } END {ORS=" ";  for (i=0;i<NF;i++){ if (i%fs == 0)  ll="\n"; else
> > ll=""; print value2[i] - value1[i]  ll  };  print "\n" }'
> 
> /proc/schedstat is already a massive pain to interpret and then you go
> and mangle things even more and expect me to try and understand that
> crap? I don't think so, life is too short.
> 
> > BTW, the imbalance increasing is due to the SCALE increase about 1024. 
> 
> > Any ideas of this? 
> 
> What happens if you try something like the below. Increased imbalance
> might lead to more load-balance action, which might lead to more task
> migration/waking up of cpus etc.
> 
> If the below makes any difference, Nikhil's changes have a funny that
> needs to be caught.

Yes, it most remove the commit effect, So the power recovered. 

In fact the only suspicious I found is large imbalance, but that it is
the commit want to...



