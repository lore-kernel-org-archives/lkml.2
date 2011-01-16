Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754068Ab1APVjS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jan 2011 16:39:18 -0500
Received: from mail.bluewatersys.com ([202.124.120.130]:15811 "EHLO
	hayes.bluewaternz.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753953Ab1APVjR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jan 2011 16:39:17 -0500
Message-ID: <4D33658C.9020502@bluewatersys.com>
Date: Mon, 17 Jan 2011 10:39:24 +1300
From: Ryan Mallon <ryan@bluewatersys.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.13) Gecko/20101208 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
CC: Grant Likely <grant.likely@secretlab.ca>,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Ben Herrenchmidt <benh@kernel.crashing.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/2] Add a common struct clk
References: <1294199462.347935.472473715866.0.gpush@pororo> <20110110104122.GI12078@pengutronix.de> <20110110110028.GB12552@n2100.arm.linux.org.uk> <201101110854.15653.jeremy.kerr@canonical.com> <AANLkTikjnz6RBCpOZM2imzX3d1ANUkaOZ2Qg9nqhpfpt@mail.gmail.com> <4D33580A.8090007@bluewatersys.com> <20110116210759.GI6917@pengutronix.de>
In-Reply-To: <20110116210759.GI6917@pengutronix.de>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/17/2011 10:07 AM, Uwe Kleine-König wrote:
> On Mon, Jan 17, 2011 at 09:41:46AM +1300, Ryan Mallon wrote:
>> On 01/16/2011 08:26 PM, Grant Likely wrote:
>>> On Mon, Jan 10, 2011 at 5:54 PM, Jeremy Kerr <jeremy.kerr@canonical.com> wrote:
>>>> Hi Russell,
>>>>
>>>>> Unless the locking problems can be resolved, the patches aren't ready.
>>>>>
>>>>> From what I've seen there's still quite a problem with what kind of
>>>>> lock to use in the clock - mutex or spinlock.
>>>>
>>>> Yes, the clock driver may either use a spinlock or mutex.
>>>>
>>>> However, this exactly the same as the current clock code, my patches do not
>>>> alter what we currently have.
>>>>
>>>> I do agree that we should define some specific semantics for the clock API
>>>> with regards to sleeping, and I'll start a new thread about that. But we
>>>> should definitely separate that issue from the problem of having multiple
>>>> definitions for struct clk, which is what these patches address.
>>>
>>> Given that each current struct clk implementation makes it's own
>>> decisions about how to handle locking, would it not make sense to omit
>>> locking entirely?  At least as a first step?  Let the clock ops
>>> implement their own locking.  Make enable count management their
>>> responsibility too.  That's all that the lock protects anyway.  The
>>> clk_* apis can fall directly through to the ops hooks with no
>>> manipulation or locking.  The way v3 of the patch worked.
>>
>> This doesn't really work in a generic API because the call sites need to
>> know whether it safe to call clk_enable/disable, etc from a
>> non-sleepable context. This has essentially the same problems as using a
>> union with both a mutex and a spinlock.
> Note that this is the current status quo, too.  clk_enable on imx
> sleeps, clk_enable on at91 doesn't.  I think we all agree we don't want
> to change that during the unifying step.  So the common struct clk might
> not solve all problems, but it's not worse than the state now.

Yes, I pointed this out. I think we have ended up in this ugly situation
because the clock API calls never defined rules about calling context
and so some platforms have ended up needing to sleep in the calls, while
drivers for other platforms assume that the clock API calls can be
safely called from atomic context.

My point, and I think Russell's point, is that if you are going to have
a truly generic, unified API we don't want this sort of mix and match.
The clock API functions should have clearly defined rules about what
context they can be called from and each platform/machine implementation
of the API should obey those rules.

Partly this is about code clarity. At the moment, to determine if a
clk_enable call might sleep I need to go and look at the implementation
for the platform I am on. There are drivers, such as the amba-pl010
serial driver, which can be used on multiple platforms. To verify that
the clock API call sites are correct you need to check each platform
that the driver runs on. By having an explicit separation of the clock
implementations which are atomic and those which may need to sleep these
problems disappear.

For the current patch series, the documentation for clk_enable would
need include this.

  "This function may or may not be safe to call from atomic context
   depending on the platform you are on."

I don't think we have too many other generic APIs in the kernel which
have this kind of loose documentation.

>> That said, although we are aiming for a generic clock API, it's usage
>> typically isn't. Most of the users of the clock API are machine/platform
>> specific drivers and so they can make assumptions about the
>> implementation of the clock API calls. We currently do have a generic
>> set of clock calls which do not define rules about calling from atomic
>> context. We have a number of drivers, for several platforms, using the
>> clk_enable/disable calls. Some platforms are using sleeping clocks and
>> others are using atomic clocks, but because the _usage_ of the API is
>> largely platform specific it all hangs together.
>>
>> This is a bit ugly in practice. It's hardly desirable to have an API
>> which looks generic, but in reality is platform/machine specific. I'm
>> guessing that a large benefit of having a unified API and well defined
>> rules about whether clock API calls may sleep or not allows the usage of
>> the clock API to become more generic.
>>
>> I agree with Russell that the best short term approach is to create two
>> clock APIs, one for clocks which are atomic and the other for clocks
>> which need to sleep. If nothing else this at least allows the rules
>> about calling context to nailed down.
> For me this sounds like code duplication if everything is identical only
> spinlocks are substituted by mutexes.  What do you think about my
> suggestion to use a Kconfig symbol that is selected by platforms (e.g.
> COMMON_CLK_SLEEPING) and then use:
> 
> 	#ifdef CONFIG_COMMON_CLK_SLEEPING
> 		... mutex stuff ...
> 	#else
> 		... spinlock stuff ...
> 	#endif

You still have the problem that cannot make any assumptions about
calling context for calls to the clock API. The point is that the
semantics about calling context for a generic clock API are currently
too loose. Part of consolidating the clock implementations should be to
fix that. Russell's suggestion to reduce to two implementations (from
the 30+ we have now) will have a net reduction in code, but will also
clarify which platforms/drivers are using sleeping clocks.

~Ryan

-- 
Bluewater Systems Ltd - ARM Technology Solution Centre

Ryan Mallon         		5 Amuri Park, 404 Barbadoes St
ryan@bluewatersys.com         	PO Box 13 889, Christchurch 8013
http://www.bluewatersys.com	New Zealand
Phone: +64 3 3779127		Freecall: Australia 1800 148 751
Fax:   +64 3 3779135			  USA 1800 261 2934
