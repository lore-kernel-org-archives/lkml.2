Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754000Ab1DTAJQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 20:09:16 -0400
Received: from outbound.icp-qv1-irony-out6.iinet.net.au ([203.59.1.109]:37548
	"EHLO outbound.icp-qv1-irony-out6.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753440Ab1DTAJP convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 20:09:15 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApEBAEgjrk3L2T1e/2dsb2JhbAANrxO8VoVxBJIp
X-IronPort-AV: E=Sophos;i="4.64,242,1301846400"; 
   d="scan'208";a="234199191"
Subject: Re: [PATCH 1/2] gpio: add pin biasing and drive mode to gpiolib
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
From: Ben Nizette <bn@niasdigital.com>
In-Reply-To: <20110419093855.36910400@lxorguk.ukuu.org.uk>
Date: Wed, 20 Apr 2011 10:09:10 +1000
Cc: Linus Walleij <linus.walleij@stericsson.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Lee Jones <lee.jones@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <D3BCC8A3-7570-49F2-838C-A2B1899B0519@niasdigital.com>
References: <1303076273-8093-1-git-send-email-linus.walleij@stericsson.com> <3F5641E3-C443-4541-9FDA-24D215597C1F@niasdigital.com> <20110418091902.13345132@lxorguk.ukuu.org.uk> <92FFDB9F-37F1-4618-A53D-FEF4151A4953@niasdigital.com> <20110418132629.12d9a106@lxorguk.ukuu.org.uk> <6C3F739A-A157-4796-9572-C6B0FAC2565E@niasdigital.com> <20110419093855.36910400@lxorguk.ukuu.org.uk>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
X-Mailer: Apple Mail (2.1084)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 19/04/2011, at 6:38 PM, Alan Cox wrote:

>>> It also doesn't solve the real problem which is that you've got to
>>> implement platform specific parallel gpio extensions all over the place
>>> when you really want it all using the same 'handle' and request logic.
>> 
>> Fair enough.  Forgive me if you've stated this in a previous conversation
>> then but what do you see as being the best way forward here?  Should
>> gpiolib enforce itself as the One True Allocator and require all firmware
>> drivers call back in to it to get access to the pins rather than gpiolib
>> calling back to the platform upon gpio_request()?
> 
> We need something to allocate gpios and manage them. gpiolib seems to be
> very good at this. We also need gpiolib to route other requests because
> gpiolib is the one thing which knows how to turn "gpio 43" a struct and
> function calls.
> 
>>> And for a lot of this stuff that the gpio layer really doesn't want
>>> internal knowledge of other chunks of the kernel have used models like
>>> 'get_property/set_property' (eg battery, video4linux etc) so that the mid
>>> layer can plumb in a conversation between the handle owner and the driver
>>> without getting involved in the conversation.
>> 
>> Yeah that sounds like a more reasonable way to expose this functionality if
>> the driver does indeed need it.
> 
> Leaving aside the current input/output and on/off bits I would go for
> being able to do
> 
> 	gpio_get_property(gpio, GPIO_BIAS, GPIO_BIAS_WHATEVER);
> 	gpio_set_property(gpio, GPIO_BIAS, GPIO_BIAS_WHATEVER_ELSE);

Yeah I'm all for that so long as the capability constants are defined by the gpio provider, eg <linux/gpio/mygpioexpander.h>.  There's no way gpiolib should be keeping a big ole list of every possible config option for every gpio provider.  Well, maybe gpiolib can know about the options (eg GPIO_BIAS) so long as it doesn't have to enumerate every possible value.

Thanks,
	--Ben.


> 
> and having gpiolib perform nothing more on these than
> 
> 	is the gpio allocated 
> 	does ->get_property() exist
> 		no -EOPNOTSUPP
> 		yes return ->get_proprty(gpio struct, op, val)
> 	
> For dynamically configurable features that avoids the 
> 
> 	gpio_request(35);
> 	magic_platform_hack(&foo[3], blah); /* foo3 will be gpio35 */
> 
> type stuff that becomes unmaintainable.
> 
> It would be entirely optional for a driver to support any of this stuff,
> but it would both allow drivers to do so and also mean that where there
> are multiple devices with a common feature *and* a driver wants to use it
> that it will be properly abstracted in the driver itself.
> 
> 
> Alan
> 
> 
> 
>> 
>> 	--Ben.
>> 
>>> 
>>> Alan
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>> Please read the FAQ at  http://www.tux.org/lkml/
>> 
> 
> 
> -- 
> --
> 	"Alan, I'm getting a bit worried about you."
> 				-- Linus Torvalds
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

