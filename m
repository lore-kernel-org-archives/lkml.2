Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755579Ab2ELXVF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2012 19:21:05 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:45214 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754579Ab2ELXVB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2012 19:21:01 -0400
MIME-Version: 1.0
Date: Sun, 13 May 2012 01:21:00 +0200
Message-ID: <CAHOpdHWMcV6LjpaEhk27ULkz-wGUD0-pNH=PC+ahDn47VQ+qmQ@mail.gmail.com>
Subject: BUG: jbd2 slowing down file copies even though no journaling file
 system is used
From: =?ISO-8859-1?Q?Bj=F6rn_Christoph?= <einkaufenbc09@googlemail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey guys,

I have very slow and non-consistant transfer rates when copying files to Linux.

My system:
Ubuntu 12.04 Server x64 (same issue with Debian Squeez), 2 Gb RAM, AMD
240e processor

Hard disks:
1 * 500 Gb Seagate Momentus XT Hybrid HDD
6 * 1.5 - 2 TB Samsung HDD

The Momentus contains the OS in an encrypted LWM (dm-crypt) - one ext2
for booting, one ext2 and one LVM partition (all primary).

The other bigger hard disks each contain one encrypted Truecrypt
partition. Most are with ext4, one is with ext3. I join them to one
folder using "union-fs" (read only).

I use samba for transfer of data from my Windows 7 PC's.

The files stored are usually around 20 Gb in size (movies), and I
don't really care much about journaling and integrity (most partitions
are mounted read-only anyways as they are full ;) )

------------
The good scenario

Copying files FROM the server to a Windows client is really OK
performance wise. I see a 50% network utilization (1 Gbit network) and
it's quite constant around 46 Mb/sec.

TOP shows:
13681 root      20   0     0    0    0 S   40  0.0   0:35.05 kworker/0:3
13632 windows   20   0  122m 4916 3632 R   37  0.3   3:05.52 smbd
13678 root      20   0     0    0    0 S   29  0.0   0:34.57 kworker/0:0
 1797 root      20   0  448m 1440  420 S   22  0.1   2:06.89 unionfs-fuse

IOTOP shows:
Total DISK READ:      50.40 M/s | Total DISK WRITE:       0.00 B/s
  TID  PRIO  USER     DISK READ  DISK WRITE  SWAPIN     IO>    COMMAND
13632 be/4 windows    50.40 M/s    0.00 B/s  0.00 % 14.68 % smbd -F
10918 be/4 root        8.12 M/s    0.00 B/s  0.00 % 10.32 %
unionfs-fuse -o allow_other /share/h~hdd/6/Video
/share/multimedia/movies
10682 be/4 root        8.36 M/s    0.00 B/s  0.00 % 10.27 %
unionfs-fuse -o allow_other /share/h~hdd/6/Video
/share/multimedia/movies
10915 be/4 root        8.24 M/s    0.00 B/s  0.00 % 10.17 %
unionfs-fuse -o allow_other /share/h~hdd/6/Video
/share/multimedia/movies
 1798 be/4 root        8.00 M/s    0.00 B/s  0.00 % 10.15 %
unionfs-fuse -o allow_other /share/h~hdd/6/Video
/share/multimedia/movies
11282 be/4 root        9.57 M/s    0.00 B/s  0.00 % 10.13 %
unionfs-fuse -o allow_other /share/h~hdd/6/Video
/share/multimedia/movies
 1799 be/4 root        8.12 M/s    0.00 B/s  0.00 %  8.78 %
unionfs-fuse -o allow_other

We can see that there is no "jbd" here - which is expected based on
what I found on the web (we're reading so we don't need journal
creation here).

------------
The bad scenario:

I do also have to transfer data to this server. And here comes the problem.

I copy the file to a specific hard disk / samba share (not to the union-fs).

And here, the data transfer is just impossibly slow.

Now before we end up in "it's encryption", let me say this is not the
case and why:

