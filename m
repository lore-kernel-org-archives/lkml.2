Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933590Ab0EKACr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 20:02:47 -0400
Received: from mail.perches.com ([173.55.12.10]:2128 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933574Ab0EKACl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 20:02:41 -0400
Subject: Re: [PATCH 1/1] staging: hv: Optimize adj_guesttime function and
 add more detailed comments
From: Joe Perches <joe@perches.com>
To: Haiyang Zhang <haiyangz@microsoft.com>
Cc: "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
       "'devel@driverdev.osuosl.org'" <devel@driverdev.osuosl.org>,
       "'virtualization@lists.osdl.org'" <virtualization@lists.osdl.org>,
       "'gregkh@suse.de'" <gregkh@suse.de>
In-Reply-To: <1FB5E1D5CA062146B38059374562DF72662AA29C@TK5EX14MBXC130.redmond.corp.microsoft.com>
References: <1FB5E1D5CA062146B38059374562DF72662AA29C@TK5EX14MBXC130.redmond.corp.microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 10 May 2010 17:02:38 -0700
Message-ID: <1273536158.20514.31.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-05-10 at 18:12 +0000, Haiyang Zhang wrote:
> diff --git a/drivers/staging/hv/hv_utils.c b/drivers/staging/hv/hv_utils.c
> index 8f1d3ba..c0f57a1 100644
> --- a/drivers/staging/hv/hv_utils.c
> +++ b/drivers/staging/hv/hv_utils.c
> @@ -106,28 +106,45 @@ static void shutdown_onchannelcallback(void *context)
>  		orderly_poweroff(false);
>  }
>  
> -
>  /*
> - * Synchronize time with host after reboot, restore, etc.
> + * Set guest time to host UTC time.
>   */
> -static void adj_guesttime(u64 hosttime, u8 flags)
> +static inline void do_adj_guesttime(u64 hosttime)
>  {
>  	s64 host_tns;
>  	struct timespec host_ts;
> -	static s32 scnt = 50;
>  
>  	host_tns = (hosttime - WLTIMEDELTA) * 100;
>  	host_ts = ns_to_timespec(host_tns);
>  
> +	do_settimeofday(&host_ts);
> +
> +	return;
> +}

Just a couple of style nits.

return at the end of a void function() is unnecessary.

> +
> +/*
> + * Synchronize time with host after reboot, restore, etc.
> + *
> + * ICTIMESYNCFLAG_SYNC flag bit indicates reboot, restore events of the VM.
> + * After reboot the flag ICTIMESYNCFLAG_SYNC is included in the first time
> + * message after the timesync channel is opened. Since the hv_utils module is
> + * loaded after hv_vmbus, the first message is usually missed. The other
> + * thing is, systime is automatically set to emulated hardware clock which may
> + * not be UTC time or in the same time zone. So, to override these effects, we
> + * use the first 50 time samples for initial system time setting.
> + */
> +static inline void adj_guesttime(u64 hosttime, u8 flags)
> +{
> +	static s32 scnt = 50;
> +
>  	if ((flags & ICTIMESYNCFLAG_SYNC) != 0) {
> -		do_settimeofday(&host_ts);
> +		do_adj_guesttime(hosttime);
>  		return;
>  	}
>  
> -	if ((flags & ICTIMESYNCFLAG_SAMPLE) != 0 &&
> -	    scnt > 0) {
> +	if ((flags & ICTIMESYNCFLAG_SAMPLE) != 0 && scnt > 0) {
>  		scnt--;
> -		do_settimeofday(&host_ts);
> +		do_adj_guesttime(hosttime);
>  	}
>  
>  	return;

here too


