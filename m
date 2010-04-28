Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755392Ab0D1Pld (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 11:41:33 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:37417 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754907Ab0D1Plc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 11:41:32 -0400
Date: Wed, 28 Apr 2010 11:41:30 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Ondrej Zary <linux@rainbow-software.org>
cc: linux-pm@lists.linux-foundation.org, <linux-usb@vger.kernel.org>,
       <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] [RFC] ehci: Disable wake on overcurrent (WKOC_E) and
 disconnect (WKDISC_E)
In-Reply-To: <201004272246.51494.linux@rainbow-software.org>
Message-ID: <Pine.LNX.4.44L0.1004281129140.1944-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Apr 2010, Ondrej Zary wrote:

> On Tuesday 27 April 2010 21:21:23 Alan Stern wrote:
> > On Tue, 27 Apr 2010, Ondrej Zary wrote:
> > > The previous patch was not enough as it worked only when there were no
> > > USB devices connected. With a bus-powered device connected, power loss
> > > causes disconnect which wakes up the machine immediately again.
> >
> > You said earlier that the host controller was disabled for remote
> > wakeup ("/sys/devices/pci0000:00/0000:00:1d.7/power/wakeup is disabled
> > by default").  So even though the root hub might issue a wakeup
> > request, the controller hardware should not forward that request to the
> > PCI bus and it should not cause the system to wake up.
> 
> Maybe it should not - but it wakes up this board and probably also P4P800, 
> P4P800-E and P4C800-E at least:
> https://bugs.launchpad.net/ubuntu/+source/linux/+bug/75497

Okay, evidently the hardware or firmware on these boards is buggy.  
Other systems do not have the same problem, as far as I know.

> > > Does anyone know why is this enabled by default?
> >
> > Why _what_ is enabled?  Detection of disconnects?  Because otherwise
> > your computer wouldn't realize anything had happened when a suspended
> > USB device was unplugged from a suspended root hub.
> 
> That's not disconnect detection - that's wakeup on disconnect.

True; I oversimplified.  Furthermore, starting in 2.6.34, the wakeup 
settings during system sleep (suspend or hibernation) can be different 
from the settings during autosuspend, so you can have root hubs enabled 
for wakeup during autosuspend but not during system sleep.

>  If I understand 
> EHCI 1.0 specification correctly, disconnect detection should work regardless 
> of the state of this bit:
> | PORTSC bit 21: Wake on Disconnect Enable (WKDSCNNT_E):
> | R/W. Default = 0b.
> | Writing this bit to a one enables the port to be sensitive to device
> | disconnects as wake-up events. See Section 4.3 for effects of this bit on
> | resume event behavior. Refer to Section 4.3.1 for operational model.  
> 
> And it really does. With this patch applied, system does not wake up when a 
> device is disconnected during suspend. When I wake up the system manually, 
> the disconnect is detected immediately (does not matter

It's worth pointing out that EHCI is different in this respect from
OHCI and UHCI; the older controllers do not have the capability to
enable or disable wakeup independently for connect, disconnect, and
overcurrent events.  They are all or nothing.  So are external USB
hubs.


> > > If we don't need that, perhaps the following patch should be applied.
> > >
> > >
> > > Disable wake on overcurrent and disconnect in EHCI.
> > > This fixes immediate resume from standby on boards where port power is
> > > lost in standby which triggers overcurrent detection and disconnect if a
> > > bus-powered device is connected. At least Asus P4P800 boards are affected
> > > when any of the USBPWxx (e.g. USBPW12) jumpers is set to 5V.
> >
> > Why would you want to change the jumper settings?  Host controllers are
> > _supposed_ to supply 5V power during system suspend.
> 
> Maybe because I don't want all my USB devices to be powered when the system is 
> turned off. I doubt that laptop in suspend-to-RAM (on battery) provides power 
> to USB ports.

This depends on how your system was turned off.  During suspend or
hibernation, you _should_ want USB devices to be powered (and some
people do, as Greg pointed out).  During a normal system shutdown, the
USB buses should not be powered.

Regardless, I don't think a kernel patch is the way to solve your
problem.  Changing the wakeup setting for the root hub will do what you
want, and that setting is explicitly intended to be controlled by
userspace (after all, that's why it is exposed in sysfs).  The initial
value is only a reasonable default; you can certainly add scripts or
udev rules to disable wakeup on your EHCI root hub.

Alan Stern

