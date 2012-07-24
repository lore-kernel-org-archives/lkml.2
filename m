Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755776Ab2GXU00 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 16:26:26 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:47537 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755667Ab2GXU0Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 16:26:25 -0400
MIME-Version: 1.0
In-Reply-To: <20120724023657.6600.52706.stgit@ltc189.sdl.hitachi.co.jp>
References: <20120724023657.6600.52706.stgit@ltc189.sdl.hitachi.co.jp>
From: Blue Swirl <blauwirbel@gmail.com>
Date: Tue, 24 Jul 2012 20:26:03 +0000
Message-ID: <CAAu8pHsfRBsfSCB5gBFX5pweN2j2PdNrQZyCfjJ3sYYmVjCRfA@mail.gmail.com>
Subject: Re: [Qemu-devel] [RFC PATCH 0/6] virtio-trace: Support virtio-trace
To: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Cc: linux-kernel@vger.kernel.org, Herbert Xu <herbert@gondor.hengli.com.au>,
        Arnd Bergmann <arnd@arndb.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        yrl.pp-manager.tt@hitachi.com, qemu-devel@nongnu.org,
        Borislav Petkov <bp@amd64.org>,
        virtualization@lists.linux-foundation.org,
        "Franch Ch. Eigler" <fche@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Anthony Liguori <anthony@codemonkey.ws>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Amit Shah <amit.shah@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 24, 2012 at 2:36 AM, Yoshihiro YUNOMAE
<yoshihiro.yunomae.ez@hitachi.com> wrote:
> Hi All,
>
> The following patch set provides a low-overhead system for collecting kernel
> tracing data of guests by a host in a virtualization environment.
>
> A guest OS generally shares some devices with other guests or a host, so
> reasons of any problems occurring in a guest may be from other guests or a host.
> Then, to collect some tracing data of a number of guests and a host is needed
> when some problems occur in a virtualization environment. One of methods to
> realize that is to collect tracing data of guests in a host. To do this, network
> is generally used. However, high load will be taken to applications on guests
> using network I/O because there are many network stack layers. Therefore,
> a communication method for collecting the data without using network is needed.

I implemented something similar earlier by passing trace data from
OpenBIOS to QEMU using the firmware configuration device. The data
format was the same as QEMU used for simpletrace event structure
instead of ftrace. I didn't commit it because of a few problems.

I'm not familiar with ftrace, is it possible to trace two guest
applications (BIOS and kernel) at the same time? Or could this be
handled by opening two different virtio-serial pipes, one for BIOS and
the other for the kernel?

In my version, the tracepoint ID would have been used to demultiplex
QEMU tracepoints from BIOS tracepoints, but something like separate ID
spaces would have been better.

