Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755917Ab2JPTDC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 15:03:02 -0400
Received: from mx2.parallels.com ([64.131.90.16]:60346 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755883Ab2JPTC7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 15:02:59 -0400
Message-ID: <507DAF56.9010403@parallels.com>
Date: Tue, 16 Oct 2012 23:02:46 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Christoph Lameter <cl@linux.com>
CC: <linux-mm@kvack.org>, <cgroups@vger.kernel.org>,
        Mel Gorman <mgorman@suse.de>, Tejun Heo <tj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>,
        <kamezawa.hiroyu@jp.fujitsu.com>, David Rientjes <rientjes@google.com>,
        Pekka Enberg <penberg@kernel.org>, <devel@openvz.org>,
        <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@redhat.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        Suleiman Souhlal <suleiman@google.com>
Subject: Re: [PATCH v5 14/14] Add documentation about the kmem controller
References: <1350382611-20579-1-git-send-email-glommer@parallels.com> <1350382611-20579-15-git-send-email-glommer@parallels.com> <0000013a6ad26c73-d043cf97-c44a-45c1-9cae-0a962e93a005-000000@email.amazonses.com>
In-Reply-To: <0000013a6ad26c73-d043cf97-c44a-45c1-9cae-0a962e93a005-000000@email.amazonses.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [46.39.244.6]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/16/2012 10:25 PM, Christoph Lameter wrote:
> On Tue, 16 Oct 2012, Glauber Costa wrote:
> 
>>
>> + memory.kmem.limit_in_bytes      # set/show hard limit for kernel memory
>> + memory.kmem.usage_in_bytes      # show current kernel memory allocation
>> + memory.kmem.failcnt             # show the number of kernel memory usage hits limits
>> + memory.kmem.max_usage_in_bytes  # show max kernel memory usage recorded
> 
> Does it actually make sense to limit kernel memory? 

Yes.

> The user generally has
> no idea how much kernel memory a process is using and kernel changes can
> change the memory footprint. Given the fuzzy accounting in the kernel a
> large cache refill (if someone configures the slab batch count to be
> really big f.e.) can account a lot of memory to the wrong cgroup. The
> allocation could fail.
> 

It heavily depends on the type of the user. The user may not know how
much kernel memory precisely will be used, but he/she usually knows
quite well that it shouldn't be all cgroups together shouldn't use more
than available in the system.

IOW: It is usually safe to overcommit user memory, but not kernel
memory. This is absolutely crucial in any high-density container host,
and we've been doing this in OpenVZ for ages (in an uglier form than this)

> Limiting the total memory use of a process (U+K) would make more sense I
> guess. Only U is probably sufficient? In what way would a limitation on
> kernel memory in use be good?
> 

The kmem counter is also fed into the u counter. If the limit value of
"u" is equal or greater than "k", this is actually what you are doing.

For a lot of application yes, only U is sufficient. This is the default,
btw, since "k" is only even accounted if you set the limit.

All those use cases are detailed a bit below in this file.

A limitation of kernel memory use would be good, for example, to prevent
abuse from non-trusted containers in a high density, shared, container
environment.



