Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755575Ab2ASWDM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 17:03:12 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:46090 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754134Ab2ASWDL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 17:03:11 -0500
Date: Thu, 19 Jan 2012 14:03:06 -0800
From: Tejun Heo <tj@kernel.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: axboe@kernel.dk, ctalbott@google.com, rni@google.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 11/12] blkcg: kill blkio_policy_node
Message-ID: <20120119220306.GK5198@google.com>
References: <1326935490-11827-1-git-send-email-tj@kernel.org>
 <1326935490-11827-12-git-send-email-tj@kernel.org>
 <20120119203225.GA4421@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120119203225.GA4421@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Jan 19, 2012 at 03:32:25PM -0500, Vivek Goyal wrote:
> On Wed, Jan 18, 2012 at 05:11:29PM -0800, Tejun Heo wrote:
> 
> [..]
> > @@ -1413,14 +1110,10 @@ static int blkio_weight_write(struct blkio_cgroup *blkcg, u64 val)
> >  	spin_lock_irq(&blkcg->lock);
> >  	blkcg->weight = (unsigned int)val;
> >  
> > -	hlist_for_each_entry(blkg, n, &blkcg->blkg_list, blkcg_node) {
> > -		pn = blkio_policy_search_node(blkcg, blkg->dev,
> > -				BLKIO_POLICY_PROP, BLKIO_PROP_weight_device);
> > -		if (pn)
> > -			continue;
> > +	hlist_for_each_entry(blkg, n, &blkcg->blkg_list, blkcg_node)
> > +		if (blkg->plid == plid && !blkg->conf.weight)
> > +			blkio_update_group_weight(blkg, blkcg->weight);
> 
> Tejun,
> 
> Why do we check for blkg->conf.weight=0 here. Even if a group already has
> weight and if user has changed the cgroup weight later, that update should
> be propogated to all the groups on all the queues.

Maybe I misread the code but if explicit per-device config exists,
cgroup-wide writes are ignored, no?  The original code searches for
matching pn and if it exists, continues without updating.

> Where do we assign default cgroup weight to a blkg upon creation? May be at
> group create time, we just need to copy blkcg->weight to blkg.conf.weight.

We don't.  blk->conf.weight is set only on explicit per-device
configuration.  It's gonna be removed eventually after config
definition and handling are moved into policies.

Thanks.

-- 
tejun
