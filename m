Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932192Ab2K0UUu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 15:20:50 -0500
Received: from smtprelay-h31.telenor.se ([213.150.131.4]:39889 "EHLO
	smtprelay-h31.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756468Ab2K0UUr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 15:20:47 -0500
X-SENDER-IP: [85.230.168.206]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Al1wAJIftVBV5qjOPGdsb2JhbABFhUCFI7U6FwMBAQEBODSCHgEBBAEnExwjEAgDGC4UDRgKGhOHewMJCq98hmENiVQUiz1pg2BhA5QsgVSFe4NQgWqIAQ
X-IronPort-AV: E=Sophos;i="4.83,330,1352070000"; 
   d="scan'208";a="454102385"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Tue, 27 Nov 2012 21:21:50 +0100
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 03/11] HID: hid-input: export hidinput_allocation function
Message-ID: <20121127202150.GA895@polaris.bitmath.org>
References: <1353684694-5723-1-git-send-email-benjamin.tissoires@gmail.com>
 <1353684694-5723-4-git-send-email-benjamin.tissoires@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1353684694-5723-4-git-send-email-benjamin.tissoires@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 23, 2012 at 04:31:26PM +0100, Benjamin Tissoires wrote:
> During the probe, third party drivers can now safely create a new
> input devices depending on the parsing of the reports descriptor.
> 
> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@gmail.com>
> ---
>  drivers/hid/hid-input.c | 14 +++++++++++---
>  include/linux/hid.h     |  1 +
>  2 files changed, 12 insertions(+), 3 deletions(-)

I can think of two mechanisms that might be useful in finding a
way to achieve this cleanly: a) Let a driver return a value telling
whether to change input device, and b) Let a second driver have a go
at the same device report. Some return value or state could determine
logic in the hid core saying "we are not done with this device, try
another driver". Or something. Just not this way, please.

> 
> diff --git a/drivers/hid/hid-input.c b/drivers/hid/hid-input.c
> index eea02b0..b0572d0 100644
> --- a/drivers/hid/hid-input.c
> +++ b/drivers/hid/hid-input.c
> @@ -1163,7 +1163,7 @@ static void report_features(struct hid_device *hid)
>  			}
>  }
>  
> -static struct hid_input *hidinput_allocate(struct hid_device *hid)
> +struct hid_input *hidinput_allocate(struct hid_device *hid)
>  {
>  	struct hid_input *hidinput = kzalloc(sizeof(*hidinput), GFP_KERNEL);
>  	struct input_dev *input_dev = input_allocate_device();
> @@ -1190,10 +1190,16 @@ static struct hid_input *hidinput_allocate(struct hid_device *hid)
>  	input_dev->id.version = hid->version;
>  	input_dev->dev.parent = hid->dev.parent;
>  	hidinput->input = input_dev;
> -	list_add_tail(&hidinput->list, &hid->inputs);
> +	list_add(&hidinput->list, &hid->inputs);
>  
>  	return hidinput;
>  }
> +EXPORT_SYMBOL_GPL(hidinput_allocate);
> +
> +static struct hid_input *hid_get_latest_hidinput(struct hid_device *hid)
> +{
> +	return list_first_entry(&hid->inputs, struct hid_input, list);
> +}
>  
>  /*
>   * Register the input device; print a message.
> @@ -1243,9 +1249,11 @@ int hidinput_connect(struct hid_device *hid, unsigned int force)
>  			}
>  
>  			for (i = 0; i < report->maxfield; i++)
> -				for (j = 0; j < report->field[i]->maxusage; j++)
> +				for (j = 0; j < report->field[i]->maxusage; j++) {
> +					hidinput = hid_get_latest_hidinput(hid);
>  					hidinput_configure_usage(hidinput, report->field[i],
>  								 report->field[i]->usage + j);
> +				}
>  
>  			if (hid->quirks & HID_QUIRK_MULTI_INPUT) {
>  				/* This will leave hidinput NULL, so that it
> diff --git a/include/linux/hid.h b/include/linux/hid.h
> index d2c42dd..42b02d6 100644
> --- a/include/linux/hid.h
> +++ b/include/linux/hid.h
> @@ -701,6 +701,7 @@ extern void hidinput_hid_event(struct hid_device *, struct hid_field *, struct h
>  extern void hidinput_report_event(struct hid_device *hid, struct hid_report *report);
>  extern int hidinput_connect(struct hid_device *hid, unsigned int force);
>  extern void hidinput_disconnect(struct hid_device *);
> +extern struct hid_input *hidinput_allocate(struct hid_device *hid);
>  
>  int hid_set_field(struct hid_field *, unsigned, __s32);
>  int hid_input_report(struct hid_device *, int type, u8 *, int, int);
> -- 
> 1.8.0
> 

Thanks,
Henrik
