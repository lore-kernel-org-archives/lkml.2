Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753234Ab0DWOXQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 10:23:16 -0400
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:26421
	"EHLO VA3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752611Ab0DWOXN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 10:23:13 -0400
X-SpamScore: -18
X-BigFish: VPS-18(zz1432P98dN936eMab9bhzz1202hzz6ff19hz32i87h2a8h61h)
X-Spam-TCS-SCL: 0:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L1C2MC-01-6V0-02
X-M-MSG: 
Date: Fri, 23 Apr 2010 16:22:58 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: Alexander Graf <agraf@suse.de>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/8] KVM: SVM: Fix nested nmi handling
Message-ID: <20100423142258.GG31537@amd.com>
References: <1271932394-13968-1-git-send-email-joerg.roedel@amd.com>
 <1271932394-13968-2-git-send-email-joerg.roedel@amd.com>
 <622FCBB5-826D-4392-A521-7E395507398B@suse.de>
 <20100423141355.GD31537@amd.com>
 <85D89C34-806C-4376-89BA-5BFD413F5396@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <85D89C34-806C-4376-89BA-5BFD413F5396@suse.de>
Organization: Advanced Micro Devices =?iso-8859-1?Q?GmbH?=
	=?iso-8859-1?Q?=2C_Karl-Hammerschmidt-Str=2E_34=2C_85609_Dornach_bei_M=FC?=
	=?iso-8859-1?Q?nchen=2C_Gesch=E4ftsf=FChrer=3A_Thomas_M=2E_McCoy=2C_Giuli?=
	=?iso-8859-1?Q?ano_Meroni=2C_Andrew_Bowd=2C_Sitz=3A_Dornach=2C_Gemeinde_A?=
	=?iso-8859-1?Q?schheim=2C_Landkreis_M=FCnchen=2C_Registergericht_M=FCnche?=
	=?iso-8859-1?Q?n=2C?= HRB Nr. 43632
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 23 Apr 2010 14:22:58.0633 (UTC) FILETIME=[792A6390:01CAE2F0]
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 23, 2010 at 04:19:40PM +0200, Alexander Graf wrote:
> 
> On 23.04.2010, at 16:13, Joerg Roedel wrote:
> 
> > On Fri, Apr 23, 2010 at 03:46:07PM +0200, Alexander Graf wrote:
> >> 
> >> On 22.04.2010, at 12:33, Joerg Roedel wrote:
> >> 
> >>> The patch introducing nested nmi handling had a bug. The
> >>> check does not belong to enable_nmi_window but must be in
> >>> nmi_allowed. This patch fixes this.
> >>> 
> >>> Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
> >>> ---
> >>> arch/x86/kvm/svm.c |   16 +++++++++-------
> >>> 1 files changed, 9 insertions(+), 7 deletions(-)
> >>> 
> >>> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> >>> index ab78eb8..ec20584 100644
> >>> --- a/arch/x86/kvm/svm.c
> >>> +++ b/arch/x86/kvm/svm.c
> >>> @@ -2771,8 +2771,12 @@ static int svm_nmi_allowed(struct kvm_vcpu *vcpu)
> >>> {
> >>> 	struct vcpu_svm *svm = to_svm(vcpu);
> >>> 	struct vmcb *vmcb = svm->vmcb;
> >>> -	return !(vmcb->control.int_state & SVM_INTERRUPT_SHADOW_MASK) &&
> >>> -		!(svm->vcpu.arch.hflags & HF_NMI_MASK);
> >>> +	int ret;
> >>> +	ret = !(vmcb->control.int_state & SVM_INTERRUPT_SHADOW_MASK) &&
> >>> +	      !(svm->vcpu.arch.hflags & HF_NMI_MASK);
> >>> +	ret = ret && gif_set(svm) && nested_svm_nmi(svm);
> >>> +
> >>> +	return ret;
> >>> }
> >>> 
> >>> static bool svm_get_nmi_mask(struct kvm_vcpu *vcpu)
> >>> @@ -2841,11 +2845,9 @@ static void enable_nmi_window(struct kvm_vcpu *vcpu)
> >>> 	 * Something prevents NMI from been injected. Single step over possible
> >>> 	 * problem (IRET or exception injection or interrupt shadow)
> >>> 	 */
> >>> -	if (gif_set(svm) && nested_svm_nmi(svm)) {
> >>> -		svm->nmi_singlestep = true;
> >>> -		svm->vmcb->save.rflags |= (X86_EFLAGS_TF | X86_EFLAGS_RF);
> >>> -		update_db_intercept(vcpu);
> >>> -	}
> >>> +	svm->nmi_singlestep = true;
> >>> +	svm->vmcb->save.rflags |= (X86_EFLAGS_TF | X86_EFLAGS_RF);
> >>> +	update_db_intercept(vcpu);
> >> 
> >> So we're always messing with the nested guest state when the host
> >> wants to inject an nmi into the l1 guest? Is that safe?
> > 
> > Why not? We can't inject an NMI directly into L2 if the nested
> > hypervisor intercepts it.
> 
> So where did the code go that does the #vmexit in case the nested
> hypervisor does intercept it? It used to be nested_svm_nmi(), right?

No, nested_svm_nmi runs in atomic context where we can't emulate a
vmexit. We set exit_required and emulate the vmexit later.

	Joerg


