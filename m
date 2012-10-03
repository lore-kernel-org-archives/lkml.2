Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933110Ab2JCSET (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 14:04:19 -0400
Received: from g1t0027.austin.hp.com ([15.216.28.34]:29364 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933032Ab2JCSER (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 14:04:17 -0400
Message-ID: <506C7E20.4090103@hp.com>
Date: Wed, 03 Oct 2012 11:04:16 -0700
From: Rick Jones <rick.jones2@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Mel Gorman <mgorman@suse.de>
CC: Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Richard Jones <rick.jones2@hp.com>
Subject: Re: Netperf UDP_STREAM regression due to not sending IPIs in ttwu_queue()
References: <20121002065143.GK29125@suse.de> <1349164176.7086.43.camel@marge.simpson.net> <20121002084501.GL29125@suse.de> <506B6F59.8060800@hp.com> <20121003094732.GQ29125@suse.de>
In-Reply-To: <20121003094732.GQ29125@suse.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/03/2012 02:47 AM, Mel Gorman wrote:
> On Tue, Oct 02, 2012 at 03:48:57PM -0700, Rick Jones wrote:
>> On 10/02/2012 01:45 AM, Mel Gorman wrote:
>>
>>> SIZE=64
>>> taskset -c 0 netserver
>>> taskset -c 1 netperf -t UDP_STREAM -i 50,6 -I 99,1 -l 20 -H 127.0.0.1 -- -P 15895 -s 32768 -S 32768 -m $SIZE -M $SIZE
>>
>> Just FYI, unless you are running a hacked version of netperf, the
>> "50" in "-i 50,6" will be silently truncated to 30.
>>
>
> I'm not using a hacked version of netperf. The 50,6 has been there a long
> time so I'm not sure where I took it from any more. It might have been an
> older version or me being over-zealous at the time.

No version has ever gone past 30.  It has been that way since the 
confidence interval code was contributed.  It doesn't change anything, 
so it hasn't messed-up any results.  It would be good to fix but not 
critical.

>> PS - I trust it is the receive-side throughput being reported/used
>> with UDP_STREAM :)
>
> Good question. Now that I examine the scripts, it is in fact the sending
> side that is being reported which is flawed. Granted I'm not expecting any
> UDP loss on loopback and looking through a range of results, the
> difference is marginal. It's still wrong to report just the sending side
> for UDP_STREAM and I'll correct the scripts for it in the future.

Switching from sending to receiving throughput in UDP_STREAM could be a 
non-trivial disconnect in throughputs.  As Eric mentions, the receiver 
could be dropping lots of datagrams if it cannot keep-up, and netperf 
makes not attempt to provide any application-layer flow-control.

Not sure which version of netperf you are using to know whether or not 
it has gone to the "omni" code path.  If you aren't using 2.5.0 or 2.6.0 
then the confidence intervals will have been computed based on the 
receive side throughput, so you will at least know that it was stable, 
even if it wasn't the same as the sending side.

The top of trunk will use the remote's receive stats for the omni 
migration of a UDP_STREAM test too.  I think it is that way in 2.5.0 and 
2.6.0 as well but I've not gone into the repository to check.

Of course, that means you don't necessarily know that the sending 
throughput met your confidence intervals :)

If you are on 2.5.0 or later, you may find:

http://www.netperf.org/svn/netperf2/trunk/doc/netperf.html#Omni-Output-Selection

helpful when looking to parse results.

One more, little thing - taskset may indeed be better for what you are 
doing (it will happen "sooner" certainly), but there is also the global 
-T option to bind netperf/netserver to the specified CPU id. 
http://www.netperf.org/svn/netperf2/trunk/doc/netperf.html#index-g_t_002dT_002c-Global-41

happy benchmarking,

rick jones
