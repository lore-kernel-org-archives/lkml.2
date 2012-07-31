Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755217Ab2GaPoU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 11:44:20 -0400
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:33275 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755054Ab2GaPoS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 11:44:18 -0400
Message-ID: <5017FD3E.7090003@linux.vnet.ibm.com>
Date: Tue, 31 Jul 2012 21:13:58 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Colin Cross <ccross@android.com>
CC: Len Brown <lenb@kernel.org>, Len Brown <len.brown@intel.com>,
        Kevin Hilman <khilman@ti.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
        Linux PM mailing list <linux-pm@vger.kernel.org>
Subject: Re: [PATCH] cpuidle: coupled: fix sleeping while atomic in cpu notifier
References: <1343251216-24106-1-git-send-email-ccross@android.com>
In-Reply-To: <1343251216-24106-1-git-send-email-ccross@android.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12073115-8878-0000-0000-00000372F614
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/26/2012 02:50 AM, Colin Cross wrote:
> The cpu hotplug notifier gets called in both atomic and non-atomic
> contexts, it is not always safe to lock a mutex.  Filter out all events
> except the six necessary ones, which are all sleepable, before taking
> the mutex.
> 
> Signed-off-by: Colin Cross <ccross@android.com>
> ---
>  drivers/cpuidle/coupled.c |   12 ++++++++++++
>  1 files changed, 12 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/cpuidle/coupled.c b/drivers/cpuidle/coupled.c
> index 2c9bf26..c24dda0 100644
> --- a/drivers/cpuidle/coupled.c
> +++ b/drivers/cpuidle/coupled.c
> @@ -678,6 +678,18 @@ static int cpuidle_coupled_cpu_notify(struct notifier_block *nb,
>  	int cpu = (unsigned long)hcpu;
>  	struct cpuidle_device *dev;
> 
> +	switch (action & ~CPU_TASKS_FROZEN) {
> +	case CPU_UP_PREPARE:
> +	case CPU_DOWN_PREPARE:
> +	case CPU_ONLINE:
> +	case CPU_DEAD:
> +	case CPU_UP_CANCELED:
> +	case CPU_DOWN_FAILED:
> +		break;
> +	default:
> +		return NOTIFY_OK;
> +	}
> +

Instead, wouldn't it be better to have case statements for the
2 cases that imply atomic context and return immediately?

Something like:
	switch (action & ~CPU_TASKS_FROZEN) {
	case CPU_STARTING:
	case CPU_DYING:
		return NOTIFY_OK;
	}

Regards,
Srivatsa S. Bhat

>  	mutex_lock(&cpuidle_lock);
> 
>  	dev = per_cpu(cpuidle_devices, cpu);
> 

