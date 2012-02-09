Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757701Ab2BINw6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 08:52:58 -0500
Received: from mx1.redhat.com ([209.132.183.28]:13400 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753646Ab2BINw6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 08:52:58 -0500
Message-ID: <4F33CFAD.30602@redhat.com>
Date: Thu, 09 Feb 2012 08:52:45 -0500
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110419 Red Hat/3.1.10-1.el6_0 Thunderbird/3.1.10
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] Use NUMA node cpu mask in irq affinity
References: <1328734113-3608-1-git-send-email-prarit@redhat.com> <CAE9FiQUbVVwN8s+fT84bOvz0xo93Pp9G58RecKYbyNKyXiEAKA@mail.gmail.com>
In-Reply-To: <CAE9FiQUbVVwN8s+fT84bOvz0xo93Pp9G58RecKYbyNKyXiEAKA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 02/08/2012 06:51 PM, Yinghai Lu wrote:
> On Wed, Feb 8, 2012 at 12:48 PM, Prarit Bhargava <prarit@redhat.com> wrote:
>> The irq affinity files (/proc/irq/.../smp_affinity) contain a mask that is used
>> to "pin" an irq to a set of cpus.  On boot this set is currently all cpus.
>> This can be incorrect as ACPI SRAT may tell us that a specific device or
>> bus is attached to a particular node and it's cpus.
>>
>> When setting up the irq affinity we should take into account the NUMA node
>> cpu mask by and'ing it into the irq's affinity mask.
>>
>> Signed-off-by: Prarit Bhargava <prarit@redhat.com>
>> Acked-by: Neil Horman <nhorman@tuxdriver.com>
>> ---
>>  kernel/irq/manage.c |    2 ++
>>  1 files changed, 2 insertions(+), 0 deletions(-)
>>
>> diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
>> index a9a9dbe..2fb3469 100644
>> --- a/kernel/irq/manage.c
>> +++ b/kernel/irq/manage.c
>> @@ -301,6 +301,8 @@ setup_affinity(unsigned int irq, struct irq_desc *desc, struct cpumask *mask)
>>        }
>>
>>        cpumask_and(mask, cpu_online_mask, set);
>> +       if (desc->irq_data.node != -1)
>> +               cpumask_and(mask, mask, cpumask_of_node(desc->irq_data.node));
>>        ret = chip->irq_set_affinity(&desc->irq_data, mask, false);
>>        switch (ret) {
>>        case IRQ_SET_MASK_OK:
>> --
> 
> How about all cpus on that node get offlined?

Good point.  I guess that also goes to tglx's comments wondering what happens if the mask ends up being zero.

I'll think about that and send out a new patch shortly.

P.
> 
> Yinghai
