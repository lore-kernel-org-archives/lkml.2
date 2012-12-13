Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755445Ab2LMMRc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 07:17:32 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:50625 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755097Ab2LMMR3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 07:17:29 -0500
MIME-Version: 1.0
In-Reply-To: <20121212195019.GB9453@blackbox.djwong.org>
References: <1353059478-25474-1-git-send-email-zwu.kernel@gmail.com>
	<1354764503.16424.43.camel@f15>
	<CAEH94LikrSbsh=SfNDX2YcJj+yo3ONRZPsa1njxvOWC4+SKsPw@mail.gmail.com>
	<20121212195019.GB9453@blackbox.djwong.org>
Date: Thu, 13 Dec 2012 20:17:26 +0800
Message-ID: <CAEH94Lgqc7o+2b6OD8B5ZfWQHECrEUD062okrFhaNV=r1J2ttg@mail.gmail.com>
Subject: Re: [PATCH v1 resend hot_track 00/16] vfs: hot data tracking
From: Zhi Yong Wu <zwu.kernel@gmail.com>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: wuzhy@linux.vnet.ibm.com, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk,
        linuxram@linux.vnet.ibm.com, david@fromorbit.com, swhiteho@redhat.com,
        dave@jikos.cz, andi@firstfloor.org, northrup.james@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 13, 2012 at 3:50 AM, Darrick J. Wong
<darrick.wong@oracle.com> wrote:
> On Mon, Dec 10, 2012 at 11:30:03AM +0800, Zhi Yong Wu wrote:
>> HI, all guys.
>>
>> any comments or suggestions?
>
> Why did ffsb drop from 924 transactions/sec to 322?
It is maybe that some noise operations impact on it. I am doing one
larger scale perf testing in one clearer environment. So i want to
look at if its ffsb testing result has some difference from this.

