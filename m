Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754595Ab2BKKz2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Feb 2012 05:55:28 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:40298 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751940Ab2BKKz0 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Feb 2012 05:55:26 -0500
MIME-Version: 1.0
In-Reply-To: <4B11A480-8122-4A0B-A0EE-E1E95477F985@marvell.com>
References: <CAAJw_ZsryUFFFRCKdd9sQ7_38hjpVq37b6hhZDX5=qz8x1B+EQ@mail.gmail.com>
	<m2pqdr2tyq.fsf@bob.laptop.org>
	<CAAJw_Zv4Hk_kfc33xsVcdi-0_C6tsf_FD3sUx1JPDX_fZZMzeQ@mail.gmail.com>
	<4F30E19B.9020503@intel.com>
	<CAAJw_Zth+QM8OhMEWweBBek8QNW_9CseHSDuB-LCGrvwuqfV2A@mail.gmail.com>
	<4F310529.4020101@intel.com>
	<CAAJw_ZsHwdvXuw+edXUfyGOSMOu5oUw3zX8nUryxJJiiZXzXKQ@mail.gmail.com>
	<CAAJw_Zup7Wg7FO95Z63e_sniu21gyzdCjcBNgsS0aw6MguDwLw@mail.gmail.com>
	<CAAJw_Zv6HkLLqEzNKRCfQ7EbMNEVe_hzbW+mHOnDAWLidOhMBQ@mail.gmail.com>
	<CAAJw_Zs7aET=vdy033bzuHwW==uS8AW78NSvD2L_hjU+Mzp-_w@mail.gmail.com>
	<4F31B789.9020509@samsung.com>
	<CAAJw_ZtnWYxGCm5Vm5CQ1GBLc=GU7AGiQKe_-9LJsbMW+YG-GQ@mail.gmail.com>
	<15D4F59C-7AFA-456E-8A5F-9E11EE9B9717@marvell.com>
	<CAAJw_Zs+Jz9WiJd6254Zkj+Y76w9W3CqZTgGrLYRRsjuxnqTyw@mail.gmail.com>
	<4B11A480-8122-4A0B-A0EE-E1E95477F985@marvell.com>
Date: Sat, 11 Feb 2012 18:55:24 +0800
Message-ID: <CAAJw_Zu=M7R5cyVRmbd3Tz7MipgX_b5J4g5Z4m+SsiHP-3Uxgw@mail.gmail.com>
Subject: Re: mmc sdhci mmcblk0: error -110 sending status command, retrying
From: Jeff Chua <jeff.chua.linux@gmail.com>
To: Philip Rakity <prakity@marvell.com>
Cc: Jaehoon Chung <jh80.chung@samsung.com>, Chris Ball <cjb@laptop.org>,
        Pierre Ossman <pierre@ossman.eu>, lkml <linux-kernel@vger.kernel.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "arindam.nath@amd.com" <arindam.nath@amd.com>,
        "zhangfei.gao@gmail.com" <zhangfei.gao@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 11, 2012 at 4:28 AM, Philip Rakity <prakity@marvell.com> wrote:
>
> On Feb 10, 2012, at 8:18 AM, Jeff Chua wrote:
>
>> On Thu, Feb 9, 2012 at 3:09 AM, Philip Rakity <prakity@marvell.com> wrote:
>>>
>>>
>>> Jeff,
>>>
>>> I think the sdhci.c clock setting code was changed a while ago.   Maybe revert that mod and see what happens.
>>>
>>> The card is a 24MHz which is rather slow so I would be surprised if that was it.
>>> The other option is the force enable the High Speed bit in the  controller (used when speed is 25MHz or faster).  Will give the system more time (in theory) to work.
>>
>> That's a good point to start looking. I poked around and by setting
>> host->ios.clock to 10000000 instead of 25000000, read from a 16GB card
>> is no longer giving any error.
>>
>> I still don't dare to do any write. Already burn one 16GB SD and not
>> ready to trash another. I asked earlier but haven't got any reply as
>> to how to recover an SD that says "No medium found". Any chance of
>> recovering it?
>>
>> Here's what I did. If set too low (1000000) or too high (25000000),
>> random errors appeared.
>>
>> --- linux/drivers/mmc/core/core.c.org   2012-02-10 23:57:49.000000000 +0800
>> +++ linux/drivers/mmc/core/core.c       2012-02-10 23:53:59.000000000 +0800
>> @@ -881,7 +881,7 @@
>>        if (hz > host->f_max)
>>                hz = host->f_max;
>>
>> -       host->ios.clock = hz;
>> +       host->ios.clock = 10000000;
>>        mmc_set_ios(host);
>> }
>>
>>
>
> good news.  The other possibility but unlikely is that the timeout is too low for the card.
>
> There is a quirk for this.
>
> SDHCI_BROKEN_TIMEOUT_VAL
>
> my guess is that you will need to measure the clk pin and see if it matches the frequency being programmed.  (could be less).
>
> a simple hack is to add a printk to set_ios() or set_clock() and print out the clock rate clock register (divider) and see if they match what you should be seeing.
> It is possible the bug is NOT in this area but in the platform code where an incorrect base freq is being setup for the controller.

