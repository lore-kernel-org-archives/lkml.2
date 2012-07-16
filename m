Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752867Ab2GPJ0H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 05:26:07 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:51497 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752639Ab2GPJ0F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 05:26:05 -0400
Date: Mon, 16 Jul 2012 11:25:59 +0200
From: Ingo Molnar <mingo@kernel.org>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Jacob Pan <jacob.jun.pan@intel.com>,
        Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Joerg Roedel <joerg.roedel@amd.com>, Yinghai Lu <yinghai@kernel.org>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org, avi@redhat.com,
        gleb@redhat.com
Subject: Re: [PATCH 1/3] apic: add apic_set_eoi_write for PV use
Message-ID: <20120716092559.GA18516@gmail.com>
References: <cover.1342356186.git.mst@redhat.com>
 <db32689adef29a280bc280a6ca88683c44e9d719.1342356186.git.mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <db32689adef29a280bc280a6ca88683c44e9d719.1342356186.git.mst@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Michael S. Tsirkin <mst@redhat.com> wrote:

> KVM PV EOI optimization overrides eoi_write apic op with its own
> version. Add an API for this to avoid meddling with core x86 apic driver
> data structures directly.
> 
> For KVM use, we don't need any guarantees about when the switch to the
> new op will take place, so it could in theory use this API after SMP init,
> but it currently doesn't, and restricting callers to early init makes it
> clear that it's safe as it won't race with actual APIC driver use.
> 
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> ---
>  arch/x86/include/asm/apic.h |  3 +++
>  arch/x86/kernel/apic/apic.c | 17 +++++++++++++++++
>  2 files changed, 20 insertions(+)
> 
> diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
> index aa5b2ee..ff8dff6 100644
> --- a/arch/x86/include/asm/apic.h
> +++ b/arch/x86/include/asm/apic.h
> @@ -469,6 +469,8 @@ static inline u32 safe_apic_wait_icr_idle(void)
>  	return apic->safe_wait_icr_idle();
>  }
>  
> +extern void __init apic_set_eoi_write(void (*eoi_write)(u32 reg, u32 v));
> +
>  #else /* CONFIG_X86_LOCAL_APIC */
>  
>  static inline u32 apic_read(u32 reg) { return 0; }
> @@ -478,6 +480,7 @@ static inline u64 apic_icr_read(void) { return 0; }
>  static inline void apic_icr_write(u32 low, u32 high) { }
>  static inline void apic_wait_icr_idle(void) { }
>  static inline u32 safe_apic_wait_icr_idle(void) { return 0; }
> +static inline void apic_set_eoi_write(void (*eoi_write)(u32 reg, u32 v)) {}
>  
>  #endif /* CONFIG_X86_LOCAL_APIC */
>  
> diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
> index 39a222e..c7520b6 100644
> --- a/arch/x86/kernel/apic/apic.c
> +++ b/arch/x86/kernel/apic/apic.c
> @@ -2124,6 +2124,23 @@ void default_init_apic_ldr(void)
>  }
>  
>  /*
> + * Override the generic EOI implementation with an optimized version.
> + * Only called during early boot when only one CPU is active and with
> + * interrupts disabled, so we know this does not race with actual APIC driver
> + * use.
> + */
> +void __init apic_set_eoi_write(void (*eoi_write)(u32 reg, u32 v))
> +{
> +	struct apic **drv;
> +
> +	for (drv = __apicdrivers; drv < __apicdrivers_end; drv++) {
> +		/* Should happen once for each apic */
> +		WARN_ON((*drv)->eoi_write == eoi_write);
> +		(*drv)->eoi_write = eoi_write;
> +	}
> +}
> +

ok, it's better this way.

Acked-by: Ingo Molnar <mingo@kernel.org>

Thanks,

	Ingo
