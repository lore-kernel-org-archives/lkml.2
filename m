Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756644Ab2LMSvE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 13:51:04 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:53162 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756433Ab2LMSvC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 13:51:02 -0500
Subject: Re: question about drivers/power/88pm860x_charger.c
From: anish kumar <anish198519851985@gmail.com>
To: Julia Lawall <julia.lawall@lip6.fr>
Cc: cbou@mail.ru, dwmw2@infradead.org, linux-kernel@vger.kernel.org
In-Reply-To: <alpine.DEB.2.02.1212081731080.1984@hadrien>
References: <alpine.DEB.2.02.1212081731080.1984@hadrien>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 13 Dec 2012 10:50:55 -0800
Message-ID: <1355424655.26515.8.camel@anish-Inspiron-N5050>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-12-08 at 17:37 +0100, Julia Lawall wrote:
> The function pm860x_charger_probe in the file 
> drivers/power/88pm860x_charger.c contains the following code:
> 
>          count = pdev->num_resources;
>          for (i = 0, j = 0; i < count; i++) {
>                  info->irq[j] = platform_get_irq(pdev, i);
>                  if (info->irq[j] < 0)
>                          continue;
>                  j++;
>          }
>          info->irq_nums = j;
> 
> and then later the following code:
> 
>         for (i = 0; i < ARRAY_SIZE(info->irq); i++) {
This seems to be wrong.We already know this size which is 7 so why
use ARRAY_SIZE?I think the intention is as below
>                  ret = request_threaded_irq(info->irq[i], NULL,
>                          pm860x_irq_descs[i].handler,
>                          IRQF_ONESHOT, pm860x_irq_descs[i].name, info);
>  		...
>          }
> 
> and finally, in the function pm860x_charger_remove, the code:
> 
>          free_irq(info->irq[0], info);
>          for (i = 0; i < info->irq_nums; i++)
>                  free_irq(info->irq[i], info);
> 
> It looks like the irq_nums field is being used to record how many 
> platform_get_irq calls were successful, but this information is not used 
> in the second block of code, where request_threaded_irq is called.  So it 
> would seem that all of the requested irqs should be freed, and not just 
> the first irq_nums of them.
> 
> The remove code also looks like a double free of info->irq[0].
> 
> Could I just get rid of the irq_nums field completely?  It doesn't seem to 
diff --git a/drivers/power/88pm860x_charger.c
b/drivers/power/88pm860x_charger.c
index 2dbeb14..821629f 100644
--- a/drivers/power/88pm860x_charger.c
+++ b/drivers/power/88pm860x_charger.c
@@ -698,7 +698,7 @@ static __devinit int pm860x_charger_probe(struct
platform_device *pdev)
 
        pm860x_init_charger(info);
 
-       for (i = 0; i < ARRAY_SIZE(info->irq); i++) {
+       for (i = 0; i < info->irq_nums; i++) {
                ret = request_threaded_irq(info->irq[i], NULL,
                        pm860x_irq_descs[i].handler,
                        IRQF_ONESHOT, pm860x_irq_descs[i].name, info);

> be used elsewhere.  Also, I was planning to use devm_request_threaded_irq, 
> so then there won't be a need for the explicit frees at all.

> 
> This file also contains a kfree of devm_kzalloc'd data, which is why I 
> looked at it in the first place.
> 
> thanks,
> julia
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


