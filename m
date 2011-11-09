Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932737Ab1KIW0Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 17:26:24 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:60409 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754671Ab1KIW0U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 17:26:20 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Thomas Renninger <trenn@suse.de>
Subject: Re: [PATCH] PNP ACPI: Use real gsi
Date: Wed, 9 Nov 2011 23:28:57 +0100
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc10+; KDE/4.6.0; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>, bjorn.helgaas@hp.com,
        lenb@kernel.org, stable@kernel.org, Ingo Molnar <mingo@elte.hu>,
        H Peter Anvin <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
References: <1320372728-3235-1-git-send-email-trenn@suse.de>
In-Reply-To: <1320372728-3235-1-git-send-email-trenn@suse.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201111092328.58216.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, November 04, 2011, Thomas Renninger wrote:
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
> CC: bjorn.helgaas@hp.com
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

Have you checked which case in irq_to_gsi() really matters?

Rafael


>  	/*
>  	 * in IO-APIC mode, use overrided attribute. Two reasons:
>  	 * 1. BIOS bug in DSDT
> 

