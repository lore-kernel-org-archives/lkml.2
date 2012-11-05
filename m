Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752686Ab2KECsE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2012 21:48:04 -0500
Received: from mail-ia0-f174.google.com ([209.85.210.174]:47301 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751684Ab2KECsC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2012 21:48:02 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.02.1211041708190.1960@localhost6.localdomain6>
References: <1351974625-10282-1-git-send-email-Julia.Lawall@lip6.fr>
 <CA+1xoqd-UQXg0nuE1t5ayYY1Ow81er2mHUFUow=mfcwzkCPW5A@mail.gmail.com>
 <alpine.DEB.2.02.1211041656580.1960@localhost6.localdomain6>
 <CA+1xoqfa6CMcsjuOQ_QRRK7kGwkFPCVvrS44rk3Xf1S2HFPTow@mail.gmail.com> <alpine.DEB.2.02.1211041708190.1960@localhost6.localdomain6>
From: Sasha Levin <levinsasha928@gmail.com>
Date: Sun, 4 Nov 2012 21:47:41 -0500
Message-ID: <CA+1xoqd6TZDsFqtcZuX9A7SOcRfvoZuv5A4wY5bkyGwPJjSF-g@mail.gmail.com>
Subject: Re: [PATCH 0/8] drop if around WARN_ON
To: Julia Lawall <julia.lawall@lip6.fr>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 4, 2012 at 11:16 AM, Julia Lawall <julia.lawall@lip6.fr> wrote:
> I didn't change any cases where the if test contains a function call.  The
> current definitions of WARN_ON seem to always evaluate the condition
> expression, but I was worried that that might not always be the case.  And
> calling a function (the ones I remember were some kinds of print functions)
> seems like something one might not want buried in the argument of a
> debugging macro.

Makes sense.

> WARN_ON_SMP is just WARN_ON if CONFIG_SMP is true, but it is just 0
> otherwise.  So in that case it seems important to check that one is not
> throwing away something important.

Yup, we just need to make sure that the expression being evaluated doesn't
have side-effects.

> I remember working on the BUG_ON case several years ago, and other people
> worked on it too, but I guess some are still there...  The current
> definitions of BUG_ON seem to keep the condition, but there are quite a few
> specialized definitions, so someone at some point might make a version that
> does not have that property.

It makes sense to keep an eye for such things when converting code. I
also don't think we'll get to see a version of BUG_ON which doesn't
evaluate the expression since the kernel already has more than enough
BUG_ONs that assume the expression will be evaluated:

BUG_ON(HYPERVISOR_callback_op(CALLBACKOP_register, &event));
BUG_ON(gpiochip_add(&gemini_gpio_chip));
BUG_ON(clocksource_register_hz(&sirfsoc_clocksource, CLOCK_TICK_RATE));
BUG_ON(gpio_request(ZOOM2_HEADSET_MUX_GPIO, "hs_mux") < 0);

And so on, so we're probably safe converting to BUG_ON even if the
condition is a function, as long as it doesn't create a long and
complicated BUG_ON() ofcourse.


Thanks,
Sasha
