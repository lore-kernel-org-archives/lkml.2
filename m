Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754698Ab2JBIpP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 04:45:15 -0400
Received: from cantor2.suse.de ([195.135.220.15]:44927 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754414Ab2JBIpI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 04:45:08 -0400
Date: Tue, 2 Oct 2012 09:45:01 +0100
From: Mel Gorman <mgorman@suse.de>
To: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: Netperf UDP_STREAM regression due to not sending IPIs in
 ttwu_queue()
Message-ID: <20121002084501.GL29125@suse.de>
References: <20121002065143.GK29125@suse.de>
 <1349164176.7086.43.camel@marge.simpson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <1349164176.7086.43.camel@marge.simpson.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 02, 2012 at 09:49:36AM +0200, Mike Galbraith wrote:
> On Tue, 2012-10-02 at 07:51 +0100, Mel Gorman wrote: 
> > I'm going through old test results to see could I find any leftover
> > performance regressions that have not yet been fixed (most have at this point
> > or at least changed in such a way to make a plain revert impossible). One
> > major regression still left is with netperf UDP_STREAM regression. Bisection
> > points the finger straight at 518cd623 (sched: Only queue remote wakeups
> > when crossing cache boundaries).  Problem was introduced between 3.2 and
> > 3.3, current kernel still sucks as the following results show.
> > 
> > NETPERF UDP
> >                            3.3.0                 3.3.0                 3.6.0
> >                          vanilla       revert-518cd623               vanilla
> > Tput 64         328.38 (  0.00%)      436.58 ( 32.95%)      312.51 ( -4.83%)
> > Tput 128        661.43 (  0.00%)      869.88 ( 31.52%)      625.70 ( -5.40%)
> > Tput 256       1310.27 (  0.00%)     1724.45 ( 31.61%)     1243.65 ( -5.08%)
> > Tput 1024      5466.85 (  0.00%)     6601.43 ( 20.75%)     4838.86 (-11.49%)
> > Tput 2048     10885.95 (  0.00%)    12694.06 ( 16.61%)     9161.75 (-15.84%)
> > Tput 3312     15930.33 (  0.00%)    19327.67 ( 21.33%)    14106.26 (-11.45%)
> > Tput 4096     18025.47 (  0.00%)    22183.12 ( 23.07%)    16636.01 ( -7.71%)
> > Tput 8192     30076.42 (  0.00%)    37280.86 ( 23.95%)    28575.84 ( -4.99%)
> > Tput 16384    47742.12 (  0.00%)    56123.21 ( 17.55%)    46060.57 ( -3.52%)
> 
> Hm, 518cd623 fixed up the troubles I saw.  How exactly are you running
> this?
> 

You saw problems with TCP_RR where as this is UDP_STREAM.

I'm running this through MMTests with a version of the
configs/config-global-dhp__network-performance file that only runs
netperf-udp. Ultimately it runs netperf for a size something like
this

SIZE=64
taskset -c 0 netserver
taskset -c 1 netperf -t UDP_STREAM -i 50,6 -I 99,1 -l 20 -H 127.0.0.1 -- -P 15895 -s 32768 -S 32768 -m $SIZE -M $SIZE

-- 
Mel Gorman
SUSE Labs
