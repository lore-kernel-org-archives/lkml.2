Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752597Ab0LQDGb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 22:06:31 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:55982 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752390Ab0LQDGa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 22:06:30 -0500
Message-ID: <4D0AD3C6.1050905@cn.fujitsu.com>
Date: Fri, 17 Dec 2010 11:06:46 +0800
From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: Jens Axboe <axboe@kernel.dk>, Corrado Zoccolo <czoccolo@gmail.com>,
        Chad Talbott <ctalbott@google.com>, Nauman Rafique <nauman@google.com>,
        Divyesh Shah <dpshah@google.com>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 6/8] blkio-cgroup: "use_hierarchy" interface without any
 functionality.
References: <4CDF7BC5.9080803@cn.fujitsu.com> <4CDF9CC6.2040106@cn.fujitsu.com> <20101115165319.GI30792@redhat.com> <4CE2718C.6010406@kernel.dk> <4D01C6AB.9040807@cn.fujitsu.com> <4D057AA3.8050308@cn.fujitsu.com> <20101215212605.GA10234@redhat.com> <4D097CA2.6000005@cn.fujitsu.com> <20101216154401.GB13870@redhat.com>
In-Reply-To: <20101216154401.GB13870@redhat.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-12-17 11:06:22,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-12-17 11:06:23,
	Serialize complete at 2010-12-17 11:06:23
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal wrote:
> On Thu, Dec 16, 2010 at 10:42:42AM +0800, Gui Jianfeng wrote:
>> Vivek Goyal wrote:
>>> On Mon, Dec 13, 2010 at 09:45:07AM +0800, Gui Jianfeng wrote:
>>>> This patch adds "use_hierarchy" in Root CGroup with out any functionality.
>>>>
>>>> Signed-off-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
>>>> ---
>>>>  block/blk-cgroup.c  |   72 ++++++++++++++++++++++++++++++++++++++++++++++++--
>>>>  block/blk-cgroup.h  |    5 +++-
>>>>  block/cfq-iosched.c |   24 +++++++++++++++++
>>>>  3 files changed, 97 insertions(+), 4 deletions(-)
>>>>
>>>> diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
>>>> index 455768a..9747ebb 100644
>>>> --- a/block/blk-cgroup.c
>>>> +++ b/block/blk-cgroup.c
>>>> @@ -25,7 +25,10 @@
>>>>  static DEFINE_SPINLOCK(blkio_list_lock);
>>>>  static LIST_HEAD(blkio_list);
>>>>  
>>>> -struct blkio_cgroup blkio_root_cgroup = { .weight = 2*BLKIO_WEIGHT_DEFAULT };
>>>> +struct blkio_cgroup blkio_root_cgroup = {
>>>> +		.weight = 2*BLKIO_WEIGHT_DEFAULT,
>>>> +		.use_hierarchy = 1,
>>> Currently flat mode is the default. Lets not change the default. So lets
>>> start with use_hierarchy = 0.
>> OK, will do.
>>
>>> Secondly, why don't you make it per cgroup something along the lines of
>>> memory controller where one can start the hierarchy lower in the cgroup
>>> chain and not necessarily at the root. This way we can avoid some
>>> accounting overhead for all the groups which are non-hierarchical.
>> I'm not sure whether there's a actual use case that needs per cgroup "use_hierarchy".
>> So for first step, I just give a global "use_hierarchy" in root group. If there're
>> some actual requirements that need per cgroup "use_hierarchy". We may add the feature
>> later.
>>
> 
> I think there is some use case. Currently libvirt creates its own cgroups
> for each VM. Depending on what cgroup libvirtd has been placed when it
> started, it starts creating cgroups from there. So depending on distro,
> one might mount blkio controller at /cgroup/blkio by default and then
> libcgroup will create its own cgroups from there.
> 
> Now as of today, default is flat so the packages which takes care of 
> mounting blkio controller, I am not expecting them to suddenly change
> default to using hierarchy. 
> 
> Now if libvirt goes on to create its own cgroups under root cgroup
> (/cgroup/blkio), then libvirt can't switch it to hierarchical even if
> it wants to as children cgroups have already been created under root
> and anyway libvirt is not supposed to control the settings of
> use_hierarchy of root group.
> 
> So if we allow that a hierarchy can be defined from a child node, then
> libvirt can easily do it only for its sub hierarchy.
> 
> 			pivot
> 		       /    \ 
> 		      root  libvirtd 
> 				/ \
> 			      vm1  vm2
> 
> Here root will have use_hierarchy=0 and libvirtd will have use_hierarchy=1
> 
> Secondly, I am beginning to believe that overhead of updating the in 
> all the group of hierarchy might have significant overhead (though I don't
> have the data yet) but you will take blkcg->stats_lock of each cgroup
> in the path for each IO completion and CFQ updates so many stats. So
> there also it might make sense that let libvirtd set use_hierarchy=1
> if it needs to and incur additional overhead but global default will
> not be run with use_hierarchy=1. I think libvirtd mounts memory controller
> as of today with use_hierarchy=0.
> 
> Also I don't think it is lot of extra code to support per cgroup
> use_hierarchy. So to me it makes sense to do it right now. I am more
> concerned about getting it right now because it is part of user interface.
> If we introduce something now and then change it 2 releases town the line
> the we are stuck with one more convetntion of use_hiearchy and support it
> making life even more complicated.
> 
> So I would say that do think through it and it should not be lot of extra
> code to support it.
> 
>>>> +	};
>>>>  EXPORT_SYMBOL_GPL(blkio_root_cgroup);
>>>>  
>>>>  static struct cgroup_subsys_state *blkiocg_create(struct cgroup_subsys *,
>>>> @@ -1385,10 +1388,73 @@ struct cftype blkio_files[] = {
>>>>  #endif
>>>>  };
>>>>  
>>>> +static u64 blkiocg_use_hierarchy_read(struct cgroup *cgroup,
>>>> +				      struct cftype *cftype)
>>>> +{
>>>> +	struct blkio_cgroup *blkcg;
>>>> +
>>>> +	blkcg = cgroup_to_blkio_cgroup(cgroup);
>>>> +	return (u64)blkcg->use_hierarchy;
>>>> +}
>>>> +
>>>> +static int
>>>> +blkiocg_use_hierarchy_write(struct cgroup *cgroup,
>>>> +			    struct cftype *cftype, u64 val)
>>>> +{
>>>> +	struct blkio_cgroup *blkcg;
>>>> +	struct blkio_group *blkg;
>>>> +	struct hlist_node *n;
>>>> +	struct blkio_policy_type *blkiop;
>>>> +
>>>> +	blkcg = cgroup_to_blkio_cgroup(cgroup);
>>>> +
>>>> +	if (val > 1 || !list_empty(&cgroup->children))
>>>> +		return -EINVAL;
>>>> +
>>>> +	if (blkcg->use_hierarchy == val)
>>>> +		return 0;
>>>> +
>>>> +	spin_lock(&blkio_list_lock);
>>>> +	blkcg->use_hierarchy = val;
>>>> +
>>>> +	hlist_for_each_entry(blkg, n, &blkcg->blkg_list, blkcg_node) {
>>>> +		list_for_each_entry(blkiop, &blkio_list, list) {
>>>> +			/*
>>>> +			 * If this policy does not own the blkg, do not change
>>>> +			 * cfq group scheduling mode.
>>>> +			 */
>>>> +			if (blkiop->plid != blkg->plid)
>>>> +				continue;
>>>> +
>>>> +			if (blkiop->ops.blkio_update_use_hierarchy_fn)
>>>> +				blkiop->ops.blkio_update_use_hierarchy_fn(blkg,
>>>> +									  val);
>>> Should we really allow this? I mean allow changing hierarchy of a group
>>> when there are already children groups. I think memory controller does
>>> not allow this. We can design along the same lines. Keep use_hierarchy
>>> as 0 by default. Allow changing it only if there are no children cgroups.
>>> Otherwise we shall have to send notifications to subscribing policies
>>> and then change their structure etc. Lets keep it simple.
>> Yes, I really don't allow changing use_hierarchy if there are childre cgroups.
>> Please consider following line in my patch.
>>
>> if (val > 1 || !list_empty(&cgroup->children))
>> 	return -EINVAL;
> 
> If there are no children cgroups, then there can not be any children blkg
> and there is no need to send any per blkg notification to each policy?

Firsly, In my patch, per blkg notification only happens on root blkg.
Secondly, root cfqg is put onto "flat_service_tree" in flat mode,
where for hierarchical mode, it don't belongs to anybody. When switching, it
has to inform root cfqg to switch onto or switch off "flat_service_tree".

Anyway, If we're going to put root cfqg onto grp_service_tree regardless of
flat or hierarchical mode, this piece of code can be gone.

Thanks,
Gui

> 
> Thanks
> Vivek
> 
