Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754104Ab1LLUPv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 15:15:51 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:43882 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753739Ab1LLUPt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 15:15:49 -0500
MIME-Version: 1.0
In-Reply-To: <1323718578-1157-3-git-send-email-asharma@fb.com>
References: <1323718578-1157-1-git-send-email-asharma@fb.com> <1323718578-1157-3-git-send-email-asharma@fb.com>
From: Andrew Lutomirski <luto@mit.edu>
Date: Mon, 12 Dec 2011 12:15:27 -0800
X-Google-Sender-Auth: EhTbe7kChBhOaAyaOTSOdkzxMgM
Message-ID: <CAObL_7F8v1PT0FQ=GNcNmJKWkzQ7DfkQ9ym2EeR0TgFKiZPPaw@mail.gmail.com>
Subject: Re: [PATCH 2/2] Add a thread cpu time implementation to vDSO
To: Arun Sharma <asharma@fb.com>
Cc: linux-kernel@vger.kernel.org, Kumar Sundararajan <kumar@fb.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        john stultz <johnstul@us.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 12, 2011 at 11:36 AM, Arun Sharma <asharma@fb.com> wrote:
> From: Kumar Sundararajan <kumar@fb.com>
>
> This primarily speeds up clock_gettime(CLOCK_THREAD_CPUTIME_ID, ..)
> via a new vsyscall. We also add a direct vsyscall that returns
> time in ns (RFC: the direct vsyscall doesn't have a corresponding
> regular syscall, although clock_gettime() is pretty close).
>
> We use the following method to compute the thread cpu time:
>
> t0 = process start
> t1 = most recent context switch time
> t2 = time at which the vsyscall is invoked
>
> thread_cpu_time = sum(time slices between t0 to t1) + (t2 - t1)
>                = current->se.sum_exec_runtime + now - sched_clock()
>

[...]

This seems like a neat idea, but I'm a little worried about the
implementation.  Surely someone with 4k+ cpus will complain when the
percpu vvar data exceeds a page and crashes.  I have no personal
objection to a dynamically-sized vvar area, but it might need more
careful handling.

I also wonder if there a problem with information leaking.  If there
was an entire per-cpu vvar page (perhaps mapped differently on each
cpu) then nothing interesting would leak.  But that could add
overhead.

> diff --git a/arch/x86/include/asm/vvar.h b/arch/x86/include/asm/vvar.h
> index 0fd7a4a..e36e1c1 100644
> --- a/arch/x86/include/asm/vvar.h
> +++ b/arch/x86/include/asm/vvar.h
> @@ -47,5 +47,6 @@
>  DECLARE_VVAR(0, volatile unsigned long, jiffies)
>  DECLARE_VVAR(16, int, vgetcpu_mode)
>  DECLARE_VVAR(128, struct vsyscall_gtod_data, vsyscall_gtod_data)
> +DECLARE_VVAR(2048, struct vcpu_data, vcpu_data)

Any reason this isn't page-aligned?  Offset 2048 seems like an odd place.

>  notrace static long vdso_fallback_gettime(long clock, struct timespec *ts)
>  {
>        long ret;
> -       asm("syscall" : "=a" (ret) :
> -           "0" (__NR_clock_gettime),"D" (clock), "S" (ts) : "memory");
> +       asm volatile("syscall" : "=a" (ret) :
> +                    "0" (__NR_clock_gettime),"D" (clock), "S" (ts) : "memory");
>        return ret;
>  }

Huh?  This should probably be a separate patch (and probably not a
-stable candidate, since it would take amazing compiler stupidity to
generate anything other than the obvious code).  The memory clobber
may also be enough to make this officially safe.

>
> @@ -154,8 +155,51 @@ notrace static noinline int do_monotonic_coarse(struct timespec *ts)
>        return 0;
>  }
>
> +notrace static inline unsigned long __do_thread_cpu_time(void)
> +{
> +       unsigned int p;
> +       u_int64_t tscval;
> +       unsigned long long adj_sched_time, scale, offset;
> +       const struct vcpu_data *vp = &VVAR(vcpu_data);
> +       int cpu;
> +
> +       if (vp->tsc_unstable) {
> +               struct timespec ts;
> +               vdso_fallback_gettime(CLOCK_THREAD_CPUTIME_ID, &ts);
> +               return timespec_to_ns(&ts);
> +       }

Yuck -- another flag indicating whether we're using the tsc.

> +
> +       do {
> +               native_read_tscp(&p);

Do all 64-bit cpus have rdtscp?  ISTR older Intel machines don't have it.

> --- a/arch/x86/vdso/vdso.lds.S
> +++ b/arch/x86/vdso/vdso.lds.S
> @@ -25,6 +25,8 @@ VERSION {
>                __vdso_getcpu;
>                time;
>                __vdso_time;
> +               thread_cpu_time;
> +               __vdso_thread_cpu_time;
>        local: *;
>        };
>  }

Why do we have the non-__vdso versions?  IMO anything that actually
uses them is likely to be confused.  They have the same names as the
glibc wrappers, but the glibc wrappers have different return value and
errno semantics.  I'd say just use __vdso.

Also, what's wrong with just adding the functionality to __vdso_clock_gettime?

> +struct vcpu_data {
> +       struct vpercpu_data vpercpu[NR_CPUS];
> +       unsigned int tsc_khz;

I think this also duplicates some of the gtod_data stuff, at least in
the case that TSC works for gtod.


--Andy