sdhci: Secure Digital Host Controller Interface driver
sdhci: Copyright(c) Pierre Ossman
sdhci-pci 0000:0d:00.0: SDHCI controller found [1180:e823] (rev 4)
Registered led device: mmc0::
mmc0: clock 0Hz busmode 1 powermode 0 cs 0 Vdd 0 width 0 timing 0
mmc0: SDHCI controller on PCI [0000:0d:00.0] using DMA
mmc0: clock 0Hz busmode 2 powermode 1 cs 0 Vdd 21 width 0 timing 0
mmc0: clock 400000Hz busmode 2 powermode 2 cs 0 Vdd 21 width 0 timing 0
mmc0: clock 400000Hz busmode 2 powermode 2 cs 1 Vdd 21 width 0 timing 0
mmc0: clock 400000Hz busmode 2 powermode 2 cs 0 Vdd 21 width 0 timing 0
mmc0: clock 400000Hz busmode 2 powermode 2 cs 0 Vdd 20 width 0 timing 0
mmc0: clock 400000Hz busmode 2 powermode 2 cs 1 Vdd 20 width 0 timing 0
mmc0: clock 400000Hz busmode 2 powermode 2 cs 0 Vdd 20 width 0 timing 0
hz 25000000 min 16129 max 33000000 ios 400000
mmc0: clock 10000000Hz busmode 2 powermode 2 cs 0 Vdd 20 width 0 timing 0
mmc0: clock 10000000Hz busmode 2 powermode 2 cs 0 Vdd 20 width 2 timing 0
mmc0: new SDHC card at address b368
mmcblk0: mmc0:b368 H1109 14.9 GiB (ro)
mmcblk0: p1
mmc0: clock 0Hz busmode 2 powermode 2 cs 0 Vdd 20 width 2 timing 0
hz 10000000 min 16129 max 33000000 ios 0
mmc0: clock 10000000Hz busmode 2 powermode 2 cs 0 Vdd 20 width 2 timing 0
mmc0: clock 0Hz busmode 2 powermode 2 cs 0 Vdd 20 width 2 timing 0
hz 10000000 min 16129 max 33000000 ios 0
mmc0: clock 10000000Hz busmode 2 powermode 2 cs 0 Vdd 20 width 2 timing 0
mmc0: clock 0Hz busmode 2 powermode 2 cs 0 Vdd 20 width 2 timing 0
hz 10000000 min 16129 max 33000000 ios 0
mmc0: clock 10000000Hz busmode 2 powermode 2 cs 0 Vdd 20 width 2 timing 0
mmc0: clock 0Hz busmode 2 powermode 2 cs 0 Vdd 20 width 2 timing 0
hz 10000000 min 16129 max 33000000 ios 0
mmc0: clock 10000000Hz busmode 2 powermode 2 cs 0 Vdd 20 width 2 timing 0


Hope this helps. Also, I've tried setting hz to 20000000 but
encountered random errors.

Also, these are from dmesg ...

Detected 2790.999 MHz processor.
Calibrating delay loop (skipped), value calculated using timer
frequency.. 5581.99 BogoMIPS (lpj=27909990)
pci 0000:0d:00.0: [1180:e823] type 0 class 0x000880
pci 0000:0d:00.0: MMC controller base frequency changed to 50Mhz.
pci 0000:0d:00.0: reg 10: [mem 0xf1500000-0xf15000ff]
pci 0000:0d:00.0: supports D1 D2
pci 0000:0d:00.0: PME# supported from D0 D1 D2 D3hot D3cold


.config
CONFIG_NO_HZ=y
CONFIG_HZ_100=y



Thanks,
Jeff
