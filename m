Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751814Ab2KZFLb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 00:11:31 -0500
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:56594 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750895Ab2KZFLa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 00:11:30 -0500
X-AuditID: 9c93016f-b7b42ae000004383-2a-50b2fa00cb30
Message-ID: <50B2F9FF.9070308@lge.com>
Date: Mon, 26 Nov 2012 14:11:27 +0900
From: Bongkyu Kim <bongkyu.kim@lge.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Rob Herring <robherring2@gmail.com>
CC: grant.likely@secretlab.ca, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] of/i2c: support more interrupt specifiers
References: <1353488322-14764-1-git-send-email-bongkyu.kim@lge.com> <50ACD9F2.40207@gmail.com>
In-Reply-To: <50ACD9F2.40207@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/21/2012 10:41 PM, Rob Herring wrote:
> On 11/21/2012 02:58 AM, Bongkyu Kim wrote:
>> This patch supports more interrupt specifiers for i2c client.
> 
> Why?
> 

If we are registering a device has 2 interrupts like the below,
	i2c@f9968000 {
		lsm330_acc@1D {
			compatible = "ST,lsm330_acc",
			/* #interrupt-cells = <2> */
			interrupts = <73 0x2 65 0x2>,
		};
	};

we can't use second irq(65) in a driver because of mapping first
interrupt only.
If second irq(65) is mapped, we can use by gpio_to_irq() function at a
driver.
So, I think that all interrupt specifiers should be parsed and mapped
if DT's interrupts property is allowed several interrupt specifiers.

>> Signed-off-by: Bongkyu Kim <bongkyu.kim@lge.com>
>> ---
>>  drivers/of/of_i2c.c | 5 ++++-
>>  1 file changed, 4 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/of/of_i2c.c b/drivers/of/of_i2c.c
>> index 3550f3b..c6d9b7e 100644
>> --- a/drivers/of/of_i2c.c
>> +++ b/drivers/of/of_i2c.c
>> @@ -34,6 +34,7 @@ void of_i2c_register_devices(struct i2c_adapter *adap)
>>  		struct dev_archdata dev_ad = {};
>>  		const __be32 *addr;
>>  		int len;
>> +		int nr = 0;
>>  
>>  		dev_dbg(&adap->dev, "of_i2c: register %s\n", node->full_name);
>>  
>> @@ -57,7 +58,9 @@ void of_i2c_register_devices(struct i2c_adapter *adap)
>>  			continue;
>>  		}
>>  
>> -		info.irq = irq_of_parse_and_map(node, 0);
>> +		info.irq = irq_of_parse_and_map(node, nr++);
>> +		while (irq_of_parse_and_map(node, nr))
>> +			nr++;
> 
> What's the point if you are just discarding the interrupt number? If
> this is needed, then shouldn't you fix i2c_board_info first?
> 
> Rob
> 

It is better that i2c_board_info will be fixed.
But, if it will be fixed, all i2c client drivers should be changed.
I think there're so many i2c drivers currently.
In my opinion, do not assign to i2c_board_info and just map for all
interrupts is the better.

Thanks,
Bongkyu.

>>  		info.of_node = of_node_get(node);
>>  		info.archdata = &dev_ad;
>>  
>>
> 

