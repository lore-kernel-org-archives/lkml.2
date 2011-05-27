Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752650Ab1E0LWp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 07:22:45 -0400
Received: from mailgw9.se.ericsson.net ([193.180.251.57]:45335 "EHLO
	mailgw9.se.ericsson.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752032Ab1E0LWo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 07:22:44 -0400
X-AuditID: c1b4fb39-b7bfdae000005125-7c-4ddf89834aab
From: Bertil Engelholm <bertil.engelholm@ericsson.com>
To: Mel Gorman <mgorman@suse.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Fri, 27 May 2011 13:22:42 +0200
Subject: RE: PROBLEM: zone_reclaim is hanging high priority real time user
 pthreads
Thread-Topic: PROBLEM: zone_reclaim is hanging high priority real time user
 pthreads
Thread-Index: AcwcW5v+iXwAPGEcRT6Nb1UPmmAeAAAAGYsA
Message-ID: <980E20D8E719A84BBF593FDE6AEC23DA0AEB42A245@ESESSCMS0351.eemea.ericsson.se>
References: <980E20D8E719A84BBF593FDE6AEC23DA0AEB3CFAA7@ESESSCMS0351.eemea.ericsson.se>
 <20110527104823.GA5118@suse.de>
In-Reply-To: <20110527104823.GA5118@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanx for the response. Since a few days back we have tried disabling the 
zone reclaim and the system behaves much better so that seems to be the
short term solution we'll go for.
I also assume that if you have real time pthreads that are sensitive to 
stalls you might have to disable zone reclaim also in later kernels
even though the zone reclaim implementation have been radically improved.

/Bertil 

-----Original Message-----
From: Mel Gorman [mailto:mgorman@suse.de] 
Sent: den 27 maj 2011 12:48
To: Bertil Engelholm
Cc: linux-kernel@vger.kernel.org
Subject: Re: PROBLEM: zone_reclaim is hanging high priority real time user pthreads

On Fri, May 20, 2011 at 03:34:33PM +0200, Bertil Engelholm wrote:
> 
> Hi,
> 
> I have been investigating a problem for several weeks now and at last 
> I beleave I'm on to something. So now I'm hoping that someone has the 
> time to help me answer some questions.
> The problem has been seen in kernel 2.6.16 and I now wonder if this is 
> solved in later kernels. I have looked in the 2.6.39 source code and 
> there was a comment in that code indicating that this could still be a 
> problem even though it's not as serious as in 2.6.16.
> 
> The actual problem I have seen in 2.6.16 is that the zone_reclaim 
> function can execute on several CPU's in parallell in a multi core system.

In 2.6.16, there is a race allowing two or more processes to call zone_reclaim on a single node. Later kernels prevent this with a zone lock. This reduces excessive scanning and excessive reclaim within one node. As a side-effect, processes that contend on the lock will fall back to other nodes and stall less frequently.

> There is a check
> for the reclaim_in_progress counter in zone_reclaim but it takes some 
> time until this counter is increased in shrink_zone so if several 
> CPU's start executing zone_reclaim at the same time they will continue 
> executing shrink_zone etc. in parallell. With a test program we have 
> seen up to 4 CPU's do this in parallell. I have seen two CPU's execute 
> zone_reclaim in parallell in a panic dump that I triggered using 
> sysrq-trigger when our pthread was "hanging". However, this is not a 
> problem functionally wise, it looks like they all do what they are supposed to do.
> 

They would although that is not necessarily what you want either.

> The problem is that the execution time goes up quite a lot when 
> several CPU's execute zone_reclaim. Most likely I guess because they 
> will compete for the same locks etc. Since this is executed in the 
> "context" of any user process/pthread it can "hang" this 
> process/pthread for several seconds while other pthreads etc. continue to execute as normal.

2.6.16 did not have multiple LRUs. This means that if teh system didn't have swap configured for example, it could have to scan excessively (possible all of the node twice) reclaiming a very small number of pages. In later kernels, it would be able to complete faster which would reduce stalls.

> If you have enough allocated memory e.g. 40GB, we have seen hangings 
> for 16 seconds. And this is even though the pthread is a high priority 
> real time scheduled pthread that is suppose to execute every 10 ms 
> (testprogram). Even if you get rid of the parallell execution, I 
> suppose zone_reclaim can still hang a user pthread for some time if 
> you have many active pages and this is what I wonder if it's still valid.
> 
> In later versions of vmscan.c I can see that a lot has changed 
> regarding this code but in shrink_zone in 2.6.39 this comment can be found :
> 
> /*
> * On large memory systems, scan >> priority can become
> * really large. This is fine for the starting priority;
> * we want to put equal scanning pressure on each zone.
> * However, if the VM has a harder time of freeing pages,
> * with multiple processes reclaiming pages, the total
> * freeing target can get unreasonably large.
> */
> 
> This indicates to me that the execution time for shrink_zone can still 
> be relativly long if you have a lot of pages.
> 

Yes.

> So the question is : Can todays kernel also "hang" high priority user 
> pthreads due to zone_reclaim if you have a large system with lots of allocated memory ?

The stall should be significantly lower but still not desirable. If zone_reclaim is being used extensively, it can imply that there is a node imbalance where processes are reclaiming heavily in one node and ignoring others.

> I.e. is this function still executed in a user pthread context risking 
> to hang it for some time ?
> If this has changed so it's executed in another way (background thread 
> or some other way), when was this changed (which kernel version) ?
> 

Disable zone_reclaim. Processes will fall back to using remote nodes while waking kswapd to rebalance the current node. Processes take a hit by using remote nodes for memory accesses but this can be far lower than the time taken to run zone_reclaim.

> OK, that's it. I hope I have managed to make myself understandable.
> As I started I have spent several weeks on this and I just want to 
> make shure that if we recommend a new kernel version to our users that 
> the problem is actually solved in that version. I have searched the 
> internet for many hours for this problem but not been able to find 
> anything that looks like this specific problem.

zone_reclaim is not studied very often and has a tendency to surprise people unfortunately.

> The reason we have such a problem is
> because the pthreads that are hanging is important supervision 
> pthreads (that's why they are high priority real time pthreads) so 
> they must execute at certain intervals otherwise other pthreads will 
> think something is wrong and trigger recovery actions.
> 
> Since I'm not subscribing to this mailing list I would appreciate if 
> you could CC me any response.
> 

If your workload is not tuned to size each process within a given node (very common), I'd suggest disabling zone_reclaim altogether. This sort of problem is typically reported as "all memory is not being used" when the target application is mostly serving files. It's rare people complain about stalls due to zone_reclaim which is probably why you couldn't find any reference in Google.

--
Mel Gorman
SUSE Labs
