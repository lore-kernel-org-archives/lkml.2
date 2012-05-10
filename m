Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932121Ab2EJKic (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 06:38:32 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:46628 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758870Ab2EJKi3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 06:38:29 -0400
MIME-Version: 1.0
In-Reply-To: <CAH9JG2XBinh=XAVnt3EnWrEqeTKz34d9yB6wfiuF-J-Se_Q__Q@mail.gmail.com>
References: <1335935266-25289-1-git-send-email-thomas.abraham@linaro.org>
	<1335935266-25289-5-git-send-email-thomas.abraham@linaro.org>
	<CAH9JG2XBinh=XAVnt3EnWrEqeTKz34d9yB6wfiuF-J-Se_Q__Q@mail.gmail.com>
Date: Thu, 10 May 2012 16:08:28 +0530
Message-ID: <CAJuYYwT=AyR8aP_6tvi_kUAZ9xWoEpeEszVj0PX4yPeeO8MDOg@mail.gmail.com>
Subject: Re: [PATCH 4/7] mmc: dw_mmc: add samsung exynos5250 specific extentions
From: Thomas Abraham <thomas.abraham@linaro.org>
To: Kyungmin Park <kmpark@infradead.org>
Cc: linux-mmc@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-samsung-soc@vger.kernel.org, patches@linaro.org,
        linux-kernel@vger.kernel.org, rob.herring@calxeda.com,
        grant.likely@secretlab.ca, kgene.kim@samsung.com, cjb@laptop.org,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Mr. Park,

On 2 May 2012 12:31, Kyungmin Park <kmpark@infradead.org> wrote:
> Hi,
>
> On 5/2/12, Thomas Abraham <thomas.abraham@linaro.org> wrote:
>> The instantiation of the Synopsis Designware controller on Exynos5250
>> include extension for SDR and DDR specific tx/rx phase shift timing
>> and CIU internal divider. In addition to that, the option to skip the
>> command hold stage is also introduced. Add support for these Exynos5250
>> specfic extenstions.
>>

[...]

>> +static struct dw_mci_drv_data exynos5250_drv_data = {
>> +     .ctrl_type      = DW_MCI_TYPE_EXYNOS5250,
>> +     .caps           = MMC_CAP_UHS_DDR50 | MMC_CAP_1_8V_DDR |
>> +                             MMC_CAP_8_BIT_DATA | MMC_CAP_CMD23,
> These caps should be board specific. So it's not proper place. Esp.,
> MMC_CAP_8_BIT_DATA.

Yes, this is incorrect. I will fix this. Thanks for pointing this out.

>> +};
>> +
>>  static const struct of_device_id dw_mci_pltfm_match[] = {
>>       { .compatible = "synopsis,dw-mshc",
>>                       .data = (void *)&synopsis_drv_data, },
>> +     { .compatible = "synopsis,dw-mshc-exynos5250",
>> +                     .data = (void *)&exynos5250_drv_data, },
>>       {},
>>  };
>>  MODULE_DEVICE_TABLE(of, dw_mci_pltfm_match);
>> diff --git a/drivers/mmc/host/dw_mmc.c b/drivers/mmc/host/dw_mmc.c
>> index bcf66d7..9174a69 100644
>> --- a/drivers/mmc/host/dw_mmc.c
>> +++ b/drivers/mmc/host/dw_mmc.c
>> @@ -236,6 +236,7 @@ static void dw_mci_set_timeout(struct dw_mci *host)
>>  static u32 dw_mci_prepare_command(struct mmc_host *mmc, struct mmc_command
>> *cmd)
>>  {
>>       struct mmc_data *data;
>> +     struct dw_mci_slot *slot = mmc_priv(mmc);
>>       u32 cmdr;
>>       cmd->error = -EINPROGRESS;
>>
>> @@ -265,6 +266,10 @@ static u32 dw_mci_prepare_command(struct mmc_host *mmc,
>> struct mmc_command *cmd)
>>                       cmdr |= SDMMC_CMD_DAT_WR;
>>       }
>>
>> +     if (slot->host->drv_data->ctrl_type == DW_MCI_TYPE_EXYNOS5250)
>> +             if (SDMMC_CLKSEL_GET_SELCLK_DRV(mci_readl(slot->host, CLKSEL)))
>> +                     cmdr |= SDMMC_USE_HOLD_REG;
> Some other board, custom SOC also can use this HOLD register. So it's
> not EXYNOS5250 specific one. I think we introduce the more generic
> quirks for this instead of SOC specific.

The above code is Exynos5250 specific. The Exynos5250 hardware manual
specifies additional restrictions on when the hold register can be
used. These restrictions are specific to Exynos5250 and hence there is
check for type of the controller.


>> +
>>       return cmdr;
>>  }
>>
>> @@ -787,10 +792,19 @@ static void dw_mci_set_ios(struct mmc_host *mmc,
>> struct mmc_ios *ios)
>>       regs = mci_readl(slot->host, UHS_REG);
>>
>>       /* DDR mode set */
>> -     if (ios->timing == MMC_TIMING_UHS_DDR50)
>> +     if (ios->timing == MMC_TIMING_UHS_DDR50) {
>>               regs |= (0x1 << slot->id) << 16;
>> -     else
>> +             mci_writel(slot->host, CLKSEL, slot->host->ddr_timing);
> As you wrote, does CLKSEL is some SOC specific registers?

Yes, the CLKSEL is a Exynos specific register.


>> +     } else {
>>               regs &= ~(0x1 << slot->id) << 16;
>> +             mci_writel(slot->host, CLKSEL, slot->host->sdr_timing);
>> +     }
>> +
>> +     if (slot->host->drv_data->ctrl_type == DW_MCI_TYPE_EXYNOS5250) {
>> +             slot->host->bus_hz = clk_get_rate(slot->host->ciu_clk);
>> +             slot->host->bus_hz /= SDMMC_CLKSEL_GET_DIVRATIO(
>> +                                     mci_readl(slot->host, CLKSEL));
>> +     }
>>
>>       mci_writel(slot->host, UHS_REG, regs);
>>
>> @@ -2074,6 +2088,20 @@ static struct dw_mci_board *dw_mci_parse_dt(struct
>> dw_mci *host)
>>               if (of_get_property(np, of_quriks[idx].quirk, NULL))
>>                       pdata->quirks |= of_quriks[idx].id;
>>
>> +     if (of_property_read_u32_array(dev->of_node,
>> +                     "samsung,dw-mshc-sdr-timing", timing, 3))
>> +             host->sdr_timing = DW_MCI_DEF_SDR_TIMING;
>> +     else
>> +             host->sdr_timing = SDMMC_CLKSEL_TIMING(timing[0],
>> +                                     timing[1], timing[2]);
>> +
>> +     if (of_property_read_u32_array(dev->of_node,
>> +                     "samsung,dw-mshc-ddr-timing", timing, 3))
>> +             host->ddr_timing = DW_MCI_DEF_DDR_TIMING;
>> +     else
>> +             host->ddr_timing = SDMMC_CLKSEL_TIMING(timing[0],
>> +                                     timing[1], timing[2]);
>> +
>>       if (of_property_read_u32(np, "fifo-depth", &pdata->fifo_depth))
>>               dev_info(dev, "fifo-depth property not found, using "
>>                               "value of FIFOTH register as default\n");
>> diff --git a/drivers/mmc/host/dw_mmc.h b/drivers/mmc/host/dw_mmc.h
>> index 8b8862b..4b7e42b 100644
>> --- a/drivers/mmc/host/dw_mmc.h
>> +++ b/drivers/mmc/host/dw_mmc.h
>> @@ -53,6 +53,7 @@
>>  #define SDMMC_IDINTEN                0x090
>>  #define SDMMC_DSCADDR                0x094
>>  #define SDMMC_BUFADDR                0x098
>> +#define SDMMC_CLKSEL         0x09C /* specific to Samsung Exynos5250 */
> Another Samsung Custom SOC also used it.

Right, it is used in Exynos4 as well. So I will fix the comment accordingly.

Thanks,
Thomas.
