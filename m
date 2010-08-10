Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932162Ab0HJO4s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 10:56:48 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:58509 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932129Ab0HJO4m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 10:56:42 -0400
Date: Tue, 10 Aug 2010 15:55:52 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: paulmck@linux.vnet.ibm.com, "Ted Ts'o" <tytso@mit.edu>,
        Felipe Contreras <felipe.contreras@gmail.com>, david@lang.hm,
        Brian Swetland <swetland@google.com>,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        arve@android.com, pavel@ucw.cz, florian@mickler.org, rjw@sisk.pl,
        stern@rowland.harvard.edu, peterz@infradead.org, tglx@linutronix.de,
        menage@google.com, david-b@pacbell.net, James.Bottomley@suse.de,
        arjan@infradead.org, swmike@swm.pp.se, galibert@pobox.com,
        dipankar@in.ibm.com
Subject: Re: Attempted summary of suspend-blockers LKML thread, take three
Message-ID: <20100810145552.GA13798@srcf.ucam.org>
References: <20100808155719.GB3635@thunk.org> <AANLkTinM5e2HGOFavODPZNzZx4KshDSjsvKN4pLpGGgr@mail.gmail.com> <20100808213821.GD3635@thunk.org> <20100809112453.77210acc@lxorguk.ukuu.org.uk> <20100809181638.GI3026@linux.vnet.ibm.com> <20100809201822.441905f7@lxorguk.ukuu.org.uk> <20100810044541.GA2817@linux.vnet.ibm.com> <20100810093849.138e2318@lxorguk.ukuu.org.uk> <20100810141107.GA12873@srcf.ucam.org> <20100810154026.75efa370@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100810154026.75efa370@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 10, 2010 at 03:40:26PM +0100, Alan Cox wrote:
> > > Losing data is a design choice ? The application set a timer, the OS
> > > shouldn't be ignoring it in that situation. It might want to delay it, it
> > > might want to warn the user its hogging things it shouldnt (powertop,
> > > battery usage monitors in Android etc)
> > 
> > So we should remove explicit system suspend from the kernel?
> 
> Explicit suspend is user triggered - in the laptop case its a bit
> different. I don't btw like the fact that a laptop explicit suspend
> doesn't end up as a dbus "save data" and openoffice save (or it didn't
> last time I looked which is a while ago).

It's not inherently user triggered. Machines typically have an idle 
timeout that triggers suspend. This differs from the Android 
opportunistic suspend approach only in that the timeout is significantly 
larger, primarily due to the greater latency involved.

> > There's a clear and absolute difference between system suspend and 
> > entering the same hardware state from the idle loop. That difference is 
> > that processes aren't scheduled until an explicit wakeup event occurs. 
> > Android is entirely capable of entering the same low power state at idle 
> > (it's done with a hardcoded idle loop on Qualcomm, cpuidle on omap), but 
> > if you have more than 0 scheduling wakeups a second then your power draw 
> > is going to be greater. 
> 
> And nothing stops you also implementing a 'forced' suspend, although you
> can do that nicely by simply stopping the process group that contains the
> stuff you don't want to stop suspend and dropping into suspend when you
> idle.

We've already had the discussion about this resulting in potential 
deadlocks if there's any intercommunication between the trusted and 
untrusted apps, and if untrusted apps can be the consumers of wakeup 
events then you still end up with the wake event race condition. If we 
want to avoid the case where system suspend can cause wakeup events to 
be lost, we're pretty much required to implement something like suspend 
blocks (and, in fact, Rafael's implementation of this is already 
mainline).

> > I agree that we should be targetting 0 wakeups per second. I don't agree 
> > that it's realistic to insist that a use model that assumes imperfect 
> > software is an invalid use model.
> 
> No argument.
> 
> The question is what applications should be expressing to the kernel
> which is not tied to assumptions like 'suspend mode' and which is generic.
> 
> We don't have xfs stuff for example splattered all over userspace and in
> lots of drivers - we have generic interfaces. That way user community A
> doesn't have to care about user community B's choices, and JFFS flash fs
> people don't offend big data centre people and vice versa.

I wholeheartedly agree. But nobody has yet provided a generic approach 
to avoiding the loss of wakeup events, and that's an issue you can hit 
whenever you use full-system suspend - it's not a problem that's unique 
to Android.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
