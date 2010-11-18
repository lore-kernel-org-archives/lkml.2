Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757498Ab0KRNJX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 08:09:23 -0500
Received: from mx1.redhat.com ([209.132.183.28]:8733 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751944Ab0KRNJW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 08:09:22 -0500
Message-ID: <4CE5257B.60206@redhat.com>
Date: Thu, 18 Nov 2010 15:09:15 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101103 Fedora/1.0-0.33.b2pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.6
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, Gleb Natapov <gleb@redhat.com>,
        Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>,
        Gregory Haskins <ghaskins@novell.com>,
        Chris Lalancette <clalance@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC] kvm: fast-path msi injection with irqfd
References: <20101117221254.GA8296@redhat.com> <20101118105741.GA31261@redhat.com> <4CE50810.3090502@redhat.com> <20101118111037.GB31261@redhat.com> <4CE51C17.4000108@redhat.com> <20101118130337.GA2254@redhat.com>
In-Reply-To: <20101118130337.GA2254@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/18/2010 03:03 PM, Michael S. Tsirkin wrote:
> >  >   int kvm_set_irq(struct kvm *kvm, int irq_source_id, u32 irq, int level);
> >  >+int kvm_set_msi(struct kvm_kernel_irq_routing_entry *irq_entry, struct kvm *kvm,
> >  >+		int irq_source_id, int level);
> >
> >  No point in the level argument for an msi specific function.
>
> This is an existing function I made non-static.
> We have per-gsi callbacks so level is required there to match.

Right.

> I could add a wrapper I guess:
>
> int kvm_set_msi(struct kvm_kernel_irq_routing_entry *irq_entry, struct kvm *kvm,
> 		int irq_source_id, int level)
> {
> 	if (!level)
> 		return -1;
> 	return kvm_send_msi(irq_entry, kvm, irq_source_id);
> }
>
> This results in less code for irqfd but more code for ioctl injection
> ... is it worth it?

IMO not.

> >
> >  Apart from these minor issues, looks good.
>
>
> Something we should consider improving is the loop over all VCPUs that
> kvm_irq_delivery_to_apic invokes.  I think that (for non-broadcast
> interrupts) it should be possible to precompute an store the CPU
> in question as part of the routing entry.

> Something for a separate patch ... comments?

Yes.  Either precompute, or compute on first use and cache.  Precompute 
is more realtime-friendly so I prefer it.

-- 
error compiling committee.c: too many arguments to function

