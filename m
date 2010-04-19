Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751727Ab0DSFc6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 01:32:58 -0400
Received: from mga09.intel.com ([134.134.136.24]:57900 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751117Ab0DSFc4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 01:32:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.52,234,1270450800"; 
   d="scan'208";a="614341899"
Subject: [PATCH V5 0/3] perf & kvm: Enhance perf to collect KVM guest os
 statistics from host side
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Avi Kivity <avi@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Avi Kivity <avi@redhat.com>, Sheng Yang <sheng@linux.intel.com>,
       linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
       Marcelo Tosatti <mtosatti@redhat.com>, oerg Roedel <joro@8bytes.org>,
       Jes Sorensen <Jes.Sorensen@redhat.com>, Gleb Natapov <gleb@redhat.com>,
       Zachary Amsden <zamsden@redhat.com>, zhiteng.huang@intel.com,
       tim.c.chen@intel.com, Arnaldo Carvalho de Melo <acme@infradead.org>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Mon, 19 Apr 2010 13:32:34 +0800
Message-Id: <1271655154.2078.602.camel@ymzhang.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 (2.28.0-2.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here is the new patch of V5 against tip/master of April 17th
if anyone wants to try it.

ChangeLog V5:
        1) Split kernel patch to 2 parts. The one introduces
	perf_guest_info_callbacks() and related register/unregister
	functions. The other is the kvm implementation of the callbacks.
	2) Port to tip/master tree of April 17th.
	3) Fix a bug which causes the module parsing of default guest kernel
	fail.

ChangeLog V4:
        1) Based on Ingo's comments, I added help information around kvm
        such like command-list.txt and perf-kvm.txt.
        2) Added guest process id at the tail of kernel dso long name, so
        the display could show different label with different guest os.
        3) Based on Avi's comments, erase the racy window which might
        trigger an NMI while the NMI isn't in guest os.
        4) Fixed all the errors and warnings reported by scripts/checkpatch.pl.
        5) Fixed a compilation error pointed by Yang Sheng.

ChangeLog V3:
        1) Add --guestmount=/dir/to/all/guestos parameter. Admin mounts guest os
        root directories under /dir/to/all/guestos by sshfs. For example, I start
        2 guest os. The one's pid is 8888 and the other's is 9999.
        #mkdir ~/guestmount; cd ~/guestmount
        #sshfs -o allow_other,direct_io -p 5551 localhost:/ 8888/
        #sshfs -o allow_other,direct_io -p 5552 localhost:/ 9999/
        #perf kvm --host --guest --guestmount=~/guestmount top

        The old --guestkallsyms and --guestmodules are still supported as default
        guest os symbol parsing.

        2) Add guest os buildid support.
        3) Add sub command 'perf kvm buildid-list'.
        4) Delete sub command 'perf kvm stat', because our current implementation
        doesn't transfer guest/host requirement to kernel, and kernel always
        collects both host and guest statistics. So regular 'perf stat' is ok.
        5) Fix a couple of perf bugs.
        6) We still have no support on command with parameter 'any' as current KVM
        just uses process id to identify specific guest os instance. Users could
        uses parameter -p to collect specific guest os instance statistics.

ChangeLog V2:
        1) Based on Avi's suggestion, I moved callback functions
        to generic code area. So the kernel part of the patch is
        clearer.
        2) Add 'perf kvm stat'.


From: Zhang, Yanmin <yanmin_zhang@linux.intel.com>

Based on the discussion in KVM community, I worked out the patch to support
perf to collect guest os statistics from host side. This patch is implemented
with Ingo, Peter and some other guys' kind help. Yang Sheng pointed out a
critical bug and provided good suggestions with other guys. I really appreciate
their kind help.

The patch adds new sub command kvm to perf.

  perf kvm top
  perf kvm record
  perf kvm report
  perf kvm diff
  perf kvm buildid-list

