Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752734Ab2JBOdl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 10:33:41 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:46064 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750991Ab2JBOdj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 10:33:39 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/oEQA21IjoQbxj4658N8On4ATMb7OLzbSD7794ip
	ulQi1i85D5+gUd
Message-ID: <1349188414.7086.127.camel@marge.simpson.net>
Subject: Re: Netperf UDP_STREAM regression due to not sending IPIs in
 ttwu_queue()
From: Mike Galbraith <efault@gmx.de>
To: Mel Gorman <mgorman@suse.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        LKML <linux-kernel@vger.kernel.org>
Date: Tue, 02 Oct 2012 16:33:34 +0200
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

Well, it'll still be locked, but locally when the IPI queues the wakee.

I can confirm your UDP_STREAM findings.. but do the same cross pin with
tbench, and the story reverses.  A difference is that netperf/netserver
utilization is 100%/63% NO_TTWU_QUEUE and 100%/57% TTWU_QUEUE, ie
netserver is using more cycles with NO_TTWU_QUEUE.

tbench/tbench_srv is around 73%/56%, both sleep vs 1, both take the same
locks in ttwu().. and perform better with NO_TTWU_QUEUE.

Ponder ponder speculate.. what won't happen with TTWU_QUEUE is you won't
contend on the remote lock while a task is trying to schedule off.  We
don't content with tbench or TCP_RR, NO_TTWU_QUEUE is the cheaper.. we
do contend with UDP_STREAM, TTWU_QUEUE _becomes_ the cheaper.  Oh dear.

> 3.3.0-vanilla
>                               class name    con-bounces    contentions   waittime-min   waittime-max waittime-total    acq-bounces   acquisitions   holdtime-min   holdtime-max holdtime-total
> -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
>                                &rq->lock:         37062          37063           0.08          10.43       11037.66      410701252     1029063029           0.00          14.35   234556106.12
>                                ---------
>                                &rq->lock          14064          [<ffffffff81420a76>] __schedule+0xc6/0x710
>                                &rq->lock             33          [<ffffffff8107791d>] idle_balance+0x13d/0x190
>                                &rq->lock          11810          [<ffffffff8106cac7>] ttwu_queue+0x47/0xf0
>                                &rq->lock            283          [<ffffffff81067f86>] task_rq_lock+0x56/0xa0
>                                ---------
>                                &rq->lock          22305          [<ffffffff8106cac7>] ttwu_queue+0x47/0xf0
>                                &rq->lock          11260          [<ffffffff81420a76>] __schedule+0xc6/0x710
>                                &rq->lock            158          [<ffffffff8107791d>] idle_balance+0x13d/0x190
>                                &rq->lock              8          [<ffffffff810772a6>] load_balance+0x356/0x500
> 
> 3.3.0-revert
>                                &rq->lock:         10831          10833           0.09          10.47        4448.19          87877      768253556           0.00          16.00   140103672.33
>                                ---------
>                                &rq->lock            685          [<ffffffff810771d8>] load_balance+0x348/0x500
>                                &rq->lock           8688          [<ffffffff8106d045>] try_to_wake_up+0x215/0x2e0
>                                &rq->lock           1010          [<ffffffff814209b6>] __schedule+0xc6/0x710
>                                &rq->lock            228          [<ffffffff81067f86>] task_rq_lock+0x56/0xa0
>                                ---------
>                                &rq->lock           3317          [<ffffffff814209b6>] __schedule+0xc6/0x710
>                                &rq->lock            789          [<ffffffff810771d8>] load_balance+0x348/0x500
>                                &rq->lock            363          [<ffffffff810770a4>] load_balance+0x214/0x500
>                                &rq->lock              2          [<ffffffff810771e6>] load_balance+0x356/0x500
> 
> Note the difference in acq-bounces. I had to stop at this point and move
> back to some CMA breakage I introduced.
> 


