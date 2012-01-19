Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932754Ab2ASTNy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 14:13:54 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:37354 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932537Ab2ASTNw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 14:13:52 -0500
Date: Thu, 19 Jan 2012 11:13:37 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Simon Glass <sjg@chromium.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        LKML <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-serial@vger.kernel.org
Subject: Re: [PATCH 3/3] serial: 8250: Add a wakeup_capable module param
Message-ID: <20120119191337.GB2373@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1326826563-32215-1-git-send-email-sjg@chromium.org>
 <CAPnjgZ1g0Gf8ZCavAbmxjJXxxk9duf1ybbEUNo9L-DHBxyXx-g@mail.gmail.com>
 <20120118224304.GJ2431@linux.vnet.ibm.com>
 <201201190102.58788.rjw@sisk.pl>
 <20120119013731.GK2431@linux.vnet.ibm.com>
 <CAPnjgZ1zFHzihG51qHM-dk5Ou5vig0JL62LNFATmDwbQo_r+FQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAPnjgZ1zFHzihG51qHM-dk5Ou5vig0JL62LNFATmDwbQo_r+FQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12011919-4242-0000-0000-0000008E7459
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 18, 2012 at 06:35:56PM -0800, Simon Glass wrote:
> Hi Paul,
> 
> On Wed, Jan 18, 2012 at 5:37 PM, Paul E. McKenney
> <paulmck@linux.vnet.ibm.com> wrote:
> > On Thu, Jan 19, 2012 at 01:02:58AM +0100, Rafael J. Wysocki wrote:
> >> On Wednesday, January 18, 2012, Paul E. McKenney wrote:
> >> > On Wed, Jan 18, 2012 at 02:15:59PM -0800, Simon Glass wrote:
> >> > > Hi Paul,
> >> > >
> >> > > On Wed, Jan 18, 2012 at 1:42 PM, Paul E. McKenney
> >> > > <paulmck@linux.vnet.ibm.com> wrote:
> >> > > > On Wed, Jan 18, 2012 at 01:08:13PM -0800, Simon Glass wrote:
> >> > > >> [+cc Rafael J. Wysocki <rjw@sisk.pl> who I think wrote the wakeup.c code]
> >> > > >>
> >> > > >> Hi Alan, Paul,
> >> > > >>
> >> > > >> On Tue, Jan 17, 2012 at 8:17 PM, Paul E. McKenney
> >> > > >> <paulmck@linux.vnet.ibm.com> wrote:
> >> > > >> > On Tue, Jan 17, 2012 at 08:10:36PM +0000, Alan Cox wrote:
> >> > > >> >> On Tue, 17 Jan 2012 10:56:03 -0800
> >> > > >> >> Simon Glass <sjg@chromium.org> wrote:
> >> > > >> >>
> >> > > >> >> > Since serial_core now does not make serial ports wake-up capable by
> >> > > >> >> > default, add a parameter to support this feature in the 8250 UART.
> >> > > >> >> > This is the only UART where I think this feature is useful.
> >> > > >> >>
> >> > > >> >> NAK
> >> > > >> >>
> >> > > >> >> Things should just work for users. Magic parameters is not an
> >> > > >> >> improvement. If its a performance problem someone needs to fix the rcu
> >> > > >> >> sync overhead or stop using rcu on that path.
> >> > > >>
> >> > > >> OK fair enough, I agree. Every level I move down the source tree
> >> > > >> affects more people though.
> >> > > >>
> >> > > >> >
> >> > > >> > I must say that I lack context here, even after looking at the patch,
> >> > > >> > but the synchronize_rcu_expedited() primitives can be used if the latency
> >> > > >> > of synchronize_rcu() is too large.
> >> > > >> >
> >> > > >>
> >> > > >> Let me provide a bit of context. The serial_core code seems to be the
> >> > > >> only place in the kernel that does this:
> >> > > >>
> >> > > >>               device_init_wakeup(tty_dev, 1);
> >> > > >>               device_set_wakeup_enable(tty_dev, 0);
> >> > > >>
> >> > > >> The first call makes the device wakeup capable and enables wakeup, The
> >> > > >> second call disabled wakeup.
> >> > > >>
> >> > > >> The code that removes the wakeup source looks like this:
> >> > > >>
> >> > > >> void wakeup_source_remove(struct wakeup_source *ws)
> >> > > >> {
> >> > > >>       if (WARN_ON(!ws))
> >> > > >>               return;
> >> > > >>
> >> > > >>       spin_lock_irq(&events_lock);
> >> > > >>       list_del_rcu(&ws->entry);
> >> > > >>       spin_unlock_irq(&events_lock);
> >> > > >>       synchronize_rcu();
> >> > > >> }
> >> > > >>
> >> > > >> The sync is there because we are about to destroy the actual ws
> >> > > >> structure (in wakeup_source_destroy()). I wonder if it should be in
> >> > > >> wakeup_source_destroy() but that wouldn't help me anyway.
> >> > > >>
> >> > > >> synchronize_rcu_expedited() is a bit faster but not really fast
> >> > > >> enough. Anyway surely people will complain if I put this in the wakeup
> >> > > >> code - it will affect all wakeup users. It seems to me that the right
> >> > > >> solution is to avoid enabling and then immediately disabling wakeup.
> >> > > >
> >> > > > Hmmm...  What hardware are you running this one?  Normally,
> >> > > > synchronize_rcu_expedited() will be a couple of orders of magnitude
> >> > > > faster than synchronize_rcu().
> >> > > >
> >> > > >> I assume we can't and shouldn't change device_init_wakeup() . We could
> >> > > >> add a call like device_init_wakeup_disabled() which makes the device
> >> > > >> wakeup capable but does not actually enable it. Does that work?
> >> > > >
> >> > > > If the only reason for the synchronize_rcu() is to defer the pair of
> >> > > > kfree()s in wakeup_source_destroy(), then another possible approach
> >> > > > would be to remove the synchronize_rcu() from wakeup_source_remove()
> >> > > > and then use call_rcu() to defer the two kfree()s.
> >> > > >
> >> > > > If this is a reasonable change to make, the approach is as follows:
> >> > > >
> >> > > > 1.      Add a struct rcu_head to wakeup_source, call it "rcu".
> >> > > >        Or adjust the following to suit your choice of name.
> >> > > >
> >> > > > 2.      Replace the pair of kfree()s with:
> >> > > >
> >> > > >                call_rcu(&ws->rcu, wakeup_source_destroy_rcu);
> >> > > >
> >> > > > 3.      Create the wakeup_source_destroy_rcu() as follows:
> >> > > >
> >> > > >        static void wakeup_source_destroy_rcu(struct rcu_head *head)
> >> > > >        {
> >> > > >                struct wakeup_source *ws =
> >> > > >                        container_of(head, struct wakeup_source, rcu);
> >> > > >
> >> > > >                kfree(ws->name);
> >> > > >                kfree(ws);
> >> > > >        }
> >> > > >
> >> > > > Of course, this assumes that it is OK for wakeup_source_unregister()
> >> > > > to return before the memory is freed up.  This often is OK, but there
> >> > > > are some cases where the caller requires that there be no further
> >> > > > RCU readers with access to the old data.  In these cases, you really
> >> > > > do need the wait.
> >> > >
> >> > > Thanks very much for that. I'm not sure if it is a reasonable change,
> >> > > but it does bug me that we add it to a data structure knowing that we
> >> > > will immediately remove it!
> >> > >
> >> > > >From what I can see, making a device wakeup-enabled mostly happens on
> >> > > init or in response to a request to the driver (presumably from user
> >> > > space). In the latter case I suspect the synchronise_rcu() is fine. In
> >> > > the former it feels like we should make up our minds which of the
> >> > > three options is required (incapable, capable but not enabled, capable
> >> > > and enabled).
> >> > >
> >> > > I will try a patch first based on splitting the two options (capable
> >> > > and enable) and see if that get a NAK.
> >> > >
> >> > > Then I will come back to your solution - it seems fine to me and not a
> >> > > lot of code. Do we have to worry about someone enabling, disabled,
> >> > > enabling and then disabling wakeup quickly? Will this method break in
> >> > > that case if the second call to call_rcu() uses the same wc->rcu?
> >> >
> >> > There are a couple of questions here, let me take them one at a time:
> >> >
> >> > 1.  If you just disabled, can you immediately re-enable?
> >> >
> >> >     The answer is "yes".  The reason that this works is that you
> >> >     allocate a new structure for the re-enabling, and that new
> >> >     structure has its own rcu_head field.
> >> >
> >> > 2.  If you repeatedly disable and re-enable in a tight loop,
> >> >     can this cause problems?
> >> >
> >> >     The answer to this is also "yes" -- you can run the system
> >> >     out of memory doing that.  However, there are a number of
> >> >     simple ways to avoid this problem:
> >> >
> >> >     a.      Do a synchronize_rcu() on every (say) thousandth
> >> >             disable operation.
> >> >
> >> >     b.      As above, but only do the synchronize_rcu() if
> >> >             all 1,000 disable operations occurred within
> >> >             (say) a second of each other.
> >> >
> >> >     c.      As above, but actually count the number of
> >> >             pending call_rcu() callbacks.
> >> >
> >> >     Both (a) and (b) can be carried out on a per-CPU basis if there
> >> >     is no convenient locked structure in which to track the state.
> >> >     You cannot carry (c) out on a per-CPU basis because RCU callbacks
> >> >     can sometimes be invoked on a different CPU from the one that
> >> >     call_rcu()ed them.  Rare, but it can happen.
> >> >
> >> >     I would expect that option (a) would work in almost all cases.
> >> >
> >> > If this can be exercised freely from user space, then you probably
> >> > really do need #2 above.
> >>
> >> Yes, you can, but then I'd say it's not necessary for user space to
> >> be able to carry that out in a tight loop.  So, it seems, alternatively,
> >> we could make that loop a bit less tight, e.g. by adding an arbitrary
> >> sleep to the user space interface for the "disable" case.
> >
> > Good point, that would work just as well and be simpler.
> 
> OK, well I am expecting that this will now be a very small patch to
> change just serial_core.
> 
> Thanks for your help with this.

Glad to help, and even more glad that Alan and Rafael were able to help.  ;-)

							Thanx, Paul

