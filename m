Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755922Ab1GOSQy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 14:16:54 -0400
Received: from merlin.infradead.org ([205.233.59.134]:33915 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754653Ab1GOSQx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 14:16:53 -0400
Subject: Re: [PATCH 1/1] Fixup write permission of TLB on powerpc e500 core
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Shan Hai <haishan.bai@gmail.com>
Cc: benh@kernel.crashing.org, paulus@samba.org, tglx@linutronix.de,
        walken@google.com, dhowells@redhat.com, cmetcalf@tilera.com,
        tony.luck@intel.com, akpm@linux-foundation.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
In-Reply-To: <4E205A63.90401@gmail.com>
References: <1310717238-13857-1-git-send-email-haishan.bai@gmail.com>
	 <1310717238-13857-2-git-send-email-haishan.bai@gmail.com>
	 <1310725418.2586.309.camel@twins>  <4E205A63.90401@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 15 Jul 2011 17:24:37 +0200
Message-ID: <1310743477.2586.358.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-07-15 at 11:18 -0400, Shan Hai wrote:

> >> +	vma = find_vma(mm, address);
> > Uhm, find_vma() needs mmap_sem, and futex_atomic_cmpxchg_inatomic() is
> > most certainly not called with that lock held.
> >
> 
> My fault, that will be fixed in the V2 patch.

But you cannot, the function isn't called _atomic_ just for kicks, its
used while holding spinlocks.

> >> +	if (likely(vma)) {
> >> +		/* only fixup present page */
> >> +		if (follow_page(vma, address, FOLL_WRITE)) {
> >> +			handle_mm_fault(mm, vma, address, FAULT_FLAG_WRITE);
> > So how can this toggle your sw dirty/young tracking, that's pretty much
> > what gup(.write=1) does too!
> >
> 
> because of the kernel read only permission of the page is transparent
> to the follow_page(),  the handle_mm_fault() is not to be activated
> in the __get_use_pages(), so the gup(.write=1) could not help to fixup
> the write permission.

So why do you need the vma? Is it like I wrote earlier that you don't
have spare PTE bits and need the vma flags to see if it may become
writable?

gup(.write=1) not triggering this is a serious problem though, not
something you can just paper over. I wouldn't be at all surprised to
find there's more things broken because of that.
