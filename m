Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753388Ab2IGRkJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 13:40:09 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:40308 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751327Ab2IGRkD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 13:40:03 -0400
MIME-Version: 1.0
In-Reply-To: <504A2C7D.1090702@ti.com>
References: <1345471731-31678-1-git-send-email-prabhakar.lad@ti.com>
 <1345471731-31678-3-git-send-email-prabhakar.lad@ti.com> <504A2C7D.1090702@ti.com>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Fri, 7 Sep 2012 23:04:15 +0530
Message-ID: <CA+V-a8sGhrTLJnthX+nZESvJfaHFTV=x06eXjQOwwCZwGBxkPQ@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] ARM: da850/omap-l138: Add EVM specific code for
 VPIF to work
To: Sekhar Nori <nsekhar@ti.com>
Cc: Prabhakar Lad <prabhakar.lad@ti.com>,
        dlos <davinci-linux-open-source@linux.davincidsp.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sekhar,

Thanks for the review.

On Fri, Sep 7, 2012 at 10:48 PM, Sekhar Nori <nsekhar@ti.com> wrote:
> Hi Prabhakar,
>
> On 8/20/2012 7:38 PM, Prabhakar Lad wrote:
>> From: Manjunath Hadli <manjunath.hadli@ti.com>
>>
>> Include the expander settings to select VPIF peripheral on
>> UI card and add registration call in EVM init. Also add platform
>> data to configure display and capture devices.
>>
>> Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
>> Signed-off-by: Lad, Prabhakar <prabhakar.lad@ti.com>
>> Cc: Sekhar Nori <nsekhar@ti.com>
>> ---
>>  arch/arm/mach-davinci/Kconfig           |    9 ++
>>  arch/arm/mach-davinci/board-da850-evm.c |  178 +++++++++++++++++++++++++++++++
>>  2 files changed, 187 insertions(+), 0 deletions(-)
>>
>> diff --git a/arch/arm/mach-davinci/Kconfig b/arch/arm/mach-davinci/Kconfig
>> index ab99c3c..436b47c 100644
>> --- a/arch/arm/mach-davinci/Kconfig
>> +++ b/arch/arm/mach-davinci/Kconfig
>> @@ -186,6 +186,15 @@ config DA850_UI_RMII
>>         NOTE: Please take care while choosing this option, MII PHY will
>>         not be functional if RMII mode is selected.
>>
>> +config DA850_UI_SD_VIDEO_PORT
>> +     bool "Video Port Interface"
>> +     help
>> +       Say Y if you want to use Video Port Interface (VPIF) on the
>> +       DA850/OMAP-L138 EVM. The Video decoders/encoders are found on the
>> +       UI daughter card that is supplied with the EVM.
>
>> +       NOTE: Please make sure to disable RMII and CLCD options when you
>> +       select Video Port Interface.
>
> I thought you agreed to remove this note. CLCD is not present in
> mainline and RMII cannot be selected along with video because of the
> choice. So, the note is basically useless.
>
Ok.

