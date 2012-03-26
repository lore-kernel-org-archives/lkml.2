Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932854Ab2CZPgb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 11:36:31 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:37821 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932637Ab2CZPg3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 11:36:29 -0400
MIME-Version: 1.0
In-Reply-To: <4F706947.2080405@gmail.com>
References: <CAJuYYwS5Srw2-D6hdk=-=YN3iB37+KTWVqQPPPVbb-e7it+uVQ@mail.gmail.com>
	<1332679129-23864-1-git-send-email-thomas.abraham@linaro.org>
	<4F6F37B6.3050506@gmail.com>
	<CAJuYYwTzx8+J9oMRd7kJ=Qp5V4v0LVUYxdkAe8dMqVji0Dk4yg@mail.gmail.com>
	<4F706947.2080405@gmail.com>
Date: Mon, 26 Mar 2012 21:06:28 +0530
Message-ID: <CAJuYYwRxCTWxnof1HUqYVX4mbzWCxcab69CJyKxOh13bQbQ_5Q@mail.gmail.com>
Subject: Re: [PATCH] of/irq: of_irq_init: Call initialization function for all controllers
From: Thomas Abraham <thomas.abraham@linaro.org>
To: Rob Herring <robherring2@gmail.com>
Cc: devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, rob.herring@calxeda.com,
        patches@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26 March 2012 18:34, Rob Herring <robherring2@gmail.com> wrote:
