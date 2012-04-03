Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754594Ab2DCOIi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 10:08:38 -0400
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:60933 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754081Ab2DCOIg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 10:08:36 -0400
Message-ID: <4F7B0451.1010304@linux.vnet.ibm.com>
Date: Tue, 03 Apr 2012 19:38:17 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Toshi Kani <toshi.kani@hp.com>
CC: len.brown@intel.com, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Boris Ostrovsky <boris.ostrovsky@amd.com>, lenb@kernel.org,
        Daniel Lezcano <daniel.lezcano@linaro.org>, amit.kucheria@linaro.org,
        linux-pm@vger.kernel.org
Subject: Re: [PATCH] cpuidle: Fix panic in CPU off-lining with no idle driver
References: <1333251422-13479-1-git-send-email-toshi.kani@hp.com>
In-Reply-To: <1333251422-13479-1-git-send-email-toshi.kani@hp.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12040314-2674-0000-0000-000003EDAC4B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/01/2012 09:07 AM, Toshi Kani wrote:

> Fix a NULL pointer dereference panic in cpuidle_play_dead() during
> CPU off-lining when no cpuidle driver is registered.  A cpuidle
> driver may be registered at boot-time based on CPU type.  This patch
> allows an off-lined CPU to enter HLT-based idle in this condition.
> 
> Signed-off-by: Toshi Kani <toshi.kani@hp.com>
> Cc: Boris Ostrovsky <boris.ostrovsky@amd.com>
> ---
>  drivers/cpuidle/cpuidle.c |    5 ++++-
>  1 files changed, 4 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/cpuidle/cpuidle.c b/drivers/cpuidle/cpuidle.c
> index 87411ce..2f0083a 100644
> --- a/drivers/cpuidle/cpuidle.c
> +++ b/drivers/cpuidle/cpuidle.c
> @@ -74,7 +74,7 @@ static cpuidle_enter_t cpuidle_enter_ops;
>  /**
>   * cpuidle_play_dead - cpu off-lining
>   *
> - * Only returns in case of an error
> + * Returns in case of an error or no driver
>   */
>  int cpuidle_play_dead(void)
>  {
> @@ -83,6 +83,9 @@ int cpuidle_play_dead(void)
>  	int i, dead_state = -1;
>  	int power_usage = -1;
> 
> +	if (!drv)
> +		return -ENODEV;
> +
>  	/* Find lowest-power state that supports long-term idle */
>  	for (i = CPUIDLE_DRIVER_STATE_START; i < drv->state_count; i++) {
>  		struct cpuidle_state *s = &drv->states[i];



Reviewed-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Tested-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>


[The machine I tested on did support mwait. So, to disable mwait and ensure
that no idle driver is registered, I applied my fix for "idle=" parameters
(https://lkml.org/lkml/2012/4/3/158) and then passed idle=halt in the kernel
command line. Then the machine crashed during CPU offline. Then I tried your
patch and it fixed the issue.]
 
Regards,
Srivatsa S. Bhat
IBM Linux Technology Center

