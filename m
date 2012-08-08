Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758918Ab2HHQzx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 12:55:53 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:64984 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758508Ab2HHQzv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 12:55:51 -0400
MIME-Version: 1.0
In-Reply-To: <20120808151555.GE14718@S2101-09.ap.freescale.net>
References: <1344375978-29981-1-git-send-email-matt@genesi-usa.com> <20120808151555.GE14718@S2101-09.ap.freescale.net>
From: Matt Sealey <matt@genesi-usa.com>
Date: Wed, 8 Aug 2012 11:55:30 -0500
Message-ID: <CAKGA1bkbp8_z+HSr97cp_jeCrdTHkQxuZPFu0QPWwnXphWVdZA@mail.gmail.com>
Subject: Re: [PATCH] efikamx: reintroduce Genesi Efika MX Smarttop via device tree
To: Shawn Guo <shawn.guo@linaro.org>
Cc: Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        Steev Klimaszewski <steev@genesi-usa.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 8, 2012 at 10:15 AM, Shawn Guo <shawn.guo@linaro.org> wrote:
> On Tue, Aug 07, 2012 at 04:46:18PM -0500, Matt Sealey wrote:
>> This device tree only supports the final retail board ("TO3").
>>
>> It is currently feature equivalent to the MX51 Babbage device tree. The
>> following features have been tested and work as well as can be expected:
[snip]
>> +     soc {
>> +             aips@70000000 {
>> +                     spba@70000000 {
>> +                             esdhc@70004000 {
>
> The pinctrl_provide_dummies() in imx51_dt_init() is something to be
> removed.  Then any driver calling pinctrl API will require pinctrl
> set up for the device here.  So please have the pinctrl setup for
> those devices.

Absolutely not. Our pins are muxed in U-Boot as they should be. I
refuse to add pinmux entries
or any setup at all for this. What's stopping this right now is you
need a new U-Boot which we
didn't release or mainline because we are still testing it (old U-Boot
shipped on the boards
cannot boot device tree anyway). While the number of users of this is
limited to everyone in
the office here and a few trusted testers, actually the support here
is meaningless for everyone
else, but we feel it needs to go into the tree so we can track changes
when people changing
bindings and basically be future-thinking. We need the nitpicks, but
in this instance, I will
take a leaf from Russell's book and say I violently disagree with
requiring pinctrl to be set up.
There's no need on MX51 with the current state of the architecture and
we've successfully
tested all pad settings in mainline (and older kernels by stripping
muxing from the kernel)
just relying on gpio_direction and value sets.

We'll have a public U-Boot for this board by the end of next week
probably, and it will do it
right the first time.

>> +                     wdog@73f98000 {
>> +                             status = "okay";
>> +                     };
>
> Remove it.  I have queued a patch to enable wdog in <soc>.dtsi
> by default.

Okay.

>> +             aips@80000000 {
>> +                     sdma@83fb0000 {
>> +                             fsl,sdma-ram-script-name = "imx/sdma/sdma-imx51.bin";
>> +                     };
>
> Remove it.  I have seen a patch to move this name into <soc>.dtsi
> as default.

BTW I propose we make this somehow a bootloader-stage thing - at least, the SDMA
firmware should be in a location which is dictated not by the kernel
itself, certainly not
the device tree, but packaging and operating system dependent
features. It describes
the board, not the rootfs. As in, depending on the OS booted it may not be
imx/sdma/sdma-imx51.bin or anything like it. Remember device trees are NOT just
for Linux (or Android, which may still put it in a relative path with
that name, but it
may NOT depending on future changes!)

In a boot.scr for modern U-Boot you might just have

setenv bootargs ${bootargs} imx-sdma.firmware="imx/sdma/sdma-imx51.bin"

Or something similar. OS filesystem paths in device tree are absolutely wrong.

>> -dtb-$(CONFIG_MACH_IMX51_DT) += imx51-babbage.dtb
>> +dtb-$(CONFIG_MACH_IMX51_DT) += imx51-babbage.dtb imx51-efikamx.dtb
>
> Please have the new entry on the new line like dtb-$(CONFIG_SOC_IMX6Q).
> Yes, we will change dtb-$(CONFIG_MACH_IMX53_DT).

Okay.

-- 
Matt Sealey <matt@genesi-usa.com>
Product Development Analyst, Genesi USA, Inc.
