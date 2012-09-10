Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751816Ab2IJJvK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 05:51:10 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:57541 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751200Ab2IJJvH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 05:51:07 -0400
MIME-Version: 1.0
In-Reply-To: <1347016499-29354-5-git-send-email-lee.jones@linaro.org>
References: <1347016499-29354-1-git-send-email-lee.jones@linaro.org>
	<1347016499-29354-5-git-send-email-lee.jones@linaro.org>
Date: Mon, 10 Sep 2012 02:51:04 -0700
Message-ID: <CACRpkdYHd+oDMiwwodkPAMkFW0h4t+7-EzpoJ9jkkpSLgankow@mail.gmail.com>
Subject: Re: [PATCH 04/19] ARM: ux500: Add SDI (MMC) support to the HREF
 Device Tree
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>, Ulf Hansson <ulf.hansson@linaro.org>,
        Per Forlin <per.forlin@stericsson.com>,
        Johan Rudholm <johan.rudholm@stericsson.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de, Loic Pallardy <loic.pallardy@stericsson.com>,
        Gabriel FERNANDEZ <gabriel.fernandez@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 7, 2012 at 1:14 PM, Lee Jones <lee.jones@linaro.org> wrote:

I really want Ulf, Per or Johan to have a look at this, so Cc:ing them..

> +               // External Micro SD slot

Are C99 comments OK in DTS files?
Else /* comment like that */
(See Documentation/CodingStyle)
Ah well, nitpick, I don't care really.

> +               sdi@80126000 {

Not just sdi@ please, these have names in the current
board code that comes from the DB8500 reference manual.

In this case 80120000 is the per1 (peripheral group one),
and offset 6000 in that group is SDI0.

So the quick fix is to name it like:

sdi0_per1@80126000

But basically we have a deeper problem here. I think the
ux500 Device Tree should be arranged after peripheral
block so it actually reflects the hardware (yeah, a big
fat sorry for not realizing that before....)

So it should *actually* be like:

per_group_1 {
    sdi0@80126000 {
    };
};

per_group_2 {
    sdi4@80114000 {
    };
    sdi1@80118000 {
    };
    sdi3@80119000 {
    };
};

Then I do not know if it's also possible to use the
peripheral group offsets for the registers? Can you do
this thing and have it working?

per_group_1 {
    reg = <0x80110000 0x10000>;
    sdi0@80126000 {
        reg = <0x6000 0x10000>;
    };
};

I.e. so getting the regs for sdi0 would give 0x80116000?

Any of the above proper solutions require a heavy patch
on the SoC .dtsi pushing all peripherals to their
peripheral group to go in first of course.

> +                       arm,primecell-periphid = <0x10480180>;
> +                       max-frequency = <50000000>;
> +                       bus-width = <8>;

Isn't *THIS* (sdi0) the one which is 4 bits? (SD cards only have 4
lines...)

> +                       mmc-cap-sd-highspeed;
> +                       mmc-cap-mmc-highspeed;
> +                       vmmc-supply = <&ab8500_ldo_aux3_reg>;
> +
> +                       #gpio-cells = <1>;

Arnd already complained about this...

> +                       cd-gpios  = <&gpio2 31 0x4>; // 95

95? 95 what? Lightning McQueen?
http://en.wikipedia.org/wiki/Lightning_McQueen

Elaborate or drop ;-)

> +
> +                       status = "okay";
> +               };
> +
> +               // WLAN SDIO channel
> +               sdi@80118000 {
> +                       arm,primecell-periphid = <0x10480180>;
> +                       max-frequency = <50000000>;
> +                       bus-width = <4>;

Isn't this 8 bit capable?

> +
> +                       status = "okay";
> +               };
> +
> +               // PoP:ed eMMC
> +               sdi@80005000 {
> +                       arm,primecell-periphid = <0x10480180>;
> +                       max-frequency = <50000000>;
> +                       bus-width = <8>;
> +                       mmc-cap-mmc-highspeed;
> +
> +                       status = "okay";
> +               };
> +
> +               // On-board eMMC
> +               sdi@80114000 {
> +                       arm,primecell-periphid = <0x10480180>;
> +                       max-frequency = <50000000>;
> +                       bus-width = <8>;
> +                       mmc-cap-mmc-highspeed;
> +                       vmmc-supply = <&ab8500_ldo_aux2_reg>;
> +
> +                       status = "okay";
> +               };
>         };
>  };

Inspecting board-mop500-sdi.c I see missing pieces that gets me
worried about whether this device tree even works, and which
I am sure has regressions in highly demanding usecases because
these things are there for a reason:

- .sigdir is defined with some flags for the MMCI platform data
  for sdi0 (SD card), and no DT bindings are available for it.
  I think Ulf had a patch for pushing this into the driver that will
  need to go in first.

- SDI0 has a callback .ios_handler that I guess must be passed
  in using platform data. If you don't have this, level-shifting
  cards will not be run at optimal voltage, symptom: you cannot
  gear up signals level and will get bad blocks at some high
  speeds on some cards.

(The .ocr_mask is surplus though!)

I really think the above needs to be resolved (preferrably
by pusing some of Ulfs MMCI patches) before we can move
on with MMC DT.

Yours,
Linus Walleij
