Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758726Ab0JFIBN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 04:01:13 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:42552 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758673Ab0JFIBM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 04:01:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=U2E8BSDIrNTM/Ww7idXzGIrM9n50qDk3ItrQm5XLwPwbRmB5u1yjyvYjQGsHuK5Ssr
         8NrgL4wF6AZkCeRnmS3LT3NJYocp9ThIyFYaXjGEGJr4Ov3vxMJ2dNU1Pr8TV8Ai/oo/
         tGqaUyFHmsgBWCtwMS+OOSDfM9pX6lhoZXGf8=
MIME-Version: 1.0
In-Reply-To: <20101005225223.GC23315@opensource.wolfsonmicro.com>
References: <20100907125335.GD25830@sirena.org.uk>
	<201009091027.18176.marek.vasut@gmail.com>
	<20100909094120.GB1988@rakim.wolfsonmicro.main>
	<4CAACA63.6090202@compulab.co.il>
	<20101005161608.GD19730@core.coreip.homeip.net>
	<20101005164037.GA20555@opensource.wolfsonmicro.com>
	<20101005180703.GD21399@core.coreip.homeip.net>
	<20101005185942.GA22808@opensource.wolfsonmicro.com>
	<20101005203508.7df590db@lxorguk.ukuu.org.uk>
	<AANLkTimTW6v3N9aRA0h15SWXbBc_W0dhpf5rEeqBqGbf@mail.gmail.com>
	<20101005225223.GC23315@opensource.wolfsonmicro.com>
Date: Wed, 6 Oct 2010 10:01:10 +0200
Message-ID: <AANLkTi=+xGpqSrhPB_nLqJd_E0DzLdeb4AaQQQqP04h3@mail.gmail.com>
Subject: Re: [PATCH v2] Input: Make ADS7846 independent on regulator
From: Linus Walleij <linus.ml.walleij@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Igor Grinberg <grinberg@compulab.co.il>,
        Marek Vasut <marek.vasut@gmail.com>,
        linux-arm-kernel@lists.infradead.org, vapier@gentoo.org,
        khilman@deeprootsystems.com, linux-kernel@vger.kernel.org,
        pavel@ucw.cz, linux-input@vger.kernel.org, eric.y.miao@gmail.com,
        akpm@linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/10/6 Mark Brown <broonie@opensource.wolfsonmicro.com>:

> On Wed, Oct 06, 2010 at 12:09:39AM +0200, Linus Walleij wrote:
>
>> This wrapper function will accept non-existing regulators and
>> not treat them as errors. Consumers will have to NULL-check their
>> regulators.
>
> No, this is actively unhelpful.  If consumers can null check their
> regulators then they can just as well do an IS_ERR() check

.. and wrap all enable/disable/ etc into conditional statements
that depend on whether we could locate a regulator or not.

And yes, this is what I'm already doing in drivers like
drivers/mmc/host/mmci.c, where I check for the regulator
holder in the mmci state struct to be NULL (another way
would be to have a boolean .has_regulator but you get the
idea).

I think what Alan requested is that it be made more seamless.
The patches try to make regulator support less hairy in these
cases, a non-existing regulator will be a NULL pointer (no error
and the runtime functions will act as the compile-time stubs.

> The existing dummy regulator support already does all this in a manner
> which is much less invasive for the core.

Correct me if I'm wrong but the dummy regulators are something
different which appear when you choose to compile out regulator
support altogether.

This was not what Alan was asking about I believe, the usecase
to addressed is partial regulator support, where regulator framework
*is* compiled in, but a driver *may* not get a regulator from the
framework.

The patch makes the runtime functions with partial regulator
support for a NULL regulator behave exactly like the
compile-time stubs.

If I read your answer right, your stance is that the regulator
framework shall not help out in situations like this, instead
the driver shall recognice -ENODEV from regulator_get() and
avoid doing any regulator calls after that. Is this correct?

Yours,
Linus Walleij
