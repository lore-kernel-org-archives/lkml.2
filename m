Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755579Ab1KWNfE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 08:35:04 -0500
Received: from mx1.redhat.com ([209.132.183.28]:4274 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755445Ab1KWNfC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 08:35:02 -0500
Message-ID: <4ECCF669.6080007@redhat.com>
Date: Wed, 23 Nov 2011 21:34:33 +0800
From: Dave Young <dyoung@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: holzheu@linux.vnet.ibm.com
CC: akpm@linux-foundation.org, heiko.carstens@de.ibm.com,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        Simon Horman <horms@verge.net.au>,
        "Eric W. Biederman" <ebiederm@xmission.com>, schwidefsky@de.ibm.com,
        Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH v2] kdump: crashk_res init check for /sys/kernel/kexec_crash_size
References: <1322043068.10119.7.camel@br98xy6r> <20111123102214.GA4914@verge.net.au> <1322054283.10119.11.camel@br98xy6r>
In-Reply-To: <1322054283.10119.11.camel@br98xy6r>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/23/2011 09:18 PM, Michael Holzheu wrote:

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
> In addition to that this patch also simplifies the "ret = -EINVAL"
> vs. "ret = 0" logic as suggested by Simon Horman.
> 
> Cc: Simon Horman <horms@verge.net.au>
> Signed-off-by: Michael Holzheu <holzheu@linux.vnet.ibm.com>
> ---
>  kernel/kexec.c |   10 ++++------
>  1 file changed, 4 insertions(+), 6 deletions(-)
> 
> --- a/kernel/kexec.c
> +++ b/kernel/kexec.c
> @@ -1131,7 +1131,7 @@ void __weak crash_free_reserved_phys_ran
>  int crash_shrink_memory(unsigned long new_size)
>  {
>  	int ret = 0;
> -	unsigned long start, end;
> +	unsigned long start, end, old_size;


Sorry for jump in a little late, instead of introduce a new variable,
why not add something like:

if (!end)
	return -EINVAL;

>  
>  	mutex_lock(&kexec_mutex);
>  
> @@ -1141,11 +1141,9 @@ int crash_shrink_memory(unsigned long ne
>  	}
>  	start = crashk_res.start;
>  	end = crashk_res.end;
> -
> -	if (new_size >= end - start + 1) {
> -		ret = -EINVAL;
> -		if (new_size == end - start + 1)
> -			ret = 0;
> +	old_size = (end == 0) ? 0 : end - start + 1;
> +	if (new_size >= old_size) {
> +		ret = (new_size == old_size) ? 0 : -EINVAL;
>  		goto unlock;
>  	}
>  
> 
> 
> 
> _______________________________________________
> kexec mailing list
> kexec@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/kexec



-- 
Thanks
Dave
