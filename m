Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753532Ab1I1Heo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 03:34:44 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:48554 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751856Ab1I1Hen convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 03:34:43 -0400
MIME-Version: 1.0
In-Reply-To: <20110928064614.GN20550@pengutronix.de>
References: <1317018379-8897-1-git-send-email-u.kleine-koenig@pengutronix.de>
	<4E824821.8040105@windriver.com>
	<20110928064614.GN20550@pengutronix.de>
Date: Wed, 28 Sep 2011 03:34:41 -0400
Message-ID: <CACqU3MXO_yQKJbafD8g+kBje4y+ZWcUMsXvk_2xddrTiumSBbQ@mail.gmail.com>
Subject: Re: [PATCH] dma/imx-sdma+imx-dma: explicitly #include <linux/module.h>
From: Arnaud Lacombe <lacombar@gmail.com>
To: =?ISO-8859-1?Q?Uwe_Kleine=2DK=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>,
        Vinod Koul <vinod.koul@intel.com>,
        Dan Williams <dan.j.williams@intel.com>, linux-kernel@vger.kernel.org,
        kernel@pengutronix.de, linux-arm-kernel@lists.infradead.org,
        linux-kbuild@vger.kernel.org, Michal Marek <mmarek@suse.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

2011/9/28 Uwe Kleine-König <u.kleine-koenig@pengutronix.de>:
> [Cc: += linux-kbuild@v.k.o + Michal Marek]
>
> Hello,
>
> On Tue, Sep 27, 2011 at 06:03:13PM -0400, Paul Gortmaker wrote:
>> On 11-09-26 02:26 AM, Uwe Kleine-König wrote:
>> > This is needed after commit
>> >
>> >     include: replace linux/module.h with "struct module" wherever possible
>> >
>> > (currently 25215aa in next).
>> >
>> > Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
>> > Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
>> > ---
>> > Hello,
>> >
>> > maybe it's sensible for Paul to take that before his commit?
>>
>> Thanks, I'll blend it into the commit adding module.h to the other
>> drivers/dma files.  It seems the imx boards don't have a defconfig
>> in the arch/arm/configs that enables this (CONFIG_IMX_[S]DMA).
>>
>> What is really interesting (at least to me anyway) is that I
>> didn't get one iMX build in some 6000+ ARM randconfig builds....
>>
>> I would have thought it would have showed up at least a couple
>> times, given that number of builds.  Maybe randconfig doesn't
>> deal so well with "choice" Kconfig items?
>>
>> ~/git/module.h/linux-2.6.git$ ls -1 ../build-10*arm |wc -l
>> 6399
>> ~/git/module.h/linux-2.6.git$ grep CONFIG_ARCH_[A-Z0-9]*=y ../build-10*arm*/.config | sed 's/.*CON/CON/'|sort |uniq
>> CONFIG_ARCH_EBSA110=y
>> CONFIG_ARCH_H7201=y
>> CONFIG_ARCH_H7202=y
>> CONFIG_ARCH_H720X=y
>> CONFIG_ARCH_VERSATILE=y
>
> I don't understand why you did that sed, but AFAICT it doesn't hurt,
> too. Maybe adding -c to uniq in your command line is interesting for the
> kbuild people?!
>
this can be reproduced trivially:

for i in $(seq 1 100); do
    make ARCH=arm randconfig
    sed -e '/CONFIG_ARCH_INTEGRATOR/,/CONFIG_ARCH_ZYNQ/!d;' \
        -e '/=y/!d' .config >> arch_selected
done
sort arch_selected | uniq -c

I may have a trivial explanation for part of the symbol, which depends
on MMU, so if these symbols are selected, but MMU is not, it will
fall-back on the default, VERSATILE, which should happen 50% of the
time. However, there is plenty of symbols which have no specific
dependency, and are still not selected.

On the other side, all the result of a randconfig, on the choice alone
(ie. without any 'select' and any other symbols) is spread
"correctly".

Taken as a whole:

% cat arch_selected | sort | uniq -c | wc -l
     3

% cat arch_selected | sort | uniq -c
      2 CONFIG_ARCH_EBSA110=y
      4 CONFIG_ARCH_H720X=y
    100 CONFIG_ARCH_VERSATILE=y

However, when the choice is alone:

% cat arch_selected | sort | uniq -c | wc -l
     39

>> ~/git/module.h/linux-2.6.git$
>>
>> No ARCH_MXC, no ARCH_MXS, PXA, or any of the other 20+ variants.
>> Definitely not a random spread there, with all 6000 builds falling
>> in just 5 buckets.
> How did you test? Generate a .config, test without your change and if
> that succeeds test with it? If so, maybe the problem isn't that
> randconfig doesn't generate more random configs but that you got many
> failures in the first run?!
>
it would seem that taken globally, the result of this particular
choice is not random, but I'm not sure of the dynamic involved
precisely.

I'm not a huge fan of the way randconfig works presently, that it by
just iterating over all symbols and setting a value . I'd prefer to
keep traversing all the menu, picking a random value for
user-changeable setting, over and over until all symbol have been
chosen. However, this is a whole lots of change...

 - Arnaud

> Best regards
> Uwe
>
> --
> Pengutronix e.K.                           | Uwe Kleine-König            |
> Industrial Linux Solutions                 | http://www.pengutronix.de/  |
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
