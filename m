Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756116Ab1BURRY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 12:17:24 -0500
Received: from db3ehsobe005.messaging.microsoft.com ([213.199.154.143]:27635
	"EHLO DB3EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755911Ab1BURRW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 12:17:22 -0500
X-SpamScore: -36
X-BigFish: VPS-36(zzbb2dK1432N98dN4015L9371Pzz1202hzz8275bh15d4Rz32i637h668h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-FB-SS: 0,
X-WSS-ID: 0LGZ9CN-02-0EZ-02
X-M-MSG: 
Date: Mon, 21 Feb 2011 18:17:13 +0100
From: "Roedel, Joerg" <Joerg.Roedel@amd.com>
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Zachary Amsden <zamsden@redhat.com>
Subject: Re: [PATCH 6/6] KVM: X86: Implement userspace interface to set
 virtual_tsc_khz
Message-ID: <20110221171712.GC16508@amd.com>
References: <1297272584-22689-1-git-send-email-joerg.roedel@amd.com>
 <1297272584-22689-7-git-send-email-joerg.roedel@amd.com>
 <4D57F4CE.2090804@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4D57F4CE.2090804@redhat.com>
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

On Sun, Feb 13, 2011 at 10:12:14AM -0500, Avi Kivity wrote:
> On 02/09/2011 07:29 PM, Joerg Roedel wrote:
> > This patch implements two new vm-ioctls to get and set the
> > virtual_tsc_khz if the machine supports tsc-scaling. Setting
> > the tsc-frequency is only possible before userspace creates
> > any vcpu.
> >
> > Signed-off-by: Joerg Roedel<joerg.roedel@amd.com>
> > ---
> >   arch/x86/include/asm/kvm_host.h |    1 +
> >   arch/x86/kvm/svm.c              |    3 +++
> >   arch/x86/kvm/x86.c              |   38 ++++++++++++++++++++++++++++++++++++++
> >   include/linux/kvm.h             |    4 ++++
> >   4 files changed, 46 insertions(+), 0 deletions(-)
> >
> 
> Documentation/kvm/api.txt +++++++++++++
> 
> > @@ -633,6 +633,7 @@ int kvm_pv_mmu_op(struct kvm_vcpu *vcpu, unsigned long bytes,
> >   u8 kvm_get_guest_memory_type(struct kvm_vcpu *vcpu, gfn_t gfn);
> >
> >   extern bool tdp_enabled;
> > +extern int kvm_has_tsc_control;
> 
> bool
> 
> 
> > +	case KVM_SET_TSC_KHZ: {
> > +		u32 user_tsc_khz;
> > +
> > +		if (!kvm_has_tsc_control)
> > +			break;
> > +
> > +		/*
> > +		 * We force the tsc frequency to be set before any
> > +		 * vcpu is created
> > +		 */
> > +		if (atomic_read(&kvm->online_vcpus)>  0)
> > +			goto out;
> 
> What if a vcpu is created here?  No locking AFAICS.
> 
> > +
> > +		user_tsc_khz = arg;
> > +
> > +		kvm_arch_set_tsc_khz(kvm, user_tsc_khz);
> > +
> 
> Error check for impossible values (0, values the tsc multiplier can't 
> reach)?
> 
> > +		r = 0;
> > +		goto out;
> > +	}
> > +	case KVM_GET_TSC_KHZ: {
> > +
> > +		if (!kvm_has_tsc_control)
> > +			break;
> > +
> > +		r = -EFAULT;
> > +		if (copy_to_user(argp,&kvm->arch.virtual_tsc_khz, sizeof(__u32)))
> > +			goto out;
> 
> Should be the return value, no?
> 
> > +
> > +		r = 0;
> > +		goto out;
> > +	}
> >
> >   	default:
> >   		;
> >
> >
> > @@ -677,6 +678,9 @@ struct kvm_clock_data {
> >   #define KVM_SET_PIT2              _IOW(KVMIO,  0xa0, struct kvm_pit_state2)
> >   /* Available with KVM_CAP_PPC_GET_PVINFO */
> >   #define KVM_PPC_GET_PVINFO	  _IOW(KVMIO,  0xa1, struct kvm_ppc_pvinfo)
> > +/* Available with KVM_CAP_TSC_CONTROL */
> > +#define KVM_SET_TSC_KHZ           _IOW(KVMIO,  0xa2, __u32)
> > +#define KVM_GET_TSC_KHZ           _IOR(KVMIO,  0xa3, __u32)
> >   
> 
> _IO() - use arg or return value
> _IOW/_IOR - copy_to/from_user()
> 
> pick one, but don't mix.

Thanks, I'll fix these issued in the next version.

Regards,

	Joerg

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

