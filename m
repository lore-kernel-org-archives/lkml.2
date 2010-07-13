Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754818Ab0GMUFj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 16:05:39 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33757 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751207Ab0GMUFi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 16:05:38 -0400
Message-ID: <4C3CC6F2.7050406@zytor.com>
Date: Tue, 13 Jul 2010 13:05:06 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc13 Thunderbird/3.0.5
MIME-Version: 1.0
To: Michal Schmidt <mschmidt@redhat.com>,
        Borislav Petkov <borislav.petkov@amd.com>,
        Hans Rosenfeld <hans.rosenfeld@amd.com>
CC: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Shaohua Li <shaohua.li@intel.com>, Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH 1/2] x86: fix keeping track of AMD C1E
References: <20100713185816.2866.17837.stgit@localhost.localdomain> <20100713185957.2866.50995.stgit@localhost.localdomain>
In-Reply-To: <20100713185957.2866.50995.stgit@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Adding Borislav and Hans to the Cc: list]

Any objections?  Otherwise I'm going to queue this up in the urgent queue.

	-hpa


On 07/13/2010 11:59 AM, Michal Schmidt wrote:
> On my system with AMD Phenom II X6 I am seeing pauses at boot (usually during
> udev startup) which require a key press to continue. It only happens if C1E is
> enabled in the BIOS.
> 
> It's caused by the APIC timer's inability to wake up the CPU from C1E (AMD
> erratum #400). Linux has a workaround for it, but it's not being applied
> correctly in this case. Though c1e_idle() detects C1E just fine, by the time
> acpi_idle ('processor.ko' module) takes over, it is forgotten.
> 
> After AMD C1E is detected, it is not sufficient to flag it in boot_cpu_data,
> because the flag will get cleared in identify_cpu() when more CPUs are brought
> up later. The fix is to mark the flag as forced.
> 
> The additional call to set_cpu_cap() is just to make sure the flag is set even
> on the CPUs that are already up and /proc/cpuinfo shows 'amdc1e' on all.
> 
> Also fix indentation in the function.
> 
> Signed-off-by: Michal Schmidt <mschmidt@redhat.com>
> ---
> 
>  arch/x86/kernel/process.c |    9 +++++----
>  1 files changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
> index e7e3521..f3520a8 100644
> --- a/arch/x86/kernel/process.c
> +++ b/arch/x86/kernel/process.c
> @@ -589,7 +589,7 @@ static void c1e_idle(void)
>  			if (!boot_cpu_has(X86_FEATURE_NONSTOP_TSC))
>  				mark_tsc_unstable("TSC halt in AMD C1E");
>  			printk(KERN_INFO "System has AMD C1E enabled\n");
> -			set_cpu_cap(&boot_cpu_data, X86_FEATURE_AMDC1E);
> +			setup_force_cpu_cap(X86_FEATURE_AMDC1E);
>  		}
>  	}
>  
> @@ -605,6 +605,7 @@ static void c1e_idle(void)
>  					   &cpu);
>  			printk(KERN_INFO "Switch to broadcast mode on CPU%d\n",
>  			       cpu);
> +			set_cpu_cap(&current_cpu_data, X86_FEATURE_AMDC1E);
>  		}
>  		clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_ENTER, &cpu);
>  
> @@ -614,9 +615,9 @@ static void c1e_idle(void)
>  		 * The switch back from broadcast mode needs to be
>  		 * called with interrupts disabled.
>  		 */
> -		 local_irq_disable();
> -		 clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_EXIT, &cpu);
> -		 local_irq_enable();
> +		local_irq_disable();
> +		clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_EXIT, &cpu);
> +		local_irq_enable();
>  	} else
>  		default_idle();
>  }
> 

