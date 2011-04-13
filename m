Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752913Ab1DMNLX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 09:11:23 -0400
Received: from smtp-out.google.com ([74.125.121.67]:26958 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751776Ab1DMNLW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 09:11:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=k/zWooJJdMK3hBcMzJ7z5xtsRWysECX9uTHrlZQdAlAmvO4ancnpex/BtGvwkJgd8P
         TIxBDPop5F8+TEwMam+g==
MIME-Version: 1.0
In-Reply-To: <1302170153.12304.31.camel@marge.simson.net>
References: <1302170153.12304.31.camel@marge.simson.net>
From: Paul Menage <menage@google.com>
Date: Wed, 13 Apr 2011 15:10:59 +0200
Message-ID: <BANLkTikvHtfeC1MqqXL7yTaXhZzZ3JRi8g@mail.gmail.com>
Subject: Re: query: [PATCH 2/2] cgroup: Remove call to synchronize_rcu in cgroup_attach_task
To: Mike Galbraith <efault@gmx.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Colin Cross <ccross@android.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Li Zefan <lizf@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 7, 2011 at 11:55 AM, Mike Galbraith <efault@gmx.de> wrote:
> Greetings,
>
> Wrt these patches:
>
> https://lkml.org/lkml/2010/11/24/14 [PATCH 1/2] cgroup: Set CGRP_RELEASABLE when adding to a cgroup
> https://lkml.org/lkml/2010/11/24/15 [PATCH 2/2] cgroup: Remove call to synchronize_rcu in cgroup_attach_task
>
> I received a query regarding 2/2 because a large database company is
> apparently moving tasks between cgroups frequently enough that their
> database initialization time dropped from ~11 hours to ~4 hours when
> they applied this patch.

That sounds like a problem in their user-space code too, although I
agree that making cgroup moves faster is a good thing.

>
> Curious why these got no traction.
>

Apart from just my chronic lack of time to work on cgroups, there were
a couple of issues:

1) we had trouble getting the semantics right for the release_agent
notifications. Not that this is something that I suspect many people
care about, but it has been part of the API since the cpuset days. I
spent a while trying to juggle the way that release notifications were
done (via an event counter rather than a simple flag) but never got
them finished.

2) I have this nagging feeling that the synchronize_rcu() call in
cgroup_attach_task() was protecting more than is obvious. Certainly
when cgroups first went in, that synchronize_rcu() call meant that
cgroup_rmdir() could guarantee that if the cgroup was empty, there
were no threads in RCU-read sections accessing their old cgroup via
their RCU-proected current->cgroups pointers, so objects could just be
deleted at that point. A year or two ago we RCU-ified most/all of the
cgroup deletion path, so this shouldn't be an issue now, but I'm still
a bit worried that we missed something. I'm probably being
over-paranoid though.

We're looking at testing these patches at Google, which will give a
little more confidence.

There's a conflicting patchset (allowing moving entire processes by
writing to cgroup.procs) that Ben Blum has been trying to get in for
ages, and which has just gone in to -mm - the RCU change patches will
likely need a bit of merge love.

Paul
