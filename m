Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933406Ab1ESPW0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 11:22:26 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:51495 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933139Ab1ESPWZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 11:22:25 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Chris Metcalf <cmetcalf@tilera.com>,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH] arch/tile: add /proc/tile, /proc/sys/tile, and a sysfs cpu attribute
Date: Thu, 19 May 2011 17:22:17 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
References: <201105181807.p4II7C5g015224@farm-0002.internal.tilera.com> <201105191541.11939.arnd@arndb.de> <4DD5334D.4060800@tilera.com>
In-Reply-To: <4DD5334D.4060800@tilera.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201105191722.17685.arnd@arndb.de>
X-Provags-ID: V02:K0:onkLTRmSWoLgjzdd7B0FH9VELCVpDgiNsQYRTXhHEsZ
 hjR/bunpVA3vAxaVIcL1VlH4zH9FtiThTW4eEO8sSeBXjvjY9y
 J+N6dgXElvv1MySow07jE8/x5KobtQU+V9rbMCjtd+fvQMd3tv
 U2cB8TeTIjSah9exDc9PcXhhAjxE3R5JHxJAMUMZQ8qx0oVHfO
 izzeZHVrgfId3Aiuj4P6w==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(adding virtualization mailing list)

On Thursday 19 May 2011, Chris Metcalf wrote:
> On 5/19/2011 9:41 AM, Arnd Bergmann wrote:
> >> /proc/tile/hvconfig
> >>   Detailed configuration description of the hypervisor config
> 
> I'm concerned about moving this one out of /proc, since it's just (copious)
> free text.  An "hvconfig" (hypervisor config) file describes hypervisor
> driver "dedicated tiles" that run things like network packet or PCIe
> ingress/egress processing, etc.  In addition it lists hypervisor driver
> options, boot flags for the kernel, etc, all kinds of things -- and you
> can't really guarantee that it will fit on a 4KB page, though in practice
> it usually does.  The hypervisor reads this file from the boot stream when
> it boots, and then makes it available to Linux not for Linux's use, or even
> for programmatic userspace use, but just for end users to be able to review
> and verify that the configuration they think they booted is really what
> they got, for customer remote debugging, etc.  The "remote debugging"
> aspect makes truncation to page size a particularly worrisome idea.

Since it's not the kernel that is imposing the format here, you could
make it a binary sysfs attribute, which works in the same way as
a proc file and does not have the size limitations.

> >> /proc/tile/board
> >>   Information on part numbers, serial numbers, etc., of the
> >>   hardware that the kernel is executing on
> >>
> >> /proc/tile/switch
> >>   The type of control path for the onboard network switch, if any.
> 
> These two report information about the hardware, not the hypervisor.  For
> example:
> 
> # cat /proc/tile/board
> board_part: 402-00002-05
> board_serial: NBS-5002-00012
> chip_serial: P62338.01.110
> chip_revision: A0
> board_revision: 2.2
> board_description: Tilera TILExpressPro-64, TILEPro64 processor (866 MHz-capable), 1 10GbE, 6 1GbE
> # cat /proc/tile/switch
> control: mdio gbe/0

I think it's ok to have it below /sys/hypervisor, because the information
is provided through a hypervisor ABI, even though it describes something
else. This is more like /sys/firmware, but the boundaries between that
and /sys/hypervisor are not clearly defined when running virtualized anyway.

> The chip_serial and chip_revision can certainly hang off
> /sys/devices/system/cpu along with chip_height and chip_width (I've made
> this change now) but I don't know where the remaining "board" level
> description could go.  Note that (as you can see in the source) certain
> boards will also include four lines of output with the "mezzanine board"
> part number, serial number, revision, and description; this particular
> example doesn't have a mezzanine board.  The "switch" info is broken out
> into a separate file just to make it easier to script some /etc/rc code
> that launches a configurator for the Marvell switch on some of our boards,
> but is conceptually part of the board info.
> 
> >> /proc/tile/hardwall
> >>   Information on the set of currently active hardwalls (note that
> >>   the implementation is already present in arch/tile/kernel/hardwall.c;
> >>   this change just enables it)
> 
> This one is not a hypervisor-related file.  It just lists information about
> the set of Linux hardwalls currently active.  Again, it's not primarily
> intended for programmatic use, but as a diagnostic tool.

same here, I'd still put it into the hypervisor structure.

	Arnd
