Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757740Ab0HJO3C (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 10:29:02 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:60689 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754860Ab0HJO26 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 10:28:58 -0400
Date: Tue, 10 Aug 2010 15:40:26 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Matthew Garrett <mjg59@srcf.ucam.org>
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
Message-ID: <20100810154026.75efa370@lxorguk.ukuu.org.uk>
In-Reply-To: <20100810141107.GA12873@srcf.ucam.org>
References: <20100807061558.GA28087@thunk.org>
	<AANLkTi=sMVjya9CH6UoZwJCXJTDRgBhnPXmApU_RHVTi@mail.gmail.com>
	<20100808155719.GB3635@thunk.org>
	<AANLkTinM5e2HGOFavODPZNzZx4KshDSjsvKN4pLpGGgr@mail.gmail.com>
	<20100808213821.GD3635@thunk.org>
	<20100809112453.77210acc@lxorguk.ukuu.org.uk>
	<20100809181638.GI3026@linux.vnet.ibm.com>
	<20100809201822.441905f7@lxorguk.ukuu.org.uk>
	<20100810044541.GA2817@linux.vnet.ibm.com>
	<20100810093849.138e2318@lxorguk.ukuu.org.uk>
	<20100810141107.GA12873@srcf.ucam.org>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Losing data is a design choice ? The application set a timer, the OS
> > shouldn't be ignoring it in that situation. It might want to delay it, it
> > might want to warn the user its hogging things it shouldnt (powertop,
> > battery usage monitors in Android etc)
> 
> So we should remove explicit system suspend from the kernel?

Explicit suspend is user triggered - in the laptop case its a bit
different. I don't btw like the fact that a laptop explicit suspend
doesn't end up as a dbus "save data" and openoffice save (or it didn't
last time I looked which is a while ago).

> There's a clear and absolute difference between system suspend and 
> entering the same hardware state from the idle loop. That difference is 
> that processes aren't scheduled until an explicit wakeup event occurs. 
> Android is entirely capable of entering the same low power state at idle 
> (it's done with a hardcoded idle loop on Qualcomm, cpuidle on omap), but 
> if you have more than 0 scheduling wakeups a second then your power draw 
> is going to be greater. 

And nothing stops you also implementing a 'forced' suspend, although you
can do that nicely by simply stopping the process group that contains the
stuff you don't want to stop suspend and dropping into suspend when you
idle.

> I agree that we should be targetting 0 wakeups per second. I don't agree 
> that it's realistic to insist that a use model that assumes imperfect 
> software is an invalid use model.

No argument.

The question is what applications should be expressing to the kernel
which is not tied to assumptions like 'suspend mode' and which is generic.

We don't have xfs stuff for example splattered all over userspace and in
lots of drivers - we have generic interfaces. That way user community A
doesn't have to care about user community B's choices, and JFFS flash fs
people don't offend big data centre people and vice versa.


Alan
