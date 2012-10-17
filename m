Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756062Ab2JQCGv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 22:06:51 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:36314 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755942Ab2JQCGu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 22:06:50 -0400
X-AuditID: cbfee61b-b7fd46d0000046e0-5d-507e12b8ad13
Message-id: <507E129D.8000401@samsung.com>
Date: Wed, 17 Oct 2012 11:06:21 +0900
From: Jaehoon Chung <jh80.chung@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:15.0) Gecko/20120827
 Thunderbird/15.0
MIME-version: 1.0
To: James Hogan <james.hogan@imgtec.com>
Cc: Chris Ball <cjb@laptop.org>, Will Newton <will.newton@imgtec.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        Seungwon Jeon <tgih.jun@samsung.com>, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dw_mmc: fix multiple drv_data NULL dereferences
References: <1350376988-27477-1-git-send-email-james.hogan@imgtec.com>
In-reply-to: <1350376988-27477-1-git-send-email-james.hogan@imgtec.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrPLMWRmVeSWpSXmKPExsVy+t9jQd0dQnUBBivXSllc3jWHzeLI/35G
	ByaPz5vkAhijuGxSUnMyy1KL9O0SuDKurQ8vmK9V0fNvAWMDY59SFyMnh4SAicSsE68ZIWwx
	iQv31rN1MXJxCAlMZ5RYsv0CO4TzklFi2b/XbCBVvAJaEtM3zwSzWQRUJXp79oPZbAI6Etu/
	HWcCsUUFQiSWzP3KDlEvKPFj8j0WEFtEQENizaVeJpChzAL/GCX67x8HKxIWcJE41LKaGcQW
	EnCTWHnoJ9hQTgF3iaadN8CGMgMt2N86jQ3ClpfYvOYt8wRGgVlIdsxCUjYLSdkCRuZVjKKp
	BckFxUnpuUZ6xYm5xaV56XrJ+bmbGMHB+Ex6B+OqBotDjAIcjEo8vAFLawOEWBPLiitzDzFK
	cDArifCaNwKFeFMSK6tSi/Lji0pzUosPMUpzsCiJ8zZ7pAQICaQnlqRmp6YWpBbBZJk4OKUa
	GLkPveexCp7eNHV/2byTk4WO5zi8u7I9/ldShINxVuvu2isr3u5q/rHouUOHNO+ak5xnfPps
	5/25EbjOyECep3v3zcSr157OiF0658S914k71TVm3N24sMswabGfU+2lOCODD39XsEnsqGdx
	mCpb7LfSP9zojLTQqpUJabz8XjlOWzMso3m87iqxFGckGmoxFxUnAgD+kbRgQgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looks good to me.

Acked-by: Jaehoon Chung <jh80.chung@samsung.com>

