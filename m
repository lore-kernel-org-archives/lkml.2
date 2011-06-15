Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752203Ab1FOGUn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 02:20:43 -0400
Received: from na3sys009aog116.obsmtp.com ([74.125.149.240]:59497 "EHLO
	na3sys009aog116.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750887Ab1FOGUk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 02:20:40 -0400
Message-ID: <4DF84F31.4030108@ti.com>
Date: Wed, 15 Jun 2011 11:50:33 +0530
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.15) Gecko/20110303 Thunderbird/3.1.9
MIME-Version: 1.0
To: "Menon, Nishanth" <nm@ti.com>
CC: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Kevin Hilman <khilman@deeprootsystems.com>
Subject: Re: [PATCH] power: opp: Fix rcu_dereference_check() without protection!
References: <1308056600-17601-1-git-send-email-santosh.shilimkar@ti.com> <BANLkTimKHsGCrbZ5FhYOyJC8+pASUD-nDg@mail.gmail.com>
In-Reply-To: <BANLkTimKHsGCrbZ5FhYOyJC8+pASUD-nDg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/14/2011 9:08 PM, Menon, Nishanth wrote:
> On Tue, Jun 14, 2011 at 08:03, Santosh Shilimkar
> <santosh.shilimkar@ti.com>  wrote:
>> With RCU debug options enabled, below warning is observed.
>>
>> ===================================================
>> [ INFO: suspicious rcu_dereference_check() usage. ]
>> ---------------------------------------------------
>> drivers/base/power/opp.c:151 invoked rcu_dereference_check() without protection!
>>
>> other info that might help us debug this:
>>
>> rcu_scheduler_active = 1, debug_locks = 1
>> no locks held by swapper/1.
>> ...
>>
>> ---------------------------------------------------
>>
>> Fix the same by protecting it with rcu_read lock.
>>
>> Signed-off-by: Santosh Shilimkar<santosh.shilimkar@ti.com>
>> Cc: Rafael J. Wysocki<rjw@sisk.pl>
>> Cc: Nishanth Menon<nm@ti.com>
>> Cc: Kevin Hilman<khilman@deeprootsystems.com>
>> ---
>>   drivers/base/power/opp.c |    2 ++
>>   1 files changed, 2 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/base/power/opp.c b/drivers/base/power/opp.c
>> index 56a6899..cbed5e1 100644
>> --- a/drivers/base/power/opp.c
>> +++ b/drivers/base/power/opp.c
>> @@ -148,7 +148,9 @@ unsigned long opp_get_voltage(struct opp *opp)
>>         struct opp *tmp_opp;
>>         unsigned long v = 0;
>>
>> +       rcu_read_lock();
>>         tmp_opp = rcu_dereference(opp);
>> +       rcu_read_unlock();
>>         if (unlikely(IS_ERR_OR_NULL(tmp_opp)) || !tmp_opp->available)
>>                 pr_err("%s: Invalid parameters\n", __func__);
>>         else
> NAK. please read the Documentation/power/opp.txt
> the usage is as follows:
> rcu_read_lock();
> opp = opp_find_freq_ceil();
> voltage = opp_get_voltage(opp);
> rcu_read_unlock();
>
> the reason for this is that the opp pointer is not safe if we lock
> just the dereferencing.
>
Fair enough. if the whole fn is under the lock then it's not
necessary.

Regards
Santosh
