Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933052Ab2IFSfi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 14:35:38 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:15926 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932373Ab2IFSfh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 14:35:37 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Thu, 06 Sep 2012 11:34:50 -0700
Message-ID: <5048ECF2.8050307@nvidia.com>
Date: Thu, 6 Sep 2012 14:35:30 -0400
From: Rhyland Klein <rklein@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Olof Johansson <olof@lixom.net>
CC: Anton Vorontsov <cbou@mail.ru>, David Woodhouse <dwmw2@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sbs-battery: probe should try talking to the device
References: <1346956349-21980-1-git-send-email-olof@lixom.net>
In-Reply-To: <1346956349-21980-1-git-send-email-olof@lixom.net>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/06/2012 02:32 PM, Olof Johansson wrote:
> Turns out this driver doesn't actually try talking to the device at
> probe time, so if it's incorrectly configured in the device tree or
> platform data (or if the battery has been removed from the system), then
> probe will succeed and every access will sit there and time out. The
> end result is a possibly laggy system that thinks it has a battery but
> can never read status, which isn't very useful.
>
> Instead, just read any register (I chose status) at probe, and if that
> fails, don't register the device.
>
> Signed-off-by: Olof Johansson <olof@lixom.net>
> ---
>   drivers/power/sbs-battery.c | 10 ++++++++++
>   1 file changed, 10 insertions(+)
>
> diff --git a/drivers/power/sbs-battery.c b/drivers/power/sbs-battery.c
> index a65e8f5..2f24253 100644
> --- a/drivers/power/sbs-battery.c
> +++ b/drivers/power/sbs-battery.c
> @@ -760,6 +760,16 @@ static int __devinit sbs_probe(struct i2c_client *client,
>
>   skip_gpio:
>
> +	/* Before we register, we need to make sure we can actually talk
> +	 * to the battery.
> +	 */
> +	rc = sbs_read_word_data(client, sbs_data[REG_STATUS].addr);
> +	if (rc < 0) {
> +		dev_err(&client->dev, "%s: Failed to get device status\n",
> +			__func__);
> +		goto exit_psupply;
> +	}
> +
>   	rc = power_supply_register(&client->dev, &chip->power_supply);
>   	if (rc) {
>   		dev_err(&client->dev,
>

Acked-by: Rhyland Klein <rklein@nvidia.com>

-- 
nvpublic
