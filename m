Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752284Ab2FMIuE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 04:50:04 -0400
Received: from merlin.infradead.org ([205.233.59.134]:51687 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751132Ab2FMIuB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 04:50:01 -0400
Message-ID: <1339577392.31548.122.camel@twins>
Subject: Re: [PATCH 1/2] x86: Track minimum microcode revision globally v2
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andi Kleen <andi@firstfloor.org>
Cc: x86@kernel.org, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>
Date: Wed, 13 Jun 2012 10:49:52 +0200
In-Reply-To: <1339536350-10463-1-git-send-email-andi@firstfloor.org>
References: <1339536350-10463-1-git-send-email-andi@firstfloor.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-06-12 at 14:25 -0700, Andi Kleen wrote:
> +void update_min_microcode(struct cpuinfo_x86 *c)
> +{
> +       int i;
> +
> +       for_each_online_cpu (i)

Superfluous whitespace

> +               if (cpu_data(i).microcode < c->microcode)
> +                       return;

That needs {}

> +       if (boot_cpu_data.microcode != c->microcode) {
> +               boot_cpu_data.microcode = c->microcode;
> +               pr_info("Minimum microcode revision updated to %x\n", c->microcode);
> +       }
> +}
> +EXPORT_SYMBOL_GPL(update_min_microcode);
> +
>  /*
>   * cpu_init() initializes state that is per-CPU. Some data is already
>   * initialized (naturally) in the bootstrap process, such as the GDT


> diff --git a/arch/x86/kernel/microcode_amd.c b/arch/x86/kernel/microcode_amd.c
> index 8a2ce8f..b589c7a 100644
> --- a/arch/x86/kernel/microcode_amd.c
> +++ b/arch/x86/kernel/microcode_amd.c
> @@ -215,6 +215,7 @@ static int apply_microcode_amd(int cpu)
>         pr_info("CPU%d: new patch_level=0x%08x\n", cpu, rev);
>         uci->cpu_sig.rev = rev;
>         c->microcode = rev;
> +       update_min_microcode(c);
>  
>         return 0;
>  }
> diff --git a/arch/x86/kernel/microcode_intel.c b/arch/x86/kernel/microcode_intel.c
> index 0327e2b..50afbb9 100644
> --- a/arch/x86/kernel/microcode_intel.c
> +++ b/arch/x86/kernel/microcode_intel.c
> @@ -326,6 +326,7 @@ static int apply_microcode(int cpu)
>         uci->cpu_sig.rev = val[1];
>         c->microcode = val[1];
>  
> +       update_min_microcode(c);
>         return 0;
>  }

Doing it here means doing the for_each_cpu thing with preempt/irqs
disabled, that's not funny.

Also this is still a O(n^2) proposition.. so how is this better than the
notifier thing I had?

We should just kill reload_store() dead, and do a notifier per system
update, that gives sane semantics and avoids all the O(n^2) nonsense.
