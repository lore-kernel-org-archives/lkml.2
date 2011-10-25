Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752915Ab1JYGKo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 02:10:44 -0400
Received: from na3sys009aog126.obsmtp.com ([74.125.149.155]:49694 "EHLO
	na3sys009aog126.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752072Ab1JYGKn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 02:10:43 -0400
Message-ID: <4EA652DA.5050901@ti.com>
Date: Tue, 25 Oct 2011 11:40:34 +0530
From: Rajendra Nayak <rnayak@ti.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.20) Gecko/20110805 Thunderbird/3.1.12
MIME-Version: 1.0
To: Shawn Guo <shawn.guo@freescale.com>
CC: Grant Likely <grant.likely@secretlab.ca>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>, patches@linaro.org,
        tony@atomide.com, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org, lrg@ti.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 3/5] regulator: helper routine to extract regulator_init_data
References: <20111020061408.GE32007@S2100-06.ap.freescale.net> <4EA00F7C.1080005@ti.com> <20111021082309.GA337@S2100-06.ap.freescale.net> <20111024092411.GE8708@ponder.secretlab.ca> <20111024130429.GD1755@S2100-06.ap.freescale.net> <20111024130636.GB26033@opensource.wolfsonmicro.com> <20111024134025.GE1755@S2100-06.ap.freescale.net> <20111024135950.GV8708@ponder.secretlab.ca> <20111024145139.GH1755@S2100-06.ap.freescale.net> <20111024145631.GB8708@ponder.secretlab.ca> <20111024155132.GI1755@S2100-06.ap.freescale.net>
In-Reply-To: <20111024155132.GI1755@S2100-06.ap.freescale.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 24 October 2011 09:21 PM, Shawn Guo wrote:
> On Mon, Oct 24, 2011 at 04:56:31PM +0200, Grant Likely wrote:
>> On Mon, Oct 24, 2011 at 10:51:40PM +0800, Shawn Guo wrote:
>>> On Mon, Oct 24, 2011 at 03:59:50PM +0200, Grant Likely wrote:
>>>> On Mon, Oct 24, 2011 at 09:40:26PM +0800, Shawn Guo wrote:
>>>>> diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
>>>>> index 8fe132d..29dcf90 100644
>>>>> --- a/drivers/regulator/core.c
>>>>> +++ b/drivers/regulator/core.c
>>>>> @@ -2673,7 +2673,8 @@ struct regulator_dev *regulator_register(struct regulator_desc *regulator_desc,
>>>>>          BLOCKING_INIT_NOTIFIER_HEAD(&rdev->notifier);
>>>>>
>>>>>          /* find device_node and attach it */
>>>>> -       rdev->dev.of_node = of_find_node_by_name(NULL, regulator_desc->name);
>>>>> +       rdev->dev.of_node = of_find_node_by_name(dev->parent->of_node,
>>>>> +                                                regulator_desc->name);
>>>>
>>>> of_find_node_by_name() doesn't work that way.  The first argument is a
>>>> starting point, but it doesn't restrict the search to children of a
>>>> node.
>>>>
>>>> for_each_child_of_node() is what you want to use when iterating over
>>>> the children which unfortunately changes the structure of this
>>>> function.
>>>>
>>> The dev->parent->of_node is meant to point to node 'pmic: mc13892@0'.
>>> And the intention here is not to iterate over the children, but to
>>> start a search from a reasonable point rather than the top root node.
>>
>> It is always better to attach the of_node at struct device
>> registration time instead of searching the tree in common code.  The
>> of_node should already be assigned by the time regulator_register() is
>> called.
>
> That's the problem we have.  There is no 'struct dev' to attach of_node
> for each regulator by the time regulator_register() is called, because
> the 'struct dev' for each regulator is created inside
> regulator_register() as wrapped by 'struct regulator_dev'.

The root of your problem seems to be that your pmic driver isn't
registering regulator devices from DT, and if it did, you wouldn't
need to do a search in dev->parent->of_node and instead the driver
would have the right dev->of_node populated.

>

