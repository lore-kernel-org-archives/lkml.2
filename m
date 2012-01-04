Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755776Ab2ADOcm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 09:32:42 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:48809 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753763Ab2ADOci (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 09:32:38 -0500
Message-ID: <4F0462FF.1000308@gmail.com>
Date: Wed, 04 Jan 2012 08:32:31 -0600
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111124 Thunderbird/8.0
MIME-Version: 1.0
To: Richard Zhao <richard.zhao@freescale.com>
CC: "Turquette, Mike" <mturquette@ti.com>, andrew@lunn.ch,
        linaro-dev@lists.linaro.org, eric.miao@linaro.org,
        grant.likely@secretlab.ca, Colin Cross <ccross@google.com>,
        jeremy.kerr@canonical.com, linux@arm.linux.org.uk, sboyd@quicinc.com,
        magnus.damm@gmail.com, dsaxena@linaro.org,
        linux-arm-kernel@lists.infradead.org, arnd.bergmann@linaro.org,
        patches@linaro.org, Thomas Gleixner <tglx@linutronix.de>,
        linux-omap@vger.kernel.org, richard.zhao@linaro.org,
        shawn.guo@freescale.com, paul@pwsan.com, linus.walleij@stericsson.com,
        broonie@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org,
        amit.kucheria@linaro.org, skannan@quicinc.com
Subject: Re: [PATCH v4 3/6] clk: introduce the common clock framework
References: <1323834838-2206-1-git-send-email-mturquette@linaro.org> <1323834838-2206-4-git-send-email-mturquette@linaro.org> <alpine.LFD.2.02.1112141007550.3020@ionos> <CAJOA=zO=gM2r4pCVo+orLqE9Q1SSw4h5nXsAHo-e_SHZAfvKDA@mail.gmail.com> <20120104021541.GI2414@b20223-02.ap.freescale.net>
In-Reply-To: <20120104021541.GI2414@b20223-02.ap.freescale.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/03/2012 08:15 PM, Richard Zhao wrote:
> On Fri, Dec 16, 2011 at 04:45:48PM -0800, Turquette, Mike wrote:
>> On Wed, Dec 14, 2011 at 5:18 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
>>> On Tue, 13 Dec 2011, Mike Turquette wrote:

snip

>>>> +/**
>>>> + * clk_init - initialize the data structures in a struct clk
>>>> + * @dev: device initializing this clk, placeholder for now
>>>> + * @clk: clk being initialized
>>>> + *
>>>> + * Initializes the lists in struct clk, queries the hardware for the
>>>> + * parent and rate and sets them both.  Adds the clk to the sysfs tree
>>>> + * topology.
>>>> + *
>>>> + * Caller must populate clk->name and clk->flags before calling
>>>
>>> I'm not too happy about this construct. That leaves struct clk and its
>>> members exposed to the world instead of making it a real opaque
>>> cookie. I know from my own painful experience, that this will lead to
>>> random fiddling in that data structure in drivers and arch code just
>>> because the core code has a shortcoming.
>>>
>>> Why can't we make struct clk a real cookie and confine the data
>>> structure to the core code ?
>>>
>>> That would change the init call to something like:
>>>
>>> struct clk *clk_init(struct device *dev, const struct clk_hw *hw,
>>>                     struct clk *parent)
>>>
>>> And have:
>>> struct clk_hw {
>>>       struct clk_hw_ops *ops;
>>>       const char        *name;
>>>       unsigned long     flags;
>>> };
>>>
>>> Implementers can do:
>>> struct my_clk_hw {
>>>       struct clk_hw    hw;
>>>       mydata;
>>> };
>>>
>>> And then change the clk ops callbacks to take struct clk_hw * as an
>>> argument.
> We have to define static clocks before we adopt DT binding.
> If clk is opaque and allocate memory in clk core, it'll make hard
> to define static clocks. And register/init will pass a long parameter
> list.

DT is not a prerequisite for having dynamically created clocks. You can
make clock init dynamic without DT.

What data goes in struct clk vs. struct clk_hw could change over time.
So perhaps we can start with some data in clk_hw and plan to move it to
struct clk later. Even if almost everything ends up in clk_hw initially,
at least the structure is in place to have common, core-only data
separate from platform data.

What is the actual data you need to be static and accessible to the
platform code? A ptr to parent clk is the main thing I've seen for
static initialization. So make the parent ptr be struct clk_hw* and
allow the platforms to access.

Rob
