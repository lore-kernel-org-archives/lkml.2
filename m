Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755494Ab2K2Cqt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 21:46:49 -0500
Received: from mail-oa0-f46.google.com ([209.85.219.46]:58428 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755157Ab2K2Cqs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 21:46:48 -0500
MIME-Version: 1.0
In-Reply-To: <20121128200854.GH31879@valkosipuli.retiisi.org.uk>
References: <1354100134-21095-1-git-send-email-prabhakar.lad@ti.com>
 <1354100134-21095-2-git-send-email-prabhakar.lad@ti.com> <20121128200854.GH31879@valkosipuli.retiisi.org.uk>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Thu, 29 Nov 2012 08:16:27 +0530
Message-ID: <CA+V-a8v9+6BVMF-LgDa_zif1+GPjt8O=Y0OH98RqPhkW8pxPUw@mail.gmail.com>
Subject: Re: [PATCH v3 1/3] davinci: vpss: dm365: enable ISP registers
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: LMML <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        Manjunath Hadli <manjunath.hadli@ti.com>,
        Prabhakar Lad <prabhakar.lad@ti.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hans.verkuil@cisco.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sakari,

Thanks for the quick review.

On Thu, Nov 29, 2012 at 1:38 AM, Sakari Ailus <sakari.ailus@iki.fi> wrote:
> On Wed, Nov 28, 2012 at 04:25:32PM +0530, Prabhakar Lad wrote:
>> From: Manjunath Hadli <manjunath.hadli@ti.com>
>>
>> enable PPCR, enbale ISIF out on BCR and disable all events to
>> get the correct operation from ISIF.
>>
>> Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
>> Signed-off-by: Lad, Prabhakar <prabhakar.lad@ti.com>
>> ---
>>  drivers/media/platform/davinci/vpss.c |   13 +++++++++++++
>>  1 files changed, 13 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/media/platform/davinci/vpss.c b/drivers/media/platform/davinci/vpss.c
>> index 146e4b0..34ad7bd 100644
>> --- a/drivers/media/platform/davinci/vpss.c
>> +++ b/drivers/media/platform/davinci/vpss.c
>> @@ -52,9 +52,11 @@ MODULE_AUTHOR("Texas Instruments");
>>  #define DM355_VPSSBL_EVTSEL_DEFAULT  0x4
>>
>>  #define DM365_ISP5_PCCR              0x04
>> +#define DM365_ISP5_BCR                       0x08
>>  #define DM365_ISP5_INTSEL1           0x10
>>  #define DM365_ISP5_INTSEL2           0x14
>>  #define DM365_ISP5_INTSEL3           0x18
>> +#define DM365_ISP5_EVTSEL            0x1c
>>  #define DM365_ISP5_CCDCMUX           0x20
>>  #define DM365_ISP5_PG_FRAME_SIZE     0x28
>>  #define DM365_VPBE_CLK_CTRL          0x00
>> @@ -357,6 +359,10 @@ void dm365_vpss_set_pg_frame_size(struct vpss_pg_frame_size frame_size)
>>  }
>>  EXPORT_SYMBOL(dm365_vpss_set_pg_frame_size);
>>
>> +#define DM365_ISP5_EVTSEL_EVT_DISABLE        0x00000000
>> +#define DM365_ISP5_BCR_ISIF_OUT_ENABLE       0x00000002
>> +#define DM365_ISP5_PCCR_CLK_ENABLE   0x0000007f
>> +
>
> How about defining these next to the register definitions themselves? There
> also seems to be one EVTSEL bit defined in the beginning of the first chunk.
> Please group these.
>
Ok I'll move them to the top. These are bit definitions, maybe using BIT()
could be better ?

> For that matter --- IMO you could just write zero to the register, without
> defining it a name, if the purpose of the register is to select something
> based on bits that are set.
>
Ok.

>>  static int __devinit vpss_probe(struct platform_device *pdev)
>>  {
>>       struct resource         *r1, *r2;
>> @@ -426,9 +432,16 @@ static int __devinit vpss_probe(struct platform_device *pdev)
>>               oper_cfg.hw_ops.enable_clock = dm365_enable_clock;
>>               oper_cfg.hw_ops.select_ccdc_source = dm365_select_ccdc_source;
>>               /* Setup vpss interrupts */
>> +             isp5_write((isp5_read(DM365_ISP5_PCCR) |
>> +                             DM365_ISP5_PCCR_CLK_ENABLE), DM365_ISP5_PCCR);
>> +             isp5_write((isp5_read(DM365_ISP5_BCR) |
>> +                          DM365_ISP5_BCR_ISIF_OUT_ENABLE), DM365_ISP5_BCR);
>>               isp5_write(DM365_ISP5_INTSEL1_DEFAULT, DM365_ISP5_INTSEL1);
>>               isp5_write(DM365_ISP5_INTSEL2_DEFAULT, DM365_ISP5_INTSEL2);
>>               isp5_write(DM365_ISP5_INTSEL3_DEFAULT, DM365_ISP5_INTSEL3);
>> +             /* No event selected */
>> +             isp5_write((isp5_read(DM365_ISP5_EVTSEL) |
>> +                     DM365_ISP5_EVTSEL_EVT_DISABLE), DM365_ISP5_EVTSEL);
>
> What's this? You're reading the value of the register, orring that with zero
> and writing it back? :-)
>
My Bad I'll remove it.

Regards,
--Prabhakar

>>       } else
>>               oper_cfg.hw_ops.clear_wbl_overflow = dm644x_clear_wbl_overflow;
>>
>
> --
> Regards,
>
> Sakari Ailus
> e-mail: sakari.ailus@iki.fi     XMPP: sailus@retiisi.org.uk
