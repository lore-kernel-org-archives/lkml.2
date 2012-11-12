Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753671Ab2KLQ5P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 11:57:15 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:64442 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750832Ab2KLQ5N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 11:57:13 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Martin Steigerwald <Martin@lichtvoll.de>
Subject: Re: [PATCH 00/16 v3] f2fs: introduce flash-friendly file system
Date: Mon, 12 Nov 2012 16:57:02 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, Kim Jaegeuk <jaegeuk.kim@gmail.com>,
        Jaegeuk Kim <jaegeuk.kim@samsung.com>, linux-fsdevel@vger.kernel.org,
        gregkh@linuxfoundation.org, viro@zeniv.linux.org.uk, tytso@mit.edu,
        chur.lee@samsung.com, cm224.lee@samsung.com,
        jooyoung.hwang@samsung.com
References: <003d01cdb74b$0c3fa420$24beec60$%kim@samsung.com> <201211102149.48946.arnd@arndb.de> <201211121616.23616.Martin@lichtvoll.de>
In-Reply-To: <201211121616.23616.Martin@lichtvoll.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <201211121657.03054.arnd@arndb.de>
X-Provags-ID: V02:K0:fCcrgoaojO8yFvINBt45894F4btOVAz2/chlObprc4w
 P262+5YUg9TW69zYQQhTcTILsODPNPDRC5ToBgQWdRNJ6KsgKd
 ngmYCM73NxBg6CmgY7Hu2qP1FLpOUJfgVXAdpik7z1RQQHHlV/
 vmNCH0hk51CFZsGZ1G8rGNsLz2nRVP8UhzLj3paLG3xigSTTC/
 k6E39Gr0Nkz77fCyeaY7xVpCTG7wslxVZzOsC/KEdd/j++Cx0K
 MhyIsiRoZdm/bhNgz4dKZvm4W0trRekCDQpZS0/Jz0htGvMPwu
 7WQOItwXvzNYyXBskwdInjeyGIH99lFu0gni4GLPJZrd2gMHdy
 Fse41FtTHFAlOeRpgnrM=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 12 November 2012, Martin Steigerwald wrote:
> Am Samstag, 10. November 2012 schrieb Arnd Bergmann:

> > I would also recommend using flashbench to find out the optimum parameters
> > for your device. You can download it from
> > git://git.linaro.org/people/arnd/flashbench.git
> > In the long run, we should automate those tests and make them part of
> > mkfs.f2fs, but for now, try to find out the erase block size and the number
> > of concurrently used erase blocks on your device using a timing attack
> > in flashbench. The README file in there explains how to interpret the
> > results from "./flashbench -a /dev/sdb  --blocksize=1024" to guess
> > the erase block size, although that sometimes doesn't work.
> 
> Why do I use a blocksize of 1024 if the kernel reports me 512 byte blocks?

The blocksize you pass here is the size of writes that flashbench sends to the
kernel. Because of the algorithm used by flashbench, two hardware blocks
is the smallest size you can use here, and larger block tend to be less reliable
for this test case. I should probably change the default.

> [ 3112.144086] scsi9 : usb-storage 1-1.1:1.0
> [ 3113.145968] scsi 9:0:0:0: Direct-Access     TinyDisk 2007-05-12       0.00 PQ: 0 ANSI: 2
> [ 3113.146476] sd 9:0:0:0: Attached scsi generic sg2 type 0
> [ 3113.147935] sd 9:0:0:0: [sdb] 4095999 512-byte logical blocks: (2.09 GB/1.95 GiB)
> [ 3113.148935] sd 9:0:0:0: [sdb] Write Protect is off
> 
> 
> And how do reads give information about erase block size? Wouldn´t writes me
> more conclusive for that? (Having to erase one versus two erase blocks?)

The --open-au tests can be more reliable, but also take more time and are
harder to understand. Using this test is faster and often gives an easy
answer even without destroying data on the device.


