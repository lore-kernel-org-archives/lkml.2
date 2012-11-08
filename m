Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756001Ab2KHOSz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 09:18:55 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:45962 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755909Ab2KHOSx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 09:18:53 -0500
Date: Thu, 8 Nov 2012 06:18:48 -0800
From: Tejun Heo <tj@kernel.org>
To: Michal Hocko <mhocko@suse.cz>
Cc: lizefan@huawei.com, rjw@sisk.pl, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, fweisbec@gmail.com
Subject: Re: [PATCH 9/9 v2] cgroup_freezer: implement proper hierarchy support
Message-ID: <20121108141848.GA12973@htj.dyndns.org>
References: <1351931915-1701-1-git-send-email-tj@kernel.org>
 <1351931915-1701-10-git-send-email-tj@kernel.org>
 <20121107163919.GC2660@mtj.dyndns.org>
 <20121108140852.GI31821@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121108140852.GI31821@dhcp22.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Michal.

On Thu, Nov 08, 2012 at 03:08:52PM +0100, Michal Hocko wrote:
> This seems to be racy because parent->state access is not linearized.
> Say we have parallel freeze and thawing on a tree like the following:
> 	A
> 	|
> 	B
>         |
>         C 
> 
> pre_order will visit them in B, C order.
> 	CPU1						CPU2
> freezer_apply_state(A, true)
> A->state & FREEZING == true		freezer_apply_state(A, false)
> 					A->state & FREEZING == false
> 					freezer_apply_state(B, false)
> 					B->state & FREEZING == false
> freezer_apply_state(B, true)
> 
> B->state & FREEZING == true
> freezer_apply_state(C, true)
> 					freezer_apply_state(C, false)
> 
> So A, C are thawed while B is frozen. Or am I missing something which
> would prevent from this kind of race?

The rule is that there will be at least one inheritance operation
after a parent is updated.  The exact order of propagation doesn't
matter as long as there's at least one inheritance event after the
latest update to a parent.  This works because inheritance operations
are atomic to each other.  If one inheritance operation "saw" an
update to its parent, the next inheritance operation is guaranteed to
see at least upto that update.

So, in the above example in CPU2, (B->state & FREEZING) test and
freezer_apply_state(C, false) can't be interleaved with the same
inheritance operation from CPU1.  They either happen before or after.

Maybe it's too subtle.  The only reason I didn't use a giant
freezer_mutex was that I wanted to demonstrate how to do state
propagation without depending on single giant lock.  Maybe nobody
wants that and this should use one mutex to protect the hierarchy.  I
don't know.

Thanks.

-- 
tejun
