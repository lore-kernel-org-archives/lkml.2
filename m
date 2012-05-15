Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964955Ab2EODPF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 23:15:05 -0400
Received: from na3sys009aog105.obsmtp.com ([74.125.149.75]:37723 "EHLO
	na3sys009aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751079Ab2EODPD convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 23:15:03 -0400
From: Yong Ding <yongd@marvell.com>
To: Ulf Hansson <ulf.hansson@stericsson.com>
CC: "cjb@laptop.org" <cjb@laptop.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "stefan.xk.nilsson@stericsson.com" <stefan.xk.nilsson@stericsson.com>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "svenkatr@ti.com" <svenkatr@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 14 May 2012 20:14:35 -0700
Subject: RE: [PATCH] mmc:sdio:retry CMD52/53 when error happens
Thread-Topic: [PATCH] mmc:sdio:retry CMD52/53 when error happens
Thread-Index: Ac0x0T49+NCnF7frQ3qc9b6uuWjw6gAbi80g
Message-ID: <89813612683626448B837EE5A0B6A7CB1A2B9F19B7@SC-VEXCH4.marvell.com>
References: <1336984792-13956-1-git-send-email-yongd@marvell.com>
 <4FB10156.2080900@stericsson.com>
In-Reply-To: <4FB10156.2080900@stericsson.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: zh-CN, en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ulf Hansson,
Thanks for your comments.

Such retry mechanism is a simple CMD-level or sdio-core-level retry which takes advantage of the mmc core internal retry. There is not any side effect, but with it, even those SDIO function driver's without its own retrying mechanism can benefit in some conditions.

Besides, for CMD52, it can be used during SDIO card initialization/detection phase. At that time, SDIO function driver hasn't started to work. Of course we can probably encounter CMD52 error due to some reasons(eg, board-level schematic bad behavior), and such retry can be a potential workaround. Actually, we've encountered exactly such case in our development.


Best Wishes,

Yong Ding
Operating Systems Engineering,
Application Processor Systems Engineering

-----Original Message-----
From: Ulf Hansson [mailto:ulf.hansson@stericsson.com] 
Sent: Monday, May 14, 2012 8:58 PM
To: Yong Ding
Cc: cjb@laptop.org; linux-mmc@vger.kernel.org; stefan.xk.nilsson@stericsson.com; linus.walleij@linaro.org; svenkatr@ti.com; linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mmc:sdio:retry CMD52/53 when error happens

Hi Yongd,

 From my perspective I don't think this patch is wanted.

A retry mechanism is likely very much hw-SDIO device dependent. Upper 
layers (SDIO func driver) is thus the only software that is able to 
handle retries correctly.

Kind regards
Ulf Hansson


On 05/14/2012 10:39 AM, yongd wrote:
>    Set sdio CMD52/53's retry time as MMC_CMD_RETRIES. As a result,
> sdio might benefit from core-internal CMD retry mechanism when
> some errors happen(CRC, etc).
>
> Signed-off-by: yongd<yongd@marvell.com>
> ---
>   drivers/mmc/core/sdio_ops.c |    3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/mmc/core/sdio_ops.c b/drivers/mmc/core/sdio_ops.c
> index d29e206..884c27e 100644
> --- a/drivers/mmc/core/sdio_ops.c
> +++ b/drivers/mmc/core/sdio_ops.c
> @@ -86,7 +86,7 @@ static int mmc_io_rw_direct_host(struct mmc_host *host, int write, unsigned fn,
>   	cmd.arg |= in;
>   	cmd.flags = MMC_RSP_SPI_R5 | MMC_RSP_R5 | MMC_CMD_AC;
>
> -	err = mmc_wait_for_cmd(host,&cmd, 0);
> +	err = mmc_wait_for_cmd(host,&cmd, MMC_CMD_RETRIES);
>   	if (err)
>   		return err;
>
> @@ -147,6 +147,7 @@ int mmc_io_rw_extended(struct mmc_card *card, int write, unsigned fn,
>   	else
>   		cmd.arg |= 0x08000000 | blocks;		/* block mode */
>   	cmd.flags = MMC_RSP_SPI_R5 | MMC_RSP_R5 | MMC_CMD_ADTC;
> +	cmd.retries = MMC_CMD_RETRIES;
>
>   	data.blksz = blksz;
>   	/* Code in host drivers/fwk assumes that "blocks" always is>=1 */

