Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934509Ab2JaJmO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 05:42:14 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:20891 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752054Ab2JaJmI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 05:42:08 -0400
Message-ID: <50910086.6080705@atmel.com>
Date: Wed, 31 Oct 2012 11:42:14 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Joachim Eastwood <manabian@gmail.com>
CC: <netdev@vger.kernel.org>, <davem@davemloft.net>, <havard@skinnemoen.net>,
        <bhutchings@solarflare.com>, <linux-arm-kernel@lists.infradead.org>,
        <plagnioj@jcrosoft.com>, <patrice.vilchez@atmel.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 10/10] net/macb: add pinctrl consumer support
References: <cover.1351591858.git.nicolas.ferre@atmel.com> <3269426bdd44debc00d027651f8248db9d40f3dc.1351591858.git.nicolas.ferre@atmel.com> <CAGhQ9VxJ58ej3j9eEx1rex5h-ua_C53=Z4WwGk5YdjfaYTdHpw@mail.gmail.com>
In-Reply-To: <CAGhQ9VxJ58ej3j9eEx1rex5h-ua_C53=Z4WwGk5YdjfaYTdHpw@mail.gmail.com>
X-Enigmail-Version: 1.4.5
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/30/2012 06:37 PM, Joachim Eastwood :
> On 30 October 2012 11:18, Nicolas Ferre <nicolas.ferre@atmel.com> wrote:
>> From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
>>
>> If no pinctrl available just report a warning as some architecture may not
>> need to do anything.
>>
>> Signed-off-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
>> [nicolas.ferre@atmel.com: adapt the error path]
>> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
>> Cc: netdev@vger.kernel.org
>> ---
>>  drivers/net/ethernet/cadence/macb.c | 13 +++++++++++++
>>  1 file changed, 13 insertions(+)
>>
>> diff --git a/drivers/net/ethernet/cadence/macb.c b/drivers/net/ethernet/cadence/macb.c
>> index 4d51877..eae3d74 100644
>> --- a/drivers/net/ethernet/cadence/macb.c
>> +++ b/drivers/net/ethernet/cadence/macb.c
>> @@ -26,6 +26,9 @@
>>  #include <linux/of.h>
>>  #include <linux/of_device.h>
>>  #include <linux/of_net.h>
>> +#include <linux/of_gpio.h>
>> +#include <linux/gpio.h>
> Why are these two headers added?
> I don't see anything from them used in the code added.
> 
> Wouldn't the pinctrl header by itself be sufficient?

It is: I will remove the two unneeded headers in my v4 patch series.

Thanks,

> 
>> +#include <linux/pinctrl/consumer.h>
>>
>>  #include "macb.h"
>>
>> @@ -1472,6 +1475,7 @@ static int __init macb_probe(struct platform_device *pdev)
>>         struct phy_device *phydev;
>>         u32 config;
>>         int err = -ENXIO;
>> +       struct pinctrl *pinctrl;
>>
>>         regs = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>>         if (!regs) {
>> @@ -1479,6 +1483,15 @@ static int __init macb_probe(struct platform_device *pdev)
>>                 goto err_out;
>>         }
>>
>> +       pinctrl = devm_pinctrl_get_select_default(&pdev->dev);
>> +       if (IS_ERR(pinctrl)) {
>> +               err = PTR_ERR(pinctrl);
>> +               if (err == -EPROBE_DEFER)
>> +                       goto err_out;
>> +
>> +               dev_warn(&pdev->dev, "No pinctrl provided\n");
>> +       }
>> +
>>         err = -ENOMEM;
>>         dev = alloc_etherdev(sizeof(*bp));
>>         if (!dev)

Best regards,
-- 
Nicolas Ferre
