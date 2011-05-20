Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933777Ab1ETG6Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 02:58:24 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:40839 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933380Ab1ETG6W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 02:58:22 -0400
Date: Fri, 20 May 2011 00:58:20 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Barry Song <21cnbao@gmail.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Lee Jones <lee.jones@linaro.org>,
        Jonas Aaberg <jonas.aberg@stericsson.com>
Subject: Re: [PATCH 02/10] mach-u300: rewrite gpio driver, move to
 drivers/gpio
Message-ID: <20110520065820.GC21285@ponder.secretlab.ca>
References: <1303910002-3333-1-git-send-email-linus.walleij@stericsson.com>
 <BANLkTi=poU17RqAzp28CPjWHrN_+aFiyag@mail.gmail.com>
 <BANLkTindee6UMez8HyBUwd2H6mN-DknzPw@mail.gmail.com>
 <BANLkTik7BnJKWCsm2L3-GJPTaaiXFNSgaA@mail.gmail.com>
 <BANLkTim2rv9QHDd2zjBfyVqG9dSGCM=PAw@mail.gmail.com>
 <BANLkTinABWucqESqSRYJV+-frm6vDmpxFQ@mail.gmail.com>
 <BANLkTim=iwHY2NhWuK6qmhAdez-5AiJDBw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BANLkTim=iwHY2NhWuK6qmhAdez-5AiJDBw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 19, 2011 at 10:05:25PM +0800, Barry Song wrote:
> 2011/5/19 Linus Walleij <linus.walleij@linaro.org>:
> > On Thu, May 19, 2011 at 2:35 PM, Barry Song <21cnbao@gmail.com> wrote:
> >> 2011/5/19 Linus Walleij <linus.walleij@linaro.org>:
> >>> On Thu, May 19, 2011 at 1:38 PM, Barry Song <21cnbao@gmail.com> wrote:
> >>>>
> >>>> looks like the driver can't be a real module, is the module_exit
> >>>> suitable? it looks strange module_exit plays together with
> >>>> arch_initcall.
> >>>
> >>> It's a rather common design pattern in the kernel for early
> >>> platform drivers. Either the dependencies are resolved by the
> >>> different initlevels or they are resolved in probe order with
> >>> loadable modules. Module load will call all initlevels in order.
> >>>
> >>> It is not elegant but it is common.
> >>
> >> Linus, thanks for your reply. module_exit and related functions are
> >> really useless codes. but people have done that before, then we have
> >> no way except following.
> >> u300_gpio_exit never gets chance to run and when we disassemble
> >> vmlinux, u300_gpio_exit()  function should be not in the final binary
> >> at all, just a symbol name is left.
> >
> > I know. I can make the Kconfig options tristate if it makes you feel
> > better...
> what i feel headache is that it is really difficult and unpredicted
> for an internal gpio driver to be removable in lots of read products
> because gpio is probably the last bottom module other drivers need.
> even it can be called in arch/arm/plat(mach).
> 
> i am not sure whether  i am thinking right. gpio and pinmux are more
> things of bottom level APIs like dma/clock tree but not like device
> drivers.  but i really think you have sent a great pinmux core
> framework.
> 

No, gpio controllers are just another set of devices, albeit really
low level devices that lots of other things depend on.  The Linux
model does and should support loading/unloading of GPIO drivers
providing there is nothing using them.

So, yes, in a lot of cases unloading them is simply not possible
because board support code depends on them at some point in early
boot, but that doesn't mean that they should be treated differently
than any other drivers.

Oh, and just to be clear, there are also use cases where really low
level code has to go and poke GPIO devices directly before any of the
driver model subsystems are up and running.  That is a different
use-case and it is not what I'm talking about here.

g.


> we once thought we could have a plat-common above all
> plat-xxx/mach-xxx, and let the plat-common provide the cores of dma,
> clk, gpio, pinmux(pinmux core from you), for example, all common API
> and abstract level codes like gpio_request can be there, and SoCs just
> implement some hardware-related callbacks required by plat-common in
> themselves plat-xxx .
> 
> >
> > Linus Walleij
> >
