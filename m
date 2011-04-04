Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754790Ab1DDPN1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 11:13:27 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:36597 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754269Ab1DDPN0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 11:13:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=C1IFt5crEb9YVAzkWb7yJVjMqs3jBCntxx2scRhFhHpgQUbvihVqV7Na5IVQNOfeSP
         kPL3MZhM2IZlp7V11WyCQISQNb99xaLRZAGd+5SuCRzquS1rAxLXkDJ6VJkmnpPRcwvv
         nPY7E4W1XhDZz5QdM5FKVJWJB+v6tffVDW3Jw=
MIME-Version: 1.0
In-Reply-To: <5ad00b91-47d8-4f02-aa72-5a413957cdb5@VA3EHSMHS005.ehs.local>
References: <1301864418-12425-1-git-send-email-john.linn@xilinx.com>
	<1301864418-12425-2-git-send-email-john.linn@xilinx.com>
	<5ad00b91-47d8-4f02-aa72-5a413957cdb5@VA3EHSMHS005.ehs.local>
Date: Mon, 4 Apr 2011 16:13:25 +0100
X-Google-Sender-Auth: 58kLC86Z2AR1MrmglUoOyVbDcyQ
Message-ID: <BANLkTi=ar5HHzr9Os6hXriD411ov457Nig@mail.gmail.com>
Subject: Re: [PATCH 2/3] ARM: Xilinx: add SMP specific support files
From: Catalin Marinas <catalin.marinas@arm.com>
To: John Linn <john.linn@xilinx.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux@arm.linux.org.uk, glikely@secretlab.ca, jamie@jamieiles.com,
        arnd@arndb.de
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

John,

A few suggestions on barriers below.

On 3 April 2011 22:00, John Linn <john.linn@xilinx.com> wrote:
> diff --git a/arch/arm/mach-xilinx/platsmp.c b/arch/arm/mach-xilinx/platsmp.c
> new file mode 100644
> index 0000000..be2d55c
> --- /dev/null
> +++ b/arch/arm/mach-xilinx/platsmp.c
...
> +int __cpuinit boot_secondary(unsigned int cpu, struct task_struct *idle)
> +{
> +       unsigned long timeout;
> +
> +       /*
> +        * set synchronisation state between this boot processor
> +        * and the secondary one
> +        */
> +       spin_lock(&boot_lock);
> +
> +       printk(KERN_INFO "Xilinx SMP: booting CPU1 now\n");
> +
> +       /*
> +        * Update boot lock register with the boot key to allow the
> +        * secondary processor to start the kernel after an SEV.
> +        */
> +       __raw_writel(BOOT_LOCK_KEY, OCM_HIGH_BASE + BOOT_LOCK_OFFSET);
> +
> +       /* Flush the kernel cache to ensure that the page tables are
> +        * available for the secondary CPU to use and make sure that
> +        * the write buffer is drained before doing an SEV.
> +        */
> +       flush_cache_all();
> +       smp_wmb();
> +
> +       /*
> +        * Send an event to wake the secondary core from WFE state.
> +        */
> +       sev();

You could flush the cache before writing the boot lock register in
case the secondary wakes up from WFE. You also need a wmb() rather
than the smp_wmb(). The latter only works in the inner shareable
domain but the secondary CPU hasn't initialised the MMU yet.

Something like below:

flush_cache_all();
__raw_writel(BOOT_LOCK_KEY, OCM_HIGH_BASE + BOOT_LOCK_OFFSET);
mb();
sev();

> +void __init platform_smp_prepare_cpus(unsigned int max_cpus)
> +{
> +       int i;
> +
> +       /*
> +        * Initialise the present map, which describes the set of CPUs
> +        * actually populated at the present time.
> +        */
> +       for (i = 0; i < max_cpus; i++)
> +               set_cpu_present(i, true);
> +
> +       scu_enable(scu_base);
> +
> +       /* Initialize the boot lock register to prevent CPU1 from
> +          starting the kernel before CPU0 is ready for that.
> +       */
> +       __raw_writel(0, OCM_HIGH_BASE + BOOT_LOCK_OFFSET);
> +
> +       /*
> +        * Write the address of secondary startup routine into the
> +        * boot address. The secondary CPU will use this value
> +        * to get into the kernel after it's awake from WFE state.
> +        *
> +        * Note the physical address is needed as the secondary CPU
> +        * will not have the MMU on yet. A barrier is added to ensure
> +        * that write buffer is drained.
> +        */
> +       __raw_writel(virt_to_phys(xilinx_secondary_startup),
> +                                       OCM_HIGH_BASE + BOOT_ADDR_OFFSET);
> +       smp_wmb();

Same here, use a wmb() or mb() before the sev().

-- 
Catalin
