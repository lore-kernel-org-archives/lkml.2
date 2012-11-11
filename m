Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752880Ab2KKMck (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2012 07:32:40 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:61578 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752730Ab2KKMch (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2012 07:32:37 -0500
MIME-Version: 1.0
In-Reply-To: <CACRpkdawAdbwackZeST4iDkFZx9-exhTVoUzAABaWr1G89tATg@mail.gmail.com>
References: <1350911580-20307-1-git-send-email-sourav.poddar@ti.com>
	<20121024161429.GA16350@core.coreip.homeip.net>
	<CACRpkdai3NocZQnW6YRF+k6GXUSx3P_Ge=F-tkuivrFm6tBbLg@mail.gmail.com>
	<4099134.xWUIfbbahk@dtor-d630.eng.vmware.com>
	<CACRpkdaiLXVeUg1quuw3XPTenbKOjn+aWbGQezpcyvzQCtCWow@mail.gmail.com>
	<20121030113407.GA24335@sirena.org.uk>
	<CACRpkdapQJY0aoam741O0fb8EeM9BLk_Psq5TaPG84J7wEvCLw@mail.gmail.com>
	<87obji8kta.fsf@deeprootsystems.com>
	<CACRpkdbCk9+HSBPtfT-1dO8paSRYJ5VXX_0SxiyxgrObnJEvmQ@mail.gmail.com>
	<20121101120713.GA4413@opensource.wolfsonmicro.com>
	<CACRpkdawAdbwackZeST4iDkFZx9-exhTVoUzAABaWr1G89tATg@mail.gmail.com>
Date: Sun, 11 Nov 2012 13:32:35 +0100
Message-ID: <CACRpkdZy1zRQM8Ww3RGc=Q+yt_eS6ekb02MDM-ixzaG8LDRacQ@mail.gmail.com>
Subject: Re: [PATCHv2] Input: omap4-keypad: Add pinctrl support
From: Linus Walleij <linus.walleij@linaro.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Grant Likely <grant.likely@secretlab.ca>
Cc: Kevin Hilman <khilman@deeprootsystems.com>, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Felipe Balbi <balbi@ti.com>, Benoit Cousson <b-cousson@ti.com>,
        Sourav Poddar <sourav.poddar@ti.com>, tony@atomide.com,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org, linux-input@vger.kernel.org,
        Stephen Warren <swarren@wwwdotorg.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 1, 2012 at 3:01 PM, Linus Walleij <linus.walleij@linaro.org> wrote:
> On Thu, Nov 1, 2012 at 1:07 PM, Mark Brown
> <broonie@opensource.wolfsonmicro.com> wrote:
>> On Thu, Nov 01, 2012 at 09:54:00AM +0100, Linus Walleij wrote:
>
>> For the pin hogging I'd actually been thinking separately that we should
>> just have the device core do a devm_pinctrl_get_set_default() prior to
>> probing the device and store the result in the struct device.  That
>> would immediately remove almost all of the current pinctrl users, users
>> that do need to do things with the data or check the result can then
>> pick up the pinctrl pointer from the device struct.
>
> I never thought of that. This sounds like it would work.

So I've looked closer at this.

> And the good thing is that this is a clean cut so we
> will centralized code without having to decide right now
> how to handle the pm idle/sleep cases.
>
> Talking here with Kevin Hilman on my left and Grant
> Likely on my right (they're physically here) there is some
> worry about stashing stuff into struct device.
>
> What if I retrieve this in the pinctrl subsystem using
> bus notifiers and then expose the struct pinctrl * to
> the clients by using pinctrl_get() and when you get
> such a handle in your probe() you know that the
> pinctrl subsystem has already fetched the handle and
> set it to "default" at that point?

I have sent out an RFC for this approach. It actually
works quite well on the U300 for example.

However as stated in the patch we run into another
problem: what if the pinctrl provider returns
-EDEFER_PROBE?

(The same will be true for clocks, regulators etc I
guess...)

If I use notifiers like this, I cannot return -EPROBE_DEFER
to the core. :-(

The PM domains seem to be built on the notification
mechanism as well (AFAICT), so it will not allow drivers to
defer their probes, as it is an optional layer after all.

As a matter of fact it seems that there is an implicit
assumption in PM domains that the resources that
are taken there cannot defer any probing, so they are
assumed to always be present. Is this correct?
If so, any resources that may be deferred (such as
pinctrl) can never be handled in PM domains. Only
simple stuff that the SoC controls directly e.g through
some fixed register pokes to voltage domains.

So then the only option that remains to centralize
pinctrl handling is indeed to do that in the device core,
before probe(). I need to know Greg's feelings about that.

At the same time this sort of give me the feeling that
we might be doing something wrong. The distributed
nature of deferred probes will become quite elusive
if the deferral request comes from some place
before probe() is even called on the driver.

Please check my RFC patch and tell me above errors
in the above reasoning....

Yours,
Linus Walleij
