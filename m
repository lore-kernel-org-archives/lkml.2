Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753295Ab2FMJor (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 05:44:47 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:52479 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752807Ab2FMJoq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 05:44:46 -0400
MIME-Version: 1.0
In-Reply-To: <CAORVsuWqWt0pJfewymh_ydAH61-uPsO0M7m7Gs4N3zJY=Vo9ZA@mail.gmail.com>
References: <1339502524-10265-1-git-send-email-vincent.guittot@linaro.org>
	<1339502524-10265-4-git-send-email-vincent.guittot@linaro.org>
	<CAORVsuWqWt0pJfewymh_ydAH61-uPsO0M7m7Gs4N3zJY=Vo9ZA@mail.gmail.com>
Date: Wed, 13 Jun 2012 11:44:45 +0200
Message-ID: <CAKfTPtBc-KuDg_1qe04TfYS4+66qQoiHCJQbCF9gnhga5ociow@mail.gmail.com>
Subject: Re: [RFC 3/4] ARM: topology: Update cpu_power according to DT information
From: Vincent Guittot <vincent.guittot@linaro.org>
To: Jean Pihet <jean.pihet@newoldbits.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linaro-dev@lists.linaro.org, devicetree-discuss@lists.ozlabs.org,
        linux@arm.linux.org.uk, peterz@infradead.org,
        grant.likely@secretlab.ca, rob.herring@calxeda.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13 June 2012 10:59, Jean Pihet <jean.pihet@newoldbits.com> wrote:
> Vincent,
>
> On Tue, Jun 12, 2012 at 2:02 PM, Vincent Guittot
> <vincent.guittot@linaro.org> wrote:
>> Use cpu compatibility field and clock-frequency field of DT to
>> estimate the capacity of each core of the system
>>
>> Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
>> ---
>>  arch/arm/kernel/topology.c |  122 ++++++++++++++++++++++++++++++++++++++++++++
>>  1 file changed, 122 insertions(+)
>>
>> diff --git a/arch/arm/kernel/topology.c b/arch/arm/kernel/topology.c
>> index 2f85a64..0c2aee4 100644
>> --- a/arch/arm/kernel/topology.c
>> +++ b/arch/arm/kernel/topology.c
>> @@ -17,6 +17,7 @@
>>  #include <linux/percpu.h>
>>  #include <linux/node.h>
>>  #include <linux/nodemask.h>
>> +#include <linux/of.h>
>>  #include <linux/sched.h>
>>
>>  #include <asm/cputype.h>
>> @@ -47,6 +48,122 @@ void set_power_scale(unsigned int cpu, unsigned long power)
>>        per_cpu(cpu_scale, cpu) = power;
>>  }
>>
>> +#ifdef CONFIG_OF
>> +struct cpu_efficiency {
>> +       const char *compatible;
>> +       unsigned long efficiency;
>> +};
>> +
>> +/*
>> + * Table of relative efficiency of each processors
>> + * The efficiency value must fit in 20bit. The final
>> + * cpu_scale value must be in the range [1:2048[.
> Typo here.

I realize that I have use absolute value instead of SCHED_POWER_SCALE.
The cpu_scale value must be in the range 0 < cpu_scale < 2*SCHED_POWER_SCALE

>
>> + * Processors that are not defined in the table,
>> + * use the default SCHED_POWER_SCALE value for cpu_scale.
>> + */
>> +struct cpu_efficiency table_efficiency[] = {
>> +       {"arm,cortex-a15", 3891},
>> +       {"arm,cortex-a7",  2048},
> How are those results measured or computed? Is this purely related to
> the number crunching performance?

These values are based on ARM's figures which say that Cortex-A15 is
1,9 faster than Cortex-A7 at same frequency. So the inputs are ARM's
figures. Then, the absolute values are arbitrary with the constraint
of being large enough for precision and small enough to make the
computation in an unsigned long

>
> Also more generally what if the cores frequencies are changing?

Up to now, the scheduler takes into account the maximum capacity of a
core when it checks the load balance of the system.

Regards,
Vincent

>
> Regards,
> Jean
