Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754391Ab2GQNqd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 09:46:33 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:42621 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752183Ab2GQNqc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 09:46:32 -0400
Message-ID: <50056CB3.90004@gmail.com>
Date: Tue, 17 Jul 2012 08:46:27 -0500
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Rajendra Nayak <rnayak@ti.com>
CC: Mike Turquette <mturquette@ti.com>, Shawn Guo <shawn.guo@linaro.org>,
        Prashant Gaikwad <pgaikwad@nvidia.com>, aletes.xgr@gmail.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Archit Taneja <archit@ti.com>, loml <linux-omap@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>, "Cousson, Benoit" <b-cousson@ti.com>
Subject: Re: [PATCH] clk: fix compile for OF && !COMMON_CLK
References: <1342475161-20402-1-git-send-email-robherring2@gmail.com> <20120717001228.GA28886@gmail.com> <5004C935.4050707@gmail.com> <50056648.6000906@ti.com>
In-Reply-To: <50056648.6000906@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/17/2012 08:19 AM, Rajendra Nayak wrote:
> Rob, Mike,
> 
> On Tuesday 17 July 2012 07:38 AM, Rob Herring wrote:
>> On 07/16/2012 07:12 PM, Mike Turquette wrote:
>>> On 20120716-16:46, Rob Herring wrote:
>>>> From: Rob Herring<rob.herring@calxeda.com>
>>>>
>>>> With commit 766e6a4ec602d0c107 (clk: add DT clock binding support),
>>>> compiling with OF&&  !COMMON_CLK is broken.
>>>>
>>>
>>> Hi Rob,
>>>
>>> Thanks for sending this quickly.
>>>
>>> <snip>
>>>> @@ -313,19 +314,19 @@ int clk_add_alias(const char *alias, const
>>>> char *alias_dev_name, char *id,
>>>>   struct device_node;
>>>>   struct of_phandle_args;
>>>>
>>>> -#ifdef CONFIG_OF
>>>> +#if defined(CONFIG_OF)&&  defined(CONFIG_COMMON_CLK)
>>>>   struct clk *of_clk_get(struct device_node *np, int index);
>>>>   struct clk *of_clk_get_by_name(struct device_node *np, const char
>>>> *name);
>>>>   struct clk *of_clk_get_from_provider(struct of_phandle_args
>>>> *clkspec);
>>>>   #else
>>>>   static inline struct clk *of_clk_get(struct device_node *np, int
>>>> index)
>>>>   {
>>>> -    return NULL;
>>>> +    return ERR_PTR(-EINVAL);
> 
> So how is this expected to work on platforms (like OMAP) which have
> CONFIG_OF enabled but not CONFIG_COMMON_CLK?
> 

As I mentioned in my other reply, this really belongs with Shawn's patch
that changes the return value checking from NULL to err values.

> Archit has been seeing issues with failed clk_get's in the omap dss
> driver on linux-next.
> The clk_gets pass a valid dev pointer and an alias/con-id.
> 
> With the $Subject patch, the of_clk_get_by_name() for our builds always
> returns a ERR_PTR(-EINVAL).
> 
> Even if we do get the right of_clk_get_by_name() built in,
> there is another issue on OMAP where in we have CONFIG_OF
> enabled/selected by default for all OMAP2+ builds, even when we
> *do not* pass a dt blob to the kernel.
> 
> So would the below code fail in such cases because it expects a
> valid of_node to be populated for a device (which also has clock
> information in it)? if CONFIG_OF is set.
> 
> struct clk *clk_get(struct device *dev, const char *con_id)
> {
>         const char *dev_id = dev ? dev_name(dev) : NULL;
>         struct clk *clk;
> 
>         if (dev) {
> ---->
>     Any reason why this isn't
>     if (dev->of_node) {
> ---->

dev may be null, we could do (dev && dev->of_node) though. Either way
the error handling here needs to do the right thing.

>                 clk = of_clk_get_by_name(dev->of_node, con_id);
>                 if (clk && __clk_get(clk))
>                         return clk;
>         }
> 
>         return clk_get_sys(dev_id, con_id);
> }
> 
> regards,
> Rajendra
> 
> 
> 
> 
> 


