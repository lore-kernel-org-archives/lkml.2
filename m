Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756666Ab3AHQQK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 11:16:10 -0500
Received: from mx1.redhat.com ([209.132.183.28]:35856 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756527Ab3AHQQI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 11:16:08 -0500
Date: Tue, 8 Jan 2013 11:16:00 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: lizefan@huawei.com, axboe@kernel.dk, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        ctalbott@google.com, rni@google.com
Subject: Re: [PATCH 13/24] cfq-iosched: implement hierarchy-ready cfq_group
 charge scaling
Message-ID: <20130108161600.GD29635@redhat.com>
References: <1356726946-26037-1-git-send-email-tj@kernel.org>
 <1356726946-26037-14-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1356726946-26037-14-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 28, 2012 at 12:35:35PM -0800, Tejun Heo wrote:
> Currently, cfqg charges are scaled directly according to cfqg->weight.
> Regardless of the number of active cfqgs or the amount of active
> weights, a given weight value always scales charge the same way.  This
> works fine as long as all cfqgs are treated equally regardless of
> their positions in the hierarchy, which is what cfq currently
> implements.  It can't work in hierarchical settings because the
> interpretation of a given weight value depends on where the weight is
> located in the hierarchy.
> 
> This patch reimplements cfqg charge scaling so that it can be used to
> support hierarchy properly.  The scheme is fairly simple and
> light-weight.
> 
> * When a cfqg is added to the service tree, v(disktime)weight is
>   calculated.  It walks up the tree to root calculating the fraction
>   it has in the hierarchy.  At each level, the fraction can be
>   calculated as
> 
>     cfqg->weight / parent->level_weight
> 
>   By compounding these, the global fraction of vdisktime the cfqg has
>   claim to - vfraction - can be determined.
> 
> * When the cfqg needs to be charged, the charge is scaled inversely
>   proportionally to the vfraction.
> 
> The new scaling scheme uses the same CFQ_SERVICE_SHIFT for fixed point
> representation as before; however, the smallest scaling factor is now
> 1 (ie. 1 << CFQ_SERVICE_SHIFT).  This is different from before where 1
> was for CFQ_WEIGHT_DEFAULT and higher weight would result in smaller
> scaling factor.
> 
> While this shifts the global scale of vdisktime a bit, it doesn't
> change the relative relationships among cfqgs and the scheduling
> result isn't different.
> 
> cfq_group_notify_queue_add uses fixed CFQ_IDLE_DELAY when appending
> new cfqg to the service tree.  The specific value of CFQ_IDLE_DELAY
> didn't have any relevance to vdisktime before and is unlikely to cause
> any visible behavior difference now especially as the scale shift
> isn't that large.
> 
> As the new scheme now makes proper distinction between cfqg->weight
> and ->leaf_weight, reverse the weight aliasing for root cfqgs.  For
> root, both weights are now mapped to ->leaf_weight instead of the
> other way around.
> 
> Because we're still using cfqg_flat_parent(), this patch shouldn't
> change the scheduling behavior in any noticeable way.
> 
> v2: Beefed up comments on vfraction as requested by Vivek.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Vivek Goyal <vgoyal@redhat.com>

Looks good to me.

Acked-by: Vivek Goyal <vgoyal@redhat.com>

Vivek
