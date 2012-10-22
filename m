Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753422Ab2JVLXS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 07:23:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51660 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751969Ab2JVLXQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 07:23:16 -0400
Date: Mon, 22 Oct 2012 13:23:14 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH] KVM: x86: fix vcpu->mmio_fragments overflow
Message-ID: <20121022112314.GO29310@redhat.com>
References: <5081033C.4060503@linux.vnet.ibm.com>
 <20121022091615.GG29310@redhat.com>
 <50852972.305@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50852972.305@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 22, 2012 at 07:09:38PM +0800, Xiao Guangrong wrote:
> On 10/22/2012 05:16 PM, Gleb Natapov wrote:
> > On Fri, Oct 19, 2012 at 03:37:32PM +0800, Xiao Guangrong wrote:
> >> After commit b3356bf0dbb349 (KVM: emulator: optimize "rep ins" handling),
> >> the pieces of io data can be collected and write them to the guest memory
> >> or MMIO together.
> >>
> >> Unfortunately, kvm splits the mmio access into 8 bytes and store them to
> >> vcpu->mmio_fragments. If the guest uses "rep ins" to move large data, it
> >> will cause vcpu->mmio_fragments overflow
> >>
> >> The bug can be exposed by isapc (-M isapc):
> >>
> >> [23154.818733] general protection fault: 0000 [#1] SMP DEBUG_PAGEALLOC
> >> [ ......]
> >> [23154.858083] Call Trace:
> >> [23154.859874]  [<ffffffffa04f0e17>] kvm_get_cr8+0x1d/0x28 [kvm]
> >> [23154.861677]  [<ffffffffa04fa6d4>] kvm_arch_vcpu_ioctl_run+0xcda/0xe45 [kvm]
> >> [23154.863604]  [<ffffffffa04f5a1a>] ? kvm_arch_vcpu_load+0x17b/0x180 [kvm]
> >>
> >>
> >> Actually, we can use one mmio_fragment to store a large mmio access for the
> >> mmio access is always continuous then split it when we pass the mmio-exit-info
> >> to userspace. After that, we only need two entries to store mmio info for
> >> the cross-mmio pages access
> >>
> > I wonder can we put the data into coalesced mmio buffer instead of
> 
> If we put all mmio data into coalesced buffer, we should:
> - ensure the userspace program uses KVM_REGISTER_COALESCED_MMIO to register
>   all mmio regions.
> 
It appears to not be so.
Userspace calls kvm_flush_coalesced_mmio_buffer() after returning from
KVM_RUN which looks like this:

void kvm_flush_coalesced_mmio_buffer(void)
{
    KVMState *s = kvm_state;

    if (s->coalesced_flush_in_progress) {
        return;
    }

    s->coalesced_flush_in_progress = true;

    if (s->coalesced_mmio_ring) {
        struct kvm_coalesced_mmio_ring *ring = s->coalesced_mmio_ring;
        while (ring->first != ring->last) {
            struct kvm_coalesced_mmio *ent;

            ent = &ring->coalesced_mmio[ring->first];

            cpu_physical_memory_write(ent->phys_addr, ent->data, ent->len);
            smp_wmb();
            ring->first = (ring->first + 1) % KVM_COALESCED_MMIO_MAX;
        }
    }

    s->coalesced_flush_in_progress = false;
}

Nowhere in this function we check that MMIO region was registered with
KVM_REGISTER_COALESCED_MMIO. We do not even check that the address is
MMIO.

> - even if the MMIO region is not used by emulated-device, it also need to be
>   registered.
Same. I think writes to non registered region will be discarded.

> 
> It will breaks old version userspace program.
> 
> > exiting for each 8 bytes? Is it worth the complexity?
> 
> Simpler way is always better but i failed, so i appreciate your guys comments.
> 
Why have you failed? Exiting for each 8 bytes is infinitely better than
buffer overflow.  My question about complexity was towards theoretically
more complex code that will use coalesced MMIO buffer.

--
			Gleb.
