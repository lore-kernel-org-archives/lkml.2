Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758941Ab2ECWi5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 18:38:57 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:40740 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756344Ab2ECWiz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 18:38:55 -0400
MIME-Version: 1.0
In-Reply-To: <1335529449-28046-1-git-send-email-santosh.shilimkar@ti.com>
References: <1335529449-28046-1-git-send-email-santosh.shilimkar@ti.com>
From: Paul Gortmaker <paul.gortmaker@windriver.com>
Date: Thu, 3 May 2012 18:38:23 -0400
X-Google-Sender-Auth: m6WTeB7uDFDhlIDcENf2UwvqVtA
Message-ID: <CAP=VYLrCTOb9Qtz_HU5976cew_FR=qN6=x=_nD48ZprTcCjoUg@mail.gmail.com>
Subject: Re: [PATCH v5 0/7] Add TI EMIF SDRAM controller driver
To: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: linux-kernel@vger.kernel.org, greg@kroah.com, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 27, 2012 at 8:24 AM, Santosh Shilimkar
<santosh.shilimkar@ti.com> wrote:
> Add a driver for the EMIF SDRAM controller used in Texas Instrument SoCs

Hi Santosh,

Can you send Greg a patch that adds proper dependencies to the Kconfig?
I was going to simply add an ARM dependency, but perhaps you want to
restrict it further to a subset of OMAP platforms?

At the moment it is causing build failures in other architectures.

http://kisskb.ellerman.id.au/kisskb/buildresult/6243036/

Thanks,
Paul.
--
>
> EMIF is an SDRAM controller that supports, based on its revision,
> one or more of LPDDR2/DDR2/DDR3 protocols.This driver adds support
> for LPDDR2.
>
> The driver supports the following features:
> - Calculates the DDR AC timing parameters to be set in EMIF
>  registers using data from the device data-sheets and based
>  on the DDR frequency. If data from data-sheets is not available
>  default timing values from the JEDEC spec are used. These
>  will be safe, but not necessarily optimal
> - API for changing timings during DVFS or at boot-up
> - Temperature alert configuration and handling of temperature
>  alerts, if any for LPDDR2 devices
>  * temperature alert is based on periodic polling of MR4 mode
>    register in DDR devices automatically performed by hardware
>  * timings are de-rated and brought back to nominal when
>    temperature raises and falls respectively
> - Cache of calculated register values to avoid re-calculating
>  them
>
> The driver will need some minor updates when it is eventually
> integrated with Dynamic Voltage and Frequency Scaling (DVFS).
> This can not be done now as DVFS support is not available in
> the mainline yet.
>
> Discussions with Santosh Shilimkar <santosh.shilimkar@ti.com>
> were immensely helpful in shaping up the interfaces. Vibhore Vardhan
> <vvardhan@gmail.com> did the initial code snippet for thermal
> handling.
>
> Testing:
> - The driver is tested on OMAP4430 SDP.
> - The driver in a slightly adapted form is also tested on OMAP5.
> - Since mainline kernel doesn't have DVFS support yet,
>  testing was done using a test module.
> - Temperature alert handling was tested with simulated interrupts
>  and faked temperature values as testing all cases in real-life
>  scenarios is difficult.
> - Tested the driver as a module
>
> Cc: Greg KH <greg@kroah.com>
>
> v5:
> - Moved the EMIF driver to drivers/memory as per discussion thread [2]
>
> v4:
> - Converted instances of EXPORT_SYMBOL to EXPORT_SYMBOL_GPL
> - Removed un-necessary "#ifndef __ASSEMBLY__'
> - Minor formatting fix
>
> v2:
> - Fixed a bug found in the implementation of errata i728
>  workaround
> - Fixed the value of frequency printed in debugfs
> - Dropped the hwmod patch as Paul has already posted a
>  a hwmod series [1] that adds hwmod for EMIF
> - Converted instances of __init to __init_or_module
>
> Regards
> Santosh
>
> [1] http://thread.gmane.org/gmane.linux.ports.arm.omap/72855
> [2] https://lkml.org/lkml/2012/4/12/173
>
>
> Aneesh V (7):
>  ddr: add LPDDR2 data from JESD209-2
>  memory: emif: add register definitions for EMIF
>  memory: emif: add basic infrastructure for EMIF driver
>  memory: emif: handle frequency and voltage change events
>  memory: emif: add interrupt and temperature handling
>  memory: emif: add one-time settings
>  memory: emif: add debugfs entries for emif
>
>  Documentation/memory-devices/ti-emif.txt |   57 +
>  drivers/Kconfig                          |    4 +
>  drivers/Makefile                         |    3 +
>  drivers/memory/Kconfig                   |   22 +
>  drivers/memory/Makefile                  |    5 +
>  drivers/memory/emif.c                    | 1670 ++++++++++++++++++++++++++++++
>  drivers/memory/emif.h                    |  589 +++++++++++
>  include/linux/platform_data/emif_plat.h  |  128 +++
>  include/memory/jedec_ddr.h               |  175 ++++
>  lib/Kconfig                              |    8 +
>  lib/Makefile                             |    2 +
>  lib/jedec_ddr_data.c                     |  135 +++
>  12 files changed, 2798 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/memory-devices/ti-emif.txt
>  create mode 100644 drivers/memory/Kconfig
>  create mode 100644 drivers/memory/Makefile
>  create mode 100644 drivers/memory/emif.c
>  create mode 100644 drivers/memory/emif.h
>  create mode 100644 include/linux/platform_data/emif_plat.h
>  create mode 100644 include/memory/jedec_ddr.h
>  create mode 100644 lib/jedec_ddr_data.c
>
> --
> 1.7.5.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
