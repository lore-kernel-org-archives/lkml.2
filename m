Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966089Ab2EOSPe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 14:15:34 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:63710 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964860Ab2EOSPc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 14:15:32 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6712"; a="191182879"
Message-ID: <4FB29D43.2040300@codeaurora.org>
Date: Tue, 15 May 2012 11:15:31 -0700
From: Saravana Kannan <skannan@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Sascha Hauer <s.hauer@pengutronix.de>
CC: "Turquette, Mike" <mturquette@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        andrew@lunn.ch, rnayak@ti.com
Subject: Re: [PATCH] clk: Constify struct clk_init_data
References: <1337004763-21250-1-git-send-email-broonie@opensource.wolfsonmicro.com> <20120514215304.GB3075@gmail.com> <4FB1AF14.3050507@codeaurora.org> <20120515070058.GK30400@pengutronix.de> <4FB2875C.6030402@codeaurora.org>
In-Reply-To: <4FB2875C.6030402@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/15/2012 09:42 AM, Saravana Kannan wrote:
> On 05/15/2012 12:00 AM, Sascha Hauer wrote:
>> On Mon, May 14, 2012 at 06:19:16PM -0700, Saravana Kannan wrote:
>>> On 05/14/2012 02:53 PM, Turquette, Mike wrote:
>>>> On Mon, May 14, 2012 at 7:12 AM, Mark
>>>> Brown<broonie@opensource.wolfsonmicro.com> wrote:
>>>>> Allow drivers to declare their clk_init_data const, the framework
>>>>> really
>>>>> shouldn't be modifying the data.
>>>>>
>>>>> Signed-off-by: Mark Brown<broonie@opensource.wolfsonmicro.com>
>>>>
>>>> +interested parties
>>>>
>>>>>
>>>>> diff --git a/include/linux/clk-provider.h
>>>>> b/include/linux/clk-provider.h
>>>>> index c1c23b9..fc43ea6 100644
>>>>> --- a/include/linux/clk-provider.h
>>>>> +++ b/include/linux/clk-provider.h
>>>>> @@ -143,7 +143,7 @@ struct clk_init_data {
>>>>> */
>>>>> struct clk_hw {
>>>>> struct clk *clk;
>>>>> - struct clk_init_data *init;
>>>>> + const struct clk_init_data *init;
>>>
>>> Oh, wait. This won't work for the case where the clock registration
>>> is completely dynamic. Say, created from device tree or thru some
>>> PCI/USB device probe, etc. That's why I didn't add it before.
>>
>> Why not? In this case clk_init_data is also only used in clk_register.
>> Given that Mark has posted the patch I assume it actually works.
>>
>> Sascha
>>
>
> It's used in __clk_register() though. Which I added as a "as close as
> clk_register() but allows static init" function.
>

Sorry about my rushed responses earlier. I don't think the const will 
work even when purely using clk_register().

Say I use device tree (you can extend this to HW probing/detection) to 
know that there is a fixed factor clock. Now, if I want to dynamically 
create and register it, I will have to allocate struct clk_fixed_factor 
and struct clk_init_data. Then populate the fields of those structs and 
finally point clk_fixed_factor.hw.init to the allocated clk_init_data. 
Then call clk_register on clk_fixed_factor.hw. I'm not sure the 
assigning of the init field above will be possible if we mark it as const.

Really though, not marking it as const shouldn't really have a huge 
impact. What matters is that the common clock framework shouldn't try to 
use it after clk_register() and we can do that by following what Russell 
suggested (set hw.init to NULL at the end of clk_register).

Does that make sense?

Thanks,
Saravana

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
