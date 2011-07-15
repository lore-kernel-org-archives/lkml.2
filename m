Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965355Ab1GOJN6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 05:13:58 -0400
Received: from gate.crashing.org ([63.228.1.57]:59771 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752273Ab1GOJN5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 05:13:57 -0400
Subject: Re: [PATCH 0/1] Fixup write permission of TLB on powerpc e500 core
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Shan Hai <haishan.bai@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, paulus@samba.org,
        tglx@linutronix.de, walken@google.com, dhowells@redhat.com,
        cmetcalf@tilera.com, tony.luck@intel.com, akpm@linux-foundation.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
In-Reply-To: <4E20037C.5070506@gmail.com>
References: <1310717238-13857-1-git-send-email-haishan.bai@gmail.com>
	 <1310718056.2586.275.camel@twins>  <4E1FFC7B.4000209@gmail.com>
	 <1310719445.2586.288.camel@twins>  <4E20037C.5070506@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 15 Jul 2011 19:12:56 +1000
Message-ID: <1310721176.4968.316.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-07-15 at 17:08 +0800, Shan Hai wrote:
> The whole scenario should be,
> - the child process triggers a page fault at the first time access to
>      the lock, and it got its own writable page, but its *clean* for
>      the reason just for checking the status of the lock.
>      I am sorry for above "unbreakable COW".
> - the futex_lock_pi() is invoked because of the lock contention,
>      and the futex_atomic_cmpxchg_inatomic() tries to get the lock,
>      it found out the lock is free so tries to write to the lock for
>      reservation, a page fault occurs, because the page is read only
>      for kernel(e500 specific), and returns -EFAULT to the caller

There is nothing e500 specific about user read only pages being read
only for kernel. All architectures behave the same way here afaik.

_However_ there is something not totally x86-like in the fact that we
require handle_mm_fault() to deal with dirty and young tracking, which
means that we -will- fault for a non-dirty writeable page or for any
non-young page. It's quite possible that the page fault disabling occurs
before that and thus breaks those architectures (it's not only e500 and
afaik not only powerpc) while x86 works fine due to HW update of dirty
and young.

It might be something to look into.

Cheers,
Ben.

> - the fault_in_user_writeable() tries to fix the fault,
>      but from the get_user_pages() view everything is ok, because
>      the COW was already broken, retry futex_lock_pi_atomic()
> - futex_lock_pi_atomic() --> futex_atomic_cmpxchg_inatomic(),
>      another write protection page fault
> - infinite loop
> 
> 