The new perf could profile guest os kernel except guest os user space, but it
could summarize guest os user space utilization per guest os.

Below are some examples.
1) perf kvm top
[root@lkp-ne01 norm]# perf kvm --host --guest --guestkallsyms=/home/ymzhang/guest/kallsyms
--guestmodules=/home/ymzhang/guest/modules top

---------------------------------------------------------------------------------------------------------------------------------------
   PerfTop:   16024 irqs/sec  kernel: 2.6% us: 0.6% guest kernel:76.2% guest us:20.6% exact:  0.0% [1000Hz cycles],  (all, 16 CPUs)
---------------------------------------------------------------------------------------------------------------------------------------

             samples  pcnt function                 DSO
             _______ _____ ________________________ _______________________

             3740.00  8.0% __ticket_spin_lock       [guest.kernel.kallsyms]
             2056.00  4.4% copy_user_generic_string [guest.kernel.kallsyms]
             1412.00  3.0% resource_string          [guest.kernel.kallsyms]
              595.00  1.3% __switch_to              [guest.kernel.kallsyms]
              586.00  1.2% __d_lookup               [guest.kernel.kallsyms]
              574.00  1.2% tcp_sendmsg              [guest.kernel.kallsyms]
              565.00  1.2% kmem_cache_alloc         [guest.kernel.kallsyms]
              532.00  1.1% tcp_ack                  [guest.kernel.kallsyms]
              494.00  1.1% __kmalloc                [guest.kernel.kallsyms]
              468.00  1.0% print_cfs_rq             [guest.kernel.kallsyms]
              437.00  0.9% link_path_walk           [guest.kernel.kallsyms]
              380.00  0.8% balance_runtime          [guest.kernel.kallsyms]
              379.00  0.8% kmem_cache_free          [guest.kernel.kallsyms]
              377.00  0.8% in_gate_area_no_task     [guest.kernel.kallsyms]
              374.00  0.8% get_page_from_freelist   [guest.kernel.kallsyms]
              372.00  0.8% mark_files_ro            [guest.kernel.kallsyms]
              368.00  0.8% _atomic_dec_and_lock     [guest.kernel.kallsyms]
              356.00  0.8% crc16                    [crc16]
              353.00  0.8% put_page                 [guest.kernel.kallsyms]

If you want to just show host data, pls. don't use parameter --guest.
The headline includes guest os kernel and userspace percentage.

2) perf kvm record
[root@lkp-ne01 norm]# perf kvm --host --guest --guestkallsyms=/home/ymzhang/guest/kallsyms
--guestmodules=/home/ymzhang/guest/modules record -f -a sleep 60
[ perf record: Woken up 15 times to write data ]
[ perf record: Captured and wrote 29.385 MB perf.data.kvm (~1283837 samples) ]

3) perf kvm report
        3.1) [root@lkp-ne01 norm]# perf kvm --host --guest --guestkallsyms=/home/ymzhang/guest/kallsyms
--guestmodules=/home/ymzhang/guest/modules report --sort pid --showcpuutilization>norm.host.guest.report.pid
# Samples: 424719292247
#
# Overhead  sys    us    guest sys    guest us            Command:  Pid
# ........  .....................
#
    50.57%     1.02%     0.00%    39.97%     9.58%  qemu-system-x86: 3587
    49.32%     1.35%     0.01%    35.20%    12.76%  qemu-system-x86: 3347
     0.07%     0.07%     0.00%     0.00%     0.00%             perf: 5217


Some performance guys require perf to show sys/us/guest_sys/guest_us per KVM guest
instance which is actually just a multi-threaded process. Above sub parameter --showcpuutilization
does so.

        3.2) [root@lkp-ne01 norm]# perf kvm --host --guest --guestkallsyms=/home/ymzhang/guest/kallsyms
