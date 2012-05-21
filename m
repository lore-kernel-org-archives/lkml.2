Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932577Ab2EUXCK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 19:02:10 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:46684 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932544Ab2EUXCH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 19:02:07 -0400
MIME-Version: 1.0
In-Reply-To: <20120521081330.GB28930@dhcp-26-207.brq.redhat.com>
References: <20120518102640.GB31517@dhcp-26-207.brq.redhat.com>
	<CAE9FiQXUM-+KSZ1OcxipRW-3XQED3Csyxs=0ke0hJZR7E_hrhg@mail.gmail.com>
	<20120521081330.GB28930@dhcp-26-207.brq.redhat.com>
Date: Mon, 21 May 2012 16:02:06 -0700
X-Google-Sender-Auth: uH5KGtchg5eZQj67pP2POz-ltlk
Message-ID: <CAE9FiQUVJ3YHQfJ5i1fr8VU8-n_Rpd683DZ7M+54JwLk5kL_=g@mail.gmail.com>
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

On Mon, May 21, 2012 at 1:13 AM, Alexander Gordeev <agordeev@redhat.com> wrote:
> On Sat, May 19, 2012 at 01:53:36PM -0700, Yinghai Lu wrote:
>> > +static void
>> > +x2apic_cluster_vector_allocation_domain(int cpu, struct cpumask *retmask)
>> > +{
>> > +       cpumask_copy(retmask, cpu_possible_mask);
>>
>> why not using per_cpu(cpus_in_cluster, cpu) instead?
>
> Because it would lead to suboptimal results when updating IRQ affinity:
>
> int __ioapic_set_affinity(struct irq_data *data, const struct cpumask *mask,
>                          unsigned int *dest_id)
> {
>        struct irq_cfg *cfg = data->chip_data;
>
>        if (!cpumask_intersects(mask, cpu_online_mask))
>                return -1;
>
>        if (assign_irq_vector(data->irq, data->chip_data, mask))
>                return -1;
>
> This call ^^^ will update cfg->domain with the value returned by the call to
> apic->vector_allocation_domain(). If per_cpu(cpus_in_cluster, cpu) is returned
> as cfg->domain here then all other clusters contained in the 'mask' will not
> be taken into consideration by the apic->cpu_mask_to_apicid_and() call below.
>
>        cpumask_copy(data->affinity, mask);
>
>        *dest_id = apic->cpu_mask_to_apicid_and(mask, cfg->domain);
>
> So we really need to submit all possible CPUs here ^^^ to be able finding the
> best/heaviest cluster out of the 'mask'.

ok.

>
>        return 0;
> }
>
>
>> also you may add one per cpu var like x86_cpu_to_logical_cluster_apicid.
>
> Both cpu_mask_to_apicid() and cpu_mask_to_apicid_and() take a cpumask to
> derive the apicid from. Even though we could cache the value of apicid in
> 'x86_cpu_to_logical_cluster_apicid' variable, we still would have to unset
> CPUs which are not in the requested cpumask. That means scanning through the
> cpumask etc -- exactly what the the patch does now.

ok, i got it. thanks for the explanation.

I was thinking: pick up one for cpumask that user want, and then just
use all cpus in that cluster as dest cpus.

Yinghai
