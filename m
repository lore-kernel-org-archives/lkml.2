Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756240Ab1K2W7G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 17:59:06 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:40468 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753308Ab1K2W7D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 17:59:03 -0500
Date: Tue, 29 Nov 2011 14:58:53 -0800
From: Matt Helsley <matthltc@us.ibm.com>
To: Tejun Heo <tj@kernel.org>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        Li Zefan <lizf@cn.fujitsu.com>, Matt Helsley <matthltc@us.ibm.com>,
        Andrey Vagin <avagin@openvz.org>,
        Pavel Emelyanov <xemul@parallels.com>
Subject: Re: [RFC] cgroups: freezer -- Allow to attach a task to a frozen
 cgroup
Message-ID: <20111129225853.GA693@count0.beaverton.ibm.com>
References: <20111128120813.GK1775@moon>
 <20111128160844.GB18864@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111128160844.GB18864@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 11112922-5518-0000-0000-000000B1E111
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 28, 2011 at 08:08:44AM -0800, Tejun Heo wrote:
> On Mon, Nov 28, 2011 at 04:08:13PM +0400, Cyrill Gorcunov wrote:
> > In checkpoint/restore we need an ability to attach pids to
> > a frozen cgroup. Thus once pid reaches a frozen cgroup it is
> > not rejected, but the task get frozen immediately.

Frankly, I don't see the need for this. I think you should explain
it with more detail at the very least.

Why can't they be frozen before being checkpointed? Assuming you've
used SEIZE and spawned a new parasite thread, just move that thread to a 
cgroup for the parasitic threads then freeze the old cgroup.

> > 
> > Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
> > ---
> > 
> > I would really appreciate complains and comments.
> 
> First of all, both freezer and cgroup have non-trivial pending
> patchsets (e.g. ->can_attach_task() is scheduled for removal) and I
> have changes which basically try to achieve about the same thing, so
> let's slow down a bit.  I think the problem is a bit more complex.
> 
> Some thoughts I have on cgroup freezer ATM,
> 
> * Currently, FROZEN -> FREEZING transition isn't possible.  That's why

No, IMO that would consitute breaking the interface. Scripts, tools,
applications, and tests have been written to rely on the fact that
the cgroup cannot go from FROZEN to FREEZING -- only from FROZEN to
THAWED.

>   event transition detection by polling is acceptable.  ie. once the
>   state is polled to be FROZEN, it stays frozen.  Allowing FREEZING ->
>   FROZEN transition would probably require improvements to state

(I'm assuming this last sentence has a thinko in it...)

>   transition notification too, at the very least, clarification of

Notification is a fine idea. However, not everything that's already
written expects them so correct usage of the cgroup freezer should not
require them -- IOW allowing the FROZEN -> FREEZING transition
isn't made OK just by adding notifications.

>   rules.
> 
> * There are some unclear corner cases and bugs the current cgroup
>   freezer has.  e.g. behavior w.r.t. kthreads is outright buggy.  It
>   would be great to figure out how to deal with them with or before
>   this change (ie. what happens when you transfer unfreezable
>   kthreads).

Huh? Shouldn't we just disable moving kthreads between cgroups? Allowing
userspace to freeze kthreads via cgroups seems like a *very* bad idea
(perhaps it's a thread critical for IO, or some driver, etc.).

Cheers
	-Matt Helsley

