Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756550Ab2ECOCY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 10:02:24 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:10520 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754293Ab2ECOCW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 10:02:22 -0400
X-IronPort-AV: E=Sophos;i="4.75,523,1330905600"; 
   d="scan'208";a="12275288"
Date: Thu, 3 May 2012 15:09:50 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Peter Zijlstra <peterz@infradead.org>, Avi Kivity <avi@redhat.com>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "mtosatti@redhat.com" <mtosatti@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "vatsa@linux.vnet.ibm.com" <vatsa@linux.vnet.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hpa@zytor.com" <hpa@zytor.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>
Subject: Re: [RFC PATCH v1 3/5] KVM: Add paravirt kvm_flush_tlb_others
In-Reply-To: <4FA0688E.8030200@goop.org>
Message-ID: <alpine.DEB.2.00.1205031443590.26786@kaball-desktop>
References: <20120427161727.27082.43096.stgit@abhimanyu>  <20120427162401.27082.59387.stgit@abhimanyu> <4F9D32B4.8040002@redhat.com>  <1335865176.13683.120.camel@twins> <4F9FBF38.2060903@redhat.com>  <1335869827.13683.133.camel@twins> <1335869998.13683.135.camel@twins>
 <4FA0688E.8030200@goop.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 May 2012, Jeremy Fitzhardinge wrote:
> On 05/01/2012 03:59 AM, Peter Zijlstra wrote:
> > On Tue, 2012-05-01 at 12:57 +0200, Peter Zijlstra wrote:
> >> Anyway, I don't have any idea about the costs involved with
> >> HAVE_RCU_TABLE_FREE, but I don't think its much.. otherwise these other
> >> platforms (PPC,SPARC) wouldn't have used it, gup_fast() is a very
> >> specific case, whereas mmu-gather is something affecting pretty much all
> >> tasks. 
> > Which reminds me, I thought Xen needed this too, but a git grep on
> > HAVE_RCU_TABLE_FREE shows its still only ppc and sparc.
> >
> > Jeremy?
> 
> Yeah, I was thinking that too, but I can't remember what we did to
> resolve it.  For pure PV guests, gupf simply isn't used, so the problem
> is moot.  But for dom0 or PCI-passthrough it could be.

Yes, dom0 can use gupf, for example when a userspace block backend is
involved.

Reading the code it seems to me that xen_flush_tlb_others returns
immediately and succesfully, no matter whether one or more vcpus are or
are not running at the moment and no matter if one or more vcpus
previously disabled interrupts.

Therefore I think that we should be using HAVE_RCU_TABLE_FREE.
I am going to submit a patch for that.
