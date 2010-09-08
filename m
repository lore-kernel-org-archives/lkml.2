Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757337Ab0IHJSd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 05:18:33 -0400
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:58287
	"EHLO VA3EHSOBE008.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751089Ab0IHJSb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 05:18:31 -0400
X-SpamScore: -16
X-BigFish: VS-16(zz1432N98dN148cMzz1202hzz8275bhz32i87h2a8h61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 0,
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L8F899-02-3BJ-02
X-M-MSG: 
Date: Wed, 8 Sep 2010 11:12:52 +0200
From: "Roedel, Joerg" <Joerg.Roedel@amd.com>
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: Avi Kivity <avi@redhat.com>, Alexander Graf <agraf@suse.de>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 14/27] KVM: MMU: Make walk_addr_generic capable for
 two-level walking
Message-ID: <20100908091252.GH2177@amd.com>
References: <1283788566-29186-1-git-send-email-joerg.roedel@amd.com>
 <1283788566-29186-15-git-send-email-joerg.roedel@amd.com>
 <20100907174805.GA11215@amt.cnet>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20100907174805.GA11215@amt.cnet>
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

On Tue, Sep 07, 2010 at 01:48:05PM -0400, Marcelo Tosatti wrote:
> On Mon, Sep 06, 2010 at 05:55:53PM +0200, Joerg Roedel wrote:
> > This patch uses kvm_read_guest_page_tdp to make the
> > walk_addr_generic functions suitable for two-level page
> > table walking.
> > 
> > Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
> > ---
> >  arch/x86/kvm/paging_tmpl.h |   27 ++++++++++++++++++++-------
> >  1 files changed, 20 insertions(+), 7 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
> > index cd59af1..a5b5759 100644
> > --- a/arch/x86/kvm/paging_tmpl.h
> > +++ b/arch/x86/kvm/paging_tmpl.h
> > @@ -124,6 +124,8 @@ static int FNAME(walk_addr_generic)(struct guest_walker *walker,
> >  	unsigned index, pt_access, uninitialized_var(pte_access);
> >  	gpa_t pte_gpa;
> >  	bool eperm, present, rsvd_fault;
> > +	int offset;
> > +	u32 error = 0;
> >  
> >  	trace_kvm_mmu_pagetable_walk(addr, write_fault, user_fault,
> >  				     fetch_fault);
> > @@ -153,12 +155,13 @@ walk:
> >  		index = PT_INDEX(addr, walker->level);
> >  
> >  		table_gfn = gpte_to_gfn(pte);
> > -		pte_gpa = gfn_to_gpa(table_gfn);
> > -		pte_gpa += index * sizeof(pt_element_t);
> > +		offset    = index * sizeof(pt_element_t);
> > +		pte_gpa   = gfn_to_gpa(table_gfn) + offset;
> >  		walker->table_gfn[walker->level - 1] = table_gfn;
> >  		walker->pte_gpa[walker->level - 1] = pte_gpa;
> >  
> > -		if (kvm_read_guest(vcpu->kvm, pte_gpa, &pte, sizeof(pte))) {
> > +		if (kvm_read_guest_page_mmu(vcpu, mmu, table_gfn, &pte, offset,
> > +					    sizeof(pte), &error)) {
> >  			present = false;
> >  			break;
> >  		}
> 
> If there is failure reading the nested page tables here, you fill
> vcpu->arch.fault. But the nested fault error values will be overwritten
> at the end of walk_addr() by the original fault values?

True. Thanks for pointing that out. I will write a test-case for that
too. The results from my implemented tests show that sometimes the error
code is not reported correctly too. So I decided to do a v4 of this
patch-set with all found issues fixed.

Thanks for your review.

	Joerg


