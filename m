Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754678Ab1AGTAW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 14:00:22 -0500
Received: from ch-smtp02.sth.basefarm.net ([80.76.149.213]:33505 "EHLO
	ch-smtp02.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752151Ab1AGTAV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 14:00:21 -0500
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Fri, 7 Jan 2011 19:59:39 +0100
To: Benjamin Tissoires <benjamin.tissoires@enac.fr>
Cc: Stephane Chatty <chatty@enac.fr>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC v3 1/5] hid: add feature_mapping callback
Message-ID: <20110107185939.GA29913@polaris.bitmath.org>
References: <1294425762-29730-1-git-send-email-benjamin.tissoires@enac.fr>
 <1294425762-29730-2-git-send-email-benjamin.tissoires@enac.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1294425762-29730-2-git-send-email-benjamin.tissoires@enac.fr>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: 83.248.200.95
X-Scan-Result: No virus found in message 1PbHXK-0006RP-7j.
X-Scan-Signature: ch-smtp02.sth.basefarm.net 1PbHXK-0006RP-7j 1f3a894cfe3c3a649606a94c2b003e51
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 07, 2011 at 07:42:38PM +0100, Benjamin Tissoires wrote:
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

Hi Benjamin,

the patch series has some impurities (see checkpatch), and some minor comments below, but all in all,

Acked-by: Henrik Rydberg <rydberg@euromail.se>

>  drivers/hid/hid-input.c |   17 +++++++++++++----
>  include/linux/hid.h     |    4 ++++
>  2 files changed, 17 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/hid/hid-input.c b/drivers/hid/hid-input.c
> index bb0b365..e1b48e4 100644
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
> @@ -836,7 +844,6 @@ int hidinput_connect(struct hid_device *hid, unsigned int force)
>  	struct hid_input *hidinput = NULL;
>  	struct input_dev *input_dev;
>  	int i, j, k;
> -	int max_report_type = HID_OUTPUT_REPORT;
>  
>  	INIT_LIST_HEAD(&hid->inputs);
>  
> @@ -853,10 +860,11 @@ int hidinput_connect(struct hid_device *hid, unsigned int force)
>  			return -1;
>  	}
>  
> -	if (hid->quirks & HID_QUIRK_SKIP_OUTPUT_REPORTS)
> -		max_report_type = HID_INPUT_REPORT;
> +	for (k = HID_INPUT_REPORT; k <= HID_FEATURE_REPORT; k++) {
> +		if (k == HID_OUTPUT_REPORT &&
> +			hid->quirks & HID_QUIRK_SKIP_OUTPUT_REPORTS)

Omitting the parenthesis here is not wrong, but not really customary either.

> +			continue;
>  
> -	for (k = HID_INPUT_REPORT; k <= max_report_type; k++)
>  		list_for_each_entry(report, &hid->report_enum[k].report_list, list) {
>  
>  			if (!report->maxfield)
> @@ -909,6 +917,7 @@ int hidinput_connect(struct hid_device *hid, unsigned int force)
>  				hidinput = NULL;
>  			}
>  		}
> +	}
>  
>  	if (hidinput && input_register_device(hidinput->input))
>  		goto out_cleanup;
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
> -- 
> 1.7.3.4
> 

Thanks,
Henrik
