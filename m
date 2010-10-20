Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756217Ab0JTX66 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 19:58:58 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:38054 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753101Ab0JTX65 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 19:58:57 -0400
From: Kevin Hilman <khilman@deeprootsystems.com>
To: Ohad Ben-Cohen <ohad@wizery.com>
Cc: Balaji T K <balajitk@ti.com>, "Kamat\, Nishant" <nskamat@ti.com>,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, akpm@linux-foundation.org,
        Greg KH <greg@kroah.com>, Tony Lindgren <tony@atomide.com>,
        Benoit Cousson <b-cousson@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Hari Kanigeri <h-kanigeri2@ti.com>, Suman Anna <s-anna@ti.com>,
        Simon Que <sque@ti.com>
Subject: Re: [PATCH 3/3] omap: add hwspinlock device
Organization: Deep Root Systems, LLC
References: <1287387875-14168-1-git-send-email-ohad@wizery.com>
	<1287387875-14168-4-git-send-email-ohad@wizery.com>
	<87r5fmxghm.fsf@deeprootsystems.com>
	<AANLkTinZ2+ocJCfUpT15Ow3J9XBa-8XWnVC3gDDJ7s-v@mail.gmail.com>
	<87bp6pviwf.fsf@deeprootsystems.com>
	<AANLkTikE1dCXW-7ScVoDgEK3sxai_TyFzstSG+zvNm2F@mail.gmail.com>
	<8739s0sobc.fsf@deeprootsystems.com>
	<AANLkTikdjtYtzhgM_=io3SFdUZq=8Xcc8n24bW=SFgTA@mail.gmail.com>
Date: Wed, 20 Oct 2010 16:58:52 -0700
In-Reply-To: <AANLkTikdjtYtzhgM_=io3SFdUZq=8Xcc8n24bW=SFgTA@mail.gmail.com>
	(Ohad Ben-Cohen's message of "Wed, 20 Oct 2010 21:21:05 +0200")
Message-ID: <877hhcl8lf.fsf@deeprootsystems.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ohad Ben-Cohen <ohad@wizery.com> writes:

> On Wed, Oct 20, 2010 at 8:37 PM, Kevin Hilman
> <khilman@deeprootsystems.com> wrote:
>>> Let's take the i2c-omap for example.
>>>
>>> It sounds like it must have a predefined hwspinlock, but what if:
>>>
>>> 1. It will use omap_hwspinlock_request() to dynamically allocate a hwspinlock
>>> 2. Obviously, the hwspinlock id number must be communicated to the M3
>>> BIOS, so the i2c-omap will publish that id using a small shared memory
>>> entry that will be allocated for this sole purpose
>>> 3. we will make sure that 1+2 completes before the remote processor is
>>> taken out of reset
>>>
>>> This does not require any smart IPC and it will allow us to get rid of
>>> the omap_hwspinlock_request_specific() API and its early-callers
>>> requirement.
>>
>> Yes, that would indeed simplify things.
>
> Balaji, Nishant, are you OK with this ?
>
> It means that the I2C driver will dynamically get a hwspinlock and
> then it would need to announce the id of that hwspinlock before the M3
> is taken out of reset.
>
> It will help us get rid of static allocations that will never scale
> nicely and static vs. dynamic allocation races.
>
>>
>>> All we will be left to take care of is the order of the ->probe()
>>> execution (assuming we want both the i2c and the hwspinlock drivers to
>>> be device_initcall)
>>
>> I understand the dependency between i2c and hwspinlock for some
>> platforms with a shared i2c bus.  Besides that being a broken hardware
>> design, I can see the need for the i2c driver to take a hwspinlock for
>> i2c xfers, but why does the i2c driver need to take the hwspinlock at
>> probe time?
>
> It doesn't; it just needs to reserve a hwspinlock, and for that, we
> need the hwspinlock driver in place.

OK

>>  Presumably, this is before the remote cores are executing
>> code.
>>
>>>>
>>>> This kind of thing needs to be done by platform_data function pointers,
>>>> as is done for every other driver that needs platform-specific driver
>>>> customization.
>>>
>>> Why would we need platform-specific function pointers here ? I'm not
>>> sure I'm following this one.
>>
>> So that board code (built-in) does not call the hwspinlock driver
>> (potentially a module.)
>>
>> The way to solve this is to have platform_data with function pointers,
>> so that when the driver's ->probe() is done, it can call cany custom
>> hooks registered by the board code.
>
> Sorry, still not following.
>
> Do you refer to the i2c driver calling the hwspinlcok_request function
> at probe time via platform_data function pointers ?

No, earlier in this discussion, in response to my question about users
of this API early in boot, you said:

> And to allow early board code to reserve specific hwspinlock numbers
> for predefined use-cases, we probably want to be before arch_initcall.

My suggestion to use platform_data + function pointers was to address
the requesting of hwspinlocks in board/platform-specific code.

If the _request_specific() API is removed, and board code no longer
needs to call hwspinlock API, then this issue is moot.  However, if
board code ever needs to call the hwspinlock API, then pdata func
pointers are needed to handle both the case of late driver probe
or driver built as a module.

> With the previous _request_specific() allocation API, the important
> issue to follow was the timing:  it had to be called before any driver
> gets the chance to call the dynamic _request() API.
> That's why we had to have early board code calling it. Obviously the
> hwspinlock instance would then had to be delivered to the driver via
> platform data.
>
> But now, if we get rid of that static allocation method entirely,
> i2c_omap can just call hwspinlock_request() on probe(), but again, no
> pdata function pointers are involved because this API is
> EXPORT_SYMBOL'ed.

Agreed.  If you get rid of the _request_specific() API, then this is not
needed in the board code and pdata function pointers should not be
needed.

So then, we're back to how to ensure probe order of hwspinlock vs
i2c. :/

I agree with others that this is a much broader problem, and should not
hold up the hwspinlock driver, so for now, making hwspinlock have an
initcall before subsys_initcall is OK with me.  Probably arch_initcall()
is fine here.

I suggest you add a comment in the code at the initcall point as to why
it is using arch_initcall(), namely it has to load before i2c because...

Kevin



