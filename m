Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753204Ab1GZPJc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 11:09:32 -0400
Received: from static-98-110-176-133.bstnma.fios.verizon.net ([98.110.176.133]:4255
	"EHLO smtp.digitalreefinc.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751573Ab1GZPJ2 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 11:09:28 -0400
From: Jatinder Dua <jdua@digitalreefinc.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 26 Jul 2011 11:09:03 -0400
Subject: PROBLEM: task goes into uniterruptible sleep
Thread-Topic: PROBLEM: task goes into uniterruptible sleep
Thread-Index: AcxLpfT202lvmZv1SOSRdQtNFmi+Cg==
Message-ID: <BD1F491BE5FEB942A95DC075D99F15CA4F633FA20F@exch-be-01-prod.hq.aurarianetworks.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[1.] One line summary of the problem:  The task goes into uninterruptible sleep mode during some IO operation with NFS mounts and never comes out of it.
[2.] Full description of the problem/report:
Our application reads files off a nfs mount and also writes data to the nfs. In this particular case,
it was reading the data from one nas device and writing some data to another nas device.
The application runs without any problems on CentOS 5.6 and RHEL 5.6 however when we run the application on RHEL 6.1, one of the java threads of our application goes into uninterruptible sleep mode and from that point onwards, the application cannot function properly. The process that shows up as the one in uniterruptible sleep mode is shown below with its stack trace.

Jul 22 16:29:42 eng10 kernel: INFO: task java:11564 blocked for more than 120 seconds.
Jul 22 16:29:42 eng10 kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Jul 22 16:29:42 eng10 kernel: java          D 0000000000000005     0 11564  11562 0x00000080
Jul 22 16:29:42 eng10 kernel: ffff880d323df478 0000000000000082 ffff880d323df3d8 ffffffff810dbe3e
Jul 22 16:29:42 eng10 kernel: ffff880d323df4e8 00000000812684e0 ffff880d323df4b8 0000000000000000
Jul 22 16:29:42 eng10 kernel: ffff880d32136638 ffff880d323dffd8 000000000000f598 ffff880d32136638
Jul 22 16:29:42 eng10 kernel: Call Trace:
Jul 22 16:29:42 eng10 kernel: [<ffffffff810dbe3e>] ? call_rcu+0xe/0x10
Jul 22 16:29:42 eng10 kernel: [<ffffffff81098c99>] ? ktime_get_ts+0xa9/0xe0
Jul 22 16:29:42 eng10 kernel: [<ffffffff8110d320>] ? sync_page+0x0/0x50
Jul 22 16:29:42 eng10 kernel: [<ffffffff814db3c3>] io_schedule+0x73/0xc0
Jul 22 16:29:42 eng10 kernel: [<ffffffff8110d35d>] sync_page+0x3d/0x50
Jul 22 16:29:42 eng10 kernel: [<ffffffff814dbada>] __wait_on_bit_lock+0x5a/0xc0
Jul 22 16:29:42 eng10 kernel: [<ffffffff8110d2f7>] __lock_page+0x67/0x70
Jul 22 16:29:42 eng10 kernel: [<ffffffff8108e140>] ? wake_bit_function+0x0/0x50
Jul 22 16:29:42 eng10 kernel: [<ffffffff81123262>] ? pagevec_lookup+0x22/0x30
Jul 22 16:29:42 eng10 kernel: [<ffffffff81124a8c>] truncate_inode_pages_range+0x44c/0x460
Jul 22 16:29:42 eng10 kernel: [<ffffffff81124ab5>] truncate_inode_pages+0x15/0x20
Jul 22 16:29:42 eng10 kernel: [<ffffffff8118d20e>] generic_delete_inode+0x18e/0x1d0
Jul 22 16:29:42 eng10 kernel: [<ffffffff8118d2b5>] generic_drop_inode+0x65/0x80
Jul 22 16:29:42 eng10 kernel: [<ffffffff8118c122>] iput+0x62/0x70
Jul 22 16:29:42 eng10 kernel: [<ffffffffa050b09e>] nfs_dentry_iput+0x3e/0x60 [nfs]
Jul 22 16:29:42 eng10 kernel: [<ffffffff81188eac>] dentry_iput+0x7c/0x100
Jul 22 16:29:42 eng10 kernel: [<ffffffff81189021>] d_kill+0x31/0x60
Jul 22 16:29:42 eng10 kernel: [<ffffffff8118a90c>] dput+0x7c/0x150
Jul 22 16:29:42 eng10 kernel: [<ffffffff8117f5da>] path_put+0x1a/0x40
Jul 22 16:29:42 eng10 kernel: [<ffffffffa0511f62>] __put_nfs_open_context+0xc2/0xf0 [nfs]
Jul 22 16:29:42 eng10 kernel: [<ffffffffa0512040>] put_nfs_open_context+0x10/0x20 [nfs]
Jul 22 16:29:42 eng10 kernel: [<ffffffffa051afbc>] nfs_clear_request+0x5c/0x80 [nfs]
Jul 22 16:29:42 eng10 kernel: [<ffffffffa051afe0>] ? nfs_free_request+0x0/0x30 [nfs]
Jul 22 16:29:42 eng10 kernel: [<ffffffffa051affa>] nfs_free_request+0x1a/0x30 [nfs]
Jul 22 16:29:42 eng10 kernel: [<ffffffff812662c7>] kref_put+0x37/0x70
Jul 22 16:29:42 eng10 kernel: [<ffffffffa051af59>] nfs_release_request+0x19/0x20 [nfs]
Jul 22 16:29:42 eng10 kernel: [<ffffffffa051f3e3>] nfs_find_and_lock_request+0xb3/0xd0 [nfs]
Jul 22 16:29:42 eng10 kernel: [<ffffffffa051f4b1>] nfs_migrate_page+0x41/0xf0 [nfs]
Jul 22 16:29:42 eng10 kernel: [<ffffffff8115f9e8>] move_to_new_page+0x98/0x170
Jul 22 16:29:42 eng10 kernel: [<ffffffff8115fef4>] migrate_pages+0x434/0x4c0
Jul 22 16:29:42 eng10 kernel: [<ffffffff811560b0>] ? compaction_alloc+0x0/0x3e0
Jul 22 16:29:42 eng10 kernel: [<ffffffff811559bb>] compact_zone+0x4fb/0x780
Jul 22 16:29:42 eng10 kernel: [<ffffffff81155ee1>] compact_zone_order+0xa1/0xe0
Jul 22 16:29:42 eng10 kernel: [<ffffffff8115603c>] try_to_compact_pages+0x11c/0x190
Jul 22 16:29:42 eng10 kernel: [<ffffffff8111ff95>] __alloc_pages_nodemask+0x5f5/0x8b0
Jul 22 16:29:42 eng10 kernel: [<ffffffff811674d5>] ? mem_cgroup_charge_common+0xa5/0xd0
Jul 22 16:29:42 eng10 kernel: [<ffffffff8115475a>] alloc_pages_vma+0x9a/0x150
Jul 22 16:29:42 eng10 kernel: [<ffffffff8116cb18>] do_huge_pmd_wp_page+0x168/0x830
Jul 22 16:29:42 eng10 kernel: [<ffffffff81041594>] ? __do_page_fault+0x1e4/0x480
Jul 22 16:29:42 eng10 kernel: [<ffffffff81138394>] handle_mm_fault+0x234/0x2c0
Jul 22 16:29:42 eng10 kernel: [<ffffffff810414e9>] __do_page_fault+0x139/0x480
Jul 22 16:29:42 eng10 kernel: [<ffffffff814e054e>] ? do_page_fault+0x3e/0xa0
Jul 22 16:29:42 eng10 kernel: [<ffffffff814dd8d5>] ? page_fault+0x25/0x30
Jul 22 16:29:42 eng10 kernel: [<ffffffff814e054e>] do_page_fault+0x3e/0xa0
Jul 22 16:29:42 eng10 kernel: [<ffffffff814dd8d5>] page_fault+0x25/0x30


[3.] Keywords (i.e., modules, networking, kernel): kernel nfs uninterruptible sleep

[4.] Kernel version (from /proc/version): Linux version 2.6.32-131.0.15.el6.x86_64 (mockbuild@x86-007.build.bos.redhat.com) (gcc version 4.4.4 20100726 (Red Hat 4.4.4-13) (GCC) ) #1 SMP Tue May 10 15:42:40 EDT 2011

[5.] Output of Oops.. message (if applicable) with symbolic information
     resolved (see Documentation/oops-tracing.txt) N/A

[6.] A small shell script or example program which triggers the
     problem (if possible) - The problem occurs when our software application is running and doing the IO and it wont be possible for me to provide a shell script for reproducing the problem.
[7.] Environment
[7.1.] Software (add the output of the ver_linux script here)

If some fields are empty or look unusual you may have an old version.
Compare to the current minimal requirements in Documentation/Changes.

Linux qacae01.englab.digitalreefinc.com 2.6.32-131.0.15.el6.x86_64 #1 SMP Tue May 10 15:42:40 EDT 2011 x86_64 x86_64 x86_64 GNU/Linux

Gnu C                  ./ver_linux:
Gnu make               3.81
binutils               2.20.51.0.2
5.20.
util-linux             2.17.2
mount                  support
module-init-tools      3.9
e2fsprogs              1.41.12
pcmciautils            015
quota-tools            3.17.
Linux C Library        2.12
Dynamic linker (ldd)   2.12
Procps                 3.2.8
Net-tools              1.60
Kbd                    1.15
oprofile               0.9.6
Sh-utils               8.4
wireless-tools         29
Modules Loaded         fuse nfsd lockd nfs_acl auth_rpcgss exportfs autofs4 sunrpc p4_clockmod freq_table speedstep_lib ipv6 dm_mirror dm_region_hash dm_log ses enclosure bnx2 dcdbas microcode serio_raw sg ghes hed iTCO_wdt iTCO_vendor_support i5k_amb i5000_edac edac_core shpchp ext4 mbcache jbd2 sd_mod crc_t10dif sr_mod cdrom megaraid_sas ata_generic pata_acpi ata_piix radeon ttm drm_kms_helper drm hwmon i2c_algo_bit i2c_core dm_mod

[7.2.] Processor information (from /proc/cpuinfo):
processor      : 0
vendor_id      : GenuineIntel
cpu family     : 6
model          : 15
model name     : Intel(R) Xeon(R) CPU           X7350  @ 2.93GHz
stepping       : 11
cpu MHz        : 2933.337
cache size     : 4096 KB
physical id    : 0
siblings       : 4
core id        : 0
cpu cores      : 4
apicid         : 0
initial apicid : 0
fpu            : yes
fpu_exception  : yes
cpuid level    : 10
wp             : yes
flags          : fpu vme de pse tsc msr pae mce cx8 apic mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx lm constant_tsc arch_perfmon pebs bts rep_good aperfmperf pni dtes64 monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr pdcm dca lahf_lm tpr_shadow vnmi flexpriority
bogomips       : 5852.61
clflush size   : 64
cache_alignment : 64
address sizes  : 40 bits physical, 48 bits virtual
power management:

processor      : 1
vendor_id      : GenuineIntel
cpu family     : 6
model          : 15
model name     : Intel(R) Xeon(R) CPU           X7350  @ 2.93GHz
stepping       : 11
cpu MHz        : 2933.337
cache size     : 4096 KB
physical id    : 2
siblings       : 4
core id        : 0
cpu cores      : 4
apicid         : 8
initial apicid : 8
fpu            : yes
fpu_exception  : yes
cpuid level    : 10
wp             : yes
flags          : fpu vme de pse tsc msr pae mce cx8 apic mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx lm constant_tsc arch_perfmon pebs bts rep_good aperfmperf pni dtes64 monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr pdcm dca lahf_lm tpr_shadow vnmi flexpriority
bogomips       : 5851.46
clflush size   : 64
cache_alignment : 64
address sizes  : 40 bits physical, 48 bits virtual
power management:

processor      : 2
vendor_id      : GenuineIntel
cpu family     : 6
model          : 15
model name     : Intel(R) Xeon(R) CPU           X7350  @ 2.93GHz
stepping       : 11
cpu MHz        : 2933.337
cache size     : 4096 KB
physical id    : 4
siblings       : 4
core id        : 0
cpu cores      : 4
apicid         : 16
initial apicid : 16
fpu            : yes
fpu_exception  : yes
cpuid level    : 10
wp             : yes
flags          : fpu vme de pse tsc msr pae mce cx8 apic mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx lm constant_tsc arch_perfmon pebs bts rep_good aperfmperf pni dtes64 monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr pdcm dca lahf_lm tpr_shadow vnmi flexpriority
bogomips       : 5851.45
clflush size   : 64
cache_alignment : 64
address sizes  : 40 bits physical, 48 bits virtual
power management:

processor      : 3
vendor_id      : GenuineIntel
cpu family     : 6
model          : 15
model name     : Intel(R) Xeon(R) CPU           X7350  @ 2.93GHz
stepping       : 11
cpu MHz        : 2933.337
cache size     : 4096 KB
physical id    : 6
siblings       : 4
core id        : 0
cpu cores      : 4
apicid         : 24
initial apicid : 24
fpu            : yes
fpu_exception  : yes
cpuid level    : 10
wp             : yes
flags          : fpu vme de pse tsc msr pae mce cx8 apic mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx lm constant_tsc arch_perfmon pebs bts rep_good aperfmperf pni dtes64 monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr pdcm dca lahf_lm tpr_shadow vnmi flexpriority
bogomips       : 5851.45
clflush size   : 64
cache_alignment : 64
address sizes  : 40 bits physical, 48 bits virtual
power management:

processor      : 4
vendor_id      : GenuineIntel
cpu family     : 6
model          : 15
model name     : Intel(R) Xeon(R) CPU           X7350  @ 2.93GHz
stepping       : 11
cpu MHz        : 2933.337
cache size     : 4096 KB
physical id    : 0
siblings       : 4
core id        : 2
cpu cores      : 4
apicid         : 2
initial apicid : 2
fpu            : yes
fpu_exception  : yes
cpuid level    : 10
wp             : yes
flags          : fpu vme de pse tsc msr pae mce cx8 apic mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx lm constant_tsc arch_perfmon pebs bts rep_good aperfmperf pni dtes64 monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr pdcm dca lahf_lm tpr_shadow vnmi flexpriority
bogomips       : 5850.96
clflush size   : 64
cache_alignment : 64
address sizes  : 40 bits physical, 48 bits virtual
power management:

processor      : 5
vendor_id      : GenuineIntel
cpu family     : 6
model          : 15
model name     : Intel(R) Xeon(R) CPU           X7350  @ 2.93GHz
stepping       : 11
cpu MHz        : 2933.337
cache size     : 4096 KB
physical id    : 2
siblings       : 4
core id        : 2
cpu cores      : 4
apicid         : 10
initial apicid : 10
fpu            : yes
fpu_exception  : yes
cpuid level    : 10
wp             : yes
flags          : fpu vme de pse tsc msr pae mce cx8 apic mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx lm constant_tsc arch_perfmon pebs bts rep_good aperfmperf pni dtes64 monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr pdcm dca lahf_lm tpr_shadow vnmi flexpriority
bogomips       : 5851.45
clflush size   : 64
cache_alignment : 64
address sizes  : 40 bits physical, 48 bits virtual
power management:

processor      : 6
vendor_id      : GenuineIntel
cpu family     : 6
model          : 15
model name     : Intel(R) Xeon(R) CPU           X7350  @ 2.93GHz
stepping       : 11
cpu MHz        : 2933.337
cache size     : 4096 KB
physical id    : 4
siblings       : 4
core id        : 2
cpu cores      : 4
apicid         : 18
initial apicid : 18
fpu            : yes
fpu_exception  : yes
cpuid level    : 10
wp             : yes
flags          : fpu vme de pse tsc msr pae mce cx8 apic mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx lm constant_tsc arch_perfmon pebs bts rep_good aperfmperf pni dtes64 monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr pdcm dca lahf_lm tpr_shadow vnmi flexpriority
bogomips       : 5851.45
clflush size   : 64
cache_alignment : 64
address sizes  : 40 bits physical, 48 bits virtual
power management:

processor      : 7
vendor_id      : GenuineIntel
cpu family     : 6
model          : 15
model name     : Intel(R) Xeon(R) CPU           X7350  @ 2.93GHz
stepping       : 11
cpu MHz        : 2933.337
cache size     : 4096 KB
physical id    : 6
siblings       : 4
core id        : 2
cpu cores      : 4
apicid         : 26
initial apicid : 26
fpu            : yes
fpu_exception  : yes
cpuid level    : 10
wp             : yes
flags          : fpu vme de pse tsc msr pae mce cx8 apic mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx lm constant_tsc arch_perfmon pebs bts rep_good aperfmperf pni dtes64 monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr pdcm dca lahf_lm tpr_shadow vnmi flexpriority
bogomips       : 5851.47
clflush size   : 64
cache_alignment : 64
address sizes  : 40 bits physical, 48 bits virtual
power management:

processor      : 8
vendor_id      : GenuineIntel
cpu family     : 6
model          : 15
model name     : Intel(R) Xeon(R) CPU           X7350  @ 2.93GHz
stepping       : 11
cpu MHz        : 2933.337
cache size     : 4096 KB
physical id    : 0
siblings       : 4
core id        : 1
cpu cores      : 4
apicid         : 1
initial apicid : 1
fpu            : yes
fpu_exception  : yes
cpuid level    : 10
wp             : yes
flags          : fpu vme de pse tsc msr pae mce cx8 apic mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx lm constant_tsc arch_perfmon pebs bts rep_good aperfmperf pni dtes64 monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr pdcm dca lahf_lm tpr_shadow vnmi flexpriority
bogomips       : 5851.88
clflush size   : 64
cache_alignment : 64
address sizes  : 40 bits physical, 48 bits virtual
power management:

processor      : 9
vendor_id      : GenuineIntel
cpu family     : 6
model          : 15
model name     : Intel(R) Xeon(R) CPU           X7350  @ 2.93GHz
stepping       : 11
cpu MHz        : 2933.337
cache size     : 4096 KB
physical id    : 2
siblings       : 4
core id        : 1
cpu cores      : 4
apicid         : 9
initial apicid : 9
fpu            : yes
fpu_exception  : yes
cpuid level    : 10
wp             : yes
flags          : fpu vme de pse tsc msr pae mce cx8 apic mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx lm constant_tsc arch_perfmon pebs bts rep_good aperfmperf pni dtes64 monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr pdcm dca lahf_lm tpr_shadow vnmi flexpriority
bogomips       : 5851.45
clflush size   : 64
cache_alignment : 64
address sizes  : 40 bits physical, 48 bits virtual
power management:

processor      : 10
vendor_id      : GenuineIntel
cpu family     : 6
model          : 15
model name     : Intel(R) Xeon(R) CPU           X7350  @ 2.93GHz
stepping       : 11
cpu MHz        : 2933.337
cache size     : 4096 KB
physical id    : 4
siblings       : 4
core id        : 1
cpu cores      : 4
apicid         : 17
initial apicid : 17
fpu            : yes
fpu_exception  : yes
cpuid level    : 10
wp             : yes
flags          : fpu vme de pse tsc msr pae mce cx8 apic mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx lm constant_tsc arch_perfmon pebs bts rep_good aperfmperf pni dtes64 monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr pdcm dca lahf_lm tpr_shadow vnmi flexpriority
bogomips       : 5851.44
clflush size   : 64
cache_alignment : 64
address sizes  : 40 bits physical, 48 bits virtual
power management:

processor      : 11
vendor_id      : GenuineIntel
cpu family     : 6
model          : 15
model name     : Intel(R) Xeon(R) CPU           X7350  @ 2.93GHz
stepping       : 11
cpu MHz        : 2933.337
cache size     : 4096 KB
physical id    : 6
siblings       : 4
core id        : 1
cpu cores      : 4
apicid         : 25
initial apicid : 25
fpu            : yes
fpu_exception  : yes
cpuid level    : 10
wp             : yes
flags          : fpu vme de pse tsc msr pae mce cx8 apic mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx lm constant_tsc arch_perfmon pebs bts rep_good aperfmperf pni dtes64 monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr pdcm dca lahf_lm tpr_shadow vnmi flexpriority
bogomips       : 5851.46
clflush size   : 64
cache_alignment : 64
address sizes  : 40 bits physical, 48 bits virtual
power management:

processor      : 12
vendor_id      : GenuineIntel
cpu family     : 6
model          : 15
model name     : Intel(R) Xeon(R) CPU           X7350  @ 2.93GHz
stepping       : 11
cpu MHz        : 2933.337
cache size     : 4096 KB
physical id    : 0
siblings       : 4
core id        : 3
cpu cores      : 4
apicid         : 3
initial apicid : 3
fpu            : yes
fpu_exception  : yes
cpuid level    : 10
wp             : yes
flags          : fpu vme de pse tsc msr pae mce cx8 apic mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx lm constant_tsc arch_perfmon pebs bts rep_good aperfmperf pni dtes64 monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr pdcm dca lahf_lm tpr_shadow vnmi flexpriority
bogomips       : 5850.82
clflush size   : 64
cache_alignment : 64
address sizes  : 40 bits physical, 48 bits virtual
power management:

processor      : 13
vendor_id      : GenuineIntel
cpu family     : 6
model          : 15
model name     : Intel(R) Xeon(R) CPU           X7350  @ 2.93GHz
stepping       : 11
cpu MHz        : 2933.337
cache size     : 4096 KB
physical id    : 2
siblings       : 4
core id        : 3
cpu cores      : 4
apicid         : 11
initial apicid : 11
fpu            : yes
fpu_exception  : yes
cpuid level    : 10
wp             : yes
flags          : fpu vme de pse tsc msr pae mce cx8 apic mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx lm constant_tsc arch_perfmon pebs bts rep_good aperfmperf pni dtes64 monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr pdcm dca lahf_lm tpr_shadow vnmi flexpriority
bogomips       : 5851.48
clflush size   : 64
cache_alignment : 64
address sizes  : 40 bits physical, 48 bits virtual
power management:

processor      : 14
vendor_id      : GenuineIntel
cpu family     : 6
model          : 15
model name     : Intel(R) Xeon(R) CPU           X7350  @ 2.93GHz
stepping       : 11
cpu MHz        : 2933.337
cache size     : 4096 KB
physical id    : 4
siblings       : 4
core id        : 3
cpu cores      : 4
apicid         : 19
initial apicid : 19
fpu            : yes
fpu_exception  : yes
cpuid level    : 10
wp             : yes
flags          : fpu vme de pse tsc msr pae mce cx8 apic mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx lm constant_tsc arch_perfmon pebs bts rep_good aperfmperf pni dtes64 monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr pdcm dca lahf_lm tpr_shadow vnmi flexpriority
bogomips       : 5852.24
clflush size   : 64
cache_alignment : 64
address sizes  : 40 bits physical, 48 bits virtual
power management:

processor      : 15
vendor_id      : GenuineIntel
cpu family     : 6
model          : 15
model name     : Intel(R) Xeon(R) CPU           X7350  @ 2.93GHz
stepping       : 11
cpu MHz        : 2933.337
cache size     : 4096 KB
physical id    : 6
siblings       : 4
core id        : 3
cpu cores      : 4
apicid         : 27
initial apicid : 27
fpu            : yes
fpu_exception  : yes
cpuid level    : 10
wp              : yes
flags          : fpu vme de pse tsc msr pae mce cx8 apic mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx lm constant_tsc arch_perfmon pebs bts rep_good aperfmperf pni dtes64 monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr pdcm dca lahf_lm tpr_shadow vnmi flexpriority
bogomips       : 5850.95
clflush size   : 64
cache_alignment : 64
address sizes  : 40 bits physical, 48 bits virtual
power management:

[7.3.] Module information (from /proc/modules):
nfs 379282 3 - Live 0xffffffffa04b0000
fscache 46761 1 nfs, Live 0xffffffffa049a000 (T)
fuse 66138 0 - Live 0xffffffffa047f000
nfsd 305480 13 - Live 0xffffffffa0425000
lockd 74268 2 nfs,nfsd, Live 0xffffffffa0408000
nfs_acl 2613 2 nfs,nfsd, Live 0xffffffffa0402000
auth_rpcgss 44925 2 nfs,nfsd, Live 0xffffffffa03ef000
exportfs 4202 1 nfsd, Live 0xffffffffa03e8000
autofs4 27683 3 - Live 0xffffffffa03db000
sunrpc 242213 28 nfs,nfsd,lockd,nfs_acl,auth_rpcgss, Live 0xffffffffa0387000
p4_clockmod 20059 0 - Live 0xffffffffa037d000
freq_table 4847 1 p4_clockmod, Live 0xffffffffa0376000
speedstep_lib 5367 1 p4_clockmod, Live 0xffffffffa036f000
ipv6 322291 209 - Live 0xffffffffa02f5000
dm_mirror 14067 0 - Live 0xffffffffa027a000
dm_region_hash 12136 1 dm_mirror, Live 0xffffffffa024a000
dm_log 10120 2 dm_mirror,dm_region_hash, Live 0xffffffffa0245000
e1000e 213905 0 - Live 0xffffffffa02ba000
bnx2 77300 0 - Live 0xffffffffa02a5000
microcode 112781 0 - Live 0xffffffffa0287000
dcdbas 9185 0 - Live 0xffffffffa0240000
serio_raw 4816 0 - Live 0xffffffffa01e2000
sg 30090 0 - Live 0xffffffffa01a7000
ghes 3893 0 - Live 0xffffffffa00b1000
hed 2306 1 ghes, Live 0xffffffffa0032000
iTCO_wdt 12060 0 - Live 0xffffffffa0081000
iTCO_vendor_support 3022 1 iTCO_wdt, Live 0xffffffffa0028000
i7300_edac 8631 0 - Live 0xffffffffa0282000
edac_core 46533 3 i7300_edac, Live 0xffffffffa026c000
shpchp 33448 0 - Live 0xffffffffa0254000
ext4 359671 3 - Live 0xffffffffa01e6000
mbcache 7918 1 ext4, Live 0xffffffffa01b1000
jbd2 88768 1 ext4, Live 0xffffffffa01ca000
sd_mod 38196 3 - Live 0xffffffffa0198000
crc_t10dif 1507 1 sd_mod, Live 0xffffffffa0072000
megaraid_sas 76175 2 - Live 0xffffffffa01b5000
sr_mod 16194 0 - Live 0xffffffffa0091000
cdrom 39769 1 sr_mod, Live 0xffffffffa0075000
pata_acpi 3667 0 - Live 0xffffffffa0038000
ata_generic 3611 0 - Live 0xffffffffa002c000
ata_piix 22652 0 - Live 0xffffffffa0015000
radeon 927303 1 - Live 0xffffffffa00b3000
ttm 67003 1 radeon, Live 0xffffffffa0097000
drm_kms_helper 34768 1 radeon, Live 0xffffffffa0086000
drm 213686 3 radeon,ttm,drm_kms_helper, Live 0xffffffffa003b000
hwmon 2464 1 radeon, Live 0xffffffffa0035000
i2c_algo_bit 5728 1 radeon, Live 0xffffffffa002e000
i2c_core 31274 4 radeon,drm_kms_helper,drm,i2c_algo_bit, Live 0xffffffffa001e000
dm_mod 75539 11 dm_mirror,dm_log, Live 0xffffffffa0000000
[7.4.] Loaded driver and hardware information (/proc/ioports, /proc/iomem)
0000-001f : dma1
0020-0021 : pic1
0040-0043 : timer0
0050-0053 : timer1
0060-0060 : keyboard
0064-0064 : keyboard
0070-007f : rtc0
0080-008f : dma page reg
00a0-00a1 : pic2
00c0-00df : dma2
00f0-00ff : fpu
0170-0177 : 0000:00:1f.2
  0170-0177 : ata_piix
01f0-01f7 : 0000:00:1f.2
  01f0-01f7 : ata_piix
02f8-02ff : serial
0376-0376 : 0000:00:1f.2
  0376-0376 : ata_piix
03c0-03df : vga+
03f6-03f6 : 0000:00:1f.2
  03f6-03f6 : ata_piix
03f8-03ff : serial
0800-087f : pnp 00:07
  0800-0803 : ACPI PM1a_EVT_BLK
  0804-0805 : ACPI PM1a_CNT_BLK
  0808-080b : ACPI PM_TMR
  0810-0815 : ACPI CPU throttle
  0828-082f : ACPI GPE0_BLK
  0830-0833 : iTCO_wdt
  0860-087f : iTCO_wdt
0880-08bf : pnp 00:07
08c0-08df : pnp 00:07
08e0-08e3 : pnp 00:07
08f0-08f0 : ACPI PM2_CNT_BLK
0900-0900 : pnp 00:07
0c00-0c7f : pnp 00:07
0ca0-0ca7 : pnp 00:07
0ca8-0ca8 : pnp 00:08
0ca9-0cab : pnp 00:07
0cac-0cac : pnp 00:08
0cad-0caf : pnp 00:07
0cf8-0cff : PCI conf1
1000-1fff : PCI Bus 0000:15
bc80-bc9f : 0000:00:1d.0
  bc80-bc9f : uhci_hcd
bca0-bcbf : 0000:00:1d.1
  bca0-bcbf : uhci_hcd
bcc0-bcdf : 0000:00:1d.2
  bcc0-bcdf : uhci_hcd
bce0-bcff : 0000:00:1d.3
  bce0-bcff : uhci_hcd
c000-cfff : PCI Bus 0000:1b
  cc00-ccff : 0000:1b:0c.0
d000-efff : PCI Bus 0000:16
  d000-efff : PCI Bus 0000:17
    d000-dfff : PCI Bus 0000:19
      dc00-dcff : 0000:19:00.0
    e000-efff : PCI Bus 0000:18
      ece0-ecff : 0000:18:00.0
fc00-fc0f : 0000:00:1f.2
  fc00-fc0f : ata_piix
[7.5.] PCI information ('lspci -vvv' as root)
00:00.0 Host bridge: Intel Corporation 7300 Chipset Memory Controller Hub (rev 01)
        Subsystem: Intel Corporation Device 8086
        Control: I/O- Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 11
        Capabilities: [50] Power Management version 2
               Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
               Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [58] MSI: Enable- Count=1/1 Maskable- 64bit-
               Address: fee00000  Data: 0000
        Capabilities: [6c] Express (v1) Root Port (Slot-), MSI 00
               DevCap: MaxPayload 256 bytes, PhantFunc 0, Latency L0s unlimited, L1 unlimited
                       ExtTag- RBE+ FLReset-
               DevCtl: Report errors: Correctable- Non-Fatal- Fatal+ Unsupported-
                       RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+
                       MaxPayload 128 bytes, MaxReadReq 128 bytes
               DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
               LnkCap: Port #0, Speed 2.5GT/s, Width x4, ASPM L0s, Latency L0 unlimited, L1 unlimited
                       ClockPM- Surprise+ LLActRep+ BwNot-
               LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk-
                       ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
               LnkSta: Speed 2.5GT/s, Width x4, TrErr- Train- SlotClk+ DLActive+ BWMgmt- ABWMgmt-
               RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
               RootCap: CRSVisible-
               RootSta: PME ReqID 0000, PMEStatus- PMEPending-
        Capabilities: [100] Advanced Error Reporting
               UESta:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
               UEMsk:  DLP- SDES- TLP+ FCP- CmpltTO+ CmpltAbrt+ UnxCmplt+ RxOF- MalfTLP- ECRC- UnsupReq+ ACSViol+
               UESvrt: DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
               CESta:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr-
               CEMsk:  RxErr+ BadTLP+ BadDLLP+ Rollover+ Timeout+ NonFatalErr+
               AERCap: First Error Pointer: 00, GenCap- CGenEn- ChkCap- ChkEn-

00:01.0 PCI bridge: Intel Corporation 7300 Chipset PCI Express Port 1 (rev 01) (prog-if 00 [Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx+
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Bus: primary=00, secondary=14, subordinate=14, sec-latency=0
        I/O behind bridge: 0000f000-00000fff
        Memory behind bridge: fff00000-000fffff
        Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
        BridgeCtl: Parity+ SERR+ NoISA+ VGA- MAbort- >Reset- FastB2B-
                PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
        Capabilities: [50] Power Management version 2
               Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
               Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [58] MSI: Enable+ Count=1/1 Maskable- 64bit-
               Address: fee00000  Data: 4079
        Capabilities: [6c] Express (v1) Root Port (Slot+), MSI 00
               DevCap: MaxPayload 256 bytes, PhantFunc 0, Latency L0s unlimited, L1 unlimited
                       ExtTag- RBE+ FLReset-
               DevCtl: Report errors: Correctable- Non-Fatal- Fatal+ Unsupported-
                       RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+
                       MaxPayload 128 bytes, MaxReadReq 128 bytes
               DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
               LnkCap: Port #1, Speed 2.5GT/s, Width x4, ASPM L0s, Latency L0 unlimited, L1 unlimited
                       ClockPM- Surprise+ LLActRep+ BwNot-
               LnkCtl: ASPM Disabled; RCB 64 bytes Disabled+ Retrain- CommClk-
                       ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
               LnkSta: Speed 2.5GT/s, Width x4, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
               SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- Surpise-
                       Slot #  5, PowerLimit 25.000000; Interlock- NoCompl-
               SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
                       Control: AttnInd Off, PwrInd Off, Power- Interlock-
               SltSta: Status: AttnBtn- PowerFlt- MRL+ CmdCplt- PresDet- Interlock-
                       Changed: MRL- PresDet+ LinkState-
               RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal+ PMEIntEna- CRSVisible-
               RootCap: CRSVisible-
               RootSta: PME ReqID 0000, PMEStatus- PMEPending-
        Capabilities: [f0] Subsystem: Intel Corporation Device 0000
        Capabilities: [100] Advanced Error Reporting
               UESta:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
               UEMsk:  DLP- SDES- TLP+ FCP- CmpltTO- CmpltAbrt+ UnxCmplt+ RxOF- MalfTLP- ECRC- UnsupReq+ ACSViol-
               UESvrt: DLP+ SDES+ TLP- FCP+ CmpltTO+ CmpltAbrt- UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
               CESta:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr-
               CEMsk:  RxErr+ BadTLP+ BadDLLP+ Rollover+ Timeout+ NonFatalErr+
               AERCap: First Error Pointer: 00, GenCap- CGenEn- ChkCap- ChkEn-
        Kernel driver in use: pcieport
        Kernel modules: shpchp

00:02.0 PCI bridge: Intel Corporation 7300 Chipset PCI Express Port 2 (rev 01) (prog-if 00 [Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx+
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Bus: primary=00, secondary=16, subordinate=1a, sec-latency=0
        I/O behind bridge: 0000d000-0000efff
        Memory behind bridge: de100000-de5fffff
        Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
        BridgeCtl: Parity+ SERR+ NoISA+ VGA- MAbort- >Reset- FastB2B-
               PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
        Capabilities: [50] Power Management version 2
               Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
               Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [58] MSI: Enable+ Count=1/1 Maskable- 64bit-
               Address: fee00000  Data: 4081
        Capabilities: [6c] Express (v1) Root Port (Slot-), MSI 00
               DevCap: MaxPayload 256 bytes, PhantFunc 0, Latency L0s unlimited, L1 unlimited
                       ExtTag- RBE+ FLReset-
               DevCtl: Report errors: Correctable- Non-Fatal- Fatal+ Unsupported-
                       RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+
                       MaxPayload 128 bytes, MaxReadReq 128 bytes
               DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
               LnkCap: Port #2, Speed 2.5GT/s, Width x4, ASPM L0s, Latency L0 unlimited, L1 unlimited
                       ClockPM- Surprise+ LLActRep+ BwNot-
               LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk-
                       ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
               LnkSta: Speed 2.5GT/s, Width x4, TrErr- Train- SlotClk+ DLActive+ BWMgmt- ABWMgmt-
               RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal+ PMEIntEna+ CRSVisible-
               RootCap: CRSVisible-
               RootSta: PME ReqID 0000, PMEStatus- PMEPending-
        Capabilities: [f0] Subsystem: Intel Corporation Device 0000
        Capabilities: [100] Advanced Error Reporting
               UESta:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
               UEMsk:  DLP- SDES- TLP+ FCP- CmpltTO- CmpltAbrt+ UnxCmplt+ RxOF- MalfTLP- ECRC- UnsupReq+ ACSViol-
               UESvrt: DLP+ SDES+ TLP- FCP+ CmpltTO+ CmpltAbrt- UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
               CESta:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr-
               CEMsk:  RxErr+ BadTLP+ BadDLLP+ Rollover+ Timeout+ NonFatalErr+
               AERCap: First Error Pointer: 00, GenCap- CGenEn- ChkCap- ChkEn-
        Kernel driver in use: pcieport
        Kernel modules: shpchp

00:03.0 PCI bridge: Intel Corporation 7300 Chipset PCI Express Port 3 (rev 01) (prog-if 00 [Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx+
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Bus: primary=00, secondary=01, subordinate=0b, sec-latency=0
        I/O behind bridge: 0000f000-00000fff
        Memory behind bridge: d6000000-ddffffff
        Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort+ <SERR- <PERR-
        BridgeCtl: Parity+ SERR+ NoISA+ VGA- MAbort- >Reset- FastB2B-
               PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
        Capabilities: [50] Power Management version 2
               Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
               Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [58] MSI: Enable+ Count=1/1 Maskable- 64bit-
               Address: fee00000  Data: 4089
        Capabilities: [6c] Express (v1) Root Port (Slot-), MSI 00
               DevCap: MaxPayload 256 bytes, PhantFunc 0, Latency L0s unlimited, L1 unlimited
                       ExtTag- RBE+ FLReset-
               DevCtl: Report errors: Correctable- Non-Fatal- Fatal+ Unsupported-
                       RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+
                       MaxPayload 128 bytes, MaxReadReq 128 bytes
               DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
               LnkCap: Port #3, Speed 2.5GT/s, Width x4, ASPM L0s, Latency L0 unlimited, L1 unlimited
                       ClockPM- Surprise+ LLActRep+ BwNot-
               LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk-
                       ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
               LnkSta: Speed 2.5GT/s, Width x4, TrErr- Train- SlotClk+ DLActive+ BWMgmt- ABWMgmt-
               RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal+ PMEIntEna+ CRSVisible-
               RootCap: CRSVisible-
               RootSta: PME ReqID 0000, PMEStatus- PMEPending-
        Capabilities: [f0] Subsystem: Intel Corporation Device 0000
        Capabilities: [100] Advanced Error Reporting
               UESta:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
               UEMsk:  DLP- SDES- TLP+ FCP- CmpltTO- CmpltAbrt+ UnxCmplt+ RxOF- MalfTLP- ECRC- UnsupReq+ ACSViol-
               UESvrt: DLP+ SDES+ TLP- FCP+ CmpltTO+ CmpltAbrt- UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
               CESta:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr-
               CEMsk:  RxErr+ BadTLP+ BadDLLP+ Rollover+ Timeout+ NonFatalErr+
               AERCap: First Error Pointer: 00, GenCap- CGenEn- ChkCap- ChkEn-
        Kernel driver in use: pcieport
        Kernel modules: shpchp

00:04.0 PCI bridge: Intel Corporation 7300 Chipset PCI Express Port 4 (rev 01) (prog-if 00 [Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx+
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Bus: primary=00, secondary=0c, subordinate=0f, sec-latency=0
        I/O behind bridge: 0000f000-00000fff
        Memory behind bridge: fff00000-000fffff
        Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort+ <SERR- <PERR-
        BridgeCtl: Parity+ SERR+ NoISA+ VGA- MAbort- >Reset- FastB2B-
               PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
        Capabilities: [50] Power Management version 2
               Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
               Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [58] MSI: Enable+ Count=1/1 Maskable- 64bit-
               Address: fee00000  Data: 4091
        Capabilities: [6c] Express (v1) Root Port (Slot-), MSI 00
               DevCap: MaxPayload 256 bytes, PhantFunc 0, Latency L0s unlimited, L1 unlimited
                       ExtTag- RBE+ FLReset-
               DevCtl: Report errors: Correctable- Non-Fatal- Fatal+ Unsupported-
                       RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+
                       MaxPayload 128 bytes, MaxReadReq 128 bytes
               DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
               LnkCap: Port #4, Speed 2.5GT/s, Width x8, ASPM L0s, Latency L0 unlimited, L1 unlimited
                       ClockPM- Surprise+ LLActRep+ BwNot-
               LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk-
                       ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
               LnkSta: Speed 2.5GT/s, Width x8, TrErr- Train- SlotClk+ DLActive+ BWMgmt- ABWMgmt-
               RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal+ PMEIntEna+ CRSVisible-
               RootCap: CRSVisible-
               RootSta: PME ReqID 0000, PMEStatus- PMEPending-
        Capabilities: [f0] Subsystem: Intel Corporation Device 0000
        Capabilities: [100] Advanced Error Reporting
               UESta:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
               UEMsk:  DLP- SDES- TLP+ FCP- CmpltTO- CmpltAbrt+ UnxCmplt+ RxOF- MalfTLP- ECRC- UnsupReq+ ACSViol-
               UESvrt: DLP+ SDES+ TLP- FCP+ CmpltTO+ CmpltAbrt- UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
               CESta:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr-
               CEMsk:  RxErr+ BadTLP+ BadDLLP+ Rollover+ Timeout+ NonFatalErr+
               AERCap: First Error Pointer: 00, GenCap- CGenEn- ChkCap- ChkEn-
        Kernel driver in use: pcieport
        Kernel modules: shpchp

00:06.0 PCI bridge: Intel Corporation 7300 Chipset PCI Express Port 6 (rev 01) (prog-if 00 [Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx+
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Bus: primary=00, secondary=10, subordinate=13, sec-latency=0
        I/O behind bridge: 0000f000-00000fff
        Memory behind bridge: fff00000-000fffff
        Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort+ <SERR- <PERR-
        BridgeCtl: Parity+ SERR+ NoISA+ VGA- MAbort- >Reset- FastB2B-
               PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
        Capabilities: [50] Power Management version 2
               Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
               Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [58] MSI: Enable+ Count=1/1 Maskable- 64bit-
               Address: fee00000  Data: 4099
        Capabilities: [6c] Express (v1) Root Port (Slot-), MSI 00
               DevCap: MaxPayload 256 bytes, PhantFunc 0, Latency L0s unlimited, L1 unlimited
                       ExtTag- RBE+ FLReset-
               DevCtl: Report errors: Correctable- Non-Fatal- Fatal+ Unsupported-
                       RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+
                       MaxPayload 128 bytes, MaxReadReq 128 bytes
               DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
               LnkCap: Port #6, Speed 2.5GT/s, Width x8, ASPM L0s, Latency L0 unlimited, L1 unlimited
                       ClockPM- Surprise+ LLActRep+ BwNot-
               LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk-
                       ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
               LnkSta: Speed 2.5GT/s, Width x8, TrErr- Train- SlotClk+ DLActive+ BWMgmt- ABWMgmt-
               RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal+ PMEIntEna+ CRSVisible-
               RootCap: CRSVisible-
               RootSta: PME ReqID 0000, PMEStatus- PMEPending-
        Capabilities: [f0] Subsystem: Intel Corporation Device 0000
        Capabilities: [100] Advanced Error Reporting
               UESta:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
               UEMsk:  DLP- SDES- TLP+ FCP- CmpltTO- CmpltAbrt+ UnxCmplt+ RxOF- MalfTLP- ECRC- UnsupReq+ ACSViol-
               UESvrt: DLP+ SDES+ TLP- FCP+ CmpltTO+ CmpltAbrt- UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
               CESta:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr-
               CEMsk:  RxErr+ BadTLP+ BadDLLP+ Rollover+ Timeout+ NonFatalErr+
               AERCap: First Error Pointer: 00, GenCap- CGenEn- ChkCap- ChkEn-
        Kernel driver in use: pcieport
        Kernel modules: shpchp

00:10.0 Host bridge: Intel Corporation 7300 Chipset FSB Registers (rev 01)
        Subsystem: Dell PowerEdge R900 7300 Chipset FSB Registers
        Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Kernel driver in use: i7300_edac
        Kernel modules: i7300_edac, i7300_idle

00:10.1 Host bridge: Intel Corporation 7300 Chipset FSB Registers (rev 01)
        Subsystem: Dell PowerEdge R900 7300 Chipset FSB Registers
        Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Kernel modules: i7300_edac, i7300_idle

00:10.2 Host bridge: Intel Corporation 7300 Chipset FSB Registers (rev 01)
        Subsystem: Dell PowerEdge R900 7300 Chipset FSB Registers
        Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Kernel modules: i7300_edac, i7300_idle

00:10.3 Host bridge: Intel Corporation 7300 Chipset FSB Registers (rev 01)
        Subsystem: Dell PowerEdge R900 7300 Chipset FSB Registers
        Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Kernel modules: i7300_edac, i7300_idle

00:11.0 Host bridge: Intel Corporation 7300 Chipset Snoop Filter Registers (rev 01)
        Subsystem: Intel Corporation Device 8086
        Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-

00:11.3 Host bridge: Intel Corporation 7300 Chipset Snoop Filter Registers (rev 01)
        Subsystem: Intel Corporation Device 8086
        Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-

00:13.0 Host bridge: Intel Corporation 7300 Chipset Debug and Miscellaneous Registers (rev 01)
        Subsystem: Intel Corporation Device 8086
        Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-

00:15.0 Host bridge: Intel Corporation 7300 Chipset FBD Branch 0 Registers (rev 01)
        Subsystem: Intel Corporation Device 8086
        Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-

00:16.0 Host bridge: Intel Corporation 7300 Chipset FBD Branch 1 Registers (rev 01)
        Subsystem: Intel Corporation Device 8086
        Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-

00:1c.0 PCI bridge: Intel Corporation 631xESB/632xESB/3100 Chipset PCI Express Root Port 1 (rev 09) (prog-if 00 [Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+ Stepping- SERR- FastB2B- DisINTx+
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Bus: primary=00, secondary=15, subordinate=15, sec-latency=0
        I/O behind bridge: 00001000-00001fff
        Memory behind bridge: c0000000-c01fffff
        Prefetchable memory behind bridge: 00000000c0200000-00000000c03fffff
        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
        BridgeCtl: Parity+ SERR+ NoISA+ VGA- MAbort- >Reset- FastB2B-
               PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
        Capabilities: [40] Express (v1) Root Port (Slot+), MSI 00
               DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s unlimited, L1 unlimited
                       ExtTag+ RBE- FLReset-
               DevCtl: Report errors: Correctable- Non-Fatal+ Fatal+ Unsupported-
                       RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                       MaxPayload 128 bytes, MaxReadReq 128 bytes
               DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
               LnkCap: Port #1, Speed 2.5GT/s, Width x4, ASPM L0s L1, Latency L0 <256ns, L1 <4us
                       ClockPM- Surprise- LLActRep- BwNot-
               LnkCtl: ASPM Disabled; RCB 64 bytes Disabled+ Retrain- CommClk+
                       ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
               LnkSta: Speed 2.5GT/s, Width x0, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
               SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ Surpise+
                       Slot #  6, PowerLimit 25.000000; Interlock- NoCompl-
               SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
                       Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
               SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet- Interlock-
                       Changed: MRL- PresDet- LinkState-
               RootCtl: ErrCorrectable- ErrNon-Fatal+ ErrFatal+ PMEIntEna- CRSVisible-
               RootCap: CRSVisible-
               RootSta: PME ReqID 0000, PMEStatus- PMEPending-
        Capabilities: [80] MSI: Enable+ Count=1/1 Maskable- 64bit-
               Address: fee00000  Data: 40a1
        Capabilities: [90] Subsystem: Dell Device 01f0
        Capabilities: [a0] Power Management version 2
               Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
               Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [100] Virtual Channel <?>
        Capabilities: [180] Root Complex Link <?>
        Kernel driver in use: pcieport
        Kernel modules: shpchp

00:1d.0 USB Controller: Intel Corporation 631xESB/632xESB/3100 Chipset UHCI USB Controller #1 (rev 09) (prog-if 00 [UHCI])
        Subsystem: Dell PowerEdge R900 onboard USB
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Interrupt: pin A routed to IRQ 20
        Region 4: I/O ports at bc80 [size=32]
        Kernel driver in use: uhci_hcd

00:1d.1 USB Controller: Intel Corporation 631xESB/632xESB/3100 Chipset UHCI USB Controller #2 (rev 09) (prog-if 00 [UHCI])
        Subsystem: Dell PowerEdge R900 onboard USB
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Interrupt: pin A routed to IRQ 20
        Region 4: I/O ports at bca0 [size=32]
        Kernel driver in use: uhci_hcd

00:1d.2 USB Controller: Intel Corporation 631xESB/632xESB/3100 Chipset UHCI USB Controller #3 (rev 09) (prog-if 00 [UHCI])
        Subsystem: Dell PowerEdge R900 onboard USB
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Interrupt: pin A routed to IRQ 20
        Region 4: I/O ports at bcc0 [size=32]
        Kernel driver in use: uhci_hcd

00:1d.3 USB Controller: Intel Corporation 631xESB/632xESB/3100 Chipset UHCI USB Controller #4 (rev 09) (prog-if 00 [UHCI])
        Subsystem: Dell PowerEdge R900 onboard USB
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Interrupt: pin A routed to IRQ 20
        Region 4: I/O ports at bce0 [size=32]
        Kernel driver in use: uhci_hcd

00:1d.7 USB Controller: Intel Corporation 631xESB/632xESB/3100 Chipset EHCI USB2 Controller (rev 09) (prog-if 20 [EHCI])
        Subsystem: Dell PowerEdge R900 onboard USB
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Interrupt: pin B routed to IRQ 21
        Region 0: Memory at de0ffc00 (32-bit, non-prefetchable) [size=1K]
        Capabilities: [50] Power Management version 2
               Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
               Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [58] Debug port: BAR=1 offset=00a0
        Kernel driver in use: ehci_hcd

00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev d9) (prog-if 01 [Subtractive decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+ Stepping- SERR+ FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Bus: primary=00, secondary=1b, subordinate=1b, sec-latency=32
        I/O behind bridge: 0000c000-0000cfff
        Memory behind bridge: de600000-de6fffff
        Prefetchable memory behind bridge: 00000000c8000000-00000000cfffffff
        Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort+ <SERR- <PERR-
        BridgeCtl: Parity+ SERR+ NoISA- VGA+ MAbort- >Reset- FastB2B-
               PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
        Capabilities: [50] Subsystem: Gammagraphx, Inc. (or missing ID) Device 0000

00:1f.0 ISA bridge: Intel Corporation 631xESB/632xESB/3100 Chipset LPC Interface Controller (rev 09)
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+ Stepping- SERR+ FastB2B- DisINTx-
        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Kernel modules: iTCO_wdt, intel-rng

00:1f.2 IDE interface: Intel Corporation 631xESB/632xESB/3100 Chipset SATA IDE Controller (rev 09) (prog-if 8a [Master SecP PriP])
        Subsystem: Dell Device 01f0
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+ Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Region 0: I/O ports at 01f0 [size=8]
        Region 1: I/O ports at 03f4 [size=1]
        Region 2: I/O ports at 0170 [size=8]
        Region 3: I/O ports at 0374 [size=1]
        Region 4: I/O ports at fc00 [size=16]
        Region 5: Memory at c0400000 (32-bit, non-prefetchable) [size=1K]
        Capabilities: [70] Power Management version 2
               Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot+,D3cold-)
               Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
        Kernel driver in use: ata_piix
        Kernel modules: ata_generic, pata_acpi, ata_piix

01:00.0 PCI bridge: Integrated Device Technology, Inc. PES24T6 PCI Express Switch (rev 0e) (prog-if 00 [Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Bus: primary=01, secondary=02, subordinate=0b, sec-latency=0
        I/O behind bridge: 0000f000-00000fff
        Memory behind bridge: d6000000-ddffffff
        Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
        BridgeCtl: Parity+ SERR+ NoISA+ VGA- MAbort- >Reset- FastB2B-
               PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
        Capabilities: [40] Express (v1) Upstream Port, MSI 00
               DevCap: MaxPayload 2048 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
                       ExtTag+ AttnBtn- AttnInd- PwrInd- RBE+ FLReset-SlotPowerLimit 0.000000W
               DevCtl: Report errors: Correctable- Non-Fatal- Fatal+ Unsupported-
                       RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                       MaxPayload 128 bytes, MaxReadReq 128 bytes
               DevSta: CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr- TransPend-
               LnkCap: Port #0, Speed 2.5GT/s, Width x4, ASPM L0s L1, Latency L0 <512ns, L1 <4us
                       ClockPM- Surprise- LLActRep- BwNot-
               LnkCtl: ASPM Disabled; Disabled- Retrain- CommClk-
                       ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
               LnkSta: Speed 2.5GT/s, Width x4, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
        Capabilities: [c0] Power Management version 3
               Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
               Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [100] Advanced Error Reporting
               UESta:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
               UEMsk:  DLP- SDES- TLP+ FCP- CmpltTO- CmpltAbrt- UnxCmplt+ RxOF- MalfTLP- ECRC+ UnsupReq+ ACSViol-
               UESvrt: DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
               CESta:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
               CEMsk:  RxErr+ BadTLP+ BadDLLP+ Rollover+ Timeout+ NonFatalErr+
               AERCap: First Error Pointer: 00, GenCap+ CGenEn- ChkCap+ ChkEn-
        Capabilities: [200] Virtual Channel <?>
        Kernel driver in use: pcieport
        Kernel modules: shpchp

02:01.0 PCI bridge: Integrated Device Technology, Inc. PES24T6 PCI Express Switch (rev 0e) (prog-if 00 [Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Bus: primary=02, secondary=03, subordinate=03, sec-latency=0
        I/O behind bridge: 0000f000-00000fff
        Memory behind bridge: fff00000-000fffff
        Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
        BridgeCtl: Parity+ SERR+ NoISA+ VGA- MAbort- >Reset- FastB2B-
               PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
        Capabilities: [40] Express (v1) Downstream Port (Slot-), MSI 00
               DevCap: MaxPayload 2048 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
                       ExtTag+ RBE+ FLReset-
               DevCtl: Report errors: Correctable- Non-Fatal- Fatal+ Unsupported-
                       RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                       MaxPayload 128 bytes, MaxReadReq 128 bytes
               DevSta: CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr- TransPend-
               LnkCap: Port #1, Speed 2.5GT/s, Width x4, ASPM L0s L1, Latency L0 <512ns, L1 <4us
                       ClockPM- Surprise+ LLActRep+ BwNot-
               LnkCtl: ASPM Disabled; Disabled+ Retrain- CommClk-
                       ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
               LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train+ SlotClk+ DLActive- BWMgmt- ABWMgmt-
        Capabilities: [c0] Power Management version 3
               Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
               Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [d0] MSI: Enable+ Count=1/1 Maskable- 64bit+
               Address: 00000000fee00000  Data: 40a9
        Capabilities: [100] Advanced Error Reporting
               UESta:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
               UEMsk:  DLP- SDES- TLP+ FCP- CmpltTO- CmpltAbrt- UnxCmplt+ RxOF- MalfTLP- ECRC+ UnsupReq+ ACSViol-
               UESvrt: DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
               CESta:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
               CEMsk:  RxErr+ BadTLP+ BadDLLP+ Rollover+ Timeout+ NonFatalErr+
               AERCap: First Error Pointer: 00, GenCap+ CGenEn- ChkCap+ ChkEn-
        Capabilities: [200] Virtual Channel <?>
        Kernel driver in use: pcieport
        Kernel modules: shpchp

02:02.0 PCI bridge: Integrated Device Technology, Inc. PES24T6 PCI Express Switch (rev 0e) (prog-if 00 [Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Bus: primary=02, secondary=0a, subordinate=0b, sec-latency=0
        I/O behind bridge: 0000f000-00000fff
        Memory behind bridge: d6000000-d7ffffff
        Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
        BridgeCtl: Parity+ SERR+ NoISA+ VGA- MAbort- >Reset- FastB2B-
               PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
        Capabilities: [40] Express (v1) Downstream Port (Slot-), MSI 00
               DevCap: MaxPayload 2048 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
                       ExtTag+ RBE+ FLReset-
               DevCtl: Report errors: Correctable- Non-Fatal- Fatal+ Unsupported-
                       RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                       MaxPayload 128 bytes, MaxReadReq 128 bytes
               DevSta: CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr- TransPend-
               LnkCap: Port #2, Speed 2.5GT/s, Width x4, ASPM L0s L1, Latency L0 <512ns, L1 <4us
                       ClockPM- Surprise+ LLActRep+ BwNot-
               LnkCtl: ASPM Disabled; Disabled- Retrain- CommClk-
                       ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
               LnkSta: Speed 2.5GT/s, Width x4, TrErr- Train- SlotClk+ DLActive+ BWMgmt- ABWMgmt-
        Capabilities: [c0] Power Management version 3
               Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
               Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [d0] MSI: Enable+ Count=1/1 Maskable- 64bit+
               Address: 00000000fee00000  Data: 40b1
        Capabilities: [100] Advanced Error Reporting
               UESta:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
               UEMsk:  DLP- SDES- TLP+ FCP- CmpltTO- CmpltAbrt- UnxCmplt+ RxOF- MalfTLP- ECRC+ UnsupReq+ ACSViol-
               UESvrt: DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
               CESta:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
               CEMsk:  RxErr+ BadTLP+ BadDLLP+ Rollover+ Timeout+ NonFatalErr+
               AERCap: First Error Pointer: 00, GenCap+ CGenEn- ChkCap+ ChkEn-
        Capabilities: [200] Virtual Channel <?>
        Kernel driver in use: pcieport
        Kernel modules: shpchp

02:03.0 PCI bridge: Integrated Device Technology, Inc. PES24T6 PCI Express Switch (rev 0e) (prog-if 00 [Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Bus: primary=02, secondary=08, subordinate=09, sec-latency=0
        I/O behind bridge: 0000f000-00000fff
        Memory behind bridge: d8000000-d9ffffff
        Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
        BridgeCtl: Parity+ SERR+ NoISA+ VGA- MAbort- >Reset- FastB2B-
               PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
        Capabilities: [40] Express (v1) Downstream Port (Slot-), MSI 00
               DevCap: MaxPayload 2048 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
                       ExtTag+ RBE+ FLReset-
               DevCtl: Report errors: Correctable- Non-Fatal- Fatal+ Unsupported-
                       RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                       MaxPayload 128 bytes, MaxReadReq 128 bytes
               DevSta: CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr- TransPend-
               LnkCap: Port #3, Speed 2.5GT/s, Width x4, ASPM L0s L1, Latency L0 <512ns, L1 <4us
                       ClockPM- Surprise+ LLActRep+ BwNot-
               LnkCtl: ASPM Disabled; Disabled- Retrain- CommClk-
                       ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
               LnkSta: Speed 2.5GT/s, Width x4, TrErr- Train- SlotClk+ DLActive+ BWMgmt- ABWMgmt-
        Capabilities: [c0] Power Management version 3
               Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
               Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [d0] MSI: Enable+ Count=1/1 Maskable- 64bit+
               Address: 00000000fee00000  Data: 40b9
        Capabilities: [100] Advanced Error Reporting
               UESta:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
               UEMsk:  DLP- SDES- TLP+ FCP- CmpltTO- CmpltAbrt- UnxCmplt+ RxOF- MalfTLP- ECRC+ UnsupReq+ ACSViol-
               UESvrt: DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
               CESta:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
               CEMsk:  RxErr+ BadTLP+ BadDLLP+ Rollover+ Timeout+ NonFatalErr+
               AERCap: First Error Pointer: 00, GenCap+ CGenEn- ChkCap+ ChkEn-
        Capabilities: [200] Virtual Channel <?>
        Kernel driver in use: pcieport
        Kernel modules: shpchp

02:04.0 PCI bridge: Integrated Device Technology, Inc. PES24T6 PCI Express Switch (rev 0e) (prog-if 00 [Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Bus: primary=02, secondary=06, subordinate=07, sec-latency=0
        I/O behind bridge: 0000f000-00000fff
        Memory behind bridge: da000000-dbffffff
        Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
        BridgeCtl: Parity+ SERR+ NoISA+ VGA- MAbort- >Reset- FastB2B-
               PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
        Capabilities: [40] Express (v1) Downstream Port (Slot-), MSI 00
               DevCap: MaxPayload 2048 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
                       ExtTag+ RBE+ FLReset-
               DevCtl: Report errors: Correctable- Non-Fatal- Fatal+ Unsupported-
                       RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                       MaxPayload 128 bytes, MaxReadReq 128 bytes
               DevSta: CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr- TransPend-
               LnkCap: Port #4, Speed 2.5GT/s, Width x4, ASPM L0s L1, Latency L0 <512ns, L1 <4us
                       ClockPM- Surprise+ LLActRep+ BwNot-
               LnkCtl: ASPM Disabled; Disabled- Retrain- CommClk-
                       ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
               LnkSta: Speed 2.5GT/s, Width x4, TrErr- Train- SlotClk+ DLActive+ BWMgmt- ABWMgmt-
        Capabilities: [c0] Power Management version 3
               Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
               Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [d0] MSI: Enable+ Count=1/1 Maskable- 64bit+
               Address: 00000000fee00000  Data: 40c1
        Capabilities: [100] Advanced Error Reporting
               UESta:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
               UEMsk:  DLP- SDES- TLP+ FCP- CmpltTO- CmpltAbrt- UnxCmplt+ RxOF- MalfTLP- ECRC+ UnsupReq+ ACSViol-
               UESvrt: DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
               CESta:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
               CEMsk:  RxErr+ BadTLP+ BadDLLP+ Rollover+ Timeout+ NonFatalErr+
               AERCap: First Error Pointer: 00, GenCap+ CGenEn- ChkCap+ ChkEn-
        Capabilities: [200] Virtual Channel <?>
        Kernel driver in use: pcieport
        Kernel modules: shpchp

02:05.0 PCI bridge: Integrated Device Technology, Inc. PES24T6 PCI Express Switch (rev 0e) (prog-if 00 [Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Bus: primary=02, secondary=04, subordinate=05, sec-latency=0
        I/O behind bridge: 0000f000-00000fff
        Memory behind bridge: dc000000-ddffffff
        Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
        BridgeCtl: Parity+ SERR+ NoISA+ VGA- MAbort- >Reset- FastB2B-
               PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
        Capabilities: [40] Express (v1) Downstream Port (Slot-), MSI 00
               DevCap: MaxPayload 2048 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
                       ExtTag+ RBE+ FLReset-
               DevCtl: Report errors: Correctable- Non-Fatal- Fatal+ Unsupported-
                       RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                       MaxPayload 128 bytes, MaxReadReq 128 bytes
               DevSta: CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr- TransPend-
               LnkCap: Port #5, Speed 2.5GT/s, Width x4, ASPM L0s L1, Latency L0 <512ns, L1 <4us
                       ClockPM- Surprise+ LLActRep+ BwNot-
               LnkCtl: ASPM Disabled; Disabled- Retrain- CommClk-
                       ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
               LnkSta: Speed 2.5GT/s, Width x4, TrErr- Train- SlotClk+ DLActive+ BWMgmt- ABWMgmt-
        Capabilities: [c0] Power Management version 3
               Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
               Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [d0] MSI: Enable+ Count=1/1 Maskable- 64bit+
               Address: 00000000fee00000  Data: 40c9
        Capabilities: [100] Advanced Error Reporting
               UESta:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
               UEMsk:  DLP- SDES- TLP+ FCP- CmpltTO- CmpltAbrt- UnxCmplt+ RxOF- MalfTLP- ECRC+ UnsupReq+ ACSViol-
               UESvrt: DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
               CESta:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
               CEMsk:  RxErr+ BadTLP+ BadDLLP+ Rollover+ Timeout+ NonFatalErr+
               AERCap: First Error Pointer: 00, GenCap+ CGenEn- ChkCap+ ChkEn-
        Capabilities: [200] Virtual Channel <?>
        Kernel driver in use: pcieport
        Kernel modules: shpchp

04:00.0 PCI bridge: Broadcom EPB PCI-Express to PCI-X Bridge (rev c3) (prog-if 00 [Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Bus: primary=04, secondary=05, subordinate=05, sec-latency=64
        I/O behind bridge: 0000f000-00000fff
        Memory behind bridge: dc000000-ddffffff
        Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort+ <SERR- <PERR-
        BridgeCtl: Parity+ SERR+ NoISA+ VGA- MAbort- >Reset- FastB2B-
               PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
        Capabilities: [60] Express (v1) PCI/PCI-X Bridge, MSI 00
               DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
                       ExtTag+ AttnBtn- AttnInd- PwrInd- RBE- FLReset-
               DevCtl: Report errors: Correctable- Non-Fatal- Fatal+ Unsupported-
                       RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop- BrConfRtry-
                       MaxPayload 128 bytes, MaxReadReq 128 bytes
               DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
               LnkCap: Port #0, Speed 2.5GT/s, Width x4, ASPM L0s L1, Latency L0 <4us, L1 <4us
                       ClockPM- Surprise- LLActRep- BwNot-
               LnkCtl: ASPM Disabled; Disabled- Retrain- CommClk-
                       ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
               LnkSta: Speed 2.5GT/s, Width x4, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
        Capabilities: [90] PCI-X bridge device
               Secondary Status: 64bit+ 133MHz+ SCD- USC- SCO- SRD- Freq=133MHz
               Status: Dev=04:00.0 64bit- 133MHz- SCD- USC- SCO- SRD-
               Upstream: Capacity=0 CommitmentLimit=0
               Downstream: Capacity=0 CommitmentLimit=0
        Capabilities: [b0] Power Management version 2
               Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
               Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [100] Advanced Error Reporting
               UESta:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
               UEMsk:  DLP- SDES- TLP+ FCP- CmpltTO+ CmpltAbrt+ UnxCmplt+ RxOF- MalfTLP- ECRC- UnsupReq+ ACSViol-
               UESvrt: DLP+ SDES- TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
               CESta:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr-
               CEMsk:  RxErr+ BadTLP+ BadDLLP+ Rollover+ Timeout+ NonFatalErr-
               AERCap: First Error Pointer: 00, GenCap- CGenEn- ChkCap- ChkEn-
        Capabilities: [14c] Power Budgeting <?>
        Capabilities: [160] Device Serial Number 84-2b-2b-ff-fe-49-ee-24
        Kernel modules: shpchp

05:00.0 Ethernet controller: Broadcom Corporation NetXtreme II BCM5708 Gigabit Ethernet (rev 12)
        Subsystem: Dell PowerEdge R900 Broadcom NetXtreme II BCM5708
        Control: I/O- Mem+ BusMaster+ SpecCycle+ MemWINV+ VGASnoop- ParErr+ Stepping- SERR+ FastB2B- DisINTx-
        Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 32 (16000ns min), Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 38
        Region 0: Memory at dc000000 (64-bit, non-prefetchable) [size=32M]
        Capabilities: [40] PCI-X non-bridge device
               Command: DPERE- ERO- RBC=512 OST=8
               Status: Dev=05:00.0 64bit+ 133MHz+ SCD- USC- DC=simple DMMRBC=512 DMOST=8 DMCRS=32 RSCEM- 266MHz- 533MHz-
        Capabilities: [48] Power Management version 2
               Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot+,D3cold+)
               Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=1 PME-
        Capabilities: [50] Vital Product Data
               Product Name: Broadcom NetXtreme II Ethernet Controller
               Read-only fields:
                       [PN] Part number: BCM95708B2
                       [EC] Engineering changes: 220197-2
                       [SN] Serial number: 0123456789
                       [MN] Manufacture ID: 31 30 32 38
                       [V0] Vendor specific: 6.2.12
                       [RV] Reserved: checksum good, 22 byte(s) reserved
               End
        Capabilities: [58] MSI: Enable- Count=1/1 Maskable- 64bit+
               Address: e85b72a901506378  Data: 5654
        Kernel driver in use: bnx2
        Kernel modules: bnx2

06:00.0 PCI bridge: Broadcom EPB PCI-Express to PCI-X Bridge (rev c3) (prog-if 00 [Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Bus: primary=06, secondary=07, subordinate=07, sec-latency=64
        I/O behind bridge: 0000f000-00000fff
        Memory behind bridge: da000000-dbffffff
        Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort+ <SERR- <PERR-
        BridgeCtl: Parity+ SERR+ NoISA+ VGA- MAbort- >Reset- FastB2B-
               PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
        Capabilities: [60] Express (v1) PCI/PCI-X Bridge, MSI 00
               DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
                       ExtTag+ AttnBtn- AttnInd- PwrInd- RBE- FLReset-
               DevCtl: Report errors: Correctable- Non-Fatal- Fatal+ Unsupported-
                       RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop- BrConfRtry-
                       MaxPayload 128 bytes, MaxReadReq 128 bytes
               DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
               LnkCap: Port #0, Speed 2.5GT/s, Width x4, ASPM L0s L1, Latency L0 <4us, L1 <4us
                       ClockPM- Surprise- LLActRep- BwNot-
               LnkCtl: ASPM Disabled; Disabled- Retrain- CommClk-
                       ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
               LnkSta: Speed 2.5GT/s, Width x4, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
        Capabilities: [90] PCI-X bridge device
               Secondary Status: 64bit+ 133MHz+ SCD- USC- SCO- SRD- Freq=133MHz
               Status: Dev=06:00.0 64bit- 133MHz- SCD- USC- SCO- SRD-
               Upstream: Capacity=0 CommitmentLimit=0
               Downstream: Capacity=0 CommitmentLimit=0
        Capabilities: [b0] Power Management version 2
               Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
               Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [100] Advanced Error Reporting
               UESta:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
               UEMsk:  DLP- SDES- TLP+ FCP- CmpltTO+ CmpltAbrt+ UnxCmplt+ RxOF- MalfTLP- ECRC- UnsupReq+ ACSViol-
               UESvrt: DLP+ SDES- TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
               CESta:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr-
               CEMsk:  RxErr+ BadTLP+ BadDLLP+ Rollover+ Timeout+ NonFatalErr-
               AERCap: First Error Pointer: 00, GenCap- CGenEn- ChkCap- ChkEn-
        Capabilities: [14c] Power Budgeting <?>
        Capabilities: [160] Device Serial Number 84-2b-2b-ff-fe-49-ee-26
        Kernel modules: shpchp

07:00.0 Ethernet controller: Broadcom Corporation NetXtreme II BCM5708 Gigabit Ethernet (rev 12)
        Subsystem: Dell PowerEdge R900 Broadcom NetXtreme II BCM5708
        Control: I/O- Mem+ BusMaster+ SpecCycle+ MemWINV+ VGASnoop- ParErr+ Stepping- SERR+ FastB2B- DisINTx-
        Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 32 (16000ns min), Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 37
        Region 0: Memory at da000000 (64-bit, non-prefetchable) [size=32M]
        Capabilities: [40] PCI-X non-bridge device
               Command: DPERE- ERO- RBC=512 OST=8
               Status: Dev=07:00.0 64bit+ 133MHz+ SCD- USC- DC=simple DMMRBC=512 DMOST=8 DMCRS=32 RSCEM- 266MHz- 533MHz-
        Capabilities: [48] Power Management version 2
               Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot+,D3cold+)
               Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=1 PME-
        Capabilities: [50] Vital Product Data
               Product Name: Broadcom NetXtreme II Ethernet Controller
               Read-only fields:
                       [PN] Part number: BCM95708B2
                       [EC] Engineering changes: 220197-2
                       [SN] Serial number: 0123456789
                       [MN] Manufacture ID: 31 30 32 38
                       [V0] Vendor specific: 6.2.12
                       [RV] Reserved: checksum good, 22 byte(s) reserved
               End
        Capabilities: [58] MSI: Enable- Count=1/1 Maskable- 64bit+
               Address: 26af65fd502feef0  Data: 1d51
        Kernel driver in use: bnx2
        Kernel modules: bnx2

08:00.0 PCI bridge: Broadcom EPB PCI-Express to PCI-X Bridge (rev c3) (prog-if 00 [Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Bus: primary=08, secondary=09, subordinate=09, sec-latency=64
        I/O behind bridge: 0000f000-00000fff
        Memory behind bridge: d8000000-d9ffffff
        Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort+ <SERR- <PERR-
        BridgeCtl: Parity+ SERR+ NoISA+ VGA- MAbort- >Reset- FastB2B-
               PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
        Capabilities: [60] Express (v1) PCI/PCI-X Bridge, MSI 00
               DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
                       ExtTag+ AttnBtn- AttnInd- PwrInd- RBE- FLReset-
               DevCtl: Report errors: Correctable- Non-Fatal- Fatal+ Unsupported-
                       RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop- BrConfRtry-
                       MaxPayload 128 bytes, MaxReadReq 128 bytes
               DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
               LnkCap: Port #0, Speed 2.5GT/s, Width x4, ASPM L0s L1, Latency L0 <4us, L1 <4us
                       ClockPM- Surprise- LLActRep- BwNot-
               LnkCtl: ASPM Disabled; Disabled- Retrain- CommClk-
                       ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
               LnkSta: Speed 2.5GT/s, Width x4, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
        Capabilities: [90] PCI-X bridge device
               Secondary Status: 64bit+ 133MHz+ SCD- USC- SCO- SRD- Freq=133MHz
               Status: Dev=08:00.0 64bit- 133MHz- SCD- USC- SCO- SRD-
               Upstream: Capacity=0 CommitmentLimit=0
               Downstream: Capacity=0 CommitmentLimit=0
        Capabilities: [b0] Power Management version 2
               Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
               Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [100] Advanced Error Reporting
               UESta:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
               UEMsk:  DLP- SDES- TLP+ FCP- CmpltTO+ CmpltAbrt+ UnxCmplt+ RxOF- MalfTLP- ECRC- UnsupReq+ ACSViol-
               UESvrt: DLP+ SDES- TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
               CESta:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr-
               CEMsk:  RxErr+ BadTLP+ BadDLLP+ Rollover+ Timeout+ NonFatalErr-
               AERCap: First Error Pointer: 00, GenCap- CGenEn- ChkCap- ChkEn-
        Capabilities: [14c] Power Budgeting <?>
        Capabilities: [160] Device Serial Number 84-2b-2b-ff-fe-49-ee-28
        Kernel modules: shpchp

09:00.0 Ethernet controller: Broadcom Corporation NetXtreme II BCM5708 Gigabit Ethernet (rev 12)
        Subsystem: Dell PowerEdge R900 Broadcom NetXtreme II BCM5708
        Control: I/O- Mem+ BusMaster+ SpecCycle+ MemWINV+ VGASnoop- ParErr+ Stepping- SERR+ FastB2B- DisINTx-
        Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 32 (16000ns min), Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 19
        Region 0: Memory at d8000000 (64-bit, non-prefetchable) [size=32M]
        Capabilities: [40] PCI-X non-bridge device
               Command: DPERE- ERO- RBC=512 OST=8
               Status: Dev=09:00.0 64bit+ 133MHz+ SCD- USC- DC=simple DMMRBC=512 DMOST=8 DMCRS=32 RSCEM- 266MHz- 533MHz-
        Capabilities: [48] Power Management version 2
               Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot+,D3cold+)
               Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=1 PME-
        Capabilities: [50] Vital Product Data
               Product Name: Broadcom NetXtreme II Ethernet Controller
               Read-only fields:
                       [PN] Part number: BCM95708B2
                       [EC] Engineering changes: 220197-2
                       [SN] Serial number: 0123456789
                       [MN] Manufacture ID: 31 30 32 38
                       [V0] Vendor specific: 6.2.12
                       [RV] Reserved: checksum good, 22 byte(s) reserved
               End
        Capabilities: [58] MSI: Enable- Count=1/1 Maskable- 64bit+
               Address: 7d55da6f3c5edf64  Data: fffd
        Kernel driver in use: bnx2
        Kernel modules: bnx2

0a:00.0 PCI bridge: Broadcom EPB PCI-Express to PCI-X Bridge (rev c3) (prog-if 00 [Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Bus: primary=0a, secondary=0b, subordinate=0b, sec-latency=64
        I/O behind bridge: 0000f000-00000fff
        Memory behind bridge: d6000000-d7ffffff
        Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort+ <SERR- <PERR-
        BridgeCtl: Parity+ SERR+ NoISA+ VGA- MAbort- >Reset- FastB2B-
               PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
        Capabilities: [60] Express (v1) PCI/PCI-X Bridge, MSI 00
               DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
                       ExtTag+ AttnBtn- AttnInd- PwrInd- RBE- FLReset-
               DevCtl: Report errors: Correctable- Non-Fatal- Fatal+ Unsupported-
                       RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop- BrConfRtry-
                       MaxPayload 128 bytes, MaxReadReq 128 bytes
               DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
               LnkCap: Port #0, Speed 2.5GT/s, Width x4, ASPM L0s L1, Latency L0 <4us, L1 <4us
                       ClockPM- Surprise- LLActRep- BwNot-
               LnkCtl: ASPM Disabled; Disabled- Retrain- CommClk-
                       ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
               LnkSta: Speed 2.5GT/s, Width x4, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
        Capabilities: [90] PCI-X bridge device
               Secondary Status: 64bit+ 133MHz+ SCD- USC- SCO- SRD- Freq=133MHz
               Status: Dev=0a:00.0 64bit- 133MHz- SCD- USC- SCO- SRD-
               Upstream: Capacity=0 CommitmentLimit=0
               Downstream: Capacity=0 CommitmentLimit=0
        Capabilities: [b0] Power Management version 2
               Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
               Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [100] Advanced Error Reporting
               UESta:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
               UEMsk:  DLP- SDES- TLP+ FCP- CmpltTO+ CmpltAbrt+ UnxCmplt+ RxOF- MalfTLP- ECRC- UnsupReq+ ACSViol-
               UESvrt: DLP+ SDES- TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
               CESta:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr-
               CEMsk:  RxErr+ BadTLP+ BadDLLP+ Rollover+ Timeout+ NonFatalErr-
               AERCap: First Error Pointer: 00, GenCap- CGenEn- ChkCap- ChkEn-
        Capabilities: [14c] Power Budgeting <?>
        Capabilities: [160] Device Serial Number 84-2b-2b-ff-fe-49-ee-2a
        Kernel modules: shpchp

0b:00.0 Ethernet controller: Broadcom Corporation NetXtreme II BCM5708 Gigabit Ethernet (rev 12)
        Subsystem: Dell PowerEdge R900 Broadcom NetXtreme II BCM5708
        Control: I/O- Mem+ BusMaster+ SpecCycle+ MemWINV+ VGASnoop- ParErr+ Stepping- SERR+ FastB2B- DisINTx-
        Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 32 (16000ns min), Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 18
        Region 0: Memory at d6000000 (64-bit, non-prefetchable) [size=32M]
        Capabilities: [40] PCI-X non-bridge device
               Command: DPERE- ERO- RBC=512 OST=8
               Status: Dev=0b:00.0 64bit+ 133MHz+ SCD- USC- DC=simple DMMRBC=512 DMOST=8 DMCRS=32 RSCEM- 266MHz- 533MHz-
        Capabilities: [48] Power Management version 2
               Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot+,D3cold+)
               Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=1 PME-
        Capabilities: [50] Vital Product Data
               Product Name: Broadcom NetXtreme II Ethernet Controller
               Read-only fields:
                       [PN] Part number: BCM95708B2
                       [EC] Engineering changes: 220197-2
                       [SN] Serial number: 0123456789
                       [MN] Manufacture ID: 31 30 32 38
                       [V0] Vendor specific: 6.2.12
                       [RV] Reserved: checksum good, 22 byte(s) reserved
               End
        Capabilities: [58] MSI: Enable- Count=1/1 Maskable- 64bit+
               Address: 2caec3654f27b3f0  Data: 7dec
        Kernel driver in use: bnx2
        Kernel modules: bnx2

0c:00.0 PCI bridge: Integrated Device Technology, Inc. PES24N3A PCI Express Switch (rev 0e) (prog-if 00 [Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Bus: primary=0c, secondary=0d, subordinate=0f, sec-latency=0
        I/O behind bridge: 0000f000-00000fff
        Memory behind bridge: fff00000-000fffff
        Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
        BridgeCtl: Parity+ SERR+ NoISA+ VGA- MAbort- >Reset- FastB2B-
               PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
        Capabilities: [40] Express (v1) Upstream Port, MSI 00
               DevCap: MaxPayload 2048 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
                       ExtTag+ AttnBtn- AttnInd- PwrInd- RBE+ FLReset-SlotPowerLimit 0.000000W
               DevCtl: Report errors: Correctable- Non-Fatal- Fatal+ Unsupported-
                       RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                       MaxPayload 128 bytes, MaxReadReq 128 bytes
               DevSta: CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr- TransPend-
               LnkCap: Port #0, Speed 2.5GT/s, Width x8, ASPM L0s L1, Latency L0 <512ns, L1 <4us
                       ClockPM- Surprise- LLActRep- BwNot-
               LnkCtl: ASPM Disabled; Disabled- Retrain- CommClk-
                       ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
               LnkSta: Speed 2.5GT/s, Width x8, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
        Capabilities: [c0] Power Management version 3
               Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
               Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [100] Advanced Error Reporting
               UESta:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
               UEMsk:  DLP- SDES- TLP+ FCP- CmpltTO- CmpltAbrt- UnxCmplt+ RxOF- MalfTLP- ECRC+ UnsupReq+ ACSViol-
               UESvrt: DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
               CESta:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
               CEMsk:  RxErr+ BadTLP+ BadDLLP+ Rollover+ Timeout+ NonFatalErr+
               AERCap: First Error Pointer: 00, GenCap+ CGenEn- ChkCap+ ChkEn-
        Capabilities: [200] Virtual Channel <?>
        Kernel driver in use: pcieport
        Kernel modules: shpchp

0d:02.0 PCI bridge: Integrated Device Technology, Inc. PES24N3A PCI Express Switch (rev 0e) (prog-if 00 [Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Bus: primary=0d, secondary=0f, subordinate=0f, sec-latency=0
        I/O behind bridge: 0000f000-00000fff
        Memory behind bridge: fff00000-000fffff
        Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
        BridgeCtl: Parity+ SERR+ NoISA+ VGA- MAbort- >Reset- FastB2B-
               PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
        Capabilities: [40] Express (v1) Downstream Port (Slot+), MSI 00
               DevCap: MaxPayload 2048 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
                       ExtTag+ RBE+ FLReset-
               DevCtl: Report errors: Correctable- Non-Fatal- Fatal+ Unsupported-
                       RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                       MaxPayload 128 bytes, MaxReadReq 128 bytes
               DevSta: CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr- TransPend-
               LnkCap: Port #2, Speed 2.5GT/s, Width x8, ASPM L0s L1, Latency L0 <512ns, L1 <4us
                       ClockPM- Surprise+ LLActRep+ BwNot-
               LnkCtl: ASPM Disabled; Disabled+ Retrain- CommClk-
                       ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
               LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train+ SlotClk+ DLActive- BWMgmt- ABWMgmt-
               SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- Surpise-
                       Slot #  2, PowerLimit 25.000000; Interlock- NoCompl-
               SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
                       Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
               SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
                       Changed: MRL- PresDet- LinkState-
        Capabilities: [c0] Power Management version 3
               Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
               Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [d0] MSI: Enable+ Count=1/1 Maskable- 64bit+
               Address: 00000000fee00000  Data: 40d1
        Capabilities: [100] Advanced Error Reporting
               UESta:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
               UEMsk:  DLP- SDES- TLP+ FCP- CmpltTO- CmpltAbrt- UnxCmplt+ RxOF- MalfTLP- ECRC+ UnsupReq+ ACSViol-
               UESvrt: DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
               CESta:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
               CEMsk:  RxErr+ BadTLP+ BadDLLP+ Rollover+ Timeout+ NonFatalErr+
               AERCap: First Error Pointer: 00, GenCap+ CGenEn- ChkCap+ ChkEn-
        Capabilities: [200] Virtual Channel <?>
        Kernel driver in use: pcieport
        Kernel modules: shpchp

0d:04.0 PCI bridge: Integrated Device Technology, Inc. PES24N3A PCI Express Switch (rev 0e) (prog-if 00 [Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Bus: primary=0d, secondary=0e, subordinate=0e, sec-latency=0
        I/O behind bridge: 0000f000-00000fff
        Memory behind bridge: fff00000-000fffff
        Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
        BridgeCtl: Parity+ SERR+ NoISA+ VGA- MAbort- >Reset- FastB2B-
               PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
        Capabilities: [40] Express (v1) Downstream Port (Slot+), MSI 00
               DevCap: MaxPayload 2048 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
                       ExtTag+ RBE+ FLReset-
               DevCtl: Report errors: Correctable- Non-Fatal- Fatal+ Unsupported-
                       RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                       MaxPayload 128 bytes, MaxReadReq 128 bytes
               DevSta: CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr- TransPend-
               LnkCap: Port #4, Speed 2.5GT/s, Width x8, ASPM L0s L1, Latency L0 <512ns, L1 <4us
                       ClockPM- Surprise+ LLActRep+ BwNot-
               LnkCtl: ASPM Disabled; Disabled+ Retrain- CommClk-
                       ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
               LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train+ SlotClk+ DLActive- BWMgmt- ABWMgmt-
               SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- Surpise-
                       Slot #  1, PowerLimit 25.000000; Interlock- NoCompl-
               SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
                       Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
               SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
                       Changed: MRL- PresDet- LinkState-
        Capabilities: [c0] Power Management version 3
               Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
               Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [d0] MSI: Enable+ Count=1/1 Maskable- 64bit+
               Address: 00000000fee00000  Data: 40d9
        Capabilities: [100] Advanced Error Reporting
               UESta:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
               UEMsk:  DLP- SDES- TLP+ FCP- CmpltTO- CmpltAbrt- UnxCmplt+ RxOF- MalfTLP- ECRC+ UnsupReq+ ACSViol-
               UESvrt: DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
               CESta:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
               CEMsk:  RxErr+ BadTLP+ BadDLLP+ Rollover+ Timeout+ NonFatalErr+
               AERCap: First Error Pointer: 00, GenCap+ CGenEn- ChkCap+ ChkEn-
        Capabilities: [200] Virtual Channel <?>
        Kernel driver in use: pcieport
        Kernel modules: shpchp

10:00.0 PCI bridge: Integrated Device Technology, Inc. PES24N3A PCI Express Switch (rev 0e) (prog-if 00 [Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Bus: primary=10, secondary=11, subordinate=13, sec-latency=0
        I/O behind bridge: 0000f000-00000fff
        Memory behind bridge: fff00000-000fffff
        Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
        BridgeCtl: Parity+ SERR+ NoISA+ VGA- MAbort- >Reset- FastB2B-
               PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
        Capabilities: [40] Express (v1) Upstream Port, MSI 00
               DevCap: MaxPayload 2048 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
                       ExtTag+ AttnBtn- AttnInd- PwrInd- RBE+ FLReset-SlotPowerLimit 0.000000W
               DevCtl: Report errors: Correctable- Non-Fatal- Fatal+ Unsupported-
                       RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                       MaxPayload 128 bytes, MaxReadReq 128 bytes
               DevSta: CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr- TransPend-
               LnkCap: Port #0, Speed 2.5GT/s, Width x8, ASPM L0s L1, Latency L0 <512ns, L1 <4us
                       ClockPM- Surprise- LLActRep- BwNot-
               LnkCtl: ASPM Disabled; Disabled- Retrain- CommClk-
                       ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
               LnkSta: Speed 2.5GT/s, Width x8, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
        Capabilities: [c0] Power Management version 3
               Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
               Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [100] Advanced Error Reporting
               UESta:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
               UEMsk:  DLP- SDES- TLP+ FCP- CmpltTO- CmpltAbrt- UnxCmplt+ RxOF- MalfTLP- ECRC+ UnsupReq+ ACSViol-
               UESvrt: DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
               CESta:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
               CEMsk:  RxErr+ BadTLP+ BadDLLP+ Rollover+ Timeout+ NonFatalErr+
               AERCap: First Error Pointer: 00, GenCap+ CGenEn- ChkCap+ ChkEn-
        Capabilities: [200] Virtual Channel <?>
        Kernel driver in use: pcieport
        Kernel modules: shpchp

11:02.0 PCI bridge: Integrated Device Technology, Inc. PES24N3A PCI Express Switch (rev 0e) (prog-if 00 [Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Bus: primary=11, secondary=13, subordinate=13, sec-latency=0
        I/O behind bridge: 0000f000-00000fff
        Memory behind bridge: fff00000-000fffff
        Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
        BridgeCtl: Parity+ SERR+ NoISA+ VGA- MAbort- >Reset- FastB2B-
               PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
        Capabilities: [40] Express (v1) Downstream Port (Slot+), MSI 00
               DevCap: MaxPayload 2048 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
                       ExtTag+ RBE+ FLReset-
               DevCtl: Report errors: Correctable- Non-Fatal- Fatal+ Unsupported-
                       RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                       MaxPayload 128 bytes, MaxReadReq 128 bytes
               DevSta: CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr- TransPend-
               LnkCap: Port #2, Speed 2.5GT/s, Width x8, ASPM L0s L1, Latency L0 <512ns, L1 <4us
                       ClockPM- Surprise+ LLActRep+ BwNot-
               LnkCtl: ASPM Disabled; Disabled+ Retrain- CommClk-
                       ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
               LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train+ SlotClk+ DLActive- BWMgmt- ABWMgmt-
               SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- Surpise-
                       Slot #  4, PowerLimit 25.000000; Interlock- NoCompl-
               SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
                       Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
               SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
                       Changed: MRL- PresDet- LinkState-
        Capabilities: [c0] Power Management version 3
               Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
               Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [d0] MSI: Enable+ Count=1/1 Maskable- 64bit+
               Address: 00000000fee00000  Data: 40e1
        Capabilities: [100] Advanced Error Reporting
               UESta:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
               UEMsk:  DLP- SDES- TLP+ FCP- CmpltTO- CmpltAbrt- UnxCmplt+ RxOF- MalfTLP- ECRC+ UnsupReq+ ACSViol-
               UESvrt: DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
               CESta:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
               CEMsk:  RxErr+ BadTLP+ BadDLLP+ Rollover+ Timeout+ NonFatalErr+
               AERCap: First Error Pointer: 00, GenCap+ CGenEn- ChkCap+ ChkEn-
        Capabilities: [200] Virtual Channel <?>
        Kernel driver in use: pcieport
        Kernel modules: shpchp

11:04.0 PCI bridge: Integrated Device Technology, Inc. PES24N3A PCI Express Switch (rev 0e) (prog-if 00 [Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Bus: primary=11, secondary=12, subordinate=12, sec-latency=0
        I/O behind bridge: 0000f000-00000fff
        Memory behind bridge: fff00000-000fffff
        Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
        BridgeCtl: Parity+ SERR+ NoISA+ VGA- MAbort- >Reset- FastB2B-
               PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
        Capabilities: [40] Express (v1) Downstream Port (Slot+), MSI 00
                DevCap: MaxPayload 2048 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
                       ExtTag+ RBE+ FLReset-
               DevCtl: Report errors: Correctable- Non-Fatal- Fatal+ Unsupported-
                       RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                       MaxPayload 128 bytes, MaxReadReq 128 bytes
               DevSta: CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr- TransPend-
               LnkCap: Port #4, Speed 2.5GT/s, Width x8, ASPM L0s L1, Latency L0 <512ns, L1 <4us
                       ClockPM- Surprise+ LLActRep+ BwNot-
               LnkCtl: ASPM Disabled; Disabled+ Retrain- CommClk-
                       ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
               LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train+ SlotClk+ DLActive- BWMgmt- ABWMgmt-
               SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- Surpise-
                       Slot #  3, PowerLimit 25.000000; Interlock- NoCompl-
               SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
                       Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
               SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
                       Changed: MRL- PresDet- LinkState-
        Capabilities: [c0] Power Management version 3
               Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
               Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [d0] MSI: Enable+ Count=1/1 Maskable- 64bit+
               Address: 00000000fee00000  Data: 40e9
        Capabilities: [100] Advanced Error Reporting
               UESta:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
               UEMsk:  DLP- SDES- TLP+ FCP- CmpltTO- CmpltAbrt- UnxCmplt+ RxOF- MalfTLP- ECRC+ UnsupReq+ ACSViol-
               UESvrt: DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
               CESta:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
               CEMsk:  RxErr+ BadTLP+ BadDLLP+ Rollover+ Timeout+ NonFatalErr+
               AERCap: First Error Pointer: 00, GenCap+ CGenEn- ChkCap+ ChkEn-
        Capabilities: [200] Virtual Channel <?>
        Kernel driver in use: pcieport
        Kernel modules: shpchp

16:00.0 PCI bridge: Intel Corporation 6311ESB/6321ESB PCI Express Upstream Port (rev 01) (prog-if 00 [Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+ Stepping- SERR+ FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Bus: primary=16, secondary=17, subordinate=19, sec-latency=0
        I/O behind bridge: 0000d000-0000efff
        Memory behind bridge: de200000-de5fffff
        Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
        BridgeCtl: Parity+ SERR+ NoISA+ VGA- MAbort- >Reset- FastB2B-
               PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
        Capabilities: [44] Express (v1) Upstream Port, MSI 00
               DevCap: MaxPayload 256 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
                       ExtTag- AttnBtn- AttnInd- PwrInd- RBE- FLReset-SlotPowerLimit 0.000000W
               DevCtl: Report errors: Correctable- Non-Fatal- Fatal+ Unsupported-
                       RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                       MaxPayload 128 bytes, MaxReadReq 4096 bytes
               DevSta: CorrErr- UncorrErr+ FatalErr- UnsuppReq+ AuxPwr- TransPend-
               LnkCap: Port #0, Speed 2.5GT/s, Width x8, ASPM L0s, Latency L0 unlimited, L1 unlimited
                       ClockPM- Surprise- LLActRep- BwNot-
               LnkCtl: ASPM Disabled; Disabled- Retrain- CommClk-
                       ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
               LnkSta: Speed 2.5GT/s, Width x4, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
        Capabilities: [70] Power Management version 2
               Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
               Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [80] Subsystem: Gammagraphx, Inc. (or missing ID) Device 0000
        Capabilities: [100] Advanced Error Reporting
               UESta:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq+ ACSViol-
               UEMsk:  DLP- SDES- TLP+ FCP- CmpltTO+ CmpltAbrt+ UnxCmplt+ RxOF- MalfTLP- ECRC- UnsupReq+ ACSViol-
               UESvrt: DLP+ SDES- TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
               CESta:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr-
               CEMsk:  RxErr+ BadTLP+ BadDLLP+ Rollover+ Timeout+ NonFatalErr-
               AERCap: First Error Pointer: 14, GenCap- CGenEn- ChkCap- ChkEn-
        Kernel modules: shpchp

16:00.3 PCI bridge: Intel Corporation 6311ESB/6321ESB PCI Express to PCI-X Bridge (rev 01) (prog-if 00 [Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+ Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Bus: primary=16, secondary=1a, subordinate=1a, sec-latency=64
        I/O behind bridge: 0000f000-00000fff
        Memory behind bridge: fff00000-000fffff
        Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
        Secondary status: 66MHz+ FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort+ <SERR- <PERR-
        BridgeCtl: Parity+ SERR+ NoISA+ VGA- MAbort- >Reset- FastB2B-
               PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
        Capabilities: [44] Express (v1) PCI/PCI-X Bridge, MSI 00
               DevCap: MaxPayload 256 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
                       ExtTag- AttnBtn- AttnInd- PwrInd- RBE- FLReset-
               DevCtl: Report errors: Correctable- Non-Fatal- Fatal+ Unsupported-
                       RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop- BrConfRtry-
                       MaxPayload 128 bytes, MaxReadReq 256 bytes
               DevSta: CorrErr- UncorrErr+ FatalErr- UnsuppReq+ AuxPwr- TransPend-
               LnkCap: Port #0, Speed 2.5GT/s, Width x8, ASPM L0s, Latency L0 unlimited, L1 unlimited
                       ClockPM- Surprise- LLActRep- BwNot-
               LnkCtl: ASPM Disabled; Disabled- Retrain- CommClk-
                       ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
               LnkSta: Speed 2.5GT/s, Width x4, TrErr- Train- SlotClk- DLActive- BWMgmt- ABWMgmt-
        Capabilities: [6c] Power Management version 2
               Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
               Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [80] Subsystem: Gammagraphx, Inc. (or missing ID) Device 0000
        Capabilities: [d8] PCI-X bridge device
               Secondary Status: 64bit+ 133MHz+ SCD- USC- SCO- SRD- Freq=133MHz
               Status: Dev=00:00.3 64bit- 133MHz- SCD- USC- SCO- SRD-
               Upstream: Capacity=65535 CommitmentLimit=65535
               Downstream: Capacity=65535 CommitmentLimit=65535
        Capabilities: [100] Advanced Error Reporting
               UESta:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq+ ACSViol-
               UEMsk:  DLP- SDES- TLP+ FCP- CmpltTO+ CmpltAbrt+ UnxCmplt+ RxOF- MalfTLP- ECRC- UnsupReq+ ACSViol-
               UESvrt: DLP+ SDES- TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
               CESta:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr-
               CEMsk:  RxErr+ BadTLP+ BadDLLP+ Rollover+ Timeout+ NonFatalErr-
               AERCap: First Error Pointer: 14, GenCap- CGenEn- ChkCap- ChkEn-
        Kernel modules: shpchp

17:00.0 PCI bridge: Intel Corporation 6311ESB/6321ESB PCI Express Downstream Port E1 (rev 01) (prog-if 00 [Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+ Stepping- SERR+ FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Bus: primary=17, secondary=19, subordinate=19, sec-latency=0
        I/O behind bridge: 0000d000-0000dfff
        Memory behind bridge: de200000-de3fffff
        Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
        BridgeCtl: Parity+ SERR+ NoISA+ VGA- MAbort- >Reset- FastB2B-
               PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
        Capabilities: [44] Express (v1) Downstream Port (Slot+), MSI 00
               DevCap: MaxPayload 256 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
                       ExtTag- RBE- FLReset-
               DevCtl: Report errors: Correctable- Non-Fatal- Fatal+ Unsupported-
                       RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                       MaxPayload 128 bytes, MaxReadReq 4096 bytes
               DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
               LnkCap: Port #0, Speed 2.5GT/s, Width x4, ASPM L0s, Latency L0 unlimited, L1 unlimited
                       ClockPM- Surprise- LLActRep- BwNot-
               LnkCtl: ASPM Disabled; Disabled- Retrain- CommClk-
                       ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
               LnkSta: Speed 2.5GT/s, Width x4, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
               SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- Surpise-
                       Slot #  8, PowerLimit 25.000000; Interlock- NoCompl-
               SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
                       Control: AttnInd Off, PwrInd Off, Power- Interlock-
               SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
                       Changed: MRL- PresDet+ LinkState-
        Capabilities: [60] MSI: Enable- Count=1/1 Maskable- 64bit+
               Address: 0000000000000000  Data: 0000
        Capabilities: [70] Power Management version 2
               Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
               Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [80] Subsystem: Gammagraphx, Inc. (or missing ID) Device 0000
        Capabilities: [100] Advanced Error Reporting
               UESta:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
               UEMsk:  DLP- SDES- TLP+ FCP- CmpltTO+ CmpltAbrt+ UnxCmplt+ RxOF- MalfTLP- ECRC- UnsupReq+ ACSViol-
               UESvrt: DLP+ SDES- TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
               CESta:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr-
               CEMsk:  RxErr+ BadTLP+ BadDLLP+ Rollover+ Timeout+ NonFatalErr-
               AERCap: First Error Pointer: 00, GenCap- CGenEn- ChkCap- ChkEn-
        Kernel modules: shpchp

17:01.0 PCI bridge: Intel Corporation 6311ESB/6321ESB PCI Express Downstream Port E2 (rev 01) (prog-if 00 [Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+ Stepping- SERR+ FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Bus: primary=17, secondary=18, subordinate=18, sec-latency=0
        I/O behind bridge: 0000e000-0000efff
        Memory behind bridge: de400000-de5fffff
        Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
        BridgeCtl: Parity+ SERR+ NoISA+ VGA- MAbort- >Reset- FastB2B-
               PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
        Capabilities: [44] Express (v1) Downstream Port (Slot+), MSI 00
               DevCap: MaxPayload 256 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
                       ExtTag- RBE- FLReset-
               DevCtl: Report errors: Correctable- Non-Fatal- Fatal+ Unsupported-
                       RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                       MaxPayload 128 bytes, MaxReadReq 4096 bytes
               DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
               LnkCap: Port #0, Speed 2.5GT/s, Width x4, ASPM L0s, Latency L0 unlimited, L1 unlimited
                       ClockPM- Surprise- LLActRep- BwNot-
               LnkCtl: ASPM Disabled; Disabled- Retrain- CommClk-
                       ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
               LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
               SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- Surpise-
                       Slot #  7, PowerLimit 25.000000; Interlock- NoCompl-
               SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
                       Control: AttnInd Off, PwrInd Off, Power- Interlock-
               SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
                       Changed: MRL- PresDet+ LinkState-
        Capabilities: [60] MSI: Enable- Count=1/1 Maskable- 64bit+
               Address: 0000000000000000  Data: 0000
        Capabilities: [70] Power Management version 2
               Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
               Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [80] Subsystem: Gammagraphx, Inc. (or missing ID) Device 0000
        Capabilities: [100] Advanced Error Reporting
               UESta:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
               UEMsk:  DLP- SDES- TLP+ FCP- CmpltTO+ CmpltAbrt+ UnxCmplt+ RxOF- MalfTLP- ECRC- UnsupReq+ ACSViol-
                UESvrt: DLP+ SDES- TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
               CESta:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr-
               CEMsk:  RxErr+ BadTLP+ BadDLLP+ Rollover+ Timeout+ NonFatalErr-
               AERCap: First Error Pointer: 00, GenCap- CGenEn- ChkCap- ChkEn-
        Kernel modules: shpchp

18:00.0 Ethernet controller: Intel Corporation 82574L Gigabit Network Connection
        Subsystem: Intel Corporation Gigabit CT Desktop Adapter
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 18
        Region 0: Memory at de560000 (32-bit, non-prefetchable) [size=128K]
        Region 1: Memory at de580000 (32-bit, non-prefetchable) [size=512K]
        Region 2: I/O ports at ece0 [size=32]
        Region 3: Memory at de55c000 (32-bit, non-prefetchable) [size=16K]
        Expansion ROM at de400000 [disabled] [size=256K]
        Capabilities: [c8] Power Management version 2
               Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
               Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=1 PME-
        Capabilities: [d0] MSI: Enable- Count=1/1 Maskable- 64bit+
               Address: 0000000000000000  Data: 0000
        Capabilities: [e0] Express (v1) Endpoint, MSI 00
               DevCap: MaxPayload 256 bytes, PhantFunc 0, Latency L0s <512ns, L1 <64us
                       ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
               DevCtl: Report errors: Correctable- Non-Fatal- Fatal+ Unsupported-
                       RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
                       MaxPayload 128 bytes, MaxReadReq 512 bytes
               DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
               LnkCap: Port #1, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 <128ns, L1 <64us
                       ClockPM- Surprise- LLActRep- BwNot-
               LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk-
                       ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
               LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
        Capabilities: [a0] MSI-X: Enable+ Count=5 Masked-
               Vector table: BAR=3 offset=00000000
               PBA: BAR=3 offset=00002000
        Capabilities: [100] Advanced Error Reporting
               UESta:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
               UEMsk:  DLP- SDES- TLP+ FCP- CmpltTO+ CmpltAbrt+ UnxCmplt+ RxOF- MalfTLP- ECRC- UnsupReq+ ACSViol-
               UESvrt: DLP+ SDES- TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
               CESta:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr-
               CEMsk:  RxErr+ BadTLP+ BadDLLP+ Rollover+ Timeout+ NonFatalErr+
               AERCap: First Error Pointer: 00, GenCap- CGenEn- ChkCap- ChkEn-
        Capabilities: [140] Device Serial Number 00-1b-21-ff-ff-b3-b3-79
        Kernel driver in use: e1000e
        Kernel modules: e1000e

19:00.0 RAID bus controller: LSI Logic / Symbios Logic MegaRAID SAS 1078 (rev 04)
        Subsystem: Dell PERC 6/i Integrated RAID Controller
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 17
        Region 0: Memory at de380000 (64-bit, non-prefetchable) [size=256K]
        Region 2: I/O ports at dc00 [size=256]
        Region 3: Memory at de3c0000 (64-bit, non-prefetchable) [size=256K]
        Expansion ROM at de200000 [disabled] [size=32K]
        Capabilities: [b0] Express (v1) Endpoint, MSI 00
               DevCap: MaxPayload 256 bytes, PhantFunc 0, Latency L0s unlimited, L1 unlimited
                       ExtTag- AttnBtn- AttnInd- PwrInd- RBE- FLReset-
               DevCtl: Report errors: Correctable- Non-Fatal- Fatal+ Unsupported-
                       RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
                       MaxPayload 128 bytes, MaxReadReq 2048 bytes
               DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq+ AuxPwr- TransPend-
               LnkCap: Port #0, Speed 2.5GT/s, Width x8, ASPM L0s, Latency L0 <2us, L1 unlimited
                       ClockPM- Surprise- LLActRep- BwNot-
               LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk-
                       ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
               LnkSta: Speed 2.5GT/s, Width x4, TrErr- Train- SlotClk- DLActive- BWMgmt- ABWMgmt-
        Capabilities: [c4] MSI: Enable- Count=1/4 Maskable- 64bit+
               Address: 0000000000000000  Data: 0000
        Capabilities: [d4] MSI-X: Enable- Count=4 Masked-
               Vector table: BAR=0 offset=0003e000
               PBA: BAR=0 offset=00fff000
        Capabilities: [e0] Power Management version 2
               Flags: PMEClk- DSI- D1+ D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
               Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [ec] Vital Product Data
               Not readable
        Capabilities: [100] Power Budgeting <?>
        Kernel driver in use: megaraid_sas
        Kernel modules: megaraid_sas

1b:0c.0 VGA compatible controller: ATI Technologies Inc ES1000 (rev 02) (prog-if 00 [VGA controller])
        Subsystem: Dell PowerEdge R900 Embedded ATI ES1000
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping+ SERR+ FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 32 (2000ns min), Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 17
        Region 0: Memory at c8000000 (32-bit, prefetchable) [size=128M]
        Region 1: I/O ports at cc00 [size=256]
        Region 2: Memory at de6f0000 (32-bit, non-prefetchable) [size=64K]
        [virtual] Expansion ROM at de600000 [disabled] [size=128K]
        Capabilities: [50] Power Management version 2
               Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
               Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
        Kernel driver in use: radeon
        Kernel modules: radeon, radeonfb

[7.6.] SCSI information (from /proc/scsi/scsi)
Attached devices:
Host: scsi0 Channel: 00 Id: 00 Lun: 00
  Vendor: TEAC     Model: DVD-ROM DV-28SW  Rev: R.2A
  Type:   CD-ROM                           ANSI  SCSI revision: 05
Host: scsi2 Channel: 02 Id: 00 Lun: 00
  Vendor: DELL     Model: PERC 6/i         Rev: 1.22
  Type:   Direct-Access                    ANSI  SCSI revision: 05
[7.7.] Other information that might be relevant to the problem
       (please look in /proc and include all information that you
       think to be relevant):
[X.] Other notes, patches, fixes, workarounds:


