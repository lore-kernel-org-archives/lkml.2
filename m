Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752355Ab0L1I1m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Dec 2010 03:27:42 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:40882 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752141Ab0L1I1j convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Dec 2010 03:27:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Lir5ROAgIWO9X6UD0zbAv+J1hVoHvZ74JE7rHEtvsR+syoi+xdp2UqOaO55CsPrnzJ
         xCzUzqkW/ZmpBbd6+OtyjQYujIx+N0TsEO4VQsvaFoL2jxgQovmCQCiJrYbhWsk5gOSj
         G8OrMbgTALOUCnyTSHpkrXviO0xGR553GyM74=
MIME-Version: 1.0
In-Reply-To: <s5h62umnpxb.wl%tiwai@suse.de>
References: <s5hfwtzbj8v.wl%tiwai@suse.de>
	<20101216234032.GA17239@void.printf.net>
	<50D31EC8-BD9E-4920-8CEB-2AD10DF9C5C5@marvell.com>
	<20101217034342.GA19673@void.printf.net>
	<s5hy67o95to.wl%tiwai@suse.de>
	<AANLkTimSt5a998m1oqdppsWjGCVid0-Ub81pKgsPR36f@mail.gmail.com>
	<E81C83FE-E3AD-49DA-86BE-95631F1B81CD@marvell.com>
	<AANLkTim6pQW0sDtZRNbXbgbvzuXKCdsju7z_ADBxvXPd@mail.gmail.com>
	<s5h62umnpxb.wl%tiwai@suse.de>
Date: Tue, 28 Dec 2010 03:27:37 -0500
Message-ID: <AANLkTinkskR0_3LsZtjy_iA6ti1cKDWCe=Verq8DSkvs@mail.gmail.com>
Subject: Re: [PATCH] mmc: Test bus-width for old MMC devices (v2)
From: zhangfei gao <zhangfei.gao@gmail.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: Philip Rakity <prakity@marvell.com>, Chris Ball <cjb@laptop.org>,
        Aries Lee <arieslee@jmicron.com>, Qiming Wu <wuqm@marvell.com>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 22, 2010 at 3:59 AM, Takashi Iwai <tiwai@suse.de> wrote:
> At Tue, 21 Dec 2010 22:56:32 -0500,
> zhangfei gao wrote:
>>
>> On Tue, Dec 21, 2010 at 11:36 AM, Philip Rakity <prakity@marvell.com> wrote:
>> >
>> >
>> > Can you please try this diff and see if it works for you.
>> >
>> > Will do formal patch after your testing.  What card is failing ?
>> >
>> > Please let me know the manufacturing information so can add card to my test suite.
>> >
>> > Philip
>> >
>> > diff --git a/drivers/mmc/core/mmc.c b/drivers/mmc/core/mmc.c
>> > index 1d8409f..77072c8 100644
>> > --- a/drivers/mmc/core/mmc.c
>> > +++ b/drivers/mmc/core/mmc.c
>> > @@ -558,6 +558,8 @@ static int mmc_init_card(struct mmc_host *host, u32 ocr,
>> >                                         EXT_CSD_BUS_WIDTH,
>> >                                         ext_csd_bits[idx][0]);
>> >                        if (!err) {
>> > +                               mmc_set_bus_width_ddr(card->host,
>> > +                                                     bus_width, MMC_SDR_MODE);
>> Test OK,
>> Curious why move here, then mmc_set_bus_width_ddr is called twice in
>> fact when ddr=0 &&  (!(host->caps & MMC_CAP_BUS_WIDTH_TEST)), though
>> not impact function.
>> mmc_set_bus_width is mmc_set_bus_width_ddr(host, width, MMC_SDR_MODE).
>
> Right.  How about the patch below?  This one just moves the call
> before caps test, so it's simpler (and avoiding double calls).
>
>
> thanks,
>
> Takashi
>
> ===
> From b66b9704f8d2fefa402741fb17949224b2766b4f Mon Sep 17 00:00:00 2001
> From: Takashi Iwai <tiwai@suse.de>
> Date: Wed, 22 Dec 2010 09:54:33 +0100
> Subject: [PATCH] mmc: fix mmc_set_bus_width_ddr() call without bus-width-test cap
>
> With the bus-width test patch, mmc_set_bus_width*() isn't called properly
> when the driver doesn't set MMC_CAP_BUS_WIDTH and no DDR mode.
> This patch fixes the regression by moving the call up before the cap test.
>
> Signed-off-by: Takashi Iwai <tiwai@suse.de>
> ---
>  drivers/mmc/core/mmc.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/mmc/core/mmc.c b/drivers/mmc/core/mmc.c
> index 1d8409f..c86dd73 100644
> --- a/drivers/mmc/core/mmc.c
> +++ b/drivers/mmc/core/mmc.c
> @@ -558,6 +558,8 @@ static int mmc_init_card(struct mmc_host *host, u32 ocr,
>                                         EXT_CSD_BUS_WIDTH,
>                                         ext_csd_bits[idx][0]);
>                        if (!err) {
> +                               mmc_set_bus_width_ddr(card->host,
> +                                                     bus_width, MMC_SDR_MODE);
>                                /*
>                                 * If controller can't handle bus width test,
>                                 * use the highest bus width to maintain
> @@ -565,8 +567,6 @@ static int mmc_init_card(struct mmc_host *host, u32 ocr,
>                                 */
>                                if (!(host->caps & MMC_CAP_BUS_WIDTH_TEST))
>                                        break;
> -                               mmc_set_bus_width_ddr(card->host,
> -                                                     bus_width, MMC_SDR_MODE);
>                                err = mmc_bus_test(card, bus_width);
>                                if (!err)
>                                        break;
> --
> 1.7.3.4

It's also works, solve (ddr=0 & (!(host->caps & MMC_CAP_BUS_WIDTH_TEST))) issue.
Is it possible to merge to original patch.

Thanks
>
>
>
