Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751479Ab1L0GKw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Dec 2011 01:10:52 -0500
Received: from mail4-relais-sop.national.inria.fr ([192.134.164.105]:45388
	"EHLO mail4-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751044Ab1L0GKt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Dec 2011 01:10:49 -0500
X-IronPort-AV: E=Sophos;i="4.71,414,1320620400"; 
   d="scan'208";a="124769877"
Date: Tue, 27 Dec 2011 07:10:42 +0100 (CET)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: lawall@pl-59034.rocq.inria.fr
To: Adam Jiang <jiang.adam@gmail.com>
cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: devm_kfree
In-Reply-To: <CALK_+D35jwxsABqfQ7o0CEF+aDaDcccp8-q7RDEO_t4Pm_gNWg@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1112270710300.7818@pl-59034.rocq.inria.fr>
References: <1324661974-17281-1-git-send-email-julia@diku.dk> <20111226120855.GB17760@sirena.org.uk> <alpine.DEB.2.02.1112261440450.1873@localhost6.localdomain6> <CALK_+D35jwxsABqfQ7o0CEF+aDaDcccp8-q7RDEO_t4Pm_gNWg@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323329-1025713729-1324966246=:7818"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-1025713729-1324966246=:7818
Content-Type: TEXT/PLAIN; charset=iso-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT

On Tue, 27 Dec 2011, Adam Jiang wrote:

> 2011/12/26 Julia Lawall <julia.lawall@lip6.fr>:
>> Is it reasonable to use devm_kfree in a probe function that fails or a
>> remove function that succeeds?
>
> I cannot catch your question. If the memory is allocated by
> devm_kzalloc(), it is not necessary to release with devm_kfree() at
> all. It would be release once the driver was detached or destroyed.

Perhaps it is undesirable to keep it around until then, as in my last
example below where the probe function seems to want to go with a
different solution in some cases?

I was also worried that one call could make some information required by
another one unavailable.  For example in the following case:

drivers/dma/mpc512x_dma.c

         devm_free_irq(dev, mdma->irq, mdma);
         irq_dispose_mapping(mdma->irq);

Is it OK to call irq_dispose_mapping and then let devm_free_irq be called
implicitly afterwards?

julia



>
>>
>> Examples from drivers/watchdog/shwdt.c:
>>
>> sh_wdt_probe:
>>
>>        ...
>>  out_unreg:
>>        unregister_reboot_notifier(&sh_wdt_notifier);
>>  out_unmap:
>> -       devm_iounmap(&pdev->dev, wdt->base);
>>  out_err:
>> -       devm_kfree(&pdev->dev, wdt);
>
> It is necessary?
>
>>  out_release:
>> -       devm_release_mem_region(&pdev->dev, res->start, resource_size(res));
>
> It is necessary?
>
>>
>>        return rc;
>>  }
>>
>>
>> sh_wdt_remove:
>>
>>        ...
>>        unregister_reboot_notifier(&sh_wdt_notifier);
>>        devm_release_mem_region(&pdev->dev, res->start, resource_size(res));
>>        devm_iounmap(&pdev->dev, wdt->base);
>>        devm_kfree(&pdev->dev, wdt);
>
> These lines should be deleted if the driver has detached.
>
>>
>>        return 0;
>> }
>>
>>
>> On the other hand, perhaps devm_kfree is needed in probe function that
>> succeeds, eg in drivers/input/keyboard/samsung-keypad.c:
>>
>>        if (pdev->dev.of_node) {
>>                devm_kfree(&pdev->dev, (void *)pdata->keymap_data->keymap);
>>                devm_kfree(&pdev->dev, (void *)pdata->keymap_data);
>>                devm_kfree(&pdev->dev, (void *)pdata);
>>        }
>>        return 0;
>>
>> julia
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
> --
> To unsubscribe from this list: send the line "unsubscribe kernel-janitors" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
--8323329-1025713729-1324966246=:7818--