On 10/16/2012 05:43 PM, James Hogan wrote:
> Commit 800d78bfccb3d38116abfda2a5b9c8afdbd5ea21 ("mmc: dw_mmc: add
> support for implementation specific callbacks") merged in v3.7-rc1.
> 
> The above commit introduced multiple NULL pointer dereferences when
> the default dw_mci_pltfm_probe() is used, as it sets host->drv_data to
> NULL, and that's only checked against NULL in 1 out of the 7 cases where
> it is dereferenced.
> 
> Signed-off-by: James Hogan <james.hogan@imgtec.com>
> ---
>  drivers/mmc/host/dw_mmc-pltfm.c |    4 ++--
>  drivers/mmc/host/dw_mmc.c       |   29 +++++++++++++++++------------
>  2 files changed, 19 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/mmc/host/dw_mmc-pltfm.c b/drivers/mmc/host/dw_mmc-pltfm.c
> index c960ca7..e595721 100644
> --- a/drivers/mmc/host/dw_mmc-pltfm.c
> +++ b/drivers/mmc/host/dw_mmc-pltfm.c
> @@ -50,8 +50,8 @@ int dw_mci_pltfm_register(struct platform_device *pdev,
>  	if (!host->regs)
>  		return -ENOMEM;
>  
> -	if (host->drv_data->init) {
> -		ret = host->drv_data->init(host);
> +	if (drv_data && drv_data->init) {
> +		ret = drv_data->init(host);
>  		if (ret)
>  			return ret;
>  	}
> diff --git a/drivers/mmc/host/dw_mmc.c b/drivers/mmc/host/dw_mmc.c
> index c2828f3..0dc6e33 100644
> --- a/drivers/mmc/host/dw_mmc.c
> +++ b/drivers/mmc/host/dw_mmc.c
> @@ -232,6 +232,7 @@ static u32 dw_mci_prepare_command(struct mmc_host *mmc, struct mmc_command *cmd)
>  {
>  	struct mmc_data	*data;
>  	struct dw_mci_slot *slot = mmc_priv(mmc);
> +	struct dw_mci_drv_data *drv_data = slot->host->drv_data;
>  	u32 cmdr;
>  	cmd->error = -EINPROGRESS;
>  
> @@ -261,8 +262,8 @@ static u32 dw_mci_prepare_command(struct mmc_host *mmc, struct mmc_command *cmd)
>  			cmdr |= SDMMC_CMD_DAT_WR;
>  	}
>  
> -	if (slot->host->drv_data->prepare_command)
> -		slot->host->drv_data->prepare_command(slot->host, &cmdr);
> +	if (drv_data && drv_data->prepare_command)
> +		drv_data->prepare_command(slot->host, &cmdr);
>  
>  	return cmdr;
>  }
> @@ -772,6 +773,7 @@ static void dw_mci_request(struct mmc_host *mmc, struct mmc_request *mrq)
>  static void dw_mci_set_ios(struct mmc_host *mmc, struct mmc_ios *ios)
>  {
>  	struct dw_mci_slot *slot = mmc_priv(mmc);
> +	struct dw_mci_drv_data *drv_data = slot->host->drv_data;
>  	u32 regs;
>  
>  	/* set default 1 bit mode */
> @@ -807,8 +809,8 @@ static void dw_mci_set_ios(struct mmc_host *mmc, struct mmc_ios *ios)
>  		slot->clock = ios->clock;
>  	}
>  
> -	if (slot->host->drv_data->set_ios)
> -		slot->host->drv_data->set_ios(slot->host, ios);
> +	if (drv_data && drv_data->set_ios)
> +		drv_data->set_ios(slot->host, ios);
>  
>  	switch (ios->power_mode) {
>  	case MMC_POWER_UP:
> @@ -1815,6 +1817,7 @@ static int dw_mci_init_slot(struct dw_mci *host, unsigned int id)
>  {
>  	struct mmc_host *mmc;
>  	struct dw_mci_slot *slot;
> +	struct dw_mci_drv_data *drv_data = host->drv_data;
>  	int ctrl_id, ret;
>  	u8 bus_width;
>  
> @@ -1854,8 +1857,8 @@ static int dw_mci_init_slot(struct dw_mci *host, unsigned int id)
>  	} else {
>  		ctrl_id = to_platform_device(host->dev)->id;
>  	}
> -	if (host->drv_data && host->drv_data->caps)
> -		mmc->caps |= host->drv_data->caps[ctrl_id];
> +	if (drv_data && drv_data->caps)
> +		mmc->caps |= drv_data->caps[ctrl_id];
>  
>  	if (host->pdata->caps2)
>  		mmc->caps2 = host->pdata->caps2;
> @@ -1867,10 +1870,10 @@ static int dw_mci_init_slot(struct dw_mci *host, unsigned int id)
>  	else
>  		bus_width = 1;
>  
> -	if (host->drv_data->setup_bus) {
> +	if (drv_data && drv_data->setup_bus) {
>  		struct device_node *slot_np;
>  		slot_np = dw_mci_of_find_slot_node(host->dev, slot->id);
> -		ret = host->drv_data->setup_bus(host, slot_np, bus_width);
> +		ret = drv_data->setup_bus(host, slot_np, bus_width);
>  		if (ret)
>  			goto err_setup_bus;
>  	}
> @@ -2035,6 +2038,7 @@ static struct dw_mci_board *dw_mci_parse_dt(struct dw_mci *host)
>  	struct dw_mci_board *pdata;
>  	struct device *dev = host->dev;
>  	struct device_node *np = dev->of_node;
> +	struct dw_mci_drv_data *drv_data = host->drv_data;
>  	int idx, ret;
>  
>  	pdata = devm_kzalloc(dev, sizeof(*pdata), GFP_KERNEL);
> @@ -2062,8 +2066,8 @@ static struct dw_mci_board *dw_mci_parse_dt(struct dw_mci *host)
>  
>  	of_property_read_u32(np, "card-detect-delay", &pdata->detect_delay_ms);
>  
> -	if (host->drv_data->parse_dt) {
> -		ret = host->drv_data->parse_dt(host);
> +	if (drv_data && drv_data->parse_dt) {
> +		ret = drv_data->parse_dt(host);
>  		if (ret)
>  			return ERR_PTR(ret);
>  	}
> @@ -2080,6 +2084,7 @@ static struct dw_mci_board *dw_mci_parse_dt(struct dw_mci *host)
>  
>  int dw_mci_probe(struct dw_mci *host)
>  {
> +	struct dw_mci_drv_data *drv_data = host->drv_data;
>  	int width, i, ret = 0;
>  	u32 fifo_size;
>  	int init_slots = 0;
> @@ -2127,8 +2132,8 @@ int dw_mci_probe(struct dw_mci *host)
>  	else
>  		host->bus_hz = clk_get_rate(host->ciu_clk);
>  
> -	if (host->drv_data->setup_clock) {
> -		ret = host->drv_data->setup_clock(host);
> +	if (drv_data && drv_data->setup_clock) {
> +		ret = drv_data->setup_clock(host);
>  		if (ret) {
>  			dev_err(host->dev,
>  				"implementation specific clock setup failed\n");
> 

