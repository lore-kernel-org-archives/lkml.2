Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753243Ab0G1Jhx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 05:37:53 -0400
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:49301 "EHLO
	TX2EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750876Ab0G1Jhv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 05:37:51 -0400
X-SpamScore: -34
X-BigFish: VPS-34(zz1432N98dN936eM9371Pzz1202hzz15d4Rz32i87h2a8h43h61h)
X-Spam-TCS-SCL: 0:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L69H9K-01-5PF-02
X-M-MSG: 
Date: Wed, 28 Jul 2010 11:37:08 +0200
From: "Roedel, Joerg" <Joerg.Roedel@amd.com>
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] KVM: SVM: Emulate next_rip svm feature
Message-ID: <20100728093708.GD26098@amd.com>
References: <1280247261-19115-1-git-send-email-joerg.roedel@amd.com>
 <1280247261-19115-3-git-send-email-joerg.roedel@amd.com>
 <4C4F2643.8080507@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4C4F2643.8080507@redhat.com>
Organization: Advanced Micro Devices =?iso-8859-1?Q?GmbH?=
	=?iso-8859-1?Q?=2C_Karl-Hammerschmidt-Str=2E_34=2C_85609_Dornach_bei_M=FC?=
	=?iso-8859-1?Q?nchen=2C_Gesch=E4ftsf=FChrer=3A_Thomas_M=2E_McCoy=2C_Giuli?=
	=?iso-8859-1?Q?ano_Meroni=2C_Andrew_Bowd=2C_Sitz=3A_Dornach=2C_Gemeinde_A?=
	=?iso-8859-1?Q?schheim=2C_Landkreis_M=FCnchen=2C_Registergericht_M=FCnche?=
	=?iso-8859-1?Q?n=2C?= HRB Nr. 43632
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 27, 2010 at 02:32:35PM -0400, Avi Kivity wrote:
>   On 07/27/2010 07:14 PM, Joerg Roedel wrote:
> > This patch implements the emulations of the svm next_rip
> > feature in the nested svm implementation in kvm.
> >
> > Signed-off-by: Joerg Roedel<joerg.roedel@amd.com>
> > ---
> >   arch/x86/kvm/svm.c |    8 +++++++-
> >   1 files changed, 7 insertions(+), 1 deletions(-)
> >
> > diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> > index 7d10f2c..b44c9cc 100644
> > --- a/arch/x86/kvm/svm.c
> > +++ b/arch/x86/kvm/svm.c
> > @@ -1919,6 +1919,7 @@ static int nested_svm_vmexit(struct vcpu_svm *svm)
> >   	nested_vmcb->control.exit_info_2       = vmcb->control.exit_info_2;
> >   	nested_vmcb->control.exit_int_info     = vmcb->control.exit_int_info;
> >   	nested_vmcb->control.exit_int_info_err = vmcb->control.exit_int_info_err;
> > +	nested_vmcb->control.next_rip          = vmcb->control.next_rip;
> >
> 
> Can it be really this simple?  Suppose we emulate a nested guest 
> instruction just before vmexit, doesn't that invalidate 
> vmcb->control.next_rip?  Can that happen?

Good point. I looked again into it. The documentation states:

	The next sequential instruction pointer (nRIP) is saved in
	the guest VMCB control area at location C8h on all #VMEXITs that
	are due to instruction intercepts, as defined in Section 15.8 on
	page 378, as well as MSR and IOIO intercepts and exceptions
	caused by the INT3, INTO, and BOUND instructions. For all other
	intercepts, nRIP is reset to zero.

There are a few intercepts that may need injection when running nested
immediatly after an instruction emulation on the host side:
	
	INTR, NMI
	#PF, #GP, ...

All these instructions do not provide a valid next_rip on #vmexit so we
should be save here. The other way around, copying back a next_rip
pointer when there should be none, should also not happen as far as I
see it. The next_rip is only set for instruction intercepts which are
either handled on the host side or reinjected directly into the L1
hypervisor.
When you don't see a failing case either, I think we are save with this
simple implementation.

	Joerg

-- 
Joerg Roedel - AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

