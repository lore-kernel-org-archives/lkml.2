Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755263Ab2JEJyP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 05:54:15 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48560 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755217Ab2JEJyO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 05:54:14 -0400
Date: Fri, 5 Oct 2012 10:54:08 +0100
From: Mel Gorman <mgorman@suse.de>
To: Rick Jones <rick.jones2@hp.com>
Cc: Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: Netperf UDP_STREAM regression due to not sending IPIs in
 ttwu_queue()
Message-ID: <20121005095408.GB29125@suse.de>
References: <20121002065143.GK29125@suse.de>
 <1349164176.7086.43.camel@marge.simpson.net>
 <20121002084501.GL29125@suse.de>
 <506B6F59.8060800@hp.com>
 <20121003094732.GQ29125@suse.de>
 <506C7E20.4090103@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <506C7E20.4090103@hp.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 03, 2012 at 11:04:16AM -0700, Rick Jones wrote:
> On 10/03/2012 02:47 AM, Mel Gorman wrote:
> >On Tue, Oct 02, 2012 at 03:48:57PM -0700, Rick Jones wrote:
> >>On 10/02/2012 01:45 AM, Mel Gorman wrote:
> >>
> >>>SIZE=64
> >>>taskset -c 0 netserver
> >>>taskset -c 1 netperf -t UDP_STREAM -i 50,6 -I 99,1 -l 20 -H 127.0.0.1 -- -P 15895 -s 32768 -S 32768 -m $SIZE -M $SIZE
> >>
> >>Just FYI, unless you are running a hacked version of netperf, the
> >>"50" in "-i 50,6" will be silently truncated to 30.
> >>
> >
> >I'm not using a hacked version of netperf. The 50,6 has been there a long
> >time so I'm not sure where I took it from any more. It might have been an
> >older version or me being over-zealous at the time.
> 
> No version has ever gone past 30.  It has been that way since the
> confidence interval code was contributed.  It doesn't change
> anything, so it hasn't messed-up any results.  It would be good to
> fix but not critical.
> 

It's fixed already. I don't know where the 50 came out of in that case.
I was probably thinking "many iterations" at the time without reading
the docs properly.

> >>PS - I trust it is the receive-side throughput being reported/used
> >>with UDP_STREAM :)
> >
> >Good question. Now that I examine the scripts, it is in fact the sending
> >side that is being reported which is flawed. Granted I'm not expecting any
> >UDP loss on loopback and looking through a range of results, the
> >difference is marginal. It's still wrong to report just the sending side
> >for UDP_STREAM and I'll correct the scripts for it in the future.
> 
> Switching from sending to receiving throughput in UDP_STREAM could
> be a non-trivial disconnect in throughputs.  As Eric mentions, the
> receiver could be dropping lots of datagrams if it cannot keep-up,
> and netperf makes not attempt to provide any application-layer
> flow-control.
> 

I'll bear that in mind in the future if there is a sudden change in
throughput and determine if that is because of this send/receive disconnect
or something else. The raw data is recorded in either case so it should
be manageable.

> Not sure which version of netperf you are using to know whether or
> not it has gone to the "omni" code path.  If you aren't using 2.5.0
> or 2.6.0 then the confidence intervals will have been computed based
> on the receive side throughput, so you will at least know that it
> was stable, even if it wasn't the same as the sending side.
> 

I'm using 2.4.5 because there was "no reason" to upgrade. I'll take a
closer look at upgrading soon based on this comment because there is
a possibility that the confidence interval detection is a little
broken in the version I'm using.

> The top of trunk will use the remote's receive stats for the omni
> migration of a UDP_STREAM test too.  I think it is that way in 2.5.0
> and 2.6.0 as well but I've not gone into the repository to check.
> 
> Of course, that means you don't necessarily know that the sending
> throughput met your confidence intervals :)
> 

:)

> If you are on 2.5.0 or later, you may find:
> 
> http://www.netperf.org/svn/netperf2/trunk/doc/netperf.html#Omni-Output-Selection
> 
> helpful when looking to parse results.
> 

Thanks.

> One more, little thing - taskset may indeed be better for what you
> are doing (it will happen "sooner" certainly), but there is also the
> global -T option to bind netperf/netserver to the specified CPU id. http://www.netperf.org/svn/netperf2/trunk/doc/netperf.html#index-g_t_002dT_002c-Global-41
> 

I was aware of the option but had avoided using it as I think when I
worked with taskset inially the option didn't exist.

Thanks a lot Rick for the suggestions, they are very helpful.

-- 
Mel Gorman
SUSE Labs
