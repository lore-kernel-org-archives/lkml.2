Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755099Ab0JRLFh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 07:05:37 -0400
Received: from mx3.sophos.com ([74.202.89.160]:38588 "EHLO mx3.sophos.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754899Ab0JRLFg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 07:05:36 -0400
From: Tvrtko Ursulin <tvrtko.ursulin@sophos.com>
Organization: Sophos Plc
To: Eric Paris <eparis@redhat.com>
Subject: Re: [BUG][PATCH][2.6.36-rc3] fanotify: Do not ignore result of permission decisions
Date: Mon, 18 Oct 2010 12:05:34 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.34.7-0.3-desktop; KDE/4.4.4; x86_64; ; )
CC: Andreas Gruenbacher <agruen@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
References: <201009071608.02290.tvrtko.ursulin@sophos.com> <201010081711.24373.tvrtko.ursulin@sophos.com> <1286556660.2682.72.camel@localhost.localdomain>
In-Reply-To: <1286556660.2682.72.camel@localhost.localdomain>
MIME-Version: 1.0
Message-ID: <201010181205.34294.tvrtko.ursulin@sophos.com>
X-MIMETrack: Itemize by SMTP Server on Mercury/Servers/Sophos(Release 7.0.3|September 26, 2007) at
 18/10/2010 12:05:34,
	Serialize by Router on Mercury/Servers/Sophos(Release 7.0.3|September 26, 2007) at
 18/10/2010 12:05:34,
	Serialize complete at 18/10/2010 12:05:34
X-TNEFEvaluated: 1
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 08 Oct 2010 17:51:00 Eric Paris wrote:
> On Fri, 2010-10-08 at 17:11 +0100, Tvrtko Ursulin wrote:
> > On Friday 08 Oct 2010 14:00:40 Andreas Gruenbacher wrote:
> > > Tvrtko,
> > >
> > > On Wednesday 08 September 2010 10:24:04 Tvrtko Ursulin wrote:
> > > >                 }
> > > >
> > > > +#ifdef CONFIG_FANOTIFY_ACCESS_PERMISSIONS
> > > > +               /* If a listener denied on a permission event we will
> > > > remember the reason +                  and run the rest with a
> > > > non-permission mask only. This allows other +
> > > > listeners to receive non-permission notifications but we do not care
> > > > +
> > > >
> > > >      about further permission checks and want to deny this event. */
> > > >      +
> > > >
> > > >             if (unlikely((res == -EPERM) && (mask &
> > > >
> > > > FS_ALL_PERM_EVENTS))) {
> > >
> > > We should probably stop processing here whenever res != 0, for any
> > > mask. (The fanotify and inotify handle_event callbacks can return
> > > -ENOMEM right now, but this doesn't seem very useful and should
> > > probably be fixed: fsnotify has no way of doing anything about
> > > -ENOMEM.
> >
> > I wasn't 100% sure of how fanotify works, or in other words can there be
> > more events in this mask after perm events are removed. If it can then
> > we should send them to other listeners. Eric?
> >
> > Also if ENOMEM, why not try sending to other listeners?
>
> No, you'll never have a PERM_EVENT and something else at the same time.
> If it's a PERM_EVENT denial we wouldn't really want to even notify
> others, since the operation won't have actually taken place (perm event
> denials should be passed all the way back up the stack)

Ok, I wasn't sure if event merging could somehow join more events on one
object into one event here.

> As to ENOMEM that's a little harder I guess.  We don't have to stop just
> because inotify got ENOMEM, but we should stop if PERM_EVENTS got an
> ENOMEM.
>
> I'd really rather not put CONFIG_FANOTIFY_ACCESS_PERMISSIONS in this
> file.  fsnotify.c should be notifier agnostic.
>
> How about just:
>
> if (unlikely(ret && (mask & ALL_PERM)))
>       return ret

Looks like it would work and on more thinking I also agree with the logic to
stop the perm chain on ENOMEM.

Tvrtko

Sophos Plc, The Pentagon, Abingdon Science Park, Abingdon, OX14 3YP, United Kingdom.
Company Reg No 2096520. VAT Reg No GB 348 3873 20.
