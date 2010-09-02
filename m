Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755977Ab0IBQdm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 12:33:42 -0400
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:57993 "EHLO
	TX2EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755917Ab0IBQdk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 12:33:40 -0400
X-SpamScore: -36
X-BigFish: VS-36(zzbb2dK1432N98dN4015L9371Pzz1202hzz15d4Rz32i87h2a8h61h)
X-Spam-TCS-SCL: 0:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L84OLN-02-CN7-02
X-M-MSG: 
Date: Thu, 2 Sep 2010 18:32:20 +0200
From: "Roedel, Joerg" <Joerg.Roedel@amd.com>
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] KVM: MMU: Fix 32 bit legacy paging with NPT
Message-ID: <20100902163220.GE1964@amd.com>
References: <1283441387-7378-1-git-send-email-joerg.roedel@amd.com>
 <1283441387-7378-2-git-send-email-joerg.roedel@amd.com>
 <4C7FC91A.5030305@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4C7FC91A.5030305@redhat.com>
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

On Thu, Sep 02, 2010 at 11:56:10AM -0400, Avi Kivity wrote:
>   On 09/02/2010 06:29 PM, Joerg Roedel wrote:
> > This patch fixes 32 bit legacy paging with NPT enabled. The
> > mmu_check_root call on the top-level of the loop causes
> > root_gfn to take values (in the tdp_enabled path) which are
> > outside of guest memory. So the mmu_check_root call fails at
> > some point in the loop interation causing the guest to
> > tiple-fault.
> > This patch changes the mmu_check_root calls to the places
> > where they are really necessary. As a side-effect it
> > introduces a check for the root of a pae page table too.
> >
> >
> > @@ -2387,6 +2387,10 @@ static int mmu_alloc_roots(struct kvm_vcpu *vcpu)
> >   		return 0;
> >   	}
> >   	direct = !is_paging(vcpu);
> > +
> > +	if (mmu_check_root(vcpu, root_gfn))
> > +		return 1;
> > +
> >   	for (i = 0; i<  4; ++i) {
> >   		hpa_t root = vcpu->arch.mmu.pae_root[i];
> >
> > @@ -2398,10 +2402,10 @@ static int mmu_alloc_roots(struct kvm_vcpu *vcpu)
> >   				continue;
> >   			}
> >   			root_gfn = pdptr>>  PAGE_SHIFT;
> > +			if (mmu_check_root(vcpu, root_gfn))
> > +				return 1;
> >   		} else if (vcpu->arch.mmu.root_level == 0)
> >   			root_gfn = 0;
> > -		if (mmu_check_root(vcpu, root_gfn))
> > -			return 1;
> >   		if (tdp_enabled) {
> >   			direct = 1;
> >   			root_gfn = i<<  30;
> 
> The overloading of root_gfn is pretty bad.  Also, we don't really need 
> to check root_gfn for the direct case (the guest can easily switch cr3 
> later to one that would fail the check).
> 
> However, I'll apply the patch since it fixes the direct problem.  More 
> involved fixes can come later (esp. after the nnpt patches land).

Ok, great. I will rebase my nnpt patches on-top of this and do some more
final testing before I post them.

Thanks,

	Joerg

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

