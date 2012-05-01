Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757537Ab2EACgO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 22:36:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34554 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752527Ab2EACgM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 22:36:12 -0400
Date: Mon, 30 Apr 2012 23:31:45 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Takuya Yoshikawa <takuya.yoshikawa@gmail.com>
Cc: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        Avi Kivity <avi@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v4 06/10] KVM: MMU: fast path of handling guest page fault
Message-ID: <20120501023145.GC10142@amt.cnet>
References: <4F9776D2.7020506@linux.vnet.ibm.com>
 <4F9777A4.208@linux.vnet.ibm.com>
 <20120426234535.GA5057@amt.cnet>
 <4F9A3445.2060305@linux.vnet.ibm.com>
 <20120427145213.GB28796@amt.cnet>
 <20120429175004.b54d8c095a60d98c8cdbc942@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120429175004.b54d8c095a60d98c8cdbc942@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 29, 2012 at 05:50:04PM +0900, Takuya Yoshikawa wrote:
> On Fri, 27 Apr 2012 11:52:13 -0300
> Marcelo Tosatti <mtosatti@redhat.com> wrote:
> 
> > Yes but the objective you are aiming for is to read and write sptes
> > without mmu_lock. That is, i am not talking about this patch. 
> > Please read carefully the two examples i gave (separated by "example)").
> 
> The real objective is not still clear.
> 
> The ~10% improvement reported before was on macro benchmarks during live
> migration.  At least, that optimization was the initial objective.
> 
> But at some point, the objective suddenly changed to "lock-less" without
> understanding what introduced the original improvement.
> 
> Was the problem really mmu_lock contention?
> 
> If the path being introduced by this patch is really fast, isn't it
> possible to achieve the same improvement still using mmu_lock?

Right. Supposedly, mmu_lock cacheline bouncing is the problem. Hum:

$ pahole -C "kvm" /tmp/kvm.ko 
struct kvm {
	spinlock_t                 mmu_lock;             /*     0     2
*/

	/* XXX 6 bytes hole, try to pack */

	struct mutex               slots_lock;           /*     8    32
*/
	struct mm_struct *         mm;                   /*    40     8
*/
	struct kvm_memslots *      memslots;             /*    48     8
*/
	struct srcu_struct         srcu;                 /*    56    48
*/
	/* --- cacheline 1 boundary (64 bytes) was 40 bytes ago --- */
	u32                        bsp_vcpu_id;          /*   104     4
*/

	/* XXX 4 bytes hole, try to pack */

Oops. False sharing?

> Note: During live migration, the fact that the guest gets faulted is
> itself a limitation.  We could easily see noticeable slowdown of a
> program even if it runs only between two GET_DIRTY_LOGs.
> 
> 
> > The rules for code under mmu_lock should be:
> > 
> > 1) Spte updates under mmu lock must always be atomic and 
> > with locked instructions.
> > 2) Spte values must be read once, and appropriate action
> > must be taken when writing them back in case their value
> > has changed (remote TLB flush might be required).
> 
> Although I am not certain about what will be really needed in the
> final form, if this kind of maybe-needed-overhead is going to be
> added little by little, I worry about possible regression.
> 
> Thanks,
> 	Takuya

Yes, that is a possibility.

