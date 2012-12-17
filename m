Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753268Ab2LQV1o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 16:27:44 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1751 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752286Ab2LQV1n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 16:27:43 -0500
Date: Mon, 17 Dec 2012 16:27:36 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: lizefan@huawei.com, axboe@kernel.dk, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        ctalbott@google.com, rni@google.com
Subject: Re: [PATCH 07/12] cfq-iosched: implement hierarchy-ready cfq_group
 charge scaling
Message-ID: <20121217212736.GB13691@redhat.com>
References: <1355524885-22719-1-git-send-email-tj@kernel.org>
 <1355524885-22719-8-git-send-email-tj@kernel.org>
 <20121217205317.GI7235@redhat.com>
 <20121217211738.GD1844@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121217211738.GD1844@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 17, 2012 at 01:17:38PM -0800, Tejun Heo wrote:
> Hello,
> 
> On Mon, Dec 17, 2012 at 03:53:18PM -0500, Vivek Goyal wrote:
> > On Fri, Dec 14, 2012 at 02:41:20PM -0800, Tejun Heo wrote:
> > > Currently, cfqg charges are scaled directly according to cfqg->weight.
> > > Regardless of the number of active cfqgs or the amount of active
> > > weights, a given weight value always scales charge the same way.  This
> > > works fine as long as all cfqgs are treated equally regardless of
> > > their positions in the hierarchy, which is what cfq currently
> > > implements.  It can't work in hierarchical settings because the
> > > interpretation of a given weight value depends on where the weight is
> > > located in the hierarchy.
> > 
> > I did not understand this. Why the current scheme will not work with
> > hierarchy?
> 
> Because the meaning of a weight changes depending on where the weight
> exists in the hierarchy?
> 
> > While we calculate the vdisktime, this is calculated with the help
> > of CFQ_DEFAULT_WEIGHT and cfqg->weight. So we scale used time slice
> > in proportion to CFQ_DEFAULT_WEIGTH/cfqg->weight. So higher the weight
> > lesser the charge and cfqg gets scheduled again faster and lower the
> > weight, higher the vdisktime and cfqg gets scheduled less  frequently.
> > 
> > As every cfqg does the same thing on service tree, they automatically
> > get fair share w.r.t their weight.
> > 
> > And this mechanism should not be impacted by the hierarchy because we
> > have a separate service tree at separate level. This will not work
> > only if you come up with one compressed tree and then weights will
> > have to be adjusted. If we have a separate service tree in each group
> > then it should work just fine.
> 
> Why would you create N service trees when you can almost trivially use
> one by calcualting the effective weight?  You would have to be
> adjusting all trees above whenever something changes in a child.

One of the reasons I can think is accuracy. If a task/group is added to
a service tree, it mostly does not change the fraction of parent and
does not change the fraction of parent's sibling.

By making everything flat any addition/removal of an entity changes
fraction of everything on the tree.

Not that I am bothered about it because we do not focus that strictly
on fairness. So I would not care about it.

What I do care about is atleast being able to read and understand the
code easily. Right now, it is hard to understand. I am still struggling
to wrap my head around it.

For example, while adding a group to service tree we calculate
cfqg->vfaction as follows.

vfr = vfr * pos->leaf_weight / pos->level_weight;

and then 

vfr = vfr * pos->weight / parent->level_weight;

cfqg->vfraction = max_t(unsigned, vfr, 1)

If cfqg->vfraction is about cfqg then why should we take into account
leaf_weight and level_weight. We should be just worried about pos->weight
and parent->level_weight and that should determine vfaction of cfqg.
 
Thanks
Vivek
