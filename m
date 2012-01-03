Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753643Ab2ACAoY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jan 2012 19:44:24 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:56547 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753461Ab2ACAoW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jan 2012 19:44:22 -0500
MIME-Version: 1.0
In-Reply-To: <1325521990-4445-1-git-send-email-joerg.roedel@amd.com>
References: <1325521990-4445-1-git-send-email-joerg.roedel@amd.com>
From: Yang Bai <hamo.by@gmail.com>
Date: Tue, 3 Jan 2012 08:44:01 +0800
Message-ID: <CAO_0yfOzVCK8OGL5G9Aej+V4AZ12EMFKi3HafAX0JzeW9C3FtQ@mail.gmail.com>
Subject: Re: [PATCH] arm: Fix linux-next compile error in arch/arm/common/gic.c
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: Russell King <linux@arm.linux.org.uk>, Marc Zyngier <marc.zyngier@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Rob Herring <rob.herring@calxeda.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 3, 2012 at 12:33 AM, Joerg Roedel <joerg.roedel@amd.com> wrote:
> With CONFIG_SMP=n the following compile error occurs:
>
>  CC      arch/arm/common/gic.o
> arch/arm/common/gic.c: In function 'gic_init_bases':
> arch/arm/common/gic.c:679:4: error: implicit declaration of function 'cpu_logical_map' [-Werror=implicit-function-declaration]
> cc1: some warnings being treated as errors
>
> This patch fixes the problem.
>
> Cc: Marc Zyngier <marc.zyngier@arm.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>
> Cc: Rob Herring <rob.herring@calxeda.com>
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
> ---
>  arch/arm/common/gic.c |    5 ++++-
>  1 files changed, 4 insertions(+), 1 deletions(-)
>
> diff --git a/arch/arm/common/gic.c b/arch/arm/common/gic.c
> index b2dc2dd..b33f6b0 100644
> --- a/arch/arm/common/gic.c
> +++ b/arch/arm/common/gic.c
> @@ -676,7 +676,10 @@ void __init gic_init_bases(unsigned int gic_nr, int irq_start,
>                }
>
>                for_each_possible_cpu(cpu) {
> -                       unsigned long offset = percpu_offset * cpu_logical_map(cpu);
> +                       unsigned long offset = percpu_offset;
> +#ifdef CONFIG_SMP
> +                       offset *= cpu_logical_map(cpu);
> +#endif
>                        *per_cpu_ptr(gic->dist_base.percpu_base, cpu) = dist_base + offset;
>                        *per_cpu_ptr(gic->cpu_base.percpu_base, cpu) = cpu_base + offset;
>                }
> --
> 1.7.5.4
>
>

Is this the right way to fix it? Or shall we do like this:

#ifdef CONFIG_SMP
...
#else
#define cpu_logical_map() 1
#endif

and leave the gic.c code unchanged.

Thanks,
Yang
