Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755461Ab0ELJ5Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 05:57:25 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:34798 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753447Ab0ELJ5Y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 05:57:24 -0400
MIME-version: 1.0
Content-type: text/plain; charset=utf-8; format=flowed; delsp=yes
Date: Wed, 12 May 2010 11:57:50 +0200
From: =?utf-8?B?TWljaGHFgiBOYXphcmV3aWN6?= <m.nazarewicz@samsung.com>
Subject: Re: [PATCH] USB: gadget: f_mass_storage: fix in fsg_common_init()
 error recovery
In-reply-to: <70376CA23424B34D86F1C7DE6B9973430254343ABC@VSHINMSMBX01.vshodc.lntinfotech.com>
To: Viral Mehta <Viral.Mehta@lntinfotech.com>,
       "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
       Marek Szyprowski <m.szyprowski@samsung.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Message-id: <op.vck7aofj7p4s8u@pikus>
Organization: Samsung Electronics
Content-transfer-encoding: 8BIT
User-Agent: Opera Mail/10.10 (Linux)
References: <994e1bf34d3b6f1fbc58c0f7ce61c7f258208ddd.1273651956.git.mina86@mina86.com>
 <70376CA23424B34D86F1C7DE6B9973430254343ABA@VSHINMSMBX01.vshodc.lntinfotech.com>
 <op.vck4q0c87p4s8u@pikus>
 <70376CA23424B34D86F1C7DE6B9973430254343ABB@VSHINMSMBX01.vshodc.lntinfotech.com>
 <70376CA23424B34D86F1C7DE6B9973430254343ABC@VSHINMSMBX01.vshodc.lntinfotech.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 May 2010 11:36:06 +0200, Viral Mehta <Viral.Mehta@lntinfotech.com> wrote:
> diff --git a/drivers/usb/gadget/f_mass_storage.c b/drivers/usb/gadget/f_mass_storage.c
> index f4911c0..7ad9a89 100644
> --- a/drivers/usb/gadget/f_mass_storage.c
> +++ b/drivers/usb/gadget/f_mass_storage.c
> @@ -2702,7 +2702,8 @@ static struct fsg_common *fsg_common_init(struct fsg_common *common,
>         if (fsg_strings[FSG_STRING_INTERFACE].id == 0) {
>                 rc = usb_string_id(cdev);
>                 if (rc < 0) {
> -                       kfree(common);
> +                       if(common->free_storage_on_release)
> +                               kfree(common);
>                         return ERR_PTR(rc);
>                 }
>                 fsg_strings[FSG_STRING_INTERFACE].id = rc;
> @@ -2713,7 +2714,8 @@ static struct fsg_common *fsg_common_init(struct fsg_common *common,
>          * LUN devices in sysfs. */
>         curlun = kzalloc(nluns * sizeof *curlun, GFP_KERNEL);
>         if (!curlun) {
> -               kfree(common);
> +               if(common->free_storage_on_release)
> +                       kfree(common);
>                 return ERR_PTR(-ENOMEM);
>         }
>         common->luns = curlun;
>
> looks correct and simple fix.

Yes, it should work fine and in fact was my first approach but as I've written in
my previous mail:

> The way I see it, it does not matter that much -- it's error recovery so we assume
> it's unlikely to happen and as such speed optimisation is not really needed here --
> it's better to optimise for space and minimise the number of possible paths.

Because of that, I the "goto error_release" to be cleaner in the sense that
there is a single error recovery path and only one place where
free_storage_on_release flag is checked and common freed.

-- 
Best regards,                                        _     _
| Humble Liege of Serenely Enlightened Majesty of  o' \,=./ `o
| Computer Science,  Michał "mina86" Nazarewicz       (o o)
+----[mina86*mina86.com]---[mina86*jabber.org]----ooO--(_)--Ooo--
