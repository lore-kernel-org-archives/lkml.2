Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753144Ab1KHKYp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 05:24:45 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:52692 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751471Ab1KHKYn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 05:24:43 -0500
Date: Tue, 8 Nov 2011 11:22:35 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Ted Ts'o" <tytso@mit.edu>, Pekka Enberg <penberg@cs.helsinki.fi>,
        "Frank Ch. Eigler" <fche@redhat.com>, Vince Weaver <vince@deater.net>,
        Pekka Enberg <penberg@kernel.org>,
        Anthony Liguori <anthony@codemonkey.ws>, Avi Kivity <avi@redhat.com>,
        "kvm@vger.kernel.org list" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        qemu-devel Developers <qemu-devel@nongnu.org>,
        Alexander Graf <agraf@suse.de>, Blue Swirl <blauwirbel@gmail.com>,
        =?iso-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [F.A.Q.] perf ABI backwards and forwards compatibility
Message-ID: <20111108102235.GA1241@elte.hu>
References: <20111106183132.GA4500@thunk.org>
 <CAOJsxLHvYo5zA+_m-AXuZHjAcGKE5q0ytmPCZ0Gye52LWq1p9Q@mail.gmail.com>
 <CAOJsxLG6kyq-RoQiBj0B_tThvOy1AxJf6XB2VfQFQJkwQ5cHcQ@mail.gmail.com>
 <20111106231953.GD4500@thunk.org>
 <alpine.LFD.2.02.1111070838520.1823@tux.localdomain>
 <alpine.DEB.2.02.1111071156230.28615@pianoman.cluster.toy>
 <20111107175942.GA9395@elte.hu>
 <y0mpqh3og3v.fsf@fche.csb>
 <alpine.LFD.2.02.1111072204370.3082@tux.localdomain>
 <20111107203514.GG24234@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111107203514.GG24234@thunk.org>
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


* Ted Ts'o <tytso@mit.edu> wrote:

> I don't believe there's ever been any guarantee that "perf test" 
> from version N of the kernel will always work on a version N+M of 
> the kernel.  Perhaps I am wrong, though. If that is a guarantee 
> that the perf developers are willing to stand behind, or have 
> already made, I would love to be corrected and would be delighted 
> to hear that in fact there is a stable, backwards compatible perf 
> ABI.

We do even more than that, the perf ABI is fully backwards *and* 
forwards compatible: you can run older perf on newer ABIs and newer 
perf on older ABIs.

To show you how it works in practice, here's a random 
cross-compatibility experiment: going back to the perf ABI of 2 years 
ago. I used v2.6.32 which was just the second upstream kernel with 
perf released in it.

So i took a fresh perf tool version and booted a vanilla v2.6.32 
(x86, defconfig, PERF_COUNTERS=y) kernel:

  $ uname -a
  Linux mercury 2.6.32 #162137 SMP Tue Nov 8 10:55:37 CET 2011 x86_64 x86_64 x86_64 GNU/Linux

  $ perf --version
  perf version 3.1.1927.gceec2

  $ perf top

  Events: 2K cycles
 61.68%  [kernel]             [k] sha_transform
 16.09%  [kernel]             [k] mix_pool_bytes_extract
  4.70%  [kernel]             [k] extract_buf
  4.17%  [kernel]             [k] _spin_lock_irqsave
  1.44%  [kernel]             [k] copy_user_generic_string
  0.75%  [kernel]             [k] extract_entropy_user
  0.37%  [kernel]             [k] acpi_pm_read

[the box is running a /dev/urandom stress-test as you can see.]

 $ perf stat sleep 1

 Performance counter stats for 'sleep 1':

          0.766698 task-clock                #    0.001 CPUs utilized          
                 1 context-switches          #    0.001 M/sec                  
                 0 CPU-migrations            #    0.000 M/sec                  
               177 page-faults               #    0.231 M/sec                  
         1,513,332 cycles                    #    1.974 GHz                    
   <not supported> stalled-cycles-frontend 
   <not supported> stalled-cycles-backend  
           522,609 instructions              #    0.35  insns per cycle        
            65,812 branches                  #   85.838 M/sec                  
             7,762 branch-misses             #   11.79% of all branches        

       1.076211168 seconds time elapsed

The two <not supported> events are not supported by the old kernel - 
but the other events were and the tool picked them up without bailing 
out.

Regular profiling:

 $ perf record -a sleep 1
 [ perf record: Woken up 1 times to write data ]
 [ perf record: Captured and wrote 0.075 MB perf.data (~3279 samples) ]

