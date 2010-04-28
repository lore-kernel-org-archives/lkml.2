Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754554Ab0D1OUh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 10:20:37 -0400
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:28928 "EHLO
	TX2EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751521Ab0D1OUf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 10:20:35 -0400
X-SpamScore: -26
X-BigFish: VPS-26(zz1432P98dN936eM9371Pab9bhzz1202hzz6ff19hz32i2a8h87h64h)
X-Spam-TCS-SCL: 3:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L1LBU0-02-2C0-02
X-M-MSG: 
Date: Wed, 28 Apr 2010 16:20:23 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 12/22] KVM: MMU: Implement nested gva_to_gpa functions
Message-ID: <20100428142023.GE18832@amd.com>
References: <1272364712-17425-1-git-send-email-joerg.roedel@amd.com>
 <1272364712-17425-13-git-send-email-joerg.roedel@amd.com>
 <4BD6DA94.7050501@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4BD6DA94.7050501@redhat.com>
Organization: Advanced Micro Devices =?iso-8859-1?Q?GmbH?=
	=?iso-8859-1?Q?=2C_Karl-Hammerschmidt-Str=2E_34=2C_85609_Dornach_bei_M=FC?=
	=?iso-8859-1?Q?nchen=2C_Gesch=E4ftsf=FChrer=3A_Thomas_M=2E_McCoy=2C_Giuli?=
	=?iso-8859-1?Q?ano_Meroni=2C_Andrew_Bowd=2C_Sitz=3A_Dornach=2C_Gemeinde_A?=
	=?iso-8859-1?Q?schheim=2C_Landkreis_M=FCnchen=2C_Registergericht_M=FCnche?=
	=?iso-8859-1?Q?n=2C?= HRB Nr. 43632
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 28 Apr 2010 14:20:23.0804 (UTC) FILETIME=[F0F21BC0:01CAE6DD]
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 27, 2010 at 03:37:40PM +0300, Avi Kivity wrote:
> On 04/27/2010 01:38 PM, Joerg Roedel wrote:
> >This patch adds the functions to do a nested l2_gva to
> >l1_gpa page table walk.
> >
> >Signed-off-by: Joerg Roedel<joerg.roedel@amd.com>
> >---
> >  arch/x86/include/asm/kvm_host.h |    4 ++++
> >  arch/x86/kvm/mmu.c              |    8 ++++++++
> >  arch/x86/kvm/paging_tmpl.h      |   31 +++++++++++++++++++++++++++++++
> >  3 files changed, 43 insertions(+), 0 deletions(-)
> >
> >diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> >index ccdbd2f..3cbfb51 100644
> >--- a/arch/x86/include/asm/kvm_host.h
> >+++ b/arch/x86/include/asm/kvm_host.h
> >@@ -287,6 +287,10 @@ struct kvm_vcpu_arch {
> >  	bool tpr_access_reporting;
> >
> >  	struct kvm_mmu mmu;
> >+
> >+	/* Used for two dimensional paging emulation */
> >+	struct kvm_mmu nested_mmu;
> >+
> >  	/* only needed in kvm_pv_mmu_op() path, but it's hot so
> >  	 * put it here to avoid allocation */
> >  	struct kvm_pv_mmu_op_buffer mmu_op_buffer;
> >diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
> >index 4e0bfdb..8bd40b5 100644
> >--- a/arch/x86/kvm/mmu.c
> >+++ b/arch/x86/kvm/mmu.c
> >@@ -2144,6 +2144,14 @@ static gpa_t nonpaging_gva_to_gpa(struct kvm_vcpu *vcpu, gva_t vaddr,
> >  	return vaddr;
> >  }
> >
> >+static gpa_t nonpaging_gva_to_gpa_nested(struct kvm_vcpu *vcpu, gva_t vaddr,
> >+					 u32 access, u32 *error)
> >+{
> >+	if (error)
> >+		*error = 0;
> 
> Why allow error == NULL?

In the emulator there are some functions passing NULL for the error
code. In general it doesn't matter much because when we track this
information in the vcpu struct these error parameters can be removed. I
just let this outside the scope of this patchset and make that cleanup
later.

> 
> >
> >+static gpa_t FNAME(gva_to_gpa_nested)(struct kvm_vcpu *vcpu, gva_t vaddr,
> >+				      u32 access, u32 *error)
> >+{
> >+	struct guest_walker walker;
> >+	gpa_t gpa = UNMAPPED_GVA;
> >+	int r;
> >+
> >+	r = FNAME(walk_addr_nested)(&walker, vcpu, vaddr,
> >+				    !!(access&  PFERR_WRITE_MASK),
> >+				    !!(access&  PFERR_USER_MASK),
> >+				    !!(access&  PFERR_FETCH_MASK));
> 
> Those !! are unneeded.

Ok, I remove them.

	Joerg

