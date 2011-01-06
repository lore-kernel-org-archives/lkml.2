Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753216Ab1AFQXb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 11:23:31 -0500
Received: from ch-smtp03.sth.basefarm.net ([80.76.149.214]:39005 "EHLO
	ch-smtp03.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751354Ab1AFQXa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 11:23:30 -0500
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Thu, 6 Jan 2011 17:22:23 +0100
To: Benjamin Tissoires <benjamin.tissoires@enac.fr>
Cc: Stephane Chatty <chatty@enac.fr>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC v2 01/10] hid: add feature_mapping callback
Message-ID: <20110106162223.GB1790@polaris.bitmath.org>
References: <1294248468-19979-1-git-send-email-benjamin.tissoires@enac.fr>
 <1294248468-19979-2-git-send-email-benjamin.tissoires@enac.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1294248468-19979-2-git-send-email-benjamin.tissoires@enac.fr>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: 83.248.200.95
X-Scan-Result: No virus found in message 1PasbZ-00043y-Ax.
X-Scan-Signature: ch-smtp03.sth.basefarm.net 1PasbZ-00043y-Ax 51c2bae3a9675093586c1ef409a4c5d2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 05, 2011 at 06:27:39PM +0100, Benjamin Tissoires wrote:
> Currently hid doesn't export the features it knows to the specific modules.
> Some information can be really important in such features: MosArt and
> Cypress devices are by default not in a multitouch mode.
> We have to send the value 2 on the right feature.
> 
> This patch exports to the module the features report so they can find the
> right feature to set up the correct mode.
> 
> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@enac.fr>
> ---
>  drivers/hid/hid-input.c |   10 +++++++++-
>  include/linux/hid.h     |    4 ++++
>  2 files changed, 13 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/hid/hid-input.c b/drivers/hid/hid-input.c
> index bb0b365..07d8cb2 100644
> --- a/drivers/hid/hid-input.c
> +++ b/drivers/hid/hid-input.c
> @@ -287,6 +287,14 @@ static void hidinput_configure_usage(struct hid_input *hidinput, struct hid_fiel
>  		goto ignore;
>  	}
>  
> +	if (field->report_type == HID_FEATURE_REPORT) {
> +		if (device->driver->feature_mapping) {
> +			device->driver->feature_mapping(device, hidinput, field,
> +                                usage);
> +		}
> +		goto ignore;
> +	}
> +
>  	if (device->driver->input_mapping) {
>  		int ret = device->driver->input_mapping(device, hidinput, field,
>  				usage, &bit, &max);
> @@ -836,7 +844,7 @@ int hidinput_connect(struct hid_device *hid, unsigned int force)
>  	struct hid_input *hidinput = NULL;
>  	struct input_dev *input_dev;
>  	int i, j, k;
> -	int max_report_type = HID_OUTPUT_REPORT;
> +	int max_report_type = HID_FEATURE_REPORT;

Doing it this way conflicts with the HID_QUIRK_SKIP_OUTPUT_REPORTS quirk.

>  
>  	INIT_LIST_HEAD(&hid->inputs);
>  
> diff --git a/include/linux/hid.h b/include/linux/hid.h
> index bb0f56f..75303b0 100644
> --- a/include/linux/hid.h
> +++ b/include/linux/hid.h
> @@ -593,6 +593,7 @@ struct hid_usage_id {
>   * @report_fixup: called before report descriptor parsing (NULL means nop)
>   * @input_mapping: invoked on input registering before mapping an usage
>   * @input_mapped: invoked on input registering after mapping an usage
> + * @feature_mapping: invoked on feature registering
>   * @suspend: invoked on suspend (NULL means nop)
>   * @resume: invoked on resume if device was not reset (NULL means nop)
>   * @reset_resume: invoked on resume if device was reset (NULL means nop)
> @@ -636,6 +637,9 @@ struct hid_driver {
>  	int (*input_mapped)(struct hid_device *hdev,
>  			struct hid_input *hidinput, struct hid_field *field,
>  			struct hid_usage *usage, unsigned long **bit, int *max);
> +	void (*feature_mapping)(struct hid_device *hdev,
> + 			struct hid_input *hidinput, struct hid_field *field,
> + 			struct hid_usage *usage);
>  #ifdef CONFIG_PM
>  	int (*suspend)(struct hid_device *hdev, pm_message_t message);
>  	int (*resume)(struct hid_device *hdev);

Thanks,
Henrik
