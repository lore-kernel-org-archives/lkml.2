Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932968Ab1AMPvr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 10:51:47 -0500
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:22736
	"EHLO VA3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756747Ab1AMPvn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 10:51:43 -0500
X-SpamScore: -32
X-BigFish: VPS-32(zzbb2dK1432N98dN9371Pzz1202hzz8275bh8275dh15d4Rz32i637h668h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LEYXDS-01-PR5-02
X-M-MSG: 
Date: Thu, 13 Jan 2011 16:51:29 +0100
From: "Roedel, Joerg" <Joerg.Roedel@amd.com>
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@kernel.org" <stable@kernel.org>
Subject: Re: [PATCH 1/2] KVM: SVM: Fix NMI path when NMI happens in guest
 mode
Message-ID: <20110113155129.GA23914@amd.com>
References: <1294932178-26866-1-git-send-email-joerg.roedel@amd.com>
 <1294932178-26866-2-git-send-email-joerg.roedel@amd.com>
 <4D2F1D49.8070807@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4D2F1D49.8070807@redhat.com>
Organization: Advanced Micro Devices =?iso-8859-1?Q?GmbH?=
	=?iso-8859-1?Q?=2C_Karl-Hammerschmidt-Str=2E_34=2C_85609_Dornach_bei_M=FC?=
	=?iso-8859-1?Q?nchen=2C_Gesch=E4ftsf=FChrer=3A_Thomas_M=2E_McCoy=2C_Giuli?=
	=?iso-8859-1?Q?ano_Meroni=2C_Andrew_Bowd=2C_Sitz=3A_Dornach=2C_Gemeinde_A?=
	=?iso-8859-1?Q?schheim=2C_Landkreis_M=FCnchen=2C_Registergericht_M=FCnche?=
	=?iso-8859-1?Q?n=2C?= HRB Nr. 43632
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 13, 2011 at 10:42:01AM -0500, Avi Kivity wrote:
> On 01/13/2011 05:22 PM, Joerg Roedel wrote:
> > The vmexit path on SVM needs to restore the KERNEL_GS_BASE
> > MSR in order to savely execute the NMI handler. Otherwise a
> > pending NMI can occur after the STGI instruction and crash
> > the machine.
> > This makes it impossible to run perf and kvm in parallel on
> > an AMD machine in a stable way.
> >
> > Cc: stable@kernel.org
> > Signed-off-by: Joerg Roedel<joerg.roedel@amd.com>
> > ---
> >   arch/x86/kvm/svm.c |    1 +
> >   1 files changed, 1 insertions(+), 0 deletions(-)
> >
> > diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> > index 25bd1bc..8b9bc72 100644
> > --- a/arch/x86/kvm/svm.c
> > +++ b/arch/x86/kvm/svm.c
> > @@ -3637,6 +3637,7 @@ static void svm_vcpu_run(struct kvm_vcpu *vcpu)
> >
> >   #ifdef CONFIG_X86_64
> >   	wrmsrl(MSR_GS_BASE, svm->host.gs_base);
> > +	wrmsrl(MSR_KERNEL_GS_BASE, current->thread.gs);
> >   #else
> >   	loadsegment(fs, svm->host.fs);
> >   #endif
> 
> Why would an NMI crash if MSR_KERNEL_GS_BASE is bad?
> 
> I see save_paranoid depends on MSR_GS_BASE (specifically its sign, which 
> is bad for the new instructions that allow userspace to write gsbase), 
> but not on MSR_KERNEL_GS_BASE.

Thats a good question. I have not idea. I spent some time trying to
figure this out (after I found out that wrong KERNEL_GS_BASE was the
cause of the crashes) but had no luck.

This also doesn't happen every time an NMI is delivered in svm_vcpu_run.
Sometimes it runs perfectly in parallel for a few minutues before the
machine triple-faults.

I also had a look at entry_64.S. The save_paranoid could not be the
cause because MSR_GS_BASE is already negative at this point. But the
re-schedule condition check at the end of the NMI handler code could
also not be the cause because the NMI happens while preemption (and
interrupts) are disabled (a re-schedule should also trigger
preempt-notifiers and restore KERNEL_GS_BASE).

	Joerg

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

