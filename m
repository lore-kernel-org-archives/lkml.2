Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935571Ab2JaNSR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 09:18:17 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48789 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935519Ab2JaNSP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 09:18:15 -0400
Date: Wed, 31 Oct 2012 14:18:10 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Lai Jiangshan <laijs@cn.fujitsu.com>, Wen Congyang <wency@cn.fujitsu.com>
Cc: Mel Gorman <mgorman@suse.de>, David Rientjes <rientjes@google.com>,
        LKML <linux-kernel@vger.kernel.org>, x86 maintainers <x86@kernel.org>,
        Jiang Liu <jiang.liu@huawei.com>,
        Rusty Russell <rusty@rustcorp.com.au>, Yinghai Lu <yinghai@kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Yasuaki ISIMATU <isimatu.yasuaki@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Balbir Singh <bsingharora@gmail.com>, Tejun Heo <tj@kernel.org>,
        Li Zefan <lizefan@huawei.com>, cgroups@vger.kernel.org,
        linux-mm@kvack.org, containers@lists.linux-foundation.org,
        Christoph Lameter <cl@linux.com>, Hillf Danton <dhillf@gmail.com>
Subject: Re: [V5 PATCH 08/26] memcontrol: use N_MEMORY instead N_HIGH_MEMORY
Message-ID: <20121031131810.GA27381@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5090CD48.30604@cn.fujitsu.com>
 <1351524078-20363-7-git-send-email-laijs@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 31-10-12 15:03:36, Wen Congyang wrote:
> At 10/30/2012 04:46 AM, David Rientjes Wrote:
> > On Mon, 29 Oct 2012, Lai Jiangshan wrote:
[...]
> >> In one word, we need a N_MEMORY. We just intrude it as an alias to
> >> N_HIGH_MEMORY and fix all im-proper usages of N_HIGH_MEMORY in late patches.
> >>
> > 
> > If this is really that problematic (and it appears it's not given that 
> > there are many use cases of it and people tend to get it right), then why 
> > not simply rename N_HIGH_MEMORY instead of introducing yet another 
> > nodemask to the equation?
> 
> The reason is that we need a node which only contains movable memory. This
> feature is very important for node hotplug. So we will add a new nodemask
> for movable memory. N_MEMORY contains movable memory but N_HIGH_MEMORY
> doesn't contain it.

OK, so the N_MOVABLE_MEMORY (or how you will call it) requires that all
the allocations will be migrateable?
How do you want to achieve that with the page_cgroup descriptors? (see
bellow)

On Mon 29-10-12 23:20:58, Lai Jiangshan wrote:
[...]
> diff --git a/mm/page_cgroup.c b/mm/page_cgroup.c
> index 5ddad0c..c1054ad 100644
> --- a/mm/page_cgroup.c
> +++ b/mm/page_cgroup.c
> @@ -271,7 +271,7 @@ void __init page_cgroup_init(void)
>  	if (mem_cgroup_disabled())
>  		return;
>  
> -	for_each_node_state(nid, N_HIGH_MEMORY) {
> +	for_each_node_state(nid, N_MEMORY) {
>  		unsigned long start_pfn, end_pfn;
>  
>  		start_pfn = node_start_pfn(nid);

This will call init_section_page_cgroup(pfn, nid) later which allocates
page_cgroup descriptors which are not movable. Or is there any code in
your patchset that handles this?
-- 
Michal Hocko
SUSE Labs