> On 03/25/2012 11:16 AM, Thomas Abraham wrote:
>> On 25 March 2012 20:50, Rob Herring <robherring2@gmail.com> wrote:
>>> On 03/25/2012 07:38 AM, Thomas Abraham wrote:
>>>> The of_irq_init function stops processing the interrupt controller hierarchy
>>>> when there are no more interrupt controller parents identified. Though this
>>>> condition suffices most cases, there are cases where a interrupt controller's
>>>> parent controller does not participate in the initialization of the interrupt
>>>> hierarchy. An example of such a case is the use of a interrupt nexus node
>>>> by a interrupt controller node which delivers interrupts to separate interrupt
>>>> parent controllers.
>>>>
>>>> Instead of stopping the processing of interrupt controller hierarchy in such
>>>> a case, the orphan interrupt controller node's descriptor can be identified
>>>> and its 'logical' parent in the descriptor is set as NULL. The processing of
>>>> interrupt hierarchy is then restarted by looking for descriptors which have
>>>> a NULL interrupt parent.
>>>>
>>>> Cc: Rob Herring <rob.herring@calxeda.com>
>>>> Cc: Grant Likely <grant.likely@secretlab.ca>
>>>> Signed-off-by: Thomas Abraham <thomas.abraham@linaro.org>
>>>> ---
>>>
>>> Wouldn't this accomplish the same thing? You just need to add the
>>> wakeup-map node name to your matches list.
>>>
>>>
>>> diff --git a/drivers/of/irq.c b/drivers/of/irq.c
>>> index 9cf0060..deeaf00 100644
>>> --- a/drivers/of/irq.c
>>> +++ b/drivers/of/irq.c
>>> @@ -416,8 +416,6 @@ void __init of_irq_init(const struct of_device_id
>>> *matches)
>>>        INIT_LIST_HEAD(&intc_parent_list);
>>>
>>>        for_each_matching_node(np, matches) {
>>> -               if (!of_find_property(np, "interrupt-controller", NULL))
>>> -                       continue;
>>>                /*
>>>                 * Here, we allocate and populate an intc_desc with the node
>>>                 * pointer, interrupt-parent device_node etc.
>>>
>>
>> Hi Rob,
>>
>> I tested with this, but the init function of wakeup controller is not
>> called. The following is the example nodes that I used for testing.
>>
>>  gic:interrupt-controller@10490000 {
>>                compatible = "arm,cortex-a9-gic";
>>                #interrupt-cells = <3>;
>>                #address-cells = <0>;
>>                #size-cells = <0>;
>>                interrupt-controller;
>>                cpu-offset = <0x8000>;
>>                reg = <0x10490000 0x1000>, <0x10480000 0x100>;
>>        };
>>
>>        combiner:interrupt-controller@10440000 {
>>                compatible = "samsung,exynos4210-combiner";
>>                #interrupt-cells = <2>;
>>                interrupt-controller;
>>                samsung,combiner-nr = <16>;
>>                reg = <0x10440000 0x1000>;
>>                interrupts = <0 0 0>, <0 1 0>, <0 2 0>, <0 3 0>,
>>                             <0 4 0>, <0 5 0>, <0 6 0>, <0 7 0>,
>>                             <0 8 0>, <0 9 0>, <0 10 0>, <0 11 0>,
>>                             <0 12 0>, <0 13 0>, <0 14 0>, <0 15 0>;
>>        };
>>
>>        wakeup_eint: interrupt-controller@11400000 {
>>                compatible = "samsung,exynos5210-wakeup-eint";
>>                reg = <0x11400000 0x1000>;
>>                interrupt-controller;
>>                #interrupt-cells = <2>;
>>                interrupt-parent = <&wakeup_map>;
>>                interrupts = <0x0 0>, <0x1 0>, <0x2 0>, <0x3 0>,
>>                             <0x4 0>, <0x5 0>, <0x6 0>, <0x7 0>,
>>                             <0x8 0>, <0x9 0>, <0xa 0>, <0xb 0>,
>>                             <0xc 0>, <0xd 0>, <0xe 0>, <0xf 0>,
>>                             <0x10 0>;
>>
>>                wakeup_map: interrupt-map {
>>                        compatible = "samsung,exynos5210-wakeup-eint-map";
>>                        #interrupt-cells = <2>;
>>                        #address-cells = <0>;
>>                        #size-cells = <0>;
>>                        interrupt-map = <0x0 0 &gic 0 16 0>,
>>                                        <0x1 0 &gic 0 17 0>,
>>                                        <0x2 0 &gic 0 18 0>,
>>                                        <0x3 0 &gic 0 19 1>,
>>                                        <0x4 0 &gic 0 20 0>,
>>                                        <0x5 0 &gic 0 21 1>,
>>                                        <0x6 0 &gic 0 22 0>,
>>                                        <0x7 0 &gic 0 23 1>,
>>                                        <0x8 0 &gic 0 24 0>,
>>                                        <0x9 0 &gic 0 25 1>,
>>                                        <0xa 0 &gic 0 26 0>,
>>                                        <0xb 0 &gic 0 27 1>,
>>                                        <0xc 0 &gic 0 28 0>,
>>                                        <0xd 0 &gic 0 29 1>,
>>                                        <0xe 0 &gic 0 30 0>,
>>                                        <0xf 0 &gic 0 31 1>,
>>                                        <0x10 0 &combiner 2 4>;
>>                };
>>        };
>>
>> And following is the match table used for testing.
>>
>> static const struct of_device_id exynos4_dt_irq_match[] = {
>>        { .compatible = "arm,cortex-a9-gic", .data = gic_of_init, },
>>        { .compatible = "samsung,exynos4210-combiner",
>>                        .data = combiner_of_init, },
>>        { .compatible = "samsung,exynos4210-wakeup-eint-map",
>
> Looks like you have a mismatch here: 5210 or 4210?

Sorry, that was a typo. I checked the code again. It is 4210.

>
>
>>                        .data = exynos_init_irq_eint, },
>>        {},
>> };
>>
>> The ' interrupt-map' map sub-node of 'interrupt-controller@11400000'
>> node does not have a interrupt-parent property. So it inherits it from
>> its parent node, which is 'interrupt-map' itself. So the parent of
>> wakeup-map is not gic or combiner and hence the initialization
>> function of wakeup controller is not called.
>>
>
> That should be fine. If a node's interrupt-parent is itself, then that's
> treated as a root interrupt controller.

I checked this again and found that of_irq_find_parent() function when
called with pointer to "interrupt-map" node as the parameter, does not
return "interrupt-map" as the parent in the example nodes listed
above. This might be wrong and may be caused due to the check

of_get_property(p, "#interrupt-cells", NULL) == NULL

in the do..while loop in of_irq_find_parent() function. So this
explains why the 'interrupt-map' was not treated as the root interrupt
controller.

>
>> If a interrupt-parent property is added to 'interrupt-map' node (which
>> is probably not the right thing to do), and set the interrupt parent
>> as gic or combiner, there is a possibility that the interrupt-map is
>> initialized before the combiner (which is not correct since
>> interrupt-map uses combiner as one of its parents). But by placing
>> 'wakeup_eint' node ahead of combiner node, this can be overcome but
>> relying on placement of nodes in dts file is not a reliable solution.
>
> Your fix doesn't really guarantee the proper order either. It's still a
> side effect of the implementation. Perhaps a retry mechanism would work.
> Then the init for wakeup_eint can retry if the gic is not yet setup.

Ok. A retry mechanism would be most robust solution for this case.

Thanks,
Thomas.

[...]
