Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756204Ab2K0UNI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 15:13:08 -0500
Received: from smtprelay-h22.telenor.se ([195.54.99.197]:40341 "EHLO
	smtprelay-h22.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754474Ab2K0UNG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 15:13:06 -0500
X-SENDER-IP: [85.230.168.206]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Al1wAHketVBV5qjOPGdsb2JhbABFhUCFI7U6FwMBAQEBODSCHgEBBAEnExwjBQsIA0YUDRgKGhOHewMJCq96hmENiVQUiz2ESWEDkk+BXYFUhXuDUIFqiAE
X-IronPort-AV: E=Sophos;i="4.83,330,1352070000"; 
   d="scan'208";a="237724933"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Tue, 27 Nov 2012 21:14:07 +0100
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 02/11] HID: hid-input: simplify hid_input allocation and
 registration
Message-ID: <20121127201407.GA884@polaris.bitmath.org>
References: <1353684694-5723-1-git-send-email-benjamin.tissoires@gmail.com>
 <1353684694-5723-3-git-send-email-benjamin.tissoires@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1353684694-5723-3-git-send-email-benjamin.tissoires@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Benjamin,

> In order to provide fine control for the creation of different
> input devices in probe function of third party drivers, this patch
> split the allocations, the registrations and the free of input
> devices.
> 
> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@gmail.com>
> ---
>  drivers/hid/hid-input.c | 28 ++++++++++++++++++----------
>  1 file changed, 18 insertions(+), 10 deletions(-)

I don't like this patch, nor its purpose. Drivers should not depend on
the hid core working in a particular way internally, that spells
disaster. There must be some other way in which the same effect can be
achieved?

> 
> diff --git a/drivers/hid/hid-input.c b/drivers/hid/hid-input.c
> index 47f98a3..eea02b0 100644
> --- a/drivers/hid/hid-input.c
> +++ b/drivers/hid/hid-input.c
> @@ -1206,6 +1206,7 @@ int hidinput_connect(struct hid_device *hid, unsigned int force)
>  	struct hid_driver *drv = hid->driver;
>  	struct hid_report *report;
>  	struct hid_input *hidinput = NULL;
> +	struct hid_input *next;
>  	int i, j, k;
>  
>  	INIT_LIST_HEAD(&hid->inputs);
> @@ -1238,7 +1239,7 @@ int hidinput_connect(struct hid_device *hid, unsigned int force)
>  			if (!hidinput) {
>  				hidinput = hidinput_allocate(hid);
>  				if (!hidinput)
> -					goto out_unwind;
> +					goto out_cleanup;
>  			}
>  
>  			for (i = 0; i < report->maxfield; i++)
> @@ -1253,29 +1254,36 @@ int hidinput_connect(struct hid_device *hid, unsigned int force)
>  				 * UGCI) cram a lot of unrelated inputs into the
>  				 * same interface. */
>  				hidinput->report = report;
> -				if (drv->input_configured)
> -					drv->input_configured(hid, hidinput);
> -				if (input_register_device(hidinput->input))
> -					goto out_cleanup;
>  				hidinput = NULL;
>  			}
>  		}
>  	}
>  
> -	if (hidinput) {
> +	list_for_each_entry(hidinput, &hid->inputs, list) {
>  		if (drv->input_configured)
>  			drv->input_configured(hid, hidinput);
>  		if (input_register_device(hidinput->input))
> -			goto out_cleanup;
> +			goto out_unwind;
>  	}
>  
>  	return 0;
>  
>  out_cleanup:
> -	list_del(&hidinput->list);
> -	input_free_device(hidinput->input);
> -	kfree(hidinput);
> +	list_for_each_entry_safe(hidinput, next, &hid->inputs, list) {
> +		list_del(&hidinput->list);
> +		input_free_device(hidinput->input);
> +		kfree(hidinput);
> +	}
> +	return -1;

Irregular return in the error path?

> +
>  out_unwind:
> +	/* free the non-registered hidinput, starting from the faulty one */
> +	list_for_each_entry_safe_from(hidinput, next, &hid->inputs, list) {
> +		list_del(&hidinput->list);
> +		input_free_device(hidinput->input);
> +		kfree(hidinput);
> +	}
> +
>  	/* unwind the ones we already registered */
>  	hidinput_disconnect(hid);
>  
> -- 
> 1.8.0
> 

Thanks,
Henrik
