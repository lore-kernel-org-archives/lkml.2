Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758997Ab2EJKuK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 06:50:10 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:51001 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751918Ab2EJKuI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 06:50:08 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Felipe Contreras <felipe.contreras@gmail.com>
Subject: Re: Big I/O latencies, except when iotop is hooked
Date: Thu, 10 May 2012 10:49:58 +0000
User-Agent: KMail/1.12.2 (Linux/3.4.0-rc3; KDE/4.3.2; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <CAMP44s2eVtquLoB6Zjbs4nGVKP6e=Dxse4uicL4s8vmrFeJdTQ@mail.gmail.com> <201205091756.16050.arnd@arndb.de> <CAMP44s1anUhxRqvdEVYdvu9+xedoQmRiEOHii3yaJQWfM2zauA@mail.gmail.com>
In-Reply-To: <CAMP44s1anUhxRqvdEVYdvu9+xedoQmRiEOHii3yaJQWfM2zauA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <201205101049.58818.arnd@arndb.de>
X-Provags-ID: V02:K0:C1/AuuWhJLhNgY3NoN3ebY4GhTInHPP0D5KG9Qn+Ya5
 61br+e3EerhLCmTpK1M4q73LDGHw8f6KB4pz1cp+1IlboYQJEt
 4GpGdnZodnd8LIzLH0jv0gDhJ8yBB0IzkFeEcTldBQC/W2ioDp
 hYrPj0tKBAjZQ7ZxKgvJZDq+AQ94HzAMPfVVH/vw5fnLGv9HU4
 3Fl9DXQmDVBi9+2oUIrLqb5ti0C6JXDOcf7SEBgJt+qDdBvnv2
 NtjwE4zZqcodFw1uSjFLuMyoY9Wts3m7YG/pMK7aACTEf2ycj/
 sR8ql3oL4RxQiIYzwL0fNRo7Ha8Xmg6xA0QXZWlOPDluNWR245
 80ixve7PkDdUM/rY/2Vs=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 09 May 2012, Felipe Contreras wrote:
> On Wed, May 9, 2012 at 7:56 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> > On Wednesday 09 May 2012, Felipe Contreras wrote:
> >> I've been noticing big I/O latencies when doing operations with
> >> notmuch (xapian database), the operations are quite simple and
> >> probably should not need a lot of I/O, however, they seen to take a
> >> long time, sometimes even seconds. But when I hook iotop (-p pid), the
> >> latency goes away, and every operation is reliably instantaneous
> >> (basically).
> >>
> >> Do you have any ideas what might be causing this delay, and why is
> >> iotop making it go away?
> >>
> >> BTW. This is an ext4 encrypted partition on a USB stick, I tried
> >> different mount options without any noticeable change. I tried to copy
> >> the data to my SSD drive and do the same operations, while it was much
> >> faster, it still seemed to have some delays triggered randomly. This
> >> is with v3.3.5.
> >
> > USB sticks like most other cheap flash media tend to have long latencies
> > because of the effects I describe on https://lwn.net/Articles/428584/.
> >
> > I don't know if you have the chance to run flashbench[1] on it (which
> > will destroy the data for the partition you are testing), but that
> > should at least tell you if it's a problem with the drive.
> 
> I'm having trouble figuring this out, but I guess the EBS is 2MiB:
> 
> % sudo ./flashbench -a /dev/sdd --blocksize=1024 --count=10
> align 2147483648	pre 932µs	on 1.08ms	post 978µs	diff 124µs
> align 1073741824	pre 641µs	on 676µs	post 639µs	diff 36.2µs
> align 536870912	pre 778µs	on 854µs	post 801µs	diff 64.9µs
> align 268435456	pre 826µs	on 908µs	post 880µs	diff 54.6µs
> align 134217728	pre 646µs	on 660µs	post 655µs	diff 9.26µs
> align 67108864	pre 783µs	on 834µs	post 783µs	diff 50.7µs
> align 33554432	pre 825µs	on 942µs	post 864µs	diff 97.1µs
> align 16777216	pre 802µs	on 995µs	post 835µs	diff 176µs
> align 8388608	pre 905µs	on 1.09ms	post 921µs	diff 175µs
> align 4194304	pre 990µs	on 1.14ms	post 998µs	diff 145µs
> align 2097152	pre 1.06ms	on 1.21ms	post 1.08ms	diff 144µs
> align 1048576	pre 1.06ms	on 1.22ms	post 1.06ms	diff 162µs

It's not really clear from this data. 2 MB sounds wrong because the numbers area
almost the same for the 1 MB and 2 MB lines. 4 MB is possible, and so is 32 
MB according to those measurements, but that would be too large for an 8GB
drive.

