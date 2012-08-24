Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756841Ab2HXBPp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 21:15:45 -0400
Received: from e06smtp10.uk.ibm.com ([195.75.94.106]:38502 "EHLO
	e06smtp10.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754456Ab2HXBPk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 21:15:40 -0400
From: Dong Hao <haodong@linux.vnet.ibm.com>
To: avi@redhat.com, acme@infradead.org, mtosatti@redhat.com, mingo@elte.hu
Cc: xiaoguangrong@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: [PATCH v7 0/3] KVM: perf: kvm events analysis tool
Date: Fri, 24 Aug 2012 09:15:26 +0800
Message-Id: <1345770929-13667-1-git-send-email-haodong@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.2.5
x-cbid: 12082401-4966-0000-0000-0000034E69E8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>

Changelog:
- rebased it on Arnaldo's git tree perf/core branch

the change from Arnaldo's comments:
- directly get event from evsel->tp_format
- remove die() and return the proper error code
- rename thread->private to thread->priv

the change from David's comments:
- use is_valid_tracepoint instead of kvm_events_exist 

This patchset introduces a perf-based tool (perf kvm stat record/report)
which can analyze kvm events more smartly. Below is the presentation slice
on 2012 Japan LinuxCon:
http://events.linuxfoundation.org/images/stories/pdf/lcjp2012_guangrong.pdf
You can get more details from it. If any questions/comments, please feel free
to let us know.

This patchset is based on Arnaldo's git tree perf/core branch, and patch 2
is just doing the "improvement" work, which can be picked up independently.


Usage:
- kvm stat
  run a command and gather performance counter statistics, it is the alias of
  perf stat

- trace kvm events:
  perf kvm stat record, or, if other tracepoints are interesting as well, we
  can append the events like this:
  perf kvm stat record -e kvm:*
  If many guests are running, we can track the specified guest by using -p or
  --pid

- show the result:
  perf kvm stat report

The output example is following:
# pgrep qemu-kvm
26071
32253
32564

total 3 guests are running on the host

Then, track the guest whose pid is 26071:
# ./perf kvm stat record -p 26071
^C[ perf record: Woken up 9 times to write data ]
[ perf record: Captured and wrote 24.903 MB perf.data.guest (~1088034 samples) ]

See the vmexit events:
# ./perf kvm stat report --event=vmexit

Analyze events for all VCPUs:

             VM-EXIT    Samples  Samples%     Time%         Avg time

         APIC_ACCESS      65381    66.58%     5.95%     37.72us ( +-   6.54% )
  EXTERNAL_INTERRUPT      16031    16.32%     3.06%     79.11us ( +-   7.34% )
               CPUID       5360     5.46%     0.06%      4.50us ( +-  35.07% )
                 HLT       4496     4.58%    90.75%   8360.34us ( +-   5.22% )
       EPT_VIOLATION       2667     2.72%     0.04%      5.49us ( +-   5.05% )
   PENDING_INTERRUPT       2242     2.28%     0.03%      5.25us ( +-   2.96% )
       EXCEPTION_NMI       1332     1.36%     0.02%      6.53us ( +-   6.51% )
      IO_INSTRUCTION        383     0.39%     0.09%     93.39us ( +-  40.92% )
           CR_ACCESS        310     0.32%     0.00%      6.10us ( +-   3.95% )

Total Samples:98202, Total events handled time:41419293.63us.

See the mmio events:
# ./perf kvm stat report --event=mmio

Analyze events for all VCPUs:

         MMIO Access    Samples  Samples%     Time%         Avg time

        0xfee00380:W      58686    90.21%    15.67%      4.95us ( +-   2.96% )
        0xfee00300:R       2124     3.26%     1.48%     12.93us ( +-  14.75% )
        0xfee00310:W       2124     3.26%     0.34%      3.00us ( +-   1.33% )
        0xfee00300:W       2123     3.26%    82.50%    720.68us ( +-  10.24% )

Total Samples:65057, Total events handled time:1854470.45us.

See the ioport event:
# ./perf kvm stat report --event=ioport

Analyze events for all VCPUs:

      IO Port Access    Samples  Samples%     Time%         Avg time

         0xc090:POUT        383   100.00%   100.00%     89.00us ( +-  42.94% )

Total Samples:383, Total events handled time:34085.56us.

And, --vcpu is used to track the specified vcpu and --key is used to sort the
result:
# ./perf kvm stat report --event=vmexit --vcpu=0 --key=time

Analyze events for VCPU 0:

             VM-EXIT    Samples  Samples%     Time%         Avg time

                 HLT        551     5.05%    94.81%   9501.72us ( +-  12.52% )
  EXTERNAL_INTERRUPT       1390    12.74%     2.39%     94.80us ( +-  20.92% )
         APIC_ACCESS       6186    56.68%     2.62%     23.41us ( +-  23.62% )
      IO_INSTRUCTION         17     0.16%     0.01%     20.39us ( +-  22.33% )
       EXCEPTION_NMI         94     0.86%     0.01%      6.07us ( +-   7.13% )
   PENDING_INTERRUPT        199     1.82%     0.02%      5.48us ( +-   4.36% )
           CR_ACCESS         52     0.48%     0.00%      4.89us ( +-   4.09% )
       EPT_VIOLATION       2057    18.85%     0.12%      3.15us ( +-   1.33% )
               CPUID        368     3.37%     0.02%      2.82us ( +-   2.79% )

Total Samples:10914, Total events handled time:5521782.02us.


Dong Hao (3):
  KVM: x86: export svm/vmx exit code and vector code to userspace
  KVM: x86: trace mmio begin and complete
  KVM: perf: kvm events analysis tool

 arch/x86/include/asm/kvm_host.h       |   36 +-
 arch/x86/include/asm/svm.h            |  205 +++++---
 arch/x86/include/asm/vmx.h            |  126 +++--
 arch/x86/kvm/trace.h                  |   89 ----
 arch/x86/kvm/x86.c                    |   32 +-
 include/trace/events/kvm.h            |   37 ++
 tools/perf/Documentation/perf-kvm.txt |   30 +-
 tools/perf/MANIFEST                   |    3 +
 tools/perf/builtin-kvm.c              |  889 ++++++++++++++++++++++++++++++++-
 tools/perf/util/header.c              |   54 ++-
 tools/perf/util/header.h              |    1 +
 tools/perf/util/thread.h              |    2 +
 12 files changed, 1264 insertions(+), 240 deletions(-)

-- 
1.7.2.5

