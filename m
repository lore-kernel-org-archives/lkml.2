Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932126Ab1KDCzm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 22:55:42 -0400
Received: from mga14.intel.com ([143.182.124.37]:21187 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754761Ab1KDCzk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 22:55:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,453,1315206000"; 
   d="scan'208";a="70409032"
Subject: Re: [PATCH] PNP ACPI: Use real gsi
From: Zhang Rui <rui.zhang@intel.com>
To: Thomas Renninger <trenn@suse.de>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        Yinghai Lu <yinghai@kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "lenb@kernel.org" <lenb@kernel.org>,
        "stable@kernel.org" <stable@kernel.org>, Ingo Molnar <mingo@elte.hu>,
        H Peter Anvin <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <1320373233-3725-1-git-send-email-trenn@suse.de>
References: <1320372728-3235-1-git-send-email-trenn@suse.de>
	 <1320373233-3725-1-git-send-email-trenn@suse.de>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 04 Nov 2011 10:54:06 +0800
Message-ID: <1320375246.27436.1353.camel@rui>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-11-04 at 10:20 +0800, Thomas Renninger wrote:
> From: Yinghai Lu <yinghai@kernel.org>
> 
> In 2.6.35 a lot cleanups in this area (not pnp, but x86 ioapic setup) have
> been introduced.
> On an IBM Xseries (x3850) this caused the machine to freeze around when
> the init userspace process is tried to get started.
> The reason is that the timer interrupt is not set up correctly on this machine.
> 
> I could bisect the issue to one of ioapic cleanups introduced in 2.6.35:
> commit a4384df3e24579d6292a1b3b41d500349948f30b
> 
> While on this machine the problem was an interrupt timer issue,
> there may be other platforms with different interrupt issues relatd to this
> problem. Kernel logs with similar IOAPIC errors inside pnpacpi setup might
> need this patch:
>   pnp 00:04: [io  0x02f8-0x02ff]
>   IOAPIC[1]: Invalid reference to IRQ 0
>   pnp 00:04: [irq 2]
>   pnp 00:04: Plug and Play ACPI device, IDs PNP0501 (active)
> 
> Yinghai came up with this patch which fixes the problem for me.
> Looks like the bisected commit is correct, but the pnp layer has been
> overseen.
> 
> Tested-by: Thomas Renninger <trenn@suse.de>
> CC: Eric W. Biederman <ebiederm@xmission.com>
> CC: bhelgaas@google.com
> CC: lenb@kernel.org
> CC: stable@kernel.org
> CC: Ingo Molnar <mingo@elte.hu>
> CC: H Peter Anvin <hpa@zytor.com>
> CC: Thomas Gleixner <tglx@linutronix.de>
> Signed-off-by: Thomas Renninger <trenn@suse.de>
> ---
>  drivers/pnp/pnpacpi/rsparser.c |    8 ++++++++
>  1 files changed, 8 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/pnp/pnpacpi/rsparser.c b/drivers/pnp/pnpacpi/rsparser.c
> index bbf3edd..dad5da9 100644
> --- a/drivers/pnp/pnpacpi/rsparser.c
> +++ b/drivers/pnp/pnpacpi/rsparser.c
> @@ -106,6 +106,14 @@ static void pnpacpi_parse_allocated_irqresource(struct pnp_dev *dev,
>  		return;
>  	}
>  
> +#ifdef CONFIG_X86_IO_APIC
> +	/*
> +	 * Convert it back to real gsi
> +	 */
> +	if (acpi_irq_model == ACPI_IRQ_MODEL_IOAPIC)
> +		acpi_isa_irq_to_gsi(gsi, &gsi);
> +#endif
> +
>  
I'm looking at this piece of code recently, and I have a few questions.

Interrupt resource descriptor returns gsi, right?
why you do need to do the isa-irq-to-gsi map again? is this problem
caused by an interrupt override table on this machine?
But if this is true, I don't see why
a4384df3e24579d6292a1b3b41d500349948f30b introduces this regression.

can you attach the acpidump table please?

thanks,
rui

> 	/*
>  	 * in IO-APIC mode, use overrided attribute. Two reasons:
>  	 * 1. BIOS bug in DSDT


