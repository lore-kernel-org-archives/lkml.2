Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757324Ab1IAL7n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 07:59:43 -0400
Received: from vuizook.err.no ([85.19.221.46]:44680 "EHLO vuizook.err.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757191Ab1IAL7m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 07:59:42 -0400
Date: Thu, 1 Sep 2011 13:59:35 +0200
From: Mike Hommey <mh@glandium.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Problem with perf hardware counters grouping
Message-ID: <20110901115935.GA19550@glandium.org>
References: <20110831085718.GB13884@glandium.org>
 <1314878012.11566.7.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1314878012.11566.7.camel@twins>
X-GPG-Fingerprint: A479 A824 265C B2A5 FC54  8D1E DE4B DA2C 54FD 2A58
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 01, 2011 at 01:53:32PM +0200, Peter Zijlstra wrote:
> On Wed, 2011-08-31 at 10:57 +0200, Mike Hommey wrote:
> > I'm having two different problems with perf hardware counters with a
> > group leader:
> > - perf_event_open()ing more than 3 makes all of them always return a
> >   value of 0;
> > - perf_event_open()ing more than 4 fails with ENOSPC. 
> 
> 
> I'm guessing you're running on something x86, either AMD-Fam10-12 or
> Intel-NHM+.

Core2Duo

> Both those have 4 generic hardware counters, but x86 defaults to
> enabling the NMI watchdog which takes one, leaving you with 3 (try: echo
> 0 > /proc/sys/kernel/nmi_watchdog). If you had looked at your dmesg
> output you'd have found lines like:
> 
>   NMI watchdog enabled, takes one hw-pmu counter.

Indeed, that shows up.

> The code can only check if the group as a whole could possibly fit on a
> PMU, which is where your failure on >4 comes from.
> 
> What happens with your >3 case is that while the group is valid and
> could fit on the PMU, it won't fit at runtime because the NMI watchdog
> is taking one and won't budge (cpu-pinned counter have precedence over
> any other kind), effectively starving your group of pmu runtime.

That makes sense. But how exactly is not using groups different, then?
perf, for instance doesn't use groups, and can get all the hardware
counters.

Mike
