Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754296Ab0EaVmV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 17:42:21 -0400
Received: from www.tglx.de ([62.245.132.106]:59758 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751778Ab0EaVmT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 17:42:19 -0400
Date: Mon, 31 May 2010 23:41:55 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: James Bottomley <James.Bottomley@suse.de>
cc: Peter Zijlstra <peterz@infradead.org>,
       =?ISO-8859-15?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>, tytso@mit.edu,
       LKML <linux-kernel@vger.kernel.org>,
       Florian Mickler <florian@mickler.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       felipe.balbi@nokia.com, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
In-Reply-To: <1275149418.4503.128.camel@mulgrave.site>
Message-ID: <alpine.LFD.2.00.1005312250050.2933@localhost.localdomain>
References: <20100527222514.0a1710bf@lxorguk.ukuu.org.uk>  <Pine.LNX.4.44L0.1005271730180.3239-100000@iolanthe.rowland.org>  <20100527230806.4deb6de3@lxorguk.ukuu.org.uk>  <20100527220949.GB10602@srcf.ucam.org>  <20100527232357.6d14fdb2@lxorguk.ukuu.org.uk>
  <20100527223605.GB11364@srcf.ucam.org>  <20100527235546.09f3ce8a@lxorguk.ukuu.org.uk>  <20100528043114.GC26177@thunk.org> <1275030704.32462.11.camel@laptop>  <AANLkTikEtlbkT4Ws3H2YGt_9QC46B5dr-b1oxJOcG4GN@mail.gmail.com>  <1275120618.27810.12699.camel@twins>
 <1275149418.4503.128.camel@mulgrave.site>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 29 May 2010, James Bottomley wrote:
> On Sat, 2010-05-29 at 10:10 +0200, Peter Zijlstra wrote:
> > 
> > Not using suspend is exactly the point. As Alan has argued, propagating
> > suspend blockers up into all regions of userspace will take much longer
> > than fixing the hardware.
> 
> Strange, that's not what I heard as the possible solution.  I thought he
> was advocating expressing the kernel side of suspend blockers as QoS
> constraints.  Once we have QoS constraints correctly done in the kernel,
> userspace still has to express its requirements.  If the requirements
> are static, then they can be done from policy files or in some other
> static way but if they're dynamic, they'll still have to be in the
> applications ... in about the same places the android wakelocks are.

That's wrong. You only need the explicit dynamic QoS constraints for
applications which follow the scheme:

     while (1) {
     	   if (event_available())
	      process_event();
	   else
	      do_useless_crap_which_consumes_power();
     }	   

which need the following annotation:

     while (1) {
     	   block_suspend();
     	   if (event_available()) {
	      process_event();
	      unblock_suspend();
	   } else {
	      unblock_suspend();
	      do_useless_crap_which_consumes_power();
           }
     }	   

Plus the kernel counterpart of drivers which take the suspend blocker
in the interrupt handler and release it when the event queue is empty.

So that's done for making polling event handling power "efficient".

Even worse, you need the same "annotation" for non polling mode and it
enforces the use of select() because you cannot take a suspend blocker
across a blocking read() without adding more invasive interactions to
the kernel..

So the "sane" app looks like:

   while (1) {
   	 select();
	 block_suspend();
	 process_events();
	 unblock_suspend();
   }

I'm really tired of arguing that this promotion of "programming style"
is the worst idea ever, so let's look how you can do the same thing
QoS based.

s/block_suspend()/qos(INTERACTIVE)/ and
s/unblock_suspend()/qos(NONE)/ and
s/block_magic()/qos_magic()/ in the drivers.

Yes, it's mostly the same, with a subtle difference:

While android can use it in the big hammer approach to disable the
existing user initiated suspend via /sys/power/state, the rest of the
world can benefit as well in various ways.

 - Sane applications which use a blocking event wait can be handled
   with a static QoS setting simply because a blocking read relies on
   the QoS state of the underlying I/O system.

 - Idle based suspend as the logical consequence of idle states is
   just a matter of QoS constraint based decisions.

 - Untrusted apps can be confined in cgroups. The groups are set to
   QoS(None) when user land decides that it's time to safe power
   (e.g. screen lock kicks in)

 - QoS states can block applications from I/O when the I/O system is
   set to a state which is exclusive.

  - ...

So that allows to use the same mechanism for more than the android
sledge hammer approach and confines the controversial use cases into
android specific files without adding a hard to maintain user space
interface which would prevent or at least make it hard to do some of
the above mentioned things which we want to see implemented.

While I personally disagree with the android approach, I REALLY want
to provide them a mechanism to make it work, but not for the price
that it actively prevents solutions which are considered to be
technically superior by a relevant group of developers/maintainers.

> > You got to realize this is about Linux as a whole, I really don't care
> > one whit about the specific Android case. We want a solution that is
> > generic enough to solve the power consumption problem and makes sense on
> > future hardware.
> 
> I don't think anyone disagrees with this. As long as we find a long term
> solution that satisfies the android case, everyone will be happy.

See above.

Thanks,

	tglx
