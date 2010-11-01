Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752534Ab0KARX7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 13:23:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47176 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751931Ab0KARX5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 13:23:57 -0400
Subject: Re: [PATCH 10/20] fanotify: allow userspace to override max queue
 depth
From: Eric Paris <eparis@redhat.com>
To: Tvrtko Ursulin <tvrtko.ursulin@sophos.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "agruen@suse.de" <agruen@suse.de>
In-Reply-To: <201011011709.59239.tvrtko.ursulin@sophos.com>
References: <20101028213139.24810.34058.stgit@paris.rdu.redhat.com>
	 <20101028213232.24810.78.stgit@paris.rdu.redhat.com>
	 <201011011709.59239.tvrtko.ursulin@sophos.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 01 Nov 2010 13:23:51 -0400
Message-ID: <1288632231.3017.53.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-11-01 at 17:09 +0000, Tvrtko Ursulin wrote:
> On Thursday 28 Oct 2010 22:32:32 Eric Paris wrote:
> > fanotify has a defualt max queue depth.  This patch allows processes which
> > explicitly request it to have an 'unlimited' queue depth.  These processes
> > need to be very careful to make sure they cannot fall far enough behind
> > that they OOM the box.  Thus this flag is gated on CAP_SYS_ADMIN.
> >
> > Signed-off-by: Eric Paris <eparis@redhat.com>
> > ---
> >
> >  fs/notify/fanotify/fanotify_user.c |    9 ++++++++-
> >  include/linux/fanotify.h           |    5 +++--
> >  2 files changed, 11 insertions(+), 3 deletions(-)
> >
> > diff --git a/fs/notify/fanotify/fanotify_user.c
> > b/fs/notify/fanotify/fanotify_user.c index 04f2fe4..43d66d9 100644
> > --- a/fs/notify/fanotify/fanotify_user.c
> > +++ b/fs/notify/fanotify/fanotify_user.c
> > @@ -691,7 +691,14 @@ SYSCALL_DEFINE2(fanotify_init, unsigned int, flags,
> > unsigned int, event_f_flags) goto out_put_group;
> >       }
> >
> > -     group->max_events = FANOTIFY_DEFAULT_MAX_EVENTS;
> > +     if (flags & FAN_UNLIMITED_QUEUE) {
> > +             fd = -EPERM;
> > +             if (!capable(CAP_SYS_ADMIN))
> > +                     goto out_put_group;
> 
> Either this capable call is not needed or the one at the top of the syscall
> needs to go if you intended to allow non-privileged access.

I realize they are redundant.  But it is starting down the path of
unpriv'd users.  I figure I already have to go back and audit everything
we do looking for places we shouldn't allow unpriv users, so no need to
add new ones without explicitly checking.

-Eric

