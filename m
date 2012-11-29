Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753890Ab2K2UVm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 15:21:42 -0500
Received: from 50-56-35-84.static.cloud-ips.com ([50.56.35.84]:58336 "EHLO
	mail.hallyn.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753331Ab2K2UVk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 15:21:40 -0500
Date: Thu, 29 Nov 2012 20:26:08 +0000
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Aristeu Rozanski <aris@redhat.com>
Cc: "Serge E. Hallyn" <serge@hallyn.com>, linux-kernel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>, Serge Hallyn <serge.hallyn@canonical.com>,
        cgroups@vger.kernel.org
Subject: Re: [PATCH 3/5] device_cgroup: keep track of local group settings
Message-ID: <20121129202608.GA26716@mail.hallyn.com>
References: <20121127193501.255267751@napanee.usersys.redhat.com>
 <20121127193502.482004744@napanee.usersys.redhat.com>
 <20121129192945.GD26104@mail.hallyn.com>
 <20121129195942.GW32112@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121129195942.GW32112@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Aristeu Rozanski (aris@redhat.com):
> On Thu, Nov 29, 2012 at 07:29:45PM +0000, Serge E. Hallyn wrote:
> > Quoting Aristeu Rozanski (aris@redhat.com):
> > > In preparation for better hierarchy support, it's needed to retain the local
> > > settings in order to try to reapply them after a propagated change if they're
> > > still valid.
> > > 
> > > Cc: Tejun Heo <tj@kernel.org>
> > > Cc: Serge Hallyn <serge.hallyn@canonical.com>
> > > Signed-off-by: Aristeu Rozanski <aris@redhat.com>
> > >  
> > > ---
> > >  security/device_cgroup.c |  108 ++++++++++++++++++++++++++++++++++-------------
> > >  1 file changed, 80 insertions(+), 28 deletions(-)
> > 
> > Hi,
> > 
> > thanks for doing this.  I've got one concern though.  I don't see
> > any place where devcgroup_create() was updated to create the
> > local exceptions list.  I think we need a guarantee that at
> 
> the local exceptions list is part of the dev_cgroup structure and it's
> initialized on the patch 'device_cgroup: keep track of local group
> setting':
> 
> @@ -190,6 +238,8 @@
>         if (!dev_cgroup)
>                 return ERR_PTR(-ENOMEM);
>         INIT_LIST_HEAD(&dev_cgroup->exceptions);
> +       INIT_LIST_HEAD(&dev_cgroup->local.exceptions);
> +       dev_cgroup->local.behavior = DEVCG_DEFAULT_NONE;
>         parent_cgroup = cgroup->parent;
> 
>         if (parent_cgroup == NULL)
> 
> > any time the local exceptions list will contain all the entries
> > contained in the cgroup->exceptions list.  Otherwise you cannot
> 
> hm, no. the local exceptions are meant to be used for stuff written
> locally. the devcgroup->exceptions list is the list in effect.
> 
> > use the exception_add() the way you do (or you can't use RCU),
> > since there could be a window between the successful addition
> > of a rule to cgroup->local.exceptions and the failed addition to
> > cgroup->exceptions, during which a task (since it won't need
> > the mutex for devcg_allow()) could exceed allowed permissions.
> >
> > It's possible I'm misunderstanding.  If you think that's the case
> > just kick me and I'll take a fresh look.
> 
> I see your point. it's indeed a problem. in dev_exception_add(), it
> needs to check for permissions before actually adding to
> devcgroup->exceptions.
> 
> > (Btw is there a git tree or gitweb view I could look at alongside
> > the patchset?)
> 
> I'll rebase the patchset along with a fix for this and resubmit with a
> link to the git repo.

Thanks, Aristeu!

-serge
