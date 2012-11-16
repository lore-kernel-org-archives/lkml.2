Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753642Ab2KPV00 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 16:26:26 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:58769 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753565Ab2KPV0Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 16:26:25 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Martin Steigerwald <Martin@lichtvoll.de>
Subject: Re: [PATCH 00/16 v3] f2fs: introduce flash-friendly file system
Date: Fri, 16 Nov 2012 21:26:13 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, Kim Jaegeuk <jaegeuk.kim@gmail.com>,
        Jaegeuk Kim <jaegeuk.kim@samsung.com>, linux-fsdevel@vger.kernel.org,
        gregkh@linuxfoundation.org, viro@zeniv.linux.org.uk, tytso@mit.edu,
        chur.lee@samsung.com, cm224.lee@samsung.com,
        jooyoung.hwang@samsung.com
References: <003d01cdb74b$0c3fa420$24beec60$%kim@samsung.com> <201211121657.03054.arnd@arndb.de> <201211141657.39475.Martin@lichtvoll.de>
In-Reply-To: <201211141657.39475.Martin@lichtvoll.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <201211162126.13940.arnd@arndb.de>
X-Provags-ID: V02:K0:zTmaK6xJC6eHCmyZ0UVVzhQ87GBXrFpCpvSMinMgF7Y
 BakV/F7znfaCUpJndnMQj2LlYAH1umgkgN0gVxufbTmcJfPtD2
 IAKdxc7mOMavHeqJkmJHg3whibfcPOpMpCNtQgvTmpwhUZvg95
 U2H5Oq9k1qhivNG21+vr+9TYA66qZm3zhclJUZwZW2z3cgT315
 xM6gZy1u345gBWHu/nqgcxHS2h1TBInZN228iqgGheyBTyC8+7
 kgTlwfyAjnbUdR7h1POIHJjDtb8zK62ho5mo+9gvEVL/svag9k
 vfs/ycvUvBfIVDW4ol0GkjbN5q5Qi4hQhgcIJDsmRgfBekxYWn
 528lB1uherKunDw5qwUQ=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 14 November 2012, Martin Steigerwald wrote:
> Am Montag, 12. November 2012 schrieb Arnd Bergmann:
> > On Monday 12 November 2012, Martin Steigerwald wrote:
> > > Am Samstag, 10. November 2012 schrieb Arnd Bergmann:

> > > Even when I apply the explaination of the README I do not seem to get a
> > > clear picture of the stick erase block size.
> > > 
> > > The values above seem to indicate to me: I don´t care about alignment at all.
> > 
> > I think it's more a case of a device where reading does not easily reveal
> > the erase block boundaries, because the variance between multiple reads
> > is much higher than between different positions. You can try again using
> > "--blocksize=1024 --count=100", which will increase the accuracy of the
> > test.
> > 
> > On the other hand, the device size of "4095999 512-byte logical blocks"
> > is quite suspicious, because it's not an even number, where it should
> > be a multiple of erase blocks. It is one less sector than 1000 2MB blocks
> > (or 500 4MB blocks, for that matter), but it's not clear if that one
> > block is missing at the start or at the end of the drive.
> 
> Just for this first flash drive, I think the erase block size if 4 MiB. The
> -a count=100/100 tests did not show any obvious results, but the 
> --open-au ones did, I think. I would use two open allocation units (AUs).
> 
> Maybe also 1 AU, cause 64 KiB sized accesses are faster that way?
> 
> Well I tend to use one AU. So that device would be more suitable for FAT
> than for BTRFS. Or more suitable for F2FS that is.
> 
> What do you think?
> 
> Only thing that seems to contradict this is the test with different
> alignments below.
> 
> 
> merkaba:~#254> /tmp/flashbench -a /dev/sdb --count=100

You should really pass "--blocksize=1024" here, which makes the results
much more accurate. Still, there are some devices where the -a test
doesn't give anything useful at all.

> align 536870912 pre 1.06ms      on 1.07ms       post 1.04ms     diff 14.6µs
> align 268435456 pre 1.09ms      on 1.1ms        post 1.09ms     diff 11.3µs
> align 134217728 pre 1.09ms      on 1.09ms       post 1.1ms      diff -87ns
> align 67108864  pre 1.05ms      on 1.06ms       post 1.03ms     diff 15.9µs
> align 33554432  pre 1.06ms      on 1.06ms       post 1.03ms     diff 18.7µs
> align 16777216  pre 1.05ms      on 1.05ms       post 1.03ms     diff 13.3µs
> align 8388608   pre 1.05ms      on 1.06ms       post 1.04ms     diff 9.03µs
> align 4194304   pre 1.06ms      on 1.06ms       post 1.04ms     diff 8.56µs
> align 2097152   pre 1.06ms      on 1.05ms       post 1.05ms     diff 2.02µs
> align 1048576   pre 1.05ms      on 1.04ms       post 1.06ms     diff -11524n
> align 524288    pre 1.05ms      on 1.05ms       post 1.04ms     diff 642ns
> align 262144    pre 1.04ms      on 1.04ms       post 1.04ms     diff -604ns
> align 131072    pre 1.03ms      on 1.04ms       post 1.04ms     diff 2.79µs
> align 65536     pre 1.04ms      on 1.05ms       post 1.05ms     diff 7.2µs
> align 32768     pre 1.05ms      on 1.05ms       post 1.05ms     diff -4475ns

