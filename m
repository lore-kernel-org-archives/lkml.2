Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754027Ab0FVGiP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 02:38:15 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:42307 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753843Ab0FVGiO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 02:38:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=IVsdpF0W+y4owfLvyrSCTHHLgKjV90OStoYvf5DyvqUsS3RJH65N/Mk8mOq43Umm79
         Ga/J9VPNODL9Mx/8YpCqp0ezczwMnu2EbQVmM/xR1gWp6IrPyyZnx5yiE46PVs8iLWYK
         TcEOlxJHxxrhC8AZiLnZ7m21kKpaQZXeB2o1Q=
MIME-Version: 1.0
In-Reply-To: <20100621112049.GA9273@oksana.dev.rtsoft.ru>
References: <20090818214449.GA12848@oksana.dev.rtsoft.ru> <20090818214622.GA22651@oksana.dev.rtsoft.ru> 
	<AANLkTikg60s6ZRSEDCq9PQK1z7hJtBDk6t4VE1lYDv8u@mail.gmail.com> 
	<20100618133212.GA5276@oksana.dev.rtsoft.ru> <0F1B54C89D5F954D8535DB252AF412FA065551D8@chinexm1.ad.analog.com> 
	<AANLkTiksYofs6hhWta6uFX2cla_g8pBu0Mtbtcbv-2tl@mail.gmail.com> 
	<20100621071551.GA16109@oksana.dev.rtsoft.ru> <AANLkTiknH95loHJsQNxvCCyQbriCFWqM5LHl3wKzmdWX@mail.gmail.com> 
	<20100621073909.GA20674@oksana.dev.rtsoft.ru> <AANLkTinjhmkQafVlrtQC5yDnqIZz859_wrZqo45QOEJ2@mail.gmail.com> 
	<20100621112049.GA9273@oksana.dev.rtsoft.ru>
From: Barry Song <21cnbao@gmail.com>
Date: Tue, 22 Jun 2010 14:37:52 +0800
Message-ID: <AANLkTikY9pfHsQ6xeVkixKF5kqL2nLyV2kgcR2iJKhG-@mail.gmail.com>
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

