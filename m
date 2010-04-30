Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759310Ab0D3SiS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 14:38:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23313 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933034Ab0D3RVm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 13:21:42 -0400
Date: Fri, 30 Apr 2010 12:44:27 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Avi Kivity <avi@redhat.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, LKML <linux-kernel@vger.kernel.org>,
       kvm@vger.kernel.org
Subject: Re: [PATCH] kvm mmu: reduce 50% memory usage
Message-ID: <20100430154427.GA32340@amt.cnet>
References: <4BD8228D.7090708@cn.fujitsu.com>
 <20100429180955.GA17909@amt.cnet>
 <4BD9D35C.5090403@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BD9D35C.5090403@redhat.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 29, 2010 at 09:43:40PM +0300, Avi Kivity wrote:
> On 04/29/2010 09:09 PM, Marcelo Tosatti wrote:
> >
> >You missed quadrant on 4mb large page emulation with shadow (see updated
> >patch below).
> 
> Good catch.
> 
> >Also for some reason i can't understand the assumption
> >does not hold for large sptes with TDP, so reverted for now.
> 
> It's unrelated to TDP, same issue with shadow.  I think the
> calculation is correct.  For example the 4th spte for a level=2 page
> will yield gfn=4*512.

Under testing i see sp at level 2, with sp->gfn == 4096, mmu_set_spte
setting index 8 to gfn 4096 (whereas kvm_mmu_page_get_gfn returns 4096 +
8*512).

Lai, can you please take a look at it? You should see the
kvm_mmu_page_set_gfn BUG_ON by using -mem-path on hugetlbfs.

> >@@ -393,6 +393,27 @@ static void mmu_free_rmap_desc(struct kvm_rmap_desc *rd)
> >  	kfree(rd);
> >  }
> >
> >+static gfn_t kvm_mmu_page_get_gfn(struct kvm_mmu_page *sp, int index)
> >+{
> >+	gfn_t gfn;
> >+
> >+	if (!sp->role.direct)
> >+		return sp->gfns[index];
> >+
> >+	gfn = sp->gfn + index * (1<<  (sp->role.level - 1) * PT64_LEVEL_BITS);
> >+	gfn += sp->role.quadrant<<  PT64_LEVEL_BITS;
> 
> PT64_LEVEL_BITS * level
> 
> >+
> >+	return gfn;
> >+}
> >+
> >
> 
> 
> -- 
> I have a truly marvellous patch that fixes the bug which this
> signature is too narrow to contain.
