Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757001Ab0JUGLh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 02:11:37 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:39579 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756756Ab0JUGLg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 02:11:36 -0400
MIME-Version: 1.0
X-Originating-IP: [109.186.69.160]
In-Reply-To: <877hhcl8lf.fsf@deeprootsystems.com>
References: <1287387875-14168-1-git-send-email-ohad@wizery.com>
 <1287387875-14168-4-git-send-email-ohad@wizery.com> <87r5fmxghm.fsf@deeprootsystems.com>
 <AANLkTinZ2+ocJCfUpT15Ow3J9XBa-8XWnVC3gDDJ7s-v@mail.gmail.com>
 <87bp6pviwf.fsf@deeprootsystems.com> <AANLkTikE1dCXW-7ScVoDgEK3sxai_TyFzstSG+zvNm2F@mail.gmail.com>
 <8739s0sobc.fsf@deeprootsystems.com> <AANLkTikdjtYtzhgM_=io3SFdUZq=8Xcc8n24bW=SFgTA@mail.gmail.com>
 <877hhcl8lf.fsf@deeprootsystems.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Thu, 21 Oct 2010 08:11:15 +0200
Message-ID: <AANLkTi=TbMq4TEDoDby+kqtX6M_7_pOpiHuNNbp8r691@mail.gmail.com>
Subject: Re: [PATCH 3/3] omap: add hwspinlock device
To: Kevin Hilman <khilman@deeprootsystems.com>
Cc: Balaji T K <balajitk@ti.com>, "Kamat, Nishant" <nskamat@ti.com>,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, akpm@linux-foundation.org,
        Greg KH <greg@kroah.com>, Tony Lindgren <tony@atomide.com>,
        Benoit Cousson <b-cousson@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Hari Kanigeri <h-kanigeri2@ti.com>, Suman Anna <s-anna@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[removed that bouncing email address we had all along :]

On Thu, Oct 21, 2010 at 1:58 AM, Kevin Hilman
<khilman@deeprootsystems.com> wrote:
>>>> Why would we need platform-specific function pointers here ? I'm not
>>>> sure I'm following this one.
>>>
>>> So that board code (built-in) does not call the hwspinlock driver
>>> (potentially a module.)
>>>
>>> The way to solve this is to have platform_data with function pointers,
>>> so that when the driver's ->probe() is done, it can call cany custom
>>> hooks registered by the board code.
>>
>> Sorry, still not following.
>>
>> Do you refer to the i2c driver calling the hwspinlcok_request function
>> at probe time via platform_data function pointers ?
>
> No, earlier in this discussion, in response to my question about users
> of this API early in boot, you said:
>
>> And to allow early board code to reserve specific hwspinlock numbers
>> for predefined use-cases, we probably want to be before arch_initcall.

yes.

> My suggestion to use platform_data + function pointers was to address
> the requesting of hwspinlocks in board/platform-specific code.
>
...
> ... if
> board code ever needs to call the hwspinlock API, then pdata func
> pointers are needed to handle both the case of late driver probe
> or driver built as a module.

How would pdata func pointers help here ?

As you say, pdata func pointers are used in scenarios where
platform-specific code needs to be executed from a driver.

But this is not the case here; here we have driver code ( the
_request_specific() API) that must be called very early in the boot,
before any other driver get the chance to call the dynamic _request()
API.

And to be able to call _request_specific() API that early in the boot,
we must have the hwspinlock driver in place (loaded and already
probe()'ed). So we had to give both the hwspinlock device creation
code and its driver a very early initcall state.

Of course, as we all agree, if we get rid of the _request_specific()
API, hwspinlock will only race with its users (namely i2c_omap), and
in this case arch_initcall() is enough.

> I agree with others that this is a much broader problem, and should not
> hold up the hwspinlock driver, so for now, making hwspinlock have an
> initcall before subsys_initcall is OK with me.  Probably arch_initcall()
> is fine here.
>
> I suggest you add a comment in the code at the initcall point as to why
> it is using arch_initcall(), namely it has to load before i2c because...

Sure.

Thanks,
Ohad.