On Mon, Jun 21, 2010 at 7:20 PM, Anton Vorontsov <cbouatmailru@gmail.com> wrote:
> On Mon, Jun 21, 2010 at 06:31:44PM +0800, Barry Song wrote:
>> On Mon, Jun 21, 2010 at 3:39 PM, Anton Vorontsov <cbouatmailru@gmail.com> wrote:
>> > On Mon, Jun 21, 2010 at 03:22:48PM +0800, Barry Song wrote:
>> >> On Mon, Jun 21, 2010 at 3:15 PM, Anton Vorontsov <cbouatmailru@gmail.com> wrote:
>> >> > On Mon, Jun 21, 2010 at 11:27:31AM +0800, Barry Song wrote:
>> >> > [...]
>> >> >> > How about we add a non_jedec flag in platform_data, if the flag is 1, we
>> >> >> > let the detection pass even though the ID is 0? Otherwise, we need a
>> >> >> > valid ID?
>> >> >> Here i mean:
>> >> >
>> >> > This will break at least OF-enabled platforms (e.g. PowerPC),
>> >> > they assume that the driver will success for non-JEDEC flashes.
>> >> > OF platforms don't pass platform data, and even if they did,
>> >> > device tree doesn't specify if the flash is JEDEC or non-JEDEC.
>> >> >
>> >> > Which is why I think that, by default, the driver should
>> >> > successfully register the flash even if JEDEC probe fails. So,
>> >> > instead of checking for "!non_jedec", I would recommend
>> >> > "force_jedec" check.
>> >>
>> >> Mike Frysinger suggested to use non_jedec since most devices are
>> >> standard jedec devices.
>> >
>> > Well, on OF platforms most devices that I'm aware of are non-JEDEC.
>> >
>> >> Only if non_jedec=1, we let the detection pass
>> >> if ID is 0.
>> >
>> > Then please #ifdef it with CONFIG_OF.
>> I think the patch has nothing to do with platform. Here SPI Flash is a
>> peripherals, doesn't depend on any platform. Adding a CONFIG_OF
>> doesn't make sense very much.
>
> With OF we don't place non-existent devices into the device
> tree (or we mark them with status = "not-ok/disabled/absent"
> property).
>
>> If you think most devices are non-JEDEC, we can change non_JEDEC to
>> force_JEDEC as you said.
>> But anyway, is that real that most devices are non_JEDEC?
>
> Why would this matter? We have to support both.
>
>> If not, I think we should change OF platform codes to
>> fit with this patch.
>
> You can't easily change OF. It's like "let's change ACPI tables
> or BIOS in these PCs". Doable, but involves things like reflashing.
> And we usually have to support old BIOSes as well.
>
> OTOH, I see (git grep m25p arch/powerpc/boot/dts/) that in
> mainline kernel only MPC8569 board has a correct m25p
> node, and it is STMicro variant (it is JEDEC capable).
>
> As we don't really have to support out of tree code, I'd
> just go with this patch, assuming that we have to change
> device tree for boards with non-JEDEC flashes. It's
> effectively the same thing as platform data flag, except
> that it works automatically for OF platforms.
>
> Signed-off-by: Anton Vorontsov <avorontsov@mvista.com>
> ---
>
> diff --git a/drivers/mtd/devices/m25p80.c b/drivers/mtd/devices/m25p80.c
> index 81e49a9..a610ca9 100644
> --- a/drivers/mtd/devices/m25p80.c
> +++ b/drivers/mtd/devices/m25p80.c
> @@ -680,6 +680,16 @@ static const struct spi_device_id m25p_ids[] = {
>        { "m25p64",  INFO(0x202017,  0,  64 * 1024, 128, 0) },
>        { "m25p128", INFO(0x202018,  0, 256 * 1024,  64, 0) },
>
> +       { "m25p05-nonjedec",  INFO(0, 0,  32 * 1024,   2, 0) },
> +       { "m25p10-nonjedec",  INFO(0, 0,  32 * 1024,   4, 0) },
> +       { "m25p20-nonjedec",  INFO(0, 0,  64 * 1024,   4, 0) },
> +       { "m25p40-nonjedec",  INFO(0, 0,  64 * 1024,   8, 0) },
> +       { "m25p80-nonjedec",  INFO(0, 0,  64 * 1024,  16, 0) },
> +       { "m25p16-nonjedec",  INFO(0, 0,  64 * 1024,  32, 0) },
> +       { "m25p32-nonjedec",  INFO(0, 0,  64 * 1024,  64, 0) },
> +       { "m25p64-nonjedec",  INFO(0, 0,  64 * 1024, 128, 0) },
> +       { "m25p128-nonjedec", INFO(0, 0, 256 * 1024,  64, 0) },
> +
>        { "m45pe10", INFO(0x204011,  0, 64 * 1024,    2, 0) },
>        { "m45pe80", INFO(0x204014,  0, 64 * 1024,   16, 0) },
>        { "m45pe16", INFO(0x204015,  0, 64 * 1024,   32, 0) },
> @@ -795,8 +805,7 @@ static int __devinit m25p_probe(struct spi_device *spi)
>
>                jid = jedec_probe(spi);
>                if (!jid) {
> -                       dev_info(&spi->dev, "non-JEDEC variant of %s\n",
> -                                id->name);
> +                       return -ENODEV;
The patch looks good to me. Only problem is NULL is also returned by
spi_write_then_read() fail:
static const struct spi_device_id *__devinit jedec_probe(struct spi_device *spi)
{
        int                     tmp;
        u8                      code = OPCODE_RDID;
        u8                      id[5];
        u32                     jedec;
        u16                     ext_jedec;
        struct flash_info       *info;

        /* JEDEC also defines an optional "extended device information"
         * string for after vendor-specific data, after the three bytes
         * we use here.  Supporting some chips might require using it.
         */
        tmp = spi_write_then_read(spi, &code, 1, id, 5);
        if (tmp < 0) {
                DEBUG(MTD_DEBUG_LEVEL0, "%s: error %d reading JEDEC ID\n",
                        dev_name(&spi->dev), tmp);
                return NULL;
        }
...
}

Here much better for -EIO (return tmp)?

>                } else if (jid != id) {
>                        /*
>                         * JEDEC knows better, so overwrite platform ID. We
>
