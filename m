Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756170Ab2KNBjY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 20:39:24 -0500
Received: from mailxx.hitachi.co.jp ([133.145.228.50]:53227 "EHLO
	mailxx.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756123Ab2KNBjX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 20:39:23 -0500
X-AuditID: b753bd60-963e4ba000004744-db-50a2f5c51018
X-AuditID: b753bd60-963e4ba000004744-db-50a2f5c51018
Subject: [RFC PATCH 0/2] kvm/vmx: Output TSC offset
To: linux-kernel@vger.kernel.org
From: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
        Joerg Roedel <joerg.roedel@amd.com>, David Sharp <dhsharp@google.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
        Ingo Molnar <mingo@redhat.com>, Avi Kivity <avi@redhat.com>,
        yrl.pp-manager.tt@hitachi.com,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Thomas Gleixner <tglx@linutronix.de>
Date: Wed, 14 Nov 2012 10:36:21 +0900
Message-ID: <20121114013611.5338.15086.stgit@yunodevel>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

The following patch set can make disordered trace data of a guest and a host
sorted in chronological order.

In a virtualization environment, it is difficult to analyze performance
problems, such as a delay of I/O request on a guest. This is because multiple
guests operate on the host. One of approaches for solving such kind of problems
is to sort trace data of guests and the host in chronological order.

After we applied the patch set(https://lkml.org/lkml/2012/11/13/588), raw TSC
can be chosen as a timestamp of ftrace. TSC is useful for merging trace data
in chronological order by two reasons. One of the reasons is that guests can
directly read raw TSC from the CPU using rdtsc operation. This means that raw
TSC value is not software clock like sched_clock, so we don't need to consider
about how the timestamp is calculated. The other is that TSC of recent x86 CPUs
is constantly incremented. This means that we don't need to worry about pace of
the timestamp. Therefore, choosing TSC as a timestamp for tracing is reasonable
to integrate trace data of guests and a host.

Here, we need to consider about just one matter for using TSC on guests. TSC
value on a guest is always the host TSC plus the guest's "TSC offset". In other
words, to merge trace data using TSC as timestamp in chronological order, we
need to consider TSC offset of the guest.

However, only the host kernel can read the TSC offset from VMCS and TSC offset
is not output in anywhere now. In other words, tools in userland cannot get
the TSC offset value, so we cannot merge trace data of guest and the host in
chronological order. Therefore, the TSC offset should be exported for userland
tools.

In this patch set, TSC offset is exported by printk() on the host. I also
attached a tool for merging trace data of a guest and a host in chronological
order.

<Example>
We assume that wakeup-latency for a command is big on a guest. Normally
we will use ftrace's wakeup-latency tracer or event tracer on the guest, but we
may not be able to solve this problem. This is because guests often exit to
the host for several reasons. In the next, we will use TSC as ftrace's timestamp
and record the trace data on the guest and the host. Then, we get following
data:

 /* guest data */
            comm-3826  [000] d...49836825726903: sched_wakeup: [detail]
            comm-3826  [000] d...49836832225344: sched_switch: [detail]
 /* host data */
        qemu-kvm-2687  [003] d...50550079203669: kvm_exit: [detail]
        qemu-kvm-2687  [003] d...50550079206816: kvm_entry: [detail]
        qemu-kvm-2687  [003] d...50550079240656: kvm_exit: [detail]
        qemu-kvm-2687  [003] d...50550079243467: kvm_entry: [detail]
        qemu-kvm-2687  [003] d...50550079256103: kvm_exit: [detail]
        qemu-kvm-2687  [003] d...50550079268391: kvm_entry: [detail]
        qemu-kvm-2687  [003] d...50550079280829: kvm_exit: [detail]
        qemu-kvm-2687  [003] d...50550079286028: kvm_entry: [detail]

Since TSC offset is not considered, these data cannot be merged. If this trace
data is shown like as follows, we will be able to understand the reason:

        qemu-kvm-2687  [003] d...50550079203669: kvm_exit: [detail]
        qemu-kvm-2687  [003] d...50550079206816: kvm_entry: [detail]
            comm-3826  [000] d.h.49836825726903: sched_wakeup: [detail] <=
        qemu-kvm-2687  [003] d...50550079240656: kvm_exit: [detail]
        qemu-kvm-2687  [003] d...50550079243467: kvm_entry: [detail]
        qemu-kvm-2687  [003] d...50550079256103: kvm_exit: [detail]
        qemu-kvm-2687  [003] d...50550079268391: kvm_entry: [detail]
            comm-3826  [000] d...49836832225344: sched_switch: [detail] <=
        qemu-kvm-2687  [003] d...50550079280829: kvm_exit: [detail]
        qemu-kvm-2687  [003] d...50550079286028: kvm_entry: [detail]

In this case, we can understand wakeup-latency was big due to exit to host
twice. Getting this data sorted in chronological order is our goal.

To merge the data like previous pattern, we apply this patch set. Then, we can
get TSC offset of the guest as follows:

$ dmesg | grep kvm
[   57.717180] kvm: (2687) write TSC offset 18446743360465545001, now clock ##
                     ^^^^                   ^^^^^^^^^^^^^^^^^^^^            |
                     PID                         TSC offset                 |
                                                           HOST TSC value --+	

We use this TSC offset value to a merge script and obtain the following data:

$ ./trace-merge.pl 18446743360465545001 host.data guest.data
h        qemu-kvm-2687  [003] d...50550079203669: kvm_exit: [detail]
h        qemu-kvm-2687  [003] d...50550079206816: kvm_entry: [detail]
g            comm-3826  [000] d.h.50550079226331: sched_wakeup: [detail] <=
h        qemu-kvm-2687  [003] d...50550079240656: kvm_exit: [detail]
h        qemu-kvm-2687  [003] d...50550079243467: kvm_entry: [detail]
h        qemu-kvm-2687  [003] d...50550079256103: kvm_exit: [detail]
h        qemu-kvm-2687  [003] d...50550079268391: kvm_entry: [detail]
g            comm-3826  [000] d...50550079279266: sched_switch: [detail] <=
h        qemu-kvm-2687  [003] d...50550079280829: kvm_exit: [detail]
h        qemu-kvm-2687  [003] d...50550079286028: kvm_entry: [detail]
|
\----guest/host

In this summary, I suggest the patch which TSC offset for each guest can be
output on the host.

I chose printk() to output TSC offset value, but I think this is not the best
method. For example, defining as a tracepoint is one of the methods. In the
case, multiple buffers are needed to keep these data.

I need your comments, thanks!
---

Yoshihiro YUNOMAE (2):
      kvm/vmx: Print TSC_OFFSET information when TSC offset value is written to VMCS
      tools: Add a tool for merging trace data of a guest and a host


 arch/x86/kvm/vmx.c                       |    5 +
 tools/scripts/trace-merge/trace-merge.pl |  109 ++++++++++++++++++++++++++++++
 2 files changed, 114 insertions(+)
 create mode 100755 tools/scripts/trace-merge/trace-merge.pl

-- 
Yoshihiro YUNOMAE
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: yoshihiro.yunomae.ez@hitachi.com

