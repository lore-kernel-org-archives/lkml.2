Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760841Ab2CNLBR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 07:01:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15928 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753075Ab2CNLBP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 07:01:15 -0400
Date: Wed, 14 Mar 2012 07:58:13 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
Cc: avi@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] KVM: Avoid checking huge page mappings in
 get_dirty_log()
Message-ID: <20120314105813.GA13956@amt.cnet>
References: <20120301193007.04b2db8e.yoshikawa.takuya@oss.ntt.co.jp>
 <20120301193216.b14538bb.yoshikawa.takuya@oss.ntt.co.jp>
 <20120313230412.GA12153@amt.cnet>
 <20120314143432.c982e893.yoshikawa.takuya@oss.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120314143432.c982e893.yoshikawa.takuya@oss.ntt.co.jp>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 14, 2012 at 02:34:32PM +0900, Takuya Yoshikawa wrote:
> Marcelo Tosatti <mtosatti@redhat.com> wrote:
> 
> > guest fault                                     enable dirty logging
> > 
> > tdp_page_fault (all _page_fault functions)      kvm_set_memory_region
> > 
> > 
> > level = mapping_level(vcpu, gfn)
> > (finds level == 2 or 3)
> > 
> > 
> >                                                 rcu_assign_pointer(slot
> > 								   with 
> >                                                                    ->dirty_bitmap)
> >                                                 synchronize_srcu_expedited()
> 
> Isn't here still in the SRCU read-side critical section?
> 
> > schedule()
> >                                                 kvm_arch_commit_memory_region()
> >                                                 spin_lock(mmu_lock)
> >                                                 kvm_mmu_slot_remove_write_access()
> > 						removes large sptes
> >                                                 spin_unlock(mmu_lock)
> > spin_lock(mmu_lock)
> > create large spte accordingly
> > to level above
> > spin_unlock(mmu_lock)
> > 
> 
> If so, we cannot start kvm_arch_commit_memory_region() until the completion
> of the SRCU critical section and this race will not happen.
> 
> 	Takuya

Correct.

