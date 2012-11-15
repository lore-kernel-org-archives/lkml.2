Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423677Ab2KOSXH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 13:23:07 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:47062 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423552Ab2KOSXF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 13:23:05 -0500
Message-ID: <50A53304.6040904@wwwdotorg.org>
Date: Thu, 15 Nov 2012 11:23:00 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Stephen Warren <swarren@nvidia.com>,
        Anmar Oueja <anmar.oueja@linaro.org>, Felipe Balbi <balbi@ti.com>,
        Benoit Cousson <b-cousson@ti.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Mitch Bradley <wmb@firmworks.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Kevin Hilman <khilman@ti.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Rickard Andersson <rickard.andersson@stericsson.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Russell King <linux@arm.linux.org.uk>
Subject: Re: [PATCH] RFC: pinctrl: grab default handler with bus notifiers
References: <1352636539-6318-1-git-send-email-linus.walleij@stericsson.com> <50A15A54.3090803@wwwdotorg.org> <20121113063546.GD18224@opensource.wolfsonmicro.com> <CACRpkdY-tye5LNOwxQ-XrjM-x9RffAvj-tPfsFQA3ZWOY8P-Vw@mail.gmail.com>
In-Reply-To: <CACRpkdY-tye5LNOwxQ-XrjM-x9RffAvj-tPfsFQA3ZWOY8P-Vw@mail.gmail.com>
X-Enigmail-Version: 1.4.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/15/2012 07:03 AM, Linus Walleij wrote:
> On Tue, Nov 13, 2012 at 7:35 AM, Mark Brown
> <broonie@opensource.wolfsonmicro.com> wrote:
>> On Mon, Nov 12, 2012 at 01:21:40PM -0700, Stephen Warren wrote:
>>> On 11/11/2012 05:22 AM, Linus Walleij wrote:
>>
>>>> Another solution that was discussed was whether to move
>>>> the default pinctrl handle and state grab to the device
>>>> core as an optional field in struct device itself, but
>>>> I'd like to first propose this less intrusive mechanism.
>>
>>> I think doing that approach makes a lot more sense; wouldn't it
>>> completely avoid the issues with deferred probe that this notifier-based
>>> method can't solve? It would also be very much in line with e.g.
>>> dev_get_regmap() - if every resource that a driver required were handled
>>> like that, then deferred probe could be significantly isolated into the
>>> driver core rather than in every driver...
>>
>> I have to say that I agree with this, notifiers seem to make life more
>> complicated for limited gain.  Otherwise I guess we could enhance
>> notifiers so that they're able to trigger deferrals?
> 
> OK I'll have to come up with a patch to the device core
> instead... it'll be much simpler anyway and if both of you guys
> can back it I guess Greg might be OK with it too.

I did have one thought here; how will this interact with hogs? If a
device's pinctrl configuration must be pinctrl_get()'d before the device
is probed, then a pinctrl device with hogs will never get probed because
it won't be registered to provide the pinctrl node parsing. Solutions
might include:

a) Some special case where if the pinctrl driver only can't probe due to
missing pinctrl from its own node, don't defer the probe, but defer the
pinctrl_get().

b) Separate out DT node parsing from device instantiation, so that the
driver can always parse the DT, without needing the context of a
specific pinctrl device to do so.

I haven't thought through this in any detail though.
