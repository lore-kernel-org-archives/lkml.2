Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754583Ab1FHIWy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 04:22:54 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50636 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752406Ab1FHIWw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 04:22:52 -0400
Subject: Re: [PATCH 04/15] KVM: MMU: cache mmio info on page fault path
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
From: Alexander Graf <agraf@suse.de>
In-Reply-To: <4DEE20EE.7060000@cn.fujitsu.com>
Date: Wed, 8 Jun 2011 10:22:47 +0200
Cc: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <4FA0E9B8-FBB6-49BD-916C-239599136604@suse.de>
References: <4DEE205E.8000601@cn.fujitsu.com> <4DEE20EE.7060000@cn.fujitsu.com>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
X-Mailer: Apple Mail (2.1084)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 07.06.2011, at 15:00, Xiao Guangrong wrote:

> If the page fault is caused by mmio, we can cache the mmio info, later, we do
> not need to walk guest page table and quickly know it is a mmio fault while we
> emulate the mmio instruction
> 
> Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
> ---
> arch/x86/include/asm/kvm_host.h |    5 +++
> arch/x86/kvm/mmu.c              |   21 +++++----------
> arch/x86/kvm/mmu.h              |   23 +++++++++++++++++
> arch/x86/kvm/paging_tmpl.h      |   21 ++++++++++-----
> arch/x86/kvm/x86.c              |   52 ++++++++++++++++++++++++++++++--------
> arch/x86/kvm/x86.h              |   36 +++++++++++++++++++++++++++
> 6 files changed, 126 insertions(+), 32 deletions(-)
> 
> 

[...]

> +static int vcpu_gva_to_gpa(struct kvm_vcpu *vcpu, unsigned long gva,
> +			   gpa_t *gpa, struct x86_exception *exception,
> +			   bool write)
> +{
> +	u32 access = (kvm_x86_ops->get_cpl(vcpu) == 3) ? PFERR_USER_MASK : 0;
> +
> +	if (vcpu_match_mmio_gva(vcpu, gva) &&
> +	      check_write_user_access(vcpu, write, access,
> +	      vcpu->arch.access)) {
> +		*gpa = vcpu->arch.mmio_gfn << PAGE_SHIFT |
> +					(gva & (PAGE_SIZE - 1));
> +		return 1;

Hrm. Let me try to understand what you're doing.

Whenever a guest issues an MMIO, it triggers an #NPF or #PF and then we walk either the NPT or the guest PT to resolve the GPA to the fault and send off an MMIO.
Within that path, you remember the GVA->GPA mapping for the last MMIO request. If the next MMIO request is on the same GVA and kernel/user permissions still apply, you simply bypass the resolution. So far so good.

Now, what happens when the GVA is not identical to the GVA it was before? It's probably a purely theoretic case, but imagine the following:

  1) guest issues MMIO on GVA 0x1000 (GPA 0x1000)
  2) guest remaps page 0x1000 to GPA 0x2000
  3) guest issues MMIO on GVA 0x1000

That would break with your current implementation, right? It sounds pretty theoretic, but imagine the following:

  1) guest user space 1 maps MMIO region A to 0x1000
  2) guest user space 2 maps MMIO region B to 0x1000
  3) guest user space 1 issues MMIO on 0x1000
  4) context switch; going to user space 2
  5) user space 2 issues MMIO on 0x1000

That case could at least be identified by also comparing the guest's cr3 value during this hack. And considering things like UIO or microkernels, it's not too unlikely :).


Alex

