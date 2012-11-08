Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756161Ab2KHPUp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 10:20:45 -0500
Received: from cantor2.suse.de ([195.135.220.15]:60489 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751930Ab2KHPUm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 10:20:42 -0500
Date: Thu, 8 Nov 2012 16:20:39 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Tejun Heo <tj@kernel.org>
Cc: lizefan@huawei.com, rjw@sisk.pl, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, fweisbec@gmail.com
Subject: Re: [PATCH 9/9 v2] cgroup_freezer: implement proper hierarchy support
Message-ID: <20121108152039.GL31821@dhcp22.suse.cz>
References: <1351931915-1701-1-git-send-email-tj@kernel.org>
 <1351931915-1701-10-git-send-email-tj@kernel.org>
 <20121107163919.GC2660@mtj.dyndns.org>
 <20121108140852.GI31821@dhcp22.suse.cz>
 <20121108141848.GA12973@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121108141848.GA12973@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 08-11-12 06:18:48, Tejun Heo wrote:
> Hello, Michal.
> 
> On Thu, Nov 08, 2012 at 03:08:52PM +0100, Michal Hocko wrote:
> > This seems to be racy because parent->state access is not linearized.
> > Say we have parallel freeze and thawing on a tree like the following:
> > 	A
> > 	|
> > 	B
> >         |
> >         C 
> > 
> > pre_order will visit them in B, C order.
> > 	CPU1						CPU2
> > freezer_apply_state(A, true)
> > A->state & FREEZING == true		freezer_apply_state(A, false)
> > 					A->state & FREEZING == false
> > 					freezer_apply_state(B, false)
> > 					B->state & FREEZING == false
> > freezer_apply_state(B, true)
> > 
> > B->state & FREEZING == true
> > freezer_apply_state(C, true)
> > 					freezer_apply_state(C, false)
> > 
> > So A, C are thawed while B is frozen. Or am I missing something which
> > would prevent from this kind of race?
> 
> The rule is that there will be at least one inheritance operation
> after a parent is updated.  The exact order of propagation doesn't
> matter as long as there's at least one inheritance event after the
> latest update to a parent.  This works because inheritance operations
> are atomic to each other.  If one inheritance operation "saw" an
> update to its parent, the next inheritance operation is guaranteed to
> see at least upto that update.
> 
> So, in the above example in CPU2, (B->state & FREEZING) test and
> freezer_apply_state(C, false) can't be interleaved with the same
> inheritance operation from CPU1.  They either happen before or after.

I am not sure I understand what you mean by inheritance operation but
you are right that the race is not possible because spin_lock makes
sure that Foo->state is done after the lock(Foo->child) and spin_unlock
then serves as a leave barrier so the other CPUs will see the correctly
updated value. The rest is handled by the fixed ordered tree walk. So
there is really no interleaving going on here.

Sorry about the confusion!

Feel free to add my Reviewed-by.
-- 
Michal Hocko
SUSE Labs
