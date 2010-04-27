Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756813Ab0D0UrE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 16:47:04 -0400
Received: from mail1-out1.atlantis.sk ([80.94.52.55]:44929 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756065Ab0D0UrA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 16:47:00 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH v2] [RFC] ehci: Disable wake on overcurrent (WKOC_E) and disconnect (WKDISC_E)
Date: Tue, 27 Apr 2010 22:46:48 +0200
User-Agent: KMail/1.9.10
Cc: linux-pm@lists.linux-foundation.org, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <Pine.LNX.4.44L0.1004271509450.1850-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1004271509450.1850-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201004272246.51494.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 27 April 2010 21:21:23 Alan Stern wrote:
> On Tue, 27 Apr 2010, Ondrej Zary wrote:
> > The previous patch was not enough as it worked only when there were no
> > USB devices connected. With a bus-powered device connected, power loss
> > causes disconnect which wakes up the machine immediately again.
>
> You said earlier that the host controller was disabled for remote
> wakeup ("/sys/devices/pci0000:00/0000:00:1d.7/power/wakeup is disabled
> by default").  So even though the root hub might issue a wakeup
> request, the controller hardware should not forward that request to the
> PCI bus and it should not cause the system to wake up.

Maybe it should not - but it wakes up this board and probably also P4P800, 
P4P800-E and P4C800-E at least:
https://bugs.launchpad.net/ubuntu/+source/linux/+bug/75497

> > Does anyone know why is this enabled by default?
>
> Why _what_ is enabled?  Detection of disconnects?  Because otherwise
> your computer wouldn't realize anything had happened when a suspended
> USB device was unplugged from a suspended root hub.

That's not disconnect detection - that's wakeup on disconnect. If I understand 
EHCI 1.0 specification correctly, disconnect detection should work regardless 
of the state of this bit:
| PORTSC bit 21: Wake on Disconnect Enable (WKDSCNNT_E):
| R/W. Default = 0b.
| Writing this bit to a one enables the port to be sensitive to device
| disconnects as wake-up events. See Section 4.3 for effects of this bit on
| resume event behavior. Refer to Section 4.3.1 for operational model.  

And it really does. With this patch applied, system does not wake up when a 
device is disconnected during suspend. When I wake up the system manually, 
the disconnect is detected immediately (does not matter

> > No other USB host driver
> > (except oxu210hp-hcd which is based on EHCI) does that.
>
> Look again -- they all do.  (All the HCDs that support suspend/resume,
> anyway.)
>
> > This also means that
> > suspended laptop wakes up when disconnecting a mouse?
>
> No, for the reason I described above.  The controller is aware of the
> wakeup request but doesn't generate a PME# event.  Likewise for desktop
> systems.
>
> > I don't have any to test
> > right now. Wakeup on USB connect makes a bit more sense but I'd say that
> > it's still not a good idea to enable it by default.
> >
> > If we don't need that, perhaps the following patch should be applied.
> >
> >
> > Disable wake on overcurrent and disconnect in EHCI.
> > This fixes immediate resume from standby on boards where port power is
> > lost in standby which triggers overcurrent detection and disconnect if a
> > bus-powered device is connected. At least Asus P4P800 boards are affected
> > when any of the USBPWxx (e.g. USBPW12) jumpers is set to 5V.
>
> Why would you want to change the jumper settings?  Host controllers are
> _supposed_ to supply 5V power during system suspend.

Maybe because I don't want all my USB devices to be powered when the system is 
turned off. I doubt that laptop in suspend-to-RAM (on battery) provides power 
to USB ports.

-- 
Ondrej Zary
