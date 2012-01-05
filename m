Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757692Ab2AECLf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 21:11:35 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:61514 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755891Ab2AECLc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 21:11:32 -0500
Message-ID: <4F0506D0.30109@gmail.com>
Date: Wed, 04 Jan 2012 20:11:28 -0600
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111124 Thunderbird/8.0
MIME-Version: 1.0
To: "Turquette, Mike" <mturquette@ti.com>
CC: Richard Zhao <richard.zhao@freescale.com>, andrew@lunn.ch,
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
References: <1323834838-2206-1-git-send-email-mturquette@linaro.org> <1323834838-2206-4-git-send-email-mturquette@linaro.org> <alpine.LFD.2.02.1112141007550.3020@ionos> <CAJOA=zO=gM2r4pCVo+orLqE9Q1SSw4h5nXsAHo-e_SHZAfvKDA@mail.gmail.com> <20120104021541.GI2414@b20223-02.ap.freescale.net> <4F0462FF.1000308@gmail.com> <CAJOA=zPw7UuhE4R3SsBeyzQ2_iN29Zv-ExaUTTFCah+GoFSfNQ@mail.gmail.com>
In-Reply-To: <CAJOA=zPw7UuhE4R3SsBeyzQ2_iN29Zv-ExaUTTFCah+GoFSfNQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/04/2012 07:01 PM, Turquette, Mike wrote:
> On Wed, Jan 4, 2012 at 6:32 AM, Rob Herring <robherring2@gmail.com> wrote:
>> On 01/03/2012 08:15 PM, Richard Zhao wrote:
>>> On Fri, Dec 16, 2011 at 04:45:48PM -0800, Turquette, Mike wrote:
>>>> On Wed, Dec 14, 2011 at 5:18 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
>>>>> On Tue, 13 Dec 2011, Mike Turquette wrote:
>>
>> snip
>>
>>>>>> +/**
>>>>>> + * clk_init - initialize the data structures in a struct clk
>>>>>> + * @dev: device initializing this clk, placeholder for now
>>>>>> + * @clk: clk being initialized
>>>>>> + *
>>>>>> + * Initializes the lists in struct clk, queries the hardware for the
>>>>>> + * parent and rate and sets them both.  Adds the clk to the sysfs tree
>>>>>> + * topology.
>>>>>> + *
>>>>>> + * Caller must populate clk->name and clk->flags before calling
>>>>>
>>>>> I'm not too happy about this construct. That leaves struct clk and its
>>>>> members exposed to the world instead of making it a real opaque
>>>>> cookie. I know from my own painful experience, that this will lead to
>>>>> random fiddling in that data structure in drivers and arch code just
>>>>> because the core code has a shortcoming.
>>>>>
>>>>> Why can't we make struct clk a real cookie and confine the data
>>>>> structure to the core code ?
>>>>>
>>>>> That would change the init call to something like:
>>>>>
>>>>> struct clk *clk_init(struct device *dev, const struct clk_hw *hw,
>>>>>                     struct clk *parent)
>>>>>
>>>>> And have:
>>>>> struct clk_hw {
>>>>>       struct clk_hw_ops *ops;
>>>>>       const char        *name;
>>>>>       unsigned long     flags;
>>>>> };
>>>>>
>>>>> Implementers can do:
>>>>> struct my_clk_hw {
>>>>>       struct clk_hw    hw;
>>>>>       mydata;
>>>>> };
>>>>>
>>>>> And then change the clk ops callbacks to take struct clk_hw * as an
>>>>> argument.
>>> We have to define static clocks before we adopt DT binding.
>>> If clk is opaque and allocate memory in clk core, it'll make hard
>>> to define static clocks. And register/init will pass a long parameter
>>> list.
>>
>> DT is not a prerequisite for having dynamically created clocks. You can
>> make clock init dynamic without DT.
> 
> Agreed.
> 
>> What data goes in struct clk vs. struct clk_hw could change over time.
>> So perhaps we can start with some data in clk_hw and plan to move it to
>> struct clk later. Even if almost everything ends up in clk_hw initially,
>> at least the structure is in place to have common, core-only data
>> separate from platform data.
> 
> What is the point of this?

To have a way forward. It would be nice to have a clk infrastructure
before I retire...

> The original clk_hw was defined simply as:
> 
> struct clk_hw {
>         struct clk *clk;
> };
> 
> It's only purpose in life was as a handle for navigation between the
> opaque struct clk and the hardware-specific struct my_clk_hw.  struct
> clk_hw is defined in clk.h and everyone can see it.  If we're suddenly
> OK putting clk data in this structure then why bother with an opaque
> struct clk at all?
> 
>> What is the actual data you need to be static and accessible to the
>> platform code? A ptr to parent clk is the main thing I've seen for
>> static initialization. So make the parent ptr be struct clk_hw* and
>> allow the platforms to access.
> 
> To answer your question on what data we're trying to expose: platform
> code commonly needs the parent pointer and the clk rate (and by
> extension, the rate of the parent).  For debug/error prints it is also
> nice to have the clk name.  Generic clk flags are also conceivably
> something that platform code might want.

I agree with the need to have the parent and flags from a static init
perspective. There's not really a good reason the others can't be
accessed thru accessors though.

> I'd like to spin the question around: if we're OK exposing some stuff
> (in your example above, the parent pointer), then what clk data are
> you trying to hide?

Well, everything from drivers which the current clk implementations do
hide. Catching abuse in with drivers coming in from all different trees
and lists will be impossible.

For platform code it is more fuzzy. I don't think platform code should
be allowed to muck with prepare/enable counts for example.

Rob

> 
> Regards,
> Mike
> 
>>
>> Rob

