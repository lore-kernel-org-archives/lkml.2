Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751509Ab1HQHLn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 03:11:43 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:60959 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750813Ab1HQHLl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 03:11:41 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Kenneth Heitke <kheitke@codeaurora.org>
Cc: sdharia@codeaurora.org, David Brown <davidb@codeaurora.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        bryanh@codeaurora.org, linux-arm-msm@vger.kernel.org,
        rdunlap@xenotime.net, rmk+kernel@arm.linux.org.uk,
        john.stultz@linaro.org, akpm@linux-foundation.org, ohad@wizery.com,
        gregkh@suse.de, stefanr@s5r6.in-berlin.de, lethal@linux-sh.org,
        linville@tuxdriver.com, zajec5@gmail.com, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] slimbus: Linux driver framework for SLIMbus.
Date: Wed, 17 Aug 2011 09:09:44 +0200
Message-ID: <1772239.ndMLD9ec3r@wuerfel>
User-Agent: KMail/4.7.0  (Linux/3.0.0-rc1nosema+; KDE/4.7.0; x86_64; ; )
In-Reply-To: <4E4AFCC9.7020109@codeaurora.org>
References: <1313019091-15354-1-git-send-email-kheitke@codeaurora.org> <4380004.YTvKt3Mlxd@wuerfel> <4E4AFCC9.7020109@codeaurora.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:IhnVm/howRUp/pDoIfHIj7pzZbM8znGwNqO8qqQpzbW
 PRxUr4nq0ycINMRMPLDGJNXa1Xh0+hU41fq+VOcbdkPXNvBWUx
 vdWG4vjgtrN69/YL0GTvt20QkqB3tMZv0m1Y0KyCSi3FqTVjeq
 mu5+qAYR/LA5PHTeGDaQzIwdmQyDY0CQ1YnxOVHrb65taHQQ5Z
 uUSZkiUF8hq+cu94sBe0g==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 16 August 2011 17:27:05 Kenneth Heitke wrote:
> On 08/16/2011 01:49 PM, Arnd Bergmann wrote:
> > Or does the 48-bit number actually tell us something about what
> > device we're talking to, e.g. 24 bit vendor plus 24 bit device
> > type and revision or such. If that's the case, the number needs
> > to be the primary key that gets used to identify the driver,
> > just like we do it in case of USB or PCI devices.
> 
> The 8-bit address is a logical address that is assigned by the SLIMbus 
> framework.  The framework maintains the mapping of logical addresses to 
> the 48-bit Enumeration Address (EA).  The 8-bit logical address is then 
> used for any further SLIMbus device addressing.
> 
> The slim_get_logical_addr() API call is used by the client drivers to 
> get the logical address that has been assigned to the device.
> 
> For the proposed implementation, the client drivers are probed before 
> their devices are discovered because the client driver may need to 
> power-up the device or pull it out of reset.  Once the device is powered 
> up, the call to get_logical_address() will let the client know whether 
> or not their device has enumerated.

Hmm, I looked at http://www.national.com/assets/en/other/intro_to_SLIMbus.pdf
which contains:

| SLIMbusTM uses a 48-bit Enumeration Addresses (EA) to
| uniquely identify Devices which can announce
| their presence on the bus. Each Device has an EA,
| which incorporates Manufacturer ID, Product Code,
| Device Index, and Instance Value for a Device. The
| Manufacturer ID code is supplied by the MIPI
| Alliance and uniquely identifies the manufacturer
| of the Device, similar to the manufacturer IDs used with
| PCI bus components. The Device Index code uniquely
| identifies multiple Devices within a single
| Component. The Instance Value code is for the case
| where multiple Devices of the same type or Class
| are attached to the bus.

Based on this, I would strongly suggest a different model to the
one that you are suggesting:

* Make each device driver assume that the device is powered on when
  talking to it.
* Make the EA (minus the index/instance ID) the primary identifier for a
  device driver, not an arbitrary string.
* Move the logic for enabling and disabling devices into a host specific
  driver that takes care of powering the devices up initially, identifying
  them and putting them into run-time PM disabled state when no driver was
  found or the device is unused.

This will make it possible to reuse the same driver for multiple machines
that have the same endpoint devices, while moving all the board specific
clock and reset logic into a separate driver, which can be very small in
many cases.

I would guess that in many cases, the logic for enabling the devices
fits into the slimbus host driver. If that is not the case, e.g. when
a lot of machines have the same host controller but each of them uses
a different way to get the devices out of reset, you can turn the host
driver into a library that contains the actual code accessing the host
controller registers, but provide a per-machine platform_driver that
known how to enable the individual devices and uses the library code
from the main host driver to talk to the devices.

	Arnd
