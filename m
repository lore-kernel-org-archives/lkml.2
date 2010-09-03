Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757951Ab0ICMWl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 08:22:41 -0400
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:46891 "EHLO
	TX2EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751850Ab0ICMWj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 08:22:39 -0400
X-SpamScore: -21
X-BigFish: VS-21(zz1432N98dNzz1202hzz8275bh15d4Rz32i87h2a8h)
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L867NS-01-AGG-02
X-M-MSG: 
Date: Fri, 3 Sep 2010 14:21:40 +0200
From: "Roedel, Joerg" <Joerg.Roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] KVM: SVM: Clean up rip handling in vmrun emulation
Message-ID: <20100903122140.GG1964@amd.com>
References: <1283441387-7378-1-git-send-email-joerg.roedel@amd.com>
 <1283441387-7378-4-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1283441387-7378-4-git-send-email-joerg.roedel@amd.com>
Organization: Advanced Micro Devices =?iso-8859-1?Q?GmbH?=
	=?iso-8859-1?Q?=2C_Karl-Hammerschmidt-Str=2E_34=2C_85609_Dornach_bei_M=FC?=
	=?iso-8859-1?Q?nchen=2C_Gesch=E4ftsf=FChrer=3A_Thomas_M=2E_McCoy=2C_Giuli?=
	=?iso-8859-1?Q?ano_Meroni=2C_Andrew_Bowd=2C_Sitz=3A_Dornach=2C_Gemeinde_A?=
	=?iso-8859-1?Q?schheim=2C_Landkreis_M=FCnchen=2C_Registergericht_M=FCnche?=
	=?iso-8859-1?Q?n=2C?= HRB Nr. 43632
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 02, 2010 at 11:29:47AM -0400, Joerg Roedel wrote:
> This patch changes the rip handling in the vmrun emulation
> path from using next_rip to the generic kvm register access
> functions.
> 
> Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
> ---
>  arch/x86/kvm/svm.c |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> index ecd4e58..1643f30 100644
> --- a/arch/x86/kvm/svm.c
> +++ b/arch/x86/kvm/svm.c
> @@ -2069,7 +2069,7 @@ static bool nested_svm_vmrun(struct vcpu_svm *svm)
>  		return false;
>  	}
>  
> -	trace_kvm_nested_vmrun(svm->vmcb->save.rip - 3, vmcb_gpa,
> +	trace_kvm_nested_vmrun(svm->vmcb->save.rip, vmcb_gpa,
>  			       nested_vmcb->save.rip,
>  			       nested_vmcb->control.int_ctl,
>  			       nested_vmcb->control.event_inj,
> @@ -2270,8 +2270,8 @@ static int vmrun_interception(struct vcpu_svm *svm)
>  	if (nested_svm_check_permissions(svm))
>  		return 1;
>  
> -	svm->next_rip = kvm_rip_read(&svm->vcpu) + 3;
> -	skip_emulated_instruction(&svm->vcpu);
> +	/* Save rip after vmrun instruction */
> +	kvm_rip_write(&svm->vcpu, kvm_rip_read(&svm->vcpu) + 3);
>  
>  	if (!nested_svm_vmrun(svm))
>  		return 1;

Argh, in my interactive commit I forgot one part of this patch. Please
apply the attached one instead.


>From 42450df2b72c23538d61616834dbdf1b53deafd7 Mon Sep 17 00:00:00 2001
From: Joerg Roedel <joerg.roedel@amd.com>
Date: Thu, 2 Sep 2010 17:12:18 +0200
Subject: [PATCH 3/3] KVM: SVM: Clean up rip handling in vmrun emulation

This patch changes the rip handling in the vmrun emulation
path from using next_rip to the generic kvm register access
functions.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kvm/svm.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index ecd4e58..6808f64 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -2069,7 +2069,7 @@ static bool nested_svm_vmrun(struct vcpu_svm *svm)
 		return false;
 	}
 
-	trace_kvm_nested_vmrun(svm->vmcb->save.rip - 3, vmcb_gpa,
+	trace_kvm_nested_vmrun(svm->vmcb->save.rip, vmcb_gpa,
 			       nested_vmcb->save.rip,
 			       nested_vmcb->control.int_ctl,
 			       nested_vmcb->control.event_inj,
@@ -2098,7 +2098,7 @@ static bool nested_svm_vmrun(struct vcpu_svm *svm)
 	hsave->save.cr0    = kvm_read_cr0(&svm->vcpu);
 	hsave->save.cr4    = svm->vcpu.arch.cr4;
 	hsave->save.rflags = vmcb->save.rflags;
-	hsave->save.rip    = svm->next_rip;
+	hsave->save.rip    = kvm_rip_read(&svm->vcpu);
 	hsave->save.rsp    = vmcb->save.rsp;
 	hsave->save.rax    = vmcb->save.rax;
 	if (npt_enabled)
@@ -2270,8 +2270,8 @@ static int vmrun_interception(struct vcpu_svm *svm)
 	if (nested_svm_check_permissions(svm))
 		return 1;
 
-	svm->next_rip = kvm_rip_read(&svm->vcpu) + 3;
-	skip_emulated_instruction(&svm->vcpu);
+	/* Save rip after vmrun instruction */
+	kvm_rip_write(&svm->vcpu, kvm_rip_read(&svm->vcpu) + 3);
 
 	if (!nested_svm_vmrun(svm))
 		return 1;
-- 
1.7.0.4


-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

