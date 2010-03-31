Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757514Ab0CaQH4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 12:07:56 -0400
Received: from hosting.visp.net.lb ([194.146.153.11]:54088 "EHLO
	hosting.visp.net.lb" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757412Ab0CaQHy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 12:07:54 -0400
From: Denys Fedorysychenko <nuclearcat@nuclearcat.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: endless sync on bdi_sched_wait()? 2.6.33.1
Date: Wed, 31 Mar 2010 19:07:31 +0300
User-Agent: KMail/1.12.4 (Linux/2.6.31.12-rt21-home1; KDE/4.3.5; x86_64; ; )
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="koi8-r"
Content-Transfer-Encoding: 7bit
Message-Id: <201003311907.31342.nuclearcat@nuclearcat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have a proxy server with "loaded" squid. On some moment i did sync, and 
expecting it to finish in reasonable time. Waited more than 30 minutes, still 
"sync". Can be reproduced easily.

Here is some stats and info:

Linux SUPERPROXY 2.6.33.1-build-0051 #16 SMP Wed Mar 31 17:23:28 EEST 2010 
i686 GNU/Linux

SUPERPROXY ~ # iostat -k -x -d 30
Linux 2.6.33.1-build-0051 (SUPERPROXY)  03/31/10        _i686_  (4 CPU)

Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s avgrq-sz 
avgqu-sz   await  svctm  %util
sda               0.16     0.01    0.08    0.03     3.62     1.33    88.94     
0.15 1389.89  59.15   0.66
sdb               4.14    61.25    6.22   25.55    44.52   347.21    24.66     
2.24   70.60   2.36   7.49
sdc               4.37   421.28    9.95   98.31   318.27  2081.95    44.34    
20.93  193.21   2.31  24.96
sdd               2.34   339.90    3.97  117.47    95.48  1829.52    31.70     
1.73   14.23   8.09  98.20
sde               2.29    71.40    2.34   27.97    22.56   397.81    27.74     
2.34   77.34   1.66   5.04
dm-0              0.00     0.00    0.19    0.02     3.48     0.02    32.96     
0.05  252.11  28.05   0.60

Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s avgrq-sz 
avgqu-sz   await  svctm  %util
sda               0.00     0.00    0.00    0.00     0.00     0.00     0.00     
0.00    0.00   0.00   0.00
sdb               0.00    54.67    2.93   26.87    12.27   326.13    22.71     
2.19   73.49   1.91   5.68
sdc               0.00   420.50    3.43  110.53   126.40  2127.73    39.56    
23.82  209.00   2.06  23.44
sdd               0.00   319.63    2.30  122.03   121.87  1765.87    30.37     
1.72   13.83   7.99  99.37
sde               0.00    71.67    0.83   30.63     6.93   409.33    26.46     
2.66   84.68   1.51   4.76
dm-0              0.00     0.00    0.00    0.00     0.00     0.00     0.00     
0.00    0.00   0.00   0.00


CPU:  8.4% usr  7.7% sys  0.0% nic 50.7% idle 27.7% io  0.6% irq  4.7% sirq
Load average: 5.57 4.82 4.46 2/243 2032
  PID  PPID USER     STAT   VSZ %MEM CPU %CPU COMMAND
 1769  1552 squid    R     668m  8.3   3 11.7 /usr/sbin/squid -N
 1546  1545 root     R    10800  0.1   2  6.0 /config/globax 
/config/globax.conf
 1549  1548 root     S    43264  0.5   2  1.5 /config/globax /config/globax-
dld.conf
 1531     2 root     DW       0  0.0   0  0.3 [jbd2/sdd1-8]
 1418     1 root     S     2500  0.0   3  0.0 /sbin/syslogd -R 80.83.17.2
 1524     2 root     SW       0  0.0   0  0.0 [flush-8:32]
 1525     2 root     SW       0  0.0   1  0.0 [jbd2/sdc1-8]
 1604     2 root     DW       0  0.0   0  0.0 [flush-8:48]
 1537     2 root     SW       0  0.0   1  0.0 [jbd2/sde1-8]
   18     2 root     SW       0  0.0   3  0.0 [events/3]
 1545     1 root     S     3576  0.0   1  0.0 /config/globax 
/config/globax.conf
 1548     1 root     S     3576  0.0   0  0.0 /config/globax /config/globax-
dld.conf
 1918     1 ntp      S     3316  0.0   3  0.0 /usr/sbin/ntpd -s
 1919     1 root     S     3268  0.0   3  0.0 /usr/sbin/ntpd -s
    1     0 root     S     2504  0.0   0  0.0 /bin/sh /init trynew trynew 
trynew trynew
 1923  1257 root     S     2504  0.0   1  0.0 /sbin/getty 38400 tty1
 1924  1257 root     S     2504  0.0   0  0.0 /sbin/getty 38400 tty2
 1927  1257 root     S     2504  0.0   0  0.0 /sbin/getty 38400 tty3
 2015  2014 root     S     2504  0.0   1  0.0 -ash
 2032  2015 root     R     2504  0.0   3  0.0 top
 1584     1 root     S     2500  0.0   1  0.0 /usr/bin/ifplugd -i eth0 -a -r 
/etc/startup/rc.ifup -t 1 -u 1 -d 1
 1592     1 root     S     2500  0.0   1  0.0 /usr/bin/ifplugd -i eth2 -a -r 
/etc/startup/rc.ifup -t 1 -u 1 -d 1
 1587     1 root     S     2500  0.0   1  0.0 /usr/bin/ifplugd -i eth1 -a -r 
/etc/startup/rc.ifup -t 1 -u 1 -d 1
 1595     1 root     S     2500  0.0   1  0.0 /usr/bin/ifplugd -i eth3 -a -r 
/etc/startup/rc.ifup -t 1 -u 1 -d 1
 1257     1 root     S     2500  0.0   0  0.0 init
 1420     1 root     S     2500  0.0   1  0.0 /sbin/klogd
 1432     1 root     S     2500  0.0   3  0.0 /usr/sbin/telnetd -f 
/etc/issue.telnet
 1552     1 root     S     2500  0.0   1  0.0 /bin/sh /bin/squidloop
 1743  1742 root     S     2500  0.0   3  0.0 ash -c gs newkernel
 1744  1743 root     S     2500  0.0   0  0.0 /bin/sh /bin/gs newkernel
 1753  1744 root     D     2368  0.0   0  0.0 sync


SUPERPROXY ~ # cat /proc/1753/stack
[<c019a93c>] bdi_sched_wait+0x8/0xc
[<c019a807>] wait_on_bit+0x20/0x2c
[<c019a9af>] sync_inodes_sb+0x6f/0x10a
[<c019dd53>] __sync_filesystem+0x28/0x49
[<c019ddf3>] sync_filesystems+0x7f/0xc0
[<c019de7a>] sys_sync+0x1b/0x2d
[<c02f7a25>] syscall_call+0x7/0xb
[<ffffffff>] 0xffffffff
SUPERPROXY ~ # cat /proc/1753/status
Name:   sync
State:  D (disk sleep)
Tgid:   1753
Pid:    1753
PPid:   1744
TracerPid:      0
Uid:    0       0       0       0
Gid:    0       0       0       0
FDSize: 32
Groups: 0
VmPeak:     2368 kB
VmSize:     2368 kB
VmLck:         0 kB
VmHWM:       408 kB
VmRSS:       408 kB
VmData:      192 kB
VmStk:        84 kB
VmExe:       488 kB
VmLib:      1540 kB
VmPTE:        12 kB
Threads:        1
SigQ:   2/127824
SigPnd: 0000000000000000
ShdPnd: 0000000000000000
SigBlk: 0000000000000000
SigIgn: 0000000000000000
SigCgt: 0000000000000000
CapInh: 0000000000000000
CapPrm: ffffffffffffffff
CapEff: ffffffffffffffff
CapBnd: ffffffffffffffff
Cpus_allowed:   f
Cpus_allowed_list:      0-3
Mems_allowed:   1
Mems_allowed_list:      0
voluntary_ctxt_switches:        124
nonvoluntary_ctxt_switches:     2

SUPERPROXY ~ # cat /proc/meminfo
MemTotal:        8186788 kB
MemFree:         3758908 kB
Buffers:          373656 kB
Cached:          3122824 kB
SwapCached:            0 kB
Active:          1851000 kB
Inactive:        2152916 kB
Active(anon):     446516 kB
Inactive(anon):    63140 kB
Active(file):    1404484 kB
Inactive(file):  2089776 kB
Unevictable:        2152 kB
Mlocked:               0 kB
HighTotal:       7346120 kB
HighFree:        3720868 kB
LowTotal:         840668 kB
LowFree:           38040 kB
SwapTotal:             0 kB
SwapFree:              0 kB
Dirty:            109540 kB
Writeback:          1036 kB
AnonPages:        509648 kB
Mapped:             2320 kB
Shmem:                 8 kB
Slab:             263512 kB
SReclaimable:     129176 kB
SUnreclaim:       134336 kB
KernelStack:         980 kB
PageTables:         1460 kB
NFS_Unstable:          0 kB
Bounce:                0 kB
WritebackTmp:          0 kB
CommitLimit:     4093392 kB
Committed_AS:     746808 kB
VmallocTotal:     122880 kB
VmallocUsed:        2860 kB
VmallocChunk:     113308 kB
DirectMap4k:        4088 kB
DirectMap2M:      907264 kB

"Tuning" (that probably is wrong?)
SCHED="cfq"
echo ${SCHED} >/sys/block/sdb/queue/scheduler
echo ${SCHED} >/sys/block/sdc/queue/scheduler
echo ${SCHED} >/sys/block/sdd/queue/scheduler
echo ${SCHED} >/sys/block/sde/queue/scheduler
echo ${SCHED} >/sys/block/sdf/queue/scheduler

echo 0 >/sys/block/sdb/queue/iosched/low_latency
echo 0 >/sys/block/sdc/queue/iosched/low_latency
echo 0 >/sys/block/sdd/queue/iosched/low_latency
echo 0 >/sys/block/sde/queue/iosched/low_latency
echo 0 >/sys/block/sdf/queue/iosched/low_latency


echo 128 >/sys/block/sdb/queue/iosched/quantum
echo 128 >/sys/block/sdc/queue/iosched/quantum
echo 128 >/sys/block/sdd/queue/iosched/quantum
echo 128 >/sys/block/sde/queue/iosched/quantum
echo 128 >/sys/block/sdf/queue/iosched/quantum

sysctl -w vm.dirty_background_bytes=600000000
sysctl -w vm.dirty_bytes=800000000

rootfs on / type rootfs (rw)
proc on /proc type proc (rw,relatime)
sysfs on /sys type sysfs (rw,relatime)
none on /dev/pts type devpts (rw,relatime,mode=600)
none on /proc/bus/usb type usbfs (rw,relatime)
/dev/mapper/root on /mnt/flash type ext3 
(rw,noatime,errors=continue,data=writeback)
/dev/loop0 on /lib/modules/2.6.33.1-build-0051 type squashfs (ro,relatime)
none on /sys/kernel/debug type debugfs (rw,relatime)
/dev/sdb2 on /cache1 type ext4 
(rw,noatime,nodiratime,barrier=0,journal_async_commit,nobh,data=writeback)
/dev/sdc1 on /cache2 type ext4 
(rw,noatime,nodiratime,barrier=0,journal_async_commit,nobh,data=writeback)
/dev/sdd1 on /cache3 type ext4 
(rw,noatime,nodiratime,barrier=0,journal_async_commit,nobh,data=writeback)
/dev/sde1 on /cache4 type ext4 
(rw,noatime,nodiratime,barrier=0,journal_async_commit,nobh,data=writeback)
/dev/sda1 on /mnt/boot type ext2 (rw,relatime,errors=continue)
