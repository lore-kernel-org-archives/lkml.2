Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754907Ab0EaWWw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 18:22:52 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:35803 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751717Ab0EaWWu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 18:22:50 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
Date: Tue, 1 Jun 2010 00:23:59 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.35-rc1-rjw; KDE/4.3.5; x86_64; ; )
Cc: James Bottomley <James.Bottomley@suse.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Arve =?iso-8859-1?q?Hj=F8nnev=E5g?= <arve@android.com>, tytso@mit.edu,
       LKML <linux-kernel@vger.kernel.org>,
       Florian Mickler <florian@mickler.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       felipe.balbi@nokia.com, Alan Cox <alan@lxorguk.ukuu.org.uk>
References: <20100527222514.0a1710bf@lxorguk.ukuu.org.uk> <1275149418.4503.128.camel@mulgrave.site> <alpine.LFD.2.00.1005312250050.2933@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.1005312250050.2933@localhost.localdomain>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201006010024.00032.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 31 May 2010, Thomas Gleixner wrote:
> On Sat, 29 May 2010, James Bottomley wrote:
> > On Sat, 2010-05-29 at 10:10 +0200, Peter Zijlstra wrote:
> > > 
> > > Not using suspend is exactly the point. As Alan has argued, propagating
> > > suspend blockers up into all regions of userspace will take much longer
> > > than fixing the hardware.
> > 
> > Strange, that's not what I heard as the possible solution.  I thought he
> > was advocating expressing the kernel side of suspend blockers as QoS
> > constraints.  Once we have QoS constraints correctly done in the kernel,
> > userspace still has to express its requirements.  If the requirements
> > are static, then they can be done from policy files or in some other
> > static way but if they're dynamic, they'll still have to be in the
> > applications ... in about the same places the android wakelocks are.
> 
> That's wrong. You only need the explicit dynamic QoS constraints for
> applications which follow the scheme:
> 
>      while (1) {
>      	   if (event_available())
> 	      process_event();
> 	   else
> 	      do_useless_crap_which_consumes_power();
>      }	   
> 
> which need the following annotation:
> 
>      while (1) {
>      	   block_suspend();
>      	   if (event_available()) {
> 	      process_event();
> 	      unblock_suspend();
> 	   } else {
> 	      unblock_suspend();
> 	      do_useless_crap_which_consumes_power();
>            }
>      }	   
> 
> Plus the kernel counterpart of drivers which take the suspend blocker
> in the interrupt handler and release it when the event queue is empty.
> 
> So that's done for making polling event handling power "efficient".
> 
> Even worse, you need the same "annotation" for non polling mode and it
> enforces the use of select() because you cannot take a suspend blocker
> across a blocking read() without adding more invasive interactions to
> the kernel..
> 
> So the "sane" app looks like:
> 
>    while (1) {
>    	 select();
> 	 block_suspend();
> 	 process_events();
> 	 unblock_suspend();
>    }
> 
> I'm really tired of arguing that this promotion of "programming style"
> is the worst idea ever, so let's look how you can do the same thing
> QoS based.
> 
> s/block_suspend()/qos(INTERACTIVE)/ and
> s/unblock_suspend()/qos(NONE)/ and
> s/block_magic()/qos_magic()/ in the drivers.
> 
> Yes, it's mostly the same, with a subtle difference:
> 
> While android can use it in the big hammer approach to disable the
> existing user initiated suspend via /sys/power/state, the rest of the
> world can benefit as well in various ways.
> 
>  - Sane applications which use a blocking event wait can be handled
>    with a static QoS setting simply because a blocking read relies on
>    the QoS state of the underlying I/O system.
> 
>  - Idle based suspend as the logical consequence of idle states is
>    just a matter of QoS constraint based decisions.
> 
>  - Untrusted apps can be confined in cgroups. The groups are set to
>    QoS(None) when user land decides that it's time to safe power
>    (e.g. screen lock kicks in)
> 
>  - QoS states can block applications from I/O when the I/O system is
>    set to a state which is exclusive.
> 
>   - ...
> 
> So that allows to use the same mechanism for more than the android
> sledge hammer approach and confines the controversial use cases into
> android specific files without adding a hard to maintain user space
> interface which would prevent or at least make it hard to do some of
> the above mentioned things which we want to see implemented.

I generally agree.

I think the Alan Stern's recent proposal goes along these lines, but it has
the advantage of being a bit more specific. ;-)

Thanks,
Rafael
