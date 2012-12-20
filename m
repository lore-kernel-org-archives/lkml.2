Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752310Ab2LTBc2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 20:32:28 -0500
Received: from mail-we0-f172.google.com ([74.125.82.172]:56332 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751397Ab2LTBcX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 20:32:23 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH] mfd: db8500-prcmu: fix irqdomain usage
To: Linus Walleij <linus.walleij@stericsson.com>,
        Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org
Cc: Anmar Oueja <anmar.oueja@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>, stable@kernel.org,
        Lee Jones <lee.jones@linaro.org>
In-Reply-To: <1355928161-8082-1-git-send-email-linus.walleij@stericsson.com>
References: <1355928161-8082-1-git-send-email-linus.walleij@stericsson.com>
Date: Thu, 20 Dec 2012 01:32:18 +0000
Message-Id: <20121220013218.A55E93E0AD7@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Dec 2012 15:42:41 +0100, Linus Walleij <linus.walleij@stericsson.com> wrote:
> From: Linus Walleij <linus.walleij@linaro.org>
> 
> This fixes two issues with the DB8500 PRCMU irqdomain:
> - You have to state the irq base 0 to get a linear domain
>   for the DT case from irq_domain_add_simple()
> - The irqdomain was not used to translate the initial irq
>   request using irq_create_mapping() making the linear
>   case fail as it was lacking a proper descriptor.
> 
> I took this opportunity to fix two lines of whitespace
> errors in related code as I was anyway messing around with
> it.
> 
> Cc: stable@kernel.org
> Cc: Lee Jones <lee.jones@linaro.org>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---
> Hi Sam, this is a regression and as such should go into the
> -rc series. As you can see I also added the Cc: stable tag.
> 
> Yours,
> Linus Walleij
> ---
>  drivers/mfd/db8500-prcmu.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/mfd/db8500-prcmu.c b/drivers/mfd/db8500-prcmu.c
> index dc8826d..fcac8e0 100644
> --- a/drivers/mfd/db8500-prcmu.c
> +++ b/drivers/mfd/db8500-prcmu.c
> @@ -2524,7 +2524,7 @@ static bool read_mailbox_0(void)
>  
>  		for (n = 0; n < NUM_PRCMU_WAKEUPS; n++) {
>  			if (ev & prcmu_irq_bit[n])
> -				generic_handle_irq(IRQ_PRCMU_BASE + n);
> +				generic_handle_irq(irq_create_mapping(db8500_irq_domain,n));

This looks wrong. It probably works at the moment, but calling
irq_create_mapping when trying to process an IRQ is backwards. There
certainly shouldn't be any processing of an irq that isn't already
mapped. irq_find_mapping() should be used instead.

g.
