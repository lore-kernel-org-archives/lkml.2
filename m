Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759362Ab2IKOoa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 10:44:30 -0400
Received: from mail.free-electrons.com ([88.190.12.23]:60359 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758618Ab2IKOo1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 10:44:27 -0400
Date: Tue, 11 Sep 2012 16:44:09 +0200
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Lior Amsalem <alior@marvell.com>, Russell King <linux@arm.linux.org.uk>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Linus Walleij <linus.walleij@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Ben Dooks <ben.dooks@codethink.co.uk>, Rob Landley <rob@landley.net>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v3 1/9] pinctrl: mvebu: pinctrl driver core
Message-ID: <20120911164409.4c030bd8@skate>
In-Reply-To: <1347266386-16229-2-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1345623750-10645-1-git-send-email-sebastian.hesselbarth@gmail.com>
	<1347266386-16229-1-git-send-email-sebastian.hesselbarth@gmail.com>
	<1347266386-16229-2-git-send-email-sebastian.hesselbarth@gmail.com>
Organization: Free Electrons
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Sebastian,

Sorry for getting back to you so late about this patch set. I have been
very busy with other things.

Le Mon, 10 Sep 2012 10:39:38 +0200,
Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com> a écrit :

> v3:
> - list of functions is now built out of pin groups passed to core driver
>   instead of parsing DT node.

Even though I have gone through your discussion with Stephen Warren on
this, I don't get what you have done exactly, and I'm even more puzzled
by the following piece of code:

> +static int __devinit _add_function(const char **funcs, const char *name)
> +{
> +	int n = 0;
> +
> +	while (funcs[n]) {
> +		/* function already there */
> +		if (strcmp(funcs[n], name) == 0)
> +			return -EEXIST;
> +		n++;
> +	}
> +	funcs[n] = name;
> +	return 0;
> +}
> +
> +static int __devinit mvebu_pinctrl_build_functions(struct platform_device *pdev,
> +						   struct mvebu_pinctrl *pctl)
> +{
> +	const char **prefunc = kzalloc(sizeof(char *), GFP_KERNEL);
> +	int num = 0;
> +	int n, s;
> +
> +	for (n = 0; n < pctl->num_groups; n++) {
> +		struct mvebu_pinctrl_group *grp = &pctl->groups[n];
> +		for (s = 0; s < grp->num_settings; s++) {
> +			/* skip unsupported settings on this variant */
> +			if (pctl->variant &&
> +			    !(pctl->variant & grp->settings[s].variant))
> +				continue;
> +
> +			/* check for unique functions */
> +			if (_add_function(prefunc, grp->settings[s].name))
> +				continue;
> +
> +			num++;
> +		}
> +	}
> +	return 0;
> +}

What is this supposed to do? It allocates an array prefunc, whose
reference is only stored in a local variable, and anywhere else, so
basically it does nothing except leaking memory unless I got it wrong.

Moreover, this array has only one entry, while the loop accesses
several entries, which probably explains the crash I'm seeing at boot
time:

