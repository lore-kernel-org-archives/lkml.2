Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752154Ab2LCTrL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 14:47:11 -0500
Received: from mx1.redhat.com ([209.132.183.28]:5382 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751383Ab2LCTrJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 14:47:09 -0500
Date: Mon, 3 Dec 2012 17:47:04 -0200
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Gleb Natapov <gleb@redhat.com>, Avi Kivity <avi@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 3/3] KVM: x86: improve reexecute_instruction
Message-ID: <20121203194704.GA590@amt.cnet>
References: <50AAC77C.8040505@linux.vnet.ibm.com>
 <50AAC7F9.7050305@linux.vnet.ibm.com>
 <20121126224105.GB10634@amt.cnet>
 <50B433D0.8060107@linux.vnet.ibm.com>
 <20121128141230.GI928@redhat.com>
 <50B626D7.7070608@linux.vnet.ibm.com>
 <20121128215750.GA10039@amt.cnet>
 <50B692F3.4000408@linux.vnet.ibm.com>
 <20121129002132.GC17264@amt.cnet>
 <50BC63BD.70408@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50BC63BD.70408@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 03, 2012 at 04:33:01PM +0800, Xiao Guangrong wrote:
> Hi Marcelo,
> 
> Thanks for your patience. I was reading your reply over and over again, i would
> like to argue it more :).
> Please see below.
> 
> On 11/29/2012 08:21 AM, Marcelo Tosatti wrote:
> 
> > 
> > https://lkml.org/lkml/2012/11/17/75
> > 
> > Does unshadowing work with large sptes at reexecute_instruction? That
> > is, do we nuke any large read-only sptes that might be causing a certain
> > gfn to be read-only?
> > 
> > That is, following the sequence there, is the large read-only spte
> > properly destroyed?
> 
> Actually, sptes can not prevent gfn becoming writable, that means the gfn
> can become writable *even if* it exists a spte which maps to the gfn.
> 
> The condition that can prevent gfn becoming writable is, the gfn has been
> shadowed, that means the gfn can not become writable if it exists a sp
> with sp.gfn = gfn.
> 
> Note, drop_spte does not remove any sp. So, either destroying spte or keeping
> spte doest not have any affect for gfn write-protection.
> 
> If luck enough, my point is right, the current code can do some optimizations
> as below:
> 
>                 if (level > PT_PAGE_TABLE_LEVEL &&
> -                   has_wrprotected_page(vcpu->kvm, gfn, level)) {
> -                       ret = 1;
> -                       drop_spte(vcpu->kvm, sptep);
> -                       goto done;
> -               }
> +                   has_wrprotected_page(vcpu->kvm, gfn, level))
> +                       return 0;
> 
> 
> 1): we can return 0 instead of 1 to avoid unnecessary emulation. vcpu will refault
>     again then kvm will use small page.

So on refault the large spte is nuked. That works, yes.

> 2): need not do any change on the spte.

