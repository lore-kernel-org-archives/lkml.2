Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760134Ab2HJDTt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 23:19:49 -0400
Received: from e06smtp12.uk.ibm.com ([195.75.94.108]:43548 "EHLO
	e06smtp12.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759020Ab2HJDTr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 23:19:47 -0400
From: Dong Hao <haodong@linux.vnet.ibm.com>
To: avi@redhat.com, acme@infradead.org
Cc: mtosatti@redhat.com, mingo@elte.hu, dsahern@gmail.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Subject: [PATCH v6 0/3] KVM: perf: kvm events analysis tool
Date: Fri, 10 Aug 2012 11:19:07 +0800
Message-Id: <1344568750-5147-1-git-send-email-haodong@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.2.5
x-cbid: 12081003-8372-0000-0000-0000036D9A8C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Xiao Guangrong<xiaoguangrong@linux.vnet.ibm.com>

This patchset introduces a perf-based tool (perf kvm stat record/report)
which can analysis kvm events more smartly. This is a presentation on
2012 Japan LinuxCon:
http://events.linuxfoundation.org/images/stories/pdf/lcjp2012_guangrong.pdf
You can get more detail from it. Any question/comment please feel free let
us know.

Patch 1 and patch 3 can be applied to either tip tree or kvm tree, but patch 2
can only be applied to kvm tree. Fortunately, patch 2 is just doing the
"improvement" work, and it can be picked up independently.

Usage:
- kvm stat
  run a command and gather performance counter statistics, it is the alias of
  perf stat

- trace kvm events:
  perf kvm stat record, or, if other tracepoints are interesting as well, we
  can append the events like this:
  perf kvm stat record -e timer:*
  If many guests are running, we can track the specified guest by using -p or
  --pid

- show the result:
  perf kvm stat report

The output example is following:
# pgrep qemu-kvm
27841
27888
27936

total 3 guests are running on the host

Then, track the guest whose pid is 27936:
# ./perf kvm stat record -p 27936
^C[ perf record: Woken up 1 times to write data ]
[ perf record: Captured and wrote 0.177 MB perf.data.guest (~7742 samples) ]

See the vmexit events:
# ./perf kvm stat report --event=vmexit


Analyze events for all VCPUs:

             VM-EXIT    Samples  Samples%     Time%         Avg time

         APIC_ACCESS        237    80.34%     0.01%     20.86us ( +-   8.03% )
                 HLT         45    15.25%    99.98% 790874.75us ( +-  16.93% )
  EXTERNAL_INTERRUPT         11     3.73%     0.00%     47.70us ( +-  17.45% )
       EXCEPTION_NMI          1     0.34%     0.00%      5.11us ( +-   -nan% )
           CR_ACCESS          1     0.34%     0.00%      6.33us ( +-   -nan% )

Total Samples:295, Total events handled time:35594844.34us.

See the mmio events:
# ./perf kvm stat report --event=mmio


Analyze events for all VCPUs:

         MMIO Access    Samples  Samples%     Time%         Avg time

        0xfee00380:W        151    82.07%    76.19%      7.72us ( +-  11.96% )
        0xfee00300:W         11     5.98%    18.86%     26.23us ( +-  27.33% )
        0xfee00300:R         11     5.98%     2.16%      3.00us ( +-   9.17% )
        0xfee00310:W         11     5.98%     2.79%      3.88us ( +-   9.15% )

Total Samples:184, Total events handled time:1529.42us.

See the ioport event:
# ./perf kvm stat report --event=ioport


Analyze events for all VCPUs:

      IO Port Access    Samples  Samples%     Time%         Avg time

          0x5658:PIN       3357    55.22%    92.13%    162.31us ( +-   0.87% )
         0xc090:POUT       1221    20.09%     2.10%     10.18us ( +-   4.97% )
            0x60:PIN        748    12.30%     3.18%     25.17us ( +-   5.01% )
            0x64:PIN        748    12.30%     2.57%     20.35us ( +-  11.81% )
         0xc050:POUT          5     0.08%     0.01%      8.79us ( +-  12.88% )

Total Samples:6079, Total events handled time:591405.43us.

And, --vcpu is used to track the specified vcpu and --key is used to sort the
result:
# ./perf kvm stat report --event=ioport --vcpu=0 --key=time


Analyze events for VCPU 0:

      IO Port Access    Samples  Samples%     Time%         Avg time

          0x5658:PIN        145    94.77%    99.67%    133.00us ( +-   2.96% )
         0xc090:POUT          8     5.23%     0.33%      7.99us ( +-  16.85% )

Total Samples:153, Total events handled time:19348.87us.

Changelog:
- merge "perf kvm-events" into perf "perf kvm stat" as Ingo's suggestion
- track kvm events for the specified guest
- rename kvm_mmio_done to kvm_io_done
- fix compiling-error on i386


Dong Hao (3):
  KVM: x86: export svm/vmx exit code and vector code to userspace
  KVM: x86: tracemmio begin and complete
  KVM: perf kvm events analysis tool

 arch/x86/include/asm/kvm_host.h       |   36 +-
 arch/x86/include/asm/svm.h            |  205 +++++---
 arch/x86/include/asm/vmx.h            |  126 ++++--
 arch/x86/kvm/trace.h                  |   89 ----
 arch/x86/kvm/x86.c                    |   32 +-
 include/trace/events/kvm.h            |   37 ++
 tools/perf/Documentation/perf-kvm.txt |   30 ++-
 tools/perf/MANIFEST                   |    3 +
 tools/perf/builtin-kvm.c              |  858 ++++++++++++++++++++++++++++++++-
 tools/perf/util/header.c              |   55 ++-
 tools/perf/util/header.h              |    1 +
 tools/perf/util/thread.h              |    2 +
 12 files changed, 1234 insertions(+), 240 deletions(-)

-- 
1.7.2.5

