Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933167Ab2AFLHZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jan 2012 06:07:25 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:55756 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758144Ab2AFLHY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jan 2012 06:07:24 -0500
Date: Fri, 6 Jan 2012 12:05:20 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jan Beulich <JBeulich@suse.com>
Cc: tglx@linutronix.de, hpa@zytor.com, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] x86-64: fix memset() to support sizes of 4Gb and above
Message-ID: <20120106110519.GA32673@elte.hu>
References: <4F05D992020000780006AA09@nat28.tlf.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F05D992020000780006AA09@nat28.tlf.novell.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jan Beulich <JBeulich@suse.com> wrote:

> While currently there doesn't appear to be any reachable 
> in-tree case where such large memory blocks may be passed to 
> memset() (alloc_bootmem() being the primary non-reachable one, 
> as it gets called with suitably large sizes in FLATMEM 
> configurations), we have recently hit the problem a second 
> time in our Xen kernels. Rather than working around it a 
> second time, prevent others from falling into the same trap by 
> fixing this long standing limitation.
> 
> Signed-off-by: Jan Beulich <jbeulich@suse.com>

Have you checked the before/after size of the hotpath?

The patch suggests that it got shorter by 3 instructions:

> -	movl %edx,%r8d
> -	andl $7,%r8d
> -	movl %edx,%ecx
> -	shrl $3,%ecx
> +	movq %rdx,%rcx
> +	andl $7,%edx
> +	shrq $3,%rcx

[...]

>  	movq %rdi,%r10
> -	movq %rdx,%r11
>  

[...]

> -	movl	%r11d,%ecx
> -	andl	$7,%ecx
> +	andl	$7,%edx

Is that quick impression correct? I have not tried building or 
measuring it.

Also, note that we have some cool instrumentation tech upstream, 
lately we've added a way to measure the *kernel*'s memcpy 
routine performance in user-space, using perf bench:

  $ perf bench mem memcpy -r x86
  # Running mem/memcpy benchmark...
  Unknown routine:x86
  Available routines...
	default ... Default memcpy() provided by glibc
	x86-64-unrolled ... unrolled memcpy() in arch/x86/lib/memcpy_64.S

  $ perf bench mem memcpy -r x86-64-unrolled
  # Running mem/memcpy benchmark...
  # Copying 1MB Bytes ...

       1.888902 GB/Sec
      15.024038 GB/Sec (with prefault)

This builds the routine in arch/x86/lib/memcpy_64.S and measures 
its bandwidth in the cache-cold and cache-hot case as well.

Would be nice to add support for arch/x86/lib/memset_64.S as 
well, and look at the before/after performance of it. In 
userspace we can do a lot more accurate measurements of this 
kind:

 $ perf stat --repeat 1000 -e instructions -e cycles perf bench mem memcpy -r x86-64-unrolled >/dev/null

 Performance counter stats for 'perf bench mem memcpy -r x86-64-unrolled' (1000 runs):

         4,924,378 instructions              #    0.84  insns per cycle          ( +-  0.03% )
         5,892,603 cycles                    #    0.000 GHz                      ( +-  0.06% )

       0.002208000 seconds time elapsed                                          ( +-  0.10% )

Check how the confidence interval of the measurement is in the 
0.03% range, thus even a single cycle change in overhead caused 
by your patch should be measurable. Note, you'll need to rebuild 
perf with the different memset routines.

For example the kernel's memcpy routine in slightly faster than 
glibc's:

  $ perf stat --repeat 1000 -e instructions -e cycles perf bench mem memcpy -r default >/dev/null

 Performance counter stats for 'perf bench mem memcpy -r default' (1000 runs):

         4,927,173 instructions              #    0.83  insns per cycle          ( +-  0.03% )
         5,928,168 cycles                    #    0.000 GHz                      ( +-  0.06% )

       0.002157349 seconds time elapsed                                          ( +-  0.10% )

If such measurements all suggests equal or better performance, 
and if there's no erratum in current CPUs that would make 4G 
string copies dangerous [which your research suggests should be 
fine], i have no principal objection against this patch.

I'd not be surprised (at all) if other OSs did larger than 4GB 
memsets in certain circumstances.

Thanks,

	Ingo
