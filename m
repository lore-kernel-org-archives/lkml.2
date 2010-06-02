Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933286Ab0FBXDu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 19:03:50 -0400
Received: from cantor.suse.de ([195.135.220.2]:53410 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933161Ab0FBXDs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 19:03:48 -0400
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
From: James Bottomley <James.Bottomley@suse.de>
To: Arve =?ISO-8859-1?Q?Hj=F8nnev=E5g?= <arve@android.com>
Cc: tytso@mit.edu, Neil Brown <neilb@suse.de>, felipe.balbi@nokia.com,
       LKML <linux-kernel@vger.kernel.org>,
       Florian Mickler <florian@mickler.org>,
       Peter Zijlstra <peterz@infradead.org>, mark.gross@intel.com,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
In-Reply-To: <AANLkTikeHarkwvO5-Fdrxt1FzTQL2lGHiQXBSG0vsKob@mail.gmail.com>
References: <20100527232357.6d14fdb2@lxorguk.ukuu.org.uk>
	 <20100601135102.GA8098@srcf.ucam.org>
	 <1275426085.21962.967.camel@mulgrave.site> <201006020024.14220.rjw@sisk.pl>
	 <1275431816.21962.1108.camel@mulgrave.site>
	 <AANLkTikObnAZbyOxeYAhXcEbimO3XTTO-HlC9CD_HH6t@mail.gmail.com>
	 <1275451342.21962.1777.camel@mulgrave.site>
	 <AANLkTilRcFZyYa-0HlaM-6IEZSyar3S9S_cCWSFax2Zo@mail.gmail.com>
	 <1275491111.2799.110.camel@mulgrave.site>
	 <20100602214748.7742e3ae@schatten.dmk.lab>
	 <1275511271.2799.516.camel@mulgrave.site>
	 <AANLkTikeHarkwvO5-Fdrxt1FzTQL2lGHiQXBSG0vsKob@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 02 Jun 2010 18:03:38 -0500
Message-ID: <1275519818.2799.527.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-06-02 at 15:27 -0700, Arve Hjønnevåg wrote:
> On Wed, Jun 2, 2010 at 1:41 PM, James Bottomley <James.Bottomley@suse.de> wrote:
> > On Wed, 2010-06-02 at 21:47 +0200, Florian Mickler wrote:
> >> On Wed, 02 Jun 2010 10:05:11 -0500
> >> James Bottomley <James.Bottomley@suse.de> wrote:
> >>
> >> > On Tue, 2010-06-01 at 21:41 -0700, Arve Hjønnevåg wrote:
> >> > > No, they have to be two separate constraints, otherwise a constraint
> >> > > to block suspend would override a constraint to block a low power idle
> >> > > mode or the other way around.
> >> >
> >> > Depends.  If you block the system from going into low power idle, does
> >> > that mean you still want it to be fully suspended?
> >> >
> >> > If yes, then we do have independent constraints.  If not, they have a
> >> > hierarchy:
> >> >
> >> >       * Fully Interactive (no low power idle or suspend)
> >> >       * Partially Interactive (may go into low power idle but not
> >> >         suspend)
> >> >       * None (may go into low power idle or suspend)
> >> >
> >> > Which is expressable as a ternary constraint.
> >> >
> >> > James
> >> >
> >>
> >> But unblocking suspend at the moment is independent to getting idle.
> >> If you have the requirement to stay in the highest-idle level (i.e.
> >> best latency you can get) that does not (currently) mean, that you can
> >> not suspend.
> >
> > I don't understand that as a reason.  If we looks at this a qos
> > constraints, you're saying that the system may not drop into certain low
> > power states because it might turn something off that's currently being
> > used by a driver or a process.  Suspend is certainly the lowest state of
> > that because it turns everything off, why would it be legal to drop into
> > that?
> 
> Because the driver gets called on suspend which gives it a change to
> stop using it.
> 
> >
> > I also couldn't find this notion of separation of idleness power from
> > suspend blocking in the original suspend block patch set ... if you can
> > either tell me where it is, or give me an example of the separated use
> > cases, I'd understand better.
> >
> 
> The suspend block patchset only deals with suspend, not low power idle
> modes. The original wakelock patchset had two wakelock types, idle and
> suspend.

OK, so that explains why I didn't see it ...

> >> To preserve that explicit fall-through while still having working
> >> run-time-powermanagement I think the qos-constraints need to be
> >> separated.
> >
> > OK, as above, why?  or better yet, just give an example.
> >
> 
> The i2c bus on the Nexus One is used by the other core to turn off the
> power you our core when we enter the lowest power mode. This means
> that we cannot enter that low power mode while the i2c bus is active,
> so we block low power idle modes. At some point we also tries to block
> suspend in this case, but this caused a lot of failed suspend attempts
> since the frequency scaling code would try to ramp up while freezing
> processes which in turn aborted the process freezing attempts.

OK, so this is a device specific power constraint state.  I suppose it
makes sense to have a bunch of those, because the device isn't
necessarily going to know what idle power mode it can't go into, so the
cpu govenor should sort it out rather than have the device specify a
minimum state.  

James


