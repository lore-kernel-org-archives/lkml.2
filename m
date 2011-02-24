Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756069Ab1BXOSZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 09:18:25 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:61342 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755452Ab1BXOSV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 09:18:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=QCiJpIj7Ef65pj+KnsjwAMgePC7rf82+KDQbRv2qSHo7QaDOYpGFXSymEQEzxaO13A
         qM/Yyqj+Tu9xufWQM6HOsE0P2wGclEa25EKVMjjy0EoaQRYNCZr3X5RUSk5kQAz2yt+3
         7+LFPgwKuuoBpQ85mCM7EWjwOes6Ruew1Mpu4=
MIME-Version: 1.0
In-Reply-To: <20110224111935.GB7169@intel.com>
References: <20110224111935.GB7169@intel.com>
Date: Thu, 24 Feb 2011 23:18:19 +0900
Message-ID: <AANLkTinJEXc_x36Rht=XfYEtjShAYKWRDcsjGFtd=5Tj@mail.gmail.com>
Subject: Re: [PATCH 1/1]mmc: set timeout for SDHCI host before sending busy cmd
From: Jae hoon Chung <jh80.chung@gmail.com>
To: Chuanxiao Dong <chuanxiao.dong@intel.com>
Cc: linux-mmc@vger.kernel.org, cjb@laptop.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de, Kyungmin Park <kyungmin.park@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

This patch looks like this. I sent to the RFC patch..

http://marc.info/?l=linux-mmc&m=129109794815028&w=3

Signed-off-by: Jaehoon Chung <jh80.chung@samsung.com>
 Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>

---
 drivers/mmc/host/sdhci.c  |    6 +++++-
 include/linux/mmc/sdhci.h |    3 ++-
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
index 782c0ee..3b93d97 100644
--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -655,8 +655,12 @@ static void sdhci_prepare_data(struct sdhci_host
*host, struct mmc_data *data)

       WARN_ON(host->data);

-       if (data == NULL)
+       if (data == NULL) {
+               if ((host->quirks & SDHCI_QUIRK_SET_DATA_TIMEOUT_VAL) &&
+                               (host->cmd->flags & MMC_RSP_BUSY))
+                       sdhci_writel(host, 0xE, SDHCI_TIMEOUT_CONTROL);
               return;
+       }

       /* Sanity checks */
       BUG_ON(data->blksz * data->blocks > 524288);
diff --git a/include/linux/mmc/sdhci.h b/include/linux/mmc/sdhci.h
index 1fdc673..315ff49 100644
--- a/include/linux/mmc/sdhci.h
+++ b/include/linux/mmc/sdhci.h
@@ -83,7 +83,8 @@ struct sdhci_host {
 #define SDHCI_QUIRK_MULTIBLOCK_READ_ACMD12             (1<<28)
 /* Controller doesn't have HISPD bit field in HI-SPEED SD card */
 #define SDHCI_QUIRK_NO_HISPD_BIT                       (1<<29)
-
+/* Controller need set data timeout value when card is busy */
+#define SDHCI_QUIRK_SET_DATA_TIMEOUT_VAL               (1<<30)
       int irq;                /* Device IRQ */
       void __iomem *ioaddr;   /* Mapped address */

--
1.6.0.4

2011/2/24 Chuanxiao Dong <chuanxiao.dong@intel.com>:
> Set the timeout control register for SDHCI host when it needs to send some
> commands which need busy signal. Use the maximum timeout value will be safe.
>
> Signed-off-by: Chuanxiao Dong <chuanxiao.dong@intel.com>
> ---
>  drivers/mmc/host/sdhci.c |   14 ++++++++++----
>  1 files changed, 10 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
> index 9e15f41..32b7475 100644
> --- a/drivers/mmc/host/sdhci.c
> +++ b/drivers/mmc/host/sdhci.c
> @@ -40,7 +40,6 @@
>
>  static unsigned int debug_quirks = 0;
>
> -static void sdhci_prepare_data(struct sdhci_host *, struct mmc_data *);
>  static void sdhci_finish_data(struct sdhci_host *);
>
>  static void sdhci_send_command(struct sdhci_host *, struct mmc_command *);
> @@ -651,16 +650,23 @@ static void sdhci_set_transfer_irqs(struct sdhci_host *host)
>                sdhci_clear_set_irqs(host, dma_irqs, pio_irqs);
>  }
>
> -static void sdhci_prepare_data(struct sdhci_host *host, struct mmc_data *data)
> +static void sdhci_prepare_data(struct sdhci_host *host, struct mmc_command *cmd)
>  {
>        u8 count;
>        u8 ctrl;
> +       struct mmc_data *data = cmd->data;
>        int ret;
>
>        WARN_ON(host->data);
>
> -       if (data == NULL)
> +       if (data == NULL) {
> +               /*
> +                * set timeout to be maximum value for command with busy signal.
> +                */
> +               if (cmd->flags & MMC_RSP_BUSY)
> +                       sdhci_writeb(host, 0xE, SDHCI_TIMEOUT_CONTROL);
>                return;
> +       }
>
>        /* Sanity checks */
>        BUG_ON(data->blksz * data->blocks > 524288);
> @@ -920,7 +926,7 @@ static void sdhci_send_command(struct sdhci_host *host, struct mmc_command *cmd)
>
>        host->cmd = cmd;
>
> -       sdhci_prepare_data(host, cmd->data);
> +       sdhci_prepare_data(host, cmd);
>
>        sdhci_writel(host, cmd->arg, SDHCI_ARGUMENT);
>
> --
> 1.6.6.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-mmc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
