Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755516Ab0D0NLK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 09:11:10 -0400
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:40578 "EHLO
	TX2EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752579Ab0D0NLG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 09:11:06 -0400
X-SpamScore: -20
X-BigFish: VPS-20(z1857rz1432P98dN936eM4015L9371Pab9bhzz1202hzz6ff19hz32i2a8h87h43h61h)
X-Spam-TCS-SCL: 0:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L1JDY1-02-6ZT-02
X-M-MSG: 
Date: Tue, 27 Apr 2010 15:10:48 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 13/22] KVM: X86: Add kvm_read_guest_page_tdp function
Message-ID: <20100427131047.GG11097@amd.com>
References: <1272364712-17425-1-git-send-email-joerg.roedel@amd.com>
 <1272364712-17425-14-git-send-email-joerg.roedel@amd.com>
 <4BD6DBB3.7050908@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4BD6DBB3.7050908@redhat.com>
Organization: Advanced Micro Devices =?iso-8859-1?Q?GmbH?=
	=?iso-8859-1?Q?=2C_Karl-Hammerschmidt-Str=2E_34=2C_85609_Dornach_bei_M=FC?=
	=?iso-8859-1?Q?nchen=2C_Gesch=E4ftsf=FChrer=3A_Thomas_M=2E_McCoy=2C_Giuli?=
	=?iso-8859-1?Q?ano_Meroni=2C_Andrew_Bowd=2C_Sitz=3A_Dornach=2C_Gemeinde_A?=
	=?iso-8859-1?Q?schheim=2C_Landkreis_M=FCnchen=2C_Registergericht_M=FCnche?=
	=?iso-8859-1?Q?n=2C?= HRB Nr. 43632
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 27 Apr 2010 13:10:48.0309 (UTC) FILETIME=[0DBE6250:01CAE60B]
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 27, 2010 at 03:42:27PM +0300, Avi Kivity wrote:
> On 04/27/2010 01:38 PM, Joerg Roedel wrote:
> >This patch adds a function which can read from the guests
> >physical memory or from the guest's guest physical memory.
> >This will be used in the two-dimensional page table walker.
> >
> >Signed-off-by: Joerg Roedel<joerg.roedel@amd.com>
> >---
> >  arch/x86/include/asm/kvm_host.h |    3 +++
> >  arch/x86/kvm/x86.c              |   24 ++++++++++++++++++++++++
> >  2 files changed, 27 insertions(+), 0 deletions(-)
> >
> >diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> >index 3cbfb51..7851bbc 100644
> >--- a/arch/x86/include/asm/kvm_host.h
> >+++ b/arch/x86/include/asm/kvm_host.h
> >@@ -635,6 +635,9 @@ void kvm_requeue_exception(struct kvm_vcpu *vcpu, unsigned nr);
> >  void kvm_requeue_exception_e(struct kvm_vcpu *vcpu, unsigned nr, u32 error_code);
> >  void kvm_inject_page_fault(struct kvm_vcpu *vcpu, unsigned long cr2,
> >  			   u32 error_code);
> >+int kvm_read_guest_page_tdp(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
> >+			    gfn_t gfn, void *data, int offset, int len,
> >+			    u32 *error);
> >  bool kvm_require_cpl(struct kvm_vcpu *vcpu, int required_cpl);
> >
> >  int kvm_pic_set_irq(void *opaque, int irq, int level);
> >diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> >index 6b2ce1d..558d995 100644
> >--- a/arch/x86/kvm/x86.c
> >+++ b/arch/x86/kvm/x86.c
> >@@ -356,6 +356,30 @@ bool kvm_require_cpl(struct kvm_vcpu *vcpu, int required_cpl)
> >  EXPORT_SYMBOL_GPL(kvm_require_cpl);
> >
> >  /*
> >+ * This function will be used to read from the physical memory of the currently
> >+ * running guest. The difference to kvm_read_guest_page ist that this function
> >+ * can read from guest physical or from the guest's guest physical memory.
> >+ */
> 
> s/ist/is/

This is a common typo error I make ;) I'll fix it.

> >+int kvm_read_guest_page_tdp(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
> >+			    gfn_t gfn, void *data, int offset, int len,
> >+			    u32 *error)
> 
> Naming: I see 'tdp' as a host property, and this is valid whether
> tdp is enabled or not.  Suggest calling it
> kvm_read_nested_guest_page().
> 
> Following mmu.txt, the parameter would be ngfn, not gfn.
> 
> >+{
> >+	gfn_t real_gfn;
> >+	gpa_t gpa;
> >+
> >+	*error   = 0;
> >+	gpa      = gfn<<  PAGE_SHIFT;
> >+	real_gfn = mmu->translate_gpa(vcpu, gpa, error);
> 
> Overflow: sizeof(gpa) > sizeof(gfn).
> 
> >+	if (real_gfn == UNMAPPED_GVA)
> >+		return -EFAULT;
> >+
> >+	real_gfn>>= PAGE_SHIFT;
> 
> gpa_to_gfn().

I'll fix the overflow errors and send an updated patch.

Thanks,
	Joerg

