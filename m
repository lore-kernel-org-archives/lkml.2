Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755427Ab0D0Pkp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 11:40:45 -0400
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.15]:45150
	"EHLO VA3EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755228Ab0D0Pkn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 11:40:43 -0400
X-SpamScore: -33
X-BigFish: VPS-33(zz1432P98dN936eM179dN9371P10d1Izz1202hzz6ff19hz32i87h2a8h43h62h)
X-Spam-TCS-SCL: 1:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L1JKVD-02-IQC-02
X-M-MSG: 
Date: Tue, 27 Apr 2010 17:40:25 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 15/22] KVM: MMU: Introduce kvm_read_guest_page_x86()
Message-ID: <20100427154024.GL11097@amd.com>
References: <1272364712-17425-1-git-send-email-joerg.roedel@amd.com>
 <1272364712-17425-16-git-send-email-joerg.roedel@amd.com>
 <4BD6DE15.8070409@redhat.com>
 <20100427132030.GH11097@amd.com>
 <4BD6E80A.2000201@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4BD6E80A.2000201@redhat.com>
Organization: Advanced Micro Devices =?iso-8859-1?Q?GmbH?=
	=?iso-8859-1?Q?=2C_Karl-Hammerschmidt-Str=2E_34=2C_85609_Dornach_bei_M=FC?=
	=?iso-8859-1?Q?nchen=2C_Gesch=E4ftsf=FChrer=3A_Thomas_M=2E_McCoy=2C_Giuli?=
	=?iso-8859-1?Q?ano_Meroni=2C_Andrew_Bowd=2C_Sitz=3A_Dornach=2C_Gemeinde_A?=
	=?iso-8859-1?Q?schheim=2C_Landkreis_M=FCnchen=2C_Registergericht_M=FCnche?=
	=?iso-8859-1?Q?n=2C?= HRB Nr. 43632
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 27 Apr 2010 15:40:25.0248 (UTC) FILETIME=[F46A9200:01CAE61F]
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 27, 2010 at 04:35:06PM +0300, Avi Kivity wrote:
> On 04/27/2010 04:20 PM, Joerg Roedel wrote:

> >Hmm, difficult since both mmu's are active in the npt-npt case. The
> >arch.mmu struct contains mostly the l1 paging state initialized for
> >shadow paging and different set_cr3/get_cr3/inject_page_fault functions.
> >This keeps the changes to the mmu small and optimize for the common case
> >(a nested npt fault).
> 
> Well, it reduces the changes to the mmu, but it makes a 'struct
> kvm_mmu' incoherent since its meaning depends on whether it is
> nested or not.  For someone reading the code, it is hard to see when
> to use ->nested_mmu or ->mmu.
> 
> Perhaps have
> 
>    struct kvm_mmu base_mmu;
>    struct kvm_mmu nested_mmu;
>    struct kvm_mmu *mmu;
> 
> You could have one patch that mindlessly changes mmu. to mmu->.  The
> impact of the patchset increases, but I think the result is more
> readable.
> 
> It will be a pain adapting the patchset, but easier than updating
> mmu.txt to reflect the current situation.

Okay, I finally read most of mmu.txt :)
I agree that the implemented scheme for using arch.mmu and
arch.nested_mmu is non-obvious. The most complicated thing is that
.gva_to_gpa functions are exchanged between mmu and nested_mmu. This
means that nested_mmu.gva_to_gpa basically walks a page table in a mode
described by arch.mmu while mmu.gva_to_gpa walks the full
two-dimensional page table.
But I also don't yet see how a *mmu pointer would help here. From my
current understanding of the idea the only place to use it would be the
init_kvm_mmu path. But maybe we could also do this to make things more
clear:

	* Rename nested_mmu to l2_mmu and use it to save the current
	  paging mode of the l2 guest
	* Do not switch the the .gva_to_gpa function pointers between
	  mmu contexts and provide a wrapper function for all callers of
	  arch.mmu.gva_to_gpa which uses the right one for the current
	  context. The arch.nested flag is the indicator for which one
	  to use.

Btw. the purpose of the nested-flag is to prevent to reset arch.mmu when
the l2 guest changes his paging mode and we could remove this flag with
a pointer-solution.
Currently its a bit unclear when to use mmu or nested_mmu. With a
pointer it would be unclear to the code reader when to use the pointer
and when to select the mmu_contexts directly.

	Joerg


