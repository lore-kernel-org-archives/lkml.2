Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758281Ab1GDQTW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jul 2011 12:19:22 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:51714 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755695Ab1GDQTT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jul 2011 12:19:19 -0400
Date: Mon, 4 Jul 2011 10:19:14 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-kernel@vger.kernel.org, sodaville@linutronix.de
Subject: Re: [PATCH v2 2/2] gpio: Add a driver for Sodaville GPIO controller
Message-ID: <20110704161914.GH29977@ponder.secretlab.ca>
References: <1309159583-11339-1-git-send-email-bigeasy@linutronix.de>
 <1309159583-11339-2-git-send-email-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1309159583-11339-2-git-send-email-bigeasy@linutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 27, 2011 at 09:26:23AM +0200, Sebastian Andrzej Siewior wrote:
> Sodaville has GPIO controller behind the PCI bus. To my suprissed it is
> not the same as on PXA.
> 
> The interrupt & gpio chip can be referenced from the device tree like
> from any other driver. Unfortunately the driver which uses the gpio
> interrupt has to use irq_of_parse_and_map() instead of
> platform_get_irq(). The problem is that the platform device (which is
> created from the device tree) is most likely created before the
> interrupt chip is registered and therefore irq_of_parse_and_map() fails.
> 
> In theory the driver works as module. In reality most of the irq
> functions are not exported to modules and it is possible that _this_
> module is unloaded while the provided irqs are still in use.
> 
> Signed-off-by: Hans J. Koch <hjk@linutronix.de>
> [torbenh@linutronix.de: make it work after the irq namespace cleanup,
> 	                add some device tree entries.]
> Signed-off-by: Torben Hohn <torbenh@linutronix.de>
> [bigeasy@linutronix.de: convert to generic irq & gpio chip]
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> ---
>  .../devicetree/bindings/gpio/sodaville.txt         |   48 +++
>  arch/x86/platform/ce4100/falconfalls.dts           |    7 +-
>  drivers/gpio/Kconfig                               |    8 +
>  drivers/gpio/Makefile                              |    1 +
>  drivers/gpio/gpio-sodaville.c                      |  302 ++++++++++++++++++++

I tried to apply this, but it failed to build:

/home/grant/hacking/linux-2.6/drivers/gpio/gpio-sodaville.c:101:36:
error: expected declaration specifiers or ‘...’ before
‘irq_hw_number_t’
/home/grant/hacking/linux-2.6/drivers/gpio/gpio-sodaville.c: In
function ‘sdv_xlate’:
/home/grant/hacking/linux-2.6/drivers/gpio/gpio-sodaville.c:106:15:
error: ‘struct irq_domain’ has no member named ‘of_node’
/home/grant/hacking/linux-2.6/drivers/gpio/gpio-sodaville.c:113:3:
error: ‘out_hwirq’ undeclared (first use in this function)
/home/grant/hacking/linux-2.6/drivers/gpio/gpio-sodaville.c:113:3:
note: each undeclared identifier is reported only once for each
function it appears in
/home/grant/hacking/linux-2.6/drivers/gpio/gpio-sodaville.c: At top
level:
/home/grant/hacking/linux-2.6/drivers/gpio/gpio-sodaville.c:129:15:
error: variable ‘irq_domain_sdv_ops’ has initializer but incomplete
type
/home/grant/hacking/linux-2.6/drivers/gpio/gpio-sodaville.c:130:2:
error: unknown field ‘dt_translate’ specified in initializer
/home/grant/hacking/linux-2.6/drivers/gpio/gpio-sodaville.c:130:2:
warning: excess elements in struct initializer
/home/grant/hacking/linux-2.6/drivers/gpio/gpio-sodaville.c:130:2:
warning: (near initialization for ‘irq_domain_sdv_ops’)
/home/grant/hacking/linux-2.6/drivers/gpio/gpio-sodaville.c: In
function ‘sdv_register_irqsupport’:
/home/grant/hacking/linux-2.6/drivers/gpio/gpio-sodaville.c:152:8:
error: ‘struct irq_domain’ has no member named ‘irq_base’
/home/grant/hacking/linux-2.6/drivers/gpio/gpio-sodaville.c:153:8:
error: ‘struct irq_domain’ has no member named ‘of_node’
/home/grant/hacking/linux-2.6/drivers/gpio/gpio-sodaville.c:154:8:
error: ‘struct irq_domain’ has no member named ‘ops’
/home/grant/hacking/linux-2.6/drivers/gpio/gpio-sodaville.c:182:2:
error: implicit declaration of function ‘irq_domain_add’
/home/grant/hacking/linux-2.6/drivers/gpio/gpio-sodaville.c: In
function ‘sdv_gpio_remove’:
/home/grant/hacking/linux-2.6/drivers/gpio/gpio-sodaville.c:263:2:
error: implicit declaration of function ‘irq_domain_del’
make[3]: *** [drivers/gpio/gpio-sodaville.o] Error 1
make[3]: *** Waiting for unfinished jobs....
  CC      kernel/trace/trace_export.o
  make[2]: *** [drivers/gpio] Error 2
  make[2]: *** Waiting for unfinished jobs....

I assume there is a missing #include, you can either send a fixup
patch or a new version, your choice.

Also...

> diff --git a/drivers/gpio/Makefile b/drivers/gpio/Makefile
> index 0fbdd75..cc6d662 100644
> --- a/drivers/gpio/Makefile
> +++ b/drivers/gpio/Makefile
> @@ -41,6 +41,7 @@ obj-$(CONFIG_GPIO_S5PV210)	+= gpio-s5pv210.o
>  
>  obj-$(CONFIG_GPIO_SCH)		+= gpio-sch.o
>  obj-$(CONFIG_GPIO_STMPE)	+= gpio-stmpe.o
> +obj-$(CONFIG_GPIO_SODAVILLE)	+= gpio-sodaville.o
>  obj-$(CONFIG_GPIO_SX150X)	+= gpio-sx150x.o
>  obj-$(CONFIG_GPIO_TC3589X)	+= gpio-tc3589x.o
>  obj-$(CONFIG_ARCH_TEGRA)	+= gpio-tegra.o

Last I checked, SO comes before ST in alphabetized lists.  :-)

g.

