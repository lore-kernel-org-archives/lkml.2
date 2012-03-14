Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760705Ab2CNKNf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 06:13:35 -0400
Received: from goliath.siemens.de ([192.35.17.28]:25766 "EHLO
	goliath.siemens.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760403Ab2CNKNd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 06:13:33 -0400
Message-ID: <4F606F13.1040704@siemens.com>
Date: Wed, 14 Mar 2012 11:12:35 +0100
From: Jan Kiszka <jan.kiszka@siemens.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Eric B Munson <emunson@mgebm.net>
CC: avi@redhat.com, mingo@redhat.com, hpa@zytor.com, ryanh@linux.vnet.ibm.com,
        aliguori@us.ibm.com, mtosatti@redhat.com, kvm@vger.kernel.org,
        linux-arch@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4 V16] Add functions to check if the host has stopped
 the vm
References: <1331408248-6781-1-git-send-email-emunson@mgebm.net> <1331408248-6781-3-git-send-email-emunson@mgebm.net>
In-Reply-To: <1331408248-6781-3-git-send-email-emunson@mgebm.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-03-10 20:37, Eric B Munson wrote:
> When a host stops or suspends a VM it will set a flag to show this.  The
> watchdog will use these functions to determine if a softlockup is real, or the
> result of a suspended VM.
> 

...

> diff --git a/arch/x86/kernel/kvmclock.c b/arch/x86/kernel/kvmclock.c
> index f8492da..4ba090c 100644
> --- a/arch/x86/kernel/kvmclock.c
> +++ b/arch/x86/kernel/kvmclock.c
> @@ -22,6 +22,7 @@
>  #include <asm/msr.h>
>  #include <asm/apic.h>
>  #include <linux/percpu.h>
> +#include <linux/hardirq.h>
>  
>  #include <asm/x86_init.h>
>  #include <asm/reboot.h>
> @@ -114,6 +115,26 @@ static void kvm_get_preset_lpj(void)
>  	preset_lpj = lpj;
>  }
>  
> +bool kvm_check_and_clear_guest_paused(void)
> +{
> +	bool ret = false;
> +	struct pvclock_vcpu_time_info *src;
> +
> +	/*
> +	 * per_cpu() is safe here because this function is only called from
> +	 * timer functions where preemption is already disabled.
> +	 */
> +	WARN_ON(!in_atomic());
> +	src = &__get_cpu_var(hv_clock);
> +	if ((src->flags & PVCLOCK_GUEST_STOPPED) != 0) {
> +		__this_cpu_and(hv_clock.flags, ~PVCLOCK_GUEST_STOPPED);
> +		ret = true;
> +	}
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(kvm_check_and_clear_guest_paused);

Which module is going to use this? I failed to find it, but I may have
missed something.

The actual reason for this reply: this patches causes a compiler warning
here, likely due to lacking include for EXPORT_SYMBOL_GPL:

  CC      arch/x86/kernel/kvmclock.o
/data/linux-kvm/arch/x86/kernel/kvmclock.c:136:1: warning: data
definition has no type or storage class
/data/linux-kvm/arch/x86/kernel/kvmclock.c:136:1: warning: type defaults
to ‘int’ in declaration of ‘EXPORT_SYMBOL_GPL’
/data/linux-kvm/arch/x86/kernel/kvmclock.c:136:1: warning: parameter
names (without types) in function declaration

Jan

-- 
Siemens AG, Corporate Technology, CT T DE IT 1
Corporate Competence Center Embedded Linux
