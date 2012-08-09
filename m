Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030538Ab2HIOaG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 10:30:06 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:33870 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030204Ab2HIOaB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 10:30:01 -0400
MIME-Version: 1.0
In-Reply-To: <CAOMZO5DOEfV4wTSNW8ABaUhGwa_KG3Bkt0o-rs8k-cZk4P-=+A@mail.gmail.com>
References: <1344375978-29981-1-git-send-email-matt@genesi-usa.com>
 <20120808151555.GE14718@S2101-09.ap.freescale.net> <CAKGA1bkbp8_z+HSr97cp_jeCrdTHkQxuZPFu0QPWwnXphWVdZA@mail.gmail.com>
 <CAOMZO5DOEfV4wTSNW8ABaUhGwa_KG3Bkt0o-rs8k-cZk4P-=+A@mail.gmail.com>
From: Matt Sealey <matt@genesi-usa.com>
Date: Thu, 9 Aug 2012 09:29:39 -0500
Message-ID: <CAKGA1bkOo=En2P18FaBpq_KAZ88kisikXhNTabvnDknQ-EwFjA@mail.gmail.com>
Subject: Re: [PATCH] efikamx: reintroduce Genesi Efika MX Smarttop via device tree
To: Fabio Estevam <festevam@gmail.com>
Cc: Shawn Guo <shawn.guo@linaro.org>,
        Steev Klimaszewski <steev@genesi-usa.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 8, 2012 at 12:19 PM, Fabio Estevam <festevam@gmail.com> wrote:
> Matt,
>
> On Wed, Aug 8, 2012 at 1:55 PM, Matt Sealey <matt@genesi-usa.com> wrote:
>
> ...
>> or any setup at all for this. What's stopping this right now is you
>> need a new U-Boot which we
>> didn't release or mainline because we are still testing it (old U-Boot
>> shipped on the boards
>> cannot boot device tree anyway). While the number of users of this is
>
> Actually you can boot a device tree kernel even on old bootloaders
> that do not support dt.
>
> You need to select:
> CONFIG_ARM_APPENDED_DTB=y
> CONFIG_ARM_ATAG_DTB_COMPAT=y
>
> Then,
>
> make -j4 zImage
> make imx51-babbage.dtb
> cat arch/arm/boot/zImage arch/arm/boot/ imx51-babbage.dtb  >
> arch/arm/boot/zImage_dtb
> mkimage -A arm -O linux -T kernel -C none -a 0x90008000 -e 0x90008000
> -n Linux -d arch/arm/boot/zImage_dtb arch/arm/boot/uImage
>
> and boot this generated uImage the same way as you used to do in the
> non-dt case.

That's true, but we don't have our customers compile their own kernels
if they can help it, and appending a dtb to the end of a kernel isn't
part of distro packaging so it just doesn't get done yet... We'd need
to update a bunch of scripts, test them, and then deal with the
frightening scenario of appending a dtb to a kernel *and* passing the
address of the filesystem version (usually the one appended!) - hoping
either works. It's too much testing. We'd rather update everyone to a
new U-Boot that works, and deal with a single point on that end, that
can boot the legacy kernel (machine id matches, legacy boot works on
old kernel) and the new kernel alike.

All of this is coming from development branches we have here, and
we're pushing it to mainline as a convenience for everyone concerned.

What we've got on the test plan is;

1) Old U-Boot, Old Kernel. This works already for years.
2) New U-Boot, Old Kernel. This works, well tested.
3) New U-Boot, New Kernel+DTB. This works or we wouldn't be sending patches.

The Old U-Boot, New Kernel doesn't make sense for us if the New U-Boot
is all that's required to retain functionality.

The reason the new kernel depends on the new U-Boot is we're trying to
do all pinmux configuration in U-Boot (and we do in-house, and it
works). No pinctrl stuff in the kernel or device tree is required at
this point. The Old Kernel will remux a few things redundantly or
change drive strengths or whatever or add hysteresis to the UART port
which is not board-burning but is not really necessary, but it will
work. The new kernel will just be able to do what it does out of the
box, which is how it should be (hence why I object to adding pinctrl
setup...)

--
Matt Sealey <matt@genesi-usa.com>
