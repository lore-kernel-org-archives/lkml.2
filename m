Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755710Ab2JCGuT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 02:50:19 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:58414 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753260Ab2JCGuR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 02:50:17 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/xgk4WckfxrvaGWQ3MkfwNvY64SgIzozZJHKMfwv
	KpKHqvNuL1aqRC
Message-ID: <1349247011.4465.24.camel@marge.simpson.net>
Subject: Re: Netperf UDP_STREAM regression due to not sending IPIs in
 ttwu_queue()
From: Mike Galbraith <efault@gmx.de>
To: Mel Gorman <mgorman@suse.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        LKML <linux-kernel@vger.kernel.org>
Date: Wed, 03 Oct 2012 08:50:11 +0200
In-Reply-To: <20121002131421.GN29125@suse.de>
References: <20121002065143.GK29125@suse.de>
	 <1349164176.7086.43.camel@marge.simpson.net>
	 <20121002084501.GL29125@suse.de>
	 <1349170282.7086.56.camel@marge.simpson.net>
	 <20121002131421.GN29125@suse.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-10-02 at 14:14 +0100, Mel Gorman wrote: 
> On Tue, Oct 02, 2012 at 11:31:22AM +0200, Mike Galbraith wrote:
> > On Tue, 2012-10-02 at 09:45 +0100, Mel Gorman wrote: 
> > > On Tue, Oct 02, 2012 at 09:49:36AM +0200, Mike Galbraith wrote:
> > 
> > > > Hm, 518cd623 fixed up the troubles I saw.  How exactly are you running
> > > > this?
> > > > 
> > > 
> > > You saw problems with TCP_RR where as this is UDP_STREAM.
> > 
> > Yeah, but I wanted to stare at UDP_STREAM as you run it to see if it
> > would tell me anything about why those numbers happen.
> > 
> > > I'm running this through MMTests with a version of the
> > > configs/config-global-dhp__network-performance file that only runs
> > > netperf-udp. Ultimately it runs netperf for a size something like
> > > this
> > > 
> > > SIZE=64
> > > taskset -c 0 netserver
> > > taskset -c 1 netperf -t UDP_STREAM -i 50,6 -I 99,1 -l 20 -H 127.0.0.1 -- -P 15895 -s 32768 -S 32768 -m $SIZE -M $SIZE
> > 
> 
> lock_stat points at the runqueue lock which makes sense as without the
> IPI the rq->lock has to be taken

Perf top says we're spinning in ttwu() with NO_TTWU_QUEUE.

nohz=off idle=halt, netperf -l bignum vs -i 50,6 -I 99,1 -l 20, watching
with taskset -c 3 perf top -C 1 -U.

Switch rate rises by nearly 200k/s with NO_TTWU_QUEUE, ttwu() climbs to
#1 spot.  Annotate shows while (p->on_cpu) cpu_relax() eating ~50% of
all ttwu() cycles.  Turn TTWU_QUEUE back on, spin evaporates, switch
rate drops, throughput climbs.  Nifty.

-Mike

