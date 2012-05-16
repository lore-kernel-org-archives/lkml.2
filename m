Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759140Ab2EPIFC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 04:05:02 -0400
Received: from merlin.infradead.org ([205.233.59.134]:38140 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751626Ab2EPIE4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 04:04:56 -0400
Message-ID: <1337155464.27694.132.camel@twins>
Subject: Re: [PATCH v5 6/7] x86/tlb: optimizing flush_tlb_mm
From: Peter Zijlstra <peterz@infradead.org>
To: Alex Shi <alex.shi@intel.com>
Cc: Nick Piggin <npiggin@gmail.com>, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, arnd@arndb.de, rostedt@goodmis.org, fweisbec@gmail.com,
        jeremy@goop.org, riel@redhat.com, luto@mit.edu, avi@redhat.com,
        len.brown@intel.com, dhowells@redhat.com, fenghua.yu@intel.com,
        borislav.petkov@amd.com, yinghai@kernel.org, ak@linux.intel.com,
        cpw@sgi.com, steiner@sgi.com, akpm@linux-foundation.org,
        penberg@kernel.org, hughd@google.com, rientjes@google.com,
        kosaki.motohiro@jp.fujitsu.com, n-horiguchi@ah.jp.nec.com,
        tj@kernel.org, oleg@redhat.com, axboe@kernel.dk, jmorris@namei.org,
        kamezawa.hiroyu@jp.fujitsu.com, viro@zeniv.linux.org.uk,
        linux-kernel@vger.kernel.org, yongjie.ren@intel.com,
        linux-arch@vger.kernel.org
Date: Wed, 16 May 2012 10:04:24 +0200
In-Reply-To: <1337155239.27694.131.camel@twins>
References: <1337072138-8323-1-git-send-email-alex.shi@intel.com>
	 <1337072138-8323-7-git-send-email-alex.shi@intel.com>
	 <CAPa8GCDsSOrzQwX2qRJyocYAZdGbwjD4t4fjxmWXV6=EoXjXZw@mail.gmail.com>
	 <4FB2590C.1050303@intel.com> <1337092577.27694.45.camel@twins>
	 <1337093840.27694.56.camel@twins> <4FB34D49.1060809@intel.com>
	 <1337155239.27694.131.camel@twins>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-05-16 at 10:00 +0200, Peter Zijlstra wrote:
> On Wed, 2012-05-16 at 14:46 +0800, Alex Shi wrote:
> > diff --git a/include/asm-generic/tlb.h b/include/asm-generic/tlb.h
> > index 75e888b..ed6642a 100644
> > --- a/include/asm-generic/tlb.h
> > +++ b/include/asm-generic/tlb.h
> > @@ -86,6 +86,8 @@ struct mmu_gather {
> >  #ifdef CONFIG_HAVE_RCU_TABLE_FREE
> >         struct mmu_table_batch  *batch;
> >  #endif
> > +       unsigned long           start;
> > +       unsigned long           end;
> >         unsigned int            need_flush : 1, /* Did free PTEs */
> >                                 fast_mode  : 1; /* No batching   */
> >  
> > diff --git a/mm/memory.c b/mm/memory.c
> > index 6105f47..b176172 100644
> > --- a/mm/memory.c
> > +++ b/mm/memory.c
> > @@ -206,6 +206,8 @@ void tlb_gather_mmu(struct mmu_gather *tlb, struct mm_struct *mm, bool fullmm)
> >         tlb->mm = mm;
> >  
> >         tlb->fullmm     = fullmm;
> > +       tlb->start      = -1UL;
> > +       tlb->end        = 0;
> >         tlb->need_flush = 0;
> >         tlb->fast_mode  = (num_possible_cpus() == 1);
> >         tlb->local.next = NULL;

Also, you just broke compilation on a bunch of archs.. again.
