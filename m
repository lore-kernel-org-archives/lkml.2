Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752850Ab1EJVZq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 17:25:46 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:60580 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752630Ab1EJVZp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 17:25:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=gjqaVOstx+BknE7UQKvmtxKteyWkNk/a/VE2hLAa071IVoW6rc6sFBLkFsDbSjlCdI
         3WSFWsH1E9G5d3BVecj3NS3omrQ6Omw6x1JwOuAWW2f/4bp8xZn4RuRk7GRCyhy/elNw
         WaqNlyW0CJu9iD4OhyRwTWLqkJ+tJXlbN3wp8=
MIME-Version: 1.0
In-Reply-To: <20110502225708.GD28001@n2100.arm.linux.org.uk>
References: <1304363768-30338-1-git-send-email-linus.walleij@stericsson.com>
	<20110502225708.GD28001@n2100.arm.linux.org.uk>
Date: Tue, 10 May 2011 23:25:44 +0200
X-Google-Sender-Auth: dcHyAq1uKoPyx-OvLiW-7yUlhao
Message-ID: <BANLkTikSwkYEvbQ8XVrB3LUetVqBBUjT2g@mail.gmail.com>
Subject: Re: [PATCH 0/4] Pinmux subsystem
From: Linus Walleij <linus.walleij@linaro.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, Grant Likely <grant.likely@secretlab.ca>,
        Martin Persson <martin.persson@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Finally I'm back at the pinmux patch set trying to answer all questions
accumulated:

2011/5/3 Russell King - ARM Linux <linux@arm.linux.org.uk>:

> While I like the idea of consolidating the pinmuxing stuff, I'm not sure
> about having a struct pin_mux pointer in each bus types device structure.
> It'd mean this would have to be added to platform devices as well...

Yeah I'm not sure about the patch to the AMBA/PrimeCell bus really,
an alternative is for all drivers to request their mux individually. But in
the AMBA bus we already request the silicon block clock and the
silicon power switch so it seemed natural to also request a mux setting,
if there is one.

> Then there's SA1100 (and PXA?) to consider with its IrDA setup, where its
> necessary to switch the pin muxing during driver operation, when switching
> between SIR and FIR modes (SIR uses the UART, FIR uses a separate hardware
> block.)
>
> So any per-device pinmuxing subsystem also needs a way that a driver can
> change the pinmuxing of its associated pins on the fly too.

It can, basically:

struct pinmux *pmx;

pmx = pinmux_get(dev, "irda-uart");
pinmux_enable(pmx);
(... SIR UART operations ...)
pinmux_disable(pmx);
pinmux_put(pmx);
(... stuff to init FIR silicon ...)
pmx = pinmux_get(dev, "irda-fir");
pinmux_enable(pmx);
(... etc ...)

Just like you would take an alternative clock or regulator in case using i would
exclude the use of another clock/regulator.

Thanks,
Linus Walleij
