Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932463Ab2HIMap (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 08:30:45 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:41821 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758032Ab2HIMan (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 08:30:43 -0400
X-AuditID: b753bd60-a0885ba000000655-63-5023ad706de3
X-AuditID: b753bd60-a0885ba000000655-63-5023ad706de3
From: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Subject: [PATCH V2 0/6] virtio-trace: Support virtio-trace
To: linux-kernel@vger.kernel.org
Cc: Amit Shah <amit.shah@redhat.com>, Anthony Liguori <anthony@codemonkey.ws>,
        Arnd Bergmann <arnd@arndb.de>, Borislav Petkov <bp@amd64.org>,
        "Franch Ch. Eigler" <fche@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        Ingo Molnar <mingo@redhat.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Steven Rostedt <rostedt@goodmis.org>,
        virtualization@lists.linux-foundation.org, qemu-devel@nongnu.org,
        yrl.pp-manager.tt@hitachi.com
Date: Thu, 09 Aug 2012 21:30:29 +0900
Message-ID: <20120809123029.8542.38311.stgit@ltc189.sdl.hitachi.co.jp>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

The following patch set provides a low-overhead system for collecting kernel
tracing data of guests by a host in a virtualization environment.

A guest OS generally shares some devices with other guests or a host, so
reasons of any problems occurring in a guest may be from other guests or a host.
Then, to collect some tracing data of a number of guests and a host is needed
when some problems occur in a virtualization environment. One of methods to
realize that is to collect tracing data of guests in a host. To do this, network
is generally used. However, high load will be taken to applications on guests
using network I/O because there are many network stack layers. Therefore,
a communication method for collecting the data without using network is needed.

We submitted a patch set of "IVRing", a ring-buffer driver constructed on
Inter-VM shared memory (IVShmem), to LKML http://lwn.net/Articles/500304/ in
this June. IVRing and the IVRing reader use POSIX shared memory each other
without using network, so a low-overhead system for collecting guest tracing
data is realized. However, this patch set has some problems as follows:
 - use IVShmem instead of virtio
 - create a new ring-buffer without using existing ring-buffer in kernel
 - scalability
   -- not support SMP environment
   -- buffer size limitation
   -- not support live migration (maybe difficult for realize this)

Therefore, we propose a new system "virtio-trace", which uses enhanced
virtio-serial and existing ring-buffer of ftrace, for collecting guest kernel
tracing data. In this system, there are 5 main components:
 (1) Ring-buffer of ftrace in a guest
     - When trace agent reads ring-buffer, a page is removed from ring-buffer.
 (2) Trace agent in the guest
     - Splice the page of ring-buffer to read_pipe using splice() without
       memory copying. Then, the page is spliced from write_pipe to virtio
       without memory copying.
 (3) Virtio-console driver in the guest
     - Pass the page to virtio-ring
 (4) Virtio-serial bus in QEMU
     - Copy the page to kernel pipe
 (5) Reader in the host
     - Read guest tracing data via FIFO(named pipe) 
Here, this patch set is only for guest kernels, so guest and host don't need to
run the same kernel.

In this patch set, we cannot get text-formatted data but raw-formatted data on
a host. perf and trace-cmd can actually translate raw to text by using
information of kernel or trace format under tracing/events directory in
debugfs. In the same way, if the information of a guest is exported to a host,
we can translate raw data of a guest to text data on a host or a remote host.
We will use 9pfs to export that.

***Evaluation***
When a host collects tracing data of a guest, the performance of using
virtio-trace is compared with that of using native(just running ftrace),
IVRing, and virtio-serial(normal method of read/write).

<environment>
The overview of this evaluation is as follows:
 (a) A guest on a KVM is prepared.
     - The guest is dedicated one physical CPU as a virtual CPU(VCPU).

 (b) The guest starts to write tracing data to ring-buffer of ftrace.
     - The probe points are all trace points of sched, timer, and kmem.

 (c) Writing trace data, dhrystone 2 in UNIX bench is executed as a benchmark
     tool in the guest.
     - Dhrystone 2 intends system performance by repeating integer arithmetic
       as a score.
     - Since higher score equals to better system performance, if the score
       decrease based on bare environment, it indicates that any operation
       disturbs the integer arithmetic. Then, we define the overhead of
       transporting trace data is calculated as follows:
		OVERHEAD = (1 - SCORE_OF_A_METHOD/NATIVE_SCORE) * 100.

The performance of each method is compared as follows:
 [1] Native
     - only recording trace data to ring-buffer on a guest
 [2] Virtio-trace
     - running a trace agent on a guest
     - a reader on a host opens FIFO using cat command
 [3] IVRing
     - A SystemTap script in a guest records trace data to IVRing.
       -- probe points are same as ftrace.
 [4] Virtio-serial(normal)
     - A reader(using cat) on a guest output trace data to a host using
       standard output via virtio-serial.

Other information is as follows:
 - host
   kernel: 3.3.7-1 (Fedora16)
   CPU: Intel Xeon x5660@2.80GHz(12core)
   Memory: 48GB

 - guest(only booting one guest)
   kernel: 3.5.0-rc4+ (Fedora16)
   CPU: 1VCPU(dedicated)
   Memory: 1GB

<result>
3 patterns based on the bare environment were indicated as follows:
	                   Scores      overhead against [0] Native
    [0] Native:          28807569.5               -
    [1] Virtio-trace:    28685049.5             0.43%
    [2] IVRing:          28418595.5             1.35%
    [3] Virtio-serial:   13262258.7            53.96%


***Just enhancement ideas***
 - Support for trace-cmd
 - Support for 9pfs protocol
 - Support for non-blocking mode in QEMU

v2:
 - Use GFP_KERNEL instead of GFP_ATOMIC in syscall context function in 1/6
 - Just a minor fix for avoiding a confliction with previous patch in 5/6
 - Cleanup (change fprintf() to pr_err() and an include guard) in 6/6

Thank you,

---

Masami Hiramatsu (5):
      virtio/console: Allocate scatterlist according to the current pipe size
      ftrace: Allow stealing pages from pipe buffer
      virtio/console: Wait until the port is ready on splice
      virtio/console: Add a failback for unstealable pipe buffer
      virtio/console: Add splice_write support

Yoshihiro YUNOMAE (1):
      tools: Add guest trace agent as a user tool


 drivers/char/virtio_console.c               |  198 ++++++++++++++++++--
 kernel/trace/trace.c                        |    8 -
 tools/virtio/virtio-trace/Makefile          |   14 +
 tools/virtio/virtio-trace/README            |  118 ++++++++++++
 tools/virtio/virtio-trace/trace-agent-ctl.c |  137 ++++++++++++++
 tools/virtio/virtio-trace/trace-agent-rw.c  |  192 +++++++++++++++++++
 tools/virtio/virtio-trace/trace-agent.c     |  270 +++++++++++++++++++++++++++
 tools/virtio/virtio-trace/trace-agent.h     |   75 ++++++++
 8 files changed, 985 insertions(+), 27 deletions(-)
 create mode 100644 tools/virtio/virtio-trace/Makefile
 create mode 100644 tools/virtio/virtio-trace/README
 create mode 100644 tools/virtio/virtio-trace/trace-agent-ctl.c
 create mode 100644 tools/virtio/virtio-trace/trace-agent-rw.c
 create mode 100644 tools/virtio/virtio-trace/trace-agent.c
 create mode 100644 tools/virtio/virtio-trace/trace-agent.h

-- 
Yoshihiro YUNOMAE
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: yoshihiro.yunomae.ez@hitachi.com

