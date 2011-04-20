Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755205Ab1DTP3R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 11:29:17 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:57413 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754203Ab1DTP3Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 11:29:16 -0400
Date: Wed, 20 Apr 2011 16:29:58 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Linus Walleij <linus.ml.walleij@gmail.com>
Cc: Haojian Zhuang <haojian.zhuang@gmail.com>,
        Kyungmin Park <kmpark@infradead.org>, Ben Nizette <bn@niasdigital.com>,
        linux-kernel@vger.kernel.org, Grant Likely <grant.likely@secretlab.ca>,
        Lee Jones <lee.jones@linaro.org>, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/2] gpio: add pin biasing and drive mode to gpiolib
Message-ID: <20110420162958.09286aa7@lxorguk.ukuu.org.uk>
In-Reply-To: <BANLkTinaOk4Qq+uwdZQtapncwjpdTg9wmQ@mail.gmail.com>
References: <1303076273-8093-1-git-send-email-linus.walleij@stericsson.com>
	<3F5641E3-C443-4541-9FDA-24D215597C1F@niasdigital.com>
	<20110418091902.13345132@lxorguk.ukuu.org.uk>
	<92FFDB9F-37F1-4618-A53D-FEF4151A4953@niasdigital.com>
	<20110418132629.12d9a106@lxorguk.ukuu.org.uk>
	<6C3F739A-A157-4796-9572-C6B0FAC2565E@niasdigital.com>
	<20110419093855.36910400@lxorguk.ukuu.org.uk>
	<BANLkTimqpP2k1tBvRL0BXs9E-Q=3bh0C7Q@mail.gmail.com>
	<BANLkTint6DGgosVkjK-sveyA9SL9WVS4Mg@mail.gmail.com>
	<BANLkTinaOk4Qq+uwdZQtapncwjpdTg9wmQ@mail.gmail.com>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Some people inevitably think that GPIO and pin/padmux are
> intertwined, but as far as I have seen they are not. However there

It's not just pin muxing - gpio pins are sometimes shared between
firmware and OS and belong to one or the other depending upon what is
going on. For example the OS may need to own the pin for things like
updating or eeprom writing but the firmware or another device owns it for
day to day processing.

> may be a cross dependency so that a GPIO driver may need to
> export an additional pin/padmux interface or so, e.g we have
> a separate chip in I2C which can mux pins...

Would it not make sense to assume that given a situation where you have a
GPIO that can be routed four ways that you actually implement it like the
rest of the kernel - ie

	r = gpio_request(n);	/* n, n+1, n+2, n+3 are the four ways
				*/

	if (r < 0) 	/* EBUSY - someone else is using one of the
				four */ 
		return -EBUSY;
	/* Succeeded - will also have set the mux for us */

At that point drivers don't need to know if a GPIO is muxed it'll just be
busy if someone else is using it.

It seems to me that if the goal of the gpio layer is to provide an
abstraction then it can abstract muxes just fine and without needing
drivers to know.

Alan
