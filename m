Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755279Ab1EJHgO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 03:36:14 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:36250 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754626Ab1EJHgL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 03:36:11 -0400
Date: Tue, 10 May 2011 09:35:51 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Daniel J Blueman <daniel.blueman@gmail.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        H Peter Anvin <hpa@zytor.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ioapic: fix potential resume deadlock
Message-ID: <20110510073551.GH11595@elte.hu>
References: <1304908814-23369-1-git-send-email-daniel.blueman@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1304908814-23369-1-git-send-email-daniel.blueman@gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Daniel J Blueman <daniel.blueman@gmail.com> wrote:

> Fix a potential deadlock when resuming; here the calling function
> has disabled interrupts, so we cannot sleep.
> 
> Signed-off-by: Daniel J Blueman <daniel.blueman@gmail.com>
> 
> ---
>  arch/x86/kernel/apic/io_apic.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
> index 45fd33d..df63620 100644
> --- a/arch/x86/kernel/apic/io_apic.c
> +++ b/arch/x86/kernel/apic/io_apic.c
> @@ -621,14 +621,14 @@ struct IO_APIC_route_entry **alloc_ioapic_entries(void)
>  	struct IO_APIC_route_entry **ioapic_entries;
>  
>  	ioapic_entries = kzalloc(sizeof(*ioapic_entries) * nr_ioapics,
> -				GFP_KERNEL);
> +				GFP_ATOMIC);
>  	if (!ioapic_entries)
>  		return 0;
>  
>  	for (apic = 0; apic < nr_ioapics; apic++) {
>  		ioapic_entries[apic] =
>  			kzalloc(sizeof(struct IO_APIC_route_entry) *
> -				nr_ioapic_registers[apic], GFP_KERNEL);
> +				nr_ioapic_registers[apic], GFP_ATOMIC);
>  		if (!ioapic_entries[apic])
>  			goto nomem;
>  	}

Hm, there must be some other bug here.

ioapic entries should be allocated on system bootup and should never really be 
deallocated.

The bug might be in the idea to call to enable_IR_x2apic() on resume - why are 
ioapic entries reallocated there? That call in default_setup_apic_routing() was 
introduced some time ago in:

  fa47f7e52874: x86, x2apic: Simplify apic init in SMP and UP builds

and that it results in reallocation in the suspend patch is distinctly wrong.

I suspect the reason why this has not triggered for others is the relative 
rarity of affected systems?

Suresh?

Thanks,

	Ingo
