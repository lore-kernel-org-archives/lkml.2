Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756316Ab2EGNTu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 09:19:50 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:54965 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755410Ab2EGNTt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 09:19:49 -0400
Date: Mon, 7 May 2012 15:19:43 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Ido Yariv <ido@wizery.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ravikiran Thirumalai <kiran.thirumalai@gmail.com>,
        Shai Fultheim <shai@scalemp.com>
Subject: Re: [PATCH v2 2/2] vsmp: Ignore IOAPIC IRQ affinity if possible
Message-ID: <20120507131943.GI23858@gmail.com>
References: <1333715987-26059-2-git-send-email-ido@wizery.com>
 <1334561976-13965-1-git-send-email-ido@wizery.com>
 <1334561976-13965-2-git-send-email-ido@wizery.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1334561976-13965-2-git-send-email-ido@wizery.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ido Yariv <ido@wizery.com> wrote:

> From: Ravikiran Thirumalai <kiran.thirumalai@gmail.com>
> 
> vSMP can route interrupts more optimally based on internal knowledge the
> OS does not have. In order to support this optimization, all CPUs must
> be able to handle all possible IOAPIC interrupts.
> 
> Fix this by setting the vector allocation domain for all CPUs and by
> enabling this feature in vSMP.
> 
> Signed-off-by: Ravikiran Thirumalai <kiran.thirumalai@gmail.com>
> Signed-off-by: Shai Fultheim <shai@scalemp.com>
> [ido@wizery.com: rebased, simplified, and reworded the commit message]
> Signed-off-by: Ido Yariv <ido@wizery.com>
> ---
> Changes from v1:
> - Updated Kiran's email address
> 
>  arch/x86/kernel/apic/probe_64.c |   10 ++++++++++
>  arch/x86/kernel/vsmp_64.c       |   15 +++++++++++----
>  2 files changed, 21 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kernel/apic/probe_64.c b/arch/x86/kernel/apic/probe_64.c
> index 3fe9866..0f96703 100644
> --- a/arch/x86/kernel/apic/probe_64.c
> +++ b/arch/x86/kernel/apic/probe_64.c
> @@ -29,6 +29,15 @@ static int apicid_phys_pkg_id(int initial_apic_id, int index_msb)
>  }
>  
>  /*
> + * In vSMP, all cpus should be capable of handling interrupts, regardless of
> + * the apic used.
> + */
> +static void fill_vector_allocation_domain(int cpu, struct cpumask *retmask)
> +{
> +	cpumask_setall(retmask);
> +}
> +
> +/*
>   * Check the APIC IDs in bios_cpu_apicid and choose the APIC mode.
>   */
>  void __init default_setup_apic_routing(void)
> @@ -51,6 +60,7 @@ void __init default_setup_apic_routing(void)
>  	if (is_vsmp_box()) {
>  		/* need to update phys_pkg_id */
>  		apic->phys_pkg_id = apicid_phys_pkg_id;
> +		apic->vector_allocation_domain = fill_vector_allocation_domain;
>  	}
>  }

This is_vsmp_box() special case should really move into its own 
apic handler.

Thanks,

	Ingo
