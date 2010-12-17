Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756653Ab0LQXDb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 18:03:31 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34118 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756593Ab0LQXD3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 18:03:29 -0500
Date: Fri, 17 Dec 2010 18:03:20 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Cc: Jens Axboe <axboe@kernel.dk>, Corrado Zoccolo <czoccolo@gmail.com>,
        Chad Talbott <ctalbott@google.com>, Nauman Rafique <nauman@google.com>,
        Divyesh Shah <dpshah@google.com>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 6/8] blkio-cgroup: "use_hierarchy" interface without any
 functionality.
Message-ID: <20101217230320.GA2532@redhat.com>
References: <4CDF7BC5.9080803@cn.fujitsu.com>
 <4CDF9CC6.2040106@cn.fujitsu.com>
 <20101115165319.GI30792@redhat.com>
 <4CE2718C.6010406@kernel.dk>
 <4D01C6AB.9040807@cn.fujitsu.com>
 <4D057AA3.8050308@cn.fujitsu.com>
 <20101215212605.GA10234@redhat.com>
 <4D097CA2.6000005@cn.fujitsu.com>
 <20101216154401.GB13870@redhat.com>
 <4D0AD3C6.1050905@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D0AD3C6.1050905@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 17, 2010 at 11:06:46AM +0800, Gui Jianfeng wrote:
[..]
> >>>> +static int
> >>>> +blkiocg_use_hierarchy_write(struct cgroup *cgroup,
> >>>> +			    struct cftype *cftype, u64 val)
> >>>> +{
> >>>> +	struct blkio_cgroup *blkcg;
> >>>> +	struct blkio_group *blkg;
> >>>> +	struct hlist_node *n;
> >>>> +	struct blkio_policy_type *blkiop;
> >>>> +
> >>>> +	blkcg = cgroup_to_blkio_cgroup(cgroup);
> >>>> +
> >>>> +	if (val > 1 || !list_empty(&cgroup->children))
> >>>> +		return -EINVAL;
> >>>> +
> >>>> +	if (blkcg->use_hierarchy == val)
> >>>> +		return 0;
> >>>> +
> >>>> +	spin_lock(&blkio_list_lock);
> >>>> +	blkcg->use_hierarchy = val;
> >>>> +
> >>>> +	hlist_for_each_entry(blkg, n, &blkcg->blkg_list, blkcg_node) {
> >>>> +		list_for_each_entry(blkiop, &blkio_list, list) {
> >>>> +			/*
> >>>> +			 * If this policy does not own the blkg, do not change
> >>>> +			 * cfq group scheduling mode.
> >>>> +			 */
> >>>> +			if (blkiop->plid != blkg->plid)
> >>>> +				continue;
> >>>> +
> >>>> +			if (blkiop->ops.blkio_update_use_hierarchy_fn)
> >>>> +				blkiop->ops.blkio_update_use_hierarchy_fn(blkg,
> >>>> +									  val);
> >>> Should we really allow this? I mean allow changing hierarchy of a group
> >>> when there are already children groups. I think memory controller does
> >>> not allow this. We can design along the same lines. Keep use_hierarchy
> >>> as 0 by default. Allow changing it only if there are no children cgroups.
> >>> Otherwise we shall have to send notifications to subscribing policies
> >>> and then change their structure etc. Lets keep it simple.
> >> Yes, I really don't allow changing use_hierarchy if there are childre cgroups.
> >> Please consider following line in my patch.
> >>
> >> if (val > 1 || !list_empty(&cgroup->children))
> >> 	return -EINVAL;
> > 
> > If there are no children cgroups, then there can not be any children blkg
> > and there is no need to send any per blkg notification to each policy?
> 
> Firsly, In my patch, per blkg notification only happens on root blkg.
> Secondly, root cfqg is put onto "flat_service_tree" in flat mode,
> where for hierarchical mode, it don't belongs to anybody. When switching, it
> has to inform root cfqg to switch onto or switch off "flat_service_tree".
> 
> Anyway, If we're going to put root cfqg onto grp_service_tree regardless of
> flat or hierarchical mode, this piece of code can be gone.
> 

Exactly. Keeping everything on grp_service_tree() both for flat and
hierarchical mode will make sure no root group moving around business
and no notifications when use_hierarchy is set.

Thanks
Vivek
