Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757517Ab0KVUQq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 15:16:46 -0500
Received: from claw.goop.org ([74.207.240.146]:44285 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753487Ab0KVUQp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 15:16:45 -0500
Message-ID: <4CEACFAB.90503@goop.org>
Date: Mon, 22 Nov 2010 12:16:43 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101027 Fedora/3.1.6-1.fc13 Lightning/1.0b3pre Thunderbird/3.1.6
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: "Xen-devel@lists.xensource.com" <Xen-devel@lists.xensource.com>,
        kvm-devel <kvm@vger.kernel.org>, Glauber Costa <glommer@redhat.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Virtualization <virtualization@lists.linux-foundation.org>,
        Olivier Hanesse <olivier.hanesse@gmail.com>,
        Avi Kivity <avi@redhat.com>, Eelco Dolstra <e.dolstra@tudelft.nl>
Subject: Re: [PATCH] x86/pvclock-xen: zero last_value on resume
References: <4CC708DE.1070000@goop.org>
In-Reply-To: <4CC708DE.1070000@goop.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/26/2010 09:59 AM, Jeremy Fitzhardinge wrote:
>
> If the guest domain has been suspend/resumed or migrated, then the
> system clock backing the pvclock clocksource may revert to a smaller
> value (ie, can be non-monotonic across the migration/save-restore).
> Make sure we zero last_value in that case so that the domain
> continues to see clock updates.

Ping?  Looks like this fell through the gaps.

    J

> [ I don't know if kvm needs an analogous fix or not. ]
>
> Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> Cc: Stable Kernel <stable@kernel.org>
> Reported-by: Eelco Dolstra <e.dolstra@tudelft.nl>
> Reported-by: Olivier Hanesse <olivier.hanesse@gmail.com>
> Bisected-by: Cédric Schieli <cschieli@gmail.com>
> Tested-by: Cédric Schieli <cschieli@gmail.com>
>
> diff --git a/arch/x86/include/asm/pvclock.h b/arch/x86/include/asm/pvclock.h
> index cd02f32..6226870 100644
> --- a/arch/x86/include/asm/pvclock.h
> +++ b/arch/x86/include/asm/pvclock.h
> @@ -11,5 +11,6 @@ unsigned long pvclock_tsc_khz(struct pvclock_vcpu_time_info *src);
>  void pvclock_read_wallclock(struct pvclock_wall_clock *wall,
>  			    struct pvclock_vcpu_time_info *vcpu,
>  			    struct timespec *ts);
> +void pvclock_resume(void);
>  
>  #endif /* _ASM_X86_PVCLOCK_H */
> diff --git a/arch/x86/kernel/pvclock.c b/arch/x86/kernel/pvclock.c
> index 239427c..a4f07c1 100644
> --- a/arch/x86/kernel/pvclock.c
> +++ b/arch/x86/kernel/pvclock.c
> @@ -120,6 +120,11 @@ unsigned long pvclock_tsc_khz(struct pvclock_vcpu_time_info *src)
>  
>  static atomic64_t last_value = ATOMIC64_INIT(0);
>  
> +void pvclock_resume(void)
> +{
> +	atomic64_set(&last_value, 0);
> +}
> +
>  cycle_t pvclock_clocksource_read(struct pvclock_vcpu_time_info *src)
>  {
>  	struct pvclock_shadow_time shadow;
> diff --git a/arch/x86/xen/time.c b/arch/x86/xen/time.c
> index b2bb5aa..5da5e53 100644
> --- a/arch/x86/xen/time.c
> +++ b/arch/x86/xen/time.c
> @@ -426,6 +426,8 @@ void xen_timer_resume(void)
>  {
>  	int cpu;
>  
> +	pvclock_resume();
> +
>  	if (xen_clockevent != &xen_vcpuop_clockevent)
>  		return;
>  
>
>
>
>
> _______________________________________________
> Virtualization mailing list
> Virtualization@lists.linux-foundation.org
> https://lists.linux-foundation.org/mailman/listinfo/virtualization

