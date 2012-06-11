Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752481Ab2FKFFP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 01:05:15 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:54643 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751263Ab2FKFFN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 01:05:13 -0400
MIME-version: 1.0
Content-transfer-encoding: 8BIT
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfee61b-b7fcc6d000003a7a-62-4fd57c872978
Message-id: <4FD57C87.7000404@samsung.com>
Date: Mon, 11 Jun 2012 14:05:11 +0900
From: jonghwa3.lee@samsung.com
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.2) Gecko/20120216
 Thunderbird/10.0.2
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, Mike Turquette <mturquette@linaro.org>,
        H Hartley Sweeten <hsweetn@visionengravers.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH] clock: max77686: Add driver for Maxim 77686 32KHz crystal
 oscillator
References: <1338541736-2978-1-git-send-email-jonghwa3.lee@samsung.com>
 <201206011613.33706.arnd@arndb.de>
In-reply-to: <201206011613.33706.arnd@arndb.de>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrBLMWRmVeSWpSXmKPExsVy+t9jAd32mqv+BjMvWVpc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6MpzM/Mha0ildsfdbA2MA4R6iLkZNDQsBE4t7v58wQtpjEhXvr
	2boYuTiEBBYxSszdu54FJMErICjxY/I9IJuDg1lAXuLIpWyQMLOAusSkeYuYIer7mCS+t95l
	h6jXktjfeBzMZhFQlfi25guYzSYgJ/G26RsjyBxRgQiJX/0cIGERAUWJqS+egc1hFmhnkni0
	YzMTSEJYIFpix7KNjCC2kECOxPvzS9lAbE4BfYlru9tZJjAKzEJy3iyE82YhOW8BI/MqRtHU
	guSC4qT0XCO94sTc4tK8dL3k/NxNjODweya9g3FVg8UhRgEORiUeXofcq/5CrIllxZW5hxgl
	OJiVRHi3VQCFeFMSK6tSi/Lji0pzUosPMUpzsCiJ8zZZX/AXEkhPLEnNTk0tSC2CyTJxcEo1
	MC500VfuX34wNdkpcY/vCx/12ttG95amx+jvbDrlVv6j/e7aD8/nlc/5kskofbbl/sTbTPZ3
	Zotbd31YOZW1IkklXPN5x898cwVZ1crqxWcN+LNuyO0/Nzf8XMApRo3paU3HQ8uVHb6USSeK
	9k5vjuk8uciySv7ssiVi97O3bHjAwbBd8IqXohJLcUaioRZzUXEiAEmQoFA7AgAA
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Arnd.
Sorry for that reply is late. I had some personal reasons so i couldn't
check e-mail all last week. I just read your comments today.

On 2012년 06월 02일 01:13, Arnd Bergmann wrote:

> On Friday 01 June 2012, Jonghwa Lee wrote:
>> +
>> +#ifdef COMMON_CONFIG_CLK
> 
> Two comments on this one:
> 
> 1. It should be CONFIG_COMMON_CLK, not COMMON_CONFIG_CLK, I suppose. The symbol
> you are testing for is never defined so your code does not even get built.
> I suppose you did not test the version you are sending ...
> 
> 2. There is no use in enclosing an entire file in #ifdef. Instead, make the Kconfig
> symbol depend on COMMON_CLK.
> 


I did build test only without #ifdef statement before upload. And i
wrote this line right before send the code. I made mistake at that time.
Anyway, I'll change this condition as you commented.

>> +#define to_max77686_clk(__name)		container_of(hw,		\
>> +					struct max77686_clk, __name)
> 
> This use of container_of() is very unusual and confusing, because the argument
> into your macro is the member of the struct, not the variable that you are basing
> from. You should not need the macro at all, so please try to remove it.
> 


Yes, i agree that this macro makes some confuse.

>> +struct max77686_clk {
>> +	struct max77686_dev *iodev;
>> +	struct clk_hw clk32khz_ap_hw;
>> +	struct clk_hw clk32khz_cp_hw;
>> +	struct clk_hw clk32khz_pmic_hw;
>> +};
>> +
>> +static struct clk *clk32khz_ap;
>> +static struct clk *clk32khz_cp;
>> +static struct clk *clk32khz_pmic;
>> +static char *max77686_clk[] = {
>> +	"32khap",
>> +	"32khcp",
>> +	"p32kh",
>> +};
> 
> With these static definitions, you can only have a single max77686 device in the
> system. Better remove these symbols.


Okay, I'll apply it.

> 
>> +static struct max77686_clk *get_max77686_clk(struct clk_hw *hw)
>> +{
>> +	struct clk *clk = hw->clk;
>> +	if (clk == clk32khz_ap)
>> +		return to_max77686_clk(clk32khz_ap_hw);
>> +	else if (clk == clk32khz_cp)
>> +		return to_max77686_clk(clk32khz_cp_hw);
>> +	else if (clk == clk32khz_pmic)
>> +		return to_max77686_clk(clk32khz_pmic_hw);
>> +	else
>> +		return NULL;
>> +}
> 
> I can only assume that you meant this to be
> 
> struct max77686_clk {
> 	struct max77686_dev *iodev;
> 	u32 mask;
> 	struct clk_hw hw;
> };
> static struct max77686_clk *get_max77686_clk(struct clk_hw *hw)
> {
> 	return container_of(hw, struct max77686_clk, hw)->iodev;
> }
> 
> You probably misunderstood the person who was suggesting you use
> container_of(). Note that this function is so simple that you
> probably don't even need it: just open-code the container_of.
>


I think to_max77686_clk macro makes you uncomfortable, I'll modify them
with considering your comments. And your get_max77668_clk() return wrong
type pointer since it has to return struct max77696_clk pointer.

 

Thanks.
