Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753281Ab0DZSME (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 14:12:04 -0400
Received: from claw.goop.org ([74.207.240.146]:49347 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753078Ab0DZSMA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 14:12:00 -0400
Message-ID: <4BD5D76D.9020601@goop.org>
Date: Mon, 26 Apr 2010 11:11:57 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Lightning/1.0b2pre Thunderbird/3.0.4
MIME-Version: 1.0
To: Glauber Costa <glommer@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, avi@redhat.com
Subject: Re: [PATCH 1/6] Enable pvclock flags in vcpu_time_info structure
References: <1272303988-21929-1-git-send-email-glommer@redhat.com> <1272303988-21929-2-git-send-email-glommer@redhat.com>
In-Reply-To: <1272303988-21929-2-git-send-email-glommer@redhat.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/26/2010 10:46 AM, Glauber Costa wrote:
> This patch removes one padding byte and transform it into a flags
> field. New versions of guests using pvclock will query these flags
> upon each read.
>   

Is this necessary?  Why not just make the pvclock driver maintain a
local flag set, and have the HV backend call into it to update it.  Why
does it need to be part of the pvclock structure?

    J

> Flags, however, will only be interpreted when the guest decides to.
> It uses the pvclock_valid_flags function to signal that a specific
> set of flags should be taken into consideration. Which flags are valid
> are usually devised via HV negotiation.
>
> Signed-off-by: Glauber Costa <glommer@redhat.com>
> CC: Jeremy Fitzhardinge <jeremy@goop.org>
> ---
>  arch/x86/include/asm/pvclock-abi.h |    3 ++-
>  arch/x86/include/asm/pvclock.h     |    1 +
>  arch/x86/kernel/pvclock.c          |    9 +++++++++
>  3 files changed, 12 insertions(+), 1 deletions(-)
>
> diff --git a/arch/x86/include/asm/pvclock-abi.h b/arch/x86/include/asm/pvclock-abi.h
> index 6d93508..ec5c41a 100644
> --- a/arch/x86/include/asm/pvclock-abi.h
> +++ b/arch/x86/include/asm/pvclock-abi.h
> @@ -29,7 +29,8 @@ struct pvclock_vcpu_time_info {
>  	u64   system_time;
>  	u32   tsc_to_system_mul;
>  	s8    tsc_shift;
> -	u8    pad[3];
> +	u8    flags;
> +	u8    pad[2];
>  } __attribute__((__packed__)); /* 32 bytes */
>  
>  struct pvclock_wall_clock {
> diff --git a/arch/x86/include/asm/pvclock.h b/arch/x86/include/asm/pvclock.h
> index 53235fd..c50823f 100644
> --- a/arch/x86/include/asm/pvclock.h
> +++ b/arch/x86/include/asm/pvclock.h
> @@ -6,6 +6,7 @@
>  
>  /* some helper functions for xen and kvm pv clock sources */
>  cycle_t pvclock_clocksource_read(struct pvclock_vcpu_time_info *src);
> +void pvclock_valid_flags(u8 flags);
>  unsigned long pvclock_tsc_khz(struct pvclock_vcpu_time_info *src);
>  void pvclock_read_wallclock(struct pvclock_wall_clock *wall,
>  			    struct pvclock_vcpu_time_info *vcpu,
> diff --git a/arch/x86/kernel/pvclock.c b/arch/x86/kernel/pvclock.c
> index 03801f2..8f4af7b 100644
> --- a/arch/x86/kernel/pvclock.c
> +++ b/arch/x86/kernel/pvclock.c
> @@ -31,8 +31,16 @@ struct pvclock_shadow_time {
>  	u32 tsc_to_nsec_mul;
>  	int tsc_shift;
>  	u32 version;
> +	u8  flags;
>  };
>  
> +static u8 valid_flags = 0;
> +
> +void pvclock_valid_flags(u8 flags)
> +{
> +	valid_flags = flags;
> +}
> +
>  /*
>   * Scale a 64-bit delta by scaling and multiplying by a 32-bit fraction,
>   * yielding a 64-bit result.
> @@ -91,6 +99,7 @@ static unsigned pvclock_get_time_values(struct pvclock_shadow_time *dst,
>  		dst->system_timestamp  = src->system_time;
>  		dst->tsc_to_nsec_mul   = src->tsc_to_system_mul;
>  		dst->tsc_shift         = src->tsc_shift;
> +		dst->flags             = src->flags;
>  		rmb();		/* test version after fetching data */
>  	} while ((src->version & 1) || (dst->version != src->version));
>  
>   

