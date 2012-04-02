Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751661Ab2DBTb2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 15:31:28 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:35367 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750778Ab2DBTb0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 15:31:26 -0400
Message-ID: <4F79FE8F.1040708@linaro.org>
Date: Mon, 02 Apr 2012 21:31:27 +0200
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
CC: lenb@kernel.org, khilman@ti.com, deepthi@linux.vnet.ibm.com,
        g.trinabh@gmail.com, arjan@infradead.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, amit.kucheria@linaro.org
Subject: Re: [PATCH] cpuidle: Avoid possible NULL pointer dereference in __cpuidle_register_device()
References: <20120402144422.11574.83174.stgit@srivatsabhat.in.ibm.com>
In-Reply-To: <20120402144422.11574.83174.stgit@srivatsabhat.in.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/02/2012 04:44 PM, Srivatsa S. Bhat wrote:
> In __cpuidle_register_device(), "dev->cpu" is used before checking if dev is
> non-NULL. Fix it.
>
> Signed-off-by: Srivatsa S. Bhat<srivatsa.bhat@linux.vnet.ibm.com>
> ---

That should be fixed at the caller level. Usually, static function does 
not check the function parameters, it is up to the exported function to 
do that. It is supposed the static functions are called with valid 
parameters.

There are two callers for __cpuidle_register_device:
  * cpuidle_register_device
  * cpuidle_enable_device

Both of them do not check 'dev' is a valid parameter. They should as 
they are exported and could be used by an external module. IMHO, BUG_ON 
could be used here if dev == NULL.


>   drivers/cpuidle/cpuidle.c |    3 ++-
>   1 files changed, 2 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/cpuidle/cpuidle.c b/drivers/cpuidle/cpuidle.c
> index 87411ce..75b381e 100644
> --- a/drivers/cpuidle/cpuidle.c
> +++ b/drivers/cpuidle/cpuidle.c
> @@ -372,7 +372,7 @@ EXPORT_SYMBOL_GPL(cpuidle_disable_device);
>   static int __cpuidle_register_device(struct cpuidle_device *dev)
>   {
>   	int ret;
> -	struct device *cpu_dev = get_cpu_device((unsigned long)dev->cpu);
> +	struct device *cpu_dev;
>   	struct cpuidle_driver *cpuidle_driver = cpuidle_get_driver();
>
>   	if (!dev)
> @@ -380,6 +380,7 @@ static int __cpuidle_register_device(struct cpuidle_device *dev)
>   	if (!try_module_get(cpuidle_driver->owner))
>   		return -EINVAL;
>
> +	cpu_dev = get_cpu_device((unsigned long)dev->cpu);
>   	init_completion(&dev->kobj_unregister);
>
>   	per_cpu(cpuidle_devices, dev->cpu) = dev;
>


-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

