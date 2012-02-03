Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757842Ab2BCU7R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 15:59:17 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:58204 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757629Ab2BCU7P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 15:59:15 -0500
Date: Fri, 3 Feb 2012 12:59:10 -0800
From: Tejun Heo <tj@kernel.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: axboe@kernel.dk, ctalbott@google.com, rni@google.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH UPDATED 11/11] blkcg: unify blkg's for blkcg policies
Message-ID: <20120203205910.GB14209@google.com>
References: <1328131156-13290-1-git-send-email-tj@kernel.org>
 <1328131156-13290-12-git-send-email-tj@kernel.org>
 <20120202003730.GC19837@google.com>
 <20120203194105.GA12616@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120203194105.GA12616@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey, Vivek.

On Fri, Feb 03, 2012 at 02:41:05PM -0500, Vivek Goyal wrote:
> On Wed, Feb 01, 2012 at 04:37:30PM -0800, Tejun Heo wrote:
> > As a transitional step to untangle blkg management, elvswitch and
> > policy [de]registration, all blkgs except the root blkg are being shot
> > down during elvswitch and bypass.  This patch adds blkg_root_update()
> > to update root blkg in place on policy change.  This is hacky and racy
> > but should be good enough as interim step until we get locking
> > simplified and switch over to proper in-place update for all blkgs.
> 
> - So we don't shoot down root group over elevator switch and policy
>   changes because we are not sure if we will be able to alloc new
>   group? It is not like elevator where we don't free the old one till
>   we have made sure that new one is allocated and initialized properly.

No, because we policies cache root group and we don't have mechanism
to update them.  I could have added that but root group management
should be moved to blkcg core anyway and in-place update will be
applied to all blkgs, so I just chose a dirty shortcut as an interim
step.

> - I am assuming that we will change  blkg_destroy_all() later to also
>   take policy as argument and only destroy policy data of respective
>   policy and not the whole group. (Well I guess we can destroy the whole
>   group if it was only policy on the group). 

Yeap, that's what's scheduled.

> [..]
> >  static struct blkio_group *blkg_alloc(struct blkio_cgroup *blkcg,
> > -				      struct request_queue *q,
> > -				      struct blkio_policy_type *pol)
> > +				      struct request_queue *q)
> 
> Comment before this function still mentions "pol" as function argument.

Will update.

> [..]
> > @@ -776,43 +786,49 @@ blkiocg_reset_stats(struct cgroup *cgrou
> >  #endif
> >  
> >  	blkcg = cgroup_to_blkio_cgroup(cgroup);
> > +	spin_lock(&blkio_list_lock);
> >  	spin_lock_irq(&blkcg->lock);
> 
> Isn't blkcg lock enough to protect against policy registration/deregistration.
> A policy can not add/delete a group to cgroup list without blkcg list. 

But pol list can change regardless of that, no?

Thanks.

-- 
tejun
