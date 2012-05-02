Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752341Ab2EBEmn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 00:42:43 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:10715 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751011Ab2EBEml (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 00:42:41 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6698"; a="184488181"
Message-ID: <4FA0BB3D.4040004@codeaurora.org>
Date: Tue, 01 May 2012 21:42:37 -0700
From: Saravana Kannan <skannan@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:12.0) Gecko/20120420 Thunderbird/12.0
MIME-Version: 1.0
To: Mike Turquette <mturquette@ti.com>
CC: Mike Turquette <mturquette@linaro.org>,
        Arnd Bergman <arnd.bergmann@linaro.org>,
        linux-arm-kernel@lists.infradead.org, Andrew Lunn <andrew@lunn.ch>,
        Paul Walmsley <paul@pwsan.com>, Russell King <linux@arm.linux.org.uk>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Stephen Boyd <sboyd@codeaurora.org>, linux-arm-msm@vger.kernel.org,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Magnus Damm <magnus.damm@gmail.com>, linux-kernel@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>,
        Richard Zhao <richard.zhao@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Deepak Saxena <dsaxena@linaro.org>,
        Amit Kucheria <amit.kucheria@linaro.org>,
        Jamie Iles <jamie@jamieiles.com>,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Shawn Guo <shawn.guo@freescale.com>
Subject: Re: [PATCH] clk: Use a separate struct for holding init data.
References: <1335419936-10881-1-git-send-email-skannan@codeaurora.org> <20120502020418.GF17311@gmail.com>
In-Reply-To: <20120502020418.GF17311@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/01/2012 07:04 PM, Mike Turquette wrote:
> On 20120425-22:58, Saravana Kannan wrote:
>> Create a struct clk_init_data to hold all data that needs to be passed from
>> the platfrom specific driver to the common clock framework during clock
>> registration. Add a pointer to this struct inside clk_hw.
>>
>> This has several advantages:
>> * Completely hides struct clk from many clock platform drivers and static
>>    clock initialization code that don't care for static initialization of
>>    the struct clks.
>> * For platforms that want to do complete static initialization, it removed
>>    the need to directly mess with the struct clk's fields while still
>>    allowing to statically allocate struct clk. This keeps the code more
>>    future proof even if they include clk-private.h.
>> * Simplifies the generic clk_register() function and allows adding optional
>>    fields in the future without modifying the function signature.
>> * Simplifies the static initialization of clocks on all platforms by
>>    removing the need for forward delcarations or convoluted macros.
>>
>> Signed-off-by: Saravana Kannan<skannan@codeaurora.org>
>
> Hi Saravana,
>
> Thanks for the patch.  I've taken it into my clk-next but I have two
> points:

Yayyy!! Finally I can get rid of having to know about struct clk.

> 1) I'm surprised that you abandoned the approach of exposing the
> less-private members of struct clk via struct clk_hw.  Your original
> patch did just that, but did not account for static initialization.
> This patch seems to have gone in the opposite direction and only
> accounts for static initialization.

I think there might be some misunderstanding on what can/can't be done 
with my patch. Or may be I'm not understanding your question.

I used to expose the "shared" info through clk_hw. I just put them in a 
struct and make clk_hw point to it. This would allow for easily marking 
this shared info as __init data. It would have a been a pain to do (or 
not even possible) if I had put the fields directly into clk_hw.

I'm not sure why you say my patch only accounts for static 
initialization. The entire clk specific struct (say, struct fixed_clk), 
the clk_init_data can be dynamically allocated and registered using 
clk_register.

For completely static init, you can just do:

#include <linux/clk-private.h>

static struct clk __my_clk;

static struct clk_init_data __my_clki = {
	<fill in shared fields>
};

static struct fixed_clk my_clk = {
	.blah = 10,
	.hw = {
		.i = &__my_clki;
		.c = &__my_clk;
	},
};

__clk_register(&my_clk.hw);

>
> I'm happy to take the patch as-is, but I did think that there were
> merits to your original approach.

Is there anything the first patch could do that this one couldn't?

The only small demerit of this patch that I know is that we could be 
doing some copying of the shared data when we do clk_register() (this 
prevents us from having one copy of parent list, etc).

>
> 2) I did make a modification to your patch where I kept the
> DEFINE_CLK_* macros and continued to declare __clk_init in
> clk-private.h.  I do want to get rid of both of these in the future but
> currently my platform relies on static initialization before the
> allocator is available.  Please let me know if this causes a problem for
> you.

I definitely had your requirements in mind too when I made the changes.

You really shouldn't need __clk_init. That's why I added __clk_register. 
With __clk_register (and the example I gave above), you should be able 
to do fully static init. Is there something I missed?

The DEFINE_CLK_* marcos aren't really very useful since there is no 
cyclic referencing going on.

You also don't really need to define variables for struct clk or struct 
clk_init_data. You can create anonymous struct pointers if that's your 
style. Something like:


static struct fixed_clk my_clk = {
	.blah = 10,
	.hw = {
		.i = &(struct clk_init_data) {
			<fill in shared fields>
		},
		.c = &(struct clk){};
	},
};

So, with one of the above approaches, DEFINE_CLK_* macros just end up 
obfuscating the definition of a clock and its fields.

With __clk_register() the only real difference between fully static and 
partly dynamic clock registration is that you don't mark the 
clk_init_data struct as __init and you call __clk_register() instead of 
clk_register(). I believe I documented it next to __clk_register() in clk.c.

> Platform folks should rebase on top of this if needed.  This should be
> the last change to the driver/platform-facing API before 3.5.

I really wish we discussed your changes before it was made, pulled in 
and announced since clk_init isn't really needed. But since you just 
added more APIs and didn't remove the ones I added, I guess it's not 
very bad.

Since people were already frustrated with the API change I made at this 
point, can we recommend people to not use __clk_init() when sending 
patches for your clk-next? And make it static after the next kernel release?

Thanks,
Saravana

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
