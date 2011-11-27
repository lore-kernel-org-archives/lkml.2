Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755503Ab1K0OHT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Nov 2011 09:07:19 -0500
Received: from mout2.freenet.de ([195.4.92.92]:40796 "EHLO mout2.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754865Ab1K0OHS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Nov 2011 09:07:18 -0500
Message-ID: <4ED243F5.7090407@01019freenet.de>
Date: Sun, 27 Nov 2011 15:06:45 +0100
From: Andreas Hartmann <andihartmann@01019freenet.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0.1) Gecko/20111121 Firefox/8.0.1 SeaMonkey/2.5
MIME-Version: 1.0
To: richard -rw- weinberger <richard.weinberger@gmail.com>
CC: linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: Broken hd or filesystem access after resume from suspend2disk
References: <jatcd7$4sc$1@ID-44327.news.uni-berlin.de> <CAFLxGvzwbLZrECWRzDxbHMt+SwKyCUukh9=PEpEQZsw=EtgoJw@mail.gmail.com>
In-Reply-To: <CAFLxGvzwbLZrECWRzDxbHMt+SwKyCUukh9=PEpEQZsw=EtgoJw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

richard -rw- weinberger schrieb:
> On Sun, Nov 27, 2011 at 2:02 PM, Andreas Hartmann
> <andihartmann@01019freenet.de> wrote:
>> Hello,
>>
>> I'm often having trouble accessing the hd / filesystem after a resume
>> from  suspend2disk. Sometimes, the machine completely hangs after resume
>> or it cannot be suspended at all.
>>
>> Today, I faced the following problem after resuming:
>>
>> Using wpa_supplicant failed with the message:
>>
>> wpa_supplicant -t -c /etc/wpa_supplicant/wpa_supplicant.conf -f
>> /var/log/wpa_supplicant.log -Dnl80211 -iwlan0
>> wpa_supplicant: symbol lookup error: /lib64/libssl.so.1.0.0: undefined
>> symbol: RAND_add
>>
>>
>> ldd `which wpa_supplicant`
>>        linux-vdso.so.1 =>  (0x00007fffd84b9000)
>>        libnl.so.1 => /lib64/libnl.so.1 (0x00007fe5ac0bd000)
>>        libdl.so.2 => /lib64/libdl.so.2 (0x00007fe5abeb9000)
>>        libssl.so.1.0.0 => /lib64/libssl.so.1.0.0 (0x00007fe5abc5d000)
>>        libcrypto.so.1.0.0 => /lib64/libcrypto.so.1.0.0 (0x00007fe5ab8ad000)
>>        libdbus-1.so.3 => /lib64/libdbus-1.so.3 (0x00007fe5ab668000)
>>        libc.so.6 => /lib64/libc.so.6 (0x00007fe5ab2d9000)
>>        libm.so.6 => /lib64/libm.so.6 (0x00007fe5ab082000)
>>        /lib64/ld-linux-x86-64.so.2 (0x00007fe5ac30f000)
>>        libz.so.1 => /lib64/libz.so.1 (0x00007fe5aae6a000)
>>        libpthread.so.0 => /lib64/libpthread.so.0 (0x00007fe5aac4d000)
>>        librt.so.1 => /lib64/librt.so.1 (0x00007fe5aaa45000)
>>
>>
>> rpm -qVf /lib64/libssl.so.1.0.0
>> 5........    /lib64/libcrypto.so.1.0.0
>>
>> -> The libcrypto-library seems to be broken.
>>
>> In order to check, if there are more broken libraries (after the
>> resume), I did a md5sum on the complete /lib64 directory to have it at
>> base for a recheck after a reboot.
>>
>> The recheck after the reboot showed two more broken files:
>>
>> cd /lib64
>> md5sum -c md5sum.out | grep FAILED
>> libcrypto.so.1.0.0: FAILED
>> libkeyutils.so.1: FAILED
>> libkeyutils.so.1.4: FAILED
>> md5sum: WARNING: 3 computed checksums did NOT match
>>
>> Apparently, there is something completely broken after resume.

[...]

> 
> Hmmm, maybe this related to my problem:
> http://thread.gmane.org/gmane.linux.kernel/1116939/focus=1117113
> 
> First I thought the issue is no longer present in newer kernels.
> But my netbook still suffers on it.

I just looked at the link above and can say that I face this problem
since opensuse 11.3 (kernel 2.6.34 ...) with my machine (64 bit). The
problem is, that the effects are always different, addicted to the file
which actually is corrupted. I even could see this kernel bug after
resume from s2disk, which seems to be filesystem related, too:

http://permalink.gmane.org/gmane.linux.kernel/1214998

I'm using a crypted lvm partition:

fdisk -l

Disk /dev/sda: 250.1 GB, 250059350016 bytes
255 heads, 63 sectors/track, 30401 cylinders, total 488397168 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0xbab21f87

   Device Boot      Start         End      Blocks   Id  System
/dev/sda1   *        2048      321535      159744   83  Linux
/dev/sda2          321536   488396799   244037632   8e  Linux LVM


pvdisplay
  --- Physical volume ---
  PV Name               /dev/mapper/cr_sda2
  VG Name               system
  PV Size               232.73 GiB / not usable 4.00 MiB
  Allocatable           yes
  PE Size               4.00 MiB
  Total PE              59578
  Free PE               43519
  Allocated PE          16059



lvdisplay
  --- Logical volume ---
  LV Name                /dev/system/home
  VG Name                system
  LV Write Access        read/write
  LV Status              available
  # open                 1
  LV Size                25.00 GiB
  Current LE             6400
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     3072
  Block device           253:1

  --- Logical volume ---
  LV Name                /dev/system/opt
  VG Name                system
  LV Write Access        read/write
  LV Status              available
  # open                 1
  LV Size                1.00 GiB
  Current LE             256
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     3072
  Block device           253:2

  --- Logical volume ---
  LV Name                /dev/system/root
  VG Name                system
  LV Write Access        read/write
  LV Status              available
  # open                 1
  LV Size                2.00 GiB
  Current LE             512
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     3072
  Block device           253:3

  --- Logical volume ---
  LV Name                /dev/system/swap
  VG Name                system
  LV Write Access        read/write
  LV Status              available
  # open                 2
  LV Size                4.00 GiB
  Current LE             1024
  Segments               2
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           253:4

  --- Logical volume ---
  LV Name                /dev/system/usr
  VG Name                system
  LV Write Access        read/write
  LV Status              available
  # open                 1
  LV Size                20.00 GiB
  Current LE             5120
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     3072
  Block device           253:5

  --- Logical volume ---
  LV Name                /dev/system/var
  VG Name                system
  LV Write Access        read/write
  LV Status              available
  # open                 1
  LV Size                10.73 GiB
  Current LE             2747
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     3072
  Block device           253:6


cryptsetup status cr_sda2
/dev/mapper/cr_sda2 is active and is in use.
  type:    LUKS1
  cipher:  aes-cbc-essiv:sha256
  keysize: 256 bits
  device:  /dev/sda2
  offset:  4096 sectors
  size:    488071168 sectors
  mode:    read/write


The resume partition is /dev/system/swap



Kind regards,
Andreas Hartmann
