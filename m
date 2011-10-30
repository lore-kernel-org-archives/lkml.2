Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934290Ab1J3RM0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Oct 2011 13:12:26 -0400
Received: from smtp-out1.tiscali.nl ([195.241.79.176]:57971 "EHLO
	smtp-out1.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934231Ab1J3RMZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Oct 2011 13:12:25 -0400
Subject: Re: [PATCH] [RESEND] media: tea5764: reconcile Kconfig symbol and
 macro
From: Paul Bolle <pebolle@tiscali.nl>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <4EAD7E9F.6050709@xenotime.net>
References: <1319976530.14409.17.camel@x61.thuisdomein>
	 <4EAD7E9F.6050709@xenotime.net>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 30 Oct 2011 18:12:18 +0100
Message-ID: <1319994738.14409.37.camel@x61.thuisdomein>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-10-30 at 09:43 -0700, Randy Dunlap wrote:
> On 10/30/11 05:08, Paul Bolle wrote:
> > The Kconfig symbol RADIO_TEA5764_XTAL is unused. The code does use a
> > RADIO_TEA5764_XTAL macro, but does that rather peculiar. But there seems
> > to be a way to keep both. (The easiest way out would be to rip out both
> > the Kconfig symbol and the macro.)
> > 
> > Note there's also a module parameter 'use_xtal' to influence all this.
> 
> It's curious that the module parameter is only available when the driver
> is builtin (=y) but not built as a loadable module (=m):

As far as I can see the module parameter is available in both cases but
defaults to different values when builtin and when loadable. 

> config RADIO_TEA5764_XTAL
> 	bool "TEA5764 crystal reference"
> 	depends on RADIO_TEA5764=y
> 	default y

0) I've noticed similar dependencies (while doing some other Kconfig
related clean up) with a number of other config entries in that same
Kconfig file:
    $ git grep -n "depends on.*=y" drivers/media/radio/
    drivers/media/radio/Kconfig:60: depends on RADIO_RTRACK=y
    drivers/media/radio/Kconfig:83: depends on RADIO_RTRACK2=y
    drivers/media/radio/Kconfig:106:        depends on RADIO_AZTECH=y
    drivers/media/radio/Kconfig:135:        depends on RADIO_GEMTEK=y
    drivers/media/radio/Kconfig:147:        depends on RADIO_GEMTEK=y
    drivers/media/radio/Kconfig:239:        depends on RADIO_TERRATEC=y
    drivers/media/radio/Kconfig:257:        depends on RADIO_TRUST=y
    drivers/media/radio/Kconfig:280:        depends on RADIO_TYPHOON=y
    drivers/media/radio/Kconfig:287:        depends on RADIO_TYPHOON=y
    drivers/media/radio/Kconfig:314:        depends on RADIO_ZOLTRIX=y
    drivers/media/radio/Kconfig:385:        depends on RADIO_TEA5764=y 

1) It seems the logic behind those config symbols is mostly like this:
- if the driver for a radio is builtin: default some setting for that
  radio to a sane value, but allow overriding of that setting on the
  kernel commandline (through a module parameter)
- if the driver for a radio is a module: default that same setting to
  something invalid and _force_ the use of module parameters to get a
  sane value

This logic isn't implemented flawless but it does look to me that this
is intentional.

2) I'm not sure why things are done that way. Why can't builtin drivers
and loadable drivers default to identical values? But perhaps I'm just
misunderstanding the code.


Paul Bolle

