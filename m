Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753956Ab0KITfs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 14:35:48 -0500
Received: from charlotte.tuxdriver.com ([70.61.120.58]:50430 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753325Ab0KITfr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 14:35:47 -0500
Date: Tue, 9 Nov 2010 14:33:12 -0500
From: Neil Horman <nhorman@tuxdriver.com>
To: Mike Waychison <mikew@google.com>
Cc: simon.kagstrom@netinsight.net, davem@davemloft.net,
        Matt Mackall <mpm@selenic.com>, adurbin@google.com,
        linux-kernel@vger.kernel.org, chavey@google.com,
        Greg KH <greg@kroah.com>,
        =?iso-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>,
        akpm@linux-foundation.org, linux-api@vger.kernel.org
Subject: Re: [PATCH v2 04/23] netconsole: Call netpoll_cleanup() in process
 context
Message-ID: <20101109193312.GA9990@hmsreliant.think-freely.org>
References: <20101108203120.22479.19708.stgit@crlf.mtv.corp.google.com>
 <20101108203159.22479.48774.stgit@crlf.mtv.corp.google.com>
 <20101109120752.GA18269@hmsreliant.think-freely.org>
 <AANLkTi=Dez6st660R3h+0uTqkTUgOppvzBXcbg7QqxDu@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTi=Dez6st660R3h+0uTqkTUgOppvzBXcbg7QqxDu@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-Spam-Score: -2.9 (--)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 09, 2010 at 09:18:57AM -0800, Mike Waychison wrote:
> On Tue, Nov 9, 2010 at 4:07 AM, Neil Horman <nhorman@tuxdriver.com> wrote:
> > On Mon, Nov 08, 2010 at 12:32:00PM -0800, Mike Waychison wrote:
> >> +static void deferred_netpoll_cleanup(struct work_struct *work)
> >> +{
> >> +     struct netconsole_target *nt;
> >> +     unsigned long flags;
> >> +
> >> +     nt = container_of(work, struct netconsole_target, cleanup_work);
> >> +     netpoll_cleanup(&nt->np);
> >> +
> >> +     spin_lock_irqsave(&target_list_lock, flags);
> >> +     BUG_ON(nt->np_state != NETPOLL_CLEANING);
> >> +     nt->np_state = NETPOLL_DISABLED;
> >> +     spin_unlock_irqrestore(&target_list_lock, flags);
> >> +
> >> +     netconsole_target_put(nt);
> >> +}
> >> +
> > Where is the synchronization on the new work queue when the module is getting
> > removed? The target get/put code does nothing to the module refcount, and
> > cleanup_netconsole just deletes targets, it doesn't block or fail on netconsole
> > refcounts, so you could run this work after the module has been removed and oops
> > the system.
> >
> 
> The synchronization here is actually handled in free_param_target()
> with the call to cancel_work_sync().  After that call is made in the
> exit path, we know a task cannot be rescheduled for cleanup, so we can
> clean things up directly.
> 
> The comment/name of free_param_target should probably change.  I used
> to have this cancel_work_sync() call elsewhere, and folded both the
> dynamic and param-based target cleanup into one as they ended up being
> the same.
> 
> Removal of the item from configfs however isn't handled.
> 
> How about something like (no idea if this will get whitespace damage):
> 
That would seem clearer to me yes.  Thanks!
Neil

> 
> diff --git a/drivers/net/netconsole.c b/drivers/net/netconsole.c
> index 02ba5c4..ddd5e4f 100644
> --- a/drivers/net/netconsole.c
> +++ b/drivers/net/netconsole.c
> @@ -686,13 +686,16 @@ static void drop_netconsole_target(struct
> config_group *group,
>         spin_unlock_irqrestore(&target_list_lock, flags);
> 
>         /*
> -        * The target may have never been enabled, or was manually disabled
> -        * before being removed so netpoll may have already been cleaned up.
> +        * The target may have never been disabled, or was disabled due
> +        * to a netdev event, but we haven't had the chance to clean
> +        * things up yet.
>          *
> -        * If it queued for cleanup already, that is fine, as that path holds a
> -        * reference to the config_item.
> +        * We can't wait for the target to be cleaned up by its
> +        * scheduled work however, as that work doesn't pin this module
> +        * in place.
>          */
> -       if (nt->np_state == NETPOLL_ENABLED)
> +       cancel_work_sync(&nt->cleanup_work);
> +       if (nt->np_state == NETPOLL_ENABLED || nt->np-state == NETPOLL_CLEANING)
>                 netpoll_cleanup(&nt->np);
> 
>         config_item_put(&nt->item);
> 
> 
> 
> I can fold this diff snippet into this patch for the next round if you
> agree it plugs the remaining hole.
> 
