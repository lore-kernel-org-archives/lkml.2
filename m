Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755957Ab2GaS1b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 14:27:31 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:37533 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751166Ab2GaS12 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 14:27:28 -0400
MIME-Version: 1.0
In-Reply-To: <5017FD3E.7090003@linux.vnet.ibm.com>
References: <1343251216-24106-1-git-send-email-ccross@android.com>
	<5017FD3E.7090003@linux.vnet.ibm.com>
Date: Tue, 31 Jul 2012 11:27:27 -0700
X-Google-Sender-Auth: p_Gp9nHstrs8e_Klu3k-dH_ch0M
Message-ID: <CAMbhsRT_h=dTfUVRmMUj5Bz7ZqcJ7UA2svwNP9CNa9=f=cL4+Q@mail.gmail.com>
Subject: Re: [PATCH] cpuidle: coupled: fix sleeping while atomic in cpu notifier
From: Colin Cross <ccross@android.com>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Len Brown <lenb@kernel.org>, Len Brown <len.brown@intel.com>,
        Kevin Hilman <khilman@ti.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
        Linux PM mailing list <linux-pm@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 31, 2012 at 8:43 AM, Srivatsa S. Bhat
<srivatsa.bhat@linux.vnet.ibm.com> wrote:
> On 07/26/2012 02:50 AM, Colin Cross wrote:
>> The cpu hotplug notifier gets called in both atomic and non-atomic
>> contexts, it is not always safe to lock a mutex.  Filter out all events
>> except the six necessary ones, which are all sleepable, before taking
>> the mutex.
>>
>> Signed-off-by: Colin Cross <ccross@android.com>
>> ---
>>  drivers/cpuidle/coupled.c |   12 ++++++++++++
>>  1 files changed, 12 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/cpuidle/coupled.c b/drivers/cpuidle/coupled.c
>> index 2c9bf26..c24dda0 100644
>> --- a/drivers/cpuidle/coupled.c
>> +++ b/drivers/cpuidle/coupled.c
>> @@ -678,6 +678,18 @@ static int cpuidle_coupled_cpu_notify(struct notifier_block *nb,
>>       int cpu = (unsigned long)hcpu;
>>       struct cpuidle_device *dev;
>>
>> +     switch (action & ~CPU_TASKS_FROZEN) {
>> +     case CPU_UP_PREPARE:
>> +     case CPU_DOWN_PREPARE:
>> +     case CPU_ONLINE:
>> +     case CPU_DEAD:
>> +     case CPU_UP_CANCELED:
>> +     case CPU_DOWN_FAILED:
>> +             break;
>> +     default:
>> +             return NOTIFY_OK;
>> +     }
>> +
>
> Instead, wouldn't it be better to have case statements for the
> 2 cases that imply atomic context and return immediately?
>
> Something like:
>         switch (action & ~CPU_TASKS_FROZEN) {
>         case CPU_STARTING:
>         case CPU_DYING:
>                 return NOTIFY_OK;
>         }

No, because then it would need updating whenever a new notification
event was added.