What I find very unusual is the reported size of 15638480 sectors, which is not
a multiple of any of the usual erase block sizes. This means that the erase block
size could be an odd value. 

The prime factors of the drive size are:
$ factor 15638480                                                                        
15638480: 2 2 2 2 5 11 13 1367

This is 41KB short of 7636 MB, which is a multiple of 4MB but not 8 MB.
Hence I would guess that the erase block size is 4MB, with 41KB cut off
from either the first or the last block (I've seen both before, but usually
only on CF cards, which round down to a multiple of 63*255 sectors).

Let's hope that the last block is cut off, not the first one, otherwise
you'd have to move the start of the partition ahead by 41 KB. You can
test that by giving an '--offset=4152320' argument to flashbench, which
should either be much faster or much slower than not giving the offset
argument.

> http://usbflashspeed.com/19425
> 
> But sometimes I get weird results:
> 
> % sudo ./flashbench -O --erasesize=$[2 * 1024 * 1024] --blocksize=$[16
> * 1024] /dev/sdd --open-au-nr=2 --count=10
> 2MiB    1.88M/s
> 1MiB    21.5M/s
> 512KiB  21.9M/s
> 256KiB  20.8M/s
> 128KiB  17.7M/s
> 64KiB   22.3M/s
> 32KiB   20.8M/s
> 16KiB   17.1M/s
> % sudo ./flashbench -O --erasesize=$[2 * 1024 * 1024] --blocksize=$[16
> * 1024] /dev/sdd --open-au-nr=2 --count=10
> 2MiB    21.3M/s
> 1MiB    21.9M/s
> 512KiB  21.7M/s
> 256KiB  21.3M/s
> 128KiB  17.6M/s
> 64KiB   23.6M/s
> 32KiB   20.3M/s
> 16KiB   16M/s

This does not look that unusual. The first 2MB number was when the test hit
a garbage collection, which incurred an overhead of about one second (!)
for this device (it tried to write 2MB and came measured an average throughput
of 2MB/s for that). The drive is optimized for 64KB clusters, which are
faster than other sizes, and writing more than 64KB at once causes some
overhead that is less at larger sizes. My guess is that it can do random
access for 64KB chunks but not larger than that -- you can test that by
passing '--random' as an extra argument.

Note that '--count' is ignored for the '-O' test.

The important measurement (once you have found the erase block size) is
how many erase blocks can be held open at the same time, so I'd try
passing --open-au-nr=8 and see what happens. If the numbers are in the
same ballpark as above, then increase it further until you have hit
the point where.

> > You can also use the information from that and combine it with
> > a blocktrace log and flashsim[2] to see where the actual latencies
> > are expected to happen.
> 
> While doing the relevant operation I got:
> 
> % ./flashsim -i iolog -s 2M -b 16k -m 5 -a la
>   176.87
> 
> I guess that's bad?

176 is extremely bad, yes. A good value would be between 1 and 3.
The algorithm is probably not 'la' but 'dl' and the page size (-b)
could be smaller -- you have to test by passing '--blocksize=1024' to
the --open-au test and see where it starts getting drastically
smaller (if 4KB gives you about half the throughput of 8KB,
8KB is the page size). Those two can make the result better.

As I said, the erase block size is more likely to be 4MB, which
will make the flashsim result worse.

Does flashsim give a better number for a trace taken with iotop
running?

Can you send me or upload that iolog file?

> > The first thing you should check is whether the partitions are
> > properly aligned, using 'fdisk -l -u /dev/sdX'.
> 
> Doesn't seem like that, but that doesn't explain the results I'm getting.
> 
> I think it's pretty clear there's some kind of I/O scheduling problem.
> 
> % sudo gdisk -l /dev/sdd
> GPT fdisk (gdisk) version 0.8.4
> 
> Partition table scan:
>   MBR: protective
>   BSD: not present
>   APM: not present
>   GPT: present
> 
> Found valid GPT with protective MBR; using GPT.
> Disk /dev/sdd: 15638480 sectors, 7.5 GiB
> Logical sector size: 512 bytes
> Disk identifier (GUID): 115D90F0-6973-4C82-B778-F1434BDA38DE
> Partition table holds up to 128 entries
> First usable sector is 34, last usable sector is 15638446
> Partitions will be aligned on 2048-sector boundaries
> Total free space is 2014 sectors (1007.0 KiB)
> 
> Number  Start (sector)    End (sector)  Size       Code  Name
>    1            2048        15638446   7.5 GiB     8300  Linux filesystem

It's aligned to 1MB, which is less than the erase block size, but as
long as the file system doesn't know about erase blocks, that's good enough.

	ARnd
