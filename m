Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756246Ab2EGKfU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 06:35:20 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:59672 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754378Ab2EGKfS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 06:35:18 -0400
Date: Mon, 7 May 2012 12:35:12 +0200
From: Ingo Molnar <mingo@kernel.org>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: x86@kernel.org, kvm@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, gleb@redhat.com,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC 0/5] apic: eoi optimization support
Message-ID: <20120507103512.GG23002@gmail.com>
References: <cover.1334833140.git.mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1334833140.git.mst@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Michael S. Tsirkin <mst@redhat.com> wrote:

> I'm looking at reducing the interrupt overhead for virtualized guests:
> some workloads spend a large part of their time processing interrupts.
> This patchset supplies infrastructure to reduce the IRQ ack overhead on
> x86: the idea is to add an eoi_write callback that we can then optimize
> without touching other apic functionality.
> 
> The main user will be kvm: on kvm, an EOI write from the guest causes an
> expensive exit to host; we can avoid this using shared memory as the
> last patch in the series demonstrates.
> 
> But I also wrote a micro-optimized version for the regular x2apic: this
> shaves off a branch and about 9 instructions from EOI when x2apic is
> used, and a comment in ack_APIC_irq implies that someone counted
> instructions there, at some point.
> 
> Also included in the patchset are a couple of trivial macro fixes.
> 
> The patches work fine on my boxes and I did look at the
> objdump output to verify that the generated code
> for the micro-optimization patch looks right
> and actually is shorter.
> 
> Some benchmark results below (not sure what kind of
> testing is the most appropriate) show a tiny
> but measureable improvement. The tests were run on
> an AMD box with 24 cpus.
> 
> - A clean kernel build after reboot shows
> a tiny but measureable improvement in system time
> which means lower CPU overhead (though not measureable
> in total time - that is dominated by user time and fluctuates
> too much):
> 
> linux# reboot -f
> ...
> linux# make clean
> linux# time make -j 64 LOCALVERSION= 2>&1 > /dev/null
> 
> Before:
> 
> real    2m52.244s
> user    35m53.833s
> sys     6m7.194s
> 
> After:
> 
> real    2m52.827s
> user    35m48.916s
> sys     6m2.305s
> 
> - perf micro-benchmarks seem to consistently show
>   a tiny improvement in total time as well but it's below
>   the confidence level of 3 std deviations:
> 
> # ./tools/perf/perf   stat --sync --repeat 100 --null perf bench sched messaging
> ...
>        0.414666797 seconds time elapsed ( +-  1.29% )
> 
> Performance counter stats for 'perf bench sched messaging' (100 runs):
> 
>        0.395370891 seconds time elapsed
> ( +-  1.04% )
> 
> 
> # ./tools/perf/perf   stat --sync --repeat 100 --null perf bench sched pipe -l 10000
>        0.307019664 seconds time elapsed
> ( +-  0.10% )
> 
>        0.304738024 seconds time elapsed
> ( +-  0.08% )
> 
> The patches are against 3.4-rc3 - let me know if
> I need to rebase.
> 
> I think patches 1-2 are definitely a good idea,
> and patches 3-4 might be a good idea.
> Please review, and consider patches 1-4 for linux 3.5.
> 
> Thanks,
> MST
> 
> Michael S. Tsirkin (5):
>   apic: fix typo EIO_ACK -> EOI_ACK and document
>   apic: use symbolic APIC_EOI_ACK
>   x86: add apic->eoi_write callback
>   x86: eoi micro-optimization
>   kvm_para: guest side for eoi avoidance
> 
>  arch/x86/include/asm/apic.h            |   22 ++++++++++++--
>  arch/x86/include/asm/apicdef.h         |    2 +-
>  arch/x86/include/asm/bitops.h          |    6 ++-
>  arch/x86/include/asm/kvm_para.h        |    2 +
>  arch/x86/kernel/apic/apic_flat_64.c    |    2 +
>  arch/x86/kernel/apic/apic_noop.c       |    1 +
>  arch/x86/kernel/apic/apic_numachip.c   |    1 +
>  arch/x86/kernel/apic/bigsmp_32.c       |    1 +
>  arch/x86/kernel/apic/es7000_32.c       |    2 +
>  arch/x86/kernel/apic/numaq_32.c        |    1 +
>  arch/x86/kernel/apic/probe_32.c        |    1 +
>  arch/x86/kernel/apic/summit_32.c       |    1 +
>  arch/x86/kernel/apic/x2apic_cluster.c  |    1 +
>  arch/x86/kernel/apic/x2apic_phys.c     |    1 +
>  arch/x86/kernel/apic/x2apic_uv_x.c     |    1 +
>  arch/x86/kernel/kvm.c                  |   51 ++++++++++++++++++++++++++++++--
>  arch/x86/platform/visws/visws_quirks.c |    2 +-
>  17 files changed, 88 insertions(+), 10 deletions(-)

No objections from the x86 side.

In terms of advantages, could you please create perf stat runs 
that counts the number of MMIOs or so? That should show a pretty 
obvious improvement - and that is enough as proof, no need to 
try to reproduce the performance win in a noisy benchmark.

Thanks,

	Ingo