> Hmmm, I get very varying results here with said USB stick:
> 
> merkaba:~> /tmp/flashbench -a /dev/sdb
> align 536870912 pre 1.1ms       on 1.1ms        post 1.08ms     diff 13µs
> align 268435456 pre 1.2ms       on 1.19ms       post 1.16ms     diff 11.6µs
> align 134217728 pre 1.12ms      on 1.14ms       post 1.15ms     diff 9.51µs
> align 67108864  pre 1.12ms      on 1.15ms       post 1.12ms     diff 29.9µs
> align 33554432  pre 1.11ms      on 1.17ms       post 1.13ms     diff 49µs
> align 16777216  pre 1.14ms      on 1.16ms       post 1.15ms     diff 22.4µs
> align 8388608   pre 1.12ms      on 1.09ms       post 1.06ms     diff -2053ns
> align 4194304   pre 1.13ms      on 1.16ms       post 1.14ms     diff 21.7µs
> align 2097152   pre 1.11ms      on 1.08ms       post 1.1ms      diff -18488n
> align 1048576   pre 1.11ms      on 1.11ms       post 1.11ms     diff -2461ns
> align 524288    pre 1.15ms      on 1.17ms       post 1.1ms      diff 45.4µs
> align 262144    pre 1.11ms      on 1.13ms       post 1.13ms     diff 12µs
> align 131072    pre 1.1ms       on 1.09ms       post 1.16ms     diff -38025n
> align 65536     pre 1.09ms      on 1.08ms       post 1.11ms     diff -21353n
> align 32768     pre 1.1ms       on 1.08ms       post 1.11ms     diff -23854n
> merkaba:~> /tmp/flashbench -a /dev/sdb
> align 536870912 pre 1.11ms      on 1.13ms       post 1.13ms     diff 10.6µs
> align 268435456 pre 1.12ms      on 1.2ms        post 1.17ms     diff 61.4µs
> align 134217728 pre 1.14ms      on 1.19ms       post 1.15ms     diff 46.8µs
> align 67108864  pre 1.08ms      on 1.15ms       post 1.08ms     diff 63.8µs
> align 33554432  pre 1.09ms      on 1.08ms       post 1.09ms     diff -4761ns
> align 16777216  pre 1.12ms      on 1.14ms       post 1.07ms     diff 41.4µs
> align 8388608   pre 1.1ms       on 1.1ms        post 1.09ms     diff 7.48µs
> align 4194304   pre 1.08ms      on 1.1ms        post 1.1ms      diff 10.1µs
> align 2097152   pre 1.1ms       on 1.11ms       post 1.1ms      diff 16µs
> align 1048576   pre 1.09ms      on 1.1ms        post 1.07ms     diff 15.5µs
> align 524288    pre 1.12ms      on 1.12ms       post 1.1ms      diff 11µs
> align 262144    pre 1.13ms      on 1.13ms       post 1.1ms      diff 21.6µs
> align 131072    pre 1.11ms      on 1.13ms       post 1.12ms     diff 17.9µs
> align 65536     pre 1.07ms      on 1.1ms        post 1.1ms      diff 11.6µs
> align 32768     pre 1.09ms      on 1.11ms       post 1.13ms     diff -5131ns
> merkaba:~> /tmp/flashbench -a /dev/sdb
> align 536870912 pre 1.2ms       on 1.18ms       post 1.21ms     diff -27496n
> align 268435456 pre 1.22ms      on 1.21ms       post 1.24ms     diff -18972n
> align 134217728 pre 1.15ms      on 1.19ms       post 1.14ms     diff 42.5µs
> align 67108864  pre 1.08ms      on 1.09ms       post 1.08ms     diff 5.29µs
> align 33554432  pre 1.18ms      on 1.19ms       post 1.18ms     diff 9.25µs
> align 16777216  pre 1.18ms      on 1.22ms       post 1.17ms     diff 48.6µs
> align 8388608   pre 1.14ms      on 1.17ms       post 1.19ms     diff 4.36µs
> align 4194304   pre 1.16ms      on 1.2ms        post 1.11ms     diff 65.8µs
> align 2097152   pre 1.13ms      on 1.09ms       post 1.12ms     diff -37718n
> align 1048576   pre 1.15ms      on 1.2ms        post 1.18ms     diff 34.9µs
> align 524288    pre 1.14ms      on 1.19ms       post 1.16ms     diff 41.5µs
> align 262144    pre 1.19ms      on 1.12ms       post 1.15ms     diff -52725n
> align 131072    pre 1.21ms      on 1.11ms       post 1.14ms     diff -68522n
> align 65536     pre 1.21ms      on 1.13ms       post 1.18ms     diff -64248n
> align 32768     pre 1.14ms      on 1.25ms       post 1.12ms     diff 116µs
>
> Even when I apply the explaination of the README I do not seem to get a
> clear picture of the stick erase block size.
> 
> The values above seem to indicate to me: I don´t care about alignment at all.

