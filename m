Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752055Ab2BQR4N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 12:56:13 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:55101 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751635Ab2BQR4K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 12:56:10 -0500
X-Sasl-enc: P5E8Tsw1g2WY7zgzhZ8He7894YnbsiuSs6TtEs21v3uX 1329501368
Date: Fri, 17 Feb 2012 09:50:46 -0800
From: Greg KH <greg@kroah.com>
To: Aneesh V <aneesh@ti.com>
Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>, akpm@linux-foundation.org,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/8] Add TI EMIF SDRAM controller driver
Message-ID: <20120217175046.GA29902@kroah.com>
References: <1328357771-31644-1-git-send-email-aneesh@ti.com>
 <4F3CDF9F.9080204@ti.com>
 <20120216162359.GB20827@kroah.com>
 <4F3E5C8D.7020506@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F3E5C8D.7020506@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 17, 2012 at 07:26:29PM +0530, Aneesh V wrote:
> Greg,
> 
> On Thursday 16 February 2012 09:53 PM, Greg KH wrote:
> >On Thu, Feb 16, 2012 at 04:21:11PM +0530, Santosh Shilimkar wrote:
> >>Andrew, Greg,
> >>
> >>On Saturday 04 February 2012 05:46 PM, Aneesh V wrote:
> >>>Add a driver for the EMIF SDRAM controller used in TI SoCs
> >>>
> >>>EMIF is an SDRAM controller that supports, based on its revision,
> >>>one or more of LPDDR2/DDR2/DDR3 protocols.This driver adds support
> >>>for LPDDR2.
> >>>
> >>>The driver supports the following features:
> >>>- Calculates the DDR AC timing parameters to be set in EMIF
> >>>   registers using data from the device data-sheets and based
> >>>   on the DDR frequency. If data from data-sheets is not available
> >>>   default timing values from the JEDEC spec are used. These
> >>>   will be safe, but not necessarily optimal
> >>>- API for changing timings during DVFS or at boot-up
> >>>- Temperature alert configuration and handling of temperature
> >>>   alerts, if any for LPDDR2 devices
> >>>   * temperature alert is based on periodic polling of MR4 mode
> >>>     register in DDR devices automatically performed by hardware
> >>>   * timings are de-rated and brought back to nominal when
> >>>     temperature raises and falls respectively
> >>>- Cache of calculated register values to avoid re-calculating
> >>>   them
> >>>
> >>>The driver will need some minor updates when it is eventually
> >>>integrated with DVFS. This can not be done now as DVFS support
> >>>is not available yet in mainline.
> >>>
> >>>Discussions with Santosh Shilimkar<santosh.shilimkar@ti.com>
> >>>were immensely helpful in shaping up the interfaces. Vibhore Vardhan
> >>><vvardhan@gmail.com>  did the initial code snippet for thermal
> >>>handling.
> >>>
> >>>Testing:
> >>>- The driver is tested on OMAP4430 SDP.
> >>>- The driver in a slightly adapted form is also tested on OMAP5.
> >>>- Since mainline kernel doesn't have DVFS support yet,
> >>>   testing was done using a test module.
> >>>- Temperature alert handling was tested with simulated interrupts
> >>>   and faked temperature values as testing all cases in real-life
> >>>   scenarios is difficult.
> >>>
> >>[...]
> >>
> >>>  arch/arm/mach-omap2/omap_hwmod_44xx_data.c |  110 ++
> >>>  drivers/misc/Kconfig                       |   20 +
> >>>  drivers/misc/Makefile                      |    2 +
> >>>  drivers/misc/emif.c                        | 1522 ++++++++++++++++++++++++++++
> >>>  drivers/misc/emif_regs.h                   |  461 +++++++++
> >>>  drivers/misc/jedec_ddr_data.c              |  141 +++
> >>>  include/linux/emif.h                       |  257 +++++
> >>>  include/linux/jedec_ddr.h                  |  174 ++++
> >>
> >>Any suggestion on where this driver can reside. It's a memory
> >>controller driver which supports standard DDR functionality
> >>as per JDEC specs including thermal alert. On top of
> >>that it does support DVFS using the TI PRCM IP block.
> >
> >I don't know what any of those TLA words mean, so I really can't suggest
> 
> This is a driver for TI's memory controller(called EMIF). The
> driver is needed for adjusting the controller settings on frequency,
> voltage, and temperature changes. Any suggestion as to where this
> should go?

For those type of things, don't the iio framework provide what you need
and what?  Or perhaps the cpufreq layer?

> >where this code should go.  But just from this diffstat, it looks like
> >you are creating a new user/kernel interface, without documenting it
> >anywhere, which isn't ok.
> 
> I think you are referring to the header files added in include/linux/
> They are not creating new user/kernel interface per se.

Then why are they in include/linux/ ?

> "include/linux/jedec_ddr.h" is the interface to a library that contains
> data from the DDR specs. "include/linux/emif.h" has definitions for
> platform data needed by the driver. Maybe these should go to some other
> sub-directory within include/ or include/linux/ ?

Who needs these files?  If it's only the drivers themselves, then put it
in the same directory as the driver.  If it's platform data, then put
it, and only it, in the include/linux/platform_data/ directory.

> I shall add documentation for the driver in the next revision.

That would be good.  Please also cc: me on the next revision if you wish
me to take the patches (hint, get_maintainer.pl should have told you
this...)

thanks,

greg k-h
