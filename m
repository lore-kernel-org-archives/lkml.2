Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756364Ab1DKXog (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 19:44:36 -0400
Received: from mail.perches.com ([173.55.12.10]:4655 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752110Ab1DKXof (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 19:44:35 -0400
Subject: Re: [RFC][PATCH V3] axi: add AXI bus driver
From: Joe Perches <joe@perches.com>
To: =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Cc: linux-wireless@vger.kernel.org,
        "John W. Linville" <linville@tuxdriver.com>,
        b43-dev@lists.infradead.org,
        Michael =?ISO-8859-1?Q?B=FCsch?= <mb@bu3sch.de>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        George Kashperko <george@znau.edu.ua>,
        Arend van Spriel <arend@broadcom.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Russell King <rmk@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Andy Botting <andy@andybotting.com>,
        linuxdriverproject <devel@linuxdriverproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <1302557114-7880-1-git-send-email-zajec5@gmail.com>
References: <1302557114-7880-1-git-send-email-zajec5@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 11 Apr 2011 16:44:32 -0700
Message-ID: <1302565473.2163.28.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-04-11 at 23:25 +0200, Rafał Miłecki wrote:

>   Proper pr_* usage
 
Just trivia...

> diff --git a/drivers/axi/axi_private.h b/drivers/axi/axi_private.h
> new file mode 100644
> index 0000000..1c995f5
> --- /dev/null
> +++ b/drivers/axi/axi_private.h
> @@ -0,0 +1,45 @@
> +#ifndef LINUX_AXI_PRIVATE_H_
> +#define LINUX_AXI_PRIVATE_H_
> +
> +#include <linux/axi/axi.h>
> +#include <linux/device.h>
> +#include <linux/list.h>
> +#include <linux/types.h>
> +#include <linux/spinlock.h>
> +#include <linux/pci.h>
> +#include <linux/mod_devicetable.h>
> +#include <linux/dma-mapping.h>
> +#include <linux/types.h>

Duplicate include of linux/types.h

> +
> +#ifndef pr_fmt
> +#define pr_fmt(fmt)		"axi: " fmt
> +#endif

This needs to be before any include that includes kernel.h
and I believe
#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
is the same output and more normally used style.

Right now, you've got no prefix for any format string.
Try '$ strings built-in.o | grep "^<.>"' and see.

> +void axi_pmu_workarounds(struct axi_drv_cc *cc)
> +{
> +	struct axi_bus *bus = cc->core->bus;
> +
> +	switch (bus->chipinfo.id) {
> +	case 0x4313:

Probably better to use defines.

> +		axi_chipco_chipctl_maskset(cc, 0, ~0, 0x7);
> +		break;
> +	case 0x4331:
> +		axi_err("Enabling Ext PA lines not implemented\n");

You should still remove axi_err/info/debug and
just use pr_<level>.


> +		break;
> +	case 43224:
> +		if (bus->chipinfo.rev == 0) {
> +			axi_err("Workarounds for 43224 rev 0 not fully "
> +					"implemented\n");

I suggest you don't bother splitting and wrapping
format strings > 80 chars.  Splitting makes grep
a bit harder.

			pr_err("Workarounds for 43224 rev 0 not fully implemented\n");

Some hex and some decimal cases?
Maybe some comments for that?