--guestmodules=/home/ymzhang/guest/modules report >norm.host.guest.report
# Samples: 2466991384118
#
# Overhead          Command                                                             Shared Object  Symbol
# ........  ...............  ........................................................................  ......
#
    29.11%  qemu-system-x86  [guest.kernel.kallsyms]                                                   [g] __ticket_spin_lock
     5.88%       tbench_srv  [kernel.kallsyms]                                                         [k] ftrace_likely_update
     5.76%           tbench  [kernel.kallsyms]                                                         [k] ftrace_likely_update
     3.88%  qemu-system-x86                                                                34c3255482  [u] 0x000034c3255482
     1.83%           tbench  [kernel.kallsyms]                                                         [k] __lock_acquire
     1.81%       tbench_srv  [kernel.kallsyms]                                                         [k] __lock_acquire
     1.38%       tbench_srv  [kernel.kallsyms]                                                         [k] trace_hardirqs_off_caller
     1.37%           tbench  [kernel.kallsyms]                                                         [k] trace_hardirqs_off_caller
     1.13%  qemu-system-x86  [guest.kernel.kallsyms]                                                   [g] copy_user_generic_string
     1.04%       tbench_srv  [kernel.kallsyms]                                                         [k] validate_chain
     1.00%           tbench  [kernel.kallsyms]                                                         [k] trace_hardirqs_on_caller
     1.00%       tbench_srv  [kernel.kallsyms]                                                         [k] trace_hardirqs_on_caller
     0.95%           tbench  [kernel.kallsyms]                                                         [k] do_raw_spin_lock


[u] means it's in guest os user space. [g] means in guest os kernel. Other info is very direct.
If it shows a module such like [ext4], it means guest kernel module, because native host kernel's
modules are start from something like /lib/modules/XXX.

4) --guestmount example. I started 2 guest os. Run dbench testing in the 1st and tbench in 2nd guest os.
[root@lkp-ne01 norm]#perf kvm --host --guest --guestmount=/home/ymzhang/guestmount/ top
---------------------------------------------------------------------------------------------------------------------------------------
   PerfTop:   16014 irqs/sec  kernel: 1.8% us: 0.0% guest kernel:75.5% guest us:22.7% exact:  0.0% [1000Hz cycles],  (all, 16 CPUs)
---------------------------------------------------------------------------------------------------------------------------------------

             samples  pcnt function                 DSO
             _______ _____ ________________________ ________________________________________________________________

            16583.00  9.3% __ticket_spin_lock       [guest.kernel.kallsyms.3067]
             7178.00  4.0% copy_user_generic_string [guest.kernel.kallsyms.3067]
             4637.00  2.6% copy_user_generic_string [guest.kernel.kallsyms.3187]
             2495.00  1.4% schedule                 [guest.kernel.kallsyms.3187]
             2322.00  1.3% tcp_sendmsg              [guest.kernel.kallsyms.3187]
             2255.00  1.3% __d_lookup               [guest.kernel.kallsyms.3067]
             1892.00  1.1% __switch_to              [guest.kernel.kallsyms.3187]
             1884.00  1.1% kmem_cache_alloc         [guest.kernel.kallsyms.3067]
             1809.00  1.0% tcp_ack                  [guest.kernel.kallsyms.3187]
             1733.00  1.0% _atomic_dec_and_lock     [guest.kernel.kallsyms.3067]
             1707.00  1.0% tcp_transmit_skb         [guest.kernel.kallsyms.3187]
             1612.00  0.9% tcp_recvmsg              [guest.kernel.kallsyms.3187]
             1546.00  0.9% __kmalloc                [guest.kernel.kallsyms.3067]
             1538.00  0.9% __ticket_spin_lock       [guest.kernel.kallsyms.3187]
             1467.00  0.8% link_path_walk           [guest.kernel.kallsyms.3067]
             1403.00  0.8% path_get                 [guest.kernel.kallsyms.3067]

Signed-off-by: Zhang Yanmin <yanmin_zhang@linux.intel.com>



