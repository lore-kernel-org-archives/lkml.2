Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933771Ab0EEI3S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 04:29:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19081 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932931Ab0EEI3P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 04:29:15 -0400
Message-ID: <4BE12C58.6040101@redhat.com>
Date: Wed, 05 May 2010 11:29:12 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Glauber Costa <glommer@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, zamsden@redhat.com,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH v2 1/7] Enable pvclock flags in vcpu_time_info structure
References: <1272901927-829-1-git-send-email-glommer@redhat.com> <1272901927-829-2-git-send-email-glommer@redhat.com>
In-Reply-To: <1272901927-829-2-git-send-email-glommer@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/03/2010 06:52 PM, Glauber Costa wrote:
> This patch removes one padding byte and transform it into a flags
> field. New versions of guests using pvclock will query these flags
> upon each read.
>
> Flags, however, will only be interpreted when the guest decides to.
> It uses the pvclock_valid_flags function to signal that a specific
> set of flags should be taken into consideration. Which flags are valid
> are usually devised via HV negotiation.
>
> Signed-off-by: Glauber Costa<glommer@redhat.com>
> CC: Jeremy Fitzhardinge<jeremy@goop.org>
> ---
>   arch/x86/include/asm/pvclock-abi.h |    3 ++-
>   arch/x86/include/asm/pvclock.h     |    1 +
>   arch/x86/kernel/pvclock.c          |    9 +++++++++
>   3 files changed, 12 insertions(+), 1 deletions(-)
>
> diff --git a/arch/x86/include/asm/pvclock-abi.h b/arch/x86/include/asm/pvclock-abi.h
> index 6d93508..ec5c41a 100644
> --- a/arch/x86/include/asm/pvclock-abi.h
> +++ b/arch/x86/include/asm/pvclock-abi.h
> @@ -29,7 +29,8 @@ struct pvclock_vcpu_time_info {
>   	u64   system_time;
>   	u32   tsc_to_system_mul;
>   	s8    tsc_shift;
> -	u8    pad[3];
> +	u8    flags;
> +	u8    pad[2];
>   } __attribute__((__packed__)); /* 32 bytes */
>
>   struct pvclock_wall_clock {
> diff --git a/arch/x86/include/asm/pvclock.h b/arch/x86/include/asm/pvclock.h
> index 53235fd..cd02f32 100644
> --- a/arch/x86/include/asm/pvclock.h
> +++ b/arch/x86/include/asm/pvclock.h
> @@ -6,6 +6,7 @@
>
>   /* some helper functions for xen and kvm pv clock sources */
>   cycle_t pvclock_clocksource_read(struct pvclock_vcpu_time_info *src);
> +void pvclock_set_flags(u8 flags);
>   unsigned long pvclock_tsc_khz(struct pvclock_vcpu_time_info *src);
>   void pvclock_read_wallclock(struct pvclock_wall_clock *wall,
>   			    struct pvclock_vcpu_time_info *vcpu,
> diff --git a/arch/x86/kernel/pvclock.c b/arch/x86/kernel/pvclock.c
> index 03801f2..aa2262b 100644
> --- a/arch/x86/kernel/pvclock.c
> +++ b/arch/x86/kernel/pvclock.c
> @@ -31,8 +31,16 @@ struct pvclock_shadow_time {
>   	u32 tsc_to_nsec_mul;
>   	int tsc_shift;
>   	u32 version;
> +	u8  flags;
>   };
>
> +static u8 valid_flags = 0;
> +
>    

Minor optimization: __read_mostly.

-- 
error compiling committee.c: too many arguments to function

