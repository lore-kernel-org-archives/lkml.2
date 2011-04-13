Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757263Ab1DMQwO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 12:52:14 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:36090 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756155Ab1DMQwN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 12:52:13 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/LuOwgFuTLtNTygX5zpChEc7NLCJxLf+gSivgdbN
	EIEssjtDrRL8CM
Subject: Re: query: [PATCH 2/2] cgroup: Remove call to synchronize_rcu in
 cgroup_attach_task
From: Mike Galbraith <efault@gmx.de>
To: Paul Menage <menage@google.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Colin Cross <ccross@android.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Li Zefan <lizf@cn.fujitsu.com>
In-Reply-To: <BANLkTikvHtfeC1MqqXL7yTaXhZzZ3JRi8g@mail.gmail.com>
References: <1302170153.12304.31.camel@marge.simson.net>
	 <BANLkTikvHtfeC1MqqXL7yTaXhZzZ3JRi8g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 13 Apr 2011 18:52:09 +0200
Message-ID: <1302713529.7448.18.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-04-13 at 15:10 +0200, Paul Menage wrote:
> On Thu, Apr 7, 2011 at 11:55 AM, Mike Galbraith <efault@gmx.de> wrote:
> > Greetings,
> >
> > Wrt these patches:
> >
> > https://lkml.org/lkml/2010/11/24/14 [PATCH 1/2] cgroup: Set CGRP_RELEASABLE when adding to a cgroup
> > https://lkml.org/lkml/2010/11/24/15 [PATCH 2/2] cgroup: Remove call to synchronize_rcu in cgroup_attach_task
> >
> > I received a query regarding 2/2 because a large database company is
> > apparently moving tasks between cgroups frequently enough that their
> > database initialization time dropped from ~11 hours to ~4 hours when
> > they applied this patch.
> 
> That sounds like a problem in their user-space code too, although I
> agree that making cgroup moves faster is a good thing.

I suspect they could avoid the issue, but don't have details.

> > Curious why these got no traction.
> >
> 
> Apart from just my chronic lack of time to work on cgroups, there were
> a couple of issues:
> 
> 1) we had trouble getting the semantics right for the release_agent
> notifications. Not that this is something that I suspect many people
> care about, but it has been part of the API since the cpuset days. I
> spent a while trying to juggle the way that release notifications were
> done (via an event counter rather than a simple flag) but never got
> them finished.
> 
> 2) I have this nagging feeling that the synchronize_rcu() call in
> cgroup_attach_task() was protecting more than is obvious. Certainly
> when cgroups first went in, that synchronize_rcu() call meant that
> cgroup_rmdir() could guarantee that if the cgroup was empty, there
> were no threads in RCU-read sections accessing their old cgroup via
> their RCU-proected current->cgroups pointers, so objects could just be
> deleted at that point. A year or two ago we RCU-ified most/all of the
> cgroup deletion path, so this shouldn't be an issue now, but I'm still
> a bit worried that we missed something. I'm probably being
> over-paranoid though.

Thanks for the info.

> We're looking at testing these patches at Google, which will give a
> little more confidence.

Goody.  I'll be doing some small scale beating too fwiw.

> There's a conflicting patchset (allowing moving entire processes by
> writing to cgroup.procs) that Ben Blum has been trying to get in for
> ages, and which has just gone in to -mm - the RCU change patches will
> likely need a bit of merge love.

Yeah, saw those.

	-Mike

