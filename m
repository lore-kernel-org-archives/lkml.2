Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757390Ab2CSBIi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2012 21:08:38 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:37864 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755241Ab2CSBIh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2012 21:08:37 -0400
X-AuditID: cbfee60c-b7c83ae000001e65-90-4f66871372b4
Date: Mon, 19 Mar 2012 01:08:35 +0000 (GMT)
From: =?euc-kr?B?x9S47cHW?= <myungjoo.ham@samsung.com>
Subject: Re: Re: [PATCH v4 0/7] Add TI EMIF SDRAM controller driver
To: Kyungmin Park <kmpark@infradead.org>, Aneesh V <aneesh@ti.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg KH <greg@kroah.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Reply-to: myungjoo.ham@samsung.com
MIME-version: 1.0
X-MTR: 20120319005728403@myungjoo.ham
Msgkey: 20120319005728403@myungjoo.ham
X-EPLocale: ko_KR.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20120319005728403@myungjoo.ham
X-ParentMTR: 
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <16771402.10791332119314036.JavaMail.weblogic@epv6ml07>
X-Brightmail-Tracker: AAAAAA==
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q2J18iaa023491


Kyungmin Park<kmpark@infradead.org> 2012-03-17 15:10 (GMT+09:00)
> Hi,
> On 3/17/12, Aneesh V wrote:
> > Add a driver for the EMIF SDRAM controller used in TI SoCs
> >
> > EMIF is an SDRAM controller that supports, based on its revision,
> > one or more of LPDDR2/DDR2/DDR3 protocols.This driver adds support
> > for LPDDR2.
> >
> > The driver supports the following features:
> > - Calculates the DDR AC timing parameters to be set in EMIF
> >   registers using data from the device data-sheets and based
> >   on the DDR frequency. If data from data-sheets is not available
> >   default timing values from the JEDEC spec are used. These
> >   will be safe, but not necessarily optimal
> > - API for changing timings during DVFS or at boot-up

This means that you alreeady have callbacks to create a devfreq device driver that supports DVFS on the device. This doesn't need to be a misc device driver then.

> > - Temperature alert configuration and handling of temperature
> >   alerts, if any for LPDDR2 devices
> >   * temperature alert is based on periodic polling of MR4 mode
> >     register in DDR devices automatically performed by hardware
> >   * timings are de-rated and brought back to nominal when
> >     temperature raises and falls respectively

This can be a feature overriding "max_freq" inside the Omap EMIF devfreq device driver though it maybe (or not.. I just don't sure) be better to use thermal framework as well.


Cheers!
MyungJoo

> > - Cache of calculated register values to avoid re-calculating
> >   them
> >
> > The driver will need some minor updates when it is eventually
> > integrated with Dynamic Voltage and Frequency Scaling (DVFS).
> > This can not be done now as DVFS support is not available in
> > the mainline yet.
> Do you see the devfreq? it's designed for non-cpu device frequency.
> It's role is similar with cpufreq.
> 
> Now samsung exynos uses devfreq for DRAM bus frequency.
> 
> Thank you,
> Kyungmin Park
> >
> > Discussions with Santosh Shilimkar 
> > were immensely helpful in shaping up the interfaces. Vibhore Vardhan
> > did the initial code snippet for thermal
> > handling.
> >
> > Testing:
> > - The driver is tested on OMAP4430 SDP.
> > - The driver in a slightly adapted form is also tested on OMAP5.
> > - Since mainline kernel doesn't have DVFS support yet,
> >   testing was done using a test module.
> > - Temperature alert handling was tested with simulated interrupts
> >   and faked temperature values as testing all cases in real-life
> >   scenarios is difficult.
> > - Tested the driver as a module
> >
> > Cc: Greg KH 
> >
> > v4:
> > - Converted instances of EXPORT_SYMBOL to EXPORT_SYMBOL_GPL
> > - Removed un-necessary "#ifndef __ASSEMBLY__'
> > - Minor formatting fix
> >
> > v2:
> > - Fixed a bug found in the implementation of errata i728
> >   workaround
> > - Fixed the value of frequency printed in debugfs
> > - Dropped the hwmod patch as Paul has already posted a
> >   a hwmod series [1] that adds hwmod for EMIF
> > - Converted instances of __init to __init_or_module
> >
> > [1] http://thread.gmane.org/gmane.linux.ports.arm.omap/72855
> >
> > Aneesh V (7):
> >   misc: ddr: add LPDDR2 data from JESD209-2
> >   misc: emif: add register definitions for EMIF
> >   misc: emif: add basic infrastructure for EMIF driver
> >   misc: emif: handle frequency and voltage change events
> >   misc: emif: add interrupt and temperature handling
> >   misc: emif: add one-time settings
> >   misc: emif: add debugfs entries for emif
> >
> >  Documentation/misc-devices/ti-emif.txt  |   58 ++
> >  drivers/misc/Kconfig                    |   12 +
> >  drivers/misc/Makefile                   |    1 +
> >  drivers/misc/emif.c                     | 1670
> > +++++++++++++++++++++++++++++++
> >  drivers/misc/emif.h                     |  589 +++++++++++
> >  include/linux/platform_data/emif_plat.h |  128 +++
> >  include/misc/jedec_ddr.h                |  175 ++++
> >  lib/Kconfig                             |    8 +
> >  lib/Makefile                            |    2 +
> >  lib/jedec_ddr_data.c                    |  135 +++
> >  10 files changed, 2778 insertions(+), 0 deletions(-)
> >  create mode 100644 Documentation/misc-devices/ti-emif.txt
> >  create mode 100644 drivers/misc/emif.c
> >  create mode 100644 drivers/misc/emif.h
> >  create mode 100644 include/linux/platform_data/emif_plat.h
> >  create mode 100644 include/misc/jedec_ddr.h
> >  create mode 100644 lib/jedec_ddr_data.c
> >
> >
> > _______________________________________________
> > linux-arm-kernel mailing list
> > linux-arm-kernel@lists.infradead.org
> > http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
> >
> 

--
MyungJoo Ham (ÇÔ¸íÁÖ), PHD
System S/W Lab, S/W Platform Team, Software Center
Samsung Electronics
Cell: +82-10-6714-2858



 

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
