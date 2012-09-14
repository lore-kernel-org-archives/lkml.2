Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932178Ab2INObF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 10:31:05 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:55548 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932132Ab2INObA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 10:31:00 -0400
Date: Fri, 14 Sep 2012 16:30:57 +0200
From: Domenico Andreoli <cavokz@gmail.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Stephen Warren <swarren@nvidia.com>,
        Anmar Oueja <anmar.oueja@linaro.org>
Subject: Re: [PATCH] pinctrl: document semantics vs GPIO
Message-ID: <20120914143056.GA25696@glitch>
Mail-Followup-To: Linus Walleij <linus.walleij@linaro.org>,
	Stephen Warren <swarren@wwwdotorg.org>,
	Linus Walleij <linus.walleij@stericsson.com>,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	Stephen Warren <swarren@nvidia.com>,
	Anmar Oueja <anmar.oueja@linaro.org>
References: <1347519686-10170-1-git-send-email-linus.walleij@stericsson.com>
 <505205B1.4080708@wwwdotorg.org>
 <20120913221125.GA10032@glitch>
 <CACRpkdb+QC_iHOkoihqxDgC+b+PUij-qi6BiOKmnCB3vPnJTjw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdb+QC_iHOkoihqxDgC+b+PUij-qi6BiOKmnCB3vPnJTjw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 14, 2012 at 03:48:05PM +0200, Linus Walleij wrote:
> On Fri, Sep 14, 2012 at 12:11 AM, Domenico Andreoli <cavokz@gmail.com> wrote:
> > On Thu, Sep 13, 2012 at 10:11:29AM -0600, Stephen Warren wrote:
> 
> >> I think it makes sense to more strongly recommend that for GPIO muxing,
> >> the GPIO driver always call into the pinctrl subsystem (if needed by the
> >> HW) to perform that muxing, so that standalone gpio_direction_*() always
> >> work without any use of pinctrl; the interaction between the two should
> >> only be required if pin configuration (not just pin muxing) is also
> >> required.
> >
> > Don't know. Isn't possible to reach the same effect moving this kind
> > of knowledge into higher level helper functions and remove this bridge
> > across the subsystems?
> 
> I'm not following, please elaborate on this.
> 
> What are these higher level functions, and where will they be
> located? In which subsystem, and using what symbols/signatures and
> so on?

If the common case is requesting the pin and then the gpio, an helper
like this would do the trick. So why those calls into pinctrl should be
done by the GPIO driver itself?  Pinctrl and GPIO would be separated,
ignoring each other.

static int request_muxed_gpio(int gpio, const char *label)
{
	int err;

	err = pinctrl_request_gpio(gpio)
	if (err)
		return err;

	err = gpio_request(gpio, label);
	if (err)
		pinctrl_free_gpio(gpio);

	return err;
}

static void free_muxed_gpio(int gpio)
{
	gpio_free(gpio);
	pinctrl_free_gpio(gpio);
}

> Deepak or Arnd suggested to add a set of functions to the pinctrl
> driver vtable and make it possible to implement a generic gpio_chip
> deeply merged with a pin controller driver. I'm considering this,
> since it would also be a natural stepping stone to the /dev/pinctrl0
> device(s) I want to see for userspace access the day we need it.

If this is the plan, I can only agree. I thought it was a long term plan
hence the reasoning in terms of helper functions above for a shorter-term
proposal.

Regards,
Domenico
