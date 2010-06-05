Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755706Ab0FETGH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jun 2010 15:06:07 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:55078 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753213Ab0FETGD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jun 2010 15:06:03 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: markgross@thegnar.org
Subject: Re: PM_QOS re-design for hot path use of limited dynamic range requests was- Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
Date: Sat, 5 Jun 2010 21:07:32 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.35-rc1-rjw; KDE/4.3.5; x86_64; ; )
Cc: James Bottomley <James.Bottomley@suse.de>,
       Arve =?iso-8859-1?q?Hj=F8nnev=E5g?= <arve@android.com>,
       640e9920@gmail.com, Peter Zijlstra <peterz@infradead.org>,
       Brian Swetland <swetland@google.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Florian Mickler <florian@mickler.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
References: <AANLkTikxws5kmFhnBO1MLzE65ETka3Jy0R5ayAKTS1Lc@mail.gmail.com> <1275661390.4455.31.camel@mulgrave.site> <20100605040638.GB20419@gvim.org>
In-Reply-To: <20100605040638.GB20419@gvim.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201006052107.32318.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 05 June 2010, mark gross wrote:
> On Fri, Jun 04, 2010 at 09:23:10AM -0500, James Bottomley wrote:
> > On Thu, 2010-06-03 at 21:07 -0700, Arve Hjønnevåg wrote:
> > > On Thu, Jun 3, 2010 at 2:05 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > > > On Thursday 03 June 2010, James Bottomley wrote:
> > > >> On Thu, 2010-06-03 at 00:10 -0700, Arve Hjønnevåg wrote:
> > > >> > On Wed, Jun 2, 2010 at 10:40 PM, mark gross <640e9920@gmail.com> wrote:
> > > >> > > On Wed, Jun 02, 2010 at 09:54:15PM -0700, Brian Swetland wrote:
> > > >> > >> On Wed, Jun 2, 2010 at 8:18 PM, mark gross <640e9920@gmail.com> wrote:
> > > >> > >> > On Wed, Jun 02, 2010 at 02:58:30PM -0700, Arve Hjønnevåg wrote:
> > > >> > >> >>
> > > >> > >> >> The list is not short. You have all the inactive and active
> > > >> > >> >> constraints on the same list. If you change it to a two level list
> > > >> > >> >> though, the list of unique values (which is the list you have to walk)
> > > >> > >> >> may be short enough for a tree to be overkill.
> > > >> > >> >
> > > >> > >> > what have you seen in practice from the wake-lock stats?
> > > >> > >> >
> > > >> > >> > I'm having a hard time seeing where you could get more than just a
> > > >> > >> > handfull.  However; one could go to a dual list (like the scheduler) and
> > > >> > >> > move inactive nodes from an active to inactive list, or we could simply
> > > >> > >> > remove them from the list uppon inactivity.  which would would well
> > > >> > >> > after I change the api to have the client allocate the memory for the
> > > >> > >> > nodes...  BUT, if your moving things in and out of a list a lot, I'm not
> > > >> > >> > sure the break even point where changing the structure helps.
> > > >> > >> >
> > > >> > >> > We'll need to try it.
> > > >> > >> >
> > > >> > >> > I think we will almost never see more than 10 list elements.
> > > >> > >> >
> > > >> > >> > --mgross
> > > >> > >> >
> > > >> > >> >
> > > >> > >>
> > > >> > >> I see about 80 (based on the batteryinfo dump) on my Nexus One
> > > >> > >> (QSD8250, Android Froyo):
> > > >> > >
> > > >> > > shucks.
> > > >> > >
> > > >> > > well I think for a pm_qos class that has boolean dynamic range we can
> > > >> > > get away with not walking the list on every request update.  we can use
> > > >> > > a counter, and the list will be for mostly for stats.
> > > >> > >
> > > >> >
> > > >> > Did you give any thought to my suggestion to only use one entry per
> > > >> > unique value on the first level list and then use secondary lists of
> > > >> > identical values. That way if you only have two constraints values the
> > > >> > list you have to walk when updating a request will never have more
> > > >> > than two entries regardless of how many total request you have.
> > > >> >
> > > >> > A request update then becomes something like this:
> > > >> >   if on primary list {
> > > >> >     unlink from primary list
> > > >> >     if secondary list is not empty
> > > >> >       get next secondary entry and add in same spot on primary list
> > > >> >   }
> > > >> >   unlink from secondary list
> > > >> >   find new spot on primary list
> > > >> >   if already there
> > > >> >     add to secondary list
> > > >> >   else
> > > >> >     add to primary list
> > > >>
> > > >> This is just reinventing hash bucketed lists.  To get the benefits, all
> > > >> we do is implement an N state constraint as backed by an N bucketed hash
> > > >> list, which the kernel already has all the internal mechanics for.
> > > >
> > > > Agreed.
> > > >
> > > 
> > > No, a hash is used for quick lookup of a specific value, not to find
> > > an extreme value.
> > 
> > If you only have N possible values an N bucket hash list is rather
> > efficient (provided N is small).  But I would agree that knowing what N
> > is represents an API change, and since plists can do this without
> > changing the API, they're better.
> > 
> > >  It is however extremely similar to plists. The only
> > > difference is that plists link all the secondary lists together.
> > 
> > Right, so they would solve the *current* problem exactly.
> > 
> > >  If we
> > > want to have constraints that autoexpire, then keeping the secondary
> > > lists separate allows the same optimization as I did for
> > > wakelock/suspend_blocker timeouts where no timer is active if an
> > > (equal or stricter) non-expiring constraint is active.
> > 
> > But this is a future discussion and not part of the patch.  The way open
> > source works is that we sort out the best implementation for the current
> > conditions.  If the implementation has to change because of future
> > stuff, then we change it when the future stuff comes along.  Changing
> > implementations is easy (they don't have any externally visible impact).
> > Changing the in-kernel API is slightly harder, but easily doable.  It's
> > only changing the user visible ABI that we worry about and try not to
> > do.
> >
> 
> True.
> 
> The following is what I think I'll work on this weekend.  (hopefully
> have some sort of patch that at least compiles...)
> 
> 
> Changes to pm_qos to enable "wakelock" or "suspend blocker" support:
> 
> Requirements:
> 1) atomic context support.
> 2) make updating request fast enough for hot path users.
> 3) Add a request class for "interactive_suspend", this particular
> request has a dynamic range of 1 (its 0 or 1).  If zero then ok to auto
> suspend, if 1 then only user driven suspend.  Whenever the aggregate
> request changes value the registered notifiers are called.
> 
> 
> Implementation:
> * change api to have caller allocated the qos request structures. (solve
> the kalloc issue)
> * add plist use for constraint classes with hash-able dynamic ranges

Please have a look at the patch James posted earlier today on linux-pm,
you were CCed.

Rafael
