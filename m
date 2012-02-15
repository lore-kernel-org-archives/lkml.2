Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758884Ab2BOKtx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 05:49:53 -0500
Received: from mx1.redhat.com ([209.132.183.28]:21451 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755995Ab2BOKtw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 05:49:52 -0500
Message-ID: <4F3B8DC9.8040100@redhat.com>
Date: Wed, 15 Feb 2012 12:49:45 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: Igor Mammedov <imammedo@redhat.com>
CC: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com, riel@redhat.com, amit.shah@redhat.com,
        mtosatti@redhat.com
Subject: Re: [PATCH] BUG in pv_clock when overflow condition is detected
References: <1329157256-19926-1-git-send-email-imammedo@redhat.com>
In-Reply-To: <1329157256-19926-1-git-send-email-imammedo@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/13/2012 08:20 PM, Igor Mammedov wrote:
> BUG when overflow occurs at pvclock.c:pvclock_get_nsec_offset
>
>     u64 delta = native_read_tsc() - shadow->tsc_timestamp;
>
> this might happen at an attempt to read an uninitialized yet clock.
> It won't prevent stalls and hangs but at least it won't do it silently.
>
> Signed-off-by: Igor Mammedov <imammedo@redhat.com>
> ---
>  arch/x86/kernel/pvclock.c |    5 ++++-
>  1 files changed, 4 insertions(+), 1 deletions(-)
>
> diff --git a/arch/x86/kernel/pvclock.c b/arch/x86/kernel/pvclock.c
> index 42eb330..35a6190 100644
> --- a/arch/x86/kernel/pvclock.c
> +++ b/arch/x86/kernel/pvclock.c
> @@ -43,7 +43,10 @@ void pvclock_set_flags(u8 flags)
>  
>  static u64 pvclock_get_nsec_offset(struct pvclock_shadow_time *shadow)
>  {
> -	u64 delta = native_read_tsc() - shadow->tsc_timestamp;
> +	u64 delta;
> +	u64 tsc = native_read_tsc();
> +	BUG_ON(tsc < shadow->tsc_timestamp);
> +	delta = tsc - shadow->tsc_timestamp;
>  	return pvclock_scale_delta(delta, shadow->tsc_to_nsec_mul,
>  				   shadow->tsc_shift);

Maybe a WARN_ON_ONCE()?  Otherwise a relatively minor hypervisor bug can
kill the guest.

-- 
error compiling committee.c: too many arguments to function

