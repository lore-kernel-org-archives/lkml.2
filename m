Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755504Ab1LZNpG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Dec 2011 08:45:06 -0500
Received: from mail1-relais-roc.national.inria.fr ([192.134.164.82]:43734 "EHLO
	mail1-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755477Ab1LZNpB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Dec 2011 08:45:01 -0500
X-IronPort-AV: E=Sophos;i="4.71,410,1320620400"; 
   d="scan'208";a="136887692"
Date: Mon, 26 Dec 2011 14:44:58 +0100 (CET)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@localhost6.localdomain6
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
cc: Julia Lawall <julia@diku.dk>, Samuel Ortiz <sameo@linux.intel.com>,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: devm_kfree
In-Reply-To: <20111226120855.GB17760@sirena.org.uk>
Message-ID: <alpine.DEB.2.02.1112261440450.1873@localhost6.localdomain6>
References: <1324661974-17281-1-git-send-email-julia@diku.dk> <20111226120855.GB17760@sirena.org.uk>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Is it reasonable to use devm_kfree in a probe function that fails or a 
remove function that succeeds?

Examples from drivers/watchdog/shwdt.c:

sh_wdt_probe:

 	...
  out_unreg:
         unregister_reboot_notifier(&sh_wdt_notifier);
  out_unmap:
-       devm_iounmap(&pdev->dev, wdt->base);
  out_err:
-       devm_kfree(&pdev->dev, wdt);
  out_release:
-       devm_release_mem_region(&pdev->dev, res->start, 
resource_size(res));

         return rc;
  }


sh_wdt_remove:

 	...
         unregister_reboot_notifier(&sh_wdt_notifier);
         devm_release_mem_region(&pdev->dev, res->start, resource_size(res));
         devm_iounmap(&pdev->dev, wdt->base);
         devm_kfree(&pdev->dev, wdt);

 	return 0;
}


On the other hand, perhaps devm_kfree is needed in probe function that 
succeeds, eg in drivers/input/keyboard/samsung-keypad.c:

         if (pdev->dev.of_node) {
                 devm_kfree(&pdev->dev, (void *)pdata->keymap_data->keymap);
                 devm_kfree(&pdev->dev, (void *)pdata->keymap_data);
                 devm_kfree(&pdev->dev, (void *)pdata);
         }
         return 0;

julia
