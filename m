Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751670Ab0FFGHX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jun 2010 02:07:23 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:64734 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751140Ab0FFGHV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jun 2010 02:07:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=qc0jNxvmKxanF/VexNG0RYEo7K9A/a7ciJmJaeOdvk9foS/KGLzn6hCM81dkaaotex
         e6Twv1iVcL3AV5ld3ktEXwHeS4gALt0+HTCG8b+P//T+XhP2/dvlfAb7Amz6cRM8hrP9
         OWdrdEDK37++RPWkucoEFB6CqvABMzzZUnz/o=
From: Maciej Rutecki <maciej.rutecki@gmail.com>
Reply-To: maciej.rutecki@gmail.com
To: armin walland <a.walland@focusmr.com>
Subject: Re: Ooops in BTRFS in 2.6.34 / x86_64 when mounting subvolume by name
Date: Sun, 6 Jun 2010 08:07:16 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34; KDE/4.3.4; i686; ; )
Cc: linux-kernel@vger.kernel.org
References: <201005271428.01239.a.walland@focusmr.com>
In-Reply-To: <201005271428.01239.a.walland@focusmr.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201006060807.16529.maciej.rutecki@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I created a Bugzilla entry at 
https://bugzilla.kernel.org/show_bug.cgi?id=16137
for your bug report, please add your address to the CC list in there, thanks!

