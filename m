Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757903Ab1DXV7p (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Apr 2011 17:59:45 -0400
Received: from legolas.restena.lu ([158.64.1.34]:57105 "EHLO
	legolas.restena.lu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757876Ab1DXV7m convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Apr 2011 17:59:42 -0400
Date: Sun, 24 Apr 2011 23:59:28 +0200
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, linux-fsdevel@vger.kernel.org
Subject: Re: 2.6.39-rc4+: Kernel leaking memory during FS scanning,
 regression?
Message-ID: <20110424235928.71af51e0@neptune.home>
In-Reply-To: <20110424202158.45578f31@neptune.home>
References: <20110424202158.45578f31@neptune.home>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.1; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 24 April 2011 Bruno Prémont <bonbons@linux-vserver.org> wrote:
> On an older system I've been running Gentoo's revdep-rebuild to check
> for system linking/*.la consistency and after doing most of the work the
> system starved more or less, just complaining about stuck tasks now and
> then.
> Memory usage graph as seen from userspace showed sudden quick increase of
> memory usage though only a very few MB were swapped out (c.f. attached RRD
> graph).

Seems I've hit it once again (though detected before system was fully
stalled by trying to reclaim memory without success).

This time it was during simple compiling...
Gathered info below:

/proc/meminfo:
MemTotal:         480660 kB
MemFree:           64948 kB
Buffers:           10304 kB
Cached:             6924 kB
SwapCached:         4220 kB
Active:            11100 kB
Inactive:          15732 kB
Active(anon):       4732 kB
Inactive(anon):     4876 kB
Active(file):       6368 kB
Inactive(file):    10856 kB
Unevictable:          32 kB
Mlocked:              32 kB
SwapTotal:        524284 kB
SwapFree:         456432 kB
Dirty:                80 kB
Writeback:             0 kB
AnonPages:          6268 kB
Mapped:             2604 kB
Shmem:                 4 kB
Slab:             250632 kB
SReclaimable:      51144 kB
SUnreclaim:       199488 kB   <--- look big as well...
KernelStack:      131032 kB   <--- what???
PageTables:          920 kB
NFS_Unstable:          0 kB
Bounce:                0 kB
WritebackTmp:          0 kB
CommitLimit:      764612 kB
Committed_AS:     132632 kB
VmallocTotal:     548548 kB
VmallocUsed:       18500 kB
VmallocChunk:     525952 kB
AnonHugePages:         0 kB
DirectMap4k:       32704 kB
DirectMap4M:      458752 kB

sysrq+m:
[ 3908.107287] SysRq : Show Memory
[ 3908.109324] Mem-Info:
[ 3908.111266] DMA per-cpu:
[ 3908.113164] CPU    0: hi:    0, btch:   1 usd:   0
[ 3908.115061] Normal per-cpu:
[ 3908.116914] CPU    0: hi:  186, btch:  31 usd: 172
[ 3908.117253] active_anon:1989 inactive_anon:2057 isolated_anon:0
[ 3908.117253]  active_file:1762 inactive_file:1841 isolated_file:0
[ 3908.117253]  unevictable:8 dirty:0 writeback:0 unstable:0
[ 3908.117253]  free:15704 slab_reclaimable:12672 slab_unreclaimable:49606
[ 3908.117253]  mapped:518 shmem:0 pagetables:214 bounce:0
[ 3908.117253] DMA free:1936kB min:88kB low:108kB high:132kB active_anon:84kB inactive_anon:128kB active_file:4kB inactive_file:68kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:15808kB mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB slab_reclaimable:140kB slab_unreclaimable:4960kB kernel_stack:8592kB pagetables:0kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:467 all_unreclaimable? yes
[ 3908.117253] lowmem_reserve[]: 0 460 460
[ 3908.117253] Normal free:60880kB min:2696kB low:3368kB high:4044kB active_anon:7872kB inactive_anon:8100kB active_file:7044kB inactive_file:7296kB unevictable:32kB isolated(anon):0kB isolated(file):0kB present:471360kB mlocked:32kB dirty:0kB writeback:0kB mapped:2072kB shmem:0kB slab_reclaimable:50548kB slab_unreclaimable:193472kB kernel_stack:122384kB pagetables:856kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
[ 3908.117253] lowmem_reserve[]: 0 0 0
[ 3908.117253] DMA: 52*4kB 216*8kB 0*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 1936kB
[ 3908.117253] Normal: 14858*4kB 181*8kB 0*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 60880kB
[ 3908.117253] 5093 total pagecache pages
[ 3908.117253] 1490 pages in swap cache
[ 3908.117253] Swap cache stats: add 55685, delete 54195, find 25271/28670
[ 3908.117253] Free swap  = 458944kB
[ 3908.117253] Total swap = 524284kB
[ 3908.117253] 122848 pages RAM
[ 3908.117253] 2699 pages reserved
[ 3908.117253] 4346 pages shared
[ 3908.117253] 84248 pages non-shared

ps auxf:
USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
root         2  0.0  0.0      0     0 ?        S    22:39   0:00 [kthreadd]
root         3  0.0  0.0      0     0 ?        S    22:39   0:00  \_ [ksoftirqd/0]
root         5  0.0  0.0      0     0 ?        S    22:39   0:00  \_ [kworker/u:0]
root         6  0.0  0.0      0     0 ?        R    22:39   0:01  \_ [rcu_kthread]
root         7  0.0  0.0      0     0 ?        R    22:39   0:00  \_ [watchdog/0]
root         8  0.0  0.0      0     0 ?        S<   22:39   0:00  \_ [khelper]
root       138  0.0  0.0      0     0 ?        S    22:39   0:00  \_ [sync_supers]
root       140  0.0  0.0      0     0 ?        S    22:39   0:00  \_ [bdi-default]
root       142  0.0  0.0      0     0 ?        S<   22:39   0:00  \_ [kblockd]
root       230  0.0  0.0      0     0 ?        S<   22:39   0:00  \_ [ata_sff]
root       237  0.0  0.0      0     0 ?        S    22:39   0:00  \_ [khubd]
root       365  0.0  0.0      0     0 ?        S    22:39   0:01  \_ [kswapd0]
root       429  0.0  0.0      0     0 ?        S    22:39   0:00  \_ [fsnotify_mark]
root       438  0.0  0.0      0     0 ?        S<   22:39   0:00  \_ [xfs_mru_cache]
root       439  0.0  0.0      0     0 ?        S<   22:39   0:00  \_ [xfslogd]
root       440  0.0  0.0      0     0 ?        S<   22:39   0:00  \_ [xfsdatad]
root       441  0.0  0.0      0     0 ?        S<   22:39   0:00  \_ [xfsconvertd]
root       497  0.0  0.0      0     0 ?        S    22:39   0:00  \_ [scsi_eh_0]
root       500  0.0  0.0      0     0 ?        S    22:39   0:00  \_ [scsi_eh_1]
root       514  0.0  0.0      0     0 ?        S    22:39   0:00  \_ [scsi_eh_2]
root       517  0.0  0.0      0     0 ?        S    22:39   0:00  \_ [scsi_eh_3]
root       521  0.0  0.0      0     0 ?        S    22:39   0:00  \_ [kworker/u:5]
root       530  0.0  0.0      0     0 ?        S    22:39   0:00  \_ [scsi_eh_4]
root       533  0.0  0.0      0     0 ?        S    22:39   0:00  \_ [scsi_eh_5]
root       585  0.0  0.0      0     0 ?        S<   22:39   0:00  \_ [kpsmoused]
root       659  0.0  0.0      0     0 ?        S<   22:40   0:00  \_ [reiserfs]
root      1436  0.0  0.0      0     0 ?        S    22:40   0:00  \_ [flush-8:0]
root      1642  0.0  0.0      0     0 ?        S<   22:40   0:00  \_ [rpciod]
root      1643  0.0  0.0      0     0 ?        S<   22:40   0:00  \_ [nfsiod]
root      1647  0.0  0.0      0     0 ?        S    22:40   0:00  \_ [lockd]
root     21739  0.0  0.0      0     0 ?        S<   23:05   0:00  \_ [ttm_swap]
root      1760  0.0  0.0      0     0 ?        S    23:22   0:00  \_ [kworker/0:2]
root     13497  0.0  0.0      0     0 ?        S    23:27   0:00  \_ [kworker/0:0]
root     14071  0.0  0.0      0     0 ?        S    23:36   0:00  \_ [kworker/0:3]
root     15923  0.0  0.0      0     0 ?        S    23:44   0:00  \_ [flush-0:18]
root     15924  0.0  0.0      0     0 ?        S    23:44   0:00  \_ [flush-0:19]
root     15925  0.0  0.0      0     0 ?        S    23:44   0:00  \_ [flush-0:20]
root     15926  0.0  0.0      0     0 ?        S    23:44   0:00  \_ [flush-0:21]
root         1  0.0  0.0   1740    72 ?        Ss   22:39   0:00 init [3]  
root       759  0.0  0.0   2228     8 ?        S<s  22:40   0:00 /sbin/udevd --daemon
root      1723  0.0  0.0   2224     8 ?        S<   22:45   0:00  \_ /sbin/udevd --daemon
root      1327  0.0  0.0   4876     8 tty2     Ss+  22:40   0:00 -bash
root      6122  0.4  0.0  34204     8 tty2     TN   23:24   0:07  \_ /usr/bin/python2.7 /usr/bin/emerge --oneshot media-gfx/gimp
portage  27988  0.0  0.0   5928     8 tty2     TN   23:28   0:00      \_ /bin/bash /usr/lib/portage/bin/ebuild.sh compile
portage  28231  0.0  0.0   6064     8 tty2     TN   23:28   0:00          \_ /bin/bash /usr/lib/portage/bin/ebuild.sh compile
portage  28245  0.0  0.0   4880     8 tty2     TN   23:28   0:00              \_ /bin/bash /usr/lib/portage/bin/ebuild-helpers/emake
portage  28250  0.0  0.0   3860     8 tty2     TN   23:28   0:00                  \_ make -j2
portage  28251  0.0  0.0   3864     8 tty2     TN   23:28   0:00                      \_ make all-recursive
portage  28252  0.0  0.0   4752     8 tty2     TN   23:28   0:00                          \_ /bin/sh -c fail= failcom='exit 1'; \?for f in x $MAKEFLAGS; do \?  case $f in \?    *=* | --[!k]*);; \?   
portage  12569  0.0  0.0   4752     8 tty2     TN   23:33   0:00                              \_ /bin/sh -c fail= failcom='exit 1'; \?for f in x $MAKEFLAGS; do \?  case $f in \?    *=* | --[!k]*);; \
portage  12570  0.0  0.0   3864     8 tty2     TN   23:33   0:00                                  \_ make all
portage  12571  0.0  0.0   4752     8 tty2     TN   23:33   0:00                                      \_ /bin/sh -c fail= failcom='exit 1'; \?for f in x $MAKEFLAGS; do \?  case $f in \?    *=* | --[!
portage  15218  0.0  0.0   4752     8 tty2     TN   23:40   0:00                                          \_ /bin/sh -c fail= failcom='exit 1'; \?for f in x $MAKEFLAGS; do \?  case $f in \?    *=* | 
portage  15219  0.0  0.0   3884     8 tty2     TN   23:40   0:00                                              \_ make all
portage  15912  0.0  0.0   1924     8 tty2     TN   23:42   0:00                                                  \_ /usr/i686-pc-linux-gnu/gcc-bin/4.4.5/i686-pc-linux-gnu-gcc -DHAVE_CONFIG_H -I. -I.
portage  15913  0.0  0.0  12724     8 tty2     TN   23:42   0:00                                                  |   \_ /usr/libexec/gcc/i686-pc-linux-gnu/4.4.5/cc1 -quiet -I. -I../.. -I../.. -I../.
portage  15914  0.0  0.0   5284     8 tty2     TN   23:42   0:00                                                  |   \_ /usr/lib/gcc/i686-pc-linux-gnu/4.4.5/../../../../i686-pc-linux-gnu/bin/as -Qy
portage  15916  0.0  0.0   1924     8 tty2     TN   23:43   0:00                                                  \_ /usr/i686-pc-linux-gnu/gcc-bin/4.4.5/i686-pc-linux-gnu-gcc -DHAVE_CONFIG_H -I. -I.
portage  15917  0.0  0.0  11540     8 tty2     TN   23:43   0:00                                                      \_ /usr/libexec/gcc/i686-pc-linux-gnu/4.4.5/cc1 -quiet -I. -I../.. -I../.. -I../.
portage  15918  0.0  0.0   5284     8 tty2     TN   23:43   0:00                                                      \_ /usr/lib/gcc/i686-pc-linux-gnu/4.4.5/../../../../i686-pc-linux-gnu/bin/as -Qy
root      1328  0.0  0.0   4876     8 tty3     Ss+  22:40   0:00 -bash
root     13085  0.7  0.0  34128    92 tty3     TN   23:34   0:06  \_ /usr/bin/python2.7 /usr/bin/emerge --oneshot collectd
portage  13877  0.0  0.0   5924     8 tty3     TN   23:36   0:00      \_ /bin/bash /usr/lib/portage/bin/ebuild.sh prepare
portage  13899  0.0  0.0   5928     8 tty3     TN   23:36   0:00          \_ /bin/bash /usr/lib/portage/bin/ebuild.sh prepare
portage  15904  0.0  0.0   5928     8 tty3     TN   23:42   0:00              \_ /bin/bash /usr/lib/portage/bin/ebuild.sh prepare
portage  15911  0.0  0.0   4752     8 tty3     TN   23:42   0:00                  \_ /bin/sh /usr/bin/autoconf --trace=AC_PROG_LIBTOOL
root      1329  0.0  0.0   1892     8 tty4     Ss+  22:40   0:00 /sbin/agetty 38400 tty4 linux
root      1330  0.0  0.0   1892     8 tty5     Ss+  22:40   0:00 /sbin/agetty 38400 tty5 linux
root      1331  0.0  0.0   1892     8 tty6     Ss+  22:40   0:00 /sbin/agetty 38400 tty6 linux
root      1471  0.0  0.0   1928     8 ?        Ss   22:40   0:00 dhcpcd -m 2 eth0
root      1512  0.0  0.0   5128     8 ?        S    22:40   0:00 supervising syslog-ng
root      1513  0.0  0.0   5408    32 ?        Ss   22:40   0:00  \_ /usr/sbin/syslog-ng
ntp       1537  0.0  0.0   4360   236 ?        Ss   22:40   0:00 /usr/sbin/ntpd -p /var/run/ntpd.pid -u ntp:ntp
collectd  1555  0.1  0.2  45048  1032 ?        SNLsl 22:40   0:05 /usr/sbin/collectd -P /var/run/collectd/collectd.pid -C /etc/collectd.conf
root      1613  0.0  0.0   2116    96 ?        Ss   22:40   0:00 /sbin/rpcbind
root      1627  0.0  0.0   2188     8 ?        Ss   22:40   0:00 /sbin/rpc.statd --no-notify
root      1687  0.0  0.0   4204     8 ?        Ss   22:40   0:00 /usr/sbin/sshd
root     15929  0.1  0.0   7004   312 ?        Ss   23:47   0:00  \_ sshd: root@pts/2 
root     15931  0.0  0.1   4876   808 pts/2    Ss   23:47   0:00      \_ -bash
root     15949  0.0  0.2   4124   972 pts/2    R+   23:50   0:00          \_ ps auxf
root      1715  0.0  0.0   1892     8 tty1     Ss+  22:40   0:00 /sbin/agetty 38400 tty1 linux
root      1716  0.0  0.0   1892     8 ttyS0    Ss+  22:40   0:00 /sbin/agetty 115200 ttyS0 vt100
root     28160  0.0  0.0   1944     8 ?        Ss   23:21   0:00 /usr/sbin/gpm -m /dev/input/mice -t ps2

/proc/slabinfo:
slabinfo - version: 2.1
# name            <active_objs> <num_objs> <objsize> <objperslab> <pagesperslab> : tunables <limit> <batchcount> <sharedfactor> : slabdata <active_slabs> <num_slabs> <sharedavail>
squashfs_inode_cache   4240   4240    384   10    1 : tunables    0    0    0 : slabdata    424    424      0
nfs_direct_cache       0      0     72   56    1 : tunables    0    0    0 : slabdata      0      0      0
nfs_read_data         72     72    448    9    1 : tunables    0    0    0 : slabdata      8      8      0
nfs_inode_cache      252    252    568   14    2 : tunables    0    0    0 : slabdata     18     18      0
rpc_inode_cache       36     36    448    9    1 : tunables    0    0    0 : slabdata      4      4      0
RAWv6                 12     12    672   12    2 : tunables    0    0    0 : slabdata      1      1      0
UDPLITEv6              0      0    672   12    2 : tunables    0    0    0 : slabdata      0      0      0
UDPv6                 12     12    672   12    2 : tunables    0    0    0 : slabdata      1      1      0
tw_sock_TCPv6         25     25    160   25    1 : tunables    0    0    0 : slabdata      1      1      0
TCPv6                 12     12   1312   12    4 : tunables    0    0    0 : slabdata      1      1      0
mqueue_inode_cache      8      8    480    8    1 : tunables    0    0    0 : slabdata      1      1      0
xfs_inode              0      0    608   13    2 : tunables    0    0    0 : slabdata      0      0      0
xfs_efd_item           0      0    288   14    1 : tunables    0    0    0 : slabdata      0      0      0
xfs_trans              0      0    224   18    1 : tunables    0    0    0 : slabdata      0      0      0
xfs_da_state           0      0    336   12    1 : tunables    0    0    0 : slabdata      0      0      0
xfs_log_ticket         0      0    176   23    1 : tunables    0    0    0 : slabdata      0      0      0
reiser_inode_cache  38160  38160    392   10    1 : tunables    0    0    0 : slabdata   3816   3816      0
configfs_dir_cache     73     73     56   73    1 : tunables    0    0    0 : slabdata      1      1      0
inotify_inode_mark     56     56     72   56    1 : tunables    0    0    0 : slabdata      1      1      0
posix_timers_cache      0      0    120   34    1 : tunables    0    0    0 : slabdata      0      0      0
UDP-Lite               0      0    512    8    1 : tunables    0    0    0 : slabdata      0      0      0
UDP                   16     16    512    8    1 : tunables    0    0    0 : slabdata      2      2      0
tw_sock_TCP           32     32    128   32    1 : tunables    0    0    0 : slabdata      1      1      0
TCP                   13     13   1184   13    4 : tunables    0    0    0 : slabdata      1      1      0
sgpool-128            12     12   2560   12    8 : tunables    0    0    0 : slabdata      1      1      0
sgpool-64             12     12   1280   12    4 : tunables    0    0    0 : slabdata      1      1      0
sgpool-32             12     12    640   12    2 : tunables    0    0    0 : slabdata      1      1      0
sgpool-16             12     12    320   12    1 : tunables    0    0    0 : slabdata      1      1      0
blkdev_queue          17     17    920   17    4 : tunables    0    0    0 : slabdata      1      1      0
blkdev_requests       27     38    208   19    1 : tunables    0    0    0 : slabdata      2      2      0
blkdev_ioc           102    102     40  102    1 : tunables    0    0    0 : slabdata      1      1      0
biovec-256            10     10   3072   10    8 : tunables    0    0    0 : slabdata      1      1      0
biovec-128             0      0   1536   10    4 : tunables    0    0    0 : slabdata      0      0      0
biovec-64             10     10    768   10    2 : tunables    0    0    0 : slabdata      1      1      0
sock_inode_cache      63     66    352   11    1 : tunables    0    0    0 : slabdata      6      6      0
skbuff_fclone_cache     11     11    352   11    1 : tunables    0    0    0 : slabdata      1      1      0
file_lock_cache       39     39    104   39    1 : tunables    0    0    0 : slabdata      1      1      0
shmem_inode_cache    920    920    400   10    1 : tunables    0    0    0 : slabdata     92     92      0
proc_inode_cache   33216  33216    336   12    1 : tunables    0    0    0 : slabdata   2768   2768      0
sigqueue              28     28    144   28    1 : tunables    0    0    0 : slabdata      1      1      0
bdev_cache            13     18    448    9    1 : tunables    0    0    0 : slabdata      2      2      0
sysfs_dir_cache    13260  13260     48   85    1 : tunables    0    0    0 : slabdata    156    156      0
mnt_cache             99    100    160   25    1 : tunables    0    0    0 : slabdata      4      4      0
inode_cache         3757   3757    312   13    1 : tunables    0    0    0 : slabdata    289    289      0
dentry            123232 123232    128   32    1 : tunables    0    0    0 : slabdata   3851   3851      0
buffer_head         2589  30003     56   73    1 : tunables    0    0    0 : slabdata    411    411      0
vm_area_struct      1792   1794     88   46    1 : tunables    0    0    0 : slabdata     39     39      0
mm_struct             68     76    416   19    2 : tunables    0    0    0 : slabdata      4      4      0
sighand_cache         85     96   1312   12    4 : tunables    0    0    0 : slabdata      8      8      0
task_struct        16410  16410    832   19    4 : tunables    0    0    0 : slabdata    885    885      0
anon_vma_chain      2352   2720     24  170    1 : tunables    0    0    0 : slabdata     16     16      0
anon_vma            1097   1190     24  170    1 : tunables    0    0    0 : slabdata      7      7      0
radix_tree_node    19019  19019    304   13    1 : tunables    0    0    0 : slabdata   1463   1463      0
idr_layer_cache      325    338    152   26    1 : tunables    0    0    0 : slabdata     13     13      0
dma-kmalloc-8192       0      0   8192    4    8 : tunables    0    0    0 : slabdata      0      0      0
dma-kmalloc-4096       0      0   4096    8    8 : tunables    0    0    0 : slabdata      0      0      0
dma-kmalloc-2048       0      0   2048    8    4 : tunables    0    0    0 : slabdata      0      0      0
dma-kmalloc-1024       0      0   1024    8    2 : tunables    0    0    0 : slabdata      0      0      0
dma-kmalloc-512        0      0    512    8    1 : tunables    0    0    0 : slabdata      0      0      0
dma-kmalloc-256        0      0    256   16    1 : tunables    0    0    0 : slabdata      0      0      0
dma-kmalloc-128        0      0    128   32    1 : tunables    0    0    0 : slabdata      0      0      0
dma-kmalloc-64         0      0     64   64    1 : tunables    0    0    0 : slabdata      0      0      0
dma-kmalloc-32         0      0     32  128    1 : tunables    0    0    0 : slabdata      0      0      0
dma-kmalloc-16         0      0     16  256    1 : tunables    0    0    0 : slabdata      0      0      0
dma-kmalloc-8          0      0      8  512    1 : tunables    0    0    0 : slabdata      0      0      0
dma-kmalloc-192        0      0    192   21    1 : tunables    0    0    0 : slabdata      0      0      0
dma-kmalloc-96         0      0     96   42    1 : tunables    0    0    0 : slabdata      0      0      0
kmalloc-8192          12     12   8192    4    8 : tunables    0    0    0 : slabdata      3      3      0
kmalloc-4096         293    296   4096    8    8 : tunables    0    0    0 : slabdata     37     37      0
kmalloc-2048         597    606   2048    8    4 : tunables    0    0    0 : slabdata     78     78      0
kmalloc-1024        6399   6400   1024    8    2 : tunables    0    0    0 : slabdata    800    800      0
kmalloc-512        18558  18560    512    8    1 : tunables    0    0    0 : slabdata   2320   2320      0
kmalloc-256           56     64    256   16    1 : tunables    0    0    0 : slabdata      4      4      0
kmalloc-128       1258587 1258592    128   32    1 : tunables    0    0    0 : slabdata  39331  39331      0
                  ^^^^^^^^^^^^^^^
                         How may I find out who is using this many 128-byte
                         blocks?
kmalloc-64         25086  25088     64   64    1 : tunables    0    0    0 : slabdata    392    392      0
kmalloc-32          9720   9728     32  128    1 : tunables    0    0    0 : slabdata     76     76      0
kmalloc-16          2542   4864     16  256    1 : tunables    0    0    0 : slabdata     19     19      0
kmalloc-8           3580   3584      8  512    1 : tunables    0    0    0 : slabdata      7      7      0
kmalloc-192        10925  10941    192   21    1 : tunables    0    0    0 : slabdata    521    521      0
kmalloc-96         63462  63462     96   42    1 : tunables    0    0    0 : slabdata   1511   1511      0
kmem_cache            32     32    128   32    1 : tunables    0    0    0 : slabdata      1      1      0
kmem_cache_node      128    128     32  128    1 : tunables    0    0    0 : slabdata      1      1      0

Bruno
