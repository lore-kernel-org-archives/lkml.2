Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752061Ab2KJCIY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 21:08:24 -0500
Received: from e6.ny.us.ibm.com ([32.97.182.146]:45340 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750810Ab2KJCIX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 21:08:23 -0500
Message-ID: <509DA63E.7070500@us.ibm.com>
Date: Fri, 09 Nov 2012 16:56:30 -0800
From: John Stultz <johnstul@us.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Kees Cook <keescook@chromium.org>
CC: linux-kernel@vger.kernel.org, Anton Vorontsov <cbouatmailru@gmail.com>,
        Colin Cross <ccross@android.com>, Tony Luck <tony.luck@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH v2] pstore/ram: no timekeeping calls when unavailable
References: <20121105220059.GA6379@www.outflux.net>
In-Reply-To: <20121105220059.GA6379@www.outflux.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12111000-1976-0000-0000-0000133C9A0A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/05/2012 02:00 PM, Kees Cook wrote:
> We must not call timekeeping functions unless they are available. If we dump
> before they have resumed, avoid a WARN_ON by setting the timestamp to 0.
>
> Since the "ram" pstore driver can be a module, we must have
> timekeeping_suspended exported.
>
> Reported-by: Doug Anderson <dianders@chromium.org>
> Cc: Anton Vorontsov <cbouatmailru@gmail.com>
> Cc: John Stultz <johnstul@us.ibm.com>
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
> v2:
>   - export needed for timekeeping_suspended (thanks to Fengguang Wu).
> ---
>   fs/pstore/ram.c           |    8 +++++++-
>   kernel/time/timekeeping.c |    1 +
>   2 files changed, 8 insertions(+), 1 deletion(-)
>
> diff --git a/fs/pstore/ram.c b/fs/pstore/ram.c
> index 1a4f6da..6d014e0 100644
> --- a/fs/pstore/ram.c
> +++ b/fs/pstore/ram.c
> @@ -171,7 +171,13 @@ static size_t ramoops_write_kmsg_hdr(struct persistent_ram_zone *prz)
>   	struct timeval timestamp;
>   	size_t len;
>
> -	do_gettimeofday(&timestamp);
> +	/* Handle dumping before timekeeping has resumed. */
> +	if (unlikely(timekeeping_suspended)) {
> +		timestamp.tv_sec = 0;
> +		timestamp.tv_usec = 0;
> +	} else
> +		do_gettimeofday(&timestamp);
> +
Would nulling out the timestamp be better done in do_gettimeofday()?  
That way we don't have to export timekeeping internals and users would 
get something more sane for this corner case.

thanks
-john