I think it's more a case of a device where reading does not easily reveal
the erase block boundaries, because the variance between multiple reads
is much higher than between different positions. You can try again using
"--blocksize=1024 --count=100", which will increase the accuracy of the
test.

On the other hand, the device size of "4095999 512-byte logical blocks"
is quite suspicious, because it's not an even number, where it should
be a multiple of erase blocks. It is one less sector than 1000 2MB blocks
(or 500 4MB blocks, for that matter), but it's not clear if that one
block is missing at the start or at the end of the drive.

> With another flash, likely slower Intenso 4GB stick I get:
> 
> [ 3672.512143] scsi 10:0:0:0: Direct-Access     Ut165    USB2FlashStorage 0.00 PQ: 0 ANSI: 2
> [ 3672.514469] sd 10:0:0:0: Attached scsi generic sg2 type 0
> [ 3672.514991] sd 10:0:0:0: [sdb] 7897088 512-byte logical blocks: (4.04 GB/3.76 GiB)
> […]

$ factor 7897088
7897088: 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 241

Slightly more helpful, this one has 241 32MB-blocks, so at least we know that the
erase block size is not larger than 32MB (which would be very unlikely anyway)
and not a multiple of 3.

> align 16777216  pre 939µs       on 903µs        post 880µs      diff -5972ns
> align 8388608   pre 900µs       on 914µs        post 923µs      diff 2.42µs
> align 4194304   pre 894µs       on 886µs        post 882µs      diff -1563ns
> 
> here?
> 
> align 2097152   pre 829µs       on 890µs        post 874µs      diff 37.8µs
> align 1048576   pre 899µs       on 882µs        post 843µs      diff 11.1µs
> align 524288    pre 890µs       on 887µs        post 902µs      diff -9005ns
> align 262144    pre 887µs       on 887µs        post 898µs      diff -5474ns
> align 131072    pre 928µs       on 895µs        post 914µs      diff -26028n
> align 65536     pre 898µs       on 898µs        post 894µs      diff 2.59µs
> align 32768     pre 884µs       on 891µs        post 901µs      diff -1284ns
> 
> 
> Similar picture. The diffs seem to be mostly quite small with only some
> micro seconds. Or am I misreading something?

Same thing, try again with the options I listed above.

> Then with a quite fast one 16 GB Transcend.
> 
> [ 4055.393399] sd 11:0:0:0: Attached scsi generic sg2 type 0
> [ 4055.394729] sd 11:0:0:0: [sdb] 31375360 512-byte logical blocks: (16.0 GB/14.9 GiB)
> [ 4055.395262] sd 11:0:0:0: [sdb] Write Protect is off

$ factor  31375360
31375360: 2 2 2 2 2 2 2 2 2 2 2 2 2 2 5 383

That would be 5*383*16MB, so the erase block size will be a fraction of 16MB.
 
