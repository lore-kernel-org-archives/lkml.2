Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932355Ab0FOTkp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 15:40:45 -0400
Received: from hera.kernel.org ([140.211.167.34]:51890 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754047Ab0FOTko (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 15:40:44 -0400
Message-ID: <4C17D6EF.8090003@kernel.org>
Date: Tue, 15 Jun 2010 21:39:27 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
CC: Andrew Morton <akpm@linux-foundation.org>, mingo@elte.hu, awalls@radix.net,
       linux-kernel@vger.kernel.org, jeff@garzik.org, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       johannes@sipsolutions.net, oleg@redhat.com, axboe@kernel.dk
Subject: Re: [PATCHSET] workqueue: concurrency managed workqueue, take#5
References: <1276551467-21246-1-git-send-email-tj@kernel.org> <20100614145839.8ac7687a.akpm@linux-foundation.org> <4C17C353.80708@s5r6.in-berlin.de>
In-Reply-To: <4C17C353.80708@s5r6.in-berlin.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 15 Jun 2010 19:39:38 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 06/15/2010 08:15 PM, Stefan Richter wrote:
>>From what I understood, this is about the following:
> 
>   - Right now, a workqueue is backed by either 1 or by #_of_CPUs
>     kernel threads.  There is no other option.
> 
>   - To avoid creating half a million of kernel threads, driver authors
>     resort to either
>        - using the globally shared workqueue even if they might queue
>          high-latency work in corner cases,
>     or
>        - creating a single-threaded workqueue even if they put unrelated
>          jobs into that queue that should better be executed in
>          parallel, not serially.
>     (I for one have both cases in drivers/firewire/, and I have similar
>     issues in the old drivers/ieee1394/.)
> 
> The cmwq patch series reforms workqueues to be backed by a global thread
> pool.  Hence:
> 
>   + Driver authors can and should simply register one queue for any one
>     purpose now.  They don't need to worry anymore about having too many
>     or too few backing threads.

Wq now serves more as a flushing and max-inflight controlling domain,
so unless it needs to flush the workqueue (as opposed to each work) or
throttle max-inflight or might be used during allocation path (in
which case emergency worker should also be used), default wq should
work fine too.

>   + [A side effect:  In some cases, a driver that currently uses a
>     thread pool can be simplified by migrating to the workqueue API.]
> 
> Tejun, please correct me if I misunderstood.

Yeap, from driver's POV, mostly precise.  The reason I started this
whole thing is that I was trying to implement in-kernel media presence
polling (mostly for cdroms but may also useful for polling other stuff
for other types of devices) and I got immediately stuck on how to
manage concurrency.

I can create single kthread per drive which should work fine in most
cases but there are configurations with a lot of devices and it's not
only wasteful but might actually cause scalability issues.  For most
common cases, ST or MT wq could be enough but then again when
something gets stuck (unfortunately somewhat common with cheap
drives), the whole thing will get stuck.  So, I was thinking about
creating a worker pool for it and managing concurrency, which felt
very silly.  I just needed some context to host those pollings on
demand and this is not something I should be worrying about when I'm
trying to implement media presence polling.

I think there are many similar situations for drivers.  I already
wrote about libata but it's just silly to worry about how to manage
execution contexts for polling PIO, EH and hotplug from individual
drivers and drivers often have to make suboptimal choices because it's
not worth solving fully at that layer.  So, cmwq tries to provide an
easy way to get hold of execution contexts on demand.

Thanks.

-- 
tejun
