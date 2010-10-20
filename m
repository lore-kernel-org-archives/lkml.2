Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755357Ab0JTTV3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 15:21:29 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:33309 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755278Ab0JTTV1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 15:21:27 -0400
MIME-Version: 1.0
X-Originating-IP: [109.186.69.160]
In-Reply-To: <8739s0sobc.fsf@deeprootsystems.com>
References: <1287387875-14168-1-git-send-email-ohad@wizery.com>
 <1287387875-14168-4-git-send-email-ohad@wizery.com> <87r5fmxghm.fsf@deeprootsystems.com>
 <AANLkTinZ2+ocJCfUpT15Ow3J9XBa-8XWnVC3gDDJ7s-v@mail.gmail.com>
 <87bp6pviwf.fsf@deeprootsystems.com> <AANLkTikE1dCXW-7ScVoDgEK3sxai_TyFzstSG+zvNm2F@mail.gmail.com>
 <8739s0sobc.fsf@deeprootsystems.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Wed, 20 Oct 2010 21:21:05 +0200
Message-ID: <AANLkTikdjtYtzhgM_=io3SFdUZq=8Xcc8n24bW=SFgTA@mail.gmail.com>
Subject: Re: [PATCH 3/3] omap: add hwspinlock device
To: Kevin Hilman <khilman@deeprootsystems.com>, Balaji T K <balajitk@ti.com>,
        "Kamat, Nishant" <nskamat@ti.com>
Cc: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, akpm@linux-foundation.org,
        Greg KH <greg@kroah.com>, Tony Lindgren <tony@atomide.com>,
        Benoit Cousson <b-cousson@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Hari Kanigeri <h-kanigeri2@ti.com>, Suman Anna <s-anna@ti.com>,
        Simon Que <sque@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 20, 2010 at 8:37 PM, Kevin Hilman
<khilman@deeprootsystems.com> wrote:
>> Let's take the i2c-omap for example.
>>
>> It sounds like it must have a predefined hwspinlock, but what if:
>>
>> 1. It will use omap_hwspinlock_request() to dynamically allocate a hwspinlock
>> 2. Obviously, the hwspinlock id number must be communicated to the M3
>> BIOS, so the i2c-omap will publish that id using a small shared memory
>> entry that will be allocated for this sole purpose
>> 3. we will make sure that 1+2 completes before the remote processor is
>> taken out of reset
>>
>> This does not require any smart IPC and it will allow us to get rid of
>> the omap_hwspinlock_request_specific() API and its early-callers
>> requirement.
>
> Yes, that would indeed simplify things.

Balaji, Nishant, are you OK with this ?

It means that the I2C driver will dynamically get a hwspinlock and
then it would need to announce the id of that hwspinlock before the M3
is taken out of reset.

It will help us get rid of static allocations that will never scale
nicely and static vs. dynamic allocation races.

>
>> All we will be left to take care of is the order of the ->probe()
>> execution (assuming we want both the i2c and the hwspinlock drivers to
>> be device_initcall)
>
> I understand the dependency between i2c and hwspinlock for some
> platforms with a shared i2c bus.  Besides that being a broken hardware
> design, I can see the need for the i2c driver to take a hwspinlock for
> i2c xfers, but why does the i2c driver need to take the hwspinlock at
> probe time?

It doesn't; it just needs to reserve a hwspinlock, and for that, we
need the hwspinlock driver in place.

>  Presumably, this is before the remote cores are executing
> code.
>
>>>
>>> This kind of thing needs to be done by platform_data function pointers,
>>> as is done for every other driver that needs platform-specific driver
>>> customization.
>>
>> Why would we need platform-specific function pointers here ? I'm not
>> sure I'm following this one.
>
> So that board code (built-in) does not call the hwspinlock driver
> (potentially a module.)
>
> The way to solve this is to have platform_data with function pointers,
> so that when the driver's ->probe() is done, it can call cany custom
> hooks registered by the board code.

Sorry, still not following.

Do you refer to the i2c driver calling the hwspinlcok_request function
at probe time via platform_data function pointers ?

With the previous _request_specific() allocation API, the important
issue to follow was the timing:  it had to be called before any driver
gets the chance to call the dynamic _request() API.
That's why we had to have early board code calling it. Obviously the
hwspinlock instance would then had to be delivered to the driver via
platform data.

But now, if we get rid of that static allocation method entirely,
i2c_omap can just call hwspinlock_request() on probe(), but again, no
pdata function pointers are involved because this API is
EXPORT_SYMBOL'ed.
