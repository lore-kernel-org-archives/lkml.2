Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932507Ab2EUXdG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 19:33:06 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:36650 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753895Ab2EUXdD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 19:33:03 -0400
MIME-Version: 1.0
In-Reply-To: <CAE9FiQUVJ3YHQfJ5i1fr8VU8-n_Rpd683DZ7M+54JwLk5kL_=g@mail.gmail.com>
References: <20120518102640.GB31517@dhcp-26-207.brq.redhat.com>
	<CAE9FiQXUM-+KSZ1OcxipRW-3XQED3Csyxs=0ke0hJZR7E_hrhg@mail.gmail.com>
	<20120521081330.GB28930@dhcp-26-207.brq.redhat.com>
	<CAE9FiQUVJ3YHQfJ5i1fr8VU8-n_Rpd683DZ7M+54JwLk5kL_=g@mail.gmail.com>
Date: Mon, 21 May 2012 16:33:03 -0700
X-Google-Sender-Auth: _RIGC9tB-SvNFK1ONALLDxyRMc4
Message-ID: <CAE9FiQUA_hSA4wH6Sm93+yVty6X=Dq8UGinC7PNRcFcbpB3MpQ@mail.gmail.com>
Subject: Re: [PATCH 2/3] x86: x2apic/cluster: Make use of lowest priority
 delivery mode
From: Yinghai Lu <yinghai@kernel.org>
To: Alexander Gordeev <agordeev@redhat.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 21, 2012 at 4:02 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> On Mon, May 21, 2012 at 1:13 AM, Alexander Gordeev <agordeev@redhat.com> wrote:
>> On Sat, May 19, 2012 at 01:53:36PM -0700, Yinghai Lu wrote:
>>> > +static void
>>> > +x2apic_cluster_vector_allocation_domain(int cpu, struct cpumask *retmask)
>>> > +{
>>> > +       cpumask_copy(retmask, cpu_possible_mask);
>>>
>>> why not using per_cpu(cpus_in_cluster, cpu) instead?
>>
>> Because it would lead to suboptimal results when updating IRQ affinity:
>>
>> int __ioapic_set_affinity(struct irq_data *data, const struct cpumask *mask,
>>                          unsigned int *dest_id)
>> {
>>        struct irq_cfg *cfg = data->chip_data;
>>
>>        if (!cpumask_intersects(mask, cpu_online_mask))
>>                return -1;
>>
>>        if (assign_irq_vector(data->irq, data->chip_data, mask))
>>                return -1;
>>
>> This call ^^^ will update cfg->domain with the value returned by the call to
>> apic->vector_allocation_domain(). If per_cpu(cpus_in_cluster, cpu) is returned
>> as cfg->domain here then all other clusters contained in the 'mask' will not
>> be taken into consideration by the apic->cpu_mask_to_apicid_and() call below.
>>
>>        cpumask_copy(data->affinity, mask);
>>
>>        *dest_id = apic->cpu_mask_to_apicid_and(mask, cfg->domain);
>>
>> So we really need to submit all possible CPUs here ^^^ to be able finding the
>> best/heaviest cluster out of the 'mask'.
>
> ok.

Maybe you can not simply to change that to possible_cpu_mask.

otherwise assign_irq_vector will try to get same vector for all cpus
for one irq.

then will make x2apic cluster mode will one support 224 irqs instead.

so you need to make vector_allocation_domain() to be less cpu set.

Yinghai
