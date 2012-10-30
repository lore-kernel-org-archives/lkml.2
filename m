Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932533Ab2J3OI7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 10:08:59 -0400
Received: from mailxx.hitachi.co.jp ([133.145.228.50]:33678 "EHLO
	mailxx.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756656Ab2J3OI5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 10:08:57 -0400
X-AuditID: b753bd60-9544eba000002f78-e6-508fdef3a9ec
Message-ID: <508FDEF3.8030601@hitachi.com>
Date: Tue, 30 Oct 2012 23:06:43 +0900
From: Mitsuhiro Tanino <mitsuhiro.tanino.gm@hitachi.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:16.0) Gecko/20121010 Thunderbird/16.0.1
MIME-Version: 1.0
To: kexec@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [Patch 0/2] Exclude hwpoison page from vmcore dump
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,
Please find a set of patches that introduce a new "-p" option into
"makedumpfile" to exclude hwpoison page from vmcore dump.

Details as described below.

Problem
-------
Recently, according to increase large memory systems, possibility of
failures which come from memory crash are also increasing.
Regarding this, Linux has a hwpoison feature and this can isolate
uncorrectable error in memory which are reported as SRAO machine check.

However, when a user gets a core dump file using kdump, dump kernel
does not know which memory has uncorrectable error(SRAO) and
dump kernel touches memory which has uncorrectable error.
As a result, a fatal machine check occurs and a user fails to get vmcore.

