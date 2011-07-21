Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752258Ab1GUHOI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 03:14:08 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:53466 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751814Ab1GUHOG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 03:14:06 -0400
MIME-Version: 1.0
In-Reply-To: <20110714144509.GA6391@electric-eye.fr.zoreil.com>
References: <CACna6rxAKMp-2wqwz4k4S3nTkY_3Qz7=hEZk9F2Zig7T5kp_HA@mail.gmail.com>
	<20110714144509.GA6391@electric-eye.fr.zoreil.com>
Date: Thu, 21 Jul 2011 09:14:05 +0200
Message-ID: <CACna6rwQOdb+Z6OiD8K6duW8RxYvD3GR3wxr5taPHuKGesg-vg@mail.gmail.com>
Subject: Re: Bug in BCMA: device_unregister causing "NULL pointer dereference at"
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Francois Romieu <romieu@fr.zoreil.com>
Cc: linux-wireless@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

W dniu 14 lipca 2011 16:45 użytkownik Francois Romieu
<romieu@fr.zoreil.com> napisał:
> Rafał Miłecki <zajec5@gmail.com> :
> [...]
>> Any tip, why does it happen?
>
> bcma_release_core_dev kfrees core while its list_head is still used ?
>
> May be something like this :
>
> diff --git a/drivers/bcma/main.c b/drivers/bcma/main.c
> index be52344..85fb3aa 100644
> --- a/drivers/bcma/main.c
> +++ b/drivers/bcma/main.c
> @@ -110,11 +110,14 @@ static int bcma_register_cores(struct bcma_bus *bus)
>
>  static void bcma_unregister_cores(struct bcma_bus *bus)
>  {
> -       struct bcma_device *core;
> +       struct bcma_device *core, *next;
>
> -       list_for_each_entry(core, &bus->cores, list) {
> +       list_for_each_entry_safe(core, next, &bus->cores, list) {
> +               list_del(&core->list);
>                if (core->dev_registered)
>                        device_unregister(&core->dev);
> +               else
> +                       kfree(core);
>        }
>  }

Thanks for your help, but I'm afraid crash happens in totally
different place. Have you take a look at dmesg.log from my second
e-mail? NULL ptr exception happens in kobject_del.

-- 
Rafał
