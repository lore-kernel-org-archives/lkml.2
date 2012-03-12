Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752167Ab2CLQJp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 12:09:45 -0400
Received: from cantor2.suse.de ([195.135.220.15]:44095 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751769Ab2CLQJm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 12:09:42 -0400
Date: Mon, 12 Mar 2012 17:09:40 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Simon Wood <simon@mungewell.org>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michael Bauer <michael@m-bauer.org>,
        Michal Maly <madcatxster@gmail.com>
Subject: Re: [PATCH 1/2] HID: hid-lg4ff add support for G27 LEDs
In-Reply-To: <1331565459-1892-1-git-send-email-simon@mungewell.org>
Message-ID: <alpine.LNX.2.00.1203121708430.18356@pobox.suse.cz>
References: <1331565459-1892-1-git-send-email-simon@mungewell.org>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Mar 2012, Simon Wood wrote:

> This patch adds support for the G27 LEDs. The LEDs are controlled
> by a 5bit value (0-31) where bit0 is the right most LED, the LEDs
> are mirrored to the left.
> 
> Arrangement on wheel is:
>    G G Y Y R R(bit4) Y Y G G(bit0)
> 
> Signed-off-by: Simon Wood <simon@mungewell.org>
> ---
>  drivers/hid/hid-lg4ff.c |   84 +++++++++++++++++++++++++++++++++++++++++++++-
>  1 files changed, 82 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/hid/hid-lg4ff.c b/drivers/hid/hid-lg4ff.c
> index 6ecc9e2..4f3b744 100644
> --- a/drivers/hid/hid-lg4ff.c
> +++ b/drivers/hid/hid-lg4ff.c
> @@ -49,7 +49,12 @@ static void hid_lg4ff_set_range_g25(struct hid_device *hid, u16 range);
>  static ssize_t lg4ff_range_show(struct device *dev, struct device_attribute *attr, char *buf);
>  static ssize_t lg4ff_range_store(struct device *dev, struct device_attribute *attr, const char *buf, size_t count);
>  
> +static void hid_lg4ff_set_leds(struct hid_device *hid, __u8 leds);
> +static ssize_t lg4ff_leds_show(struct device *dev, struct device_attribute *attr, char *buf);
> +static ssize_t lg4ff_leds_store(struct device *dev, struct device_attribute *attr, const char *buf, size_t count);
> +
>  static DEVICE_ATTR(range, S_IRWXU | S_IRWXG | S_IRWXO, lg4ff_range_show, lg4ff_range_store);
> +static DEVICE_ATTR(leds, S_IRWXU | S_IRWXG | S_IRWXO, lg4ff_leds_show, lg4ff_leds_store);
>  
>  static bool list_inited;
>  
> @@ -336,6 +341,67 @@ static ssize_t lg4ff_range_store(struct device *dev, struct device_attribute *at
>  	return count;
>  }
>  
> +/* Read current state of leds and display it in terminal */
> +static ssize_t lg4ff_leds_show(struct device *dev, struct device_attribute *attr, char *buf)
> +{
> +	struct lg4ff_device_entry *uninitialized_var(entry);
> +	struct list_head *h;
> +	struct hid_device *hid = to_hid_device(dev);
> +	size_t count;
> +
> +	list_for_each(h, &device_list.list) {
> +		entry = list_entry(h, struct lg4ff_device_entry, list);
> +		if (strcmp(entry->device_id, (&hid->dev)->kobj.name) == 0)
> +			break;
> +	}

Please correct me if I am wrong, but I don't see nothing that'd prevent 
this racing with lg4ff_deinit().

The same applies to already existing sysfs attributes actually.

-- 
Jiri Kosina
SUSE Labs
