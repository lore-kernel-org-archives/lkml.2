Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755181Ab2ISIF1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 04:05:27 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:53455 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751507Ab2ISIFJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 04:05:09 -0400
Message-ID: <50597CAD.7010801@suse.cz>
Date: Wed, 19 Sep 2012 10:05:01 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20120904 Thunderbird/16.0
MIME-Version: 1.0
To: Kevin Daughtridge <kevin@kdau.com>
CC: Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Henrik Rydberg <rydberg@euromail.se>
Subject: Re: [PATCH v2] HID: leave dev_rdesc unmodified and use it for comparisons
References: <50592FB1.7000800@kdau.com>
In-Reply-To: <50592FB1.7000800@kdau.com>
X-Enigmail-Version: 1.5a1pre
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/19/2012 04:36 AM, Kevin Daughtridge wrote:
> --- a/drivers/hid/hid-core.c
> +++ b/drivers/hid/hid-core.c
> @@ -775,12 +775,14 @@ int hid_open_report(struct hid_device *d
>          return -ENODEV;
>      size = device->dev_rsize;
>  
> +    start = kmemdup(start, size, GFP_KERNEL);
> +    if (start == NULL)
> +        return -ENOMEM;
> +
>      if (device->driver->report_fixup)
>          start = device->driver->report_fixup(device, start, &size);
>  
> -    device->rdesc = kmemdup(start, size, GFP_KERNEL);
> -    if (device->rdesc == NULL)
> -        return -ENOMEM;
> +    device->rdesc = start;
>      device->rsize = size;

AFAICS this is incorrect. Some drivers return pointers to their own
static structure from their .report_fixup. Hence there are two problems:
* leak, because kmemdup'ped start is never freed
* invalid free -- kfree(device->rdesc) will try to free a static structure

regards,
-- 
js
suse labs
