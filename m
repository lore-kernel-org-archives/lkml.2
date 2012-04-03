Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752589Ab2DCHwv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 03:52:51 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:57131 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752100Ab2DCHwu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 03:52:50 -0400
Date: Tue, 3 Apr 2012 09:52:45 +0200
From: Ingo Molnar <mingo@kernel.org>
To: "Chen, Dennis (SRDC SW)" <Dennis1.Chen@amd.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>
Subject: Re: semaphore and mutex in current Linux kernel (3.2.2)
Message-ID: <20120403075245.GD26826@gmail.com>
References: <491D6B4EAD0A714894D8AD22F4BDE0439F94AB@SCYBEXDAG02.amd.com>
 <20120401121943.GA11893@gmail.com>
 <491D6B4EAD0A714894D8AD22F4BDE0439F9560@SCYBEXDAG02.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <491D6B4EAD0A714894D8AD22F4BDE0439F9560@SCYBEXDAG02.amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Chen, Dennis (SRDC SW) <Dennis1.Chen@amd.com> wrote:

> > Well, a way to reproduce that would be to find a lock_mutex
> > intense workload ('perf top -g', etc.), and then changing back
> > the underlying mutex to a semaphore, and measure the performance
> > of the two primitives.
>
> Why not the 'test-mutex' tool in the document? 
>
> I guess it should be the private tool from you, if you can 
> share it to me then I can help to make a new round performance 
> check of the two primitives in the latest kernel... make a 
> deal?

I think I posted it back then - but IIRC it was really just 
open-coded mutex fastpath executed in user-space by a couple of 
threads. To do that today you'd have to create it anew: just 
copy the current mutex fast-path to user-space and measure it.

I'm not sure what the point of comparative measurements with 
semaphores would be: for example we don't have per architecture 
optimized semaphores anymore, we switched the legacy semaphores 
to a generic version and are phasing them out.

Mutexes have various advantages (such as lockdep coverage and in 
general tighter semantics that makes their usage more robust) 
and we aren't going back to semaphores.

What would make a ton of sense would be to create a 'perf bench' 
module that would use the kernel's mutex code and would measure 
it in user-space. 'perf bench mem' already does a simplified 
form of that: it measures the kernel's memcpy and memset 
routines:

$ perf bench mem memcpy -r help
# Running mem/memcpy benchmark...
Unknown routine:help
Available routines...
	default ... Default memcpy() provided by glibc
	x86-64-unrolled ... unrolled memcpy() in arch/x86/lib/memcpy_64.S
	x86-64-movsq ... movsq-based memcpy() in arch/x86/lib/memcpy_64.S
	x86-64-movsb ... movsb-based memcpy() in arch/x86/lib/memcpy_64.S

$ perf bench mem memcpy -r x86-64-movsq
# Running mem/memcpy benchmark...
# Copying 1MB Bytes ...

       2.229595 GB/Sec
      10.850694 GB/Sec (with prefault)

$ perf bench mem memcpy -r x86-64-movsb
# Running mem/memcpy benchmark...
# Copying 1MB Bytes ...

       2.055921 GB/Sec
       2.447525 GB/Sec (with prefault)

So what could be done is to add something like:

  perf bench locking mutex

Which would, similarly to tools/perf/bench/mem-memcpy-x86-64-asm.S
et al inline the mutex routines, would build user-space glue 
around them and would allow them to be measured.

Such a new feature could then be used to improve mutex 
performance in the future. Likewise:

  perf bench locking spinlock

could be used to do something similar to spinlocks - measuring 
them contended and uncontended, cache-cold and cache-hot, etc.

This would then be used by all future kernel developer 
generations to improve these locking primitives - avoiding the 
test-mutex kind of obscolescence and bitrot :-)

So if you'd be interested in writing that brand new benchmarking 
feature and need help then let the perf people know.

Thanks,

	Ingo
