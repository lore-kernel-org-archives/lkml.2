Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965354Ab1GOIo0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 04:44:26 -0400
Received: from merlin.infradead.org ([205.233.59.134]:53432 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965119Ab1GOIoZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 04:44:25 -0400
Subject: Re: [PATCH 0/1] Fixup write permission of TLB on powerpc e500 core
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: MailingLists <haishan.bai@gmail.com>
Cc: benh@kernel.crashing.org, paulus@samba.org, tglx@linutronix.de,
        walken@google.com, dhowells@redhat.com, cmetcalf@tilera.com,
        tony.luck@intel.com, akpm@linux-foundation.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
In-Reply-To: <4E1FFC7B.4000209@gmail.com>
References: <1310717238-13857-1-git-send-email-haishan.bai@gmail.com>
	 <1310718056.2586.275.camel@twins>  <4E1FFC7B.4000209@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 15 Jul 2011 10:44:05 +0200
Message-ID: <1310719445.2586.288.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-07-15 at 16:38 +0800, MailingLists wrote:
> On 07/15/2011 04:20 PM, Peter Zijlstra wrote:
> > On Fri, 2011-07-15 at 16:07 +0800, Shan Hai wrote:
> >> The following test case could reveal a bug in the futex_lock_pi()
> >>
> >> BUG: On FUTEX_LOCK_PI, there is a infinite loop in the futex_lock_pi()
> >>          on Powerpc e500 core.
> >> Cause: The linux kernel on the e500 core has no write permission on
> >>          the COW page, refer the head comment of the following test code.
> >>
> >> ftrace on test case:
> >> [000]   353.990181: futex_lock_pi_atomic<-futex_lock_pi
> >> [000]   353.990185: cmpxchg_futex_value_locked<-futex_lock_pi_atomic
> >> [snip]
> >> [000]   353.990191: do_page_fault<-handle_page_fault
> >> [000]   353.990192: bad_page_fault<-handle_page_fault
> >> [000]   353.990193: search_exception_tables<-bad_page_fault
> >> [snip]
> >> [000]   353.990199: get_user_pages<-fault_in_user_writeable
> >> [snip]
> >> [000]   353.990208: mark_page_accessed<-follow_page
> >> [000]   353.990222: futex_lock_pi_atomic<-futex_lock_pi
> >> [snip]
> >> [000]   353.990230: cmpxchg_futex_value_locked<-futex_lock_pi_atomic
> >> [ a loop occures here ]
> >>
> >
> > But but but but, that get_user_pages(.write=1, .force=0) should result
> > in a COW break, getting our own writable page.
> >
> > What is this e500 thing smoking that this doesn't work?
> 
> A page could be set to read only by the kernel (supervisor in the powerpc
> literature) on the e500, and that's what the kernel do. Set SW(supervisor
> write) bit in the TLB entry to grant write permission to the kernel on a
> page.
> 
> And further the SW bit is set according to the DIRTY flag of the PTE,
> PTE.DIRTY is set in the do_page_fault(), the futex_lock_pi() disabled
> page fault, the PTE.DIRTY never can be set, so do the SW bit, unbreakable
> COW occurred, infinite loop followed.

I'm fairly sure fault_in_user_writeable() has PF enabled as it takes
mmap_sem, an pagefaul_disable() is akin to preemp_disable() on mainline.

Also get_user_pages() fully expects to be able to schedule, and in fact
can call the full pf handler path all by its lonesome self.
