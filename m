Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753067Ab3AFIln (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2013 03:41:43 -0500
Received: from mail1-relais-roc.national.inria.fr ([192.134.164.82]:21365 "EHLO
	mail1-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751892Ab3AFIlj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2013 03:41:39 -0500
X-IronPort-AV: E=Sophos;i="4.84,419,1355094000"; 
   d="scan'208";a="188602816"
Date: Sun, 6 Jan 2013 09:41:36 +0100 (CET)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@localhost6.localdomain6
To: Anton Vorontsov <anton@enomsg.org>
cc: kernel-janitors@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/power/88pm860x_battery.c: use
 devm_request_threaded_irq
In-Reply-To: <20130106050953.GH6919@lizard.sbx05280.losalca.wayport.net>
Message-ID: <alpine.DEB.2.02.1301060941110.2070@localhost6.localdomain6>
References: <1354986995-2324-1-git-send-email-Julia.Lawall@lip6.fr> <20130106050953.GH6919@lizard.sbx05280.losalca.wayport.net>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 5 Jan 2013, Anton Vorontsov wrote:

> On Sat, Dec 08, 2012 at 06:16:35PM +0100, Julia Lawall wrote:
>> From: Julia Lawall <Julia.Lawall@lip6.fr>
>>
>> devm_request_threaded_irq requests and irq that is freed when a driver
>> detaches.  This patch uses devm_request_threaded_irq for irqs that are
>> requested in the probe function of a platform device and are only freed in
>> the remove function.
>>
>> Additionally, the original code used devm_kzalloc, but kfree.  This would
>> lead to a double free.  The problem was found using the following semantic
>> match (http://coccinelle.lip6.fr/):
>>
>> // <smpl>
>> @@
>> expression x,e;
>> @@
>> x = devm_kzalloc(...)
>> ... when != x = e
>> ?-kfree(x,...);
>> // </smpl>
>>
>> The error handling code in the probe function is also simplified in the
>> cases where there is now nothing to do other than return.
>>
>> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
>>
>> ---
> [....]
>> @@ -994,9 +989,6 @@ static int pm860x_battery_remove(struct platform_device *pdev)
>>  	struct pm860x_battery_info *info = platform_get_drvdata(pdev);
>>
>>  	power_supply_unregister(&info->battery);
>> -	free_irq(info->irq_batt, info);
>> -	free_irq(info->irq_cc, info);
>> -	kfree(info);
>
> It is not safe to access battery ('struct power_supply') object after
> _unregister() (and irq handlers will surely do). Instead of removing
> free_irq(), the right fix would be to place the two calls before
> _unregister().

Thanks for the feedback.  I will send a new patch.

julia
