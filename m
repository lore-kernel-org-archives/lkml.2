Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753844Ab2LLLXe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 06:23:34 -0500
Received: from cantor2.suse.de ([195.135.220.15]:58361 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753257Ab2LLLXc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 06:23:32 -0500
Date: Wed, 12 Dec 2012 12:23:29 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Xishi Qiu <qiuxishi@huawei.com>
Cc: Jianguo Wu <wujianguo@huawei.com>, tj@kernel.org, lizefan@huawei.com,
        aneesh.kumar@linux.vnet.ibm.com,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Liujiang <jiang.liu@huawei.com>, dhillf@gmail.com,
        Jiang Liu <liuj97@gmail.com>, Hanjun Guo <guohanjun@huawei.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org
Subject: Re: [PATCH] mm/hugetlb: create hugetlb cgroup file in hugetlb_init
Message-ID: <20121212112329.GE32081@dhcp22.suse.cz>
References: <50C83F97.3040009@huawei.com>
 <20121212101917.GD32081@dhcp22.suse.cz>
 <50C85FFD.10305@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50C85FFD.10305@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 12-12-12 18:44:13, Xishi Qiu wrote:
> On 2012/12/12 18:19, Michal Hocko wrote:
> 
> > On Wed 12-12-12 16:25:59, Jianguo Wu wrote:
> >> Build kernel with CONFIG_HUGETLBFS=y,CONFIG_HUGETLB_PAGE=y
> >> and CONFIG_CGROUP_HUGETLB=y, then specify hugepagesz=xx boot option,
> >> system will boot fail.
> >>
> >> This failure is caused by following code path:
> >> setup_hugepagesz
> >> 	hugetlb_add_hstate
> >> 		hugetlb_cgroup_file_init
> >> 			cgroup_add_cftypes
> >> 				kzalloc <--slab is *not available* yet
> >>
> >> For this path, slab is not available yet, so memory allocated will be
> >> failed, and cause WARN_ON() in hugetlb_cgroup_file_init().
> >>
> >> So I move hugetlb_cgroup_file_init() into hugetlb_init().
> > 
> > I do not think this is a good idea. hugetlb_init is in __init section as
> > well so what guarantees that the slab is initialized by then? Isn't this
> > just a good ordering that makes this working?
> 
> Hi Michal,
> 
> __initcall functions will be called in
> start_kernel()
> 	rest_init()  // -> slab is already
> 		kernel_init()
> 			kernel_init_freeable()
> 				do_basic_setup()
> 					do_initcalls()
> 
> and setup_hugepagesz() will be called in
> start_kernel()
> 	parse_early_param()  // -> before mm_init() -> kmem_cache_init()
> 
> Is this right?

Yes this is right. I just noticed that kmem_cache_init_late is an __init
function as well and didn't realize it is called directly. Sorry about
the confusion.
Anyway I still think it would be a better idea to move the call into the
hugetlb_cgroup_create callback where it is more logical IMO but now that
I'm looking at other controllers (blk and kmem.tcp) they all do this from
init calls as well. So it doesn't make sense to have hugetlb behave
differently.

So
Acked-by: Michal Hocko <mhocko@suse.cz>

Thanks!
-- 
Michal Hocko
SUSE Labs
