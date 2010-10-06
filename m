Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932695Ab0JFPOh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 11:14:37 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:41915 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756208Ab0JFPOg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 11:14:36 -0400
Date: Wed, 6 Oct 2010 08:14:47 -0700
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Linus Walleij <linus.ml.walleij@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Igor Grinberg <grinberg@compulab.co.il>,
        Marek Vasut <marek.vasut@gmail.com>,
        linux-arm-kernel@lists.infradead.org, vapier@gentoo.org,
        khilman@deeprootsystems.com, linux-kernel@vger.kernel.org,
        pavel@ucw.cz, linux-input@vger.kernel.org, eric.y.miao@gmail.com,
        akpm@linux-foundation.org
Subject: Re: [PATCH v2] Input: Make ADS7846 independent on regulator
Message-ID: <20101006151446.GA2803@opensource.wolfsonmicro.com>
References: <20100909094120.GB1988@rakim.wolfsonmicro.main>
 <4CAACA63.6090202@compulab.co.il>
 <20101005161608.GD19730@core.coreip.homeip.net>
 <20101005164037.GA20555@opensource.wolfsonmicro.com>
 <20101005180703.GD21399@core.coreip.homeip.net>
 <20101005185942.GA22808@opensource.wolfsonmicro.com>
 <20101005203508.7df590db@lxorguk.ukuu.org.uk>
 <AANLkTimTW6v3N9aRA0h15SWXbBc_W0dhpf5rEeqBqGbf@mail.gmail.com>
 <20101005225223.GC23315@opensource.wolfsonmicro.com>
 <AANLkTi=+xGpqSrhPB_nLqJd_E0DzLdeb4AaQQQqP04h3@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTi=+xGpqSrhPB_nLqJd_E0DzLdeb4AaQQQqP04h3@mail.gmail.com>
X-Cookie: You now have Asian Flu.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 06, 2010 at 10:01:10AM +0200, Linus Walleij wrote:
> 2010/10/6 Mark Brown <broonie@opensource.wolfsonmicro.com>:

> > No, this is actively unhelpful.  If consumers can null check their
> > regulators then they can just as well do an IS_ERR() check

> .. and wrap all enable/disable/ etc into conditional statements
> that depend on whether we could locate a regulator or not.

This is a totally different use case to that being discussed in this
thread - the use case being discussed in this thread is for things like
core power supplies which are critical to the operation of the device.
The expected error handling if these supplies are missing would be to
abort.

For users that can reasonably do optional supplies I'd expect that there
would be other code which also needs to be conditional which relies on
some action having being taken on the regulator and would also need to
be bypassed so it'd be a bit surprising if things didn't get caught up
in a bigger conditional block.

> I think what Alan requested is that it be made more seamless.

I'm fairly sure he's talking about the use case above, though I'm not
100% sure how familiar with the API Alan is.  Note also that the way
you've done this with things returning success for nonexistant supplies
means that things are less seamless than they might be.

> > The existing dummy regulator support already does all this in a manner
> > which is much less invasive for the core.

> Correct me if I'm wrong but the dummy regulators are something
> different which appear when you choose to compile out regulator
> support altogether.

No, they're a feature of the compiled in regulator API (which happen to
behave in the same manner as the stubs you get if the API is disbled).

> This was not what Alan was asking about I believe, the usecase
> to addressed is partial regulator support, where regulator framework
> *is* compiled in, but a driver *may* not get a regulator from the
> framework.

He's looking for something that can be used for supplies that are
critical to device operation on random devices on the board, something
that says that all unconfigured supplies are actually provided by
non-specific fixed voltage regulators.  This is different from the case
where some supplies may be missing because they really are not present
(in that the supplies are there, we've just not told the system how
they're provided).  Alan and Marek need boards to be able to say that
every device on the board has a supply even if it's not explicitly
configured while you want to be able to more easily ignore failures with
specific supplies.

> If I read your answer right, your stance is that the regulator
> framework shall not help out in situations like this, instead
> the driver shall recognice -ENODEV from regulator_get() and
> avoid doing any regulator calls after that. Is this correct?

Pretty much for your use case, though if enough things like MMC have
cases where supplies truly can just be omitted with no effect on the
operation of the system at all then I guess a consumer initiated way to
request a dummy could be in order.  I'd worry that people will just end
up randomly using it for all supplies, though.
