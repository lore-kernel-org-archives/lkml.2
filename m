Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755821Ab2AQUUB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 15:20:01 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47544 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753224Ab2AQUT7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 15:19:59 -0500
Date: Tue, 17 Jan 2012 14:19:54 -0600
From: Seth Forshee <seth.forshee@canonical.com>
To: Corentin Chary <corentincj@iksaif.net>
Cc: platform-driver-x86@vger.kernel.org, Zhang Rui <rui.zhang@intel.com>,
        linux-kernel@vger.kernel.org, Andrzej Prochyra <andrzej@prochyra.name>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        David Herrmann <dh.herrmann@googlemail.com>,
        Richard =?utf-8?Q?Sch=C3=BCtz?= <r.schtz@t-online.de>,
        Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org
Subject: Re: [PATCH] ACPI / Video: blacklist some samsung laptops
Message-ID: <20120117201954.GC2257@ubuntu-macmini>
Mail-Followup-To: Corentin Chary <corentincj@iksaif.net>,
	platform-driver-x86@vger.kernel.org,
	Zhang Rui <rui.zhang@intel.com>, linux-kernel@vger.kernel.org,
	Andrzej Prochyra <andrzej@prochyra.name>,
	Matthew Garrett <mjg59@srcf.ucam.org>,
	David Herrmann <dh.herrmann@googlemail.com>,
	Richard =?utf-8?Q?Sch=C3=BCtz?= <r.schtz@t-online.de>,
	Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org
References: <1326784098-3244-1-git-send-email-corentincj@iksaif.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1326784098-3244-1-git-send-email-corentincj@iksaif.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 17, 2012 at 08:08:18AM +0100, Corentin Chary wrote:
> On these laptops, the ACPI video is not functional, and very unlikely
> to be fixed by the vendor. Note that intel_backlight works for some
> of these laptops, and the backlight from samsung-laptop always work.
> 
> The good news is that newer laptops have functional ACPI video device
> and won't end up growing this list.
> 
> Signed-off-by: Corentin Chary <corentincj@iksaif.net>
> ---
>  drivers/acpi/video_detect.c |   49 +++++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 49 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/acpi/video_detect.c b/drivers/acpi/video_detect.c
> index 45d8097..66be45e 100644
> --- a/drivers/acpi/video_detect.c
> +++ b/drivers/acpi/video_detect.c
> @@ -132,6 +132,53 @@ find_video(acpi_handle handle, u32 lvl, void *context, void **rv)
>  	return AE_OK;
>  }
>  
> +/* Force to use vendor driver when the ACPI device is known to be
> + * buggy */
> +static int video_detect_force_vendor(const struct dmi_system_id *d)
> +{
> +	acpi_video_support |= ACPI_VIDEO_BACKLIGHT_DMI_VENDOR;
> +	return 0;
> +}
> +
> +static struct dmi_system_id video_detect_dmi_table[] = {
> +	{
> +	 .callback = video_detect_force_vendor,
> +	 .ident = "N150P",
> +	 .matches = {
> +		DMI_MATCH(DMI_SYS_VENDOR, "SAMSUNG ELECTRONICS CO., LTD."),
> +		DMI_MATCH(DMI_PRODUCT_NAME, "N150P"),
> +		DMI_MATCH(DMI_BOARD_NAME, "N150P"),
> +		},
> +	},
> +	{
> +	 .callback = video_detect_force_vendor,
> +	 .ident = "N145P/N250P/N260P",
> +	 .matches = {
> +		DMI_MATCH(DMI_SYS_VENDOR, "SAMSUNG ELECTRONICS CO., LTD."),
> +		DMI_MATCH(DMI_PRODUCT_NAME, "N145P/N250P/N260P"),
> +		DMI_MATCH(DMI_BOARD_NAME, "N145P/N250P/N260P"),
> +		},
> +	},
> +	{
> +	 .callback = video_detect_force_vendor,
> +	 .ident = "N150/N210/N220",
> +	 .matches = {
> +		DMI_MATCH(DMI_SYS_VENDOR, "SAMSUNG ELECTRONICS CO., LTD."),
> +		DMI_MATCH(DMI_PRODUCT_NAME, "N150/N210/N220"),
> +		DMI_MATCH(DMI_BOARD_NAME, "N150/N210/N220"),
> +		},
> +	},
> +	{
> +	 .callback = video_detect_force_vendor,
> +	 .ident = "NF110/NF210/NF310",
> +	 .matches = {
> +		DMI_MATCH(DMI_SYS_VENDOR, "SAMSUNG ELECTRONICS CO., LTD."),
> +		DMI_MATCH(DMI_PRODUCT_NAME, "NF110/NF210/NF310"),
> +		DMI_MATCH(DMI_BOARD_NAME, "NF110/NF210/NF310"),
> +		},
> +	},
> +};
> +
>  /*
>   * Returns the video capabilities of a specific ACPI graphics device
>   *
> @@ -164,6 +211,8 @@ long acpi_video_get_capabilities(acpi_handle graphics_handle)
>  		 *		ACPI_VIDEO_BACKLIGHT_DMI_VENDOR;
>  		 *}
>  		 */
> +
> +		dmi_check_system(video_detect_dmi_table);
>  	} else {
>  		status = acpi_bus_get_device(graphics_handle, &tmp_dev);
>  		if (ACPI_FAILURE(status)) {
> -- 
> 1.7.5.4
> 

This is working great on the NF310. Thanks!

