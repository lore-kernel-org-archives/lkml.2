Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934219Ab3AIVUk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 16:20:40 -0500
Received: from mx2.parallels.com ([64.131.90.16]:49034 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933555Ab3AIVUe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 16:20:34 -0500
Message-ID: <50EDDF1E.6010705@parallels.com>
Date: Thu, 10 Jan 2013 01:20:30 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Anton Vorontsov <anton.vorontsov@linaro.org>,
        David Rientjes <rientjes@google.com>,
        Pekka Enberg <penberg@kernel.org>, Mel Gorman <mgorman@suse.de>,
        Michal Hocko <mhocko@suse.cz>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Luiz Capitulino <lcapitulino@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Thelen <gthelen@google.com>,
        Leonid Moiseichuk <leonid.moiseichuk@nokia.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Minchan Kim <minchan@kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        John Stultz <john.stultz@linaro.org>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>, <linaro-kernel@lists.linaro.org>,
        <patches@linaro.org>, <kernel-team@android.com>
Subject: Re: [PATCH 1/2] Add mempressure cgroup
References: <20130104082751.GA22227@lizard.gateway.2wire.net> <1357288152-23625-1-git-send-email-anton.vorontsov@linaro.org> <20130109203731.GA20454@htj.dyndns.org>
In-Reply-To: <20130109203731.GA20454@htj.dyndns.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [46.39.244.6]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/10/2013 12:37 AM, Tejun Heo wrote:
> Hello,
> 
> Can you please cc me too when posting further patches?  I kinda missed
> the whole discussion upto this point.
> 
> On Fri, Jan 04, 2013 at 12:29:11AM -0800, Anton Vorontsov wrote:
>> This commit implements David Rientjes' idea of mempressure cgroup.
>>
>> The main characteristics are the same to what I've tried to add to vmevent
>> API; internally, it uses Mel Gorman's idea of scanned/reclaimed ratio for
>> pressure index calculation. But we don't expose the index to the userland.
>> Instead, there are three levels of the pressure:
>>
>>  o low (just reclaiming, e.g. caches are draining);
>>  o medium (allocation cost becomes high, e.g. swapping);
>>  o oom (about to oom very soon).
>>
>> The rationale behind exposing levels and not the raw pressure index
>> described here: http://lkml.org/lkml/2012/11/16/675
>>
>> For a task it is possible to be in both cpusets, memcg and mempressure
>> cgroups, so by rearranging the tasks it is possible to watch a specific
>> pressure (i.e. caused by cpuset and/or memcg).
> 
> So, cgroup is headed towards single hierarchy.  Dunno how much it
> would affect mempressure but it probably isn't wise to design with
> focus on multiple hierarchies.
> 
> Isn't memory reclaim and oom condition tied to memcgs when memcg is in
> use?  It seems natural to tie mempressure to memcg.  Is there some
> reason this should be a separate cgroup.  I'm kinda worried this is
> headed cpuacct / cpu silliness we have.  Glauber, what's your opinion
> here?
> 

I've already said this in a previous incarnation of this thread. But
I'll summarize my main points:

* I believe this mechanism is superior to memcg notification mechanism.
* I believe memcg notification mechanism is quite coarce - we actually
define the thresholds prior to flushing the stock, which means we can be
wrong by as much as 32 * ncpus.
* Agreeing with you that most of the data will come from memcg, I just
think this should all be part of memcg.
* memcg is indeed expensive even when it is not being used, so global
users would like to avoid it. This is true, but I've already
demonstrated that it is an implementation problem rather than a
conceptual problem, and can be fixed - although I had not yet the time
to go back to it (but now I have a lot less on my shoulders than before)

Given the above, I believe that ideally we should use this pressure
mechanism in memcg replacing the current memcg notification mechanism.
More or less like timer expiration happens: you could still write
numbers for compatibility, but those numbers would be internally mapped
into the levels Anton is proposing, that makes *way* more sense.

If that is not possible, they should coexist as "notification" and a
"pressure" mechanism inside memcg.

The main argument against it centered around cpusets also being able to
participate in the play. I haven't yet understood how would it take
place. In particular, I saw no mention to cpusets in the patches.

I will say again that I fully know memcg is expensive. We all do.
However, it only matters to the global case. For the child cgroup case,
you are *already* paying this anyway. And for the global case, we should
not use the costs of it as an excuse: we should fix it, or otherwise
prove that it is unfixable.