>
> --D
>>
>> On Thu, Dec 6, 2012 at 11:28 AM, Zhi Yong Wu <wuzhy@linux.vnet.ibm.com> wrote:
>> > HI, guys
>> >
>> > THe perf testing is done separately with fs_mark, fio, ffsb and
>> > compilebench in one kvm guest.
>> >
>> > Below is the performance testing report for hot tracking, and no obvious
>> > perf downgrade is found.
>> >
>> > Note: original kernel means its source code is not changed;
>> >       kernel with enabled hot tracking means its source code is with hot
>> > tracking patchset.
>> >
>> > The test env is set up as below:
>> >
>> > root@debian-i386:/home/zwu# uname -a
>> > Linux debian-i386 3.7.0-rc8+ #266 SMP Tue Dec 4 12:17:55 CST 2012 x86_64
>> > GNU/Linux
>> >
>> > root@debian-i386:/home/zwu# mkfs.xfs -f -l
>> > size=1310b,sunit=8 /home/zwu/bdev.img
>> > meta-data=/home/zwu/bdev.img     isize=256    agcount=4, agsize=128000
>> > blks
>> >          =                       sectsz=512   attr=2, projid32bit=0
>> > data     =                       bsize=4096   blocks=512000, imaxpct=25
>> >          =                       sunit=0      swidth=0 blks
>> > naming   =version 2              bsize=4096   ascii-ci=0
>> > log      =internal log           bsize=4096   blocks=1310, version=2
>> >          =                       sectsz=512   sunit=1 blks, lazy-count=1
>> > realtime =none                   extsz=4096   blocks=0, rtextents=0
>> >
>> > 1.) original kernel
>> >
>> > root@debian-i386:/home/zwu# mount -o
>> > loop,logbsize=256k /home/zwu/bdev.img /mnt/scratch
>> > [ 1197.421616] XFS (loop0): Mounting Filesystem
>> > [ 1197.567399] XFS (loop0): Ending clean mount
>> > root@debian-i386:/home/zwu# mount
>> > /dev/sda1 on / type ext3 (rw,errors=remount-ro)
>> > tmpfs on /lib/init/rw type tmpfs (rw,nosuid,mode=0755)
>> > proc on /proc type proc (rw,noexec,nosuid,nodev)
>> > sysfs on /sys type sysfs (rw,noexec,nosuid,nodev)
>> > udev on /dev type tmpfs (rw,mode=0755)
>> > tmpfs on /dev/shm type tmpfs (rw,nosuid,nodev)
>> > devpts on /dev/pts type devpts (rw,noexec,nosuid,gid=5,mode=620)
>> > none on /selinux type selinuxfs (rw,relatime)
>> > debugfs on /sys/kernel/debug type debugfs (rw)
>> > binfmt_misc on /proc/sys/fs/binfmt_misc type binfmt_misc
>> > (rw,noexec,nosuid,nodev)
>> > /dev/loop0 on /mnt/scratch type xfs (rw,logbsize=256k)
>> > root@debian-i386:/home/zwu# free -m
>> >              total       used       free     shared    buffers
>> > cached
>> > Mem:           112        109          2          0          4
>> > 53
>> > -/+ buffers/cache:         51         60
>> > Swap:          713         29        684
>> >
>> > 2.) kernel with enabled hot tracking
>> >
>> > root@debian-i386:/home/zwu# mount -o
>> > hot_track,loop,logbsize=256k /home/zwu/bdev.img /mnt/scratch
>> > [  364.648470] XFS (loop0): Mounting Filesystem
>> > [  364.910035] XFS (loop0): Ending clean mount
>> > [  364.921063] VFS: Turning on hot data tracking
>> > root@debian-i386:/home/zwu# mount
>> > /dev/sda1 on / type ext3 (rw,errors=remount-ro)
>> > tmpfs on /lib/init/rw type tmpfs (rw,nosuid,mode=0755)
>> > proc on /proc type proc (rw,noexec,nosuid,nodev)
>> > sysfs on /sys type sysfs (rw,noexec,nosuid,nodev)
>> > udev on /dev type tmpfs (rw,mode=0755)
>> > tmpfs on /dev/shm type tmpfs (rw,nosuid,nodev)
>> > devpts on /dev/pts type devpts (rw,noexec,nosuid,gid=5,mode=620)
>> > none on /selinux type selinuxfs (rw,relatime)
>> > binfmt_misc on /proc/sys/fs/binfmt_misc type binfmt_misc
>> > (rw,noexec,nosuid,nodev)
>> > /dev/loop0 on /mnt/scratch type xfs (rw,hot_track,logbsize=256k)
>> > root@debian-i386:/home/zwu# free -m
>> >              total       used       free     shared    buffers
>> > cached
>> > Mem:           112        107          4          0          2
>> > 34
>> > -/+ buffers/cache:         70         41
>> > Swap:          713          2        711
>> >
>> > 1. fs_mark test
>> >
>> > 1.) orginal kernel
>> >
>> > #  ./fs_mark  -D  100  -S0  -n  1000  -s  1  -L  30  -d  /mnt/scratch/0
>> > -d  /mnt/scratch/1  -d  /mnt/scratch/2  -d  /mnt/scratch/3
>> > -d  /mnt/scratch/4  -d  /mnt/scratch/5  -d  /mnt/scratch/6
>> > -d  /mnt/scratch/7
>> > #       Version 3.3, 8 thread(s) starting at Wed Dec  5 03:20:58 2012
>> > #       Sync method: NO SYNC: Test does not issue sync() or fsync() calls.
>> > #       Directories:  Time based hash between directories across 100
>> > subdirectories with 180 seconds per subdirectory.
>> > #       File names: 40 bytes long, (16 initial bytes of time stamp with 24
>> > random bytes at end of name)
>> > #       Files info: size 1 bytes, written with an IO size of 16384 bytes per
>> > write
>> > #       App overhead is time in microseconds spent in the test not doing file
>> > writing related system calls.
>> >
>> > FSUse%        Count         Size    Files/sec     App Overhead
>> >      2         8000            1        375.6         27175895
>> >      3        16000            1        375.6         27478079
>> >      4        24000            1        346.0         27819607
>> >      4        32000            1        316.9         25863385
>> >      5        40000            1        335.2         25460605
>> >      6        48000            1        312.3         25889196
>> >      7        56000            1        327.3         25000611
>> >      8        64000            1        304.4         28126698
>> >      9        72000            1        361.7         26652172
>> >      9        80000            1        370.1         27075875
>> >     10        88000            1        347.8         31093106
>> >     11        96000            1        387.1         26877324
>> >     12       104000            1        352.3         26635853
>> >     13       112000            1        379.3         26400198
>> >     14       120000            1        367.4         27228178
>> >     14       128000            1        359.2         27627871
>> >     15       136000            1        358.4         27089821
>> >     16       144000            1        385.5         27804852
>> >     17       152000            1        322.9         26221907
>> >     18       160000            1        393.2         26760040
>> >     18       168000            1        351.9         29210327
>> >     20       176000            1        395.2         24610548
>> >     20       184000            1        376.7         27518650
>> >     21       192000            1        340.1         27512874
>> >     22       200000            1        389.0         27109104
>> >     23       208000            1        389.7         29288594
>> >     24       216000            1        352.6         29948820
>> >     25       224000            1        380.4         26370958
>> >     26       232000            1        332.9         27770518
>> >     26       240000            1        333.6         25176691
>> >
>> > 2.) kernel with enabled hot tracking
>> >
>> > #  ./fs_mark  -D  100  -S0  -n  1000  -s  1  -L  30  -d  /mnt/scratch/0
>> > -d  /mnt/scratch/1  -d  /mnt/scratch/2  -d  /mnt/scratch/3
>> > -d  /mnt/scratch/4  -d  /mnt/scratch/5  -d  /mnt/scratch/6
>> > -d  /mnt/scratch/7
>> > #       Version 3.3, 8 thread(s) starting at Tue Dec  4 04:28:48 2012
>> > #       Sync method: NO SYNC: Test does not issue sync() or fsync() calls.
>> > #       Directories:  Time based hash between directories across 100
>> > subdirectories with 180 seconds per subdirectory.
>> > #       File names: 40 bytes long, (16 initial bytes of time stamp with 24
>> > random bytes at end of name)
>> > #       Files info: size 1 bytes, written with an IO size of 16384 bytes per
>> > write
>> > #       App overhead is time in microseconds spent in the test not doing file
>> > writing related system calls.
>> >
>> > FSUse%        Count         Size    Files/sec     App Overhead
>> >      4         8000            1        323.0         25104879
>> >      6        16000            1        351.4         25372919
>> >      8        24000            1        345.9         24107987
>> >      9        32000            1        313.2         26249533
>> >     10        40000            1        323.0         20312267
>> >     12        48000            1        303.2         22178040
>> >     14        56000            1        307.6         22775058
>> >     15        64000            1        317.9         25178845
>> >     17        72000            1        351.8         22020260
>> >     19        80000            1        369.3         23546708
>> >     21        88000            1        324.1         29068297
>> >     22        96000            1        355.3         25212333
>> >     24       104000            1        346.4         26622613
>> >     26       112000            1        360.4         25477193
>> >     28       120000            1        362.9         21774508
>> >     29       128000            1        329.0         25760109
>> >     31       136000            1        369.5         24540577
>> >     32       144000            1        330.2         26013559
>> >     34       152000            1        365.5         25643279
>> >     36       160000            1        366.2         24393130
>> >     38       168000            1        348.3         25248940
>> >     39       176000            1        357.3         24080574
>> >     40       184000            1        316.8         23011921
>> >     43       192000            1        351.7         27468060
>> >     44       200000            1        362.2         27540349
>> >     46       208000            1        340.9         26135445
>> >     48       216000            1        339.2         20926743
>> >     50       224000            1        316.5         21399871
>> >     52       232000            1        346.3         24669604
>> >     53       240000            1        320.5         22204449
>> >
>> >
>> > 2. FFSB test
>> >
>> > 1.) original kernel
>> >
>> > FFSB version 6.0-RC2 started
>> >
>> > benchmark time = 10
>> > ThreadGroup 0
>> > ================
>> >          num_threads      = 4
>> >
>> >          read_random      = off
>> >          read_size        = 40960       (40KB)
>> >          read_blocksize   = 4096        (4KB)
>> >          read_skip        = off
>> >          read_skipsize    = 0   (0B)
>> >
>> >          write_random     = off
>> >          write_size       = 40960       (40KB)
>> >          fsync_file       = 0
>> >          write_blocksize  = 4096        (4KB)
>> >          wait time        = 0
>> >
>> >          op weights
>> >                          read = 0 (0.00%)
>> >                       readall = 1 (10.00%)
>> >                         write = 0 (0.00%)
>> >                        create = 1 (10.00%)
>> >                        append = 1 (10.00%)
>> >                        delete = 1 (10.00%)
>> >                        metaop = 0 (0.00%)
>> >                     createdir = 0 (0.00%)
>> >                          stat = 1 (10.00%)
>> >                      writeall = 1 (10.00%)
>> >                writeall_fsync = 1 (10.00%)
>> >                    open_close = 1 (10.00%)
>> >                   write_fsync = 0 (0.00%)
>> >                  create_fsync = 1 (10.00%)
>> >                  append_fsync = 1 (10.00%)
>> >
>> > FileSystem /mnt/scratch/test1
>> > ==========
>> >          num_dirs         = 100
>> >          starting files   = 0
>> >
>> >          Fileset weight:
>> >                      33554432 (  32MB) -> 1 (1.00%)
>> >                       8388608 (   8MB) -> 2 (2.00%)
>> >                        524288 ( 512KB) -> 3 (3.00%)
>> >                        262144 ( 256KB) -> 4 (4.00%)
>> >                        131072 ( 128KB) -> 5 (5.00%)
>> >                         65536 (  64KB) -> 8 (8.00%)
>> >                         32768 (  32KB) -> 10 (10.00%)
>> >                         16384 (  16KB) -> 13 (13.00%)
>> >                          8192 (   8KB) -> 21 (21.00%)
>> >                          4096 (   4KB) -> 33 (33.00%)
>> >          directio         = off
>> >          alignedio        = off
>> >          bufferedio       = off
>> >
>> >          aging is off
>> >          current utilization = 26.19%
>> >
>> > creating new fileset /mnt/scratch/test1
>> > fs setup took 87 secs
>> > Syncing()...1 sec
>> > Starting Actual Benchmark At: Wed Dec  5 03:38:06 2012
>> >
>> > Syncing()...0 sec
>> > FFSB benchmark finished   at: Wed Dec  5 03:38:18 2012
>> >
>> > Results:
>> > Benchmark took 11.44 sec
>> >
>> > Total Results
>> > ===============
>> >              Op Name   Transactions      Trans/sec      % Trans     % Op Weight
>> > Throughput
>> >              =======   ============      =========      =======     ===========
>> > ==========
>> >              readall :           93           8.13       0.880%         21.053%
>> > 32.5KB/sec
>> >               create :           20           1.75       0.189%          5.263%
>> > 6.99KB/sec
>> >               append :           10           0.87       0.095%          2.632%
>> > 3.5KB/sec
>> >               delete :            4           0.35       0.038%         10.526%
>> > NA
>> >                 stat :            3           0.26       0.028%          7.895%
>> > NA
>> >             writeall :         2178         190.39      20.600%         10.526%
>> > 762KB/sec
>> >       writeall_fsync :            5           0.44       0.047%          5.263%
>> > 1.75KB/sec
>> >           open_close :            6           0.52       0.057%         15.789%
>> > NA
>> >         create_fsync :         8234         719.78      77.878%         15.789%
>> > 2.81MB/sec
>> >         append_fsync :           20           1.75       0.189%          5.263%
>> > 6.99KB/sec
>> > -
>> > 924.24 Transactions per Second
>> >
>> > Throughput Results
>> > ===================
>> > Read Throughput: 32.5KB/sec
>> > Write Throughput: 3.57MB/sec
>> >
>> > System Call Latency statistics in millisecs
>> > =====
>> >                 Min             Avg             Max             Total Calls
>> >                 ========        ========        ========        ============
>> > [   open]       0.050000        3.980161        41.840000                 31
>> >    -
>> > [   read]       0.017000        71.442215       1286.122000               93
>> >    -
>> > [  write]       0.052000        1.034817        2201.956000            10467
>> >    -
>> > [ unlink]       1.118000        185.398750      730.807000                 4
>> >    -
>> > [  close]       0.019000        1.968968        39.679000                 31
>> >    -
>> > [   stat]       0.043000        2.173667        6.428000                   3
>> >    -
>> >
>> > 0.8% User   Time
>> > 9.2% System Time
>> > 10.0% CPU Utilization
>> >
>> > 2.) kernel with enabled hot tracking
>> >
>> > FFSB version 6.0-RC2 started
>> >
>> > benchmark time = 10
>> > ThreadGroup 0
>> > ================
>> >          num_threads      = 4
>> >
>> >          read_random      = off
>> >          read_size        = 40960       (40KB)
>> >          read_blocksize   = 4096        (4KB)
>> >          read_skip        = off
>> >          read_skipsize    = 0   (0B)
>> >
>> >          write_random     = off
>> >          write_size       = 40960       (40KB)
>> >          fsync_file       = 0
>> >          write_blocksize  = 4096        (4KB)
>> >          wait time        = 0
>> >
>> >          op weights
>> >                          read = 0 (0.00%)
>> >                       readall = 1 (10.00%)
>> >                         write = 0 (0.00%)
>> >                        create = 1 (10.00%)
>> >                        append = 1 (10.00%)
>> >                        delete = 1 (10.00%)
>> >                        metaop = 0 (0.00%)
>> >                     createdir = 0 (0.00%)
>> >                          stat = 1 (10.00%)
>> >                      writeall = 1 (10.00%)
>> >                writeall_fsync = 1 (10.00%)
>> >                    open_close = 1 (10.00%)
>> >                   write_fsync = 0 (0.00%)
>> >                  create_fsync = 1 (10.00%)
>> >                  append_fsync = 1 (10.00%)
>> >
>> > FileSystem /mnt/scratch/test1
>> > ==========
>> >          num_dirs         = 100
>> >          starting files   = 0
>> >
>> >          Fileset weight:
>> >                      33554432 (  32MB) -> 1 (1.00%)
>> >                       8388608 (   8MB) -> 2 (2.00%)
>> >                        524288 ( 512KB) -> 3 (3.00%)
>> >                        262144 ( 256KB) -> 4 (4.00%)
>> >                        131072 ( 128KB) -> 5 (5.00%)
>> >                         65536 (  64KB) -> 8 (8.00%)
>> >                         32768 (  32KB) -> 10 (10.00%)
>> >                         16384 (  16KB) -> 13 (13.00%)
>> >                          8192 (   8KB) -> 21 (21.00%)
>> >                          4096 (   4KB) -> 33 (33.00%)
>> >          directio         = off
>> >          alignedio        = off
>> >          bufferedio       = off
>> >
>> >          aging is off
>> >          current utilization = 52.46%
>> >
>> > creating new fileset /mnt/scratch/test1
>> > fs setup took 42 secs
>> > Syncing()...1 sec
>> > Starting Actual Benchmark At: Tue Dec  4 06:41:54 2012
>> >
>> > Syncing()...0 sec
>> > FFSB benchmark finished   at: Tue Dec  4 06:42:53 2012
>> >
>> > Results:
>> > Benchmark took 59.42 sec
>> >
>> > Total Results
>> > ===============
>> >              Op Name   Transactions      Trans/sec      % Trans     % Op Weight
>> > Throughput
>> >              =======   ============      =========      =======     ===========
>> > ==========
>> >              readall :        10510         176.87      54.808%         10.959%
>> > 707KB/sec
>> >               create :           48           0.81       0.250%          9.589%
>> > 3.23KB/sec
>> >               append :          100           1.68       0.521%         13.699%
>> > 6.73KB/sec
>> >               delete :            5           0.08       0.026%          6.849%
>> > NA
>> >                 stat :            5           0.08       0.026%          6.849%
>> > NA
>> >             writeall :          130           2.19       0.678%         12.329%
>> > 8.75KB/sec
>> >       writeall_fsync :           19           0.32       0.099%          8.219%
>> > 1.28KB/sec
>> >           open_close :            9           0.15       0.047%         12.329%
>> > NA
>> >         create_fsync :         8300         139.67      43.283%         12.329%
>> > 559KB/sec
>> >         append_fsync :           50           0.84       0.261%          6.849%
>> > 3.37KB/sec
>> > -
>> > 322.70 Transactions per Second
>> >
>> > Throughput Results
>> > ===================
>> > Read Throughput: 707KB/sec
>> > Write Throughput: 582KB/sec
>> >
>> > System Call Latency statistics in millisecs
>> > =====
>> >                 Min             Avg             Max             Total Calls
>> >                 ========        ========        ========        ============
>> > [   open]       0.061000        0.750540        10.721000                 63
>> >    -
>> > [   read]       0.017000        11.058425       28555.394000           10510
>> >    -
>> > [  write]       0.034000        6.705286        26812.076000            8647
>> >    -
>> > [ unlink]       0.922000        7.679800        25.364000                  5
>> >    -
>> > [  close]       0.019000        0.996635        34.723000                 63
>> >    -
>> > [   stat]       0.046000        0.942800        4.489000                   5
>> >    -
>> >
>> > 0.2% User   Time
>> > 2.6% System Time
>> > 2.8% CPU Utilization
>> >
>> >
>> > 3. fio test
>> >
>> > 1.) original kernel
>> >
>> > seq-read: (g=0): rw=read, bs=8K-8K/8K-8K, ioengine=libaio, iodepth=8
>> > ...
>> > seq-read: (g=0): rw=read, bs=8K-8K/8K-8K, ioengine=libaio, iodepth=8
>> > seq-write: (g=1): rw=write, bs=8K-8K/8K-8K, ioengine=libaio, iodepth=8
>> > ...
>> > seq-write: (g=1): rw=write, bs=8K-8K/8K-8K, ioengine=libaio, iodepth=8
>> > rnd-read: (g=2): rw=randread, bs=8K-8K/8K-8K, ioengine=libaio, iodepth=8
>> > ...
>> > rnd-read: (g=2): rw=randread, bs=8K-8K/8K-8K, ioengine=libaio, iodepth=8
>> > rnd-write: (g=3): rw=randwrite, bs=8K-8K/8K-8K, ioengine=libaio,
>> > iodepth=8
>> > ...
>> > rnd-write: (g=3): rw=randwrite, bs=8K-8K/8K-8K, ioengine=libaio,
>> > iodepth=8
>> > Starting 16 threads
>> >
>> > seq-read: (groupid=0, jobs=4): err= 0: pid=1646
>> >   read : io=2,835MB, bw=24,192KB/s, iops=3,023, runt=120021msec
>> >     slat (usec): min=0, max=999K, avg=1202.67, stdev=3145.84
>> >     clat (usec): min=0, max=1,536K, avg=9186.07, stdev=11344.56
>> >     bw (KB/s) : min=   39, max=21301, per=26.11%, avg=6315.41,
>> > stdev=1082.63
>> >   cpu          : usr=10.89%, sys=33.14%, ctx=1488108, majf=13, minf=2238
>> >   IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=100.0%, 16=0.0%, 32=0.0%,
>> >>=64=0.0%
>> >      submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%,
>> >>=64=0.0%
>> >      complete  : 0=0.0%, 4=100.0%, 8=0.1%, 16=0.0%, 32=0.0%, 64=0.0%,
>> >>=64=0.0%
>> >      issued r/w: total=362940/0, short=0/0
>> >      lat (usec): 2=3.53%, 50=0.01%, 100=0.01%, 250=0.01%, 500=0.01%
>> >      lat (usec): 750=0.03%, 1000=0.03%
>> >      lat (msec): 2=1.75%, 4=1.08%, 10=68.93%, 20=22.39%, 50=2.02%
>> >      lat (msec): 100=0.16%, 250=0.04%, 1000=0.01%, 2000=0.03%
>> > seq-write: (groupid=1, jobs=4): err= 0: pid=1646
>> >   write: io=1,721MB, bw=14,652KB/s, iops=1,831, runt=120277msec
>> >     slat (usec): min=0, max=1,004K, avg=1744.41, stdev=3144.06
>> >     clat (usec): min=0, max=1,014K, avg=15699.65, stdev=19751.69
>> >     bw (KB/s) : min=  285, max=18032, per=26.41%, avg=3869.67,
>> > stdev=762.96
>> >   cpu          : usr=6.29%, sys=22.61%, ctx=880380, majf=36, minf=3222
>> >   IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=100.0%, 16=0.0%, 32=0.0%,
>> >>=64=0.0%
>> >      submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%,
>> >>=64=0.0%
>> >      complete  : 0=0.0%, 4=100.0%, 8=0.1%, 16=0.0%, 32=0.0%, 64=0.0%,
>> >>=64=0.0%
>> >      issued r/w: total=0/220282, short=0/0
>> >      lat (usec): 2=2.43%, 500=0.01%, 750=0.12%, 1000=0.14%
>> >      lat (msec): 2=0.86%, 4=1.72%, 10=39.03%, 20=42.20%, 50=11.87%
>> >      lat (msec): 100=1.15%, 250=0.17%, 500=0.06%, 750=0.14%, 1000=0.09%
>> >      lat (msec): 2000=0.02%
>> > rnd-read: (groupid=2, jobs=4): err= 0: pid=1646
>> >   read : io=65,128KB, bw=541KB/s, iops=67, runt=120381msec
>> >     slat (usec): min=48, max=55,230, avg=167.95, stdev=248.50
>> >     clat (msec): min=74, max=4,229, avg=472.23, stdev=129.50
>> >     bw (KB/s) : min=    0, max=  203, per=25.34%, avg=137.08,
>> > stdev=21.73
>> >   cpu          : usr=0.85%, sys=2.19%, ctx=44001, majf=30, minf=3726
>> >   IO depths    : 1=0.1%, 2=0.1%, 4=0.2%, 8=99.7%, 16=0.0%, 32=0.0%,
>> >>=64=0.0%
>> >      submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%,
>> >>=64=0.0%
>> >      complete  : 0=0.0%, 4=100.0%, 8=0.1%, 16=0.0%, 32=0.0%, 64=0.0%,
>> >>=64=0.0%
>> >      issued r/w: total=8141/0, short=0/0
>> >
>> >      lat (msec): 100=0.04%, 250=0.09%, 500=81.72%, 750=13.09%,
>> > 1000=2.97%
>> >      lat (msec): 2000=1.50%, >=2000=0.59%
>> > rnd-write: (groupid=3, jobs=4): err= 0: pid=1646
>> >   write: io=200MB, bw=1,698KB/s, iops=212, runt=120331msec
>> >     slat (usec): min=48, max=215K, avg=2272.24, stdev=2283.09
>> >     clat (usec): min=762, max=14,617K, avg=147521.66, stdev=444146.36
>> >     bw (KB/s) : min=    1, max= 3960, per=56.86%, avg=964.90,
>> > stdev=514.63
>> >   cpu          : usr=1.25%, sys=4.20%, ctx=135229, majf=0, minf=10194
>> >   IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=99.9%, 16=0.0%, 32=0.0%,
>> >>=64=0.0%
>> >      submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%,
>> >>=64=0.0%
>> >      complete  : 0=0.0%, 4=100.0%, 8=0.1%, 16=0.0%, 32=0.0%, 64=0.0%,
>> >>=64=0.0%
>> >      issued r/w: total=0/25536, short=0/0
>> >      lat (usec): 1000=0.26%
>> >      lat (msec): 2=0.13%, 4=2.01%, 10=3.77%, 20=42.78%, 50=20.95%
>> >      lat (msec): 100=12.83%, 250=12.50%, 500=2.49%, 750=0.33%,
>> > 1000=0.12%
>> >      lat (msec): 2000=0.53%, >=2000=1.30%
>> >
>> > Run status group 0 (all jobs):
>> >    READ: io=2,835MB, aggrb=24,191KB/s, minb=24,772KB/s, maxb=24,772KB/s,
>> > mint=120021msec, maxt=120021msec
>> >
>> > Run status group 1 (all jobs):
>> >   WRITE: io=1,721MB, aggrb=14,651KB/s, minb=15,003KB/s, maxb=15,003KB/s,
>> > mint=120277msec, maxt=120277msec
>> >
>> > Run status group 2 (all jobs):
>> >    READ: io=65,128KB, aggrb=541KB/s, minb=553KB/s, maxb=553KB/s,
>> > mint=120381msec, maxt=120381msec
>> >
>> > Run status group 3 (all jobs):
>> >   WRITE: io=200MB, aggrb=1,697KB/s, minb=1,738KB/s, maxb=1,738KB/s,
>> > mint=120331msec, maxt=120331msec
>> >
>> > Disk stats (read/write):
>> >   loop0: ios=0/0, merge=0/0, ticks=0/0, in_queue=0, util=0.00%
>> >
>> > 2.) kernel with enabled hot tracking
>> >
>> > seq-read: (g=0): rw=read, bs=8K-8K/8K-8K, ioengine=libaio, iodepth=8
>> > ...
>> > seq-read: (g=0): rw=read, bs=8K-8K/8K-8K, ioengine=libaio, iodepth=8
>> > seq-write: (g=1): rw=write, bs=8K-8K/8K-8K, ioengine=libaio, iodepth=8
>> > ...
>> > seq-write: (g=1): rw=write, bs=8K-8K/8K-8K, ioengine=libaio, iodepth=8
>> > rnd-read: (g=2): rw=randread, bs=8K-8K/8K-8K, ioengine=libaio, iodepth=8
>> > ...
>> > rnd-read: (g=2): rw=randread, bs=8K-8K/8K-8K, ioengine=libaio, iodepth=8
>> > rnd-write: (g=3): rw=randwrite, bs=8K-8K/8K-8K, ioengine=libaio,
>> > iodepth=8
>> > ...
>> > rnd-write: (g=3): rw=randwrite, bs=8K-8K/8K-8K, ioengine=libaio,
>> > iodepth=8
>> > Starting 16 threads
>> >
>> > seq-read: (groupid=0, jobs=4): err= 0: pid=2163
>> >   read : io=3,047MB, bw=26,001KB/s, iops=3,250, runt=120003msec
>> >     slat (usec): min=0, max=1,000K, avg=1141.34, stdev=2175.25
>> >     clat (usec): min=0, max=1,002K, avg=8610.96, stdev=6184.67
>> >     bw (KB/s) : min=   12, max=18896, per=25.28%, avg=6572.50,
>> > stdev=713.22
>> >   cpu          : usr=10.38%, sys=35.02%, ctx=1601418, majf=12, minf=2235
>> >   IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=100.0%, 16=0.0%, 32=0.0%,
>> >>=64=0.0%
>> >      submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%,
>> >>=64=0.0%
>> >      complete  : 0=0.0%, 4=100.0%, 8=0.1%, 16=0.0%, 32=0.0%, 64=0.0%,
>> >>=64=0.0%
>> >      issued r/w: total=390029/0, short=0/0
>> >      lat (usec): 2=1.49%, 50=0.01%, 100=0.01%, 250=0.01%, 500=0.01%
>> >      lat (usec): 750=0.01%, 1000=0.02%
>> >      lat (msec): 2=1.53%, 4=0.86%, 10=79.60%, 20=14.93%, 50=1.43%
>> >      lat (msec): 100=0.09%, 250=0.02%, 500=0.01%, 1000=0.01%, 2000=0.01%
>> > seq-write: (groupid=1, jobs=4): err= 0: pid=2163
>> >   write: io=1,752MB, bw=14,950KB/s, iops=1,868, runt=120003msec
>> >     slat (usec): min=0, max=1,002K, avg=1697.47, stdev=3568.70
>> >     clat (usec): min=0, max=1,019K, avg=15630.94, stdev=21109.46
>> >     bw (KB/s) : min=  123, max=14693, per=26.31%, avg=3933.46,
>> > stdev=779.57
>> >   cpu          : usr=6.31%, sys=21.85%, ctx=894177, majf=4, minf=3407
>> >   IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=100.0%, 16=0.0%, 32=0.0%,
>> >>=64=0.0%
>> >      submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%,
>> >>=64=0.0%
>> >      complete  : 0=0.0%, 4=100.0%, 8=0.1%, 16=0.0%, 32=0.0%, 64=0.0%,
>> >>=64=0.0%
>> >      issued r/w: total=0/224253, short=0/0
>> >      lat (usec): 2=2.44%, 100=0.01%, 250=0.01%, 500=0.01%, 750=0.06%
>> >      lat (usec): 1000=0.23%
>> >      lat (msec): 2=0.73%, 4=2.00%, 10=40.15%, 20=42.68%, 50=10.25%
>> >      lat (msec): 100=0.95%, 250=0.14%, 500=0.10%, 750=0.12%, 1000=0.11%
>> >      lat (msec): 2000=0.03%
>> > rnd-read: (groupid=2, jobs=4): err= 0: pid=2163
>> >   read : io=85,208KB, bw=709KB/s, iops=88, runt=120252msec
>> >     slat (usec): min=52, max=48,325, avg=204.43, stdev=596.50
>> >     clat (msec): min=1, max=2,754, avg=359.99, stdev=78.96
>> >     bw (KB/s) : min=    0, max=  249, per=25.17%, avg=178.20,
>> > stdev=23.79
>> >   cpu          : usr=1.00%, sys=2.64%, ctx=55704, majf=28, minf=2971
>> >   IO depths    : 1=0.1%, 2=0.1%, 4=0.2%, 8=99.7%, 16=0.0%, 32=0.0%,
>> >>=64=0.0%
>> >      submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%,
>> >>=64=0.0%
>> >      complete  : 0=0.0%, 4=100.0%, 8=0.1%, 16=0.0%, 32=0.0%, 64=0.0%,
>> >>=64=0.0%
>> >      issued r/w: total=10651/0, short=0/0
>> >
>> >      lat (msec): 2=0.01%, 50=0.02%, 100=0.04%, 250=1.61%, 500=92.60%
>> >      lat (msec): 750=4.24%, 1000=0.68%, 2000=0.59%, >=2000=0.22%
>> > rnd-write: (groupid=3, jobs=4): err= 0: pid=2163
>> >   write: io=247MB, bw=2,019KB/s, iops=252, runt=125287msec
>> >     slat (usec): min=51, max=286K, avg=2576.23, stdev=2882.30
>> >     clat (usec): min=698, max=8,156K, avg=123274.05, stdev=355311.20
>> >     bw (KB/s) : min=    1, max= 4848, per=57.62%, avg=1162.77,
>> > stdev=560.79
>> >   cpu          : usr=1.33%, sys=4.24%, ctx=163334, majf=0, minf=8588
>> >   IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=99.9%, 16=0.0%, 32=0.0%,
>> >>=64=0.0%
>> >      submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%,
>> >>=64=0.0%
>> >      complete  : 0=0.0%, 4=100.0%, 8=0.1%, 16=0.0%, 32=0.0%, 64=0.0%,
>> >>=64=0.0%
>> >      issued r/w: total=0/31616, short=0/0
>> >      lat (usec): 750=0.03%, 1000=0.15%
>> >      lat (msec): 2=0.06%, 4=2.15%, 10=3.57%, 20=48.23%, 50=22.43%
>> >      lat (msec): 100=11.48%, 250=9.14%, 500=1.04%, 750=0.16%, 1000=0.05%
>> >      lat (msec): 2000=0.09%, >=2000=1.42%
>> >
>> > Run status group 0 (all jobs):
>> >    READ: io=3,047MB, aggrb=26,001KB/s, minb=26,625KB/s, maxb=26,625KB/s,
>> > mint=120003msec, maxt=120003msec
>> >
>> > Run status group 1 (all jobs):
>> >   WRITE: io=1,752MB, aggrb=14,949KB/s, minb=15,308KB/s, maxb=15,308KB/s,
>> > mint=120003msec, maxt=120003msec
>> >
>> > Run status group 2 (all jobs):
>> >    READ: io=85,208KB, aggrb=708KB/s, minb=725KB/s, maxb=725KB/s,
>> > mint=120252msec, maxt=120252msec
>> >
>> > Run status group 3 (all jobs):
>> >   WRITE: io=247MB, aggrb=2,018KB/s, minb=2,067KB/s, maxb=2,067KB/s,
>> > mint=125287msec, maxt=125287msec
>> >
>> > Disk stats (read/write):
>> >   loop0: ios=0/0, merge=0/0, ticks=0/0, in_queue=0, util=0.00%
>> >
>> >
>> > 4. compilebench test
>> >
>> > 1.) original kernel
>> >
>> > using working directory /mnt/scratch/, 30 intial dirs 100 runs
>> >
>> > native unpatched native-0 222MB in 87.48 seconds (2.54 MB/s)
>> > native patched native-0 109MB in 24.89 seconds (4.41 MB/s)
>> > native patched compiled native-0 691MB in 35.54 seconds (19.46 MB/s)
>> > create dir kernel-0 222MB in 91.22 seconds (2.44 MB/s)
>> > create dir kernel-1 222MB in 91.55 seconds (2.43 MB/s)
>> > create dir kernel-2 222MB in 97.00 seconds (2.29 MB/s)
>> > create dir kernel-3 222MB in 87.64 seconds (2.54 MB/s)
>> > create dir kernel-4 222MB in 86.18 seconds (2.58 MB/s)
>> > create dir kernel-5 222MB in 84.68 seconds (2.63 MB/s)
>> > create dir kernel-6 222MB in 85.02 seconds (2.62 MB/s)
>> > create dir kernel-7 222MB in 87.74 seconds (2.53 MB/s)
>> > create dir kernel-8 222MB in 86.79 seconds (2.56 MB/s)
>> > create dir kernel-9 222MB in 87.85 seconds (2.53 MB/s)
>> > create dir kernel-10 222MB in 86.88 seconds (2.56 MB/s)
>> > create dir kernel-11 222MB in 86.47 seconds (2.57 MB/s)
>> > create dir kernel-12 222MB in 84.26 seconds (2.64 MB/s)
>> > create dir kernel-13 222MB in 87.40 seconds (2.54 MB/s)
>> > create dir kernel-14 222MB in 85.44 seconds (2.60 MB/s)
>> > create dir kernel-15 222MB in 86.80 seconds (2.56 MB/s)
>> > create dir kernel-16 222MB in 88.57 seconds (2.51 MB/s)
>> > create dir kernel-17 222MB in 85.66 seconds (2.60 MB/s)
>> > create dir kernel-18 222MB in 87.40 seconds (2.54 MB/s)
>> > create dir kernel-19 222MB in 85.47 seconds (2.60 MB/s)
>> > create dir kernel-20 222MB in 89.29 seconds (2.49 MB/s)
>> > create dir kernel-21 222MB in 88.53 seconds (2.51 MB/s)
>> > create dir kernel-22 222MB in 86.25 seconds (2.58 MB/s)
>> > create dir kernel-23 222MB in 85.34 seconds (2.61 MB/s)
>> > create dir kernel-24 222MB in 84.61 seconds (2.63 MB/s)
>> > create dir kernel-25 222MB in 88.13 seconds (2.52 MB/s)
>> > create dir kernel-26 222MB in 85.57 seconds (2.60 MB/s)
>> > create dir kernel-27 222MB in 87.26 seconds (2.55 MB/s)
>> > create dir kernel-28 222MB in 83.68 seconds (2.66 MB/s)
>> > create dir kernel-29 222MB in 86.33 seconds (2.58 MB/s)
>> > === sdb ===
>> >   CPU  0:              9366376 events,   439049 KiB data
>> >   Total:               9366376 events (dropped 0),   439049 KiB data
>> > patch dir kernel-7 109MB in 55.00 seconds (1.99 MB/s)
>> > compile dir kernel-7 691MB in 37.15 seconds (18.62 MB/s)
>> > compile dir kernel-14 680MB in 38.48 seconds (17.69 MB/s)
>> > patch dir kernel-14 691MB in 93.31 seconds (7.41 MB/s)
>> > read dir kernel-7 in 93.36 9.85 MB/s
>> > read dir kernel-10 in 58.25 3.82 MB/s
>> > create dir kernel-3116 222MB in 91.96 seconds (2.42 MB/s)
>> > clean kernel-7 691MB in 5.16 seconds (134.03 MB/s)
>> > read dir kernel-6 in 56.98 3.90 MB/s
>> > stat dir kernel-2 in 19.42 seconds
>> > compile dir kernel-2 680MB in 43.11 seconds (15.79 MB/s)
>> > clean kernel-14 691MB in 6.27 seconds (110.30 MB/s)
>> > clean kernel-2 680MB in 5.79 seconds (117.55 MB/s)
>> > patch dir kernel-2 109MB in 71.22 seconds (1.54 MB/s)
>> > stat dir kernel-2 in 16.06 seconds
>> > create dir kernel-6231 222MB in 96.20 seconds (2.31 MB/s)
>> > delete kernel-8 in 45.20 seconds
>> > compile dir kernel-2 691MB in 38.58 seconds (17.93 MB/s)
>> > create dir kernel-70151 222MB in 93.41 seconds (2.38 MB/s)
>> > clean kernel-2 691MB in 5.09 seconds (135.87 MB/s)
>> > create dir kernel-78184 222MB in 86.04 seconds (2.58 MB/s)
>> > compile dir kernel-7 691MB in 37.60 seconds (18.39 MB/s)
>> > create dir kernel-64250 222MB in 80.33 seconds (2.77 MB/s)
>> > delete kernel-12 in 43.00 seconds
>> > stat dir kernel-2 in 16.43 seconds
>> > patch dir kernel-70151 109MB in 77.42 seconds (1.42 MB/s)
>> > stat dir kernel-7 in 18.48 seconds
>> > stat dir kernel-78184 in 18.62 seconds
>> > compile dir kernel-2 691MB in 43.31 seconds (15.97 MB/s)
>> > compile dir kernel-26 680MB in 50.37 seconds (13.51 MB/s)
>> > stat dir kernel-7 in 21.52 seconds
>> > create dir kernel-2717 222MB in 89.86 seconds (2.47 MB/s)
>> > delete kernel-26 in 47.81 seconds
>> > stat dir kernel-2 in 18.61 seconds
>> > compile dir kernel-14 691MB in 46.66 seconds (14.82 MB/s)
>> > compile dir kernel-70151 691MB in 39.19 seconds (17.65 MB/s)
>> > create dir kernel-55376 222MB in 88.91 seconds (2.50 MB/s)
>> > stat dir kernel-22 in 18.66 seconds
>> > delete kernel-55376 in 37.71 seconds
>> > patch dir kernel-27 109MB in 74.82 seconds (1.47 MB/s)
>> > patch dir kernel-64250 109MB in 81.08 seconds (1.35 MB/s)
>> > read dir kernel-6231 in 82.15 2.71 MB/s
>> > patch dir kernel-9 109MB in 96.02 seconds (1.14 MB/s)
>> > stat dir kernel-14 in 22.46 seconds
>> > read dir kernel-29 in 58.10 3.83 MB/s
>> > create dir kernel-57327 222MB in 93.92 seconds (2.37 MB/s)
>> > stat dir kernel-14 in 21.92 seconds
>> > compile dir kernel-27 691MB in 41.43 seconds (16.69 MB/s)
>> > create dir kernel-64334 222MB in 89.31 seconds (2.49 MB/s)
>> > patch dir kernel-1 109MB in 84.37 seconds (1.30 MB/s)
>> > create dir kernel-16056 222MB in 94.93 seconds (2.34 MB/s)
>> > clean kernel-7 691MB in 7.27 seconds (95.13 MB/s)
>> > delete kernel-27 in 46.32 seconds
>> > create dir kernel-51614 222MB in 88.91 seconds (2.50 MB/s)
>> > clean kernel-14 691MB in 6.71 seconds (103.07 MB/s)
>> > delete kernel-64250 in 43.60 seconds
>> > stat dir kernel-2 in 24.25 seconds
>> > clean kernel-70151 691MB in 6.20 seconds (111.55 MB/s)
>> > delete kernel-14 in 40.74 seconds
>> > read dir kernel-2 in 118.45 7.76 MB/s
>> > create dir kernel-24150 222MB in 88.99 seconds (2.50 MB/s)
>> > read dir kernel-9 in 83.70 2.73 MB/s
>> > patch dir kernel-19 109MB in 76.06 seconds (1.44 MB/s)
>> > clean kernel-2 691MB in 6.64 seconds (104.16 MB/s)
>> > compile dir kernel-18 680MB in 47.33 seconds (14.38 MB/s)
>> > compile dir kernel-2 691MB in 44.63 seconds (15.50 MB/s)
>> > delete kernel-2 in 51.03 seconds
>> > delete kernel-70151 in 45.96 seconds
>> > stat dir kernel-1 in 17.56 seconds
>> > read dir kernel-18 in 121.08 7.46 MB/s
>> > clean kernel-18 680MB in 6.47 seconds (105.20 MB/s)
>> > compile dir kernel-17 680MB in 52.10 seconds (13.06 MB/s)
>> > read dir kernel-17 in 114.66 7.88 MB/s
>> > stat dir kernel-18 in 30.36 seconds
>> > stat dir kernel-64334 in 44.78 seconds
>> > delete kernel-24150 in 44.79 seconds
>> > delete kernel-17 in 47.64 seconds
>> > stat dir kernel-1 in 19.87 seconds
>> > compile dir kernel-7 691MB in 47.65 seconds (14.51 MB/s)
>> > patch dir kernel-16 109MB in 100.96 seconds (1.09 MB/s)
>> > stat dir kernel-7 in 21.35 seconds
>> > create dir kernel-82195 222MB in 111.17 seconds (2.00 MB/s)
>> > delete kernel-82195 in 40.79 seconds
>> > stat dir kernel-3 in 19.51 seconds
>> > patch dir kernel-2717 109MB in 94.55 seconds (1.16 MB/s)
>> > patch dir kernel-5 109MB in 60.21 seconds (1.82 MB/s)
>> > read dir kernel-2717 in 94.85 2.41 MB/s
>> > delete kernel-29 in 40.51 seconds
>> > clean kernel-7 691MB in 5.84 seconds (118.42 MB/s)
>> > read dir kernel-4 in 57.91 3.84 MB/s
>> > stat dir kernel-78184 in 19.65 seconds
>> > patch dir kernel-0 109MB in 90.61 seconds (1.21 MB/s)
>> > patch dir kernel-3 109MB in 75.67 seconds (1.45 MB/s)
>> > create dir kernel-30226 222MB in 106.72 seconds (2.08 MB/s)
>> > read dir kernel-19 in 83.79 2.72 MB/s
>> > read dir kernel-9 in 82.64 2.76 MB/s
>> > delete kernel-5 in 38.89 seconds
>> > read dir kernel-7 in 59.70 3.82 MB/s
>> > patch dir kernel-57327 109MB in 101.71 seconds (1.08 MB/s)
>> > read dir kernel-11 in 59.83 3.72 MB/s
>> >
>> > run complete:
>> > ==========================================================================
>> > intial create total runs 30 avg 2.55 MB/s (user 13.94s sys 34.07s)
>> > create total runs 14 avg 2.41 MB/s (user 13.83s sys 34.39s)
>> > patch total runs 15 avg 1.79 MB/s (user 6.55s sys 34.71s)
>> > compile total runs 14 avg 16.04 MB/s (user 2.65s sys 16.88s)
>> > clean total runs 10 avg 113.53 MB/s (user 0.46s sys 3.14s)
>> > read tree total runs 11 avg 3.30 MB/s (user 11.68s sys 24.50s)
>> > read compiled tree total runs 4 avg 8.24 MB/s (user 13.67s sys 35.85s)
>> > delete tree total runs 10 avg 42.12 seconds (user 6.76s sys 24.50s)
>> > delete compiled tree total runs 4 avg 48.20 seconds (user 7.65s sys
>> > 28.60s)
>> > stat tree total runs 11 avg 21.90 seconds (user 6.87s sys 6.34s)
>> > stat compiled tree total runs 7 avg 21.23 seconds (user 7.65s sys 7.15s)
>> >
>> > 2.) kernel with enabled hot tracking
>> >
>> > using working directory /mnt/scratch/, 30 intial dirs 100 runs
>> > native unpatched native-0 222MB in 112.82 seconds (1.97 MB/s)
>> > native patched native-0 109MB in 27.38 seconds (4.01 MB/s)
>> > native patched compiled native-0 691MB in 40.42 seconds (17.11 MB/s)
>> > create dir kernel-0 222MB in 92.88 seconds (2.39 MB/s)
>> > create dir kernel-1 222MB in 98.56 seconds (2.26 MB/s)
>> > create dir kernel-2 222MB in 107.27 seconds (2.07 MB/s)
>> > create dir kernel-3 222MB in 92.81 seconds (2.40 MB/s)
>> > create dir kernel-4 222MB in 90.30 seconds (2.46 MB/s)
>> > create dir kernel-5 222MB in 91.57 seconds (2.43 MB/s)
>> > create dir kernel-6 222MB in 91.92 seconds (2.42 MB/s)
>> > create dir kernel-7 222MB in 90.16 seconds (2.47 MB/s)
>> > create dir kernel-8 222MB in 94.71 seconds (2.35 MB/s)
>> > create dir kernel-9 222MB in 91.79 seconds (2.42 MB/s)
>> > create dir kernel-10 222MB in 92.14 seconds (2.41 MB/s)
>> > create dir kernel-11 222MB in 88.59 seconds (2.51 MB/s)
>> > create dir kernel-12 222MB in 92.15 seconds (2.41 MB/s)
>> > create dir kernel-13 222MB in 91.54 seconds (2.43 MB/s)
>> > create dir kernel-14 222MB in 91.15 seconds (2.44 MB/s)
>> > create dir kernel-15 222MB in 90.54 seconds (2.46 MB/s)
>> > create dir kernel-16 222MB in 92.23 seconds (2.41 MB/s)
>> > create dir kernel-17 222MB in 89.88 seconds (2.47 MB/s)
>> > create dir kernel-18 222MB in 94.65 seconds (2.35 MB/s)
>> > create dir kernel-19 222MB in 89.99 seconds (2.47 MB/s)
>> > create dir kernel-20 222MB in 90.35 seconds (2.46 MB/s)
>> > create dir kernel-21 222MB in 90.92 seconds (2.45 MB/s)
>> > create dir kernel-22 222MB in 90.76 seconds (2.45 MB/s)
>> > create dir kernel-23 222MB in 90.04 seconds (2.47 MB/s)
>> > create dir kernel-24 222MB in 89.60 seconds (2.48 MB/s)
>> > create dir kernel-25 222MB in 91.52 seconds (2.43 MB/s)
>> > create dir kernel-26 222MB in 90.45 seconds (2.46 MB/s)
>> > create dir kernel-27 222MB in 92.72 seconds (2.40 MB/s)
>> > create dir kernel-28 222MB in 90.37 seconds (2.46 MB/s)
>> > create dir kernel-29 222MB in 89.60 seconds (2.48 MB/s)
>> > === sdb ===
>> >   CPU  0:              8878754 events,   416192 KiB data
>> >   Total:               8878754 events (dropped 0),   416192 KiB data
>> > patch dir kernel-7 109MB in 61.00 seconds (1.80 MB/s)
>> > compile dir kernel-7 691MB in 40.21 seconds (17.20 MB/s)
>> > compile dir kernel-14 680MB in 45.97 seconds (14.81 MB/s)
>> > patch dir kernel-14 691MB in 83.73 seconds (8.26 MB/s)
>> > read dir kernel-7 in 88.66 10.37 MB/s
>> > read dir kernel-10 in 56.44 3.94 MB/s
>> > create dir kernel-3116 222MB in 91.58 seconds (2.43 MB/s)
>> > clean kernel-7 691MB in 6.69 seconds (103.38 MB/s)
>> > read dir kernel-6 in 61.07 3.64 MB/s
>> > stat dir kernel-2 in 21.42 seconds
>> > compile dir kernel-2 680MB in 44.55 seconds (15.28 MB/s)
>> > clean kernel-14 691MB in 6.98 seconds (99.08 MB/s)
>> > clean kernel-2 680MB in 6.12 seconds (111.21 MB/s)
>> > patch dir kernel-2 109MB in 73.95 seconds (1.48 MB/s)
>> > stat dir kernel-2 in 18.61 seconds
>> > create dir kernel-6231 222MB in 100.84 seconds (2.21 MB/s)
>> > delete kernel-8 in 40.38 seconds
>> > compile dir kernel-2 691MB in 42.18 seconds (16.40 MB/s)
>> > create dir kernel-70151 222MB in 96.34 seconds (2.31 MB/s)
>> > clean kernel-2 691MB in 4.54 seconds (152.33 MB/s)
>> > create dir kernel-78184 222MB in 94.71 seconds (2.35 MB/s)
>> > compile dir kernel-7 691MB in 43.64 seconds (15.85 MB/s)
>> > create dir kernel-64250 222MB in 87.65 seconds (2.54 MB/s)
>> > delete kernel-12 in 38.58 seconds
>> > stat dir kernel-2 in 17.48 seconds
>> > patch dir kernel-70151 109MB in 79.82 seconds (1.37 MB/s)
>> > stat dir kernel-7 in 25.76 seconds
>> > stat dir kernel-78184 in 20.30 seconds
>> > compile dir kernel-2 691MB in 40.93 seconds (16.90 MB/s)
>> > compile dir kernel-26 680MB in 48.86 seconds (13.93 MB/s)
>> > stat dir kernel-7 in 23.87 seconds
>> > create dir kernel-2717 222MB in 98.71 seconds (2.25 MB/s)
>> > delete kernel-26 in 45.60 seconds
>> > stat dir kernel-2 in 22.62 seconds
>> > compile dir kernel-14 691MB in 51.12 seconds (13.53 MB/s)
>> > compile dir kernel-70151 691MB in 41.40 seconds (16.71 MB/s)
>> > create dir kernel-55376 222MB in 94.61 seconds (2.35 MB/s)
>> > stat dir kernel-22 in 22.11 seconds
>> > delete kernel-55376 in 36.47 seconds
>> > patch dir kernel-27 109MB in 76.74 seconds (1.43 MB/s)
>> > patch dir kernel-64250 109MB in 86.43 seconds (1.27 MB/s)
>> > read dir kernel-6231 in 85.10 2.61 MB/s
>> > patch dir kernel-9 109MB in 97.67 seconds (1.12 MB/s)
>> > stat dir kernel-14 in 24.80 seconds
>> > read dir kernel-29 in 61.00 3.65 MB/s
>> > create dir kernel-57327 222MB in 101.42 seconds (2.19 MB/s)
>> > stat dir kernel-14 in 22.45 seconds
>> > compile dir kernel-27 691MB in 48.19 seconds (14.35 MB/s)
>> > create dir kernel-64334 222MB in 96.65 seconds (2.30 MB/s)
>> > patch dir kernel-1 109MB in 88.32 seconds (1.24 MB/s)
>> > create dir kernel-16056 222MB in 100.60 seconds (2.21 MB/s)
>> > clean kernel-7 691MB in 8.20 seconds (84.34 MB/s)
>> > delete kernel-27 in 48.53 seconds
>> > create dir kernel-51614 222MB in 98.07 seconds (2.27 MB/s)
>> > clean kernel-14 691MB in 6.82 seconds (101.41 MB/s)
>> > delete kernel-64250 in 44.01 seconds
>> > stat dir kernel-2 in 26.37 seconds
>> > clean kernel-70151 691MB in 6.21 seconds (111.37 MB/s)
>> > delete kernel-14 in 41.74 seconds
>> > read dir kernel-2 in 122.71 7.50 MB/s
>> > create dir kernel-24150 222MB in 99.01 seconds (2.25 MB/s)
>> > read dir kernel-9 in 78.29 2.91 MB/s
>> > patch dir kernel-19 109MB in 77.45 seconds (1.42 MB/s)
>> > clean kernel-2 691MB in 5.94 seconds (116.43 MB/s)
>> > compile dir kernel-18 680MB in 49.17 seconds (13.84 MB/s)
>> > compile dir kernel-2 691MB in 47.20 seconds (14.65 MB/s)
>> > delete kernel-2 in 48.01 seconds
>> > delete kernel-70151 in 47.60 seconds
>> > stat dir kernel-1 in 21.80 seconds
>> > read dir kernel-18 in 109.98 8.21 MB/s
>> > clean kernel-18 680MB in 7.78 seconds (87.49 MB/s)
>> > compile dir kernel-17 680MB in 54.39 seconds (12.51 MB/s)
>> > read dir kernel-17 in 108.52 8.32 MB/s
>> > stat dir kernel-18 in 19.48 seconds
>> > stat dir kernel-64334 in 22.04 seconds
>> > delete kernel-24150 in 44.36 seconds
>> > delete kernel-17 in 49.09 seconds
>> > stat dir kernel-1 in 18.16 seconds
>> > compile dir kernel-7 691MB in 48.90 seconds (14.14 MB/s)
>> > patch dir kernel-16 109MB in 103.71 seconds (1.06 MB/s)
>> > stat dir kernel-7 in 21.94 seconds
>> > create dir kernel-82195 222MB in 110.82 seconds (2.01 MB/s)
>> > delete kernel-82195 in 38.64 seconds
>> > stat dir kernel-3 in 22.88 seconds
>> > patch dir kernel-2717 109MB in 92.23 seconds (1.19 MB/s)
>> > patch dir kernel-5 109MB in 64.95 seconds (1.69 MB/s)
>> > read dir kernel-2717 in 97.88 2.33 MB/s
>> > delete kernel-29 in 40.59 seconds
>> > clean kernel-7 691MB in 5.09 seconds (135.87 MB/s)
>> > read dir kernel-4 in 59.42 3.74 MB/s
>> > stat dir kernel-78184 in 20.24 seconds
>> > patch dir kernel-0 109MB in 95.95 seconds (1.14 MB/s)
>> > patch dir kernel-3 109MB in 62.86 seconds (1.74 MB/s)
>> > create dir kernel-30226 222MB in 106.81 seconds (2.08 MB/s)
>> > read dir kernel-19 in 81.32 2.81 MB/s
>> > read dir kernel-9 in 74.65 3.06 MB/s
>> > delete kernel-5 in 42.04 seconds
>> > read dir kernel-7 in 61.95 3.68 MB/s
>> > patch dir kernel-57327 109MB in 97.85 seconds (1.12 MB/s)
>> > read dir kernel-11 in 58.85 3.78 MB/s
>> >
>> > run complete:
>> > ==========================================================================
>> > intial create total runs 30 avg 2.42 MB/s (user 13.60s sys 36.18s)
>> > create total runs 14 avg 2.27 MB/s (user 13.66s sys 36.94s)
>> > patch total runs 15 avg 1.82 MB/s (user 6.62s sys 36.93s)
>> > compile total runs 14 avg 15.01 MB/s (user 2.76s sys 18.29s)
>> > clean total runs 10 avg 110.29 MB/s (user 0.46s sys 3.21s)
>> > read tree total runs 11 avg 3.29 MB/s (user 11.04s sys 28.65s)
>> > read compiled tree total runs 4 avg 8.60 MB/s (user 13.16s sys 41.32s)
>> > delete tree total runs 10 avg 41.44 seconds (user 6.43s sys 25.19s)
>> > delete compiled tree total runs 4 avg 47.81 seconds (user 7.18s sys
>> > 29.27s)
>> > stat tree total runs 11 avg 20.41 seconds (user 6.39s sys 7.45s)
>> > stat compiled tree total runs 7 avg 23.97 seconds (user 7.24s sys 8.74s)
>> >
>> > On Fri, 2012-11-16 at 17:51 +0800, zwu.kernel@gmail.com wrote:
>> >> From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
>> >>
>> >> HI, guys,
>> >>
>> >>   Any comments or ideas are appreciated, thanks.
>> >>
>> >> NOTE:
>> >>
>> >>   The patchset can be obtained via my kernel dev git on github:
>> >> git://github.com/wuzhy/kernel.git hot_tracking
>> >>   If you're interested, you can also review them via
>> >> https://github.com/wuzhy/kernel/commits/hot_tracking
>> >>
>> >>   For more info, please check hot_tracking.txt in Documentation
>> >>
>> >> TODO List:
>> >>
>> >>  1.) Need to do scalability or performance tests. - Required
>> >>  2.) Need one simpler but efficient temp calculation function
>> >>  3.) How to save the file temperature among the umount to be able to
>> >>      preserve the file tempreture after reboot - Optional
>> >>
>> >> Changelog:
>> >>
>> >>  - Solved 64 bits inode number issue. [David Sterba]
>> >>  - Embed struct hot_type in struct file_system_type [Darrick J. Wong]
>> >>  - Cleanup Some issues [David Sterba]
>> >>  - Use a static hot debugfs root [Greg KH]
>> >>  - Rewritten debugfs support based on seq_file operation. [Dave Chinner]
>> >>  - Refactored workqueue support. [Dave Chinner]
>> >>  - Turn some Micro into be tunable   [Zhiyong, Zheng Liu]
>> >>        TIME_TO_KICK, and HEAT_UPDATE_DELAY
>> >>  - Introduce hot func registering framework [Zhiyong]
>> >>  - Remove global variable for hot tracking [Zhiyong]
>> >>  - Add xfs hot tracking support [Dave Chinner]
>> >>  - Add ext4 hot tracking support [Zheng Liu]
>> >>  - Cleanedup a lot of other issues [Dave Chinner]
>> >>  - Added memory shrinker [Dave Chinner]
>> >>  - Converted to one workqueue to update map info periodically [Dave Chinner]
>> >>  - Cleanedup a lot of other issues [Dave Chinner]
>> >>  - Reduce new files and put all in fs/hot_tracking.[ch] [Dave Chinner]
>> >>  - Add btrfs hot tracking support [Zhiyong]
>> >>  - The first three patches can probably just be flattened into one.
>> >>                                         [Marco Stornelli , Dave Chinner]
>> >>
>> >> Zhi Yong Wu (16):
>> >>   vfs: introduce some data structures
>> >>   vfs: add init and cleanup functions
>> >>   vfs: add I/O frequency update function
>> >>   vfs: add two map arrays
>> >>   vfs: add hooks to enable hot tracking
>> >>   vfs: add temp calculation function
>> >>   vfs: add map info update function
>> >>   vfs: add aging function
>> >>   vfs: add one work queue
>> >>   vfs: add FS hot type support
>> >>   vfs: register one shrinker
>> >>   vfs: add one ioctl interface
>> >>   vfs: add debugfs support
>> >>   proc: add two hot_track proc files
>> >>   btrfs: add hot tracking support
>> >>   vfs: add documentation
>> >>
>> >>  Documentation/filesystems/00-INDEX         |    2 +
>> >>  Documentation/filesystems/hot_tracking.txt |  263 ++++++
>> >>  fs/Makefile                                |    2 +-
>> >>  fs/btrfs/ctree.h                           |    1 +
>> >>  fs/btrfs/super.c                           |   22 +-
>> >>  fs/compat_ioctl.c                          |    5 +
>> >>  fs/dcache.c                                |    2 +
>> >>  fs/direct-io.c                             |    6 +
>> >>  fs/hot_tracking.c                          | 1306 ++++++++++++++++++++++++++++
>> >>  fs/hot_tracking.h                          |   52 ++
>> >>  fs/ioctl.c                                 |   74 ++
>> >>  include/linux/fs.h                         |    5 +
>> >>  include/linux/hot_tracking.h               |  152 ++++
>> >>  kernel/sysctl.c                            |   14 +
>> >>  mm/filemap.c                               |    6 +
>> >>  mm/page-writeback.c                        |   12 +
>> >>  mm/readahead.c                             |    7 +
>> >>  17 files changed, 1929 insertions(+), 2 deletions(-)
>> >>  create mode 100644 Documentation/filesystems/hot_tracking.txt
>> >>  create mode 100644 fs/hot_tracking.c
>> >>  create mode 100644 fs/hot_tracking.h
>> >>  create mode 100644 include/linux/hot_tracking.h
>> >>
>> >
>> > --
>> > Regards,
>> >
>> > Zhi Yong Wu
>> >
>>
>>
>>
>> --
>> Regards,
>>
>> Zhi Yong Wu



-- 
Regards,

Zhi Yong Wu
