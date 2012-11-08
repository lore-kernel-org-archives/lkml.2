Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756138Ab2KHP3b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 10:29:31 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:42534 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751898Ab2KHP32 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 10:29:28 -0500
Date: Thu, 8 Nov 2012 07:29:23 -0800
From: Tejun Heo <tj@kernel.org>
To: Michal Hocko <mhocko@suse.cz>
Cc: lizefan@huawei.com, rjw@sisk.pl, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, fweisbec@gmail.com
Subject: Re: [PATCH 9/9 v2] cgroup_freezer: implement proper hierarchy support
Message-ID: <20121108152923.GG12973@htj.dyndns.org>
References: <1351931915-1701-1-git-send-email-tj@kernel.org>
 <1351931915-1701-10-git-send-email-tj@kernel.org>
 <20121107163919.GC2660@mtj.dyndns.org>
 <20121108140852.GI31821@dhcp22.suse.cz>
 <20121108141848.GA12973@htj.dyndns.org>
 <20121108152039.GL31821@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121108152039.GL31821@dhcp22.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey, Michal.

On Thu, Nov 08, 2012 at 04:20:39PM +0100, Michal Hocko wrote:
> > So, in the above example in CPU2, (B->state & FREEZING) test and
> > freezer_apply_state(C, false) can't be interleaved with the same
> > inheritance operation from CPU1.  They either happen before or after.
> 
> I am not sure I understand what you mean by inheritance operation but

The operation of looking at one's parent and inherting the state.
Here, checking parent->state and calling apply_state accordingly.

> you are right that the race is not possible because spin_lock makes
> sure that Foo->state is done after the lock(Foo->child) and spin_unlock
> then serves as a leave barrier so the other CPUs will see the correctly
> updated value. The rest is handled by the fixed ordered tree walk. So
> there is really no interleaving going on here.

I'm worried that this is a bit too subtle.  This will work fine with a
single hierarchy mutex protecting hierarchy updates and state
propagations through it and that should work for most controllers too.
I want to have at least one example of finer grained locking for
future reference and cgroup_freezer happened to be the one I started
working on.  So, it is more complicated (not necessarily in written
code but the sync rules) than necessary.  I'm still not sure whether
to keep it or not.  I'll add more documentation about synchronization
in cgroup_for_each_descendant_pre() either way.

Thanks.

-- 
tejun
