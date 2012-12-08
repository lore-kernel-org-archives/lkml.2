Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964872Ab2LHQhr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2012 11:37:47 -0500
Received: from mail1-relais-roc.national.inria.fr ([192.134.164.82]:35751 "EHLO
	mail1-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933030Ab2LHQhq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2012 11:37:46 -0500
X-IronPort-AV: E=Sophos;i="4.84,243,1355094000"; 
   d="scan'208";a="185239313"
Date: Sat, 8 Dec 2012 17:37:45 +0100 (CET)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@hadrien
To: cbou@mail.ru, dwmw2@infradead.org, linux-kernel@vger.kernel.org
Subject: question about drivers/power/88pm860x_charger.c
Message-ID: <alpine.DEB.2.02.1212081731080.1984@hadrien>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The function pm860x_charger_probe in the file 
drivers/power/88pm860x_charger.c contains the following code:

         count = pdev->num_resources;
         for (i = 0, j = 0; i < count; i++) {
                 info->irq[j] = platform_get_irq(pdev, i);
                 if (info->irq[j] < 0)
                         continue;
                 j++;
         }
         info->irq_nums = j;

and then later the following code:

        for (i = 0; i < ARRAY_SIZE(info->irq); i++) {
                 ret = request_threaded_irq(info->irq[i], NULL,
                         pm860x_irq_descs[i].handler,
                         IRQF_ONESHOT, pm860x_irq_descs[i].name, info);
 		...
         }

and finally, in the function pm860x_charger_remove, the code:

         free_irq(info->irq[0], info);
         for (i = 0; i < info->irq_nums; i++)
                 free_irq(info->irq[i], info);

It looks like the irq_nums field is being used to record how many 
platform_get_irq calls were successful, but this information is not used 
in the second block of code, where request_threaded_irq is called.  So it 
would seem that all of the requested irqs should be freed, and not just 
the first irq_nums of them.

The remove code also looks like a double free of info->irq[0].

Could I just get rid of the irq_nums field completely?  It doesn't seem to 
be used elsewhere.  Also, I was planning to use devm_request_threaded_irq, 
so then there won't be a need for the explicit frees at all.

This file also contains a kfree of devm_kzalloc'd data, which is why I 
looked at it in the first place.

thanks,
julia
