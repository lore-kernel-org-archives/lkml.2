Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752830Ab1KPTHU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 14:07:20 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:37563 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750738Ab1KPTHT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 14:07:19 -0500
MIME-Version: 1.0
In-Reply-To: <20111114021359.GA25796@b20223-02.ap.freescale.net>
References: <1320801583-12774-1-git-send-email-grant.likely@secretlab.ca>
 <1320801583-12774-7-git-send-email-grant.likely@secretlab.ca>
 <4EB9EA46.3030300@gmail.com> <20111114021359.GA25796@b20223-02.ap.freescale.net>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Wed, 16 Nov 2011 12:06:56 -0700
X-Google-Sender-Auth: _LyPvm-pufXqgrP63bquo95TF64
Message-ID: <CACxGe6tHF7K4y9FqUxYraK0pgRRtN671-pp3Z88SEj4nStQiCg@mail.gmail.com>
Subject: Re: [RFC 6/8] of: add clock providers
To: Richard Zhao <richard.zhao@linaro.org>
Cc: Rob Herring <robherring2@gmail.com>, devicetree-discuss@lists.ozlabs.org,
        Sascha Hauer <kernel@pengutronix.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 13, 2011 at 7:14 PM, Richard Zhao <richard.zhao@linaro.org> wrote:
> On Tue, Nov 08, 2011 at 08:49:42PM -0600, Rob Herring wrote:
>> > +For example:
>> > +
>> > +    oscillator {
>> > +        #clock-cells = <1>;
>> > +        clock-output-name = "ckil", "ckih";
>> > +    };
>> > +
>> > +- this node defines a device with two clock outputs, the first named
>> > +  "ckil" and the second named "ckih".  Consumer nodes always reference
>> > +  clocks by index. The names should reflect the clock output signal
>> > +  names for the device.
>> > +
>> > +==Clock consumers==
>> > +
>> > +Required properties:
>> > +clock-input:       List of phandle and clock specifier pairs, one pair
>> > +           for each clock input to the device.
>> > +clock-input-name: List of clock input name strings sorted in the same
>> > +           order as the clock-input property.  Consumers drivers
>> > +           will use clock-input-name to match clock input names
>> > +           with clock-input specifiers.
>> > +
>> > +For example:
>> > +
>> > +    uart {
>> > +        clock-input = <&osc 1> <&ref 0>;
>> > +        clock-input-name = "baud", "register";
>> > +    };
>>
>> This is duplicated below.

I'm okay with that. It's not entirely the same, and I think having
several examples is helpful.


>> > +    /* external oscillator */
>> > +    osc: oscillator {
>> > +        compatible = "fixed-clock";
>> > +        #clock-cells = <1>;
>> > +        frequency  = <32678>;
>>
>> The code is using "clock-frequency" here.

Fixed

>>
>> > +        clock-output-name = "osc";
>> > +    };
>> > +
>> > +    /* phase-locked-loop device, generates a higher frequency clock
>> > +     * from the external oscillator reference */
>> > +    pll: pll {
>> > +        compatible = "some-pll-interface"
>> > +        #clock-cells = <1>;
>> > +        clock-input = <&osc 0>;
>>
>> There's a mismatch in #clock-cells size and this.
>
> osc #clock-cells is 1. "0" is one cell too. Nothing wrong. Correct my understanding?

Richard is correct.  The #clock-cells value needs to be 1, which in
the clock binding means one cell for the phandle and one cell for the
attached arguments.  Exactly the same as the gpio binding.

>> > +static struct clk *__of_clk_get_from_provider(struct of_phandle_args *clkspec)
>> > +{
>> > +   struct of_clk_provider *provider;
>> > +   struct clk *clk = NULL;
>> > +
>> > +   /* Check if we have such a provider in our array */
>> > +   mutex_lock(&of_clk_lock);
>> > +   list_for_each_entry(provider, &of_clk_providers, link) {
>> > +           if (provider->node == clkspec->np)
>> > +                   clk = provider->get(clkspec, provider->data);
>>
>> How about:
>>
>> if (provider->get)
>>       clk = provider->get(clkspec, provider->data);
>> else
>>       clk = provider->data;

I'd rather make it a requirement for every clock driver to provide the
get hook; even if it uses a stock version that simply returns ->data.

Thanks for the review.

g.
