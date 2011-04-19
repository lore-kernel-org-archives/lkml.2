Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753828Ab1DSIiY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 04:38:24 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:49094 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752833Ab1DSIiW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 04:38:22 -0400
Date: Tue, 19 Apr 2011 09:38:55 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Ben Nizette <bn@niasdigital.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Lee Jones <lee.jones@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH 1/2] gpio: add pin biasing and drive mode to gpiolib
Message-ID: <20110419093855.36910400@lxorguk.ukuu.org.uk>
In-Reply-To: <6C3F739A-A157-4796-9572-C6B0FAC2565E@niasdigital.com>
References: <1303076273-8093-1-git-send-email-linus.walleij@stericsson.com>
	<3F5641E3-C443-4541-9FDA-24D215597C1F@niasdigital.com>
	<20110418091902.13345132@lxorguk.ukuu.org.uk>
	<92FFDB9F-37F1-4618-A53D-FEF4151A4953@niasdigital.com>
	<20110418132629.12d9a106@lxorguk.ukuu.org.uk>
	<6C3F739A-A157-4796-9572-C6B0FAC2565E@niasdigital.com>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > It also doesn't solve the real problem which is that you've got to
> > implement platform specific parallel gpio extensions all over the place
> > when you really want it all using the same 'handle' and request logic.
> 
> Fair enough.  Forgive me if you've stated this in a previous conversation
> then but what do you see as being the best way forward here?  Should
> gpiolib enforce itself as the One True Allocator and require all firmware
> drivers call back in to it to get access to the pins rather than gpiolib
> calling back to the platform upon gpio_request()?

We need something to allocate gpios and manage them. gpiolib seems to be
very good at this. We also need gpiolib to route other requests because
gpiolib is the one thing which knows how to turn "gpio 43" a struct and
function calls.

> > And for a lot of this stuff that the gpio layer really doesn't want
> > internal knowledge of other chunks of the kernel have used models like
> > 'get_property/set_property' (eg battery, video4linux etc) so that the mid
> > layer can plumb in a conversation between the handle owner and the driver
> > without getting involved in the conversation.
> 
> Yeah that sounds like a more reasonable way to expose this functionality if
> the driver does indeed need it.

Leaving aside the current input/output and on/off bits I would go for
being able to do

	gpio_get_property(gpio, GPIO_BIAS, GPIO_BIAS_WHATEVER);
	gpio_set_property(gpio, GPIO_BIAS, GPIO_BIAS_WHATEVER_ELSE);

and having gpiolib perform nothing more on these than

	is the gpio allocated 
	does ->get_property() exist
		no -EOPNOTSUPP
		yes return ->get_proprty(gpio struct, op, val)
	
For dynamically configurable features that avoids the 

	gpio_request(35);
	magic_platform_hack(&foo[3], blah); /* foo3 will be gpio35 */

type stuff that becomes unmaintainable.

It would be entirely optional for a driver to support any of this stuff,
but it would both allow drivers to do so and also mean that where there
are multiple devices with a common feature *and* a driver wants to use it
that it will be properly abstracted in the driver itself.


Alan



> 
> 	--Ben.
> 
> > 
> > Alan
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> 


-- 
--
	"Alan, I'm getting a bit worried about you."
				-- Linus Torvalds
