Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754724Ab2FDPjh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 11:39:37 -0400
Received: from mga03.intel.com ([143.182.124.21]:47336 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751374Ab2FDPjg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 11:39:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="151363804"
Message-ID: <4FCCD6B7.4030703@linux.intel.com>
Date: Mon, 04 Jun 2012 08:39:35 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Vladimir Davydov <vdavydov@parallels.com>, Ingo Molnar <mingo@elte.hu>,
        Len Brown <lenb@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cpuidle: menu: use nr_running instead of cpuload for
 calculating perf mult
References: <1338805485-10874-1-git-send-email-vdavydov@parallels.com>    <1338805967.28282.12.camel@twins> <4FCCB486.4040905@linux.intel.com>   <1338817519.28282.54.camel@twins> <4FCCBC97.8060101@linux.intel.com>  <1338822509.28282.65.camel@twins> <4FCCD0CD.8080700@linux.intel.com> <1338823568.28282.79.camel@twins>
In-Reply-To: <1338823568.28282.79.camel@twins>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/4/2012 8:26 AM, Peter Zijlstra wrote:
> On Mon, 2012-06-04 at 08:14 -0700, Arjan van de Ven wrote:
>> On 6/4/2012 8:08 AM, Peter Zijlstra wrote:
>>> On Mon, 2012-06-04 at 06:48 -0700, Arjan van de Ven wrote:
>>>> it's not about busy, it's about performance sensitive.
>>>> it's not a super nice proxy, no argument, but it's one of the few long
>>>> term ones we have.
>>>>
>>> I'm still not seeing how it makes any sense at all. Is there an actual
>>> workload here this matters?
>>
>> yes there are, mostly server ones.
> 
> OK, so pick one that cares, and try creating a heuristic based on wakeup
> history or whatever.

sounds easy. is not.

> 
>> the problem isn't an individual idle, it's that the 100us-200us
>> latencies add up if you go in and out repeatedly, when the system is in
>> a situation where it is sensitive to performance (which is not an
>> instant thing, this is a "over the long run we're busy" thing)...
>> ... they become a real factor.
> 
> Right, but since you're inflating idle time, the work will be displaced
> and will complete later. This should result in your idle time est
> shrinking.

hmm I think you're missing the whole point.


> 
> I'm just not buying load actually matters or works, if there's lots of
> idle time load history should be low, if there's not a lot of idle time,
> you're busy (per definition) and again load isn't important.

if there is a lot of idle, load can be low or high; load is more than
just cpu usage. it includes waiting for resources and mutexes etc.

if load is low, you are idle, sure (in that direction it works). If load
is low, the heuristic that is used here will not hinder a deep C state
choice.

if there is not a lot of idle time, sure, load is high. but because idle
time tends to be bursty, we can still be idle for, say, a millisecond
every 10 milliseconds. In this scenario, the load average is used to
ensure that the 200 usecond cost of exiting idle is acceptable.


one other way of doing this would be tracking cumulative accrued latency
as a percentage of cpu busy time... but that's also a pretty
approximative measure.
