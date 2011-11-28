Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753042Ab1K1QIx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 11:08:53 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:60853 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751293Ab1K1QIw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 11:08:52 -0500
Date: Mon, 28 Nov 2011 08:08:44 -0800
From: Tejun Heo <tj@kernel.org>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Li Zefan <lizf@cn.fujitsu.com>,
        Matt Helsley <matthltc@us.ibm.com>, Andrey Vagin <avagin@openvz.org>,
        Pavel Emelyanov <xemul@parallels.com>
Subject: Re: [RFC] cgroups: freezer -- Allow to attach a task to a frozen
 cgroup
Message-ID: <20111128160844.GB18864@google.com>
References: <20111128120813.GK1775@moon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111128120813.GK1775@moon>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 28, 2011 at 04:08:13PM +0400, Cyrill Gorcunov wrote:
> In checkpoint/restore we need an ability to attach pids to
> a frozen cgroup. Thus once pid reaches a frozen cgroup it is
> not rejected, but the task get frozen immediately.
> 
> Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
> ---
> 
> I would really appreciate complains and comments.

First of all, both freezer and cgroup have non-trivial pending
patchsets (e.g. ->can_attach_task() is scheduled for removal) and I
have changes which basically try to achieve about the same thing, so
let's slow down a bit.  I think the problem is a bit more complex.

Some thoughts I have on cgroup freezer ATM,

* Currently, FROZEN -> FREEZING transition isn't possible.  That's why
  event transition detection by polling is acceptable.  ie. once the
  state is polled to be FROZEN, it stays frozen.  Allowing FREEZING ->
  FROZEN transition would probably require improvements to state
  transition notification too, at the very least, clarification of
  rules.

* There are some unclear corner cases and bugs the current cgroup
  freezer has.  e.g. behavior w.r.t. kthreads is outright buggy.  It
  would be great to figure out how to deal with them with or before
  this change (ie. what happens when you transfer unfreezable
  kthreads).

* A pending feature request is making the freezing action atomically
  recursive.  We'll probably need to add a param to allow choosing
  which behavior to take.

* Another improvement that I want to have is allowing cgroup frozen
  tasks to be killed.  I don't think this matters for system freezer
  but for cgroup freezer both oom killer and systemd want it.

So, while I agree with the direction of this patch, I think this
definitely needs a lot more work to go in.  I don't think we can do
much until the freezer and cgroup changes are settled.  The freezer
part is now in Rafael's tree, the cgroup part is going under Linus'
review.  Once they're complete, I'll provide a merged branch that
further cgroup works can be based on.

Thanks.

-- 
tejun
