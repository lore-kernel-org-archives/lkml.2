Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759490Ab0D3ULV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 16:11:21 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:53948 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1759316Ab0D3ULP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 16:11:15 -0400
Date: Thu, 29 Apr 2010 12:16:24 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Ondrej Zary <linux@rainbow-software.org>
cc: Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       USB list <linux-usb@vger.kernel.org>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] [RFC] ehci: Disable wake on overcurrent (WKOC_E) and
 disconnect (WKDISC_E)
In-Reply-To: <201004281930.12293.linux@rainbow-software.org>
Message-ID: <Pine.LNX.4.44L0.1004291041300.1697-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Apr 2010, Ondrej Zary wrote:

> On Wednesday 28 April 2010 17:41:30 Alan Stern wrote:
> > On Tue, 27 Apr 2010, Ondrej Zary wrote:
> > > On Tuesday 27 April 2010 21:21:23 Alan Stern wrote:
> > > > On Tue, 27 Apr 2010, Ondrej Zary wrote:
> > > > > The previous patch was not enough as it worked only when there were
> > > > > no USB devices connected. With a bus-powered device connected, power
> > > > > loss causes disconnect which wakes up the machine immediately again.
> > > >
> > > > You said earlier that the host controller was disabled for remote
> > > > wakeup ("/sys/devices/pci0000:00/0000:00:1d.7/power/wakeup is disabled
> > > > by default").  So even though the root hub might issue a wakeup
> > > > request, the controller hardware should not forward that request to the
> > > > PCI bus and it should not cause the system to wake up.
> > >
> > > Maybe it should not - but it wakes up this board and probably also
> > > P4P800, P4P800-E and P4C800-E at least:
> > > https://bugs.launchpad.net/ubuntu/+source/linux/+bug/75497
> >
> > Okay, evidently the hardware or firmware on these boards is buggy.
> > Other systems do not have the same problem, as far as I know.

I take this back.  The same thing happens on my machine (Intel ICH5
chipset).  I'd guess there is a bug in the PCI or ACPI subsystem, but
more testing is needed before I can be sure.  Somehow the PCI or
platform wakeup mechanism gets activated even when it is supposed to be
disabled.

> It works fine in Windows.

How can you tell?  How do you know what values Windows writes into the 
EHCI port control registers?

> > Regardless, I don't think a kernel patch is the way to solve your
> > problem.  Changing the wakeup setting for the root hub will do what you
> > want, and that setting is explicitly intended to be controlled by
> > userspace (after all, that's why it is exposed in sysfs).  The initial
> > value is only a reasonable default; you can certainly add scripts or
> > udev rules to disable wakeup on your EHCI root hub.
> 
> Yes, I can work around that. But many users can't. This is an attempt to make 
> it "just work".

It should "just work" already.  The fact that it doesn't means there is 
a bug.  At the moment I can't be sure where the bug is -- but even if 
it is in ehci-hcd, your suggested patch isn't the right fix.

> I'm trying to say that the "wakeup on everything" is not a good thing (if not 
> a bug). Who needs it?

I don't know, and neither do you.  But the USB spec requires this
behavior from external hubs, so evidently _somebody_ thought it was a
good idea.

> I can't imagine any real use for it. It clearly breaks 
> suspend on some systems and is annoying on other.

If everything was working properly, the machine wouldn't wake up when a
disconnect occurred.

>  Who expects that 
> disconnecting a device should wake up sleeping machine?

Perhaps the same people who expect that plugging in a device should
wake up a sleeping machine?

> When all these three wakeups (overcurrent, connect, disconnect) are disabled, 
> we lose nothing. Connect/disconnect detection works fine after wakeup. Wakeup 
> by USB devices (not by connect/disconnect but by the device itself signaling 
> a resume) is completely independent of this (according to EHCI 
> specification).

What about UHCI or OHCI?  What about external hubs?

In short, why should EHCI behave differently from everything else?

Alan Stern