>
> We submitted a patch set of "IVRing", a ring-buffer driver constructed on
> Inter-VM shared memory (IVShmem), to LKML http://lwn.net/Articles/500304/ in
> this June. IVRing and the IVRing reader use POSIX shared memory each other
> without using network, so a low-overhead system for collecting guest tracing
> data is realized. However, this patch set has some problems as follows:
>  - use IVShmem instead of virtio
>  - create a new ring-buffer without using existing ring-buffer in kernel
>  - scalability
>    -- not support SMP environment
>    -- buffer size limitation
>    -- not support live migration (maybe difficult for realize this)
>
> Therefore, we propose a new system "virtio-trace", which uses enhanced
> virtio-serial and existing ring-buffer of ftrace, for collecting guest kernel
> tracing data. In this system, there are 5 main components:
>  (1) Ring-buffer of ftrace in a guest
>      - When trace agent reads ring-buffer, a page is removed from ring-buffer.
>  (2) Trace agent in the guest
>      - Splice the page of ring-buffer to read_pipe using splice() without
>        memory copying. Then, the page is spliced from write_pipe to virtio
>        without memory copying.
>  (3) Virtio-console driver in the guest
>      - Pass the page to virtio-ring
>  (4) Virtio-serial bus in QEMU
>      - Copy the page to kernel pipe
>  (5) Reader in the host
>      - Read guest tracing data via FIFO(named pipe)
>
> ***Evaluation***
> When a host collects tracing data of a guest, the performance of using
> virtio-trace is compared with that of using native(just running ftrace),
> IVRing, and virtio-serial(normal method of read/write).
>
> <environment>
> The overview of this evaluation is as follows:
>  (a) A guest on a KVM is prepared.
>      - The guest is dedicated one physical CPU as a virtual CPU(VCPU).
>
>  (b) The guest starts to write tracing data to ring-buffer of ftrace.
>      - The probe points are all trace points of sched, timer, and kmem.
>
>  (c) Writing trace data, dhrystone 2 in UNIX bench is executed as a benchmark
>      tool in the guest.
>      - Dhrystone 2 intends system performance by repeating integer arithmetic
>        as a score.
>      - Since higher score equals to better system performance, if the score
>        decrease based on bare environment, it indicates that any operation
>        disturbs the integer arithmetic. Then, we define the overhead of
>        transporting trace data is calculated as follows:
>                 OVERHEAD = (1 - SCORE_OF_A_METHOD/NATIVE_SCORE) * 100.
>
> The performance of each method is compared as follows:
>  [1] Native
>      - only recording trace data to ring-buffer on a guest
>  [2] Virtio-trace
>      - running a trace agent on a guest
>      - a reader on a host opens FIFO using cat command
>  [3] IVRing
>      - A SystemTap script in a guest records trace data to IVRing.
>        -- probe points are same as ftrace.
>  [4] Virtio-serial(normal)
>      - A reader(using cat) on a guest output trace data to a host using
>        standard output via virtio-serial.
>
> Other information is as follows:
>  - host
>    kernel: 3.3.7-1 (Fedora16)
>    CPU: Intel Xeon x5660@2.80GHz(12core)
>    Memory: 48GB
>
>  - guest(only booting one guest)
>    kernel: 3.5.0-rc4+ (Fedora16)
>    CPU: 1VCPU(dedicated)
>    Memory: 1GB
>
> <result>
> 3 patterns based on the bare environment were indicated as follows:
>                            Scores      overhead against [0] Native
>     [0] Native:          28807569.5               -
>     [1] Virtio-trace:    28685049.5             0.43%
>     [2] IVRing:          28418595.5             1.35%
>     [3] Virtio-serial:   13262258.7            53.96%
>
>
> ***Just enhancement ideas***
>  - Support for trace-cmd
>  - Support for 9pfs protocol
>  - Support for non-blocking mode in QEMU
>  - Make "vhost-serial"
>
> Thank you,
>
> ---
>
> Masami Hiramatsu (5):
>       virtio/console: Allocate scatterlist according to the current pipe size
>       ftrace: Allow stealing pages from pipe buffer
>       virtio/console: Wait until the port is ready on splice
>       virtio/console: Add a failback for unstealable pipe buffer
>       virtio/console: Add splice_write support
>
> Yoshihiro YUNOMAE (1):
>       tools: Add guest trace agent as a user tool
>
>
>  drivers/char/virtio_console.c               |  198 ++++++++++++++++++--
>  kernel/trace/trace.c                        |    8 -
>  tools/virtio/virtio-trace/Makefile          |   14 +
>  tools/virtio/virtio-trace/README            |  118 ++++++++++++
>  tools/virtio/virtio-trace/trace-agent-ctl.c |  137 ++++++++++++++
>  tools/virtio/virtio-trace/trace-agent-rw.c  |  192 +++++++++++++++++++
>  tools/virtio/virtio-trace/trace-agent.c     |  270 +++++++++++++++++++++++++++
>  tools/virtio/virtio-trace/trace-agent.h     |   75 ++++++++
>  8 files changed, 985 insertions(+), 27 deletions(-)
>  create mode 100644 tools/virtio/virtio-trace/Makefile
>  create mode 100644 tools/virtio/virtio-trace/README
>  create mode 100644 tools/virtio/virtio-trace/trace-agent-ctl.c
>  create mode 100644 tools/virtio/virtio-trace/trace-agent-rw.c
>  create mode 100644 tools/virtio/virtio-trace/trace-agent.c
>  create mode 100644 tools/virtio/virtio-trace/trace-agent.h
>
> --
> Yoshihiro YUNOMAE
> Software Platform Research Dept. Linux Technology Center
> Hitachi, Ltd., Yokohama Research Laboratory
> E-mail: yoshihiro.yunomae.ez@hitachi.com
>
>
