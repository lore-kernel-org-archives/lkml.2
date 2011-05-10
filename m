Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752630Ab1EJVpb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 17:45:31 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:57764 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752319Ab1EJVp3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 17:45:29 -0400
Date: Tue, 10 May 2011 22:45:18 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-kernel@vger.kernel.org, Grant Likely <grant.likely@secretlab.ca>,
        Martin Persson <martin.persson@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 0/4] Pinmux subsystem
Message-ID: <20110510214518.GB5315@n2100.arm.linux.org.uk>
References: <1304363768-30338-1-git-send-email-linus.walleij@stericsson.com> <20110502225708.GD28001@n2100.arm.linux.org.uk> <BANLkTikSwkYEvbQ8XVrB3LUetVqBBUjT2g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTikSwkYEvbQ8XVrB3LUetVqBBUjT2g@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 10, 2011 at 11:25:44PM +0200, Linus Walleij wrote:
> It can, basically:
> 
> struct pinmux *pmx;
> 
> pmx = pinmux_get(dev, "irda-uart");
> pinmux_enable(pmx);
> (... SIR UART operations ...)
> pinmux_disable(pmx);
> pinmux_put(pmx);
> (... stuff to init FIR silicon ...)
> pmx = pinmux_get(dev, "irda-fir");
> pinmux_enable(pmx);
> (... etc ...)

You really don't want to do this.  It's not that SIR and FIR are that
exclusive.  You only switch to FIR mode when you've negotiated in SIR
mode, and then there's tight timings for doing that.  Essentially you
agree in SIR mode to switch to FIR mode, switch to FIR mode and expect
a response in FIR mode from the remote end.

Calling out to lots of functions to perform the switch is asking for
that response to be missed because you've not set things up for it.

You'd want to have SIR and FIR mode 'got', and then switch as quickly
as possible between them.
