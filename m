Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751816Ab2KRJRx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2012 04:17:53 -0500
Received: from mail-wi0-f172.google.com ([209.85.212.172]:54184 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751557Ab2KRJRv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2012 04:17:51 -0500
Message-ID: <50A8A7BB.2070809@linaro.org>
Date: Sun, 18 Nov 2012 10:17:47 +0100
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Francesco Lavra <francescolavra.fl@gmail.com>
CC: linux-pm@vger.kernel.org, khilman@ti.com, deepthi@linux.vnet.ibm.com,
        g.trinabh@gmail.com, linaro-dev@lists.linaro.org, len.brown@intel.com,
        linux-kernel@vger.kernel.org, rjw@sisk.pl, jwerner@chromium.org,
        akpm@linux-foundation.org, snanda@chromium.org
Subject: Re: [RFC] cpuidle - remove the power_specified field in the driver
References: <50831CA3.2020602@linaro.org> <1352752016-3136-1-git-send-email-daniel.lezcano@linaro.org> <50A89F08.7020307@gmail.com>
In-Reply-To: <50A89F08.7020307@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/18/2012 09:40 AM, Francesco Lavra wrote:
> Hi,
> 
> On 11/12/2012 09:26 PM, Daniel Lezcano wrote:
>> This patch follows the discussion about reinitializing the power usage
>> when a C-state is added/removed.
>>
>>  https://lkml.org/lkml/2012/10/16/518
>>
>> We realized the power usage field is never filled and when it is
>> filled for tegra, the power_specified flag is not set making all these
>> values to be resetted when the driver is initialized with the set_power_state
>> function.
>>
>> Julius and I feel this is over-engineered and the power_specified
>> flag could be simply removed and continue assuming the states are
>> backward sorted.
>>
>> The menu governor select function is simplified as the power is ordered.
>> Actually the condition is always true with the current code.
>>
>> The cpuidle_play_dead function is also simplified by doing a reverse lookup
>> on the array.
>>
>> The set_power_states function is removed as it does no make sense anymore.
>>
>> Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
>> ---
>>  drivers/cpuidle/cpuidle.c        |   17 ++++-------------
>>  drivers/cpuidle/driver.c         |   25 -------------------------
>>  drivers/cpuidle/governors/menu.c |    8 ++------
>>  include/linux/cpuidle.h          |    2 +-
>>  4 files changed, 7 insertions(+), 45 deletions(-)
>>
>> diff --git a/drivers/cpuidle/cpuidle.c b/drivers/cpuidle/cpuidle.c
>> index 711dd83..f983262 100644
>> --- a/drivers/cpuidle/cpuidle.c
>> +++ b/drivers/cpuidle/cpuidle.c
>> @@ -69,24 +69,15 @@ int cpuidle_play_dead(void)
>>  {
>>  	struct cpuidle_device *dev = __this_cpu_read(cpuidle_devices);
>>  	struct cpuidle_driver *drv = cpuidle_get_cpu_driver(dev);
>> -	int i, dead_state = -1;
>> -	int power_usage = -1;
>> +	int i;
>>  
>>  	if (!drv)
>>  		return -ENODEV;
>>  
>>  	/* Find lowest-power state that supports long-term idle */
>> -	for (i = CPUIDLE_DRIVER_STATE_START; i < drv->state_count; i++) {
>> -		struct cpuidle_state *s = &drv->states[i];
>> -
>> -		if (s->power_usage < power_usage && s->enter_dead) {
>> -			power_usage = s->power_usage;
>> -			dead_state = i;
>> -		}
>> -	}
>> -
>> -	if (dead_state != -1)
>> -		return drv->states[dead_state].enter_dead(dev, dead_state);
>> +	for (i = drv->state_count; i >= CPUIDLE_DRIVER_STATE_START; i--)
>> +		if (drv->states[i].play_dead)
> 
> I guess you meant drv->states[i].enter_dead

Yep :)



-- 
 <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