> merkaba:~> /tmp/flashbench -a /dev/sdb
> align 4294967296        pre 1.28ms      on 1.48ms       post 1.33ms     diff 179µs
> align 2147483648        pre 1.32ms      on 1.51ms       post 1.33ms     diff 181µs
> align 1073741824        pre 1.31ms      on 1.46ms       post 1.35ms     diff 132µs
> align 536870912 pre 1.27ms      on 1.52ms       post 1.33ms     diff 228µs
> align 268435456 pre 1.28ms      on 1.46ms       post 1.31ms     diff 161µs
> align 134217728 pre 1.28ms      on 1.44ms       post 1.37ms     diff 120µs
> align 67108864  pre 1.27ms      on 1.44ms       post 1.34ms     diff 133µs
> align 33554432  pre 1.24ms      on 1.42ms       post 1.31ms     diff 150µs
> align 16777216  pre 1.23ms      on 1.46ms       post 1.26ms     diff 218µs
> align 8388608   pre 1.31ms      on 1.5ms        post 1.33ms     diff 180µs
> align 4194304   pre 1.27ms      on 1.45ms       post 1.36ms     diff 135µs
> align 2097152   pre 1.29ms      on 1.37ms       post 1.39ms     diff 33.7µs
> 
> here?
> 
> align 1048576   pre 1.31ms      on 1.44ms       post 1.35ms     diff 115µs
> align 524288    pre 1.33ms      on 1.39ms       post 1.48ms     diff -12297n
> align 262144    pre 1.36ms      on 1.42ms       post 1.4ms      diff 45.6µs
> align 131072    pre 1.37ms      on 1.44ms       post 1.4ms      diff 57.7µs
> align 65536     pre 1.36ms      on 1.35ms       post 1.33ms     diff 4.67µs
> align 32768     pre 1.32ms      on 1.38ms       post 1.34ms     diff 44.1µs
> merkaba:~> /tmp/flashbench -a /dev/sdb
> align 4294967296        pre 1.36ms      on 1.49ms       post 1.34ms     diff 139µs
> align 2147483648        pre 1.26ms      on 1.48ms       post 1.27ms     diff 213µs
> align 1073741824        pre 1.26ms      on 1.45ms       post 1.33ms     diff 164µs
> align 536870912 pre 1.22ms      on 1.46ms       post 1.35ms     diff 173µs
> align 268435456 pre 1.34ms      on 1.5ms        post 1.31ms     diff 172µs
> align 134217728 pre 1.34ms      on 1.48ms       post 1.31ms     diff 157µs
> align 67108864  pre 1.29ms      on 1.46ms       post 1.34ms     diff 142µs
> align 33554432  pre 1.28ms      on 1.47ms       post 1.31ms     diff 173µs
> align 16777216  pre 1.26ms      on 1.48ms       post 1.37ms     diff 168µs
> align 8388608   pre 1.31ms      on 1.47ms       post 1.36ms     diff 139µs
> align 4194304   pre 1.26ms      on 1.53ms       post 1.33ms     diff 237µs
> align 2097152   pre 1.34ms      on 1.4ms        post 1.36ms     diff 56.4µs
> align 1048576   pre 1.32ms      on 1.35ms       post 1.37ms     diff 638ns
> 
> here?
> 
> align 524288    pre 1.29ms      on 1.47ms       post 1.45ms     diff 98.1µs
> align 262144    pre 1.35ms      on 1.38ms       post 1.42ms     diff -11916n
> align 131072    pre 1.32ms      on 1.46ms       post 1.4ms      diff 100µs
> align 65536     pre 1.35ms      on 1.42ms       post 1.43ms     diff 30.8µs
> align 32768     pre 1.31ms      on 1.37ms       post 1.33ms     diff 51µs
> merkaba:~> /tmp/flashbench -a /dev/sdb
> align 4294967296        pre 1.26ms      on 1.49ms       post 1.27ms     diff 222µs
> align 2147483648        pre 1.25ms      on 1.41ms       post 1.37ms     diff 97.3µs
> align 1073741824        pre 1.26ms      on 1.47ms       post 1.31ms     diff 186µs
> align 536870912 pre 1.25ms      on 1.42ms       post 1.32ms     diff 132µs
> align 268435456 pre 1.2ms       on 1.44ms       post 1.29ms     diff 195µs
> align 134217728 pre 1.27ms      on 1.43ms       post 1.34ms     diff 118µs
> align 67108864  pre 1.25ms      on 1.45ms       post 1.31ms     diff 165µs
> align 33554432  pre 1.22ms      on 1.36ms       post 1.25ms     diff 124µs
> align 16777216  pre 1.24ms      on 1.44ms       post 1.26ms     diff 191µs
> align 8388608   pre 1.22ms      on 1.39ms       post 1.23ms     diff 164µs
> align 4194304   pre 1.23ms      on 1.43ms       post 1.3ms      diff 171µs
> align 2097152   pre 1.26ms      on 1.3ms        post 1.32ms     diff 16.7µs
> align 1048576   pre 1.26ms      on 1.27ms       post 1.26ms     diff 7.91µs
> 
> here?
> 
> align 524288    pre 1.24ms      on 1.3ms        post 1.3ms      diff 29.2µs
> align 262144    pre 1.25ms      on 1.3ms        post 1.28ms     diff 28.2µs
> align 131072    pre 1.25ms      on 1.29ms       post 1.28ms     diff 24.8µs
> align 65536     pre 1.15ms      on 1.24ms       post 1.26ms     diff 34.5µs
> align 32768     pre 1.17ms      on 1.3ms        post 1.26ms     diff 82.6µs

