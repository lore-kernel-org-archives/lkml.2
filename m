Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760439Ab0LOED5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 23:03:57 -0500
Received: from mail-fx0-f43.google.com ([209.85.161.43]:56644 "EHLO
	mail-fx0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759204Ab0LOEDp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 23:03:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=u3wMCxvXldRHywRb/lAgqueuqUHiyzQP70cDzsUcVAbH2OP7c551JITqj1ExCkJp+H
         LD/KN0zmWFHzrlJ3aoQdkYeia6e+YZBpMmY0j9FQrJOSO/jZ2czi149FqVRs0kfnK+7w
         2k8+7Oeiqxkrb083akvQqqDi0GOYH6UkK8d+0=
MIME-Version: 1.0
In-Reply-To: <1290579674-4616-3-git-send-email-tiwai@suse.de>
References: <1290579674-4616-1-git-send-email-tiwai@suse.de>
	<1290579674-4616-3-git-send-email-tiwai@suse.de>
Date: Tue, 14 Dec 2010 23:03:42 -0500
Message-ID: <AANLkTinTNp_tyFJV2ef3iU4i6X=ebNsNzrAqvXJepaFi@mail.gmail.com>
Subject: Re: [PATCH 2/2] mmc: Test bus-width for old MMC devices
From: zhangfei gao <zhangfei.gao@gmail.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: Chris Ball <cjb@laptop.org>, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Aries Lee <arieslee@jmicron.com>,
        wuqm@marvell.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 24, 2010 at 1:21 AM, Takashi Iwai <tiwai@suse.de> wrote:
> From: Aries Lee <arieslee@jmicron.com>
>
> Some old MMC devices fail with the 4/8 bits the driver tries to use
> exclusively.  This patch adds a test for the given bus setup and falls
> back to the lower bit mode (until 1-bit mode) when the test fails.
>
> [Major rework and refactoring by tiwai]
>
> Signed-off-by: Aries Lee <arieslee@jmicron.com>
> Signed-off-by: Takashi Iwai <tiwai@suse.de>
> ---
>  drivers/mmc/core/mmc.c     |   49 ++++++++++++---------
>  drivers/mmc/core/mmc_ops.c |  102 ++++++++++++++++++++++++++++++++++++++++++++
>  drivers/mmc/core/mmc_ops.h |    1 +
>  3 files changed, 131 insertions(+), 21 deletions(-)
>
> diff --git a/drivers/mmc/core/mmc.c b/drivers/mmc/core/mmc.c
> index e81e6fe..5d8b4b2 100644
> --- a/drivers/mmc/core/mmc.c
> +++ b/drivers/mmc/core/mmc.c
> @@ -507,29 +507,36 @@ static int mmc_init_card(struct mmc_host *host, u32 ocr,
>         */
>        if ((card->csd.mmca_vsn >= CSD_SPEC_VER_4) &&
>            (host->caps & (MMC_CAP_4_BIT_DATA | MMC_CAP_8_BIT_DATA))) {
> -               unsigned ext_csd_bit, bus_width;
> -
> -               if (host->caps & MMC_CAP_8_BIT_DATA) {
> -                       ext_csd_bit = EXT_CSD_BUS_WIDTH_8;
> -                       bus_width = MMC_BUS_WIDTH_8;
> -               } else {
> -                       ext_csd_bit = EXT_CSD_BUS_WIDTH_4;
> -                       bus_width = MMC_BUS_WIDTH_4;
> +               static unsigned ext_csd_bits[] = {
> +                       EXT_CSD_BUS_WIDTH_8,
> +                       EXT_CSD_BUS_WIDTH_4,
> +                       EXT_CSD_BUS_WIDTH_1
> +               };
> +               static unsigned bus_widths[] = {
> +                       MMC_BUS_WIDTH_8,
> +                       MMC_BUS_WIDTH_4,
> +                       MMC_BUS_WIDTH_1
> +               };
> +               unsigned idx;
> +
> +               if (host->caps & MMC_CAP_8_BIT_DATA)
> +                       idx = 0;
> +               else
> +                       idx = 1;
> +               for (; idx < ARRAY_SIZE(bus_widths); idx++) {
> +                       err = mmc_switch(card, EXT_CSD_CMD_SET_NORMAL,
> +                                        EXT_CSD_BUS_WIDTH, ext_csd_bits[idx]);
> +                       if (!err) {
> +                               mmc_set_bus_width(card->host, bus_widths[idx]);
> +                               err = mmc_bus_test(card, bus_widths[idx]);
> +                               if (!err)
> +                                       break;
> +                       }
>                }
> -
> -               err = mmc_switch(card, EXT_CSD_CMD_SET_NORMAL,
> -                                EXT_CSD_BUS_WIDTH, ext_csd_bit);
> -
> -               if (err && err != -EBADMSG)
> -                       goto free_card;
> -
>                if (err) {
> -                       printk(KERN_WARNING "%s: switch to bus width %d "
> -                              "failed\n", mmc_hostname(card->host),
> -                              1 << bus_width);
> -                       err = 0;
> -               } else {
> -                       mmc_set_bus_width(card->host, bus_width);
> +                       printk(KERN_WARNING "%s: switch to bus width failed\n",
> +                              mmc_hostname(card->host));
> +                       goto free_card;
>                }
>        }
>
> diff --git a/drivers/mmc/core/mmc_ops.c b/drivers/mmc/core/mmc_ops.c
> index 326447c..f8f47f9 100644
> --- a/drivers/mmc/core/mmc_ops.c
> +++ b/drivers/mmc/core/mmc_ops.c
> @@ -462,3 +462,105 @@ int mmc_send_status(struct mmc_card *card, u32 *status)
>        return 0;
>  }
>
> +#define MMC_CMD_BUS_TEST_W             19
> +#define MMC_CMD_BUS_TEST_R             14
> +
> +static int
> +mmc_send_bus_test(struct mmc_card *card, struct mmc_host *host, u8 opcode,
> +                 u8 len)
> +{
> +       struct mmc_request mrq;
> +       struct mmc_command cmd;
> +       struct mmc_data data;
> +       struct scatterlist sg;
> +       u8 *data_buf;
> +       u8 *test_buf;
> +       int i, err;
> +       static u8 testdata_8bit[8] = { 0x55, 0xaa, 0, 0, 0, 0, 0, 0 };
> +       static u8 testdata_4bit[4] = { 0x5a, 0, 0, 0 };
> +
> +       /* dma onto stack is unsafe/nonportable, but callers to this
> +        * routine normally provide temporary on-stack buffers ...
> +        */
> +       data_buf = kmalloc(len, GFP_KERNEL);
> +       if (!data_buf)
> +               return -ENOMEM;
> +
> +       if (len == 8)
> +               test_buf = testdata_8bit;
> +       else if (len == 4)
> +               test_buf = testdata_4bit;
> +       else {
> +               printk(KERN_ERR "%s: Invaild bus_width %d\n",
> +                      mmc_hostname(host), len);
> +               return -EINVAL;
> +       }
> +
> +       if (opcode == MMC_CMD_BUS_TEST_W)
> +               memcpy(data_buf, test_buf, len);
> +
> +       memset(&mrq, 0, sizeof(struct mmc_request));
> +       memset(&cmd, 0, sizeof(struct mmc_command));
> +       memset(&data, 0, sizeof(struct mmc_data));
> +
> +       mrq.cmd = &cmd;
> +       mrq.data = &data;
> +       cmd.opcode = opcode;
> +       cmd.arg = 0;
> +
> +       /* NOTE HACK:  the MMC_RSP_SPI_R1 is always correct here, but we
> +        * rely on callers to never use this with "native" calls for reading
> +        * CSD or CID.  Native versions of those commands use the R2 type,
> +        * not R1 plus a data block.
> +        */
> +       cmd.flags = MMC_RSP_SPI_R1 | MMC_RSP_R1 | MMC_CMD_ADTC;
> +
> +       data.blksz = len;
> +       data.blocks = 1;
> +       if (opcode == MMC_CMD_BUS_TEST_R)
> +               data.flags = MMC_DATA_READ;
> +       else
> +               data.flags = MMC_DATA_WRITE;
> +
> +       data.sg = &sg;
> +       data.sg_len = 1;
> +       sg_init_one(&sg, data_buf, len);
> +       mmc_wait_for_req(host, &mrq);
> +       err = 0;
> +       if (opcode == MMC_CMD_BUS_TEST_R) {
> +               for (i = 0; i < len / 4; i++)
> +                       if ((test_buf[i] ^ data_buf[i]) != 0xff) {
> +                               err = -EIO;
> +                               break;
> +                       }
> +       }
> +       kfree(data_buf);
> +
> +       if (cmd.error)
> +               return cmd.error;
> +       if (data.error)

	if (data.error && (data.error != -EILSEQ))
Could you add code here to ignore CRC error of CMD14.
According to spec, CRC bits from card are optional in CMD14, and it is
ignored by host.
However some host still check and may get crc error here if card does not send.

> +               return data.error;
> +
> +       return err;
> +}
> +
> +int mmc_bus_test(struct mmc_card *card, u8 bus_width)
> +{
> +       int err, width;
> +
> +       if (bus_width == MMC_BUS_WIDTH_8)
> +               width = 8;
> +       else if (bus_width == MMC_BUS_WIDTH_4)
> +               width = 4;
> +       else if (bus_width == MMC_BUS_WIDTH_1)
> +               return 0; /* no need for test */
> +       else
> +               return -EINVAL;
> +       err = mmc_send_bus_test(card, card->host, MMC_CMD_BUS_TEST_W, width);
> +       if (err < 0)
> +               return err;
> +       err = mmc_send_bus_test(card, card->host, MMC_CMD_BUS_TEST_R, width);
> +       return err;
> +
> +
> +}
> diff --git a/drivers/mmc/core/mmc_ops.h b/drivers/mmc/core/mmc_ops.h
> index 653eb8e..e6d44b8 100644
> --- a/drivers/mmc/core/mmc_ops.h
> +++ b/drivers/mmc/core/mmc_ops.h
> @@ -26,6 +26,7 @@ int mmc_send_cid(struct mmc_host *host, u32 *cid);
>  int mmc_spi_read_ocr(struct mmc_host *host, int highcap, u32 *ocrp);
>  int mmc_spi_set_crc(struct mmc_host *host, int use_crc);
>  int mmc_card_sleepawake(struct mmc_host *host, int sleep);
> +int mmc_bus_test(struct mmc_card *card, u8 bus_width);
>
>  #endif
>
> --
> 1.7.3.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-mmc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