This problem was previously discussed in the kexec community, with a
proposal to Slimdump framework (refer: mail threads pertaining to
http://lists.infradead.org/pipermail/kexec/2011-October/005586.html). 

Solution
--------
As Vivek mentioned in the above threads, "makedumpfile" has a 
filtering function and this can exclude some types of pages,
like zero page, free page, user data, etc, without saving the whole dump.
This function checks "pageflags" of struct page arrays and if
target page has a flag which is specified the "makedumpfile" option,
the page is excluded.
Using this function, "makedumpfile" can exclude poisoned pages which
has PG_hwpoison flag.

These patches introduce a new "-p" option into "makedumpfile" to
exclude hwpoison page from vmcore.


Test Results
------------
These patches are tested on 3.6.0-rc6 kernel and makedumpfile-1.5.0
using software pseudo MCE injection from KVM host to guest.


**** Host OS Screen logs(SRAO Machine Check injection)
Inject software pseudo MCE into guest qemu process.

(1) Load mce-inject module
# modprobe mce-inject

(2) Find a PID of target qemu-kvm and page struct
# ps -C qemu-kvm -o pid=
 3612
 9392

(3) Edit software pseudo MCE data
Choose a offset of page struct and insert the offset to ADDR line in mce-file.

#  ./page-types -p 3612 -LN -b anon | head
voffset offset  flags
8cb     86b98d  ___U_lA____Ma_b___________________
8cc     86b8ef  ___U_lA____Ma_b___________________
8cd     86ca04  ___U_lA____Ma_b___________________
8cf     86bb11  ___U_lA____Ma_b___________________
8d0     86bac7  ___U_lA____Ma_b___________________
8d2     86b0c4  ___U_lA____Ma_b___________________
8d4     86ab8d  ___U_lA____Ma_b___________________
8d7     86c5e1  ___U_lA____Ma_b___________________
8d8     86c5e3  ___U_lA____Ma_b___________________

# vi mce-file
CPU 0 BANK 2
STATUS UNCORRECTED SRAO 0x17a
MCGSTATUS MCIP RIPV
MISC 0x8c
ADDR 0x86b98d000
EOF

(4) Inject MCE
# mce-inject mce-file

Try step (3) to (4) a couple of times 

**** Guest OS Screen logs(kdump)
Guest catches MCE injection from qemu.
Then, run "echo c > /proc/sysrq-trigger" in order to execute makedumpfile.
-------------
[root@fedora17x64 ~]# uname -a
Linux fedora17x64 3.6.0+ #3 SMP Sat Sep 29 14:42:23 JST 2012 x86_64 x86_64 x86_64 GNU/Linux
[root@fedora17x64 ~]# [  245.348147] Disabling lock debugging due to kernel taint
[  245.348147] mce: [Hardware Error]: Machine check events logged
[  245.850863] MCE 0xbb706: non LRU page recovery: Ignored
[  246.348113] mce: [Hardware Error]: Machine check events logged
[  246.848190] MCE 0xbb709: non LRU page recovery: Ignored
[  249.847472] MCE 0xbb70a: non LRU page recovery: Ignored
[  250.336716] MCE 0xbb70b: non LRU page recovery: Ignored
[  252.847280] MCE 0xb8ff8: clean LRU page recovery: Recovered
[  253.847251] MCE 0xb8ff9: clean LRU page recovery: Recovered
[  256.051190] MCE 0xb68e8: clean LRU page recovery: Recovered
[  257.000764] MCE 0xb68e9: clean LRU page recovery: Recovered

[root@fedora17x64 ~]# [  276.980192] MCE 0xb66e8: LRU page recovery: Recovered
[  277.847269] MCE 0xb66e9: corrupted page was clean: dropped without side effects
[  277.848360] MCE 0xb66e9: clean LRU page recovery: Recovered

[root@fedora17x64 ~]# echo c > /proc/sysrq-trigger
[  299.612689] SysRq : Trigger a crash
[  299.613339] BUG: unable to handle kernel NULL pointer dereference at           (null)
[  299.613339] IP: [<ffffffff81373606>] sysrq_handle_crash+0x16/0x20
[  299.613339] PGD ba732067 PUD babc2067 PMD 0
[  299.613339] Oops: 0002 [#1] SMP
..............
................
.................
[  299.613339] Call Trace:
[  299.613339]  [<ffffffff81373d27>] __handle_sysrq+0x127/0x190
[  299.613339]  [<ffffffff81373dda>] write_sysrq_trigger+0x4a/0x50
[  299.613339]  [<ffffffff811dd6d8>] proc_reg_write+0x78/0xb0
[  299.613339]  [<ffffffff8117b83c>] vfs_write+0xac/0x180
[  299.613339]  [<ffffffff8117bb6a>] sys_write+0x4a/0x90
[  299.613339]  [<ffffffff815fa329>] system_call_fastpath+0x16/0x1b
[  299.613339] Code: 65 2c 75 cd 4c 89 ef e8 89 f7 ff ff eb c3 0f 1f 80 00 00 00 00 55 48 89 e5 0f 1f 44 00 00 c7 05 01 a5 ab 00 01 00 00 00 0f ae f8 <c6> 04 25 00 00 00 00 01 5d c3 55 48 89 e5 53 48 83 ec 08 0f 1f
[  299.613339] RIP  [<ffffffff81373606>] sysrq_handle_crash+0x16/0x20
[  299.613339]  RSP <ffff880037a77e38>
[  299.613339] CR2: 0000000000000000
..............
................
.................
++ KDUMP_PATH=/var/crash
++ CORE_COLLECTOR='makedumpfile -d 31 -c'
++ DEFAULT_ACTION=dump_rootfs
+++ date +%d.%m.%y-%T
++ DATEDIR=29.10.12-15:32:02
++ DUMP_INSTRUCTION=
++ read_kdump_conf
++ local conf_file=/etc/kdump.conf
++ '[' -f /etc/kdump.conf ']'
++ read config_opt config_val
++ case "$config_opt" in
++ read config_opt config_val
++ case "$config_opt" in
++ read config_opt config_val
++ case "$config_opt" in
++ CORE_COLLECTOR='makedumpfile -c -d 30 -p -D --message-level 31'
++ read config_opt config_val
++ '[' -n '' ']'
++ dump_rootfs
++ mount -o remount,rw /sysroot/
[    1.796062] EXT4-fs (dm-1): re-mounted. Opts: (null)
++ mkdir -p /sysroot//var/crash/29.10.12-15:32:02
++ makedumpfile -c -d 30 -p -D --message-level 31 /proc/vmcore /sysroot//var/crash/29.10.12-15:32:02/vmcore
sadump: does not have partition header
sadump: read dump device as unknown format
sadump: unknown format
..............
................
.................
Excluding free pages               : [100 %] STEP [Excluding free pages       ] : 0.085096 seconds
Excluding unnecessary pages        : [100 %] STEP [Excluding unnecessary pages] : 0.561497 seconds
Excluding free pages               : [100 %] STEP [Excluding free pages       ] : 0.081891 seconds
Excluding unnecessary pages        : [100 %] STEP [Excluding unnecessary pages] : 0.531003 seconds
Copying data                       : [100 %] STEP [Copying data               ] : 5.206374 seconds

Writing erase info...
offset_eraseinfo: 16225d7, size_eraseinfo: 0

Original pages  : 0x00000000000b133c
  Excluded pages   : 0x00000000000a76bf
    Pages filled with zero  : 0x0000000000000000
    Cache pages             : 0x0000000000006df7
    Cache pages + private   : 0x0000000000003451
    User process data pages : 0x0000000000002e03
    Free pages              : 0x000000000009a660
    Hwpoison pages          : 0x0000000000000014
  Remaining pages  : 0x0000000000009c7d
  (The number of pages is reduced to 5%.)
Memory Hole     : 0x000000000000ecc1
--------------------------------------------------
Total pages     : 0x00000000000bfffd


The dumpfile is saved to /sysroot//var/crash/29.10.12-15:32:02/vmcore.

makedumpfile Completed.
++ sync
++ reboot -f
Rebooting.
[    8.176645] Restarting system.
[    8.177463] reboot: machine restart
