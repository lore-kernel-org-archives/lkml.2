Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755691Ab0D0NUv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 09:20:51 -0400
Received: from va3ehsobe002.messaging.microsoft.com ([216.32.180.12]:43601
	"EHLO VA3EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755554Ab0D0NUn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 09:20:43 -0400
X-SpamScore: -32
X-BigFish: VPS-32(zz1432P98dN936eM179dN9371Pab9bhzz1202hzz6ff19hz32i87h2a8h61h)
X-Spam-TCS-SCL: 0:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L1JEE7-02-7M2-02
X-M-MSG: 
Date: Tue, 27 Apr 2010 15:20:31 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 15/22] KVM: MMU: Introduce kvm_read_guest_page_x86()
Message-ID: <20100427132030.GH11097@amd.com>
References: <1272364712-17425-1-git-send-email-joerg.roedel@amd.com>
 <1272364712-17425-16-git-send-email-joerg.roedel@amd.com>
 <4BD6DE15.8070409@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4BD6DE15.8070409@redhat.com>
Organization: Advanced Micro Devices =?iso-8859-1?Q?GmbH?=
	=?iso-8859-1?Q?=2C_Karl-Hammerschmidt-Str=2E_34=2C_85609_Dornach_bei_M=FC?=
	=?iso-8859-1?Q?nchen=2C_Gesch=E4ftsf=FChrer=3A_Thomas_M=2E_McCoy=2C_Giuli?=
	=?iso-8859-1?Q?ano_Meroni=2C_Andrew_Bowd=2C_Sitz=3A_Dornach=2C_Gemeinde_A?=
	=?iso-8859-1?Q?schheim=2C_Landkreis_M=FCnchen=2C_Registergericht_M=FCnche?=
	=?iso-8859-1?Q?n=2C?= HRB Nr. 43632
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 27 Apr 2010 13:20:31.0389 (UTC) FILETIME=[694954D0:01CAE60C]
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 27, 2010 at 03:52:37PM +0300, Avi Kivity wrote:
> On 04/27/2010 01:38 PM, Joerg Roedel wrote:
> >This patch introduces the kvm_read_guest_page_x86 function
> >which reads from the physical memory of the guest. If the
> >guest is running in guest-mode itself with nested paging
> >enabled it will read from the guest's guest physical memory
> >instead.
> >The patch also changes changes the code to use this function
> >where it is necessary.
> >
> >
> >
> >diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> >index 7851bbc..d9dfc8c 100644
> >--- a/arch/x86/include/asm/kvm_host.h
> >+++ b/arch/x86/include/asm/kvm_host.h
> >@@ -254,6 +254,13 @@ struct kvm_mmu {
> >  	union kvm_mmu_page_role base_role;
> >  	bool direct_map;
> >
> >+	/*
> >+	 * If true the mmu runs in two-level mode.
> >+	 * vcpu->arch.nested_mmu needs to contain meaningful values in
> >+	 * this case.
> >+	 */
> >+	bool nested;
> >+
> 
> struct mmu_context *active_mmu? (in vcpu->arch)

Hmm, difficult since both mmu's are active in the npt-npt case. The
arch.mmu struct contains mostly the l1 paging state initialized for
shadow paging and different set_cr3/get_cr3/inject_page_fault functions.
This keeps the changes to the mmu small and optimize for the common case
(a nested npt fault).
The arch.nested_mmu contains the l2 paging mode and is only used for
nested gva_to_gpa translations (thats the reason it is only partially
initialized).

> >  	u64 *pae_root;
> >  	u64 rsvd_bits_mask[2][4];
> >  };
> >diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> >index 558d995..317ad26 100644
> >--- a/arch/x86/kvm/x86.c
> >+++ b/arch/x86/kvm/x86.c
> >@@ -379,6 +379,20 @@ int kvm_read_guest_page_tdp(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
> >  }
> >  EXPORT_SYMBOL_GPL(kvm_read_guest_page_tdp);
> >
> >+int kvm_read_guest_page_x86(struct kvm_vcpu *vcpu, gfn_t gfn,
> >+			    void *data, int offset, int len, u32 *error)
> >+{
> >+	struct kvm_mmu *mmu;
> >+
> >+	if (vcpu->arch.mmu.nested)
> >+		mmu =&vcpu->arch.nested_mmu;
> >+	else
> >+		mmu =&vcpu->arch.mmu;
> >+
> >+	return kvm_read_guest_page_tdp(vcpu, mmu, gfn, data, offset, len,
> >+				       error);
> >+}
> 
> This is really not x86 specific (though the implementation certainly
> is).  s390 will have exactly the same need when it gets nested virt.
> I think this can be folded into
> kvm_read_guest_page_tdp()/kvm_read_nested_guest_page().

For the generic walk_addr I need a version of that function that takes
an mmu_context parameter. Thats the reason I made two functions.
The function (or at least its semantic) is useful for !x86 too, thats
right. But it currently can't be made generic because the MMU
implementation is architecture specific. Do you suggest to give it a
more generic name so we can move it later?

	Joerg


