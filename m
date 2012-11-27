Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756731Ab2K0VDm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 16:03:42 -0500
Received: from mail-qa0-f46.google.com ([209.85.216.46]:40548 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753107Ab2K0VDl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 16:03:41 -0500
Date: Tue, 27 Nov 2012 16:03:32 -0500
From: Konrad Rzeszutek Wilk <konrad@kernel.org>
To: Michael Wolf <mjw@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, riel@redhat.com, kvm@vger.kernel.org,
        peterz@infradead.org, mtosatti@redhat.com, glommer@parallels.com,
        mingo@redhat.com
Subject: Re: [PATCH 2/5] Expand the steal time msr to also contain the
 consigned time.
Message-ID: <20121127210331.GA2710@phenom.dumpdata.com>
References: <20121126203603.28840.38736.stgit@lambeau>
 <20121126203645.28840.56280.stgit@lambeau>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121126203645.28840.56280.stgit@lambeau>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 26, 2012 at 02:36:45PM -0600, Michael Wolf wrote:
> Add a consigned field.  This field will hold the time lost due to capping or overcommit.
> The rest of the time will still show up in the steal-time field.
> 
> Signed-off-by: Michael Wolf <mjw@linux.vnet.ibm.com>
> ---
>  arch/x86/include/asm/paravirt.h       |    4 ++--
>  arch/x86/include/asm/paravirt_types.h |    2 +-
>  arch/x86/kernel/kvm.c                 |    7 ++-----
>  kernel/sched/core.c                   |   10 +++++++++-
>  kernel/sched/cputime.c                |    2 +-
>  5 files changed, 15 insertions(+), 10 deletions(-)
> 
> diff --git a/arch/x86/include/asm/paravirt.h b/arch/x86/include/asm/paravirt.h
> index a0facf3..a5f9f30 100644
> --- a/arch/x86/include/asm/paravirt.h
> +++ b/arch/x86/include/asm/paravirt.h
> @@ -196,9 +196,9 @@ struct static_key;
>  extern struct static_key paravirt_steal_enabled;
>  extern struct static_key paravirt_steal_rq_enabled;
>  
> -static inline u64 paravirt_steal_clock(int cpu)
> +static inline u64 paravirt_steal_clock(int cpu, u64 *steal)

So its u64 here.
>  {
> -	return PVOP_CALL1(u64, pv_time_ops.steal_clock, cpu);
> +	PVOP_VCALL2(pv_time_ops.steal_clock, cpu, steal);
>  }
>  
>  static inline unsigned long long paravirt_read_pmc(int counter)
> diff --git a/arch/x86/include/asm/paravirt_types.h b/arch/x86/include/asm/paravirt_types.h
> index 142236e..5d4fc8b 100644
> --- a/arch/x86/include/asm/paravirt_types.h
> +++ b/arch/x86/include/asm/paravirt_types.h
> @@ -95,7 +95,7 @@ struct pv_lazy_ops {
>  
>  struct pv_time_ops {
>  	unsigned long long (*sched_clock)(void);
> -	unsigned long long (*steal_clock)(int cpu);
> +	void (*steal_clock)(int cpu, unsigned long long *steal);

But not u64 here? Any particular reason?
