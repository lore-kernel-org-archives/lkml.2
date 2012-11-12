Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753230Ab2KLPQ1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 10:16:27 -0500
Received: from mondschein.lichtvoll.de ([194.150.191.11]:35238 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751459Ab2KLPQZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 10:16:25 -0500
From: Martin Steigerwald <Martin@lichtvoll.de>
To: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 00/16 v3] f2fs: introduce flash-friendly file system
Date: Mon, 12 Nov 2012 16:16:23 +0100
User-Agent: KMail/1.13.7 (Linux/3.7.0-rc5-f2fs-usb-hcd-nothread-tp520+; KDE/4.8.4; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, Kim Jaegeuk <jaegeuk.kim@gmail.com>,
        Jaegeuk Kim <jaegeuk.kim@samsung.com>, linux-fsdevel@vger.kernel.org,
        gregkh@linuxfoundation.org, viro@zeniv.linux.org.uk, tytso@mit.edu,
        chur.lee@samsung.com, cm224.lee@samsung.com,
        jooyoung.hwang@samsung.com
References: <003d01cdb74b$0c3fa420$24beec60$%kim@samsung.com> <201211101933.38434.Martin@lichtvoll.de> <201211102149.48946.arnd@arndb.de> (sfid-20121111_013506_013683_61F4C040)
In-Reply-To: <201211102149.48946.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201211121616.23616.Martin@lichtvoll.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Samstag, 10. November 2012 schrieb Arnd Bergmann:
> On Saturday 10 November 2012, Martin Steigerwald wrote:
> > Command (m for help): n
> > Partition type:
> >    p   primary (0 primary, 0 extended, 4 free)
> >    e   extended
> > Select (default p): p
> > Partition number (1-4, default 1): 1
> > First sector (2048-4095998, default 2048): 
> > Using default value 2048
> > Last sector, +sectors or +size{K,M,G} (2048-4095998, default 4095998): 
> > Using default value 4095998
> 
> This is almost certainly not the right setting for f2fs, which only works
> at its design point if the segments are aligned to erase blocks. All modern
> flash devices have erase blocks larger than 1 MB, so starting the partition
> at a 1 MB offset will cause it to be misaligned. Also, some USB sticks
> have an area optimized for random writes in the beginning of the drive
> where both FAT32 and f2fs store their metadata. It may be worth testing
> again without a partition table, using just the raw device.

Thank you for your hints, Arnd, much appreciated.

I already suspected as such after having read some of the fine documents on
the linaro website.

As I want to write some article to give Linux users some insight about
Linux on "cheap" flash, I am willing to learn more.

> I would also recommend using flashbench to find out the optimum parameters
> for your device. You can download it from
> git://git.linaro.org/people/arnd/flashbench.git
> In the long run, we should automate those tests and make them part of
> mkfs.f2fs, but for now, try to find out the erase block size and the number
> of concurrently used erase blocks on your device using a timing attack
> in flashbench. The README file in there explains how to interpret the
> results from "./flashbench -a /dev/sdb  --blocksize=1024" to guess
> the erase block size, although that sometimes doesn't work.

Why do I use a blocksize of 1024 if the kernel reports me 512 byte blocks?

[ 3112.144086] scsi9 : usb-storage 1-1.1:1.0
[ 3113.145968] scsi 9:0:0:0: Direct-Access     TinyDisk 2007-05-12       0.00 PQ: 0 ANSI: 2
[ 3113.146476] sd 9:0:0:0: Attached scsi generic sg2 type 0
[ 3113.147935] sd 9:0:0:0: [sdb] 4095999 512-byte logical blocks: (2.09 GB/1.95 GiB)
[ 3113.148935] sd 9:0:0:0: [sdb] Write Protect is off


And how do reads give information about erase block size? Wouldn´t writes me
more conclusive for that? (Having to erase one versus two erase blocks?)


Hmmm, I get very varying results here with said USB stick:

merkaba:~> /tmp/flashbench -a /dev/sdb
align 536870912 pre 1.1ms       on 1.1ms        post 1.08ms     diff 13µs
align 268435456 pre 1.2ms       on 1.19ms       post 1.16ms     diff 11.6µs
align 134217728 pre 1.12ms      on 1.14ms       post 1.15ms     diff 9.51µs
align 67108864  pre 1.12ms      on 1.15ms       post 1.12ms     diff 29.9µs
align 33554432  pre 1.11ms      on 1.17ms       post 1.13ms     diff 49µs
align 16777216  pre 1.14ms      on 1.16ms       post 1.15ms     diff 22.4µs
align 8388608   pre 1.12ms      on 1.09ms       post 1.06ms     diff -2053ns
align 4194304   pre 1.13ms      on 1.16ms       post 1.14ms     diff 21.7µs
align 2097152   pre 1.11ms      on 1.08ms       post 1.1ms      diff -18488n
align 1048576   pre 1.11ms      on 1.11ms       post 1.11ms     diff -2461ns
align 524288    pre 1.15ms      on 1.17ms       post 1.1ms      diff 45.4µs
align 262144    pre 1.11ms      on 1.13ms       post 1.13ms     diff 12µs
align 131072    pre 1.1ms       on 1.09ms       post 1.16ms     diff -38025n
align 65536     pre 1.09ms      on 1.08ms       post 1.11ms     diff -21353n
align 32768     pre 1.1ms       on 1.08ms       post 1.11ms     diff -23854n
merkaba:~> /tmp/flashbench -a /dev/sdb
align 536870912 pre 1.11ms      on 1.13ms       post 1.13ms     diff 10.6µs
align 268435456 pre 1.12ms      on 1.2ms        post 1.17ms     diff 61.4µs
align 134217728 pre 1.14ms      on 1.19ms       post 1.15ms     diff 46.8µs
align 67108864  pre 1.08ms      on 1.15ms       post 1.08ms     diff 63.8µs
align 33554432  pre 1.09ms      on 1.08ms       post 1.09ms     diff -4761ns
align 16777216  pre 1.12ms      on 1.14ms       post 1.07ms     diff 41.4µs
align 8388608   pre 1.1ms       on 1.1ms        post 1.09ms     diff 7.48µs
align 4194304   pre 1.08ms      on 1.1ms        post 1.1ms      diff 10.1µs
align 2097152   pre 1.1ms       on 1.11ms       post 1.1ms      diff 16µs
align 1048576   pre 1.09ms      on 1.1ms        post 1.07ms     diff 15.5µs
align 524288    pre 1.12ms      on 1.12ms       post 1.1ms      diff 11µs
align 262144    pre 1.13ms      on 1.13ms       post 1.1ms      diff 21.6µs
align 131072    pre 1.11ms      on 1.13ms       post 1.12ms     diff 17.9µs
align 65536     pre 1.07ms      on 1.1ms        post 1.1ms      diff 11.6µs
align 32768     pre 1.09ms      on 1.11ms       post 1.13ms     diff -5131ns
merkaba:~> /tmp/flashbench -a /dev/sdb
align 536870912 pre 1.2ms       on 1.18ms       post 1.21ms     diff -27496n
align 268435456 pre 1.22ms      on 1.21ms       post 1.24ms     diff -18972n
align 134217728 pre 1.15ms      on 1.19ms       post 1.14ms     diff 42.5µs
align 67108864  pre 1.08ms      on 1.09ms       post 1.08ms     diff 5.29µs
align 33554432  pre 1.18ms      on 1.19ms       post 1.18ms     diff 9.25µs
align 16777216  pre 1.18ms      on 1.22ms       post 1.17ms     diff 48.6µs
align 8388608   pre 1.14ms      on 1.17ms       post 1.19ms     diff 4.36µs
align 4194304   pre 1.16ms      on 1.2ms        post 1.11ms     diff 65.8µs
align 2097152   pre 1.13ms      on 1.09ms       post 1.12ms     diff -37718n
align 1048576   pre 1.15ms      on 1.2ms        post 1.18ms     diff 34.9µs
align 524288    pre 1.14ms      on 1.19ms       post 1.16ms     diff 41.5µs
align 262144    pre 1.19ms      on 1.12ms       post 1.15ms     diff -52725n
align 131072    pre 1.21ms      on 1.11ms       post 1.14ms     diff -68522n
align 65536     pre 1.21ms      on 1.13ms       post 1.18ms     diff -64248n
align 32768     pre 1.14ms      on 1.25ms       post 1.12ms     diff 116µs


Even when I apply the explaination of the README I do not seem to get a
clear picture of the stick erase block size.

The values above seem to indicate to me: I don´t care about alignment at all.


With another flash, likely slower Intenso 4GB stick I get:

[ 3672.512143] scsi 10:0:0:0: Direct-Access     Ut165    USB2FlashStorage 0.00 PQ: 0 ANSI: 2
[ 3672.514469] sd 10:0:0:0: Attached scsi generic sg2 type 0
[ 3672.514991] sd 10:0:0:0: [sdb] 7897088 512-byte logical blocks: (4.04 GB/3.76 GiB)
[…]
merkaba:~> /tmp/flashbench -a /dev/sdb
align 1073741824        pre 1.06ms      on 1.03ms       post 951µs      diff 26.1µs
align 536870912 pre 1.06ms      on 1ms  post 941µs      diff 1.17µs
align 268435456 pre 995µs       on 957µs        post 887µs      diff 15.7µs
align 134217728 pre 994µs       on 951µs        post 883µs      diff 12.4µs
align 67108864  pre 994µs       on 989µs        post 1.02ms     diff -15104n
align 33554432  pre 934µs       on 974µs        post 1ms        diff 4.16µs
align 16777216  pre 946µs       on 916µs        post 900µs      diff -6588ns
align 8388608   pre 883µs       on 881µs        post 880µs      diff -1176ns
align 4194304   pre 884µs       on 884µs        post 885µs      diff -159ns

here?

align 2097152   pre 880µs       on 879µs        post 783µs      diff 47.6µs
align 1048576   pre 877µs       on 881µs        post 878µs      diff 3.92µs
align 524288    pre 869µs       on 870µs        post 875µs      diff -2101ns
align 262144    pre 871µs       on 875µs        post 885µs      diff -2539ns
align 131072    pre 878µs       on 893µs        post 900µs      diff 3.6µs
align 65536     pre 851µs       on 881µs        post 884µs      diff 13.7µs
align 32768     pre 836µs       on 833µs        post 880µs      diff -25556n
merkaba:~> /tmp/flashbench -a /dev/sdb
align 1073741824        pre 1.07ms      on 1e+03µ       post 962µs      diff -14615n
align 536870912 pre 1.06ms      on 1.01ms       post 940µs      diff 12.2µs
align 268435456 pre 1ms on 943µs        post 885µs      diff -1132ns
align 134217728 pre 995µs       on 982µs        post 909µs      diff 30µs
align 67108864  pre 999µs       on 995µs        post 1.01ms     diff -9707ns
align 33554432  pre 960µs       on 1.01ms       post 1.03ms     diff 15.2µs
align 16777216  pre 954µs       on 928µs        post 878µs      diff 12.1µs
align 8388608   pre 872µs       on 900µs        post 895µs      diff 16.5µs
align 4194304   pre 895µs       on 862µs        post 890µs      diff -30439n
align 2097152   pre 889µs       on 901µs        post 876µs      diff 18.7µs
align 1048576   pre 900µs       on 898µs        post 897µs      diff -708ns

here?

align 524288    pre 885µs       on 874µs        post 881µs      diff -8470ns
align 262144    pre 817µs       on 873µs        post 878µs      diff 25.6µs
align 131072    pre 882µs       on 854µs        post 881µs      diff -27423n
align 65536     pre 866µs       on 890µs        post 885µs      diff 14.3µs
align 32768     pre 900µs       on 881µs        post 893µs      diff -15412n
merkaba:~> /tmp/flashbench -a /dev/sdb
align 1073741824        pre 1.12ms      on 1.02ms       post 949µs      diff -12574n
align 536870912 pre 1.07ms      on 1.03ms       post 948µs      diff 16.5µs
align 268435456 pre 1.01ms      on 958µs        post 883µs      diff 12.1µs
align 134217728 pre 994µs       on 946µs        post 879µs      diff 9.2µs
align 67108864  pre 1ms on 1.05ms       post 1.03ms     diff 37.9µs
align 33554432  pre 942µs       on 1.01ms       post 1.03ms     diff 20.6µs
align 16777216  pre 939µs       on 903µs        post 880µs      diff -5972ns
align 8388608   pre 900µs       on 914µs        post 923µs      diff 2.42µs
align 4194304   pre 894µs       on 886µs        post 882µs      diff -1563ns

here?

align 2097152   pre 829µs       on 890µs        post 874µs      diff 37.8µs
align 1048576   pre 899µs       on 882µs        post 843µs      diff 11.1µs
align 524288    pre 890µs       on 887µs        post 902µs      diff -9005ns
align 262144    pre 887µs       on 887µs        post 898µs      diff -5474ns
align 131072    pre 928µs       on 895µs        post 914µs      diff -26028n
align 65536     pre 898µs       on 898µs        post 894µs      diff 2.59µs
align 32768     pre 884µs       on 891µs        post 901µs      diff -1284ns


Similar picture. The diffs seem to be mostly quite small with only some
micro seconds. Or am I misreading something?


Then with a quite fast one 16 GB Transcend.

[ 4055.393399] sd 11:0:0:0: Attached scsi generic sg2 type 0
[ 4055.394729] sd 11:0:0:0: [sdb] 31375360 512-byte logical blocks: (16.0 GB/14.9 GiB)
[ 4055.395262] sd 11:0:0:0: [sdb] Write Protect is off


merkaba:~> /tmp/flashbench -a /dev/sdb
align 4294967296        pre 1.28ms      on 1.48ms       post 1.33ms     diff 179µs
align 2147483648        pre 1.32ms      on 1.51ms       post 1.33ms     diff 181µs
align 1073741824        pre 1.31ms      on 1.46ms       post 1.35ms     diff 132µs
align 536870912 pre 1.27ms      on 1.52ms       post 1.33ms     diff 228µs
align 268435456 pre 1.28ms      on 1.46ms       post 1.31ms     diff 161µs
align 134217728 pre 1.28ms      on 1.44ms       post 1.37ms     diff 120µs
align 67108864  pre 1.27ms      on 1.44ms       post 1.34ms     diff 133µs
align 33554432  pre 1.24ms      on 1.42ms       post 1.31ms     diff 150µs
align 16777216  pre 1.23ms      on 1.46ms       post 1.26ms     diff 218µs
align 8388608   pre 1.31ms      on 1.5ms        post 1.33ms     diff 180µs
align 4194304   pre 1.27ms      on 1.45ms       post 1.36ms     diff 135µs
align 2097152   pre 1.29ms      on 1.37ms       post 1.39ms     diff 33.7µs

here?

align 1048576   pre 1.31ms      on 1.44ms       post 1.35ms     diff 115µs
align 524288    pre 1.33ms      on 1.39ms       post 1.48ms     diff -12297n
align 262144    pre 1.36ms      on 1.42ms       post 1.4ms      diff 45.6µs
align 131072    pre 1.37ms      on 1.44ms       post 1.4ms      diff 57.7µs
align 65536     pre 1.36ms      on 1.35ms       post 1.33ms     diff 4.67µs
align 32768     pre 1.32ms      on 1.38ms       post 1.34ms     diff 44.1µs
merkaba:~> /tmp/flashbench -a /dev/sdb
align 4294967296        pre 1.36ms      on 1.49ms       post 1.34ms     diff 139µs
align 2147483648        pre 1.26ms      on 1.48ms       post 1.27ms     diff 213µs
align 1073741824        pre 1.26ms      on 1.45ms       post 1.33ms     diff 164µs
align 536870912 pre 1.22ms      on 1.46ms       post 1.35ms     diff 173µs
align 268435456 pre 1.34ms      on 1.5ms        post 1.31ms     diff 172µs
align 134217728 pre 1.34ms      on 1.48ms       post 1.31ms     diff 157µs
align 67108864  pre 1.29ms      on 1.46ms       post 1.34ms     diff 142µs
align 33554432  pre 1.28ms      on 1.47ms       post 1.31ms     diff 173µs
align 16777216  pre 1.26ms      on 1.48ms       post 1.37ms     diff 168µs
align 8388608   pre 1.31ms      on 1.47ms       post 1.36ms     diff 139µs
align 4194304   pre 1.26ms      on 1.53ms       post 1.33ms     diff 237µs
align 2097152   pre 1.34ms      on 1.4ms        post 1.36ms     diff 56.4µs
align 1048576   pre 1.32ms      on 1.35ms       post 1.37ms     diff 638ns

here?

align 524288    pre 1.29ms      on 1.47ms       post 1.45ms     diff 98.1µs
align 262144    pre 1.35ms      on 1.38ms       post 1.42ms     diff -11916n
align 131072    pre 1.32ms      on 1.46ms       post 1.4ms      diff 100µs
align 65536     pre 1.35ms      on 1.42ms       post 1.43ms     diff 30.8µs
align 32768     pre 1.31ms      on 1.37ms       post 1.33ms     diff 51µs
merkaba:~> /tmp/flashbench -a /dev/sdb
align 4294967296        pre 1.26ms      on 1.49ms       post 1.27ms     diff 222µs
align 2147483648        pre 1.25ms      on 1.41ms       post 1.37ms     diff 97.3µs
align 1073741824        pre 1.26ms      on 1.47ms       post 1.31ms     diff 186µs
align 536870912 pre 1.25ms      on 1.42ms       post 1.32ms     diff 132µs
align 268435456 pre 1.2ms       on 1.44ms       post 1.29ms     diff 195µs
align 134217728 pre 1.27ms      on 1.43ms       post 1.34ms     diff 118µs
align 67108864  pre 1.25ms      on 1.45ms       post 1.31ms     diff 165µs
align 33554432  pre 1.22ms      on 1.36ms       post 1.25ms     diff 124µs
align 16777216  pre 1.24ms      on 1.44ms       post 1.26ms     diff 191µs
align 8388608   pre 1.22ms      on 1.39ms       post 1.23ms     diff 164µs
align 4194304   pre 1.23ms      on 1.43ms       post 1.3ms      diff 171µs
align 2097152   pre 1.26ms      on 1.3ms        post 1.32ms     diff 16.7µs
align 1048576   pre 1.26ms      on 1.27ms       post 1.26ms     diff 7.91µs

here?

align 524288    pre 1.24ms      on 1.3ms        post 1.3ms      diff 29.2µs
align 262144    pre 1.25ms      on 1.3ms        post 1.28ms     diff 28.2µs
align 131072    pre 1.25ms      on 1.29ms       post 1.28ms     diff 24.8µs
align 65536     pre 1.15ms      on 1.24ms       post 1.26ms     diff 34.5µs
align 32768     pre 1.17ms      on 1.3ms        post 1.26ms     diff 82.6µs


Thing is that me here is not always at the same place :)