This looks like a 4 MB size.

> merkaba:~> /tmp/flashbench -a /dev/sdb --count=1000
> align 536870912 pre 1.03ms      on 1.05ms       post 1.02ms     diff 20.3µs
> align 268435456 pre 1.06ms      on 1.05ms       post 1.04ms     diff 3.14µs
> align 134217728 pre 1.07ms      on 1.08ms       post 1.05ms     diff 16.1µs
> align 67108864  pre 1.03ms      on 1.03ms       post 1.02ms     diff 11µs
> align 33554432  pre 1.02ms      on 1.03ms       post 1.01ms     diff 10.3µs
> align 16777216  pre 1.03ms      on 1.04ms       post 1.02ms     diff 9.68µs
> align 8388608   pre 1.04ms      on 1.03ms       post 1.02ms     diff 6.45µs
> align 4194304   pre 1.03ms      on 1.04ms       post 1.02ms     diff 9.12µs
> align 2097152   pre 1.04ms      on 1.04ms       post 1.02ms     diff 15.4µs
> align 1048576   pre 1.03ms      on 1.03ms       post 1.03ms     diff -1590ns
> align 524288    pre 1.03ms      on 1.03ms       post 1.03ms     diff -835ns
> align 262144    pre 1.04ms      on 1.04ms       post 1.03ms     diff 1.25µs
> align 131072    pre 1.03ms      on 1.03ms       post 1.03ms     diff -3477ns
> align 65536     pre 1.03ms      on 1.03ms       post 1.03ms     diff 191ns
> align 32768     pre 1.03ms      on 1.04ms       post 1.03ms     diff 4.06µs

And this doesn't. I would guess 2 MB from the above.

> merkaba:~> /tmp/flashbench /dev/sdb --open-au --open-au-nr=2 --blocksize=4096 --erasesize=$[16*1024*1024]
> 16MiB   5.68M/s 
> 8MiB    4.3M/s  
> 4MiB    14.2M/s 
> 2MiB    13.1M/s 
> 1MiB    5.6M/s  
> 512KiB  3.35M/s 
> 256KiB  6.61M/s 
> 128KiB  4.19M/s 
> 64KiB   5.07M/s 
> 32KiB   2.16M/s 
> 16KiB   1.82M/s 
> 8KiB    1.24M/s 
> 4KiB    726K/s  
> merkaba:~> /tmp/flashbench /dev/sdb --open-au --open-au-nr=3 --blocksize=4096 --erasesize=$[16*1024*1024]
> 16MiB   7.18M/s 
> 8MiB    14.6M/s 
> 4MiB    14.1M/s 
> 2MiB    13M/s   
> 1MiB    6.39M/s 
> 512KiB  8.77M/s 
> 256KiB  6.13M/s 
> 128KiB  3.81M/s 
> 64KiB   2.37M/s 
> 32KiB   1.15M/s 
> 16KiB   648K/s  
> 8KiB    344K/s  
> 4KiB    180K/s  

This shows clearly how the device cannot handle more than 2 erase blocks, as you correctly
pointed out. I'm guessing that it does have a FAT optimized area in the front, so it should
work fine if you mount f2fs with just two active logs.

