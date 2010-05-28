Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755751Ab0E1Nrt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 09:47:49 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:40857 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753178Ab0E1Nrs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 09:47:48 -0400
Date: Fri, 28 May 2010 14:54:20 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Arve =?ISO-8859-14?B?SGr4bm5lduVn?= <arve@android.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Florian Mickler <florian@mickler.org>, felipe.balbi@nokia.com,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
Message-ID: <20100528145420.1c06e4a3@lxorguk.ukuu.org.uk>
In-Reply-To: <20100528123110.GA23930@srcf.ucam.org>
References: <20100527222514.0a1710bf@lxorguk.ukuu.org.uk>
	<Pine.LNX.4.44L0.1005271730180.3239-100000@iolanthe.rowland.org>
	<20100527230806.4deb6de3@lxorguk.ukuu.org.uk>
	<20100527220949.GB10602@srcf.ucam.org>
	<20100527232357.6d14fdb2@lxorguk.ukuu.org.uk>
	<AANLkTil6Bo7qZltbLzHJjIDyruKHFQEURpe5LPJEpTws@mail.gmail.com>
	<20100528101755.7b5f6b8a@lxorguk.ukuu.org.uk>
	<AANLkTilYHKKmQePBGW3LVLjUZy7HXHQku2Iub-LWGBm6@mail.gmail.com>
	<20100528132138.2d802d77@lxorguk.ukuu.org.uk>
	<20100528123110.GA23930@srcf.ucam.org>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > 	The UI manager gets told the phone is 'down'
> > 	Ten seconds later it is still down
>             <- wakeup event that should be delivered to untrusted app arrives here
> 
> At this point you may mark the downtrodden group as ignored between the 
> untrusted app receiving the event and the untrusted app marking itself 
> as important. To avoid this you need the UI manager to receive every 
> wakeup event in order to change its scheduling decisions.

The event wakes the device, the event itself means the kernel is doing
bits so the kernel is active and we are not idled so we have a time
before we will consider re-suspending.

[If you accept that untrusted apps must be constrained then you can't
 allow one to mark itself important - or at least you can't listen to it
 doing so and it goes to the static case which is trivial]

> (The cgroup has to have some awareness of suspend/resume so that it can 
> allow the untrusted apps to be scheduled again)

I don't think so. The apps will get scheduled anyway when not suspended.
The only reason they are not being scheduled is that the device is
suspended.

> Not just the button driver. Every driver that generates wakeupa. This 
> gets difficult when it comes to the network layer, for instance, when 
> the network driver has very little idea how the packet it just received 
> will be routed.

No. Every driver which generates wakeups which should wake an untrusted
application. If network packets to untrusted applications should wake the
box up then a simple background ping process left running is going to
drain your battery and bugger your containment of the mess completely as
you've just accepted an infinite supply of untrusted timed wakeup events
with delay.

> > Apart from that optional paranoia case my kernel now contains some
> > trivial changes of generic value that have nothing to do with suspend
> > blocking. Android has suspend blocking by choosing to use the generic
> > features in its own specific way and we need almost no code writing ?
> 
> The problem is that you still have a race, and fixing that race requires 
> every event that could generate a wakeup to be proxied out to the policy 
> manager as well. That's a moderate additional overhead.

I am not convinced at this point. If the app gets put into the important
group by the driver then you don't need to poke a policy manager.

This again moves us beyond containment because we just allowed an
'untrusted' app a way to be trusted - just as it might abuse a suspend
blocker.

If you accept untrusted apps can't be fixed (for example they could
simply lose the event internally due to app code bugs) then the static
case all looks pretty trivial.

With a Meego hat on you'd dump all the stuff you didn't trust into a
scheduler group and tell the suspend aspect of the idle choice to ignore
it when the screen blanks. While you are it you also get a free ticket to
putting trusted rt apps into the 'and don't even C6' group.

Alan
