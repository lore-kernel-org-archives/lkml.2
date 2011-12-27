Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753716Ab1L0Cs0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Dec 2011 21:48:26 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:51225 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753114Ab1L0CsU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Dec 2011 21:48:20 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.02.1112261440450.1873@localhost6.localdomain6>
References: <1324661974-17281-1-git-send-email-julia@diku.dk>
	<20111226120855.GB17760@sirena.org.uk>
	<alpine.DEB.2.02.1112261440450.1873@localhost6.localdomain6>
Date: Tue, 27 Dec 2011 11:48:18 +0900
Message-ID: <CALK_+D35jwxsABqfQ7o0CEF+aDaDcccp8-q7RDEO_t4Pm_gNWg@mail.gmail.com>
Subject: Re: devm_kfree
From: Adam Jiang <jiang.adam@gmail.com>
To: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/12/26 Julia Lawall <julia.lawall@lip6.fr>:
> Is it reasonable to use devm_kfree in a probe function that fails or a
> remove function that succeeds?

I cannot catch your question. If the memory is allocated by
devm_kzalloc(), it is not necessary to release with devm_kfree() at
all. It would be release once the driver was detached or destroyed.

>
> Examples from drivers/watchdog/shwdt.c:
>
> sh_wdt_probe:
>
>        ...
>  out_unreg:
>        unregister_reboot_notifier(&sh_wdt_notifier);
>  out_unmap:
> -       devm_iounmap(&pdev->dev, wdt->base);
>  out_err:
> -       devm_kfree(&pdev->dev, wdt);

It is necessary?

>  out_release:
> -       devm_release_mem_region(&pdev->dev, res->start, resource_size(res));

It is necessary?

>
>        return rc;
>  }
>
>
> sh_wdt_remove:
>
>        ...
>        unregister_reboot_notifier(&sh_wdt_notifier);
>        devm_release_mem_region(&pdev->dev, res->start, resource_size(res));
>        devm_iounmap(&pdev->dev, wdt->base);
>        devm_kfree(&pdev->dev, wdt);

These lines should be deleted if the driver has detached.

>
>        return 0;
> }
>
>
> On the other hand, perhaps devm_kfree is needed in probe function that
> succeeds, eg in drivers/input/keyboard/samsung-keypad.c:
>
>        if (pdev->dev.of_node) {
>                devm_kfree(&pdev->dev, (void *)pdata->keymap_data->keymap);
>                devm_kfree(&pdev->dev, (void *)pdata->keymap_data);
>                devm_kfree(&pdev->dev, (void *)pdata);
>        }
>        return 0;
>
> julia
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
