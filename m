Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752233Ab2GDNQl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 09:16:41 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:53334 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751230Ab2GDNQi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 09:16:38 -0400
Date: Wed, 4 Jul 2012 15:16:31 +0200
From: Johannes Weiner <hannes@cmpxchg.org>
To: Glauber Costa <glommer@parallels.com>
Cc: Wanpeng Li <liwp.linux@gmail.com>, Michal Hocko <mhocko@suse.cz>,
        Balbir Singh <bsingharora@gmail.com>,
        AndrewMorton <akpm@linux-foundation.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Mike Frysinger <vapier@gentoo.org>, Arun Sharma <asharma@fb.com>,
        linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Subject: Re: [PATCH 1/5 v2] memcg: replace unsigned long by u64 to avoid
 overflow
Message-ID: <20120704131631.GD7881@cmpxchg.org>
References: <1340604266-7937-1-git-send-email-liwp.linux@gmail.com>
 <20120625075215.GW27816@cmpxchg.org>
 <4FE82193.1070307@jp.fujitsu.com>
 <20120704122427.GA21598@kernel>
 <4FF4373C.8020100@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FF4373C.8020100@parallels.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 04, 2012 at 04:29:48PM +0400, Glauber Costa wrote:
> On 07/04/2012 04:24 PM, Wanpeng Li wrote:
> > On Mon, Jun 25, 2012 at 05:30:11PM +0900, Kamezawa Hiroyuki wrote:
> >> (2012/06/25 16:52), Johannes Weiner wrote:
> >>> On Mon, Jun 25, 2012 at 02:04:20PM +0800, Wanpeng Li wrote:
> >>>> Changlog:
> >>>>
> >>>> V2 -> V1:
> >>>> * fix zone_page_state()::/include/linux/vmstat.h returns 'unsigned long'
> >>>>
> >>>> From: Wanpeng Li <liwp@linux.vnet.ibm.com>
> >>>>
> >>>> Since the return value variable in mem_cgroup_zone_nr_lru_pages and
> >>>> mem_cgroup_node_nr_lru_pages functions are u64, so replace the return
> >>>> value of funtions by u64 to avoid overflow.
> >>>>
> >>>> Signed-off-by: Wanpeng Li <liwp.linux@gmail.com>
> >>>> ---
> >>>>  include/linux/vmstat.h |    2 +-
> >>>>  mm/memcontrol.c        |    5 ++---
> >>>>  2 files changed, 3 insertions(+), 4 deletions(-)
> >>>>
> >>>> diff --git a/include/linux/vmstat.h b/include/linux/vmstat.h
> >>>> index 65efb92..6a14291 100644
> >>>> --- a/include/linux/vmstat.h
> >>>> +++ b/include/linux/vmstat.h
> >>>> @@ -106,7 +106,7 @@ static inline unsigned long global_page_state(enum zone_stat_item item)
> >>>>  	return x;
> >>>>  }
> >>>>
> >>>> -static inline unsigned long zone_page_state(struct zone *zone,
> >>>> +static inline u64 zone_page_state(struct zone *zone,
> >>>>  					enum zone_stat_item item)
> >>>>  {
> >>>>  	long x = atomic_long_read(&zone->vm_stat[item]);
> >>>
> >>> We established that there is no known reason to use ulong for page
> >>> counters and that IF YOU HAD ONE, you should obviously say so and then
> >>> do a wholesale conversion.  But I don't think you have one.
> >>>
> >>> This patch makes absolutely no sense.
> >>>
> >> I agree. Then, Nack from me.
> >>
> >> Thanks,
> >> -Kame
> > 
> > static unsigned long
> > mem_cgroup_node_nr_lru_pages(struct mem_cgroup *memcg,
> > 			int nid, unsigned int lru_mask)
> > {
> > 	u64 total = 0;
> > 	int zid;
> > 
> > 	for (zid = 0; zid < MAX_NR_ZONES; zid++)
> > 		total += mem_cgroup_zone_nr_lru_pages(memcg,
> > 					    nid, zid, lru_mask);
> > 
> > 	return total;
> > }
> > 
> > Since you use unsigned long to caculate nr_pages and unsigned long long
> > to caculate bytes, so u64 in function mem_cgroup_node_nr_lru_pages should 
> > replace by unsigned long to save kernel stack, right?
> 
> How many bytes do you intend to save by replacing "u64" with "unsigned
> long" ? Have you asked yourself this question ?

I think fixing these types is a good thing.  Not for their memory
savings but to clarify the code.  Otherwise, people will scratch their
heads and waste time over whether there is something that requires the
counter to be 64-bit on a 32-bit system when really there isn't.
