Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753648Ab1DMNRT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 09:17:19 -0400
Received: from smtp-out.google.com ([216.239.44.51]:14174 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752364Ab1DMNRS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 09:17:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=XiugyLLbXbS4aTt5mPQ6TX0Ge/AU3BffWe/Y34E7MxJ/oxKxpJq8HLg6ElA8RRZxGW
         zyk0WVrPVg/M08tunOqQ==
MIME-Version: 1.0
In-Reply-To: <1302664313.7407.29.camel@marge.simson.net>
References: <1302170153.12304.31.camel@marge.simson.net> <4DA50430.8020701@cn.fujitsu.com>
 <1302664313.7407.29.camel@marge.simson.net>
From: Paul Menage <menage@google.com>
Date: Wed, 13 Apr 2011 15:16:55 +0200
Message-ID: <BANLkTikqvP90Etu=L24DPWbckrawM-6n=Q@mail.gmail.com>
Subject: Re: query: [PATCH 2/2] cgroup: Remove call to synchronize_rcu in cgroup_attach_task
To: Mike Galbraith <efault@gmx.de>
Cc: Li Zefan <lizf@cn.fujitsu.com>, LKML <linux-kernel@vger.kernel.org>,
        Colin Cross <ccross@android.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 13, 2011 at 5:11 AM, Mike Galbraith <efault@gmx.de> wrote:
> If the user _does_ that rmdir(), it's more or less back to square one.
> RCU grace periods should not impact userland, but if you try to do
> create/attach/detach/destroy, you run into the same bottleneck, as does
> any asynchronous GC, though that's not such a poke in the eye.  I tried
> a straight forward move to schedule_work(), and it seems to work just
> fine.  rmdir() no longer takes ~30ms on my box, but closer to 20us.

> +       /*
> +        * Release the subsystem state objects.
> +        */
> +       for_each_subsys(cgrp->root, ss)
> +               ss->destroy(ss, cgrp);
> +
> +       cgrp->root->number_of_cgroups--;
> +       mutex_unlock(&cgroup_mutex);
> +
> +       /*
> +        * Drop the active superblock reference that we took when we
> +        * created the cgroup
> +        */
> +       deactivate_super(cgrp->root->sb);
> +
> +       /*
> +        * if we're getting rid of the cgroup, refcount should ensure
> +        * that there are no pidlists left.
> +        */
> +       BUG_ON(!list_empty(&cgrp->pidlists));
> +
> +       kfree(cgrp);

We might want to punt this through RCU again, in case the subsystem
destroy() callbacks left anything around that was previously depending
on the RCU barrier.

Also, I'd be concerned that subsystems might get confused by the fact
that a new group called 'foo' could be created before the old 'foo'
has been cleaned up? (And do any subsystems rely on being able to
access the cgroup dentry up until the point when destroy() is called?

Paul
