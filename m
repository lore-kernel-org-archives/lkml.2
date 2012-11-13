Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753617Ab2KMNSp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 08:18:45 -0500
Received: from mail-ob0-f174.google.com ([209.85.214.174]:45398 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751827Ab2KMNSn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 08:18:43 -0500
Message-ID: <50A248AD.9000705@gmail.com>
Date: Tue, 13 Nov 2012 07:18:37 -0600
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Wolfram Sang <w.sang@pengutronix.de>
CC: Andreas Larsson <andreas@gaisler.com>, Ben Dooks <ben-linux@fluff.org>,
        Peter Korsgaard <jacmet@sunsite.dk>, linux-i2c@vger.kernel.org,
        Grant Likely <grant.likely@secretlab.ca>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        software@gaisler.com
Subject: Re: [PATCH v2 1/2] i2c: i2c-ocores: Add irq support for sparc
References: <1352739591-1317-1-git-send-email-andreas@gaisler.com> <1352739591-1317-2-git-send-email-andreas@gaisler.com> <20121113111055.GF23119@pengutronix.de>
In-Reply-To: <20121113111055.GF23119@pengutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 11/13/2012 05:10 AM, Wolfram Sang wrote:
> Hi,
> 
> On Mon, Nov 12, 2012 at 05:59:50PM +0100, Andreas Larsson wrote:
>> Add sparc support by using platform_get_irq instead of platform_get_resource.
>> There are no platform resources of type IORESOURCE_IRQ for sparc, but
>> platform_get_irq works for sparc. In the non-sparc case platform_get_irq
>> internally uses platform_get_resource.
>>
>> Signed-off-by: Andreas Larsson <andreas@gaisler.com>
>> Acked-by: Peter Korsgaard <jacmet@sunsite.dk>
>> ---
>> Changes since v1:
>>  - platform_get_irq now works for sparc, so that is used for all platforms
>>  - Acked by Peter Korsgaard <jacmet@sunsite.dk>
>>
>>  drivers/i2c/busses/i2c-ocores.c |    9 +++++----
>>  1 files changed, 5 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/i2c/busses/i2c-ocores.c b/drivers/i2c/busses/i2c-ocores.c
>> index bffd550..0b71dc6 100644
>> --- a/drivers/i2c/busses/i2c-ocores.c
>> +++ b/drivers/i2c/busses/i2c-ocores.c
>> @@ -267,7 +267,8 @@ static int __devinit ocores_i2c_probe(struct platform_device *pdev)
>>  {
>>  	struct ocores_i2c *i2c;
>>  	struct ocores_i2c_platform_data *pdata;
>> -	struct resource *res, *res2;
>> +	struct resource *res;
>> +	int irq;
>>  	int ret;
>>  	int i;
>>  
>> @@ -275,8 +276,8 @@ static int __devinit ocores_i2c_probe(struct platform_device *pdev)
>>  	if (!res)
>>  		return -ENODEV;
>>  
>> -	res2 = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
>> -	if (!res2)
>> +	irq = platform_get_irq(pdev, 0);
>> +	if (irq < 0)
>>  		return -ENODEV;
> 
> Why not pass the error code you got?

I believe that should actually be a check for 'irq <= 0' as it returns
NO_IRQ on error.

>>  
>>  	i2c = devm_kzalloc(&pdev->dev, sizeof(*i2c), GFP_KERNEL);
>> @@ -313,7 +314,7 @@ static int __devinit ocores_i2c_probe(struct platform_device *pdev)
>>  	ocores_init(i2c);
>>  
>>  	init_waitqueue_head(&i2c->wait);
>> -	ret = devm_request_irq(&pdev->dev, res2->start, ocores_isr, 0,
>> +	ret = devm_request_irq(&pdev->dev, irq, ocores_isr, 0,
>>  			       pdev->name, i2c);
>>  	if (ret) {
>>  		dev_err(&pdev->dev, "Cannot claim IRQ\n");
> 
> Rest looks good.
> 
