Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753230Ab2AUQLR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jan 2012 11:11:17 -0500
Received: from netrider.rowland.org ([192.131.102.5]:45833 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752489Ab2AUQLK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jan 2012 11:11:10 -0500
Date: Sat, 21 Jan 2012 11:11:09 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Simon Glass <sjg@chromium.org>
cc: LKML <linux-kernel@vger.kernel.org>, Greg Kroah-Hartman <gregkh@suse.de>,
        <linux-usb@vger.kernel.org>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>
Subject: Re: [PATCH] usb: Use a workqueue in usb_add_hcd() to reduce boot
 time
In-Reply-To: <CAPnjgZ0-VdAzudGFopBd+5j4HhOp10C=x0kPuJEZyaYSzwjBAA@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1201211055180.24505-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Jan 2012, Simon Glass wrote:

> Thanks for the comments.
> 
> > Too bad Linus didn't send this message to the linux-usb mailing list;
> > it might have received more attention.  Also, it's not clear what he
> > meant by "does all the probing too" -- since usb_add_hcd() is called
> > from within various drivers' probe routines, it seems only reasonable
> > that it _should_ do probing.
> 
> Well the problem is that we are trying to boot the kernel, so
> time-consuming things should be done later or in parallel where
> possible.

Doing time-consuming things later won't make any difference.  That is,
suppose the boot sequence performs activities A and B, where A takes a
long time.  Doing A later, so that the boot sequence performs B and
then A, won't change the total time required.

Doing things in parallel, on the other hand, can indeed save time.

> >> It might be better to delay the work until much later unless USB is needed
> >> for the root disk, but that might have to be a command line option.
> >
> > This may be a worthy goal, but your implementation is not good.  In
> > particular, if asynchronous usb_add_hcd fails then the driver should
> > not remain bound to the controller device.  Did you test what happens
> > when the delayed routine fails and you then try to unload the host
> > controller driver?
> 
> First, backing up a bit, there are at least two ways to solve this.
> One is to have the drivers only call usb_add_hcd() from a work queue
> or similar - i.e. not as part of their initcall execution. The other
> is what I have done here.
> 
> Before I go much further I would like to know which is
> best/preferable. Because in answer to your questions I'm not sure
> drivers have a way of dealing with failure of delayed init. It would
> need notification back to the driver at least.

That's right; all the host controller drivers would need to be modified 
to handle async probing errors.  There's no way to do what you want by 
changing only the USB core.

However, because there are so many drivers, it would be best if the 
driver changes could be minimized.  It's up to you to decide the best 
balance of effort between the drivers and the core, but you can't avoid 
the need to change them at least a little.

> > a delayed_work structure that is only going to be used once -- why not
> > allocate and free it separately instead?  And you created an entire new
> 
> I originally did it that way, but it's more complicated. I can change
> it back easily enough.

Okay, good.

> > workqueue just for registering new USB controllers; what's wrong with
> > using the system workqueue?
> 
> Nothing - perhaps I could use system_long_wq without anyone
> complaining about delays.

system_freezable_wq would be better.  Among other things, usb_add_hcd 
registers the HC's root hub, which must not happen while the system is 
preparing for suspend.

> > Finally, what justification is there for delaying everything by one
> > second?  If a USB controller is critical then you don't want to delay
> > it at all, if the controller was hotplugged some time after booting
> > then a delay doesn't matter, and if the action takes place during
> > booting then a 1-second delay isn't going to be long enough to make any
> > difference.
> 
> My purpose was to get feedback on what is acceptable. Re your last
> point it does seem to make a difference since other things can init in
> that time.

See my comments above.  The total amount of work done by the system 
remains the same; the advantage to running in parallel is that one task 
can run while another is waiting.

> As I said above my real uncertainty is where to consider that the
> 'pure init' is be done, and move the rest into a work queue. Maybe
> usb_add_hcd() should stop at the transition to HC_STATE_RUNNING (i.e.
> before calling the driver's ->start method), and return success?

Have you collected timings for both the reset and start methods, as
well as the other parts of usb_add_hcd?  Knowing what parts take
longest will help guide your decision.  I suspect you'll find that both 
methods take long enough to be worth putting in the work queue.

Alan Stern

