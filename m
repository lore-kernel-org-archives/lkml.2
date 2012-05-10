Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756459Ab2EJUe5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 16:34:57 -0400
Received: from mail4-relais-sop.national.inria.fr ([192.134.164.105]:61655
	"EHLO mail4-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753655Ab2EJUe4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 16:34:56 -0400
X-IronPort-AV: E=Sophos;i="4.75,566,1330902000"; 
   d="scan'208";a="143391291"
Date: Thu, 10 May 2012 22:34:53 +0200 (CEST)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@localhost6.localdomain6
To: Linus Walleij <linus.walleij@linaro.org>
cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-kernel@vger.kernel.org, grant.likely@secretlab.ca,
        linus.walleij@stericsson.com
Subject: Re: [PATCH] gpio/langwell: re-read the IRQ status register after
 each iteration
In-Reply-To: <CACRpkdbA58UiNLZRPWe1yGckGFrXqtJ3ddqjLLzLntC6+Cin3g@mail.gmail.com>
Message-ID: <alpine.DEB.2.02.1205102211060.1957@localhost6.localdomain6>
References: <1336644082-14137-1-git-send-email-mika.westerberg@linux.intel.com> <CACRpkdbA58UiNLZRPWe1yGckGFrXqtJ3ddqjLLzLntC6+Cin3g@mail.gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 May 2012, Linus Walleij wrote:

> On Thu, May 10, 2012 at 12:01 PM, Mika Westerberg
> <mika.westerberg@linux.intel.com> wrote:
>
>> Spotted by Grant Likely. The IRQ status register should be re-read after
>> each iteration. Otherwise the loop misses the interrupt if it gets raised
>> immediately after handled.
>>
>> Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
>> ---
>> This patch applies on top of my previous patch ("gpio: langwell: convert to
>> use irq_domain").
>
> Oh yeah that thing I recognize!
> Acked-by: Linus Walleij <linus.walleij@linaro.org>
>
> If someone has  time I think it would be a good idea to
> conjure a cocienelle sematic patch to catch this pattern, because
> I suspect it might exist in more IRQ handlers.
>
> -               pending = readl(gedr);
> -               while (pending) {
> +               while ((pending = readl(gedr))) {
>                       gpio = __ffs(pending);
>                       mask = BIT(gpio);
> -                       pending &= ~mask;

I tried the following:

@@
expression pending,gedr,e1;
statement S;
@@

*pending = readl(gedr);
... when != pending = e1
while (pending) S

That is, a readl call followed by a while loop with no reassignment of 
pending.

Perhaps the following are suspicious:

arch/arm/mach-msm/dma.c, function msm_datamover_irq_handler
drivers/gpio/gpio-msm-v1.c, function msm_gpio_irq_handler

But I am not completely sure to understand what is wanted (or not wanted).

julia
