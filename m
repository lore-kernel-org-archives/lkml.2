Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757620Ab0JHQvP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 12:51:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21067 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932375Ab0JHQvO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 12:51:14 -0400
Subject: Re: [BUG][PATCH][2.6.36-rc3] fanotify: Do not ignore result of
 permission decisions
From: Eric Paris <eparis@redhat.com>
To: Tvrtko Ursulin <tvrtko.ursulin@sophos.com>
Cc: Andreas Gruenbacher <agruen@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
In-Reply-To: <201010081711.24373.tvrtko.ursulin@sophos.com>
References: <201009071608.02290.tvrtko.ursulin@sophos.com>
	 <201009080924.04841.tvrtko.ursulin@sophos.com>
	 <201010081500.40494.agruen@suse.de>
	 <201010081711.24373.tvrtko.ursulin@sophos.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 08 Oct 2010 12:51:00 -0400
Message-ID: <1286556660.2682.72.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-10-08 at 17:11 +0100, Tvrtko Ursulin wrote:
> On Friday 08 Oct 2010 14:00:40 Andreas Gruenbacher wrote:
> > Tvrtko,
> >
> > On Wednesday 08 September 2010 10:24:04 Tvrtko Ursulin wrote:

> > >                 }
> > >
> > > +#ifdef CONFIG_FANOTIFY_ACCESS_PERMISSIONS
> > > +               /* If a listener denied on a permission event we will
> > > remember the reason +                  and run the rest with a
> > > non-permission mask only. This allows other +                  listeners
> > > to receive non-permission notifications but we do not care +
> > >      about further permission checks and want to deny this event. */ +
> > >             if (unlikely((res == -EPERM) && (mask &
> > > FS_ALL_PERM_EVENTS))) {
> >
> > We should probably stop processing here whenever res != 0, for any mask.
> > (The fanotify and inotify handle_event callbacks can return -ENOMEM right
> > now, but this doesn't seem very useful and should probably be fixed:
> > fsnotify has no way of doing anything about -ENOMEM.
> 
> I wasn't 100% sure of how fanotify works, or in other words can there be more
> events in this mask after perm events are removed. If it can then we should
> send them to other listeners. Eric?
> 
> Also if ENOMEM, why not try sending to other listeners?

No, you'll never have a PERM_EVENT and something else at the same time.
If it's a PERM_EVENT denial we wouldn't really want to even notify
others, since the operation won't have actually taken place (perm event
denials should be passed all the way back up the stack)

As to ENOMEM that's a little harder I guess.  We don't have to stop just
because inotify got ENOMEM, but we should stop if PERM_EVENTS got an
ENOMEM.

I'd really rather not put CONFIG_FANOTIFY_ACCESS_PERMISSIONS in this
file.  fsnotify.c should be notifier agnostic.

How about just:

if (unlikely(ret && (mask & ALL_PERM)))
	return ret

