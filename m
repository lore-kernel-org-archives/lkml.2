Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754376Ab2JVNw1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 09:52:27 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:55891 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753911Ab2JVNw0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 09:52:26 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Thierry Reding <thierry.reding@avionic-design.de>
Subject: Re: [PATCH 2/3] PWM: vt8500: Update vt8500 PWM driver support
Date: Mon, 22 Oct 2012 13:52:08 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: Tony Prisk <linux@prisktech.co.nz>, arm@kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
References: <1350643135-13197-1-git-send-email-linux@prisktech.co.nz> <201210221150.22004.arnd@arndb.de> <20121022120706.GA19467@avionic-0098.mockup.avionic-design.de>
In-Reply-To: <20121022120706.GA19467@avionic-0098.mockup.avionic-design.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201210221352.08352.arnd@arndb.de>
X-Provags-ID: V02:K0:GlpQroFxUyDK/eF+bXjN4Anqx60ToSronFQJ4hf2s43
 KyYSO1N5uhtWenGIqtoVT+cBsusKZuQJlIJeZFehw1mf6Yk39k
 HDFu2wgch/UR+B31vzodrdN7OXhVi+RInEpBYZbreMozHoi0Sk
 uxyVZ5VIXFzLEtr23KjVnt3mZc+mU5ZhoqM7bWUkO1gHLppijG
 of68khFdDhlKZ75Z8dhua+RHwasZM7YydpQMbWYmg0059crZna
 jnEW7sQjH9oHI0gJpNo4S/jfINKW1r1Q/cY3EhAkNUcQ88GchA
 TsV7IS0J+iJbEkzSBbey8wSQsuSf1U3v4V/1wpUBojWR0fOBY5
 Lfi+Umuvm67dWURaWc/Q=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 22 October 2012, Thierry Reding wrote:
> > As long as we get build warnings for leaving out the __devinit/__devexit
> > annotations, I would generally recommend putting them in. If we do a
> > patch to remove all of them, a couple extra instances will not cause
> > any more troubles than we already have.
> 
> I've never seen any build warnings for leaving __devinit/__devexit out.
> Where does that happen?

Section mismatches usually result into warnings from modpost, like

WARNING: modpost: Found 1 section mismatch(es).
To see full details build your kernel with:
'make CONFIG_DEBUG_SECTION_MISMATCH=y'

Actually doing that gives you an output like this (currently on exynos_defconfig):

$ make CONFIG_DEBUG_SECTION_MISMATCH=y
WARNING: drivers/pinctrl/built-in.o(.devinit.text+0x124): Section mismatch in reference from the function samsung_pinctrl_probe() to the function .init.text:samsung_gpiolib_register()
The function __devinit samsung_pinctrl_probe() references
a function __init samsung_gpiolib_register().
If samsung_gpiolib_register is only used by samsung_pinctrl_probe then
annotate samsung_gpiolib_register with a matching annotation.

or like this (now fixed in socfpga_defconfig):

WARNING: drivers/net/ethernet/stmicro/stmmac/stmmac.o(.text+0x5d4c): Section mismatch in reference from the function stmmac_pltfr_probe() to the function .devinit.text:stmmac_probe_config_dt()
The function stmmac_pltfr_probe() references
the function __devinit stmmac_probe_config_dt().
This is often because stmmac_pltfr_probe lacks a __devinit 
annotation or the annotation of stmmac_probe_config_dt is wrong.

I believe you normally don't get warnings for functions that could be
marked __devinit and only call regular functions, but there are
a couple of __devinit infrastructure functions that you can't call
from a function that isn't __init or __devinit.

	Arnd