perf report output:

 $ perf report

 Events: 1K cycles
  64.45%          dd  [kernel.kallsyms]    [k] sha_transform
  19.39%          dd  [kernel.kallsyms]    [k] mix_pool_bytes_extract
   4.11%          dd  [kernel.kallsyms]    [k] _spin_lock_irqsave
   2.98%          dd  [kernel.kallsyms]    [k] extract_buf
   0.84%          dd  [kernel.kallsyms]    [k] copy_user_generic_string
   0.38%         ssh  libcrypto.so.0.9.8b  [.] lh_insert
   0.28%   flush-8:0  [kernel.kallsyms]    [k] block_write_full_page_endio
   0.28%   flush-8:0  [kernel.kallsyms]    [k] generic_make_request

These examples show *PICTURE PERFECT* backwards ABI compatibility, 
when using the bleeding perf tool on an ancient perf kernel (when it 
wasnt even called 'perf events' but 'perf counters').

[ Note, i didnt go back to v2.6.31, the oldest upstream perf kernel, 
  because it's such a pain to build with recent binutils and recent 
  GCC ... v2.6.32 already needed a workaround and a couple of .config 
  tweaks to build and boot at all. ]

Then i built the ancient v2.6.32 perf tool from 2 years ago:

 $ perf --version
 perf version 0.0.2.PERF

and booted a fresh v3.1+ kernel:

 $ uname -a
 Linux mercury 3.1.0-tip+ #162138 SMP Tue Nov 8 11:14:26 CET 2011 x86_64 x86_64 x86_64 GNU/Linux

 $ perf stat ls

 Performance counter stats for 'ls':

       1.739193  task-clock-msecs         #      0.069 CPUs 
              0  context-switches         #      0.000 M/sec
              0  CPU-migrations           #      0.000 M/sec
            250  page-faults              #      0.144 M/sec
        3477562  cycles                   #   1999.526 M/sec
        1661460  instructions             #      0.478 IPC  
         839826  cache-references         #    482.883 M/sec
          15742  cache-misses             #      9.051 M/sec

    0.025231139  seconds time elapsed

 $ perf top

 ------------------------------------------------------------------------------
   PerfTop:   38916 irqs/sec  kernel:99.6% [100000 cycles],  (all, 2 CPUs)
 ------------------------------------------------------------------------------

             samples    pcnt   kernel function
             _______   _____   _______________

            41191.00 - 53.1% : sha_transform
            20818.00 - 26.8% : mix_pool_bytes_extract
             5481.00 -  7.1% : _raw_spin_lock_irqsave
             2132.00 -  2.7% : extract_buf
             1788.00 -  2.3% : copy_user_generic_string
              801.00 -  1.0% : acpi_pm_read
              446.00 -  0.6% : _raw_spin_unlock_irqrestore
              284.00 -  0.4% : __memset
              259.00 -  0.3% : extract_entropy_user

 $ perf record -a -f sleep 1
 [ perf record: Woken up 1 times to write data ]
 [ perf record: Captured and wrote 0.034 MB perf.data (~1467 samples) ]

 $ perf report

 # Samples: 1023
 #
 # Overhead        Command                     Shared Object  Symbol
 # ........  .............  ................................  ......
 #
     4.50%        swapper  [kernel]                          [k] acpi_pm_read
     4.01%        swapper  [kernel]                          [k] delay_tsc
     2.05%           sudo  /lib64/libcrypto.so.0.9.8b        [.] 0x000000000a0549
     1.96%           perf  [kernel]                          [k] vsnprintf
     1.86%        swapper  [kernel]                          [k] test_clear_page_writeback
     1.66%           perf  [kernel]                          [k] format_decode
     1.56%           sudo  /lib64/ld-2.7.so                  [.] do_lookup_x

These examples show *PICTURE PERFECT* forwards ABI compatibility, 
using the ancient perf tool on a bleeding edge kernel.

During the years we migrated across various transformations of the 
subsystem and added tons of features, while maintaining the perf ABI.

I don't know where the whole ABI argument comes from - perf has 
argumably one of the best and most compatible tooling ABIs within 
Linux. I suspect back in the original perf flamewars people made up 
their mind prematurely that it 'cannot' possibly work and never 
changed their mind about it, regardless of reality proving them
wrong ;-)

And yes, the quality of the ABI and tooling cross-compatibility is 
not accidental at all, it is fully intentional and we take great care 
that it stays so. More than that we'll gladly take more 'perf test' 
testcases, for obscure corner-cases that other tools might rely on. 
I.e. we are willing to help external tooling to get their testcases 
built into the kernel repo.

Note that such level of ABI support is arguably clearly overkill for 
instrumentation: which by its very nature tends to migrate to the 
newer versions - still we maintain it because in our opinion good, 
usable tooling should have a good, extensible ABI.

Thanks,

	Ingo
