Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755817Ab2JPWdX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 18:33:23 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:44925 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755358Ab2JPWdV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 18:33:21 -0400
Message-ID: <507DE0AE.7090701@wwwdotorg.org>
Date: Tue, 16 Oct 2012 16:33:18 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: linux-kernel@vger.kernel.org, Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Stephen Warren <swarren@nvidia.com>
Subject: Re: [PATCH 7/7] gpio/tegra: convert to use linear irqdomain
References: <1350415413-3723-1-git-send-email-linus.walleij@linaro.org>
In-Reply-To: <1350415413-3723-1-git-send-email-linus.walleij@linaro.org>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/16/2012 01:23 PM, Linus Walleij wrote:
> The MXS driver tries to do the work of irq_domain_add_linear()
> by reserving a bunch of descriptors somewhere and keeping track
> of the base offset, then calling irq_domain_add_legacy(). Let's
> stop doing that and simply use the linear IRQ domain.

This /looks/ fine, but appears to break users of GPIOs from this module,
and causes a backtrace when cat /sys/kernel/debug/gpio:

> root@localhost:/sys/kernel/debug# cat gpio
> [   79.141308] Unable to handle kernel paging request at virtual address 5a5a5aaa
> [   79.148701] pgd = eea70000
> [   79.151401] [5a5a5aaa] *pgd=00000000
> [   79.154979] Internal error: Oops: 5 [#1] PREEMPT SMP ARM
> [   79.160277] Modules linked in:
> [   79.163329] CPU: 1    Not tainted  (3.7.0-rc1-next-20121016-00016-g0f3bc78 #17)
> [   79.170639] PC is at gpiolib_seq_show+0x3c/0x1b0
> [   79.175245] LR is at gpiolib_seq_show+0x30/0x1b0
> [   79.179851] pc : [<c01fde7c>]    lr : [<c01fde70>]    psr: 20000013
> [   79.179851] sp : ee54fee0  ip : 00000039  fp : 00008000
> [   79.191303] r10: 000002e9  r9 : ee8140dc  r8 : ee54ff28
> [   79.196513] r7 : ee8a9c40  r6 : ee8140dc  r5 : ee54ff80  r4 : ee8a9c40
> [   79.203024] r3 : 5a5a5a5a  r2 : ee40e2e9  r1 : 00001000  r0 : 00000000
> [   79.209535] Flags: nzCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment user
> [   79.216653] Control: 10c5387d  Table: aea7004a  DAC: 00000015
> [   79.222383] Process cat (pid: 417, stack limit = 0xee54e238)
> [   79.228029] Stack: (0xee54fee0 to 0xee550000)
> [   79.232376] fee0: 5a5ab4b3 c05ca22c c00e6ac4 ee8a9c40 ee54ff80 ee48aef0 00000000 ee54ff28
> [   79.240536] ff00: ee8140dc 000002e9 00008000 c00e6b34 00000000 00019000 ee8a9c68 00000000
> [   79.248696] ff20: 00000000 00000000 00000001 00000000 00000000 00000000 00000000 ee48aef0
> [   79.256857] ff40: 00008000 00019000 ee54ff80 ee54ff80 00008000 00019000 00000000 c00c8b10
> [   79.265017] ff60: 00000000 00000000 00000000 00000000 ee48aef0 00000000 ee54ff80 c00c8be8
> [   79.273176] ff80: 00000000 00000000 00008000 00019000 00000003 00000003 c000f044 ee54e000
> [   79.281338] ffa0: 00000000 c000eec0 00008000 00019000 00000003 00019000 00008000 00019000
> [   79.289497] ffc0: 00008000 00019000 00000003 00000003 00000000 00000000 b6fe5000 00000000
> [   79.297658] ffe0: 00000000 beb645b4 0000b40d b6f621cc 40000010 00000003 00000000 00000000
> [   79.305845] [<c01fde7c>] (gpiolib_seq_show+0x3c/0x1b0) from [<c00e6b34>] (seq_read+0x32c/0x4a0)
> [   79.314533] [<c00e6b34>] (seq_read+0x32c/0x4a0) from [<c00c8b10>] (vfs_read+0xb0/0x144)
> [   79.322523] [<c00c8b10>] (vfs_read+0xb0/0x144) from [<c00c8be8>] (sys_read+0x44/0x70)
> [   79.330352] [<c00c8be8>] (sys_read+0x44/0x70) from [<c000eec0>] (ret_fast_syscall+0x0/0x30)
> [   79.338688] Code: ebfba211 e5963004 e3530000 0a00000a (e5932050) 
> [   79.344790] ---[ end trace 6fb7238d59ff2ea0 ]---

Do you have any quick ideas? If not, I'll go investigate.

I wonder if this has anything to do with drivers/pinctrl/pinctrl-tegra.c
hard-coding the GPIO base in tegra_pinctrl_gpio_range.

I've had fixing those in my mental TODO list for a while, but you got
around to it first!
