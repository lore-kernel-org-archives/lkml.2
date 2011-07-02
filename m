Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751930Ab1GBAj5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 20:39:57 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:34188 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751240Ab1GBAj4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 20:39:56 -0400
Message-ID: <4E0E6916.50406@gmail.com>
Date: Sat, 02 Jul 2011 10:40:54 +1000
From: Ryan Mallon <rmallon@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.17) Gecko/20110424 Thunderbird/3.1.10
MIME-Version: 1.0
To: Sascha Hauer <s.hauer@pengutronix.de>
CC: Bill Gatliff <bgat@billgatliff.com>, Arnd Bergmann <arnd@arndb.de>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        viresh kumar <viresh.kumar@st.com>, Shawn Guo <shawn.guo@linaro.org>,
        Ryan Mallon <ryan@bluewatersys.com>
Subject: Re: [PATCH 1/3] PWM: add pwm framework support
References: <1309430517-23821-1-git-send-email-s.hauer@pengutronix.de> <1309430517-23821-2-git-send-email-s.hauer@pengutronix.de> <BANLkTikQGFA7XcuAtEEi7_4m-j6-00sZ6Q@mail.gmail.com> <201106301441.24493.arnd@arndb.de> <BANLkTin_htv2z3D9Bbf6N8Y7UKFRvPtvOg@mail.gmail.com> <20110630170229.GP6069@pengutronix.de> <4E0D0595.5070205@gmail.com> <20110701073755.GR6069@pengutronix.de> <4E0D8540.2020200@gmail.com> <20110701085414.GV6069@pengutronix.de>
In-Reply-To: <20110701085414.GV6069@pengutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/07/11 18:54, Sascha Hauer wrote:
> On Fri, Jul 01, 2011 at 06:28:48PM +1000, Ryan Mallon wrote:
>> On 01/07/11 17:37, Sascha Hauer wrote:
>>> On Fri, Jul 01, 2011 at 09:24:05AM +1000, Ryan Mallon wrote:
>>>> On 01/07/11 03:02, Sascha Hauer wrote:
>>>>> Bill,
>>>>>
>>>>> On Thu, Jun 30, 2011 at 11:17:54AM -0500, Bill Gatliff wrote:
>>>>>> Guys:
>>>>>>
>>>>>> On Thu, Jun 30, 2011 at 7:41 AM, Arnd Bergmann<arnd@arndb.de>  wrote:
>>>>>>
>>>>>>> A lot of people want to see a framework get merged, and I think it's
>>>>>>> great that Sascha has volunteered to do the work to push that
>>>>>>> through this time, especially since you have not been able to
>>>>>>> finish your work.
>>>>>> Sascha is wasting his time by reinventing the wheel.  He's traveling
>>>>>> over exactly the same path I have already covered.  In fact, some of
>>>>>> his reviewer comments are almost word-for-word the same as those I
>>>>>> have received and addressed in the past.
>>>>>>
>>>>>> My patches were always kept current in this mailing list and others,
>>>>>> and Sascha clearly has the skills necessary to make improvements and
>>>>>> corrections should he have chosen to do so.
>>>>> I think that you made the fundamental mistake to completly ignore the
>>>>> existing pwm API and its users. With a competing api we are basically
>>>>> stuck. We can't convert the existing hardware drivers to the new API
>>>>> because leds-pwm.c, pwm_bl.c and others still depend on the old API and
>>>>> boards using it would break.
>>>> I don't think this is really a blocker to Bill's patches. There are
>>>> three (that I can see) pwm users currently:
>>>> drivers/video/backlight/pwm_bl.c
>>>> drivers/leds/leds-pwm.c
>>>> drivers/input/misc/pwm-beeper.c
>>>>
>>>> All of those drivers are trivial and good easily be updated to work
>>>> with Bill's patches. Bill already provided a leds-pwm driver.
>>> Yes, it is easy but that's not my point. The point is that you can't
>>> convert the drivers without converting *all* hardware drivers in a
>>> *single* step. If you choose to have two competing APIs in the tree
>>> for one purpose you can't convert the drivers but instead you have
>>> to copy them, either with cp or ifdefs. I have just looked at the
>>> leds-pwm driver Bill provided. Applying it immediately breaks all
>>> users.
>>>
>> At _any_ point that you change the pwm api you will need to change all
>> of the drivers. How do you plan to adapt the api in the future to
>> support the oddball pwm drivers without having to change all of the
>> drivers in one go?
> It is a framework between hardware drivers and user drivers and as such
> it is able to abstract between the API to the hardware drivers and the
> API to the user drivers. You can change one of those without touching
> the other.

You are missing the point. For example, the current in-kernel api to
configure a pwm is this:

int pwm_config(struct pwm_device *pwm, int duty_ns, int period_ns);

Bill's proposed change to the api, which is more flexible, looks like this:

int pwm_config(struct pwm_channel *p,
        struct pwm_channel_config *c)

If you want to change the api in this way at any time, you will need to
change all of the pwm drivers and all of the users (pwm-bl, pwm-leds,
etc) at the same time, or introduce some sort of wrapper layer to ease
the conversion. Either way, if you do it now or do it after your patch
set it is still the same amount of work.

We do want a better api for pwm drivers, if only to support oddball
hardware like the atmel. The process I see is this if we go with Bill's
patches:
 - Introduce new api with common framework
 - Move drivers to new api

With your patches we get this:
 - Introduce common framework
 - Move drivers to common framework
 - Modify api
 - Rewrite drivers for new api

The problem we have seen with these processes in the past is they get
left half way with some drivers moving to the new framework and some
trailing behind and some having their own hand-rolled approach because
the common api doesn't meet their needs.

>>> I don't say at all that the end result Bill is aiming at is bad because
>>> it isn't. We are not talking about the end result, but only the way to
>>> get there. And getting from a to b in bisectable small steps is a well
>>> established development model in the Kernel, or have I missed something?
>> The bi-sectable steps is fine. But what we have is a patch series which
>> introduces a new framework with a vague promise that the existing
>> drivers will get converted and the api will be improved later. Again,
>> the number of in-kernel users is so small that we may as well do it all
>> in one series.
> I don't understand you. On one hand you argue that it's trivial enough to
> port all drivers over the a new API in a single series and on the other
> hand you argue that we have to wait for several subsystem maintainers
> to port the drivers over to an existing-but-now-in-a-framework API.
>

No, I am saying that if we don't port all the drivers and leave it up to
the maintainers then it won't get done and we get left with some drivers
using the old approach and some using the new approach. For example, we
still have platforms which aren't using gpiolib yet and that was
introduced 3 years ago.

~Ryan
