Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932950Ab2KNP5p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 10:57:45 -0500
Received: from mondschein.lichtvoll.de ([194.150.191.11]:48369 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932713Ab2KNP5n convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 10:57:43 -0500
From: Martin Steigerwald <Martin@lichtvoll.de>
To: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 00/16 v3] f2fs: introduce flash-friendly file system
Date: Wed, 14 Nov 2012 16:57:39 +0100
User-Agent: KMail/1.13.7 (Linux/3.7.0-rc5-f2fs-tp520+; KDE/4.8.4; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, Kim Jaegeuk <jaegeuk.kim@gmail.com>,
        Jaegeuk Kim <jaegeuk.kim@samsung.com>, linux-fsdevel@vger.kernel.org,
        gregkh@linuxfoundation.org, viro@zeniv.linux.org.uk, tytso@mit.edu,
        chur.lee@samsung.com, cm224.lee@samsung.com,
        jooyoung.hwang@samsung.com
References: <003d01cdb74b$0c3fa420$24beec60$%kim@samsung.com> <201211121616.23616.Martin@lichtvoll.de> <201211121657.03054.arnd@arndb.de> (sfid-20121112_212249_443265_9B39A76A)
In-Reply-To: <201211121657.03054.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201211141657.39475.Martin@lichtvoll.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, 12. November 2012 schrieb Arnd Bergmann:
> On Monday 12 November 2012, Martin Steigerwald wrote:
> > Am Samstag, 10. November 2012 schrieb Arnd Bergmann:
> 
> > > I would also recommend using flashbench to find out the optimum parameters
> > > for your device. You can download it from
> > > git://git.linaro.org/people/arnd/flashbench.git
> > > In the long run, we should automate those tests and make them part of
> > > mkfs.f2fs, but for now, try to find out the erase block size and the number
> > > of concurrently used erase blocks on your device using a timing attack
> > > in flashbench. The README file in there explains how to interpret the
> > > results from "./flashbench -a /dev/sdb  --blocksize=1024" to guess
> > > the erase block size, although that sometimes doesn't work.
> > 
> > Why do I use a blocksize of 1024 if the kernel reports me 512 byte blocks?
> 
> The blocksize you pass here is the size of writes that flashbench sends to the
> kernel. Because of the algorithm used by flashbench, two hardware blocks
> is the smallest size you can use here, and larger block tend to be less reliable
> for this test case. I should probably change the default.
> 
> > [ 3112.144086] scsi9 : usb-storage 1-1.1:1.0
> > [ 3113.145968] scsi 9:0:0:0: Direct-Access     TinyDisk 2007-05-12       0.00 PQ: 0 ANSI: 2
> > [ 3113.146476] sd 9:0:0:0: Attached scsi generic sg2 type 0
> > [ 3113.147935] sd 9:0:0:0: [sdb] 4095999 512-byte logical blocks: (2.09 GB/1.95 GiB)
> > [ 3113.148935] sd 9:0:0:0: [sdb] Write Protect is off
> > 
> > 
> > And how do reads give information about erase block size? Wouldn´t writes me
> > more conclusive for that? (Having to erase one versus two erase blocks?)
> 
> The --open-au tests can be more reliable, but also take more time and are
> harder to understand. Using this test is faster and often gives an easy
> answer even without destroying data on the device.
> 
> 
> > Hmmm, I get very varying results here with said USB stick:
> > 
> > merkaba:~> /tmp/flashbench -a /dev/sdb
> > align 536870912 pre 1.1ms       on 1.1ms        post 1.08ms     diff 13µs
> > align 268435456 pre 1.2ms       on 1.19ms       post 1.16ms     diff 11.6µs
> > align 134217728 pre 1.12ms      on 1.14ms       post 1.15ms     diff 9.51µs
> > align 67108864  pre 1.12ms      on 1.15ms       post 1.12ms     diff 29.9µs
> > align 33554432  pre 1.11ms      on 1.17ms       post 1.13ms     diff 49µs
> > align 16777216  pre 1.14ms      on 1.16ms       post 1.15ms     diff 22.4µs
> > align 8388608   pre 1.12ms      on 1.09ms       post 1.06ms     diff -2053ns
> > align 4194304   pre 1.13ms      on 1.16ms       post 1.14ms     diff 21.7µs
> > align 2097152   pre 1.11ms      on 1.08ms       post 1.1ms      diff -18488n
> > align 1048576   pre 1.11ms      on 1.11ms       post 1.11ms     diff -2461ns
> > align 524288    pre 1.15ms      on 1.17ms       post 1.1ms      diff 45.4µs
> > align 262144    pre 1.11ms      on 1.13ms       post 1.13ms     diff 12µs
> > align 131072    pre 1.1ms       on 1.09ms       post 1.16ms     diff -38025n
> > align 65536     pre 1.09ms      on 1.08ms       post 1.11ms     diff -21353n
> > align 32768     pre 1.1ms       on 1.08ms       post 1.11ms     diff -23854n
> > merkaba:~> /tmp/flashbench -a /dev/sdb
> > align 536870912 pre 1.11ms      on 1.13ms       post 1.13ms     diff 10.6µs
> > align 268435456 pre 1.12ms      on 1.2ms        post 1.17ms     diff 61.4µs
> > align 134217728 pre 1.14ms      on 1.19ms       post 1.15ms     diff 46.8µs
> > align 67108864  pre 1.08ms      on 1.15ms       post 1.08ms     diff 63.8µs
> > align 33554432  pre 1.09ms      on 1.08ms       post 1.09ms     diff -4761ns
> > align 16777216  pre 1.12ms      on 1.14ms       post 1.07ms     diff 41.4µs
> > align 8388608   pre 1.1ms       on 1.1ms        post 1.09ms     diff 7.48µs
> > align 4194304   pre 1.08ms      on 1.1ms        post 1.1ms      diff 10.1µs
> > align 2097152   pre 1.1ms       on 1.11ms       post 1.1ms      diff 16µs
> > align 1048576   pre 1.09ms      on 1.1ms        post 1.07ms     diff 15.5µs
> > align 524288    pre 1.12ms      on 1.12ms       post 1.1ms      diff 11µs
> > align 262144    pre 1.13ms      on 1.13ms       post 1.1ms      diff 21.6µs
> > align 131072    pre 1.11ms      on 1.13ms       post 1.12ms     diff 17.9µs
> > align 65536     pre 1.07ms      on 1.1ms        post 1.1ms      diff 11.6µs
> > align 32768     pre 1.09ms      on 1.11ms       post 1.13ms     diff -5131ns
> > merkaba:~> /tmp/flashbench -a /dev/sdb
> > align 536870912 pre 1.2ms       on 1.18ms       post 1.21ms     diff -27496n
> > align 268435456 pre 1.22ms      on 1.21ms       post 1.24ms     diff -18972n
> > align 134217728 pre 1.15ms      on 1.19ms       post 1.14ms     diff 42.5µs
> > align 67108864  pre 1.08ms      on 1.09ms       post 1.08ms     diff 5.29µs
> > align 33554432  pre 1.18ms      on 1.19ms       post 1.18ms     diff 9.25µs
> > align 16777216  pre 1.18ms      on 1.22ms       post 1.17ms     diff 48.6µs
> > align 8388608   pre 1.14ms      on 1.17ms       post 1.19ms     diff 4.36µs
> > align 4194304   pre 1.16ms      on 1.2ms        post 1.11ms     diff 65.8µs
> > align 2097152   pre 1.13ms      on 1.09ms       post 1.12ms     diff -37718n
> > align 1048576   pre 1.15ms      on 1.2ms        post 1.18ms     diff 34.9µs
> > align 524288    pre 1.14ms      on 1.19ms       post 1.16ms     diff 41.5µs
> > align 262144    pre 1.19ms      on 1.12ms       post 1.15ms     diff -52725n
> > align 131072    pre 1.21ms      on 1.11ms       post 1.14ms     diff -68522n
> > align 65536     pre 1.21ms      on 1.13ms       post 1.18ms     diff -64248n
> > align 32768     pre 1.14ms      on 1.25ms       post 1.12ms     diff 116µs
> >
> > Even when I apply the explaination of the README I do not seem to get a
> > clear picture of the stick erase block size.
> > 
> > The values above seem to indicate to me: I don´t care about alignment at all.
> 
> I think it's more a case of a device where reading does not easily reveal
> the erase block boundaries, because the variance between multiple reads
> is much higher than between different positions. You can try again using
> "--blocksize=1024 --count=100", which will increase the accuracy of the
> test.
> 
> On the other hand, the device size of "4095999 512-byte logical blocks"
> is quite suspicious, because it's not an even number, where it should
> be a multiple of erase blocks. It is one less sector than 1000 2MB blocks
> (or 500 4MB blocks, for that matter), but it's not clear if that one
> block is missing at the start or at the end of the drive.

Just for this first flash drive, I think the erase block size if 4 MiB. The
-a count=100/100 tests did not show any obvious results, but the 
--open-au ones did, I think. I would use two open allocation units (AUs).

Maybe also 1 AU, cause 64 KiB sized accesses are faster that way?

Well I tend to use one AU. So that device would be more suitable for FAT
than for BTRFS. Or more suitable for F2FS that is.

What do you think?

Only thing that seems to contradict this is the test with different
alignments below.


merkaba:~#254> /tmp/flashbench -a /dev/sdb --count=100
align 536870912 pre 1.06ms      on 1.07ms       post 1.04ms     diff 14.6µs
align 268435456 pre 1.09ms      on 1.1ms        post 1.09ms     diff 11.3µs
align 134217728 pre 1.09ms      on 1.09ms       post 1.1ms      diff -87ns
align 67108864  pre 1.05ms      on 1.06ms       post 1.03ms     diff 15.9µs
align 33554432  pre 1.06ms      on 1.06ms       post 1.03ms     diff 18.7µs
align 16777216  pre 1.05ms      on 1.05ms       post 1.03ms     diff 13.3µs
align 8388608   pre 1.05ms      on 1.06ms       post 1.04ms     diff 9.03µs
align 4194304   pre 1.06ms      on 1.06ms       post 1.04ms     diff 8.56µs
align 2097152   pre 1.06ms      on 1.05ms       post 1.05ms     diff 2.02µs
align 1048576   pre 1.05ms      on 1.04ms       post 1.06ms     diff -11524n
align 524288    pre 1.05ms      on 1.05ms       post 1.04ms     diff 642ns
align 262144    pre 1.04ms      on 1.04ms       post 1.04ms     diff -604ns
align 131072    pre 1.03ms      on 1.04ms       post 1.04ms     diff 2.79µs
align 65536     pre 1.04ms      on 1.05ms       post 1.05ms     diff 7.2µs
align 32768     pre 1.05ms      on 1.05ms       post 1.05ms     diff -4475ns
merkaba:~> /tmp/flashbench -a /dev/sdb --count=1000
align 536870912 pre 1.03ms      on 1.05ms       post 1.02ms     diff 20.3µs
align 268435456 pre 1.06ms      on 1.05ms       post 1.04ms     diff 3.14µs
align 134217728 pre 1.07ms      on 1.08ms       post 1.05ms     diff 16.1µs
align 67108864  pre 1.03ms      on 1.03ms       post 1.02ms     diff 11µs
align 33554432  pre 1.02ms      on 1.03ms       post 1.01ms     diff 10.3µs
align 16777216  pre 1.03ms      on 1.04ms       post 1.02ms     diff 9.68µs
align 8388608   pre 1.04ms      on 1.03ms       post 1.02ms     diff 6.45µs
align 4194304   pre 1.03ms      on 1.04ms       post 1.02ms     diff 9.12µs
align 2097152   pre 1.04ms      on 1.04ms       post 1.02ms     diff 15.4µs
align 1048576   pre 1.03ms      on 1.03ms       post 1.03ms     diff -1590ns
align 524288    pre 1.03ms      on 1.03ms       post 1.03ms     diff -835ns
align 262144    pre 1.04ms      on 1.04ms       post 1.03ms     diff 1.25µs
align 131072    pre 1.03ms      on 1.03ms       post 1.03ms     diff -3477ns
align 65536     pre 1.03ms      on 1.03ms       post 1.03ms     diff 191ns
align 32768     pre 1.03ms      on 1.04ms       post 1.03ms     diff 4.06µs
merkaba:~> /tmp/flashbench /dev/sdb --open-au --open-au-nr=1 --blocksize=4096 --erasesize=$[16*1024*1024]
16MiB   15M/s   
8MiB    3.44M/s 
4MiB    13.9M/s 
2MiB    13M/s   
1MiB    15M/s   
512KiB  3.3M/s  
256KiB  6.55M/s 
128KiB  4.17M/s 
64KiB   13.5M/s 
32KiB   2.15M/s 
16KiB   1.83M/s 
8KiB    1.25M/s 
4KiB    731K/s  
merkaba:~> /tmp/flashbench /dev/sdb --open-au --open-au-nr=1 --blocksize=4096 --erasesize=$[8*1024*1024]
8MiB    14.6M/s 
4MiB    8.11M/s 
2MiB    12.5M/s 
1MiB    15.1M/s 
512KiB  3.29M/s 
256KiB  6.54M/s 
128KiB  4.16M/s 
64KiB   13.4M/s 
32KiB   2.14M/s 
16KiB   1.81M/s 
8KiB    1.23M/s 
4KiB    722K/s  
merkaba:~> /tmp/flashbench /dev/sdb --open-au --open-au-nr=1 --blocksize=4096 --erasesize=$[4*1024*1024]
4MiB    14M/s   
2MiB    13M/s   
1MiB    15M/s   
512KiB  3.26M/s 
256KiB  6.57M/s 
128KiB  4.2M/s  
64KiB   13.3M/s 
32KiB   2.13M/s 
16KiB   1.82M/s 
8KiB    1.24M/s 
4KiB    724K/s  
merkaba:~> /tmp/flashbench /dev/sdb --open-au --open-au-nr=1 --blocksize=4096 --erasesize=$[2*1024*1024]
2MiB    13.1M/s 
1MiB    15.2M/s 
512KiB  3.22M/s 
256KiB  6.57M/s 
128KiB  4.2M/s  
64KiB   13.3M/s 
32KiB   2.11M/s 
16KiB   1.82M/s 
8KiB    1.24M/s 
4KiB    725K/s  
merkaba:~> /tmp/flashbench /dev/sdb --open-au --open-au-nr=1 --blocksize=4096 --erasesize=$[2*1024*1024]
2MiB    13.1M/s 
1MiB    14.9M/s 
512KiB  3.21M/s 
256KiB  6.61M/s 
128KiB  4.19M/s 
64KiB   13.3M/s 
32KiB   2.11M/s 
16KiB   1.82M/s 
8KiB    1.23M/s 
4KiB    726K/s  
merkaba:~> /tmp/flashbench /dev/sdb --open-au --open-au-nr=1 --blocksize=4096 --erasesize=$[1*1024*1024]
1MiB    14.9M/s 
512KiB  3.12M/s 
256KiB  6.64M/s 
128KiB  4.2M/s  
64KiB   13.4M/s 
32KiB   2.07M/s 
16KiB   1.82M/s 
8KiB    1.24M/s 
4KiB    725K/s  
merkaba:~> /tmp/flashbench /dev/sdb --open-au --open-au-nr=2 --blocksize=4096 --erasesize=$[4*1024*1024]
4MiB    14.2M/s 
2MiB    13.1M/s 
1MiB    5.58M/s 
512KiB  3.43M/s 
256KiB  6.58M/s 
128KiB  4.18M/s 
64KiB   5.06M/s 
32KiB   2.14M/s 
16KiB   1.82M/s 
8KiB    1.24M/s 
4KiB    724K/s  
merkaba:~> /tmp/flashbench /dev/sdb --open-au --open-au-nr=2 --blocksize=4096 --erasesize=$[16*1024*1024]
16MiB   5.68M/s 
8MiB    4.3M/s  
4MiB    14.2M/s 
2MiB    13.1M/s 
1MiB    5.6M/s  
512KiB  3.35M/s 
256KiB  6.61M/s 
128KiB  4.19M/s 
64KiB   5.07M/s 
32KiB   2.16M/s 
16KiB   1.82M/s 
8KiB    1.24M/s 
4KiB    726K/s  
merkaba:~> /tmp/flashbench /dev/sdb --open-au --open-au-nr=3 --blocksize=4096 --erasesize=$[16*1024*1024]
16MiB   7.18M/s 
8MiB    14.6M/s 
4MiB    14.1M/s 
2MiB    13M/s   
1MiB    6.39M/s 
512KiB  8.77M/s 
256KiB  6.13M/s 
128KiB  3.81M/s 
64KiB   2.37M/s 
32KiB   1.15M/s 
16KiB   648K/s  
8KiB    344K/s  
4KiB    180K/s  
merkaba:~> /tmp/flashbench /dev/sdb --open-au --open-au-nr=1 --blocksize=4096 --erasesize=$[16*1024*1024]
16MiB   15.3M/s 
8MiB    3.48M/s 
4MiB    14.3M/s 
2MiB    13.2M/s 
1MiB    15.2M/s 
512KiB  3.33M/s 
256KiB  6.64M/s 
128KiB  4.2M/s  
64KiB   13.6M/s 
32KiB   2.15M/s 
16KiB   1.83M/s 
8KiB    1.24M/s 
4KiB    727K/s  
merkaba:~> /tmp/flashbench /dev/sdb --open-au --open-au-nr=2 --blocksize=4096 --erasesize=$[16*1024*1024]
16MiB   5.72M/s 
8MiB    4.33M/s 
4MiB    14.3M/s 
2MiB    13.3M/s 
1MiB    5.66M/s 
512KiB  3.38M/s 
256KiB  6.68M/s 
128KiB  4.24M/s 
64KiB   5.12M/s 
32KiB   2.17M/s 
16KiB   1.83M/s 
8KiB    1.24M/s 
4KiB    729K/s  
merkaba:~> /tmp/flashbench /dev/sdb --open-au --open-au-nr=1 --blocksize=4096 --erasesize=$[4*1024*1024]
4MiB    14M/s   
2MiB    13.3M/s 
1MiB    15.3M/s 
512KiB  3.29M/s 
256KiB  6.68M/s 
128KiB  4.22M/s 
64KiB   13.7M/s 
32KiB   2.15M/s 
16KiB   1.83M/s 
8KiB    1.24M/s 
4KiB    729K/s  
merkaba:~> /tmp/flashbench /dev/sdb --open-au --open-au-nr=2 --blocksize=4096 --erasesize=$[4*1024*1024]
4MiB    14.1M/s 
2MiB    13.1M/s 
1MiB    5.62M/s 
512KiB  3.43M/s 
256KiB  6.63M/s 
128KiB  4.2M/s  
64KiB   5.11M/s 
32KiB   2.15M/s 
16KiB   1.82M/s 
8KiB    1.24M/s 
4KiB    727K/s 

merkaba:~#130> /tmp/flashbench /dev/sdb --open-au --open-au-nr=1 --blocksize=65536 --erasesize=$[16*1024*1024]
16MiB   15.2M/s 
8MiB    3.46M/s 
4MiB    14.2M/s 
2MiB    13.1M/s 
1MiB    15.1M/s 
512KiB  3.31M/s 
256KiB  6.59M/s 
128KiB  4.19M/s 
64KiB   13.5M/s 
merkaba:~> /tmp/flashbench /dev/sdb --open-au --open-au-nr=2 --blocksize=65536 --erasesize=$[16*1024*1024]
16MiB   5.68M/s 
8MiB    4.31M/s 
4MiB    14.2M/s 
2MiB    13.2M/s 
1MiB    5.62M/s 
512KiB  3.36M/s 
256KiB  6.63M/s 
128KiB  4.21M/s 
64KiB   5.09M/s 


But then I tried with offset and get:

> > > With the correct guess, compare the performance you get using
> > > 
> > > $ ERASESIZE=$[2*1024*1024] # replace with guess from flashbench -a
> > > $ ./flashbench /dev/sdb --open-au --open-au-nr=1 --blocksize=4096 --erasesize=${ERASESIZE}
> > > $ ./flashbench /dev/sdb --open-au --open-au-nr=3 --blocksize=4096 --erasesize=${ERASESIZE}
> > > $ ./flashbench /dev/sdb --open-au --open-au-nr=5 --blocksize=4096 --erasesize=${ERASESIZE}
> > > $ ./flashbench /dev/sdb --open-au --open-au-nr=7 --blocksize=4096 --erasesize=${ERASESIZE}
> > > $ ./flashbench /dev/sdb --open-au --open-au-nr=13 --blocksize=4096 --erasesize=${ERASESIZE}
> > 
> > I omit this for now, cause I am not yet sure about the correct guess.
> 
> You can also try this test to find out the erase block size if the -a test fails.
> Start with the largest possible value you'd expect (16 MB for a modern and fast
> USB stick, less if it's older or smaller), and use --open-au-nr=1 to get a baseline:
> 
> ./flashbench /dev/sdb --open-au --open-au-nr=1 --blocksize=4096 --erasesize=$[16*1024*1024]
> 
> Every device should be able to handle this nicely with maximum throughput. The default is
> to start the test at 16 MB into the device to get out of the way of a potential FAT
> optimized area. You can change that offset to find where an erase block boundary is.
> Adding '--offset=[24*1024*1024]' will still be fast if the erase block size is 8 MB,
> but get slower and have more jitter if the size is actually 16 MB, because now we write
> a 16 MB section of the drive with an 8 MB misalignment. The next ones to try after that
> would be 20, 18, 17, 16.5, etc MB, to which will be slow for an 8,4, 2, an 1 MB erase
> block size, respectively. You can also reduce the --erasesize argument there and do
> 
> ./flashbench /dev/sdb --open-au --open-au-nr=1 --blocksize=65536 --erasesize=[16*1024*1024 --offset=[24*1024*1024]
> ./flashbench /dev/sdb --open-au --open-au-nr=1 --blocksize=65536 --erasesize=[8*1024*1024 --offset=[20*1024*1024]
> ./flashbench /dev/sdb --open-au --open-au-nr=1 --blocksize=65536 --erasesize=[4*1024*1024 --offset=[18*1024*1024]
> ./flashbench /dev/sdb --open-au --open-au-nr=1 --blocksize=65536 --erasesize=[2*1024*1024 --offset=[17*1024*1024]
> ./flashbench /dev/sdb --open-au --open-au-nr=1 --blocksize=65536 --erasesize=[1*1024*1024 --offset=[33*512*1024]
> 
> If you have the result from the other test to figure out the maximum value for
> '--open-au-nr=N', using that number here will make this test more reliable as well.



merkaba:~> /tmp/flashbench /dev/sdb --open-au --open-au-nr=1 --offset $[8*1024*1024] --erasesize=$[16*1024*1024]
16MiB   15.1M/s 
8MiB    3.45M/s 
4MiB    14M/s   
2MiB    13.1M/s 
1MiB    15.2M/s 
512KiB  3.31M/s 
256KiB  6.55M/s 
128KiB  4.18M/s 
64KiB   13.4M/s 
32KiB   2.14M/s 
16KiB   1.81M/s 
merkaba:~> /tmp/flashbench /dev/sdb --open-au --open-au-nr=1 --offset $[1*1024*1024] --erasesize=$[4*1024*1024]
4MiB    14.1M/s 
2MiB    13M/s   
1MiB    14.9M/s 
512KiB  3.25M/s 
256KiB  6.56M/s 
128KiB  4.16M/s 
64KiB   13.4M/s 
32KiB   2.13M/s 
16KiB   1.81M/s 
merkaba:~> /tmp/flashbench /dev/sdb --open-au --open-au-nr=1 --offset $[2*1024*1024] --erasesize=$[4*1024*1024]
4MiB    14M/s   
2MiB    13M/s   
1MiB    15.1M/s 
512KiB  3.25M/s 
256KiB  6.58M/s 
128KiB  4.18M/s 
64KiB   13.5M/s 
32KiB   2.13M/s 
16KiB   1.82M/s 


So this does seem to me that the device quite likes 4 MiB sized, but doesn´t
care too much about their alignment?

merkaba:~> /tmp/flashbench /dev/sdb --open-au --open-au-nr=1 --offset $[78*1024] --erasesize=$[4*1024*1024]
4MiB    14.2M/s 
2MiB    13.3M/s 
1MiB    15.1M/s 
512KiB  3.42M/s 
256KiB  6.6M/s  
128KiB  4.22M/s 
64KiB   13.5M/s 
32KiB   2.17M/s 
16KiB   1.84M/s 


Its seem thats a kinda special USB stick.

Thanks,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
