Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757341Ab2CZNEZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 09:04:25 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:47051 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756950Ab2CZNEY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 09:04:24 -0400
Message-ID: <4F706947.2080405@gmail.com>
Date: Mon, 26 Mar 2012 08:04:07 -0500
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120310 Thunderbird/11.0
MIME-Version: 1.0
To: Thomas Abraham <thomas.abraham@linaro.org>
CC: devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, rob.herring@calxeda.com,
        patches@linaro.org
Subject: Re: [PATCH] of/irq: of_irq_init: Call initialization function for
 all controllers
References: <CAJuYYwS5Srw2-D6hdk=-=YN3iB37+KTWVqQPPPVbb-e7it+uVQ@mail.gmail.com> <1332679129-23864-1-git-send-email-thomas.abraham@linaro.org> <4F6F37B6.3050506@gmail.com> <CAJuYYwTzx8+J9oMRd7kJ=Qp5V4v0LVUYxdkAe8dMqVji0Dk4yg@mail.gmail.com>
In-Reply-To: <CAJuYYwTzx8+J9oMRd7kJ=Qp5V4v0LVUYxdkAe8dMqVji0Dk4yg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/25/2012 11:16 AM, Thomas Abraham wrote:
> On 25 March 2012 20:50, Rob Herring <robherring2@gmail.com> wrote:
>> On 03/25/2012 07:38 AM, Thomas Abraham wrote:
>>> The of_irq_init function stops processing the interrupt controller hierarchy
>>> when there are no more interrupt controller parents identified. Though this
>>> condition suffices most cases, there are cases where a interrupt controller's
>>> parent controller does not participate in the initialization of the interrupt
>>> hierarchy. An example of such a case is the use of a interrupt nexus node
>>> by a interrupt controller node which delivers interrupts to separate interrupt
>>> parent controllers.
>>>
>>> Instead of stopping the processing of interrupt controller hierarchy in such
>>> a case, the orphan interrupt controller node's descriptor can be identified
>>> and its 'logical' parent in the descriptor is set as NULL. The processing of
>>> interrupt hierarchy is then restarted by looking for descriptors which have
>>> a NULL interrupt parent.
>>>
>>> Cc: Rob Herring <rob.herring@calxeda.com>
>>> Cc: Grant Likely <grant.likely@secretlab.ca>
>>> Signed-off-by: Thomas Abraham <thomas.abraham@linaro.org>
>>> ---
>>
>> Wouldn't this accomplish the same thing? You just need to add the
>> wakeup-map node name to your matches list.
>>
>>
>> diff --git a/drivers/of/irq.c b/drivers/of/irq.c
>> index 9cf0060..deeaf00 100644
>> --- a/drivers/of/irq.c
>> +++ b/drivers/of/irq.c
>> @@ -416,8 +416,6 @@ void __init of_irq_init(const struct of_device_id
>> *matches)
>>        INIT_LIST_HEAD(&intc_parent_list);
>>
>>        for_each_matching_node(np, matches) {
>> -               if (!of_find_property(np, "interrupt-controller", NULL))
>> -                       continue;
>>                /*
>>                 * Here, we allocate and populate an intc_desc with the node
>>                 * pointer, interrupt-parent device_node etc.
>>
> 
> Hi Rob,
> 
> I tested with this, but the init function of wakeup controller is not
> called. The following is the example nodes that I used for testing.
> 
>  gic:interrupt-controller@10490000 {
>                compatible = "arm,cortex-a9-gic";
>                #interrupt-cells = <3>;
>                #address-cells = <0>;
>                #size-cells = <0>;
>                interrupt-controller;
>                cpu-offset = <0x8000>;
>                reg = <0x10490000 0x1000>, <0x10480000 0x100>;
>        };
> 
>        combiner:interrupt-controller@10440000 {
>                compatible = "samsung,exynos4210-combiner";
>                #interrupt-cells = <2>;
>                interrupt-controller;
>                samsung,combiner-nr = <16>;
>                reg = <0x10440000 0x1000>;
>                interrupts = <0 0 0>, <0 1 0>, <0 2 0>, <0 3 0>,
>                             <0 4 0>, <0 5 0>, <0 6 0>, <0 7 0>,
>                             <0 8 0>, <0 9 0>, <0 10 0>, <0 11 0>,
>                             <0 12 0>, <0 13 0>, <0 14 0>, <0 15 0>;
>        };
> 
>        wakeup_eint: interrupt-controller@11400000 {
>                compatible = "samsung,exynos5210-wakeup-eint";
>                reg = <0x11400000 0x1000>;
>                interrupt-controller;
>                #interrupt-cells = <2>;
>                interrupt-parent = <&wakeup_map>;
>                interrupts = <0x0 0>, <0x1 0>, <0x2 0>, <0x3 0>,
>                             <0x4 0>, <0x5 0>, <0x6 0>, <0x7 0>,
>                             <0x8 0>, <0x9 0>, <0xa 0>, <0xb 0>,
>                             <0xc 0>, <0xd 0>, <0xe 0>, <0xf 0>,
>                             <0x10 0>;
> 
>                wakeup_map: interrupt-map {
>                        compatible = "samsung,exynos5210-wakeup-eint-map";
>                        #interrupt-cells = <2>;
>                        #address-cells = <0>;
>                        #size-cells = <0>;
>                        interrupt-map = <0x0 0 &gic 0 16 0>,
>                                        <0x1 0 &gic 0 17 0>,
>                                        <0x2 0 &gic 0 18 0>,
>                                        <0x3 0 &gic 0 19 1>,
>                                        <0x4 0 &gic 0 20 0>,
>                                        <0x5 0 &gic 0 21 1>,
>                                        <0x6 0 &gic 0 22 0>,
>                                        <0x7 0 &gic 0 23 1>,
>                                        <0x8 0 &gic 0 24 0>,
>                                        <0x9 0 &gic 0 25 1>,
>                                        <0xa 0 &gic 0 26 0>,
>                                        <0xb 0 &gic 0 27 1>,
>                                        <0xc 0 &gic 0 28 0>,
>                                        <0xd 0 &gic 0 29 1>,
>                                        <0xe 0 &gic 0 30 0>,
>                                        <0xf 0 &gic 0 31 1>,
>                                        <0x10 0 &combiner 2 4>;
>                };
>        };
> 
> And following is the match table used for testing.
> 
> static const struct of_device_id exynos4_dt_irq_match[] = {
>        { .compatible = "arm,cortex-a9-gic", .data = gic_of_init, },
>        { .compatible = "samsung,exynos4210-combiner",
>                        .data = combiner_of_init, },
>        { .compatible = "samsung,exynos4210-wakeup-eint-map",

Looks like you have a mismatch here: 5210 or 4210?


>                        .data = exynos_init_irq_eint, },
>        {},
> };
> 
> The ' interrupt-map' map sub-node of 'interrupt-controller@11400000'
> node does not have a interrupt-parent property. So it inherits it from
> its parent node, which is 'interrupt-map' itself. So the parent of
> wakeup-map is not gic or combiner and hence the initialization
> function of wakeup controller is not called.
> 

That should be fine. If a node's interrupt-parent is itself, then that's
treated as a root interrupt controller.

> If a interrupt-parent property is added to 'interrupt-map' node (which
> is probably not the right thing to do), and set the interrupt parent
> as gic or combiner, there is a possibility that the interrupt-map is
> initialized before the combiner (which is not correct since
> interrupt-map uses combiner as one of its parents). But by placing
> 'wakeup_eint' node ahead of combiner node, this can be overcome but
> relying on placement of nodes in dts file is not a reliable solution.

Your fix doesn't really guarantee the proper order either. It's still a
side effect of the implementation. Perhaps a retry mechanism would work.
Then the init for wakeup_eint can retry if the gic is not yet setup.

Rob


> Thanks,
> Thomas.
> 
>>
>>>  drivers/of/irq.c |   45 ++++++++++++++++++++++++++++++++++++++++++++-
>>>  1 files changed, 44 insertions(+), 1 deletions(-)
>>>
>>> diff --git a/drivers/of/irq.c b/drivers/of/irq.c
>>> index 9cf0060..70c6ece 100644
>>> --- a/drivers/of/irq.c
>>> +++ b/drivers/of/irq.c
>>> @@ -400,6 +400,38 @@ struct intc_desc {
>>>  };
>>>
>>>  /**
>>> + * of_irq_mark_orphan_desc - Set parent as NULL for a orphan intc_desc
>>> + * @intc_desc_list: the list of intc_desc to search for orphan intc_desc
>>> + *
>>> + * This is a helper function for the of_irq_init function and is invoked
>>> + * when there are child nodes available in intc_desc_list but there are
>>> + * no parent nodes in intc_parent_list. When invoked, this function
>>> + * searches for a intc_desc instance that does not have a parent intc_desc
>>> + * instance in intc_desc_list. The very reason of the invocation of this
>>> + * function ensures that a orphan intc_desc will be found. When found, the
>>> + * interrupt_parent of the orphan intc_desc is set to NULL.
>>> + */
>>> +static void of_irq_mark_orphan_desc(struct list_head *intc_desc_list)
>>> +{
>>> +     struct intc_desc *desc, *temp_desc;
>>> +
>>> +     list_for_each_entry_safe(desc, temp_desc, intc_desc_list, list) {
>>> +             struct intc_desc *td1, *td2;
>>> +             list_for_each_entry_safe(td1, td2, intc_desc_list, list) {
>>> +                     if (desc->interrupt_parent == td1->dev)
>>> +                             break;
>>> +             }
>>> +             if (desc->interrupt_parent == td1->dev)
>>> +                     continue;
>>> +
>>> +             pr_debug("%s: set interrupt_parent of 'intc_desc' with dev name"
>>> +                     " %s as NULL\n", __func__, desc->dev->full_name);
>>> +             desc->interrupt_parent = NULL;
>>> +             return;
>>> +     }
>>> +}
>>> +
>>> +/**
>>>   * of_irq_init - Scan and init matching interrupt controllers in DT
>>>   * @matches: 0 terminated array of nodes to match and init function to call
>>>   *
>>> @@ -481,8 +513,19 @@ void __init of_irq_init(const struct of_device_id *matches)
>>>               /* Get the next pending parent that might have children */
>>>               desc = list_first_entry(&intc_parent_list, typeof(*desc), list);
>>>               if (list_empty(&intc_parent_list) || !desc) {
>>> +                     /*
>>> +                      * This has reached a point where there are children in
>>> +                      * the intc_desc_list but no parent in intc_parent_list.
>>> +                      * This means there is a child desc in intc_desc_list
>>> +                      * whose parent is not one of the remaining elements of
>>> +                      * the intc_desc_list. Such a child node is marked as
>>> +                      * orphan (interrupt_parent is set to NULL) and the
>>> +                      * process continues with parent set to NULL.
>>> +                      */
>>>                       pr_err("of_irq_init: children remain, but no parents\n");
>>> -                     break;
>>> +                     of_irq_mark_orphan_desc(&intc_desc_list);
>>> +                     parent = NULL;
>>> +                     continue;
>>>               }
>>>               list_del(&desc->list);
>>>               parent = desc->dev;
>>

