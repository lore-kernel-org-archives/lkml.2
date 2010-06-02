Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933305Ab0FBXGX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 19:06:23 -0400
Received: from ist.d-labs.de ([213.239.218.44]:40870 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933172Ab0FBXGV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 19:06:21 -0400
Date: Thu, 3 Jun 2010 01:06:07 +0200
From: Florian Mickler <florian@mickler.org>
To: James Bottomley <James.Bottomley@suse.de>
Cc: Arve =?ISO-8859-15?Q?Hj=F8nnev=E5g?= <arve@android.com>,
       Neil Brown <neilb@suse.de>, tytso@mit.edu,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, mark.gross@intel.com,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>, felipe.balbi@nokia.com
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
Message-ID: <20100603010607.5baf82a6@schatten.dmk.lab>
In-Reply-To: <1275511271.2799.516.camel@mulgrave.site>
References: <20100527232357.6d14fdb2@lxorguk.ukuu.org.uk>
	<20100601135102.GA8098@srcf.ucam.org>
	<1275426085.21962.967.camel@mulgrave.site>
	<201006020024.14220.rjw@sisk.pl>
	<1275431816.21962.1108.camel@mulgrave.site>
	<AANLkTikObnAZbyOxeYAhXcEbimO3XTTO-HlC9CD_HH6t@mail.gmail.com>
	<1275451342.21962.1777.camel@mulgrave.site>
	<AANLkTilRcFZyYa-0HlaM-6IEZSyar3S9S_cCWSFax2Zo@mail.gmail.com>
	<1275491111.2799.110.camel@mulgrave.site>
	<20100602214748.7742e3ae@schatten.dmk.lab>
	<1275511271.2799.516.camel@mulgrave.site>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 02 Jun 2010 15:41:11 -0500
James Bottomley <James.Bottomley@suse.de> wrote:

> On Wed, 2010-06-02 at 21:47 +0200, Florian Mickler wrote:
> > On Wed, 02 Jun 2010 10:05:11 -0500
> > James Bottomley <James.Bottomley@suse.de> wrote:
> > 
> > > On Tue, 2010-06-01 at 21:41 -0700, Arve Hjønnevåg wrote:
> > > > No, they have to be two separate constraints, otherwise a constraint
> > > > to block suspend would override a constraint to block a low power idle
> > > > mode or the other way around.
> > > 
> > > Depends.  If you block the system from going into low power idle, does
> > > that mean you still want it to be fully suspended?
> > > 
> > > If yes, then we do have independent constraints.  If not, they have a
> > > hierarchy:
> > > 
> > >       * Fully Interactive (no low power idle or suspend)
> > >       * Partially Interactive (may go into low power idle but not
> > >         suspend)
> > >       * None (may go into low power idle or suspend)
> > > 
> > > Which is expressable as a ternary constraint.
> > > 
> > > James
> > > 
> > 
> > But unblocking suspend at the moment is independent to getting idle.
> > If you have the requirement to stay in the highest-idle level (i.e.
> > best latency you can get) that does not (currently) mean, that you can
> > not suspend.
> 
> I don't understand that as a reason.  If we looks at this a qos
> constraints, you're saying that the system may not drop into certain low
> power states because it might turn something off that's currently being
> used by a driver or a process.  Suspend is certainly the lowest state of
> that because it turns everything off, why would it be legal to drop into
> that?
> 
> I also couldn't find this notion of separation of idleness power from
> suspend blocking in the original suspend block patch set ... if you can
> either tell me where it is, or give me an example of the separated use
> cases, I'd understand better.
> 
> > To preserve that explicit fall-through while still having working
> > run-time-powermanagement I think the qos-constraints need to be
> > separated. 
> 
> OK, as above, why?  or better yet, just give an example.

Hm. Maybe it is me who doesn't understand. 

With proposed patchset: 
1. As soon as we unblock suspend we go down.  (i.e. suspending)
2. While suspend is blocked, the idle-loop does it's things. (i.e.
runtime power managment -> can give same power-result as suspend)

possible cases:
1: 
   - qos-latency-constraints: 1ms,  [here: forbids anything other than
     C1 idle state.]
   - suspend is blocked

2: - qos latency-constraints: as in 1
   - suspend unblocked

3: - qos latency-constraints: infinity, cpu in lowest power state.
   - suspend is blocked

4: - qos latency-constraints: infinity, cpu in lowest power state.
   - suspend unblocked


in case 2 and 4 we would suspend, regardeless of the qos-latency.

in case 1 and 3 we would stay awake, regardeless of the qos-latency
constraint.


If only one constraint, then case 2 (or 3) wouldn't be possible. But it
is possible now. 

A possible use case as an example?
(hmm... i'm trying my imagination hard now): 
	Your sound needs low latency, so that could be a cause for the
	qos-latency constraint. 

	And unblocking suspend could nonetheless happen:
	For example... you have an firefox open and don't want to
	prevent suspend for that case when the display is turned off


Cheers,
Flo

