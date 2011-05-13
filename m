Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757276Ab1EMPjp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 11:39:45 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:65365 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754116Ab1EMPjo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 11:39:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=k8fpJtgcVHhRESW4ke4h3STEZT+QYBSjo0i1DMGlOXX6EJs+ZVA76J30T7LCP/za3F
         tg91ZxxYjxhF/2DupXIxYCffQnnPklfceMiVTiusuTXf0kpYuI2z1gDCn4b5aIE+1kpe
         fCpL984u1NsGH0PuXrwkB0L0KCuHvFJvERYaY=
Subject: Re: [patch] percpu_counter: scalability works
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Shaohua Li <shaohua.li@intel.com>
Cc: Tejun Heo <tj@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "cl@linux.com" <cl@linux.com>, "npiggin@kernel.dk" <npiggin@kernel.dk>
In-Reply-To: <1305298300.3866.22.camel@edumazet-laptop>
References: <20110511081012.903869567@sli10-conroe.sh.intel.com>
	 <20110511092848.GE1661@htj.dyndns.org>
	 <1305168493.2373.15.camel@sli10-conroe>
	 <20110512082159.GB1030@htj.dyndns.org>
	 <1305190520.2373.18.camel@sli10-conroe>
	 <20110512085922.GD1030@htj.dyndns.org>
	 <1305190936.3795.1.camel@edumazet-laptop>
	 <20110512090534.GE1030@htj.dyndns.org>
	 <1305261477.2373.45.camel@sli10-conroe>
	 <1305264007.2831.14.camel@edumazet-laptop>
	 <20110513052859.GA11088@sli10-conroe.sh.intel.com>
	 <1305268456.2831.38.camel@edumazet-laptop>
	 <1305298300.3866.22.camel@edumazet-laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 13 May 2011 17:39:11 +0200
Message-ID: <1305301151.3866.39.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le vendredi 13 mai 2011 à 16:51 +0200, Eric Dumazet a écrit :

> Here the patch I cooked (on top of linux-2.6)
> 
> This solves the problem quite well for me.
> 
> Idea is :
> 
> Consider _sum() being slow path. It is still serialized by a spinlock().
> 
> Add a fbc->sequence, so that _add() can detect a sum() is in flight, and
> directly add to a new atomic64_t field I named "fbc->slowcount" (and not
> touch its percpu s32 variable so that _sum() can get accurate
> percpu_counter 'Value')
> 
> Low order bit of the 'sequence' is used to signal _sum() is in flight,
> while _add() threads that overflow their percpu s32 variable do a
> sequence += 2, so that _sum() can detect at least one cpu messed the
> fbc->count and reset its s32 variable. _sum() can restart its loop, but
> since sequence has still low order bit set, we have guarantee that the
> _sum() loop wont be restarted ad infinitum.
> 
> Notes : I disabled IRQ in _add() to reduce window, making _add() as fast
> as possible to avoid _sum() extra loops, but its not strictly necessary,
> we can discuss this point, since _sum() is slow path :)
> 
> _sum() is accurate and not blocking anymore _add(). It's slowing it a
> bit of course since all _add() will touch fbc->slowcount.
> 
> _sum() is about same speed than before in my tests.
> 
> On my 8 cpu (Intel(R) Xeon(R) CPU E5450 @ 3.00GHz) machine, and 32bit
> kernel, the : 
> 	loop (10000000 times) {
> 		p = mmap(128M, ANONYMOUS);
> 		munmap(p, 128M);
> 	} 
> done on 8 cpus bench :
> 
> Before patch :
> real	3m22.759s
> user	0m6.353s
> sys	26m28.919s
> 
> After patch :
> real	0m23.420s
> user	0m6.332s
> sys	2m44.561s
> 
> Quite good results considering atomic64_add() uses two "lock cmpxchg8b"
> on x86_32 :
> 
>     33.03%        mmap_test  [kernel.kallsyms]       [k] unmap_vmas
>     12.99%        mmap_test  [kernel.kallsyms]       [k] atomic64_add_return_cx8
>      5.62%        mmap_test  [kernel.kallsyms]       [k] free_pgd_range
>      3.07%        mmap_test  [kernel.kallsyms]       [k] sysenter_past_esp
>      2.48%        mmap_test  [kernel.kallsyms]       [k] memcpy
>      2.24%        mmap_test  [kernel.kallsyms]       [k] perf_event_mmap
>      2.21%        mmap_test  [kernel.kallsyms]       [k] _raw_spin_lock
>      2.02%        mmap_test  [vdso]                  [.] 0xffffe424
>      2.01%        mmap_test  [kernel.kallsyms]       [k] perf_event_mmap_output
>      1.38%        mmap_test  [kernel.kallsyms]       [k] vma_adjust
>      1.24%        mmap_test  [kernel.kallsyms]       [k] sched_clock_local
>      1.23%             perf  [kernel.kallsyms]       [k] __copy_from_user_ll_nozero
>      1.07%        mmap_test  [kernel.kallsyms]       [k] down_write
> 
> 
> If only one cpu runs the program :
> 
> real	0m16.685s
> user	0m0.771s
> sys	0m15.815s

Thinking a bit more, we could allow several _sum() in flight (we would
need an atomic_t counter for counter of _sum(), not a single bit, and
remove the spinlock.

This would allow using a separate integer for the
add_did_change_fbc_count and remove one atomic operation in _add() { the
atomic_add(2, &fbc->sequence); of my previous patch }


Another idea would also put fbc->count / fbc->slowcount out of line,
to keep "struct percpu_counter" read mostly.

I'll send a V2 with this updated schem.


By the way, I ran the bench on a more recent 2x4x2 machine and 64bit
kernel (HP G6 : Intel(R) Xeon(R) CPU E5540  @ 2.53GHz)

1) One process started (no contention) :

Before :
real	0m21.372s
user	0m0.680s
sys	0m20.670s

After V1 patch :
real	0m19.941s
user	0m0.750s
sys	0m19.170s


2) 16 processes started

Before patch:
real	2m14.509s
user	0m13.780s
sys	35m24.170s

After V1 patch :
real	0m48.617s
user	0m16.980s
sys	12m9.400s



