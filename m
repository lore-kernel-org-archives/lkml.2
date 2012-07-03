Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756114Ab2GCOBp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 10:01:45 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:63371 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750731Ab2GCOBo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 10:01:44 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCH 1/1] mfd: Fix runtime warning caused by duplicate device registration
Date: Tue, 3 Jul 2012 14:01:35 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0-rc1+; KDE/4.3.2; x86_64; ; )
Cc: Lee Jones <lee.jones@linaro.org>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linus.walleij@stericsson.com,
        sameo@linux.intel.com
References: <1341316788-12730-1-git-send-email-lee.jones@linaro.org> <4FF2EEA1.6080204@linaro.org> <20120703132447.GN29030@opensource.wolfsonmicro.com>
In-Reply-To: <20120703132447.GN29030@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201207031401.36262.arnd@arndb.de>
X-Provags-ID: V02:K0:dj+b+/t80UOZEuutrk3GxOnD1tHjrOKizP59xE1j4Wb
 WDhj6YHLVXSedrpoaesBwSveQ2npPRaOuxFyeAKfM7UnIHDNKK
 3e/3x/csNNyRV33jUwQHIDe1izuOQ//SsR4SgoNtwlXE7PEVyx
 85G9cqsN2ocLZLRmFP5w0OT4+US4j4DmPUROpGkiR03LT0cydt
 itNEFvhhLFHTWFS7yefIaCZ1QgxIRic0+kDtArjfjjRm9YwT+8
 25vdrXJIXIt5UgGG0MNMUl6cEEUvHpwT9MJziA5X/nm7Ta/4wY
 21QlSBx8zp7ToGaVj74C3kpYEC6jtJ5nEoP78KPg/doNJkHK3D
 ivtvnnftUsjtYtcMXDP0=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 03 July 2012, Mark Brown wrote:
> > Before, when we probed each device from Device Tree we came up
> > against some fairly major limitations of the Device Tree. As a
> > result, Arnd and I agreed that this was the way to go.
> 
> I'm really unconvinced that instnatiating the MFD cells from device tree
> is in general a good idea.

In general it's not, e.g. it makes no sense when the MFD is just
a bunch of registers that are mapped to various distinct Linux
devices. The two mfd devices on ux500 (prcmu and ab8500) are really
buses by themselves that happen to be implemented using the MFD
framework on Linux.

I don't see how we would get around representing the buses in
the device tree because we have to refer to nodes under them
from off-chip devices. Simplified we have something like


  db9500 {
	prcmu {
		opp@1 {
		};

		regulator@2 {
		};

		watchdog@4 {
		};

		ab8500@5 {
			regulator@3 {
			};
			regulator@4 {
			};
			adc@a {
			};
			rtc@f {
			};
			irq@e {
			};
			gpio@10 {
			};
		};
	};
  };

Most of the stuff on the board is connected to the ab8500 regulators and
gpio pins, which are also used as interrupts. In order to hook up
the external devices in the device tree, we need to have something that
we can point to as their interrupt-parent or the phandle in the gpio
description.

	Arnd
