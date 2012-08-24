Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932084Ab2HXHOZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 03:14:25 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:60132 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755100Ab2HXHOV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 03:14:21 -0400
Message-ID: <503729C7.8040508@gmail.com>
Date: Fri, 24 Aug 2012 09:14:15 +0200
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.5) Gecko/20120624 Icedove/10.0.5
MIME-Version: 1.0
To: Tony Prisk <linux@prisktech.co.nz>
CC: Mike Turquette <mturquette@ti.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@googlemail.com>,
        Grant Likely <grant.likely@secretlab.ca>, linux-doc@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/1] clk: add DT support for clock gating control
References: <1341767726-25630-1-git-send-email-sebastian.hesselbarth@googlemail.com>  <20120824023135.4547.2534@nucleus> <1345782559.20538.22.camel@gitbox>
In-Reply-To: <1345782559.20538.22.camel@gitbox>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/24/2012 06:29 AM, Tony Prisk wrote:
> On Thu, 2012-08-23 at 19:31 -0700, Mike Turquette wrote:
>> Quoting Sebastian Hesselbarth (2012-07-08 10:15:26)
>>> This patch adds support for using clock gates (clk-gate) from DT based
>>> on Rob Herrings DT clk binding support for 3.6.
>>>
>>> It adds a helper function to clk-gate to allocate all resources required by
>>> a set of individual clock gates, i.e. register base address and lock. Each
>>> clock gate is described as a child of the clock-gating-control in DT and
>>> also created by the helper function.
>>>
>> Thanks for submitting this.  I'd prefer for Rob or someone with a more vested
>> interest in DT to review your binding.  I have some comments on the code below.

Mike, Tony,

thanks for reviewing this, I didn't even remember submitting it ;)

>> <snip>
>>> diff --git a/drivers/clk/clk-gate.c b/drivers/clk/clk-gate.c
>>> +
>>> +       lockp = kzalloc(sizeof(spinlock_t), GFP_KERNEL);
>>> +       if (!lockp) {
>>> +               pr_debug("%s: unable to allocate spinlock for %s\n",
>>> +                        __func__, np->full_name);
>>> +               return;
>>> +       }
>>> +
>>> +       spin_lock_init(lockp);
>>
>> The spinlocks for the basic clock types have always been optional.  This
>> code should reflect that and not assume the spinlock.
>>
>> Also I wonder if the assumption is true that a single spinlock
>> corresponding to a device_node is always the right thing for every
>> platform.  What about a 32-bit register that contains some gating bits
>> and a 3-bit wide field for a mux which we perform read-modify-write
>> operations on?
>>
>> You'll have to pardon my DT ignorance.  My concerns above may be totally
>> crazy with respect to DT.
>
> This also requires you to split your gated clocks in seperate nodes by
> register if you don't want unrelated clocks locking each other out.
> Also, you need a method of 'sharing' the lock outside of the gated-clock
> for use by other clock types that may share the same register.

The clock-gatining-control was inspired by a single 32b register that only
has clock gating bits. Some weeks of more insight into kernel code and DT,
I agree to do this differently.

> Are you assuming that all gated-clocks will be contained within a parent
> node with:
> #address-cells =<1>;
> #size-cells =<1>;
> with no other types of clocks? This generally isn't how people are
> writing their device tree files.
>
> Looking through the current dts files, the platforms that are using
> clocks to any real degree are using address=1, size=0.
> The only ones I see with 1/1 are only defining a fixed-clock and don't
> use the reg property anyway so could just as well be 1/0.
>
> It might be better to pass the bit field as a separate property rather
> than requiring people change their reg property to suit.
>
> myclock {
> 	reg =<0x0120>;
> 	enable-bit =<22>;
> };

Actually, today I would rather have some platform specific node for the
clock gating register and don't name each individual clock but only use
the clocks phandle to sort out the corresponding bit.

cgc: clock-gating-control {
	compatible = "marvell,orion-clkctrl";
	reg = <0x12340 0x8>;
	#clock-cells = <1>;
};

some_device: gateable-device {
	...
	clocks = <&cgc 13>;
};

The platform specific node will take care of all requirements like
spinlock or not. Maybe there will have to be a property to mask out
reserved bits in the 32b register or maybe I can assume that reserved
bits do no harm if set.

Sebastian