>> +
>>  endchoice
>>
>>  config DA850_WL12XX
>> diff --git a/arch/arm/mach-davinci/board-da850-evm.c b/arch/arm/mach-davinci/board-da850-evm.c
>> index 0149fb4..cdbbced 100644
>> --- a/arch/arm/mach-davinci/board-da850-evm.c
>> +++ b/arch/arm/mach-davinci/board-da850-evm.c
>> @@ -45,6 +45,8 @@
>>  #include <mach/aemif.h>
>>  #include <mach/spi.h>
>>
>> +#include <media/tvp514x.h>
>> +
>>  #define DA850_EVM_PHY_ID             "davinci_mdio-0:00"
>>  #define DA850_LCD_PWR_PIN            GPIO_TO_PIN(2, 8)
>>  #define DA850_LCD_BL_PIN             GPIO_TO_PIN(2, 15)
>> @@ -121,6 +123,12 @@ static struct spi_board_info da850evm_spi_info[] = {
>>       },
>>  };
>>
>> +#define TVP5147_CH0          "tvp514x-0"
>> +#define TVP5147_CH1          "tvp514x-1"
>> +
>> +#define VPIF_STATUS          0x002c
>> +#define VPIF_STATUS_CLR              0x0030
>> +
>>  #ifdef CONFIG_MTD
>>  static void da850_evm_m25p80_notify_add(struct mtd_info *mtd)
>>  {
>> @@ -452,6 +460,15 @@ static void da850_evm_ui_keys_init(unsigned gpio)
>>       }
>>  }
>>
>> +#ifdef CONFIG_DA850_UI_SD_VIDEO_PORT
>> +static inline void da850_evm_setup_video_port(int video_sel)
>> +{
>> +     gpio_set_value_cansleep(video_sel, 0);
>> +}
>> +#else
>> +static inline void da850_evm_setup_video_port(int video_sel) { }
>> +#endif
>> +
>>  static int da850_evm_ui_expander_setup(struct i2c_client *client, unsigned gpio,
>>                                               unsigned ngpio, void *c)
>>  {
>> @@ -497,6 +514,8 @@ static int da850_evm_ui_expander_setup(struct i2c_client *client, unsigned gpio,
>>
>>       da850_evm_setup_emac_rmii(sel_a);
>>
>> +     da850_evm_setup_video_port(sel_c);
>> +
>>       return 0;
>>
>>  exp_setup_keys_fail:
>> @@ -1149,6 +1168,133 @@ static __init int da850_evm_init_cpufreq(void)
>>  static __init int da850_evm_init_cpufreq(void) { return 0; }
>>  #endif
>>
>> +#if defined(CONFIG_DA850_UI_SD_VIDEO_PORT)
>> +
>> +/* VPIF capture configuration */
>> +static struct tvp514x_platform_data tvp5146_pdata = {
>> +     .clk_polarity = 0,
>> +     .hs_polarity = 1,
>> +     .vs_polarity = 1
>
> A ',' needed at the end of above line. It will be nice to line up the
> initialization using tabs too.
>
Ok.

>> +};
>> +
>> +#define TVP514X_STD_ALL (V4L2_STD_NTSC | V4L2_STD_PAL)
>> +
>> +static const struct vpif_input da850_ch0_inputs[] = {
>> +     {
>> +             .input = {
>> +                     .index = 0,
>> +                     .name = "Composite",
>> +                     .type = V4L2_INPUT_TYPE_CAMERA,
>> +                     .std = TVP514X_STD_ALL,
>> +             },
>> +             .subdev_name = TVP5147_CH0,
>> +     },
>> +};
>> +
>> +static const struct vpif_input da850_ch1_inputs[] = {
>> +     {
>> +             .input = {
>> +                     .index = 0,
>> +                     .name = "S-Video",
>> +                     .type = V4L2_INPUT_TYPE_CAMERA,
>> +                     .std = TVP514X_STD_ALL,
>> +             },
>> +             .subdev_name = TVP5147_CH1,
>> +     },
>> +};
>> +#endif
>> +
>> +static struct vpif_subdev_info da850_vpif_capture_sdev_info[] = {
>> +#if defined(CONFIG_DA850_UI_SD_VIDEO_PORT)
>
> You agreed to get rid of these multiple ifdefs but you have not fixed that.
>
I have merged the top one, at later stage when we go  ahead and add sensor
support then we would have require to have define two
da850_vpif_capture_sdev_info
so to avoid it I have kept this one.

>> +     {
>> +             .name   = TVP5147_CH0,
>> +             .board_info = {
>> +                     I2C_BOARD_INFO("tvp5146", 0x5d),
>> +                     .platform_data = &tvp5146_pdata,
>> +             },
>> +             .input = INPUT_CVBS_VI2B,
>> +             .output = OUTPUT_10BIT_422_EMBEDDED_SYNC,
>> +             .can_route = 1,
>> +             .vpif_if = {
>> +                     .if_type = VPIF_IF_BT656,
>> +                     .hd_pol = 1,
>> +                     .vd_pol = 1,
>> +                     .fid_pol = 0,
>> +             },
>> +     },
>> +     {
>> +             .name   = TVP5147_CH1,
>> +             .board_info = {
>> +                     I2C_BOARD_INFO("tvp5146", 0x5c),
>> +                     .platform_data = &tvp5146_pdata,
>> +             },
>> +             .input = INPUT_SVIDEO_VI2C_VI1C,
>> +             .output = OUTPUT_10BIT_422_EMBEDDED_SYNC,
>> +             .can_route = 1,
>> +             .vpif_if = {
>> +                     .if_type = VPIF_IF_BT656,
>> +                     .hd_pol = 1,
>> +                     .vd_pol = 1,
>> +                     .fid_pol = 0,
>> +             },
>> +     },
>> +#endif
>> +};
>> +
>> +static struct vpif_capture_config da850_vpif_capture_config = {
>> +     .subdev_info = da850_vpif_capture_sdev_info,
>> +     .subdev_count = ARRAY_SIZE(da850_vpif_capture_sdev_info),
>> +#if defined(CONFIG_DA850_UI_SD_VIDEO_PORT)
>> +     .chan_config[0] = {
>> +             .inputs = da850_ch0_inputs,
>> +             .input_count = ARRAY_SIZE(da850_ch0_inputs),
>> +     },
>> +     .chan_config[1] = {
>> +             .inputs = da850_ch1_inputs,
>> +             .input_count = ARRAY_SIZE(da850_ch1_inputs),
>> +     },
>> +#endif
>> +     .card_name      = "DA850/OMAP-L138 Video Capture",
>> +};
>> +
>> +/* VPIF display configuration */
>> +static struct vpif_subdev_info da850_vpif_subdev[] = {
>> +     {
>> +             .name   = "adv7343",
>> +             .board_info = {
>> +                     I2C_BOARD_INFO("adv7343", 0x2a),
>> +             },
>> +     },
>> +};
>> +
>> +static const char const *vpif_output[] = {
>> +     "Composite",
>> +     "Component",
>> +     "S-Video",
>> +};
>> +
>> +static struct vpif_display_config da850_vpif_display_config = {
>> +     .subdevinfo     = da850_vpif_subdev,
>> +     .subdev_count   = ARRAY_SIZE(da850_vpif_subdev),
>> +     .output         = vpif_output,
>> +     .output_count   = ARRAY_SIZE(vpif_output),
>> +     .card_name      = "DA850/OMAP-L138 Video Display",
>> +};
>> +
>> +#if defined(CONFIG_VIDEO_DAVINCI_VPIF_DISPLAY) ||\
>> +             defined(CONFIG_VIDEO_DAVINCI_VPIF_DISPLAY_MODULE)
>> +#define HAS_VPIF_DISPLAY 1
>> +#else
>> +#define HAS_VPIF_DISPLAY 0
>> +#endif
>> +
>> +#if defined(CONFIG_VIDEO_DAVINCI_VPIF_CAPTURE) ||\
>> +             defined(CONFIG_VIDEO_DAVINCI_VPIF_CAPTURE_MODULE)
>> +#define HAS_VPIF_CAPTURE 1
>> +#else
>> +#define HAS_VPIF_CAPTURE 0
>> +#endif
>> +
>>  #ifdef CONFIG_DA850_WL12XX
>>
>>  static void wl12xx_set_power(int index, bool power_on)
>> @@ -1375,6 +1521,38 @@ static __init void da850_evm_init(void)
>>               pr_warning("da850_evm_init: suspend registration failed: %d\n",
>>                               ret);
>>
>> +     if (HAS_VPIF_DISPLAY || HAS_VPIF_CAPTURE) {
>> +             ret = da850_register_vpif();
>> +             if (ret)
>> +                     pr_warn("da850_evm_init: VPIF setup failed: %d\n", ret);
>> +     }
>> +
>> +     if (HAS_VPIF_CAPTURE) {
>> +             ret = davinci_cfg_reg_list(da850_vpif_capture_pins);
>> +             if (ret)
>> +                     pr_warn(
>> +                     "da850_evm_init: VPIF capture mux setup failed: %d\n",
>> +                     ret);
>> +
>> +             ret = da850_register_vpif_capture(&da850_vpif_capture_config);
>> +             if (ret)
>> +                     pr_warn(
>> +                     "da850_evm_init: VPIF capture setup failed: %d\n", ret);
>> +     }
>> +
>> +     if (HAS_VPIF_DISPLAY) {
>> +             ret = davinci_cfg_reg_list(da850_vpif_display_pins);
>> +             if (ret)
>> +                     pr_warn(
>> +                     "da850_evm_init: VPIF display mux setup failed: %d\n",
>> +                     ret);
>> +
>> +             ret = da850_register_vpif_display(&da850_vpif_display_config);
>> +             if (ret)
>> +                     pr_warn(
>> +                     "da850_evm_init: VPIF display setup failed: %d\n", ret);
>> +     }
>> +
>
> Registering the platform device only when driver is configured is not
> required. Platform device registration should just reflect what is
> present in the hardware. Removing this should also get rid of the ugly
> line breaks above.
>
Ok.

Thanks,
--Prabhakar

> Thanks,
> Sekhar
> _______________________________________________
> Davinci-linux-open-source mailing list
> Davinci-linux-open-source@linux.davincidsp.com
> http://linux.davincidsp.com/mailman/listinfo/davinci-linux-open-source
