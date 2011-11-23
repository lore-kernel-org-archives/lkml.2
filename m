Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753573Ab1KWKWV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 05:22:21 -0500
Received: from kirsty.vergenet.net ([202.4.237.240]:42778 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752469Ab1KWKWU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 05:22:20 -0500
Date: Wed, 23 Nov 2011 19:22:15 +0900
From: Simon Horman <horms@verge.net.au>
To: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Cc: akpm@linux-foundation.org, heiko.carstens@de.ibm.com,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>, schwidefsky@de.ibm.com,
        Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH] kdump: crashk_res init check for
 /sys/kernel/kexec_crash_size
Message-ID: <20111123102214.GA4914@verge.net.au>
References: <1322043068.10119.7.camel@br98xy6r>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1322043068.10119.7.camel@br98xy6r>
Organisation: Horms Solutions Ltd.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 23, 2011 at 11:11:08AM +0100, Michael Holzheu wrote:
> From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
> 
> Currently it is possible to set the crash_size via the sysfs
> /sys/kernel/kexec_crash_size even if no crash kernel memory has
> been defined with the "crashkernel" parameter. In this case
> "crashk_res" is not initialized and crashk_res.start = crashk_res.end = 0.
> Unfortunately resource_size(&crashk_res) returns 1 in this case.
> This breaks the s390 implementation of crash_(un)map_reserved_pages().
> 
> To fix the problem the correct "old_size" is now calculated in
> crash_shrink_memory(). "old_size is set to "0" if crashk_res is
> not initialized. With this change crash_shrink_memory() will do nothing,
> when "crashk_res" is not initialized. It will return "0" for
> "echo 0 > /sys/kernel/kexec_crash_size" and -EINVAL for
> "echo [not zero] > /sys/kernel/kexec_crash_size".
> 
> Signed-off-by: Michael Holzheu <holzheu@linux.vnet.ibm.com>
> ---
>  kernel/kexec.c |    8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> --- a/kernel/kexec.c
> +++ b/kernel/kexec.c
> @@ -1131,7 +1131,7 @@ void __weak crash_free_reserved_phys_ran
>  int crash_shrink_memory(unsigned long new_size)
>  {
>  	int ret = 0;
> -	unsigned long start, end;
> +	unsigned long start, end, old_size;
>  
>  	mutex_lock(&kexec_mutex);
>  
> @@ -1141,10 +1141,10 @@ int crash_shrink_memory(unsigned long ne
>  	}
>  	start = crashk_res.start;
>  	end = crashk_res.end;
> -
> -	if (new_size >= end - start + 1) {
> +	old_size = (end == 0) ? 0 : end - start + 1;
> +	if (new_size >= old_size) {
>  		ret = -EINVAL;
> -		if (new_size == end - start + 1)
> +		if (new_size == old_size)
>  			ret = 0;

I wonder if while we are here we could clean up the logic above a little.

To my mind both

		ret = new_size == old_size ? 0 : -EINVAL;

and

		if (new_size == old_size)
			ret = 0;
		else
			ret = -EINVAL;

are easier on the eyes than the current logic.

>  		goto unlock;
>  	}

But I am happy with the patch without my above suggestion.

Reviewed-by-by: Simon Horman <horms@verge.net.au>

