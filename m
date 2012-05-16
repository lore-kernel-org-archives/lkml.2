Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965294Ab2EPHwA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 03:52:00 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:56818 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S932713Ab2EPHvy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 03:51:54 -0400
X-IronPort-AV: E=Sophos;i="4.75,602,1330876800"; 
   d="scan'208";a="4967630"
Message-ID: <4FB35C48.30708@cn.fujitsu.com>
Date: Wed, 16 May 2012 15:50:32 +0800
From: zhangyanfei <zhangyanfei@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100413 Fedora/3.0.4-2.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>, mtosatti@redhat.com
CC: ebiederm@xmission.com, luto@mit.edu, Joerg Roedel <joerg.roedel@amd.com>,
        dzickus@redhat.com, paul.gortmaker@windriver.com,
        ludwig.nussel@suse.de, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, kexec@lists.infradead.org,
        Greg KH <gregkh@linuxfoundation.org>
Subject: [PATCH v2 0/5] Export offsets of VMCS fields as note information
 for kdump
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/05/16 15:50:35,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/05/16 15:50:41,
	Serialize complete at 2012/05/16 15:50:41
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=GB2312
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set exports offsets of VMCS fields as note information for
kdump. We call it VMCSINFO. The purpose of VMCSINFO is to retrieve
runtime state of guest machine image, such as registers, in host
machine's crash dump as VMCS format. The problem is that VMCS internal
is hidden by Intel in its specification. So, we slove this problem
by reverse engineering implemented in this patch set. The VMCSINFO
is exported via sysfs to kexec-tools just like VMCOREINFO.

Here are two usercases for two features that we want.

1) Create guest machine's crash dumpfile from host machine's crash dumpfile

In general, we want to use this feature on failure analysis for the system
where the processing depends on the communication between host and guest
machines to look into the system from both machines's viewpoints.

As a concrete situation, consider where there's heartbeat monitoring
feature on the guest machine's side, where we need to determine in
which machine side the cause of heartbeat stop lies. In our actual
experiments, we encountered such situation and we found the cause of
the bug was in host's process schedular so guest machine's vcpu stopped
for a long time and then led to heartbeat stop.

The module that judges heartbeat stop is on guest machine, so we need
to debug guest machine's data. But if the cause lies in host machine
side, we need to look into host machine's crash dump.

Without this feature, we first create guest machine's dump and then
create host mahine's, but there's only a short time between two
processings, during which it's unlikely that buggy situation remains.

So, we think the feature is useful to debug both guest machine's and
host machine's sides at the same time, and expect we can make failure
analysis efficiently.

Of course, we believe this feature is commonly useful on the situation
where guest machine doesn't work well due to something of host machine's.

2) Get offsets of VMCS information on the CPU running on the host machine

If kdump doesn't work well, then it means we cannot use kvm API to get
register values of guest machine and they are still left on its vmcs
region. In the case, we use crash dump mechanism running outside of
linux kernel, such as sadump, a firmware-based crash dump. Then VMCS
information is then necessary.

TODO:
  1. In kexec-tools, get VMCSINFO via sysfs and dump it as note information
     into vmcore.
  2. Dump VMCS region of each guest vcpu and VMCSINFO into qemu-process
     core file. To do this, we will modify kernel core dumper, gdb gcore
     and crash gcore.
  3. Dump guest image from the qemu-process core file into a vmcore.

