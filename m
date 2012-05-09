Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932641Ab2EIWTZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 18:19:25 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:57859 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932536Ab2EIWTW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 18:19:22 -0400
MIME-Version: 1.0
In-Reply-To: <201205091756.16050.arnd@arndb.de>
References: <CAMP44s2eVtquLoB6Zjbs4nGVKP6e=Dxse4uicL4s8vmrFeJdTQ@mail.gmail.com>
	<201205091756.16050.arnd@arndb.de>
Date: Thu, 10 May 2012 00:19:20 +0200
Message-ID: <CAMP44s1anUhxRqvdEVYdvu9+xedoQmRiEOHii3yaJQWfM2zauA@mail.gmail.com>
Subject: Re: Big I/O latencies, except when iotop is hooked
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 9, 2012 at 7:56 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Wednesday 09 May 2012, Felipe Contreras wrote:
>> I've been noticing big I/O latencies when doing operations with
>> notmuch (xapian database), the operations are quite simple and
>> probably should not need a lot of I/O, however, they seen to take a
>> long time, sometimes even seconds. But when I hook iotop (-p pid), the
>> latency goes away, and every operation is reliably instantaneous
>> (basically).
>>
>> Do you have any ideas what might be causing this delay, and why is
>> iotop making it go away?
>>
>> BTW. This is an ext4 encrypted partition on a USB stick, I tried
>> different mount options without any noticeable change. I tried to copy
>> the data to my SSD drive and do the same operations, while it was much
>> faster, it still seemed to have some delays triggered randomly. This
>> is with v3.3.5.
>
> USB sticks like most other cheap flash media tend to have long latencies
> because of the effects I describe on https://lwn.net/Articles/428584/.
>
> I don't know if you have the chance to run flashbench[1] on it (which
> will destroy the data for the partition you are testing), but that
> should at least tell you if it's a problem with the drive.

I'm having trouble figuring this out, but I guess the EBS is 2MiB:

% sudo ./flashbench -a /dev/sdd --blocksize=1024 --count=10
align 2147483648	pre 932µs	on 1.08ms	post 978µs	diff 124µs
align 1073741824	pre 641µs	on 676µs	post 639µs	diff 36.2µs
align 536870912	pre 778µs	on 854µs	post 801µs	diff 64.9µs
align 268435456	pre 826µs	on 908µs	post 880µs	diff 54.6µs
align 134217728	pre 646µs	on 660µs	post 655µs	diff 9.26µs
align 67108864	pre 783µs	on 834µs	post 783µs	diff 50.7µs
align 33554432	pre 825µs	on 942µs	post 864µs	diff 97.1µs
align 16777216	pre 802µs	on 995µs	post 835µs	diff 176µs
align 8388608	pre 905µs	on 1.09ms	post 921µs	diff 175µs
align 4194304	pre 990µs	on 1.14ms	post 998µs	diff 145µs
align 2097152	pre 1.06ms	on 1.21ms	post 1.08ms	diff 144µs
align 1048576	pre 1.06ms	on 1.22ms	post 1.06ms	diff 162µs
align 524288	pre 1.04ms	on 1.15ms	post 996µs	diff 136µs
align 262144	pre 1.06ms	on 1.22ms	post 1.06ms	diff 155µs
align 131072	pre 1.01ms	on 1.14ms	post 999µs	diff 138µs
align 65536	pre 1.06ms	on 1.23ms	post 1.05ms	diff 179µs
align 32768	pre 1.05ms	on 1.22ms	post 1.1ms	diff 146µs
align 16384	pre 1.03ms	on 1.2ms	post 1.05ms	diff 157µs
align 8192	pre 1.03ms	on 1.14ms	post 1.02ms	diff 115µs
align 4096	pre 1.03ms	on 1.12ms	post 1.04ms	diff 88.5µs
align 2048	pre 1.01ms	on 1.03ms	post 1.02ms	diff 12.9µs

http://usbflashspeed.com/19425

But sometimes I get weird results:

% sudo ./flashbench -O --erasesize=$[2 * 1024 * 1024] --blocksize=$[16
* 1024] /dev/sdd --open-au-nr=2 --count=10
2MiB    1.88M/s
1MiB    21.5M/s
512KiB  21.9M/s
256KiB  20.8M/s
128KiB  17.7M/s
64KiB   22.3M/s
32KiB   20.8M/s
16KiB   17.1M/s
% sudo ./flashbench -O --erasesize=$[2 * 1024 * 1024] --blocksize=$[16
* 1024] /dev/sdd --open-au-nr=2 --count=10
2MiB    21.3M/s
1MiB    21.9M/s
512KiB  21.7M/s
256KiB  21.3M/s
128KiB  17.6M/s
64KiB   23.6M/s
32KiB   20.3M/s
16KiB   16M/s

> You can also use the information from that and combine it with
> a blocktrace log and flashsim[2] to see where the actual latencies
> are expected to happen.

While doing the relevant operation I got:

% ./flashsim -i iolog -s 2M -b 16k -m 5 -a la
  176.87

I guess that's bad?

> The first thing you should check is whether the partitions are
> properly aligned, using 'fdisk -l -u /dev/sdX'.

Doesn't seem like that, but that doesn't explain the results I'm getting.

I think it's pretty clear there's some kind of I/O scheduling problem.

% sudo gdisk -l /dev/sdd
GPT fdisk (gdisk) version 0.8.4

Partition table scan:
  MBR: protective
  BSD: not present
  APM: not present
  GPT: present

Found valid GPT with protective MBR; using GPT.
Disk /dev/sdd: 15638480 sectors, 7.5 GiB
Logical sector size: 512 bytes
Disk identifier (GUID): 115D90F0-6973-4C82-B778-F1434BDA38DE
Partition table holds up to 128 entries
First usable sector is 34, last usable sector is 15638446
Partitions will be aligned on 2048-sector boundaries
Total free space is 2014 sectors (1007.0 KiB)

Number  Start (sector)    End (sector)  Size       Code  Name
   1            2048        15638446   7.5 GiB     8300  Linux filesystem

Cheers.

-- 
Felipe Contreras