I have one standard ext2 partition on the Momentus (300 Gb), ext2 has
no journaling (which I really don't require).

I copy the file to the ext2 partition. Average transfer rate around 29
Mb/sec. However, there are a lot of spikes in the network transfer.
Peak at around 35% and it goes down to 20% in a wave form with
sometimes even 0% transfer. I made a video of this with my cell and
can share it.

IOTOP shows this in some cases, mostly jbd2 is not there:
  PRIO  USER     DISK READ  DISK WRITE  SWAPIN     IO>    COMMAND
  416 be/3 root        0.00 B/s   97.65 M/s  0.00 % 13.74 % [jbd2/dm-1-8]
 1067 be/4 root        0.00 B/s    3.92 K/s  0.00 %  0.00 % nmbd -D
13632 be/4 windows     0.00 B/s   25.98 M/s  0.00 %  0.00 % smbd -F
    1 be/4 root        0.00 B/s    0.00 B/s  0.00 %  0.00 % init
    2 be/4 root        0.00 B/s    0.00 B/s  0.00 %  0.00 % [kthreadd]
    3 be/4 root        0.00 B/s    0.00 B/s  0.00 %  0.00 % [ksoftirqd/0]
 1029 be/4 root        0.00 B/s    0.00 B/s  0.00 %  0.00 % sshd -D
    6 rt/4 root        0.00 B/s    0.00 B/s  0.00 %  0.00 % [migration/0]

What I can see in iotop is that smbd sometimes goes up to 40 and also
down to 10 Mb/sec. Now why is it like that?

The network? No - I did a "cp /dev/zero /share/test/z" to see how
quickly that would be. It shows that even here, jbd2 kicks in with 99%
I/O sometimes - and during that time there is NO disk access at all
acc. to iotop, 0 Kb read and written.

I don't doubt iotop - what I see there correlates very well to what I
see on Windows in the network traffic.

Now, my guess here would be something like - the kernel sees that
there has been data written, it tries to find out what has to go into
a journal (jbd2) but as it's such a lot of data this takes some time
and during this time nothing else is possible as the entire CPU(s) are
used up.

Just a guess as I don't know how the kernel works one bit ;)

So now I really hope you can help me here. These write transfer rates
are just so low that there has to be a bug here somewhere, Linux can
definately be faster I am sure :) And after spending days on this
analysis and reinstalling different linux distro's I really dont want
to go back to Windows yet (yes, there I have a constant write
performance of around 48 Mb/sec.

Whatever I can do to help let me know!

/proc/version:
Linux version 3.2.0-23-generic (buildd@crested) (gcc version 4.6.3
(Ubuntu/Linaro 4.6.3-1ubuntu4) ) #36-Ubuntu SMP Tue Apr 10 20:39:51
UTC 2012

/proc/cpuinfo:
processor       : 0
vendor_id       : AuthenticAMD
cpu family      : 16
model           : 6
model name      : AMD Athlon(tm) II X2 240e Processor
stepping        : 2
microcode       : 0x10000c7

/proc/modules:
xts 12756 64 - Live 0x0000000000000000
gf128mul 14951 1 xts, Live 0x0000000000000000
ext2 73795 1 - Live 0x0000000000000000
snd_hda_codec_hdmi 32474 1 - Live 0x0000000000000000
snd_hda_intel 33773 0 - Live 0x0000000000000000
snd_hda_codec 127706 2 snd_hda_codec_hdmi,snd_hda_intel, Live 0x0000000000000000
snd_hwdep 13668 1 snd_hda_codec, Live 0x0000000000000000
snd_pcm 97188 3 snd_hda_codec_hdmi,snd_hda_intel,snd_hda_codec, Live
0x0000000000000000
snd_timer 29990 1 snd_pcm, Live 0x0000000000000000
snd 78855 6 snd_hda_codec_hdmi,snd_hda_intel,snd_hda_codec,snd_hwdep,snd_pcm,snd_timer,
Live 0x0000000000000000
edac_core 53746 0 - Live 0x0000000000000000
edac_mce_amd 23709 0 - Live 0x0000000000000000
mac_hid 13253 0 - Live 0x0000000000000000
k10temp 13166 0 - Live 0x0000000000000000
soundcore 15091 1 snd, Live 0x0000000000000000
snd_page_alloc 18529 2 snd_hda_intel,snd_pcm, Live 0x0000000000000000
sp5100_tco 13791 0 - Live 0x0000000000000000
shpchp 37277 0 - Live 0x0000000000000000
i2c_piix4 13301 0 - Live 0x0000000000000000
lp 17799 0 - Live 0x0000000000000000
parport 46562 1 lp, Live 0x0000000000000000
dm_crypt 23125 9 - Live 0x0000000000000000
pata_jmicron 12747 0 - Live 0x0000000000000000
sata_sil 13539 4 - Live 0x0000000000000000
radeon 804372 1 - Live 0x0000000000000000
wmi 19256 0 - Live 0x0000000000000000
ttm 76949 1 radeon, Live 0x0000000000000000
drm_kms_helper 46978 1 radeon, Live 0x0000000000000000
drm 242038 3 radeon,ttm,drm_kms_helper, Live 0x0000000000000000
i2c_algo_bit 13423 1 radeon, Live 0x0000000000000000
r8169 62099 0 - Live 0x0000000000000000

I read on the other data which might be needed, but that is such a lot
and I don't know if it's really needed here for this example. If you
need it, let me know!

And yes I am quite sure this issue is reproducable. I have a second
motherboard in use plus a different CPU and the results are just the
same (faster due to faster CPU but the issue is still the same).

Thanks in advance,
Bjoern
