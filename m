Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753970Ab2LQVtU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 16:49:20 -0500
Received: from mx1.redhat.com ([209.132.183.28]:20310 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751831Ab2LQVtS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 16:49:18 -0500
Date: Mon, 17 Dec 2012 16:49:11 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: lizefan@huawei.com, axboe@kernel.dk, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        ctalbott@google.com, rni@google.com
Subject: Re: [PATCH 07/12] cfq-iosched: implement hierarchy-ready cfq_group
 charge scaling
Message-ID: <20121217214911.GC13691@redhat.com>
References: <1355524885-22719-1-git-send-email-tj@kernel.org>
 <1355524885-22719-8-git-send-email-tj@kernel.org>
 <20121217205317.GI7235@redhat.com>
 <20121217211738.GD1844@htj.dyndns.org>
 <20121217212736.GB13691@redhat.com>
 <20121217213314.GF1844@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121217213314.GF1844@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 17, 2012 at 01:33:14PM -0800, Tejun Heo wrote:
> Hello,
> 
> On Mon, Dec 17, 2012 at 04:27:36PM -0500, Vivek Goyal wrote:
> > What I do care about is atleast being able to read and understand the
> > code easily. Right now, it is hard to understand. I am still struggling
> > to wrap my head around it.
> 
> Hmm... I thought it was really simple.  Maybe I'm just too familiar
> with it.  You just walk up the tree multiplying the fraction you have
> at each level.  It really doesn't get much simpler than that.
> 
> > For example, while adding a group to service tree we calculate
> > cfqg->vfaction as follows.
> > 
> > vfr = vfr * pos->leaf_weight / pos->level_weight;
> > 
> > and then 
> > 
> > vfr = vfr * pos->weight / parent->level_weight;
> > 
> > cfqg->vfraction = max_t(unsigned, vfr, 1)
> > 
> > If cfqg->vfraction is about cfqg then why should we take into account
> > leaf_weight and level_weight. We should be just worried about pos->weight
> > and parent->level_weight and that should determine vfaction of cfqg.
> 
> Eh?  Then how would it compete with the children cfqgs?  You can
> consider it as the hidden leaf node competing with the children cfqgs,
> right?  So, you take the leaf weight and divide it by the total active
> weight of all the children (including the hidden leaf node).  It isn't
> different from the rest of the calculation.  It just looks different
> because leaf_weight is stored elsewhere and we look down there and
> then walke up.  The calculation being done is exactly the same one.

Again it is coming from multiplexing cfqg and cfqg->task_group. So
effectively we are calculating the vfraction of task_group inside cfqg.
Once you say cfqg->vfraction, I immediately think of total share of
group (including task_group and all children cgroups).

May be cfqg->task_group_vfraction (or cfqg->tg_fraction) is a better name.

Also descrition says.

/* vfraction  the fraction of vdisktime that a cfqg is entitled to */

May be we can clarify it that it is share of task_group of cfqg.

I guess i am too familiar with how cpu has done it. I think I am getting
confused with properties which belong to cfqg and properties which
belong to cfqg->task_group.

I guess if we prefix fields belong to task_group with somete suitable
string, it might become little easier to understand.

Thanks
Vivek
