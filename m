Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755542Ab2DPVgH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 17:36:07 -0400
Received: from na3sys009aog132.obsmtp.com ([74.125.149.250]:58358 "EHLO
	na3sys009aog132.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751523Ab2DPVgE convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 17:36:04 -0400
MIME-Version: 1.0
In-Reply-To: <20120416203016.GH20478@pengutronix.de>
References: <1334192572-12499-1-git-send-email-mturquette@linaro.org>
 <1334192572-12499-13-git-send-email-mturquette@linaro.org> <20120416203016.GH20478@pengutronix.de>
From: "Turquette, Mike" <mturquette@ti.com>
Date: Mon, 16 Apr 2012 14:35:40 -0700
Message-ID: <CAJOA=zPu0kRn5TKh5Qg1F1r+BYOm2-uj+1NoBwM7P7QJBza1nQ@mail.gmail.com>
Subject: Re: [PATCH 12/13] clk: core: copy parent_names & return error codes
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Andrew Lunn <andrew@lunn.ch>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Russell King <linux@arm.linux.org.uk>, patches@linaro.org,
        Rajendra Nayak <rnayak@ti.com>, linux-kernel@vger.kernel.org,
        Saravana Kannan <skannan@codeaurora.org>,
        linux-arm-kernel@lists.infradead.org, Olof Johansson <olof@lixom.net>,
        linaro-dev@lists.linaro.org, arnd.bergmann@linaro.org,
        Richard Zhao <richard.zhao@linaro.org>,
        Shawn Guo <shawn.guo@freescale.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 16, 2012 at 1:30 PM, Sascha Hauer <s.hauer@pengutronix.de> wrote:
> On Wed, Apr 11, 2012 at 06:02:50PM -0700, Mike Turquette wrote:
>>  struct clk *clk_register(struct device *dev, const char *name,
>>               const struct clk_ops *ops, struct clk_hw *hw,
>>               const char **parent_names, u8 num_parents, unsigned long flags)
>>  {
>> +     int i, ret = -ENOMEM;
>
> I suggest to move the initialization of ret from here...
>
>>       struct clk *clk;
>>
>>       clk = kzalloc(sizeof(*clk), GFP_KERNEL);
>> -     if (!clk)
>> -             return NULL;
>> +     if (!clk) {
>> +             pr_err("%s: could not allocate clk\n", __func__);
>> +             goto fail_out;
>> +     }
>>
>>       clk->name = name;
>>       clk->ops = ops;
>>       clk->hw = hw;
>>       clk->flags = flags;
>> -     clk->parent_names = parent_names;
>>       clk->num_parents = num_parents;
>>       hw->clk = clk;
>>
>> -     __clk_init(dev, clk);
>> +     /* allocate local copy in case parent_names is __initdata */
>> +     clk->parent_names = kzalloc((sizeof(char*) * num_parents),
>> +                     GFP_KERNEL);
>> +
>> +     if (!clk->parent_names) {
>> +             pr_err("%s: could not allocate clk->parent_names\n", __func__);
>> +             goto fail_parent_names;
>> +     }
>> +
>> +     /* copy each string name in case parent_names is __initdata */
>
> ... to here.
>
> The rationale is that when this code is changed later someone might use
> ret above and doesn't remember that the code below expects ret to be
> initialized with -ENOMEM. Also it's easier to see that the code is
> correct.

That is sensible.

Thanks,
Mike

> Sascha
