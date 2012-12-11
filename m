Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753962Ab2LKPVG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 10:21:06 -0500
Received: from mail.free-electrons.com ([88.190.12.23]:59520 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752883Ab2LKPVE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 10:21:04 -0500
Date: Tue, 11 Dec 2012 16:20:48 +0100
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-kernel@vger.kernel.org, Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: Re: [PATCH 3/4 v2] gpio/mvebu: convert to use
 irq_domain_add_simple()
Message-ID: <20121211162048.6c9206c7@skate>
In-Reply-To: <1350644042-31793-1-git-send-email-linus.walleij@linaro.org>
References: <1350644042-31793-1-git-send-email-linus.walleij@linaro.org>
Organization: Free Electrons
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Linus Walleij,

On Fri, 19 Oct 2012 12:54:02 +0200, Linus Walleij wrote:
> The MVEBU driver probably just wants a few IRQs. Using the simple
> domain has the upside of allocating IRQ descriptors if need be,
> especially in a SPARSE_IRQ environment.

Unfortunately, this creates the following warning at boot time for each
GPIO bank:

------------[ cut here ]------------
WARNING: at /home/thomas/projets/linux-2.6/kernel/irq/irqdomain.c:181 irq_domain_add_simple+0x8c/0x9c()
Cannot allocate irq_descs @ IRQ33, assuming pre-allocated
Modules linked in:
[<c0014360>] (unwind_backtrace+0x0/0xf8) from [<c001d2b0>] (warn_slowpath_common+0x4c/0x64)
[<c001d2b0>] (warn_slowpath_common+0x4c/0x64) from [<c001d35c>] (warn_slowpath_fmt+0x30/0x40)
[<c001d35c>] (warn_slowpath_fmt+0x30/0x40) from [<c0065be4>] (irq_domain_add_simple+0x8c/0x9c)
[<c0065be4>] (irq_domain_add_simple+0x8c/0x9c) from [<c02641f8>] (mvebu_gpio_probe+0x3cc/0x49c)
[<c02641f8>] (mvebu_gpio_probe+0x3cc/0x49c) from [<c0185000>] (platform_drv_probe+0x18/0x1c)
[<c0185000>] (platform_drv_probe+0x18/0x1c) from [<c0183db4>] (driver_probe_device+0x70/0x1f0)
[<c0183db4>] (driver_probe_device+0x70/0x1f0) from [<c01826ac>] (bus_for_each_drv+0x5c/0x88)
[<c01826ac>] (bus_for_each_drv+0x5c/0x88) from [<c0183d1c>] (device_attach+0x74/0x80)
[<c0183d1c>] (device_attach+0x74/0x80) from [<c01833b4>] (bus_probe_device+0x84/0xa8)
[<c01833b4>] (bus_probe_device+0x84/0xa8) from [<c0181ce0>] (device_add+0x4ac/0x57c)
[<c0181ce0>] (device_add+0x4ac/0x57c) from [<c01dfa60>] (of_platform_device_create_pdata+0x5c/0x80)
[<c01dfa60>] (of_platform_device_create_pdata+0x5c/0x80) from [<c01dfb50>] (of_platform_bus_create+0xcc/0x270)
[<c01dfb50>] (of_platform_bus_create+0xcc/0x270) from [<c01dfbb0>] (of_platform_bus_create+0x12c/0x270)
[<c01dfbb0>] (of_platform_bus_create+0x12c/0x270) from [<c01dfd54>] (of_platform_populate+0x60/0x98)
[<c01dfd54>] (of_platform_populate+0x60/0x98) from [<c033c938>] (armada_370_xp_dt_init+0x18/0x24)
[<c033c938>] (armada_370_xp_dt_init+0x18/0x24) from [<c03383a8>] (customize_machine+0x1c/0x28)
[<c03383a8>] (customize_machine+0x1c/0x28) from [<c0008704>] (do_one_initcall+0x34/0x174)
[<c0008704>] (do_one_initcall+0x34/0x174) from [<c0262060>] (kernel_init+0x100/0x2b4)
[<c0262060>] (kernel_init+0x100/0x2b4) from [<c000df98>] (ret_from_fork+0x14/0x3c)
---[ end trace 1b75b31a2719ed1c ]---

Of course, the fix should be to remove the irq_alloc_descs() from the
driver prior to calling irq_domain_add_simple(). But the thing is that
our gpio-mvebu driver uses the
irq_alloc_generic_chip()/irq_setup_generic_chip() infrastructure, which
it seems requires a legacy IRQ domain (it needs the base IRQ number).

Or maybe there's a proper fix I'm missing?

Thanks,

Thomas
-- 
Thomas Petazzoni, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