This one is fairly deterministic, and I would assume it's 4MB, which always
has a much higher number in the last column than the 2MB one.
For a fast 16 GB stick, I also wouldn't expect smaller than 4 MB erase blocks.

> Thing is that me here is not always at the same place :)

If you add a '--count=N' argument, you can have flashbench run the test more
often and average between the runs. The default is 8.

> > With the correct guess, compare the performance you get using
> > 
> > $ ERASESIZE=$[2*1024*1024] # replace with guess from flashbench -a
> > $ ./flashbench /dev/sdb --open-au --open-au-nr=1 --blocksize=4096 --erasesize=${ERASESIZE}
> > $ ./flashbench /dev/sdb --open-au --open-au-nr=3 --blocksize=4096 --erasesize=${ERASESIZE}
> > $ ./flashbench /dev/sdb --open-au --open-au-nr=5 --blocksize=4096 --erasesize=${ERASESIZE}
> > $ ./flashbench /dev/sdb --open-au --open-au-nr=7 --blocksize=4096 --erasesize=${ERASESIZE}
> > $ ./flashbench /dev/sdb --open-au --open-au-nr=13 --blocksize=4096 --erasesize=${ERASESIZE}
> 
> I omit this for now, cause I am not yet sure about the correct guess.

You can also try this test to find out the erase block size if the -a test fails.
Start with the largest possible value you'd expect (16 MB for a modern and fast
USB stick, less if it's older or smaller), and use --open-au-nr=1 to get a baseline:

./flashbench /dev/sdb --open-au --open-au-nr=1 --blocksize=4096 --erasesize=$[16*1024*1024]

Every device should be able to handle this nicely with maximum throughput. The default is
to start the test at 16 MB into the device to get out of the way of a potential FAT
optimized area. You can change that offset to find where an erase block boundary is.
Adding '--offset=[24*1024*1024]' will still be fast if the erase block size is 8 MB,
but get slower and have more jitter if the size is actually 16 MB, because now we write
a 16 MB section of the drive with an 8 MB misalignment. The next ones to try after that
would be 20, 18, 17, 16.5, etc MB, to which will be slow for an 8,4, 2, an 1 MB erase
block size, respectively. You can also reduce the --erasesize argument there and do

./flashbench /dev/sdb --open-au --open-au-nr=1 --blocksize=65536 --erasesize=[16*1024*1024 --offset=[24*1024*1024]
./flashbench /dev/sdb --open-au --open-au-nr=1 --blocksize=65536 --erasesize=[8*1024*1024 --offset=[20*1024*1024]
./flashbench /dev/sdb --open-au --open-au-nr=1 --blocksize=65536 --erasesize=[4*1024*1024 --offset=[18*1024*1024]
./flashbench /dev/sdb --open-au --open-au-nr=1 --blocksize=65536 --erasesize=[2*1024*1024 --offset=[17*1024*1024]
./flashbench /dev/sdb --open-au --open-au-nr=1 --blocksize=65536 --erasesize=[1*1024*1024 --offset=[33*512*1024]

If you have the result from the other test to figure out the maximum value for
'--open-au-nr=N', using that number here will make this test more reliable as well.

	Arnd