> With the correct guess, compare the performance you get using
> 
> $ ERASESIZE=$[2*1024*1024] # replace with guess from flashbench -a
> $ ./flashbench /dev/sdb --open-au --open-au-nr=1 --blocksize=4096 --erasesize=${ERASESIZE}
> $ ./flashbench /dev/sdb --open-au --open-au-nr=3 --blocksize=4096 --erasesize=${ERASESIZE}
> $ ./flashbench /dev/sdb --open-au --open-au-nr=5 --blocksize=4096 --erasesize=${ERASESIZE}
> $ ./flashbench /dev/sdb --open-au --open-au-nr=7 --blocksize=4096 --erasesize=${ERASESIZE}
> $ ./flashbench /dev/sdb --open-au --open-au-nr=13 --blocksize=4096 --erasesize=${ERASESIZE}

I omit this for now, cause I am not yet sure about the correct guess.

> The first one of those should always be the fastest, hopefully followed by
> some that are equally fast and then some much slower ones (especially for the
> smaller block sizes). The "active_logs=N" mount option should be one less
> than the highest number above that is still "fast", and only "2", "4" and "6"
> are valid at the moment. If you are lucky, your device is still fast with
> "--open-au-nr=7" and slow only for higher numbers, then the default of "6"
> is ok.
> 
> If the erase size is larger than 2 MB, then you have to "-s" option in
> mkfs.f2fs to configure how many 2 MB segments there are in one erase block.
> For a 2 GB USB stick, I would guess that the erase block size is 1, 2 or
> 4 MB. Newer (larger) sticks will have larger erase blocks that may also
> be a multiple of 3 MB (3, 6, 12, or 24).

Thanks,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