Unable to handle kernel paging request at virtual address ff74edca
pgd = ef290000
[ff74edca] *pgd=00000000
Internal error: Oops: 15 [#1] ARM
Modules linked in:
CPU: 0    Not tainted  (3.6.0-rc1-00021-g1dd75c4-dirty #336)
PC is at strcmp+0x0/0x30
LR is at mvebu_pinctrl_build_functions.isra.1+0x78/0xd0
pc : [<c011b600>]    lr : [<c021fbf8>]    psr: a0000013
sp : ef02de80  ip : 00000000  fp : c02a7e28
r10: 000002a0  r9 : ef0e4924  r8 : 00000018
r7 : ef2742d0  r6 : ef0cb2b0  r5 : 00000020  r4 : 00000002
r3 : ff74edca  r2 : ef0e4920  r1 : c02a7e28  r0 : ff74edca
Flags: NzCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment kernel
Control: 10c53c7d  Table: 2f290059  DAC: 00000015
Process swapper (pid: 1, stack limit = 0xef02c268)
Stack: (0xef02de80 to 0xef02e000)
de80: ef0879c8 ef0e4900 00000043 00000043 ef2742d0 c054dd68 00000002 c057486c
dea0: 00000000 ef0879c8 ef0cb748 c02200f0 ef086348 c054c948 c055b550 c0576230
dec0: c054c6e0 ef0879c8 00000000 c054c6e0 c03008a0 c02f5c88 00000000 c014ed28
dee0: c014ed14 c014da3c ef0879c8 c054c6e0 ef0879fc 00000000 c02e91e0 c014dd30
df00: c054c6e0 c014dca4 00000000 c014c5e0 ef00554c ef0266f0 c054c6e0 c0551708
df20: ef274340 c014d380 c02a7da0 c055bf40 c054c6e0 ef02c000 c055bf40 00000000
df40: c02e91e0 c014e1e0 00000000 c02fdb4c ef02c000 c055bf40 00000000 c02e91e0
df60: c02f5c88 c00085c0 c02d1768 00000006 00000044 c02f5c88 00000044 00000006
df80: 00000006 c02e91e0 c1857e15 00000000 00000000 c02fdb4c 00000006 c02fdb2c
dfa0: c055bf40 c02e91e0 c03008a0 00000044 00000000 c02e9838 00000006 00000006
dfc0: c02e91e0 c030066c c030066c c030066c c000a04c 00000013 00000000 00000000
dfe0: 00000000 c02e98cc 00000000 00000000 c02e986c c000a04c be8ff7c8 e8dfff5e
[<c011b600>] (strcmp+0x0/0x30) from [<c021fbf8>] (mvebu_pinctrl_build_functions.isra.1+0x78/0xd0)
[<c021fbf8>] (mvebu_pinctrl_build_functions.isra.1+0x78/0xd0) from [<c02200f0>] (mvebu_pinctrl_probe+0x4a0/0x564)
[<c02200f0>] (mvebu_pinctrl_probe+0x4a0/0x564) from [<c014ed28>] (platform_drv_probe+0x14/0x18)
[<c014ed28>] (platform_drv_probe+0x14/0x18) from [<c014da3c>] (really_probe+0x60/0x1e4)
[<c014da3c>] (really_probe+0x60/0x1e4) from [<c014dd30>] (__driver_attach+0x8c/0x90)
[<c014dd30>] (__driver_attach+0x8c/0x90) from [<c014c5e0>] (bus_for_each_dev+0x50/0x7c)
[<c014c5e0>] (bus_for_each_dev+0x50/0x7c) from [<c014d380>] (bus_add_driver+0x168/0x22c)
[<c014d380>] (bus_add_driver+0x168/0x22c) from [<c014e1e0>] (driver_register+0x78/0x144)
[<c014e1e0>] (driver_register+0x78/0x144) from [<c00085c0>] (do_one_initcall+0x34/0x174)
[<c00085c0>] (do_one_initcall+0x34/0x174) from [<c02e9838>] (do_basic_setup+0x90/0xc4)
[<c02e9838>] (do_basic_setup+0x90/0xc4) from [<c02e98cc>] (kernel_init+0x60/0xf4)
[<c02e98cc>] (kernel_init+0x60/0xf4) from [<c000a04c>] (kernel_thread_exit+0x0/0x8)
Code: e3530000 e4c23001 1afffffb e12fff1e (e4d03001) 
---[ end trace a80e01be2a5f5b89 ]---
Kernel panic - not syncing: Attempted to kill init! exitcode=0x0000000b

I'd like to fix that myself, but I really don't understand what the
"functions" word mean now in this v3, as compared to v1/v2 of this
patch set. Could you enlighten me on this?

Thanks!

Thomas
-- 
Thomas Petazzoni, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
