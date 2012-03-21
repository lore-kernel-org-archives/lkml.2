Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758542Ab2CUKt6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 06:49:58 -0400
Received: from slimlogic.co.uk ([89.16.172.20]:38690 "EHLO slimlogic.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758141Ab2CUKt5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 06:49:57 -0400
Message-ID: <4F69B254.1000603@slimlogic.co.uk>
Date: Wed, 21 Mar 2012 10:49:56 +0000
From: Graeme Gregory <gg@slimlogic.co.uk>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: linux-kernel@vger.kernel.org, lrg@ti.com
Subject: Re: [PATCH] REGULATOR: core add 3 new modes/statuses
References: <1332280258-5044-1-git-send-email-gg@slimlogic.co.uk> <1332280258-5044-2-git-send-email-gg@slimlogic.co.uk> <20120321002939.GA8567@opensource.wolfsonmicro.com>
In-Reply-To: <20120321002939.GA8567@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21/03/2012 00:29, Mark Brown wrote:
> On Tue, Mar 20, 2012 at 09:50:58PM +0000, Graeme Gregory wrote:
>> This patch adds three new modes to the regulator core these are present
>> in many TI PMICs and I expect ones by other manufecturers.
> I'm not sure these are really modes, the framework essentially thinks as
> modes as regulation quality but except in the case of bypass that's not
> really what's going on here.
Your comments below do echo some of the doubts I had with this, why I
sent as an RFC before I went changing the driver to use them.

>> USBBOOST this effectively turns the regulator around instead of using
>> the USB 5v and converting this down to power USB hardware the regulator
>> instead takes the internal voltage and boosts it to 5v for USB. Most
>> commonly used when a device goes into OTG host mode.
> In theory this could be done by other things so we should probably have
> a better name, though in practice I'd be surprised to see many others.
> It does totally break the idea of a mode, though - it's a massive change
> in what the regulator does.
Im not attached to the name, I just chose it as BOOST is a type of SMPS
as well as being the common name for this function within TI. I do see
what you mean by it not really fitting the "mode" descriptor well!

>> BYPASS the input voltage on the regulator is transferred directly to the
>> output.
> This one I've actually been thinking about myself - we do want it for
> low power states but I think we should consider splitting it since while
> it does kind of look like a mode if you look at it funny (really it's
> just very, very low quality regulation) it seems like we should be able
> to do interesting things with it in the framework like turning off
> regulation if the parent regulator can directly satisfy the children.
> As a mode it's relatively limited if drivers won't select the mode
> explicitly since if regulation weren't required some of the time it's
> unlikely that the regulator would be in the picture at all.
>
> This is all rather like the mode selection stuff so it might well be
> that that's the best way of delivering the feature but I'm a bit nervous
> of just doing that partly because it's a bit of a jump for a consumer to
> go from "I want low current" to "I don't care so much what my input
> voltage is" (though often a valid one) and partly because we're not
> actually using the automatic mode selection logic since nobody is
> providing the current numbers since that's a bit sensitive.  This second
> issue with getting the information to deploy the feature is what's
> swaying me, at the minute nobody's providing the information needed
> except for some of the out of tree Qualcomm drivers.
>
> What I'd envisage for a feature specific API would be something like a
> call consumers could make to indicate that they're OK with bypass mode
> paired with a constraint flag that lets the core pay attention - if all
> the consumers vote for bypass it can get turned on.  Probably this could
> be tied in with disable too so that a consumer that wasn't enabled would
> automatically get set as voting for bypass, relying on the constraints
> to disable the feature when not appropriate.
>
> A further extension would be to allow boards to also automatically
> enable bypass if the voltages requested by the consumers can be
> satisfied directly from the parent regulator, though that's got some
> rather obvious pitfalls.
>
> Like I say I'm not entirely clear here, I keep meaning to try coding up
> the custom API and see how it feels using it in a system - any thoughts?
> Probably won't take me that long...
This Im not really sure on, I don't see much info on the actual use of
bypass mode in real devices yet. twl6035 uses it to power LDOUSB direct
from USB bus intead of using the internal SMPS. But so far that is the
only usecase I know of. Which of course means in bypass mode we not only
have to change parent to some non existent virtual regulator but also
enabled bypass mode.

>> TRACKING the regulator tracks another resource and produces the same
>> voltage. This is commonly used where an switching power supply produces
>> a voltage but a quality smoothed version of the same voltage produced
>> by an LDO is required as well.
> You also get this for ganging multiple regulators together to give a
> higher power output, though normally you want variability so this has to
> be handled at the hardware level.  This one also has an impact on how we
> handle voltage changes, it'd be good if we could arrange things so that
> get_voltage() and set_voltage() work through/with a regulator that's
> tracking.
I could see this also working if you set a parent regulator with a
TRACKING flag so the framework knows the link. The other thing to
consider is the twl6035 when you disable the parent SMPS on the LDO in
tracking mode the LDO then switches to non tracking mode and uses its
own configuration. When you turn SMPS back on it switch back to tracking
mode.
>>  #define REGULATOR_MODE_NORMAL                  0x2
>>  #define REGULATOR_MODE_IDLE                    0x4
>>  #define REGULATOR_MODE_STANDBY                 0x8
>> +#define REGULATOR_MODE_USBBOOST                        0x10
>> +#define REGULATOR_MODE_BYPASS                  0x20
>> +#define REGULATOR_MODE_TRACKING                        0x40
> Note that the existing modes are all sorted in order of quality and the
> framework does use that...
Yes I can see that now, didnt notice it at first.

Altogether it looks like adding these features requires a lot more work
than I had originally hoped :-(

I guess the best way for me to proceed is to start to think about each
of these "modes" individually and see what support I actually need from
regulator framework to get them implemented.

Graeme

