Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754892Ab1HFIsP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Aug 2011 04:48:15 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:43725 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752576Ab1HFIsM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Aug 2011 04:48:12 -0400
Date: Sat, 6 Aug 2011 09:48:05 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Colin Cross <ccross@google.com>
Cc: Stephen Warren <swarren@nvidia.com>, Ben Dooks <ben-linux@fluff.org>,
        Dilan Lee <dilee@nvidia.com>, linux-i2c@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] i2c/tegra: I2C driver uses the
 suspend_noirq/resume_noirq
Message-ID: <20110806084805.GA18098@sirena.org.uk>
References: <1312586102-27907-1-git-send-email-swarren@nvidia.com>
 <CAMbhsRScgMaTZ2e3a__OgOrrA6HN9_dkGuuNGaEfP+iqRdjyNQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMbhsRScgMaTZ2e3a__OgOrrA6HN9_dkGuuNGaEfP+iqRdjyNQ@mail.gmail.com>
X-Cookie: Tempt me with a spoon!
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 05, 2011 at 09:33:31PM -0700, Colin Cross wrote:

Please delete unneeded context from e-mails, it makes it much easier to
find the content.

> NAK - moving the suspend order around is not the correct way to solve
> this.  If wm8903 needs to talk to the i2c bus in its suspend handler,
> it needs to be child device on the i2c bus.  suspend_noirq is for

WM8903 is an I2C device.  The problem is that it's suspended as part of
the ASoC suspend since the audio subsystem is composed of multiple
devices that all need to work together coherently.  I did start doing
some stuff to bodge around this like we do on probe but there are enough
system wide problems with this that it didn't seem worth the complexity
when the existing workarounds are so straightforward.

> devices that must suspend with system irqs turned off, not for
> ordering suspend handlers.

Unfortunately it's the only tool Linux has for dealing with this sort of
issue right now.  We were supposed to be getting support for telling the
PM core about dependencies but Linus didn't like that, and it's possible
Grant's stuff with allowing device binding to be retried to handle cross 
bus dependencies will help.  Right now the Linux model just doesn't have
any understanding of cross device dependencies other than control buses.

One other example of this is that you're also going to have the same
problem with PMICs - random devices on the system might want to control
their regulators as part of the suspend process and typically the PMIC
is going to be connected over I2C so it needs to be available for as
long as possible.
