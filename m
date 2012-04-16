Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754374Ab2DPS7R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 14:59:17 -0400
Received: from mail209.messagelabs.com ([216.82.255.3]:53802 "EHLO
	mail209.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752485Ab2DPS7Q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 14:59:16 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-12.tower-209.messagelabs.com!1334602738!3332867!36
X-Originating-IP: [216.166.12.69]
X-StarScan-Version: 6.5.7; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Rafal Prylowski <prylowski@metasoft.pl>
CC: Mika Westerberg <mika.westerberg@iki.fi>,
        "vinod.koul@intel.com" <vinod.koul@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "rmallon@gmail.com" <rmallon@gmail.com>
Date: Mon, 16 Apr 2012 13:59:08 -0500
Subject: RE: [PATCH] ep93xx: Implement double buffering for M2M DMA channels
Thread-Topic: [PATCH] ep93xx: Implement double buffering for M2M DMA channels
Thread-Index: Ac0Xs1rGHQKdSwDwR0axCj1A9GwhsgEThigw
Message-ID: <ADE657CA350FB648AAC2C43247A983F00206987A3BFE@AUSP01VMBX24.collaborationhost.net>
References: <4F683B36.8090101@metasoft.pl>
 <20120321193836.GC3740@mwesterb-mobl.ger.corp.intel.com>
 <ADE657CA350FB648AAC2C43247A983F0020696D48E3E@AUSP01VMBX24.collaborationhost.net>
 <20120323070446.GC5812@mwesterb-mobl.ger.corp.intel.com>
 <ADE657CA350FB648AAC2C43247A983F0020696D48EEB@AUSP01VMBX24.collaborationhost.net>
 <20120410172853.GA25697@mwesterb-mobl>
 <ADE657CA350FB648AAC2C43247A983F00206986C01D4@AUSP01VMBX24.collaborationhost.net>
 <4F853053.7040800@metasoft.pl>
In-Reply-To: <4F853053.7040800@metasoft.pl>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, April 11, 2012 12:19 AM, Rafal Prylowski wrote:
> On 2012-04-10 19:55, H Hartley Sweeten wrote:
>> On Tuesday, April 10, 2012 10:29 AM, Mika Westerberg wrote:
>>> On Fri, Mar 23, 2012 at 11:09:50AM -0500, H Hartley Sweeten wrote:
>>>
>>> Now that the spurious interrupts thing with VIC has been sorted out, should we
>>> revisit this patch? Hartley, do you have any objections merging this?
> >
>> I have not had a chance to look at this with the VIC issue fixed.
>> 
>> Last time I tried testing the double buffering patch my system would not boot
>> correctly. I'll try to test this again shortly.
>> 
>> Rafal,
>> 
>> Could you repost the latest version of the patch?
>> 
>
> Hi,
>
> Here is the patch. It applies to current mainline (3.4rc2). The only thing that
> has changed is additional call to ep93xx_dma_advance_active(..) before disabling
> the channel.

Rafal,

This patch still doesn't work on my ep93xx system.

FWIW, I have two devices on my SPI bus:

static struct spi_board_info vision_spi_board_info[] __initdata = {
	{
		.modalias		= "sst25l",
		.platform_data		= &vision_spi_flash_data,
		.controller_data	= &vision_spi_flash_hw,
		.max_speed_hz		= 20000000,
		.bus_num		= 0,
		.chip_select		= 0,
		.mode			= SPI_MODE_3,
	}, {
		.modalias		= "mmc_spi",
		.platform_data		= &vision_spi_mmc_data,
		.controller_data	= &vision_spi_mmc_hw,
		.max_speed_hz		= 20000000,
		.bus_num		= 0,
		.chip_select		= 1,
		.mode			= SPI_MODE_3,
	},
};

static struct ep93xx_spi_info vision_spi_master __initdata = {
	.num_chipselect		= ARRAY_SIZE(vision_spi_board_info),
	.use_dma		= true,
};

With your patch applied I get these relevant messages during boot:

sst25l spi0.0: sst25lf040a (512 KiB)
Creating 3 MTD partitions on "SPI Flash":
0x000000000000-0x000000001000 : "SPI bootstrap"
0x000000001000-0x000000002000 : "Bootstrap config"
0x000000002000-0x000000080000 : "System config"
ep93xx-spi ep93xx-spi.0: EP93xx SPI Controller at 0x808a0000 irq 53
mmc_spi spi0.1: SD/MMC host mmc0, no poweroff

And /proc/interrupts shows this right after boot:

# cat /proc/interrupts
           CPU0
  4:       4519       VIC  ep93xx timer
 17:    1268725       VIC  ep93xx-spi-rx
 18:    1277244       VIC  ep93xx-spi-tx
 29:          0       VIC  ep93xx-keypad
 33:          0       VIC  rtc-isl1208
 39:        176       VIC  eth0
 52:        112       VIC  uart-pl010
 53:          1       VIC  ep93xx-spi
 56:          0       VIC  ohci_hcd:usb1
 79:          0      GPIO  mmc_spi:cd
 87:          0      GPIO  0-0074

Without your patch I get this:

sst25l spi0.0: sst25lf040a (512 KiB)
Creating 3 MTD partitions on "SPI Flash":
0x000000000000-0x000000001000 : "SPI bootstrap"
0x000000001000-0x000000002000 : "Bootstrap config"
0x000000002000-0x000000080000 : "System config"
ep93xx-spi ep93xx-spi.0: EP93xx SPI Controller at 0x808a0000 irq 53
mmc_spi spi0.1: SD/MMC host mmc0, no poweroff
mmc0: new SD card on SPI
mmcblk0: mmc0:0000 S064B 60.6 MiB
mmcblk0: p1

# cat /proc/interrupts
           CPU0
  4:       1794       VIC  ep93xx timer
 17:        141       VIC  ep93xx-spi-rx
 18:        141       VIC  ep93xx-spi-tx
 29:          0       VIC  ep93xx-keypad
 33:          0       VIC  rtc-isl1208
 39:        100       VIC  eth0
 52:        109       VIC  uart-pl010
 53:        418       VIC  ep93xx-spi
 56:          0       VIC  ohci_hcd:usb1
 79:          0      GPIO  mmc_spi:cd
 87:          0      GPIO  0-0074
Err:          0

It appears your patch is causing an interrupt storm on my system.

Regards,
Hartley

