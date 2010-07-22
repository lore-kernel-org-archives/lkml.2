Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756180Ab0GVQIu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 12:08:50 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:56595 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752532Ab0GVQIt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 12:08:49 -0400
Date: Thu, 22 Jul 2010 09:07:51 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: linux-kernel@vger.kernel.org, Kristian Hoegsberg <krh@bitplanet.net>,
        linux1394-devel@lists.sourceforge.net
Subject: Re: [review patch 1/2] firewire: new driver: nosy - IEEE 1394
 traffic sniffer
Message-Id: <20100722090751.682f3b00.randy.dunlap@oracle.com>
In-Reply-To: <tkrat.ddc816ab75cce8ac@s5r6.in-berlin.de>
References: <tkrat.72756f504d6c0055@s5r6.in-berlin.de>
	<tkrat.ddc816ab75cce8ac@s5r6.in-berlin.de>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4C486CFB.007E:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Jul 2010 11:56:38 +0200 (CEST) Stefan Richter wrote:

> This adds the traffic sniffer driver for Texas Instruments PCILynx/
> PCILynx2 based cards.  The use cases for nosy are analysis of
> nonstandard protocols and as an aid in development of drivers,
> applications, or firmwares.
> 
> This comparably small kernel driver sets up packet reception DMA in the
> special snoop mode of the PCILynx chip.  Userspace can pick up the
> snooped FireWire traffic via a misc char device file "/dev/nosy".  The
> file supports poll(), read(), and four ioctl()s; see nosy-user.h.
> 
> The ioctls use type code '&' which is currently unallocated according to
> Documentation/ioctl/ioctl-number.txt.  Is this OK or should it be moved
> to a different type code?
> 
> A side note regarding maintainability:  The PCILynx chip is well
> documented in Texas Instruments' literature SCPA020A and SLLA023.
> 
> Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
> ---
>  drivers/firewire/Kconfig     |   23 ++
>  drivers/firewire/Makefile    |    1 +
>  drivers/firewire/nosy-user.h |   25 ++
>  drivers/firewire/nosy.c      |  720 ++++++++++++++++++++++++++++++++++++++++++
>  drivers/firewire/nosy.h      |  237 ++++++++++++++
>  5 files changed, 1006 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/firewire/nosy-user.h
>  create mode 100644 drivers/firewire/nosy.c
>  create mode 100644 drivers/firewire/nosy.h
> 
> diff --git a/drivers/firewire/Kconfig b/drivers/firewire/Kconfig
> index a9371b3..c4edc34 100644
> --- a/drivers/firewire/Kconfig
> +++ b/drivers/firewire/Kconfig
> @@ -66,4 +66,27 @@ config FIREWIRE_NET
>  
>  source "drivers/ieee1394/Kconfig"
>  
> +config FIREWIRE_NOSY
> +	tristate "Nosy - a FireWire traffic sniffer for PCILynx cards"
> +	depends on PCI

Just curious:  why not depends on IEEE1394_PCILYNX ?

> +	help
> +	  Nosy is an IEEE 1394 packet sniffer that is used for protocol
> +	  analysis and in development of IEEE 1394 drivers, applications,
> +	  or firmwares.
> +
> +	  This driver lets you use a Texas Instruments PCILynx 1394 to PCI
> +	  link layer controller TSB12LV21/A/B as a low-budget bus analyzer.
> +	  PCILynx is a nowadays very rare IEEE 1394 controller which is
> +	  not OHCI 1394 compliant.
> +
> +	  The following cards are known to be based on PCILynx or PCILynx-2:
> +	  IOI IOI-1394TT (PCI card), Unibrain Fireboard 400 PCI Lynx-2
> +	  (PCI card), Newer Technology FireWire 2 Go (CardBus card),
> +	  Apple Power Mac G3 blue & white (onboard controller).
> +
> +	  To compile this driver as a module, say M here:  The module will be
> +	  called nosy.
> +
> +	  If unsure, say N.
> +
>  endmenu
> diff --git a/drivers/firewire/Makefile b/drivers/firewire/Makefile
> index a8f9bb6..3c6a7fb 100644
> --- a/drivers/firewire/Makefile
> +++ b/drivers/firewire/Makefile
> @@ -12,3 +12,4 @@ obj-$(CONFIG_FIREWIRE)      += firewire-core.o
>  obj-$(CONFIG_FIREWIRE_OHCI) += firewire-ohci.o
>  obj-$(CONFIG_FIREWIRE_SBP2) += firewire-sbp2.o
>  obj-$(CONFIG_FIREWIRE_NET)  += firewire-net.o
> +obj-$(CONFIG_FIREWIRE_NOSY) += nosy.o
> diff --git a/drivers/firewire/nosy-user.h b/drivers/firewire/nosy-user.h
> new file mode 100644
> index 0000000..e48aa62
> --- /dev/null
> +++ b/drivers/firewire/nosy-user.h
> @@ -0,0 +1,25 @@
> +#ifndef __nosy_user_h
> +#define __nosy_user_h
> +
> +#include <linux/ioctl.h>
> +#include <linux/types.h>
> +
> +#define NOSY_IOC_GET_STATS _IOR('&', 0, struct nosy_stats)
> +#define NOSY_IOC_START     _IO('&', 1)
> +#define NOSY_IOC_STOP      _IO('&', 2)
> +#define NOSY_IOC_FILTER    _IOW('&', 2, __u32)

Please add '&' to Documentation/ioctl/ioctl-number.txt.

> +struct nosy_stats {
> +	__u32 total_packet_count;
> +	__u32 lost_packet_count;
> +};
> +
> +/*
> + * Format of packets returned from the kernel driver:
> + *
> + *	quadlet with timestamp		(microseconds, CPU endian)
> + *	quadlet-padded packet data...	(little endian)
> + *	quadlet with ack		(little endian)
> + */
> +
> +#endif /* __nosy_user_h */


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