Changelog for v1 to v2:
1. The VMCSINFO now has a simple binary <field><encoded offset> format,
   as below:
     +-------------+--------------------------+
     | Byte offset | Contents                 |
     +-------------+--------------------------+
     | 0           | VMCS revision identifier |
     +-------------+--------------------------+
     | 4           | <field><encoded offset>  |
     +-------------+--------------------------+
     | 16          | <field><encoded offset>  |
     +-------------+--------------------------+
     ......
  
   The first 32 bits of VMCSINFO contains the VMCS revision identifier.
   The remainder of VMCSINFO is used for <field><encoded offset> sets.
   Each set takes 12 bytes: field occupys 4 bytes and its corresponding
   encoded offset occupys 8 bytes.

   Encoded offsets are raw values read by vmcs_read{16, 64, 32, l}, and
   they are all unsigned extended to 8 bytes for each <field><encoded offset>
   set will have the same size. 
   We do not decode offsets here. The decoding work is delayed in userspace
   tools for more flexible handling.
   
   And here are two examples of the new VMCSINFO:
   Processor: Intel(R) Core(TM)2 Duo CPU     E7500  @ 2.93GHz
   VMCSINFO contains:
     <0000000d>                   --> VMCS revision id = 0xd
     <00004000><0000000001840180> --> OFFSET(PIN_BASED_VM_EXEC_CONTROL) = 0x01840180
     <00004002><0000000001940190> --> OFFSET(CPU_BASED_VM_EXEC_CONTROL) = 0x01940190
     <0000401e><000000000fe40fe0> --> OFFSET(SECONDARY_VM_EXEC_CONTROL) = 0x0fe40fe0
     <0000400c><0000000001e401e0> --> OFFSET(VM_EXIT_CONTROLS) = 0x01e401e0
     ......

   Processor: Intel(R) Xeon(R) CPU           E7540  @ 2.00GHz (24 cores)
   VMCSINFO contains:
     <0000000e>                   --> VMCS revision id = 0xe 
     <00004000><0000000005540550> --> OFFSET(PIN_BASED_VM_EXEC_CONTROL) = 0x05540550
     <00004002><0000000005440540> --> OFFSET(CPU_BASED_VM_EXEC_CONTROL) = 0x05440540
     <0000401e><00000000054c0548> --> OFFSET(SECONDARY_VM_EXEC_CONTROL) = 0x054c0548
     <0000400c><00000000057c0578> --> OFFSET(VM_EXIT_CONTROLS) = 0x057c0578
     ......

2. Add a new kernel module *vmcsinfo-intel* for filling VMCSINFO instead
   of putting it in module kvm-intel. The new module is auto-loaded
   when the vmx cpufeature is detected and it depends on module kvm-intel.
   *Loading and unloading this module will have no side effect on the
   running guests.*
3. The sysfs file vmcsinfo is splitted into 2 files:
   /sys/kernel/vmcsinfo: shows physical address of VMCSINFO note information.
   /sys/kernel/vmcsinfo_maxsize: shows max size of VMCSINFO.
4. A new Documentation/ABI entry is added for vmcsinfo and vmcsinfo_maxsize.
5. Do not update VMCSINFO note when the kernel is panicked.

zhangyanfei (5):
  x86: Add helper variables and functions to hold VMCSINFO
  KVM: Export symbols for module vmcsinfo-intel
  KVM-INTEL: Add new module vmcsinfo-intel to fill VMCSINFO
  ksysfs: Export VMCSINFO via sysfs
  Documentation: Add ABI entry for sysfs file vmcsinfo and
    vmcsinfo_maxsize

 Documentation/ABI/testing/sysfs-kernel-vmcsinfo |   16 +
 arch/x86/include/asm/vmcsinfo.h                 |   34 ++
 arch/x86/include/asm/vmx.h                      |  133 ++++++++
 arch/x86/kernel/Makefile                        |    2 +
 arch/x86/kernel/vmcsinfo.c                      |   79 +++++
 arch/x86/kvm/Kconfig                            |   11 +
 arch/x86/kvm/Makefile                           |    3 +
 arch/x86/kvm/vmcsinfo.c                         |  402 +++++++++++++++++++++++
 arch/x86/kvm/vmx.c                              |  151 ++-------
 include/linux/kvm_host.h                        |    3 +
 kernel/ksysfs.c                                 |   29 ++
 virt/kvm/kvm_main.c                             |    8 +-
 12 files changed, 740 insertions(+), 131 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-kernel-vmcsinfo
 create mode 100644 arch/x86/include/asm/vmcsinfo.h
 create mode 100644 arch/x86/kernel/vmcsinfo.c
 create mode 100644 arch/x86/kvm/vmcsinfo.c
