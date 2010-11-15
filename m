Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754328Ab0KOJYS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 04:24:18 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:58518 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752197Ab0KOJYR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 04:24:17 -0500
Date: Mon, 15 Nov 2010 09:24:04 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Atul Sowani <sowani@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        alan@linux.intel.com, ralf@linux-mips.org
Subject: Re: [PATCH 2.6.36 1/1 RESEND] kernel SPIN_LOCK_UNLOCKED changed to
	__SPIN_LOCK_UNLOCKED()
Message-ID: <20101115092404.GA24194@n2100.arm.linux.org.uk>
References: <4CDED96A.9080404@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CDED96A.9080404@gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 14, 2010 at 12:01:06AM +0530, Atul Sowani wrote:
> There are still some files containing .lock = SPIN_LOCK_UNLOCKED type
> assignments which should be converted to __SPIN_LOCK_UNLOCKED().
> Corrected spacing between __SPIN_LOCK_UNLOCKED and ( for ARM.

Thinking about the ARM bit, I'll have to NAK this patch.

> diff -uprN a/arch/arm/kernel/smp.c b/arch/arm/kernel/smp.c
> --- a/arch/arm/kernel/smp.c	2010-10-21 02:00:22.000000000 +0530
> +++ b/arch/arm/kernel/smp.c	2010-11-07 00:47:32.000000000 +0530
> @@ -56,7 +56,7 @@ struct ipi_data {
>  };
> 
>  static DEFINE_PER_CPU(struct ipi_data, ipi_data) = {
> -	.lock	= SPIN_LOCK_UNLOCKED,
> +	.lock	= __SPIN_LOCK_UNLOCKED(ipi_data.lock),
>  };

This lock is in the percpu data area.  This means that when other CPUs
are brought online, and therefore other percpu areas are instantiated,
this lock will be mis-initialized (the pointers et.al. will be pointing
at the original percpu instance.)

So NAK, this will break.

We can either go back to a static array for this, initialize the lock
manually (though this could be problematical), or we require to go to
per-ipi type interrupts for all SMP architectures.
