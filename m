Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752241Ab0LQCiM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 21:38:12 -0500
Received: from na3sys009aog113.obsmtp.com ([74.125.149.209]:41068 "HELO
	na3sys009aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750943Ab0LQCiL convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 21:38:11 -0500
From: Philip Rakity <prakity@marvell.com>
To: Chris Ball <cjb@laptop.org>
CC: Takashi Iwai <tiwai@suse.de>, Aries Lee <arieslee@jmicron.com>,
        zhangfei gao <zhangfei.gao@gmail.com>, Qiming Wu <wuqm@marvell.com>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 16 Dec 2010 18:33:49 -0800
Subject: Re: [PATCH] mmc: Test bus-width for old MMC devices (v2)
Thread-Topic: [PATCH] mmc: Test bus-width for old MMC devices (v2)
Thread-Index: Acudktd27tbJtgokR4i/w4tlDTRKsA==
Message-ID: <50D31EC8-BD9E-4920-8CEB-2AD10DF9C5C5@marvell.com>
References: <s5hfwtzbj8v.wl%tiwai@suse.de>
 <20101216234032.GA17239@void.printf.net>
In-Reply-To: <20101216234032.GA17239@void.printf.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Chris,

It is not possible for bus_width to be not initialized.  This would imply ARRAY_SIZE(bus_widths) is 1.  Certainly not true.
We could just initialize by changing
+		unsigned idx, bus_width;
to
+		unsigned idx, bus_width = 0;

I wonder what compiler are you using so we can avoid this issue in future.

Philip


+		static unsigned ext_csd_bits[][2] = {
+			{ EXT_CSD_BUS_WIDTH_8, EXT_CSD_DDR_BUS_WIDTH_8 },
+			{ EXT_CSD_BUS_WIDTH_4, EXT_CSD_DDR_BUS_WIDTH_4 },
+			{ EXT_CSD_BUS_WIDTH_1, EXT_CSD_BUS_WIDTH_1 },
+		};
+		static unsigned bus_widths[] = {
+			MMC_BUS_WIDTH_8,
+			MMC_BUS_WIDTH_4,
+			MMC_BUS_WIDTH_1
+		};
+		unsigned idx, bus_width;
+
+		if (host->caps & MMC_CAP_8_BIT_DATA)
+			idx = 0;
+		else
+			idx = 1;
+		for (; idx < ARRAY_SIZE(bus_widths); idx++) {
+			bus_width = bus_widths[idx];
+			if (bus_width == MMC_BUS_WIDTH_1)
+				ddr = 0; /* no DDR for 1-bit width */


On Dec 16, 2010, at 3:40 PM, Chris Ball wrote:

> Hi Takashi,
> 
> On Wed, Dec 15, 2010 at 08:14:24AM +0100, Takashi Iwai wrote:
>> From: Aries Lee <arieslee@jmicron.com>
>> 
>> Some old MMC devices fail with the 4/8 bits the driver tries to use
>> exclusively.  This patch adds a test for the given bus setup and falls
>> back to the lower bit mode (until 1-bit mode) when the test fails.
>> 
>> [Major rework and refactoring by tiwai]
>> [Quirk addition and many fixes by prakity]
>> 
>> v1->v2:
>> - Rebased to the code with DDR support, set DDR bit properly
>> - Return always error when bus-switching fallback failed
>> - Define MMC_BUS_TEST_{R|W} in linux/mmc/mmc.h
>> - Add quirk MMC_CAP_BUS_WIDTH_TEST -- default not used for compatibility
>> - Ignore errors on BUS_TEST_W -- improves chances test will work
>> 
>> Signed-off-by: Aries Lee <arieslee@jmicron.com>
>> Signed-off-by: Takashi Iwai <tiwai@suse.de>
>> Signed-off-by: Philip Rakity <prakity@marvell.com>
>> Tested-by: Philip Rakity <prakity@marvell.com>
> 
> This looks good, but adds a warning:
> 
> drivers/mmc/core/mmc.c: In function ‘mmc_init_card’:
> drivers/mmc/core/mmc.c:547: warning: ‘bus_width’ may be used uninitialized in this function
> 
> Thanks,
> 
> -- 
> Chris Ball   <cjb@laptop.org>   <http://printf.net/>
> One Laptop Per Child

