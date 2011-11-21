Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755377Ab1KUP3s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 10:29:48 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:56925 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752623Ab1KUP3q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 10:29:46 -0500
MIME-Version: 1.0
In-Reply-To: <20111121145337.912104693@chello.nl>
References: <20111121145114.049265181@chello.nl>
	<20111121145337.912104693@chello.nl>
Date: Mon, 21 Nov 2011 16:29:46 +0100
Message-ID: <CABPqkBTg69-EzvtGVxdAuf=EvM6Maag_tGc_a7jE5LdMwDqRgw@mail.gmail.com>
Subject: Re: [RFC][PATCH 6/6] perf, tools: X86 RDPMC, RDTSC test
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: mingo@elte.hu, William Cohen <wcohen@redhat.com>,
        linux-kernel@vger.kernel.org, Arun Sharma <asharma@fb.com>,
        Vince Weaver <vince@deater.net>
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id pALFTufq025292

Peter,

I don't see how this test and infrastructure handles the case where the event
is multiplexed. I know there is time_enabled and time_running. But those are
not sync'd to the moment of the rdpmc(). I think there needs to be some other
timestamp in the mmap struct so the user can compute a delta to then add to
time_enabled and time_running.

Unless, we assume the two time metrics are there ONLY to compute a scaling
ratio. In which case, I think, we don't need the delta because if we
can do rdpmc()
it means the event is currently scheduled and thus time_enabled and time_running
are both ticking which means the scaling ratio does not change since the moment
the event was scheduled in.

Am I understanding the reasoning right?


On Mon, Nov 21, 2011 at 3:51 PM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> Implement a simple test for the self-monitoring data from the
> mmap-control page.
>
>  6: x86 rdpmc test: Ok
> 0: 6042 2481
> 1: 60042 23669
> 2: 605410 245588
> 3: 6060818 2396231
>
> XXX: come up with logic to automagically turn these numbers into OK/FAIL.
>
> Cc: Stephane Eranian <eranian@google.com>
> Cc: Arun Sharma <asharma@fb.com>
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> ---
>  tools/perf/builtin-test.c |  129 ++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 129 insertions(+)
> Index: linux-2.6/tools/perf/builtin-test.c
> ===================================================================
> --- linux-2.6.orig/tools/perf/builtin-test.c
> +++ linux-2.6/tools/perf/builtin-test.c
> @@ -14,6 +14,8 @@
>  #include "util/thread_map.h"
>  #include "../../include/linux/hw_breakpoint.h"
>
> +#include <sys/mman.h>
> +
>  static long page_size;
>
>  static int vmlinux_matches_kallsyms_filter(struct map *map __used, struct symbol *sym)
> @@ -841,6 +843,127 @@ static int test__parse_events(void)
>
>        return ret;
>  }
> +
> +#if defined(__x86_64__) || defined(__i386__)
> +
> +#define barrier() asm volatile("" ::: "memory")
> +
> +static u64 rdpmc(unsigned int counter)
> +{
> +       unsigned int low, high;
> +
> +       asm volatile("rdpmc" : "=a" (low), "=d" (high) : "c" (counter));
> +
> +       return low | ((u64)high) << 32;
> +}
> +
> +static u64 rdtsc(void)
> +{
> +       unsigned int low, high;
> +
> +       asm volatile("rdtsc" : "=a" (low), "=d" (high));
> +
> +       return low | ((u64)high) << 32;
> +}
> +
> +static u64 mmap_read_self(void *addr, u64 *enabled, u64 *running)
> +{
> +       struct perf_event_mmap_page *pc = addr;
> +       u32 seq;
> +       u64 count, delta;
> +
> +       do {
> +again:
> +               seq = pc->lock;
> +               barrier();
> +               if (seq & 1)
> +                       goto again;
> +
> +               if ((enabled || running) && pc->time_mult) {
> +                       u64 cyc = rdtsc();
> +                       u64 rem, quot;
> +
> +                       quot = (cyc >> pc->time_shift);
> +                       rem = cyc & ((1 << pc->time_shift) - 1);
> +                       delta = pc->time_offset +
> +                               quot * pc->time_mult +
> +                               ((rem * pc->time_mult) >> pc->time_shift);
> +               }
> +
> +               if (enabled)
> +                       *enabled = pc->time_enabled + delta;
> +
> +               if (running)
> +                       *running = pc->time_running + delta;
> +
> +               if (pc->index) {
> +                       count = rdpmc(pc->index - 1);
> +                       count += pc->offset;
> +               } else
> +                       goto fail;
> +
> +               barrier();
> +       } while (pc->lock != seq);
> +
> +       return count;
> +
> +fail:
> +       /*
> +        * XXX do read() here
> +        */
> +       printf("FAIL FAIL FAIL\n");
> +       return 0;
> +}
> +
> +static int test__rdpmc(void)
> +{
> +       volatile int tmp = 0;
> +       int loops = 1000;
> +       int n, i;
> +       int fd;
> +       void *addr;
> +       struct perf_event_attr attr = {
> +               .type = PERF_TYPE_HARDWARE,
> +               .config = PERF_COUNT_HW_INSTRUCTIONS,
> +       };
> +
> +
> +       fd = sys_perf_event_open(&attr, 0, -1, -1, 0);
> +       if (fd < 0) {
> +               die("Error: sys_perf_event_open() syscall returned "
> +                   "with %d (%s)\n", fd, strerror(errno));
> +       }
> +
> +       addr = mmap(NULL, page_size, PROT_READ, MAP_SHARED, fd, 0);
> +       if (addr == (void *)(-1)) {
> +               die("Error: mmap() syscall returned "
> +                   "with (%s)\n", strerror(errno));
> +       }
> +
> +       for (n = 0; n < 4; n++) {
> +
> +               u64 stamp, now;
> +               u64 stamp2, now2;
> +
> +               stamp = mmap_read_self(addr, NULL, &stamp2);
> +
> +               for (i = 0; i < loops; i++)
> +                       tmp++;
> +
> +               now = mmap_read_self(addr, NULL, &now2);
> +               loops *= 10;
> +
> +               printf("%d: %Lu %Lu\n", n, (unsigned long long)(now - stamp),
> +                                          (unsigned long long)(now2 - stamp2));
> +       }
> +
> +       munmap(addr, page_size);
> +       close(fd);
> +
> +       return 0;
> +}
> +#endif
> +
>  static struct test {
>        const char *desc;
>        int (*func)(void);
> @@ -865,6 +988,12 @@ static struct test {
>                .desc = "parse events tests",
>                .func = test__parse_events,
>        },
> +#if defined(__x86_64__) || defined(__i386__)
> +       {
> +               .desc = "x86 rdpmc test",
> +               .func = test__rdpmc,
> +       },
> +#endif
>        {
>                .func = NULL,
>        },
>
>
>
���{.n�+�������+%�����ݶ��w��{.n�+����{��G�����{ay�ʇڙ�,j��f���h��������z_�(�階�ݢj"���m������G������?����&���~��iO��z��v�^�m����������?�I�
