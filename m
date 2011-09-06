Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755154Ab1IFUXQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 16:23:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37719 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754907Ab1IFUXI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 16:23:08 -0400
Date: Tue, 6 Sep 2011 16:22:32 -0400
From: Don Zickus <dzickus@redhat.com>
To: Vince Weaver <vweaver1@eecs.utk.edu>
Cc: Peter Zijlstra <peterz@infradead.org>, Mike Hommey <mh@glandium.org>,
        linux-kernel@vger.kernel.org
Subject: Re: Problem with perf hardware counters grouping
Message-ID: <20110906202232.GS5795@redhat.com>
References: <20110831085718.GB13884@glandium.org>
 <1314878012.11566.7.camel@twins>
 <alpine.DEB.2.00.1109061538270.24588@cl320.eecs.utk.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1109061538270.24588@cl320.eecs.utk.edu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 06, 2011 at 03:43:09PM -0400, Vince Weaver wrote:
> On Thu, 1 Sep 2011, Peter Zijlstra wrote:
> > 
> > Both those have 4 generic hardware counters, but x86 defaults to
> > enabling the NMI watchdog which takes one, leaving you with 3 (try: echo
> > 0 > /proc/sys/kernel/nmi_watchdog). If you had looked at your dmesg
> > output you'd have found lines like:
> > 
> >   NMI watchdog enabled, takes one hw-pmu counter.
> > 
> > The code can only check if the group as a whole could possibly fit on a
> > PMU, which is where your failure on >4 comes from.
> > 
> > What happens with your >3 case is that while the group is valid and
> > could fit on the PMU, it won't fit at runtime because the NMI watchdog
> > is taking one and won't budge (cpu-pinned counter have precedence over
> > any other kind), effectively starving your group of pmu runtime.
> > 
> > Also, we should fix that return to say -EINVAL or so.
> 
> So any hope of a fix on this?  
> 
> As mentioned this is a serious problem for PAPI and I am trying to find a 
> good way to enable a workaround in a way that doesn't punish people who 
> have the watchdog disabled.
> 
> Is there a "stable" API method of determining if the nmi_watchdog is 
> present and stealing a perf-counter?  
> 
> If I find a "1" in /proc/sys/kernel/nmi_watchdog can I assume a counter is 
> being stolen?

Short answer: yes

Long answer: all that means is the nmi_watchdog is running on some
counter, hopefully the hardware based performance counters.  In some rare
cases where the hardware isn't available it may fallback to software based
counters.  But if the hardware isn't available, I think PAPI will have
bigger issues than the nmi_watchdog. :-)

Cheers,
Don
