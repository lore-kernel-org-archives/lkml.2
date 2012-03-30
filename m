Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934343Ab2C3MH3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 08:07:29 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:41452 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933847Ab2C3MHR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 08:07:17 -0400
MIME-Version: 1.0
In-Reply-To: <0e569b120d19c35dcc4f5549956cd884c3241270.1333101989.git.len.brown@intel.com>
References: <09f98a825a821f7a3f1b162f9ed023f37213a63b.1333101989.git.len.brown@intel.com>
	<1333102459-23750-1-git-send-email-lenb@kernel.org>
	<0e569b120d19c35dcc4f5549956cd884c3241270.1333101989.git.len.brown@intel.com>
Date: Fri, 30 Mar 2012 14:07:15 +0200
Message-ID: <CAHR064iEVsoMiP1PYzXeZeZzOFCPTk1YDBty6nHAfzej2qh_qA@mail.gmail.com>
Subject: Re: [PATCH 57/76] ACPI / Video: blacklist some samsung laptops
From: Corentin Chary <corentin.chary@gmail.com>
To: Len Brown <lenb@kernel.org>
Cc: linux-acpi@vger.kernel.org, linux-pm@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, Len Brown <len.brown@intel.com>,
        Matthew Garrett <mjg@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 30, 2012 at 12:14 PM, Len Brown <lenb@kernel.org> wrote:
> From: Corentin Chary <corentincj@iksaif.net>
>
> On these laptops, the ACPI video is not functional, and very unlikely
> to be fixed by the vendor. Note that intel_backlight works for some
> of these laptops, and the backlight from samsung-laptop always work.
>
> The good news is that newer laptops have functional ACPI video device
> and won't end up growing this list.
>
> Signed-off-by: Corentin Chary <corentincj@iksaif.net>
> Signed-off-by: Len Brown <len.brown@intel.com>
> ---
>  drivers/acpi/video_detect.c |   49 +++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 49 insertions(+)
>
> diff --git a/drivers/acpi/video_detect.c b/drivers/acpi/video_detect.c
> index f3f0fe7..b6f6979 100644
> --- a/drivers/acpi/video_detect.c
> +++ b/drivers/acpi/video_detect.c
> @@ -132,6 +132,53 @@ find_video(acpi_handle handle, u32 lvl, void *context, void **rv)
>        return AE_OK;
>  }
>
> +/* Force to use vendor driver when the ACPI device is known to be
> + * buggy */
> +static int video_detect_force_vendor(const struct dmi_system_id *d)
> +{
> +       acpi_video_support |= ACPI_VIDEO_BACKLIGHT_DMI_VENDOR;
> +       return 0;
> +}
> +
> +static struct dmi_system_id video_detect_dmi_table[] = {
> +       {
> +        .callback = video_detect_force_vendor,
> +        .ident = "N150P",
> +        .matches = {
> +               DMI_MATCH(DMI_SYS_VENDOR, "SAMSUNG ELECTRONICS CO., LTD."),
> +               DMI_MATCH(DMI_PRODUCT_NAME, "N150P"),
> +               DMI_MATCH(DMI_BOARD_NAME, "N150P"),
> +               },
> +       },
> +       {
> +        .callback = video_detect_force_vendor,
> +        .ident = "N145P/N250P/N260P",
> +        .matches = {
> +               DMI_MATCH(DMI_SYS_VENDOR, "SAMSUNG ELECTRONICS CO., LTD."),
> +               DMI_MATCH(DMI_PRODUCT_NAME, "N145P/N250P/N260P"),
> +               DMI_MATCH(DMI_BOARD_NAME, "N145P/N250P/N260P"),
> +               },
> +       },
> +       {
> +        .callback = video_detect_force_vendor,
> +        .ident = "N150/N210/N220",
> +        .matches = {
> +               DMI_MATCH(DMI_SYS_VENDOR, "SAMSUNG ELECTRONICS CO., LTD."),
> +               DMI_MATCH(DMI_PRODUCT_NAME, "N150/N210/N220"),
> +               DMI_MATCH(DMI_BOARD_NAME, "N150/N210/N220"),
> +               },
> +       },
> +       {
> +        .callback = video_detect_force_vendor,
> +        .ident = "NF110/NF210/NF310",
> +        .matches = {
> +               DMI_MATCH(DMI_SYS_VENDOR, "SAMSUNG ELECTRONICS CO., LTD."),
> +               DMI_MATCH(DMI_PRODUCT_NAME, "NF110/NF210/NF310"),
> +               DMI_MATCH(DMI_BOARD_NAME, "NF110/NF210/NF310"),
> +               },
> +       },
> +};
> +
>  /*
>  * Returns the video capabilities of a specific ACPI graphics device
>  *
> @@ -164,6 +211,8 @@ long acpi_video_get_capabilities(acpi_handle graphics_handle)
>                 *              ACPI_VIDEO_BACKLIGHT_DMI_VENDOR;
>                 *}
>                 */
> +
> +               dmi_check_system(video_detect_dmi_table);
>        } else {
>                status = acpi_bus_get_device(graphics_handle, &tmp_dev);
>                if (ACPI_FAILURE(status)) {
> --
> 1.7.10.rc2.19.gfae9d
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Hi Len,

Sorry for that but this patch was re-sent recently, and Matthew told
me to do that this should be done in samsung-laptop.c instead.

The resulting patch has been merged in Matthew's tree:
http://git.kernel.org/?p=linux/kernel/git/next/linux-next.git;a=blobdiff;f=drivers/platform/x86/samsung-laptop.c;h=e2a34b42ddc1d584b5333fe9921d0d2c2b12dda4;hp=4787afdf11dc20e69af8fe5324366d4bd65aeb98;hb=a979e2e2af7d5b4bb3b20f6a716c627bb23a6753;hpb=5719b81988f3c24ff694dc3a37e35b35630a3966

One of these patches should be reverted, but which one ?
Note that apple-gmux and acer-wmi are also using the
acpi_video_unregister() trick in linux-next.

Thanks,

-- 
Corentin Chary
http://xf.iksaif.net
