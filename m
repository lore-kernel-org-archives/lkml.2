Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755549Ab2K0Trt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 14:47:49 -0500
Received: from cantor2.suse.de ([195.135.220.15]:37698 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753882Ab2K0Trs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 14:47:48 -0500
Date: Tue, 27 Nov 2012 20:47:43 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>, Stephane Chatty <chatty@enac.fr>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/11] HID: hid-input factorize hid_input allocation
In-Reply-To: <1353684694-5723-2-git-send-email-benjamin.tissoires@gmail.com>
Message-ID: <alpine.LNX.2.00.1211272047340.3933@pobox.suse.cz>
References: <1353684694-5723-1-git-send-email-benjamin.tissoires@gmail.com> <1353684694-5723-2-git-send-email-benjamin.tissoires@gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Nov 2012, Benjamin Tissoires wrote:

> This just refactors the allocation of hid_input.
> No semantic changes.
> 
> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@gmail.com>

Fine by me, thanks.

> ---
>  drivers/hid/hid-input.c | 61 +++++++++++++++++++++++++++----------------------
>  1 file changed, 34 insertions(+), 27 deletions(-)
> 
> diff --git a/drivers/hid/hid-input.c b/drivers/hid/hid-input.c
> index 7015080..47f98a3 100644
> --- a/drivers/hid/hid-input.c
> +++ b/drivers/hid/hid-input.c
> @@ -1163,6 +1163,38 @@ static void report_features(struct hid_device *hid)
>  			}
>  }
>  
> +static struct hid_input *hidinput_allocate(struct hid_device *hid)
> +{
> +	struct hid_input *hidinput = kzalloc(sizeof(*hidinput), GFP_KERNEL);
> +	struct input_dev *input_dev = input_allocate_device();
> +	if (!hidinput || !input_dev) {
> +		kfree(hidinput);
> +		input_free_device(input_dev);
> +		hid_err(hid, "Out of memory during hid input probe\n");
> +		return NULL;
> +	}
> +
> +	input_set_drvdata(input_dev, hid);
> +	input_dev->event = hid->ll_driver->hidinput_input_event;
> +	input_dev->open = hidinput_open;
> +	input_dev->close = hidinput_close;
> +	input_dev->setkeycode = hidinput_setkeycode;
> +	input_dev->getkeycode = hidinput_getkeycode;
> +
> +	input_dev->name = hid->name;
> +	input_dev->phys = hid->phys;
> +	input_dev->uniq = hid->uniq;
> +	input_dev->id.bustype = hid->bus;
> +	input_dev->id.vendor  = hid->vendor;
> +	input_dev->id.product = hid->product;
> +	input_dev->id.version = hid->version;
> +	input_dev->dev.parent = hid->dev.parent;
> +	hidinput->input = input_dev;
> +	list_add_tail(&hidinput->list, &hid->inputs);
> +
> +	return hidinput;
> +}
> +
>  /*
>   * Register the input device; print a message.
>   * Configure the input layer interface
> @@ -1174,7 +1206,6 @@ int hidinput_connect(struct hid_device *hid, unsigned int force)
>  	struct hid_driver *drv = hid->driver;
>  	struct hid_report *report;
>  	struct hid_input *hidinput = NULL;
> -	struct input_dev *input_dev;
>  	int i, j, k;
>  
>  	INIT_LIST_HEAD(&hid->inputs);
> @@ -1205,33 +1236,9 @@ int hidinput_connect(struct hid_device *hid, unsigned int force)
>  				continue;
>  
>  			if (!hidinput) {
> -				hidinput = kzalloc(sizeof(*hidinput), GFP_KERNEL);
> -				input_dev = input_allocate_device();
> -				if (!hidinput || !input_dev) {
> -					kfree(hidinput);
> -					input_free_device(input_dev);
> -					hid_err(hid, "Out of memory during hid input probe\n");
> +				hidinput = hidinput_allocate(hid);
> +				if (!hidinput)
>  					goto out_unwind;
> -				}
> -
> -				input_set_drvdata(input_dev, hid);
> -				input_dev->event =
> -					hid->ll_driver->hidinput_input_event;
> -				input_dev->open = hidinput_open;
> -				input_dev->close = hidinput_close;
> -				input_dev->setkeycode = hidinput_setkeycode;
> -				input_dev->getkeycode = hidinput_getkeycode;
> -
> -				input_dev->name = hid->name;
> -				input_dev->phys = hid->phys;
> -				input_dev->uniq = hid->uniq;
> -				input_dev->id.bustype = hid->bus;
> -				input_dev->id.vendor  = hid->vendor;
> -				input_dev->id.product = hid->product;
> -				input_dev->id.version = hid->version;
> -				input_dev->dev.parent = hid->dev.parent;
> -				hidinput->input = input_dev;
> -				list_add_tail(&hidinput->list, &hid->inputs);
>  			}
>  
>  			for (i = 0; i < report->maxfield; i++)
> -- 
> 1.8.0
> 

-- 
Jiri Kosina
SUSE Labs
