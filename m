Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757758Ab0FUKcK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 06:32:10 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:54773 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757537Ab0FUKcG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 06:32:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=HIE4TtmeDwl+j5tXgCBeYd4Kja+HjOYCoM8aNlpK7vqMbP2BvgidgRP9NCvPzF53Fk
         1m9NPlwq2VFcgGjRQP/NfyLGBoDw9GcFd6/BpdBBIF4tfyNA9/MfHRkLArgJ2ATJOdED
         3QHdcEpy2zp+8M2vVgiX3Eng8Ya9kzIVZiXiY=
MIME-Version: 1.0
In-Reply-To: <20100621073909.GA20674@oksana.dev.rtsoft.ru>
References: <20090818214449.GA12848@oksana.dev.rtsoft.ru> <20090818214622.GA22651@oksana.dev.rtsoft.ru> 
	<AANLkTikg60s6ZRSEDCq9PQK1z7hJtBDk6t4VE1lYDv8u@mail.gmail.com> 
	<20100618133212.GA5276@oksana.dev.rtsoft.ru> <0F1B54C89D5F954D8535DB252AF412FA065551D8@chinexm1.ad.analog.com> 
	<AANLkTiksYofs6hhWta6uFX2cla_g8pBu0Mtbtcbv-2tl@mail.gmail.com> 
	<20100621071551.GA16109@oksana.dev.rtsoft.ru> <AANLkTiknH95loHJsQNxvCCyQbriCFWqM5LHl3wKzmdWX@mail.gmail.com> 
	<20100621073909.GA20674@oksana.dev.rtsoft.ru>
From: Barry Song <21cnbao@gmail.com>
Date: Mon, 21 Jun 2010 18:31:44 +0800
Message-ID: <AANLkTinjhmkQafVlrtQC5yDnqIZz859_wrZqo45QOEJ2@mail.gmail.com>
Subject: Re: [Uclinux-dist-devel] [PATCH 1/2] mtd: m25p80: Reworkprobing/JEDEC 
	code
To: Anton Vorontsov <cbouatmailru@gmail.com>
Cc: "Song, Barry" <Barry.Song@analog.com>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Artem Bityutskiy <dedekind1@gmail.com>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, linux-mtd@lists.infradead.org,
       uclinux-dist-devel@blackfin.uclinux.org,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 21, 2010 at 3:39 PM, Anton Vorontsov <cbouatmailru@gmail.com> wrote:
> On Mon, Jun 21, 2010 at 03:22:48PM +0800, Barry Song wrote:
>> On Mon, Jun 21, 2010 at 3:15 PM, Anton Vorontsov <cbouatmailru@gmail.com> wrote:
>> > On Mon, Jun 21, 2010 at 11:27:31AM +0800, Barry Song wrote:
>> > [...]
>> >> > How about we add a non_jedec flag in platform_data, if the flag is 1, we
>> >> > let the detection pass even though the ID is 0? Otherwise, we need a
>> >> > valid ID?
>> >> Here i mean:
>> >
>> > This will break at least OF-enabled platforms (e.g. PowerPC),
>> > they assume that the driver will success for non-JEDEC flashes.
>> > OF platforms don't pass platform data, and even if they did,
>> > device tree doesn't specify if the flash is JEDEC or non-JEDEC.
>> >
>> > Which is why I think that, by default, the driver should
>> > successfully register the flash even if JEDEC probe fails. So,
>> > instead of checking for "!non_jedec", I would recommend
>> > "force_jedec" check.
>>
>> Mike Frysinger suggested to use non_jedec since most devices are
>> standard jedec devices.
>
> Well, on OF platforms most devices that I'm aware of are non-JEDEC.
>
>> Only if non_jedec=1, we let the detection pass
>> if ID is 0.
>
> Then please #ifdef it with CONFIG_OF.
I think the patch has nothing to do with platform. Here SPI Flash is a
peripherals, doesn't depend on any platform. Adding a CONFIG_OF
doesn't make sense very much.
If you think most devices are non-JEDEC, we can change non_JEDEC to
force_JEDEC as you said. But anyway, is that real that most devices
are non_JEDEC?  If not, I think we should change OF platform codes to
fit with this patch.

>
> Thanks,
>
>> >> Index: drivers/mtd/devices/m25p80.c
>> >> ===================================================================
>> >> --- drivers/mtd/devices/m25p80.c      (revision 8927)
>> >> +++ drivers/mtd/devices/m25p80.c      (revision 8929)
>> >> @@ -795,8 +795,13 @@
>> >>
>> >>               jid = jedec_probe(spi);
>> >>               if (!jid) {
>> >> -                     dev_info(&spi->dev, "non-JEDEC variant of %s\n",
>> >> -                              id->name);
>> >> +                     if (!data->non_jedec) {
>> >> +                             dev_err(&spi->dev, "fail to detect%s\n",
>> >> +                                             id->name);
>> >> +                             return -ENODEV;
>> >> +                     } else
>> >> +                             dev_info(&spi->dev, "non-JEDEC variant of %s\n",
>> >> +                                             id->name);
>> >>               } else if (jid != id) {
>> >
>> > --
>> > Anton Vorontsov
>> > email: cbouatmailru@gmail.com
>> > irc://irc.freenode.net/bd2
>> >
>
> --
> Anton Vorontsov
> email: cbouatmailru@gmail.com
> irc://irc.freenode.net/bd2
>