> But then I tried with offset and get:
> 
> > > > With the correct guess, compare the performance you get using
> > > > 
> > > > $ ERASESIZE=$[2*1024*1024] # replace with guess from flashbench -a
> > > > $ ./flashbench /dev/sdb --open-au --open-au-nr=1 --blocksize=4096 --erasesize=${ERASESIZE}
> > > > $ ./flashbench /dev/sdb --open-au --open-au-nr=3 --blocksize=4096 --erasesize=${ERASESIZE}
> > > > $ ./flashbench /dev/sdb --open-au --open-au-nr=5 --blocksize=4096 --erasesize=${ERASESIZE}
> > > > $ ./flashbench /dev/sdb --open-au --open-au-nr=7 --blocksize=4096 --erasesize=${ERASESIZE}
> > > > $ ./flashbench /dev/sdb --open-au --open-au-nr=13 --blocksize=4096 --erasesize=${ERASESIZE}
> > > 
> > > I omit this for now, cause I am not yet sure about the correct guess.
> > 
> > You can also try this test to find out the erase block size if the -a test fails.
> > Start with the largest possible value you'd expect (16 MB for a modern and fast
> > USB stick, less if it's older or smaller), and use --open-au-nr=1 to get a baseline:
> > 
> > ./flashbench /dev/sdb --open-au --open-au-nr=1 --blocksize=4096 --erasesize=$[16*1024*1024]
> > 
> > Every device should be able to handle this nicely with maximum throughput. The default is
> > to start the test at 16 MB into the device to get out of the way of a potential FAT
> > optimized area. You can change that offset to find where an erase block boundary is.
> > Adding '--offset=[24*1024*1024]' will still be fast if the erase block size is 8 MB,
> > but get slower and have more jitter if the size is actually 16 MB, because now we write
> > a 16 MB section of the drive with an 8 MB misalignment. The next ones to try after that
> > would be 20, 18, 17, 16.5, etc MB, to which will be slow for an 8,4, 2, an 1 MB erase
> > block size, respectively. You can also reduce the --erasesize argument there and do
> > 
> > ./flashbench /dev/sdb --open-au --open-au-nr=1 --blocksize=65536 --erasesize=[16*1024*1024 --offset=[24*1024*1024]
> > ./flashbench /dev/sdb --open-au --open-au-nr=1 --blocksize=65536 --erasesize=[8*1024*1024 --offset=[20*1024*1024]
> > ./flashbench /dev/sdb --open-au --open-au-nr=1 --blocksize=65536 --erasesize=[4*1024*1024 --offset=[18*1024*1024]
> > ./flashbench /dev/sdb --open-au --open-au-nr=1 --blocksize=65536 --erasesize=[2*1024*1024 --offset=[17*1024*1024]
> > ./flashbench /dev/sdb --open-au --open-au-nr=1 --blocksize=65536 --erasesize=[1*1024*1024 --offset=[33*512*1024]
> > 
> > If you have the result from the other test to figure out the maximum value for
> > '--open-au-nr=N', using that number here will make this test more reliable as well.
> 
> 
> 
> merkaba:~> /tmp/flashbench /dev/sdb --open-au --open-au-nr=1 --offset $[8*1024*1024] --erasesize=$[16*1024*1024]
> 16MiB   15.1M/s 
> 8MiB    3.45M/s 
> 4MiB    14M/s   
> 2MiB    13.1M/s 
> 1MiB    15.2M/s 
> 512KiB  3.31M/s 
> 256KiB  6.55M/s 
> 128KiB  4.18M/s 
> 64KiB   13.4M/s 
> 32KiB   2.14M/s 
> 16KiB   1.81M/s 
> merkaba:~> /tmp/flashbench /dev/sdb --open-au --open-au-nr=1 --offset $[1*1024*1024] --erasesize=$[4*1024*1024]
> 4MiB    14.1M/s 
> 2MiB    13M/s   
> 1MiB    14.9M/s 
> 512KiB  3.25M/s 
> 256KiB  6.56M/s 
> 128KiB  4.16M/s 
> 64KiB   13.4M/s 
> 32KiB   2.13M/s 
> 16KiB   1.81M/s 

As I mentioned, the beginning of the drive is likely different from the rest, and deals differently with
random I/O to optimize for the FAT file system. That's why I suggested using 17MB offset rather than 1MB.

> merkaba:~> /tmp/flashbench /dev/sdb --open-au --open-au-nr=1 --offset $[2*1024*1024] --erasesize=$[4*1024*1024]
> 4MiB    14M/s   
> 2MiB    13M/s   
> 1MiB    15.1M/s 
> 512KiB  3.25M/s 
> 256KiB  6.58M/s 
> 128KiB  4.18M/s 
> 64KiB   13.5M/s 
> 32KiB   2.13M/s 
> 16KiB   1.82M/s 
> 
> 
> So this does seem to me that the device quite likes 4 MiB sized, but doesn´t
> care too much about their alignment?

I think we can assume that any I/O over 1MB is fast within the first few MB of the device
based on these results.

> merkaba:~> /tmp/flashbench /dev/sdb --open-au --open-au-nr=1 --offset $[78*1024] --erasesize=$[4*1024*1024]
> 4MiB    14.2M/s 
> 2MiB    13.3M/s 
> 1MiB    15.1M/s 
> 512KiB  3.42M/s 
> 256KiB  6.6M/s  
> 128KiB  4.22M/s 
> 64KiB   13.5M/s 
> 32KiB   2.17M/s 
> 16KiB   1.84M/s 
> 
> Its seem thats a kinda special USB stick.

Having fast 64KB I/O is also quite common, but I agree that it's not obviously
showing the patterns that we expect for f2fs. Especially the 2 erase block limit
is problematic. If this is still the 2GB stick, it may be more helpful to play
with a different one that is larger. Many manufacturers have changed their
underlying technology between 2GB and 4GB (even more so in SD cards), and the
newer devices are more interesting because any small ones will soon be
gone from the market.

	Arnd