On czwartek, 27 maja 2010 o 14:27:58 armin walland wrote:
> hi dearest kernel developers, i sent this email to chris mason about a week
> ago but didn't receive any reply so i don't know if it actually reached him
>  so i decided to sent it to the LKML to make sure it would not get lost:
> 
> 
> i would like to report to you an Ooops in btrfs when mounting a subvolume
>  by name. i tried to gather as much information as possible, if you want
>  any more information i will be happy to provide it.
> 
> i first encountered the crash on my hardware machine and i was also able to
> reproduce it on a virtualbox vm with which i compiled this report.
> 
> i started with a default arch linux x86_64 installation, then compiled a
> vanilla 2.6.34 kernel from kernel.org using /proc/config.gz as a basis. the
> only changes i made were to compile BTRFS static and not as a module. when
> installing i used xfs as root filesystem from where i could then copy the
>  data to the btrfs subvolume.
> 
> my goal is to have a btrfs filesystem with 2 subvolumes:
> v_root as the / filesystem
> v_home as the /home filesystem
> 
> reproduce:
> 
> ## get latest btrfs-progs
> [root@myhost ~]# uname -a
> Linux myhost 2.6.34-BREZEL #1 SMP PREEMPT Wed May 19 21:01:33 CEST 2010
>  x86_64 Intel(R) Xeon(R) CPU W3530 @ 2.80GHz GenuineIntel GNU/Linux
> [root@myhost ~]# cd /usr/src
> [root@myhost src]# git clone
> git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-progs-unstable.gi
> t Initialized empty Git repository in /usr/src/btrfs-progs-unstable/.git/
>  remote: Counting objects: 1794, done.
> remote: Compressing objects: 100% (687/687), done.
> remote: Total 1794 (delta 1355), reused 1418 (delta 1103)
> Receiving objects: 100% (1794/1794), 537.30 KiB, done.
> Resolving deltas: 100% (1355/1355), done.
> 
> -> make && make install
> 
> ## make the filesystem & subvolumes
> mkdir -p /mnt/bt01/
> [root@myhost ~]# mkfs.btrfs -L bt01 /dev/sda3
> WARNING! - Btrfs v0.19-16-g075587c-dirty IS EXPERIMENTAL
> WARNING! - see http://btrfs.wiki.kernel.org before using
> fs created label bt01 on /dev/sda3
>         nodesize 4096 leafsize 4096 sectorsize 4096 size 3.94GB
> Btrfs v0.19-16-g075587c-dirty
> [root@myhost ~]# mount /dev/sda3 /mnt/bt01/
> [root@myhost ~]# cd /mnt/bt01/
> [root@myhost bt01]# btrfsctl -S v_root .
> operation complete
> Btrfs v0.19-16-g075587c-dirty
> [root@myhost bt01]# btrfsctl -S v_home .
> operation complete
> Btrfs v0.19-16-g075587c-dirty
> 
> ## copy the data
> [root@myhost bt01]# cd /
> [root@myhost /]# find . -xdev | cpio -pv /mnt/bt01/v_root/
> [root@myhost ~]# cd /dev/
> [root@myhost ~]# find . -xdev | cpio -pv /mnt/bt01/v_root/dev/
> 
> 
> ## set the v_root subvolume as default subvolume
> [root@myhost ~]# btrfs subvol list /mnt/bt01/
> ID 256 top level 5 path v_root
> ID 257 top level 5 path v_home
> [root@myhost ~]# btrfs subvol set-default 256 /mnt/bt01/
> 
> ## prepare for reboot:
> [root@myhost ~]# umount /mnt/bt01/
> [root@myhost ~]# mount /dev/sda3 /mnt/bt01/
> [root@myhost ~]# vim /mnt/bt01/etc/fstab
> # change /
> [...]
> /dev/sda3 / btrfs defaults 0 1
> 
> [root@myhost ~]# vim /boot/grub/menu.lst
> # (0) Arch Linux BTRFS
> title  Arch Linux BTRFS
> root   (hd0,0)
> kernel /vmlinuz26-BREZEL root=/dev/sda3 ro vga=795
> initrd /kernel26-BREZEL.img
> 
> ## reboot
> [root@myhost ~]# reboot; exit
> 
> ## after reboot:  (looks fine)
> [root@myhost ~]# df -Th
> Filesystem    Type    Size  Used Avail Use% Mounted on
> /dev/sda3    btrfs    4.0G  1.2G  2.3G  34% /
> udev         tmpfs     10M  116K  9.9M   2% /dev
> shm          tmpfs    500M     0  500M   0% /dev/shm
> /dev/sda1     ext3    236M   33M  192M  15% /boot
> 
> ## now try to mount the second subvolume as /home with subvol=v_home
> [root@myhost ~]# mount -o subvol=v_home /dev/sda3 /home/
> mount: /dev/sda3 is not a valid block device
> [root@myhost ~]# 2010 May 21 14:31:04 myhost Oops: 0000 [#1] PREEMPT SMP
> 2010 May 21 14:31:04 myhost last sysfs file:
> /sys/devices/virtual/dmi/id/product_uuid
> 2010 May 21 14:31:04 myhost Stack:
> 2010 May 21 14:31:04 myhost Call Trace:
> 2010 May 21 14:31:04 myhost Code: 02 a8 35 00 48 c7 c7 6a c8 5a 81 31 c0 e8
>  f4 a7 35 00 eb a0 90 90 90 90 90 90 90 90 90 90 90 90 48 8b 87 a0 00 00 00
>  55 48 89 e5 <48> 8b 88 b8 02 00 00 8b 81 34 04 00 00 0f b7 91 5a 04 00 00
>  c9 2010 May 21 14:31:04 myhost CR2: 00000000000002b8
> 2010 May 21 14:31:12 myhost Oops: 0000 [#2] PREEMPT SMP
> 2010 May 21 14:31:12 myhost last sysfs file:
> /sys/devices/virtual/dmi/id/product_uuid
> 
> ########
> i attached 3 screenshots and ocr texts from 3 screens worth of stack trace,
>  i hope they can be helpful.
> ########
> 
> ----------
> REBOOT
> ----------
> 
> ## now do the same thing but use subvolid instead of subvol:
> [root@myhost ~]# btrfs subvolume list /
> ID 256 top level 5 path v_root
> ID 257 top level 5 path v_home
> [root@myhost ~]# mount -o subvolid=257 /dev/sda3 /home/
> [root@myhost ~]# df -Th
> Filesystem    Type    Size  Used Avail Use% Mounted on
> /dev/sda3    btrfs    4.0G  1.2G  2.3G  34% /
> udev         tmpfs     10M  116K  9.9M   2% /dev
> shm          tmpfs    500M     0  500M   0% /dev/shm
> /dev/sda1     ext3    236M   33M  192M  15% /boot
> /dev/sda3    btrfs    4.0G  1.2G  2.3G  34% /home
> 
> works perfectly.
> 
> please let me know if you need anything else and thanks a lot for this
> marvellous filesystem :)
> 

-- 
Maciej Rutecki
http://www.maciek.unixy.pl
