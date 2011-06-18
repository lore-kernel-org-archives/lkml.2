Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755945Ab1FRAxX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 20:53:23 -0400
Received: from lunge.queued.net ([66.23.231.200]:59910 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753258Ab1FRAxV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 20:53:21 -0400
Date: Fri, 17 Jun 2011 17:53:16 -0700
From: Andres Salomon <dilinger@queued.net>
To: Daniel Drake <dsd@laptop.org>
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, bigeasy@linutronix.de
Subject: Re: [PATCH v2 05/11] x86, olpc: Add XO-1 SCI driver and power
 button control
Message-ID: <20110617175316.0bcd69f0@debxo>
In-Reply-To: <1307649936-23655-6-git-send-email-dsd@laptop.org>
References: <1307649936-23655-1-git-send-email-dsd@laptop.org>
	<1307649936-23655-6-git-send-email-dsd@laptop.org>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu,  9 Jun 2011 21:05:30 +0100
Daniel Drake <dsd@laptop.org> wrote:

> The System Control Interrupt is used in the OLPC XO-1 to control
> various features of the laptop. Add the driver base and the power
> button functionality.
> 
> This driver can't be built as a module, because functionality added in
> future patches means that some drivers need to know at boot-time
> whether SCI-based functionality is available.
> 
> Signed-off-by: Daniel Drake <dsd@laptop.org>
> Acked-by: Andres Salomon <dilinger@queued.net>
> ---
>  arch/x86/Kconfig                      |    7 ++
>  arch/x86/platform/olpc/Makefile       |    1 +
>  arch/x86/platform/olpc/olpc-xo1-sci.c |  191
> +++++++++++++++++++++++++++++++++
> include/linux/cs5535.h                |    8 ++ 4 files changed, 207
> insertions(+), 0 deletions(-) create mode 100644
> arch/x86/platform/olpc/olpc-xo1-sci.c
> 
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index c9cdd7b..fb9d136 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -2079,6 +2079,13 @@ config OLPC_XO1_PM
>  	---help---
>  	  Add support for poweroff and suspend of the OLPC XO-1
> laptop. 
> +config OLPC_XO1_SCI
> +	bool "OLPC XO-1 SCI extras"
> +	depends on OLPC && OLPC_XO1_PM
> +	---help---


FYI, I just hit the following:

arch/x86/built-in.o: In function `xo1_pm_probe':
olpc-xo1-pm.c:(.devinit.text+0x105): undefined reference to
`mfd_cell_enable'
arch/x86/built-in.o: In function `xo1_sci_probe':
olpc-xo1-sci.c:(.devinit.text+0x1c1): undefined reference to
`mfd_cell_enable'
olpc-xo1-sci.c:(.devinit.text+0x3e6): undefined reference to
`cs5535_gpio_clear'


This is due to mfd-core and cs5535-gpio being built as modules, while
the olpc-xo1-sci stuff is built in.  The following patch will fix that.



From: Andres Salomon <dilinger@queued.net>
Subject: [PATCH] x86, olpc: fix build problems in xo1-sci and xo1-pm drivers

If one builds gpio-cs5535 and mfd-core as modular, the olpc-xo1-{sci,pm}
drivers will fail to build due to missing symbols.  This fixes that by
forcing them to be built into the kernel rather than allowing them to
be modular.

Signed-off-by: Andres Salomon <dilinger@queued.net>
---
 arch/x86/Kconfig |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 2a224ec..8af5ba8 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -2076,6 +2076,7 @@ config OLPC
 config OLPC_XO1_PM
 	bool "OLPC XO-1 Power Management"
 	depends on OLPC && MFD_CS5535 && PM_SLEEP
+	select MFD_CORE
 	---help---
 	  Add support for poweroff and suspend of the OLPC XO-1 laptop.
 
@@ -2089,6 +2090,8 @@ config OLPC_XO1_RTC
 config OLPC_XO1_SCI
 	bool "OLPC XO-1 SCI extras"
 	depends on OLPC && OLPC_XO1_PM && POWER_SUPPLY
+	select GPIO_CS5535
+	select MFD_CORE
 	---help---
 	  Add support for SCI-based features of the OLPC XO-1 laptop:
 	   - EC-driven system wakeups
-- 
1.7.2.5


