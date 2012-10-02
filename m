Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753912Ab2JBNO1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 09:14:27 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56696 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753661Ab2JBNO0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 09:14:26 -0400
Date: Tue, 2 Oct 2012 14:14:21 +0100
From: Mel Gorman <mgorman@suse.de>
To: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: Netperf UDP_STREAM regression due to not sending IPIs in
 ttwu_queue()
Message-ID: <20121002131421.GN29125@suse.de>
References: <20121002065143.GK29125@suse.de>
 <1349164176.7086.43.camel@marge.simpson.net>
 <20121002084501.GL29125@suse.de>
 <1349170282.7086.56.camel@marge.simpson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <1349170282.7086.56.camel@marge.simpson.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 02, 2012 at 11:31:22AM +0200, Mike Galbraith wrote:
> On Tue, 2012-10-02 at 09:45 +0100, Mel Gorman wrote: 
> > On Tue, Oct 02, 2012 at 09:49:36AM +0200, Mike Galbraith wrote:
> 
> > > Hm, 518cd623 fixed up the troubles I saw.  How exactly are you running
> > > this?
> > > 
> > 
> > You saw problems with TCP_RR where as this is UDP_STREAM.
> 
> Yeah, but I wanted to stare at UDP_STREAM as you run it to see if it
> would tell me anything about why those numbers happen.
> 
> > I'm running this through MMTests with a version of the
> > configs/config-global-dhp__network-performance file that only runs
> > netperf-udp. Ultimately it runs netperf for a size something like
> > this
> > 
> > SIZE=64
> > taskset -c 0 netserver
> > taskset -c 1 netperf -t UDP_STREAM -i 50,6 -I 99,1 -l 20 -H 127.0.0.1 -- -P 15895 -s 32768 -S 32768 -m $SIZE -M $SIZE
> 

lock_stat points at the runqueue lock which makes sense as without the
IPI the rq->lock has to be taken

3.3.0-vanilla
                              class name    con-bounces    contentions   waittime-min   waittime-max waittime-total    acq-bounces   acquisitions   holdtime-min   holdtime-max holdtime-total
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
                               &rq->lock:         37062          37063           0.08          10.43       11037.66      410701252     1029063029           0.00          14.35   234556106.12
                               ---------
                               &rq->lock          14064          [<ffffffff81420a76>] __schedule+0xc6/0x710
                               &rq->lock             33          [<ffffffff8107791d>] idle_balance+0x13d/0x190
                               &rq->lock          11810          [<ffffffff8106cac7>] ttwu_queue+0x47/0xf0
                               &rq->lock            283          [<ffffffff81067f86>] task_rq_lock+0x56/0xa0
                               ---------
                               &rq->lock          22305          [<ffffffff8106cac7>] ttwu_queue+0x47/0xf0
                               &rq->lock          11260          [<ffffffff81420a76>] __schedule+0xc6/0x710
                               &rq->lock            158          [<ffffffff8107791d>] idle_balance+0x13d/0x190
                               &rq->lock              8          [<ffffffff810772a6>] load_balance+0x356/0x500

3.3.0-revert
                               &rq->lock:         10831          10833           0.09          10.47        4448.19          87877      768253556           0.00          16.00   140103672.33
                               ---------
                               &rq->lock            685          [<ffffffff810771d8>] load_balance+0x348/0x500
                               &rq->lock           8688          [<ffffffff8106d045>] try_to_wake_up+0x215/0x2e0
                               &rq->lock           1010          [<ffffffff814209b6>] __schedule+0xc6/0x710
                               &rq->lock            228          [<ffffffff81067f86>] task_rq_lock+0x56/0xa0
                               ---------
                               &rq->lock           3317          [<ffffffff814209b6>] __schedule+0xc6/0x710
                               &rq->lock            789          [<ffffffff810771d8>] load_balance+0x348/0x500
                               &rq->lock            363          [<ffffffff810770a4>] load_balance+0x214/0x500
                               &rq->lock              2          [<ffffffff810771e6>] load_balance+0x356/0x500

Note the difference in acq-bounces. I had to stop at this point and move
back to some CMA breakage I introduced.

-- 
Mel Gorman
SUSE Labs
