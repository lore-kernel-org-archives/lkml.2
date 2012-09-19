Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755472Ab2ISLtM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 07:49:12 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:33340 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755247Ab2ISLtJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 07:49:09 -0400
Message-ID: <5059B0EF.5020905@mvista.com>
Date: Wed, 19 Sep 2012 15:47:59 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:15.0) Gecko/20120907 Thunderbird/15.0.1
MIME-Version: 1.0
To: Kevin Daughtridge <kevin@kdau.com>
CC: Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Henrik Rydberg <rydberg@euromail.se>
Subject: Re: [PATCH v2] HID: leave dev_rdesc unmodified and use it for comparisons
References: <50592FB1.7000800@kdau.com>
In-Reply-To: <50592FB1.7000800@kdau.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 19-09-2012 6:36, Kevin Daughtridge wrote:

> The dev_rdesc member of the hid_device structure is meant to store the original
> report descriptor received from the device, but it is currently passed to any
> report_fixup method before it is copied to the rdesc member. This patch moves
> the kmemdup to before, not after, the report_fixup call, keeping dev_rdesc
> unchanged.

> usbhid's hid_post_reset checks the report descriptor currently returned by the
> device against a descriptor that may have been modified by a driver's
> report_fixup method. That leaves some devices nonfunctional after a resume, with
> a "reset_resume error 1" reported. This patch checks the new descriptor against
> the unmodified dev_rdesc instead.

> BugLink:http://bugs.launchpad.net/bugs/1049623
> Signed-off-by: Kevin Daughtridge<kevin@kdau.com>

    Need space before the email. I've checked your original mail, it's not my 
Thunderbird this time (which does this kind of damage while quoting).

> ---
> --- a/drivers/hid/hid-core.c
> +++ b/drivers/hid/hid-core.c
> @@ -775,12 +775,14 @@ int hid_open_report(struct hid_device *d
>           return -ENODEV;
>       size = device->dev_rsize;
>
> +    start = kmemdup(start, size, GFP_KERNEL);
> +    if (start == NULL)
> +        return -ENOMEM;
> +
>       if (device->driver->report_fixup)
>           start = device->driver->report_fixup(device, start, &size);
>
> -    device->rdesc = kmemdup(start, size, GFP_KERNEL);
> -    if (device->rdesc == NULL)
> -        return -ENOMEM;
> +    device->rdesc = start;
>       device->rsize = size;
>
>       parser = vzalloc(sizeof(struct hid_parser));

    It still seems like the patch is whitespace damaged, but in another way: 
to every line satrting with space, another spece was added.

WBR, Sergei

