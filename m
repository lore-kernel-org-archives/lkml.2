Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753440Ab2ARKkk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 05:40:40 -0500
Received: from nat28.tlf.novell.com ([130.57.49.28]:10322 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752944Ab2ARKkj convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:4:1>);
	Wed, 18 Jan 2012 05:40:39 -0500
Message-Id: <4F16AFB1020000780006D671@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Wed, 18 Jan 2012 10:40:33 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: "Ingo Molnar" <mingo@elte.hu>
Cc: <tglx@linutronix.de>, "Andrew Morton" <akpm@linux-foundation.org>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, <hpa@zytor.com>
Subject: Re: [PATCH] x86-64: fix memset() to support sizes of 4Gb and
 above
References: <4F05D992020000780006AA09@nat28.tlf.novell.com>
 <20120106110519.GA32673@elte.hu>
In-Reply-To: <20120106110519.GA32673@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 06.01.12 at 12:05, Ingo Molnar <mingo@elte.hu> wrote:
>> * Jan Beulich <JBeulich@suse.com> wrote:
> Would be nice to add support for arch/x86/lib/memset_64.S as 
> well, and look at the before/after performance of it.

Got this done, will post the patch soon. However, ...

> For example the kernel's memcpy routine in slightly faster than 
> glibc's:

This is an illusion - since the kernel's memcpy_64.S also defines a
"memcpy" (not just "__memcpy"), the static linker resolves the
reference from mem-memcpy.c against this one. Apparent
performance differences rather point at effects like (guessing)
branch prediction (using the second vs the first entry of
routines[]). After fixing this, on my Westmere box glibc's is quite
a bit slower than the unrolled kernel variant (4% fewer
instructions, but about 15% more cycles).

> If such measurements all suggests equal or better performance, 
> and if there's no erratum in current CPUs that would make 4G 
> string copies dangerous [which your research suggests should be 
> fine], i have no principal objection against this patch.

If I interpreted things correctly, there's a tiny win with the changes
(also for not-yet-posted memcpy equivalent):

# Original 3.2:
 Performance counter stats for 'perf bench mem memcpy -r x86-64-unrolled' (1000 runs):

         5,237,848 instructions              #    1.01  insns per cycle          ( +-  0.01% )
         5,187,712 cycles                    #    0.000 GHz                      ( +-  0.10% )

       0.003426133 seconds time elapsed                                          ( +-  0.30% )

         5,236,075 instructions              #    1.01  insns per cycle          ( +-  0.01% )
         5,177,677 cycles                    #    0.000 GHz                      ( +-  0.08% )

       0.003423426 seconds time elapsed                                          ( +-  0.29% )

         5,236,887 instructions              #    1.01  insns per cycle          ( +-  0.01% )
         5,180,640 cycles                    #    0.000 GHz                      ( +-  0.08% )

       0.003410956 seconds time elapsed                                          ( +-  0.32% )

 Performance counter stats for 'perf bench mem memset -r x86-64-unrolled' (1000 runs):

         4,300,600 instructions              #    0.97  insns per cycle          ( +-  0.02% )
         4,442,449 cycles                    #    0.000 GHz                      ( +-  0.12% )

       0.002976608 seconds time elapsed                                          ( +-  0.29% )

         4,300,542 instructions              #    0.97  insns per cycle          ( +-  0.02% )
         4,443,480 cycles                    #    0.000 GHz                      ( +-  0.10% )

       0.002942516 seconds time elapsed                                          ( +-  0.36% )

         4,300,400 instructions              #    0.97  insns per cycle          ( +-  0.02% )
         4,439,363 cycles                    #    0.000 GHz                      ( +-  0.08% )

       0.002962733 seconds time elapsed                                          ( +-  0.32% )

# Patched (x86_64-mem*.patch):
 Performance counter stats for 'perf bench mem memcpy -r x86-64-unrolled' (1000 runs):

         5,236,674 instructions              #    1.01  insns per cycle          ( +-  0.01% )
         5,182,292 cycles                    #    0.000 GHz                      ( +-  0.07% )

       0.003426389 seconds time elapsed                                          ( +-  0.29% )

         5,235,704 instructions              #    1.01  insns per cycle          ( +-  0.01% )
         5,183,586 cycles                    #    0.000 GHz                      ( +-  0.08% )

       0.003414827 seconds time elapsed                                          ( +-  0.31% )

         5,236,240 instructions              #    1.01  insns per cycle          ( +-  0.01% )
         5,192,932 cycles                    #    0.000 GHz                      ( +-  0.10% )

       0.003404885 seconds time elapsed                                          ( +-  0.33% )

 Performance counter stats for 'perf bench mem memset -r x86-64-unrolled' (1000 runs):

         4,299,811 instructions              #    0.97  insns per cycle          ( +-  0.02% )
         4,442,268 cycles                    #    0.000 GHz                      ( +-  0.09% )

       0.002957321 seconds time elapsed                                          ( +-  0.32% )

         4,300,057 instructions              #    0.97  insns per cycle          ( +-  0.02% )
         4,438,804 cycles                    #    0.000 GHz                      ( +-  0.09% )

       0.002974749 seconds time elapsed                                          ( +-  0.29% )

         4,299,886 instructions              #    0.97  insns per cycle          ( +-  0.02% )
         4,444,117 cycles                    #    0.000 GHz                      ( +-  0.11% )

       0.002967353 seconds time elapsed                                          ( +-  0.30% )

Jan
