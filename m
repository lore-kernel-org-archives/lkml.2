Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754797Ab0ELWBW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 18:01:22 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40314 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752702Ab0ELWBU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 18:01:20 -0400
Date: Wed, 12 May 2010 15:00:39 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Andrej Gelenberg <andrej.gelenberg@udo.edu>
Cc: linux@brodo.de, ashok.raj@intel.com, jacob.shin@amd.com,
       linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org
Subject: Re: [PATCH] [CPUFREQ] fix race condition in store_scaling_governor
Message-Id: <20100512150039.b5b2729d.akpm@linux-foundation.org>
In-Reply-To: <4BE967B9.5050107@udo.edu>
References: <4BE967B9.5050107@udo.edu>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 May 2010 16:20:41 +0200
Andrej Gelenberg <andrej.gelenberg@udo.edu> wrote:

> Wrap store_scaling_governor with mutex lock cpufreq_governor_mutex.
> Fix kernel panic if switch scaling governor very fast.
> Bug in bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=15948
> 

Looks sane, I guess.

I am afraid of moving all those functions inside
cpufreq_governor_mutex.  Not for any specific reason, apart from a long
history of nasty deadlocks with cpufreq global locks :(

Has this change been well-tested with lockdep enabled?

> 
> diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
> index 75d293e..6ba42f9 100644
> --- a/drivers/cpufreq/cpufreq.c
> +++ b/drivers/cpufreq/cpufreq.c
> @@ -403,8 +403,6 @@ static int cpufreq_parse_governor(char 
> *str_governor, unsigned int *policy,
>   	} else if (cpufreq_driver->target) {
>   		struct cpufreq_governor *t;
> 
> -		mutex_lock(&cpufreq_governor_mutex);
> -
>   		t = __find_governor(str_governor);
> 
>   		if (t == NULL) {
> @@ -429,8 +427,6 @@ static int cpufreq_parse_governor(char 
> *str_governor, unsigned int *policy,
>   			*governor = t;
>   			err = 0;
>   		}
> -
> -		mutex_unlock(&cpufreq_governor_mutex);
>   	}
>   out:
>   	return err;
> @@ -521,7 +517,7 @@ static ssize_t show_scaling_governor(struct 
> cpufreq_policy *policy, char *buf)
>   /**
>    * store_scaling_governor - store policy for the specified CPU
>    */
> -static ssize_t store_scaling_governor(struct cpufreq_policy *policy,
> +static ssize_t _store_scaling_governor(struct cpufreq_policy *policy,
>   					const char *buf, size_t count)
>   {
>   	unsigned int ret = -EINVAL;
> @@ -553,6 +549,16 @@ static ssize_t store_scaling_governor(struct 
> cpufreq_policy *policy,
>   		return count;
>   }
> 
> +static ssize_t store_scaling_governor(struct cpufreq_policy *policy,
> +                                        const char *buf, size_t count)
> +{
> +        ssize_t ret;
> +	mutex_lock(&cpufreq_governor_mutex);
> +        ret = _store_scaling_governor(policy, buf, count);
> +	mutex_unlock(&cpufreq_governor_mutex);
> +        return ret;
> +}
> +
>   /**
>    * show_scaling_driver - show the cpufreq driver currently loaded
>    */

Your email client replaces tabs with spaces and is wordwrapping the
text.  I fixed that up in my copy of the patch.

