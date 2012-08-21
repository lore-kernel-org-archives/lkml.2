Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755973Ab2HUJoE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 05:44:04 -0400
Received: from mx2.parallels.com ([64.131.90.16]:41651 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755858Ab2HUJoA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 05:44:00 -0400
Message-ID: <5033579D.5000203@parallels.com>
Date: Tue, 21 Aug 2012 13:40:45 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Michal Hocko <mhocko@suse.cz>
CC: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
        <cgroups@vger.kernel.org>, <devel@openvz.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        <kamezawa.hiroyu@jp.fujitsu.com>, Christoph Lameter <cl@linux.com>,
        David Rientjes <rientjes@google.com>,
        Pekka Enberg <penberg@kernel.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        Suleiman Souhlal <suleiman@google.com>
Subject: Re: [PATCH v2 11/11] protect architectures where THREAD_SIZE >= PAGE_SIZE
 against fork bombs
References: <1344517279-30646-1-git-send-email-glommer@parallels.com> <1344517279-30646-12-git-send-email-glommer@parallels.com> <20120821093513.GD19797@dhcp22.suse.cz>
In-Reply-To: <20120821093513.GD19797@dhcp22.suse.cz>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/21/2012 01:35 PM, Michal Hocko wrote:
> On Thu 09-08-12 17:01:19, Glauber Costa wrote:
>> Because those architectures will draw their stacks directly from the
>> page allocator, rather than the slab cache, we can directly pass
>> __GFP_KMEMCG flag, and issue the corresponding free_pages.
>>
>> This code path is taken when the architecture doesn't define
>> CONFIG_ARCH_THREAD_INFO_ALLOCATOR (only ia64 seems to), and has
>> THREAD_SIZE >= PAGE_SIZE. Luckily, most - if not all - of the remaining
>> architectures fall in this category.
> 
> quick git grep "define *THREAD_SIZE\>" arch says that there is no such
> architecture.
> 
>> This will guarantee that every stack page is accounted to the memcg the
>> process currently lives on, and will have the allocations to fail if
>> they go over limit.
>>
>> For the time being, I am defining a new variant of THREADINFO_GFP, not
>> to mess with the other path. Once the slab is also tracked by memcg, we
>> can get rid of that flag.
>>
>> Tested to successfully protect against :(){ :|:& };:
> 
> I guess there were no other tasks in the same group (except for the
> parent shell), right? 

Yes.

> I am asking because this should trigger memcg-oom
> but that one will usually pick up something else than the fork bomb
> which would have a small memory footprint. But that needs to be handled
> on the oom level obviously.
> 
Sure, but keep in mind that the main protection is against tasks *not*
in this memcg.
