Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753176Ab0DOLfJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 07:35:09 -0400
Received: from ppsw-43.csi.cam.ac.uk ([131.111.8.143]:39947 "EHLO
	ppsw-43.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753058Ab0DOLfH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 07:35:07 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4BC6FA95.1070106@cam.ac.uk>
Date: Thu, 15 Apr 2010 12:37:57 +0100
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20100109 Thunderbird/3.0
MIME-Version: 1.0
To: Samu Onkalo <samu.p.onkalo@nokia.com>
CC: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
       lm-sensors@lm-sensors.org
Subject: Re: [PATCH 0/1] BH1770GLC / SFH7770 combined ambient light / proximity
 sensor
References: <1271327648-13497-1-git-send-email-samu.p.onkalo@nokia.com>
In-Reply-To: <1271327648-13497-1-git-send-email-samu.p.onkalo@nokia.com>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Samu,

> This patch introduces driver for Rohm BH1770GLC and Osram SFH7770
> combined ambient light and proximity sensor.
> 
> Driver is divided to 3 parts. Core-part contains common functionality for
> both parts of the chips. ALS and PS specific functionalities are
> in separate files.
> 
> ALS part is fully based on threshold interrupts. Driver doesn't provide
> direct control for threshold levels. Instead, based on sensitivity setting,
> threshold levels are updated after every interrupt. This method keeps sensor
> to follow changes in the lightning.
> 
> PS part uses interrupt for high threshold events and delayed work to simulate
> missing low threshold interrupts. This way driver is able to react proximity
> on / off events using only high threshold interrupt. Proximity sensing can
> utilize up to 3 IR leds for movement detection. Driver supports 1-3 leds
> configurations.
> 
> Platform data is used to provide IR led configuration: number of channels and
> absolute maximum operating currents for the leds.
> 
> Chip is kept running only when someone keeps device handles open.
> Otherwise chip is powered down and optionally power supplies are turned off.
> 
> Interfaces:
> Both parts of the driver provides results via separate misc char device.
> 
> sysfs interface:
> als_calib - (RW) calibration coeffient (default is neutral value)
> als_mode  - (R)  returns current chip operational state for ALS
> als_rate  - (RW) ALS side measurement rate in ms
> als_sens  - (RW) sensitivity for changes in lightning level

This ALS stuff feeds in pretty directly to the discussion just started in response
to Alan Cox's post of the isl20920 driver.  Basically we need to try and match
as much of the sysfs interface across these chips as possible.  Obviously this
one is different to the ALS sensors already in kernel in that it doesn't allow
direct reading of the value.  For his driver I suggested

illuminance0_input (not matched here)
illuminance0_calib

(these also happen to match the new IIO spec by amazing coincidence :)

I'll put some related comments in a review of the patch.

  

> ps_calib  - (RW) calibration coeffient
> ps_leds   - (RW) IR led currents in mA
> ps_mode   - (R)  returns current chip operational state for PS
> ps_rate   - (RW) PS side measurement rates (separate rates for below /
> 	         above threshold condition)
> ps_threshold - (RW) threshold level

Likewise with the proximity sensing.  If nothing else, please allow for
a chip with multiple proximity sensors with separate parameters.
> chip_id   - (R)  chip version and revision information


> 
> Tested in top of 2.6.32 kernel. Applies to 2.6.34-RC3.
> 
> Samu Onkalo (1):
>   misc: bh1770glc: Driver for bh1770glc combined als and ps sensor
> 
>  drivers/misc/Kconfig          |   12 +
>  drivers/misc/Makefile         |    3 +
>  drivers/misc/bh1770glc.h      |  169 ++++++++++++
>  drivers/misc/bh1770glc_als.c  |  424 +++++++++++++++++++++++++++++
>  drivers/misc/bh1770glc_core.c |  301 +++++++++++++++++++++
>  drivers/misc/bh1770glc_ps.c   |  585 +++++++++++++++++++++++++++++++++++++++++
>  include/linux/bh1770glc.h     |   39 +++
>  7 files changed, 1533 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/misc/bh1770glc.h
>  create mode 100644 drivers/misc/bh1770glc_als.c
>  create mode 100644 drivers/misc/bh1770glc_core.c
>  create mode 100644 drivers/misc/bh1770glc_ps.c
>  create mode 100644 include/linux/bh1770glc.h
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-i2c" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

