Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753610Ab1AZAFx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 19:05:53 -0500
Received: from ns.km10614-05.keymachine.de ([87.118.102.170]:53896 "EHLO
	km10614-05.keymachine.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751954Ab1AZAFv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 19:05:51 -0500
Date: Wed, 26 Jan 2011 01:05:43 +0100
From: Harald Braumann <harry@unheit.net>
To: Neil Brown <neilb@suse.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Deadlock on concurrent remount-ro and mdadm --stop (2.6.37)
Message-ID: <20110126000543.GA13776@nn.nn>
Mail-Followup-To: Harald Braumann <harry@unheit.net>,
	Neil Brown <neilb@suse.de>, linux-kernel@vger.kernel.org
References: <20110121124754.GA5233@nn.nn>
 <20110123161500.GB4108@nn.nn>
 <20110125085758.06df5e3e@nbeee.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110125085758.06df5e3e@nbeee.brown>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 25, 2011 at 08:57:58AM +1000, Neil Brown wrote:
> Thanks for the bug report.
> Extra useful details would include:
>  cat /proc/mdstat
>  cat /proc/mounts
> 
> i.e. what is the exact configuration of the RAID or RAIDs, and where
> are they mounted.

I've included the output of Debian's mdadm bug reporting script (see
below). It should give quite concise information about the
configuration.

I've had one more lockup in the meantime, but again no luck with
sysrq.

Cheers,
harry

--- mdadm.conf
DEVICE partitions
CREATE owner=root group=disk mode=0660 auto=yes
HOMEHOST <system>
MAILADDR root

--- /etc/default/mdadm
INITRDSTART='all'
AUTOSTART=true
AUTOCHECK=false
START_DAEMON=true
VERBOSE=false

--- /proc/mdstat:
Personalities : [raid1] [raid6] [raid5] [raid4] 
md126 : active raid5 sda2[0] sdc2[3] sdb2[1]
      3905975296 blocks super 1.2 level 5, 512k chunk, algorithm 2 [3/3] [UUU]
      bitmap: 1/15 pages [4KB], 65536KB chunk

md127 : active raid1 sda1[0] sdc1[3] sdb1[1]
      524276 blocks super 1.0 [3/3] [UUU]
      
unused devices: <none>

--- /proc/partitions:
major minor  #blocks  name

   8        0 1953514584 sda
   8        1     524288 sda1
   8        2 1952989272 sda2
   8       16 1953514584 sdb
   8       17     524288 sdb1
   8       18 1952989272 sdb2
   8       32 1953514584 sdc
   8       33     524288 sdc1
   8       34 1952989272 sdc2
   9      127     524276 md127
   9      126 3905975296 md126
 253        0  209715200 dm-0
 253        1 2671771648 dm-1
 253        2   10485760 dm-2
 253        3 2671769600 dm-3
 253        4   15728640 dm-4
 253        5   20971520 dm-5
 253        6   15728640 dm-6
 253        7   73400320 dm-7
 253        8 2227175424 dm-8
 253        9   10485760 dm-9
 253       10   10485760 dm-10
 253       11  209713152 dm-11

--- LVM physical volumes:
  PV         VG              Fmt  Attr PSize PFree  
  /dev/dm-3  vg_hausfrau     lvm2 a-   2,49t 284,00g
  /dev/md126 vg_hausfrau_raw lvm2 a-   3,64t 967,03g
--- mount output
/dev/mapper/vg_hausfrau-lv_root on / type ext4 (rw,errors=remount-ro)
tmpfs on /lib/init/rw type tmpfs (rw,nosuid,mode=0755)
proc on /proc type proc (rw,noexec,nosuid,nodev)
sysfs on /sys type sysfs (rw,noexec,nosuid,nodev)
udev on /dev type tmpfs (rw,mode=0755)
tmpfs on /dev/shm type tmpfs (rw,nosuid,nodev)
devpts on /dev/pts type devpts (rw,noexec,nosuid,gid=5,mode=620)
/dev/md127 on /boot type ext2 (rw)
/dev/mapper/vg_hausfrau-lv_tmp on /tmp type tmpfs (rw,nosuid,nodev)
/dev/mapper/vg_hausfrau-lv_var on /var type ext4 (rw)
/dev/mapper/vg_hausfrau-lv_home on /home type ext4 (rw)
/dev/mapper/vg_hausfrau-lv_vm on /var/local/vm type ext4 (rw)
/dev/mapper/vg_hausfrau-lv_data on /var/local/data type ext4 (rw,noexec,nosuid,nodev)
/dev/mapper/harry_clear on /home/harry type ext4 (rw)
debugfs on /sys/kernel/debug type debugfs (rw)
rpc_pipefs on /var/lib/nfs/rpc_pipefs type rpc_pipefs (rw)
fusectl on /sys/fs/fuse/connections type fusectl (rw)
nfsd on /proc/fs/nfsd type nfsd (rw)

--- initrd.img-2.6.37-hb:
67158 blocks
023a0931613d9e24824d55740ee88705  ./etc/mdadm/mdadm.conf
1625745d98382941a5667e4dc82556b9  ./lib/modules/2.6.37-hb/kernel/drivers/md/dm-mod.ko
0b62f233f29325947911106794e7ea39  ./lib/modules/2.6.37-hb/kernel/drivers/md/dm-crypt.ko
7d4d97a22d69ce89ad74009ffc0d570c  ./lib/modules/2.6.37-hb/kernel/drivers/md/dm-snapshot.ko
d4da8c2c4cc16e9e6cb0ad652e30f8cb  ./lib/modules/2.6.37-hb/kernel/drivers/md/dm-log.ko
212222bc936bb9141d9632f17cf1a752  ./lib/modules/2.6.37-hb/kernel/drivers/md/dm-region-hash.ko
8818bcd8efc23a8bbc94faf4c3ad29ed  ./lib/modules/2.6.37-hb/kernel/drivers/md/dm-mirror.ko
5e1c57581135f9cc003beb1340136c6e  ./lib/modules/2.6.37-hb/kernel/drivers/md/md-mod.ko
f660d2194c8ce6ff70e443002bcff391  ./lib/modules/2.6.37-hb/kernel/drivers/md/linear.ko
98f3b725335166f45aedd7222c0e89c8  ./lib/modules/2.6.37-hb/kernel/drivers/md/multipath.ko
fac69440da2c3d53aaa711b00f09179e  ./lib/modules/2.6.37-hb/kernel/drivers/md/raid0.ko
48cd65affcb21546c8a06aac0d0d1dcd  ./lib/modules/2.6.37-hb/kernel/drivers/md/raid1.ko
e6eb0135620891f2bd788cacee610cb5  ./lib/modules/2.6.37-hb/kernel/drivers/md/raid456.ko
2896a7b96807428ef946bcda25082332  ./lib/modules/2.6.37-hb/kernel/drivers/md/raid10.ko
06a6acbd64ad4e9dafdfb62347bd7f84  ./sbin/mdadm
f4fbd9099399ab08ba9b9f6c71d77595  ./scripts/local-top/mdadm

--- initrd's /conf/conf.d/md:
MD_HOMEHOST='hausfrau'
MD_DEVPAIRS='/dev/md/boot:raid1 /dev/md/system:raid5'
MD_LEVELS='raid1 raid5'
MD_DEVS=all
MD_MODULES='raid1 raid456'

--- /proc/modules:
dm_crypt 10303 2 - Live 0xffffffffa0374000
dm_mod 55459 35 dm_crypt, Live 0xffffffffa035b000
raid456 44324 1 - Live 0xffffffffa0349000
async_raid6_recov 4803 1 raid456, Live 0xffffffffa0342000
async_pq 3263 2 raid456,async_raid6_recov, Live 0xffffffffa033c000
raid6_pq 77179 2 async_raid6_recov,async_pq, Live 0xffffffffa0323000
async_xor 2209 3 raid456,async_raid6_recov,async_pq, Live 0xffffffffa031d000
async_memcpy 1222 2 raid456,async_raid6_recov, Live 0xffffffffa0310000
async_tx 1742 5 raid456,async_raid6_recov,async_pq,async_xor,async_memcpy, Live 0xffffffffa030a000
raid1 18065 1 - Live 0xffffffffa02ff000
md_mod 79679 4 raid456,raid1, Live 0xffffffffa02e0000

--- /var/log/syslog:

--- volume detail:
/dev/sda is not recognised by mdadm.
/dev/sda1:
          Magic : a92b4efc
        Version : 1.0
    Feature Map : 0x0
     Array UUID : bc81d9f7:82254925:60de4ee5:0da97039
           Name : hausfrau:boot  (local to host hausfrau)
  Creation Time : Fri Jan  7 21:54:10 2011
     Raid Level : raid1
   Raid Devices : 3

 Avail Dev Size : 1048552 (512.07 MiB 536.86 MB)
     Array Size : 1048552 (512.07 MiB 536.86 MB)
   Super Offset : 1048560 sectors
          State : clean
    Device UUID : 930ea19c:d6b8eb82:cc772846:af49ee7a

    Update Time : Tue Jan 25 17:44:42 2011
       Checksum : b7d3b93a - correct
         Events : 60


   Device Role : Active device 0
   Array State : AAA ('A' == active, '.' == missing)
--
/dev/sda2:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : 0a2ef562:31107259:8fe9b719:29d2266f
           Name : hausfrau:system  (local to host hausfrau)
  Creation Time : Fri Jan  7 20:49:46 2011
     Raid Level : raid5
   Raid Devices : 3

 Avail Dev Size : 3905976496 (1862.51 GiB 1999.86 GB)
     Array Size : 7811950592 (3725.03 GiB 3999.72 GB)
  Used Dev Size : 3905975296 (1862.51 GiB 1999.86 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : active
    Device UUID : b3b81bbe:05a34cd8:42ec5205:69111266

Internal Bitmap : 2 sectors from superblock
    Update Time : Wed Jan 26 00:57:09 2011
       Checksum : b84a669e - correct
         Events : 19604

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 0
   Array State : AAA ('A' == active, '.' == missing)
--
/dev/sdb is not recognised by mdadm.
/dev/sdb1:
          Magic : a92b4efc
        Version : 1.0
    Feature Map : 0x0
     Array UUID : bc81d9f7:82254925:60de4ee5:0da97039
           Name : hausfrau:boot  (local to host hausfrau)
  Creation Time : Fri Jan  7 21:54:10 2011
     Raid Level : raid1
   Raid Devices : 3

 Avail Dev Size : 1048552 (512.07 MiB 536.86 MB)
     Array Size : 1048552 (512.07 MiB 536.86 MB)
   Super Offset : 1048560 sectors
          State : clean
    Device UUID : 3f9bb12c:115879ab:e5028915:fc4ec219

    Update Time : Tue Jan 25 17:44:42 2011
       Checksum : dea67587 - correct
         Events : 60


   Device Role : Active device 1
   Array State : AAA ('A' == active, '.' == missing)
--
/dev/sdb2:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : 0a2ef562:31107259:8fe9b719:29d2266f
           Name : hausfrau:system  (local to host hausfrau)
  Creation Time : Fri Jan  7 20:49:46 2011
     Raid Level : raid5
   Raid Devices : 3

 Avail Dev Size : 3905976496 (1862.51 GiB 1999.86 GB)
     Array Size : 7811950592 (3725.03 GiB 3999.72 GB)
  Used Dev Size : 3905975296 (1862.51 GiB 1999.86 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : active
    Device UUID : e4748d6f:cad12a56:1b2a5f3a:5c04ac7d

Internal Bitmap : 2 sectors from superblock
    Update Time : Wed Jan 26 00:57:09 2011
       Checksum : 34408261 - correct
         Events : 19604

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 1
   Array State : AAA ('A' == active, '.' == missing)
--
/dev/sdc is not recognised by mdadm.
/dev/sdc1:
          Magic : a92b4efc
        Version : 1.0
    Feature Map : 0x0
     Array UUID : bc81d9f7:82254925:60de4ee5:0da97039
           Name : hausfrau:boot  (local to host hausfrau)
  Creation Time : Fri Jan  7 21:54:10 2011
     Raid Level : raid1
   Raid Devices : 3

 Avail Dev Size : 1048552 (512.07 MiB 536.86 MB)
     Array Size : 1048552 (512.07 MiB 536.86 MB)
   Super Offset : 1048560 sectors
          State : clean
    Device UUID : 61cec5d6:be8928bb:23d23c1d:a8d2c1a8

    Update Time : Tue Jan 25 17:44:42 2011
       Checksum : 2f1d2d44 - correct
         Events : 60


   Device Role : Active device 2
   Array State : AAA ('A' == active, '.' == missing)
--
/dev/sdc2:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : 0a2ef562:31107259:8fe9b719:29d2266f
           Name : hausfrau:system  (local to host hausfrau)
  Creation Time : Fri Jan  7 20:49:46 2011
     Raid Level : raid5
   Raid Devices : 3

 Avail Dev Size : 3905976496 (1862.51 GiB 1999.86 GB)
     Array Size : 7811950592 (3725.03 GiB 3999.72 GB)
  Used Dev Size : 3905975296 (1862.51 GiB 1999.86 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : active
    Device UUID : 174c216f:4016b4a5:1aa93f50:b74cbbdd

Internal Bitmap : 2 sectors from superblock
    Update Time : Wed Jan 26 00:57:09 2011
       Checksum : f94d6566 - correct
         Events : 19604

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 2
   Array State : AAA ('A' == active, '.' == missing)
--

--- /proc/cmdline
BOOT_IMAGE=/vmlinuz-2.6.37-hb root=/dev/mapper/vg_hausfrau-lv_root ro resume=/dev/vg_hausfrau/lv_swap no_console_suspend resume=/dev/vg_hausfrau/lv_swap no_console_suspend

--- grub2:
insmod raid
set root='(md/boot)'
insmod raid
set root='(md/boot)'
	insmod raid
	set root='(md/boot)'
	linux	/vmlinuz-2.6.37-hb root=/dev/mapper/vg_hausfrau-lv_root ro resume=/dev/vg_hausfrau/lv_swap no_console_suspend resume=/dev/vg_hausfrau/lv_swap no_console_suspend
	insmod raid
	set root='(md/boot)'
	linux	/vmlinuz-2.6.37-hb root=/dev/mapper/vg_hausfrau-lv_root ro single resume=/dev/vg_hausfrau/lv_swap no_console_suspend
	insmod raid
	set root='(md/boot)'
	insmod raid
	set root='(md/boot)'
	insmod raid
	set root='(md/boot)'
	insmod raid
	set root='(md/boot)'

--- udev:
ii  udev           164-3          /dev/ and hotplug management daemon
4a574fcd059040d33ea18a8aa605a184  /lib/udev/rules.d/64-md-raid.rules

--- /dev:
brw-rw---- 1 root disk 9, 126 2011-01-25 17:44 /dev/md126
brw-rw---- 1 root disk 9, 127 2011-01-25 17:44 /dev/md127

/dev/disk/by-id:
total 0
lrwxrwxrwx 1 root root  9 2011-01-25 17:44 ata-WDC_WD20EARS-00MVWB0_WD-WMAZA3098999 -> ../../sda
lrwxrwxrwx 1 root root 10 2011-01-25 17:44 ata-WDC_WD20EARS-00MVWB0_WD-WMAZA3098999-part1 -> ../../sda1
lrwxrwxrwx 1 root root 10 2011-01-25 17:44 ata-WDC_WD20EARS-00MVWB0_WD-WMAZA3098999-part2 -> ../../sda2
lrwxrwxrwx 1 root root  9 2011-01-25 17:44 ata-WDC_WD20EARS-00MVWB0_WD-WMAZA3122350 -> ../../sdc
lrwxrwxrwx 1 root root 10 2011-01-25 17:44 ata-WDC_WD20EARS-00MVWB0_WD-WMAZA3122350-part1 -> ../../sdc1
lrwxrwxrwx 1 root root 10 2011-01-25 17:44 ata-WDC_WD20EARS-00MVWB0_WD-WMAZA3122350-part2 -> ../../sdc2
lrwxrwxrwx 1 root root  9 2011-01-25 17:44 ata-WDC_WD20EARS-00MVWB0_WD-WMAZA3177709 -> ../../sdb
lrwxrwxrwx 1 root root 10 2011-01-25 17:44 ata-WDC_WD20EARS-00MVWB0_WD-WMAZA3177709-part1 -> ../../sdb1
lrwxrwxrwx 1 root root 10 2011-01-25 17:44 ata-WDC_WD20EARS-00MVWB0_WD-WMAZA3177709-part2 -> ../../sdb2
lrwxrwxrwx 1 root root 11 2011-01-25 17:44 dm-name-harry_clear -> ../../dm-11
lrwxrwxrwx 1 root root 10 2011-01-25 17:44 dm-name-hausfrau_clear -> ../../dm-3
lrwxrwxrwx 1 root root 10 2011-01-25 17:44 dm-name-vg_hausfrau-lv_data -> ../../dm-8
lrwxrwxrwx 1 root root 11 2011-01-25 17:44 dm-name-vg_hausfrau-lv_home -> ../../dm-10
lrwxrwxrwx 1 root root 10 2011-01-25 17:44 dm-name-vg_hausfrau-lv_root -> ../../dm-5
lrwxrwxrwx 1 root root 10 2011-01-25 17:44 dm-name-vg_hausfrau-lv_swap -> ../../dm-4
lrwxrwxrwx 1 root root 10 2011-01-25 17:44 dm-name-vg_hausfrau-lv_tmp -> ../../dm-9
lrwxrwxrwx 1 root root 10 2011-01-25 17:44 dm-name-vg_hausfrau-lv_var -> ../../dm-6
lrwxrwxrwx 1 root root 10 2011-01-25 17:44 dm-name-vg_hausfrau-lv_vm -> ../../dm-7
lrwxrwxrwx 1 root root 10 2011-01-25 17:44 dm-name-vg_hausfrau_raw-lv_harry_crypt -> ../../dm-0
lrwxrwxrwx 1 root root 10 2011-01-25 17:44 dm-name-vg_hausfrau_raw-lv_hausfrau_crypt -> ../../dm-1
lrwxrwxrwx 1 root root 10 2011-01-25 17:44 dm-name-vg_hausfrau_raw-lv_test -> ../../dm-2
lrwxrwxrwx 1 root root 10 2011-01-25 17:44 dm-uuid-CRYPT-LUKS1-4f2f3ddfd8294b4da748aee417c1da00-hausfrau_clear -> ../../dm-3
lrwxrwxrwx 1 root root 11 2011-01-25 17:44 dm-uuid-CRYPT-LUKS1-c19136db409b494ea89931e4e6f9863e-harry_clear_unformatted -> ../../dm-11
lrwxrwxrwx 1 root root 10 2011-01-25 17:44 dm-uuid-LVM-62OpijodUQGb53MakeIg5G90M1zLCHBw4OCsdRMNd52Soy2tSNHlgAJqBql4xO3o -> ../../dm-5
lrwxrwxrwx 1 root root 11 2011-01-25 17:44 dm-uuid-LVM-62OpijodUQGb53MakeIg5G90M1zLCHBwCNUqbZLco9chBTCleNEYAn1sHwdbRDIQ -> ../../dm-10
lrwxrwxrwx 1 root root 10 2011-01-25 17:44 dm-uuid-LVM-62OpijodUQGb53MakeIg5G90M1zLCHBwMgvTJ115C6k3xN5D02mqXng0vmuPwex9 -> ../../dm-6
lrwxrwxrwx 1 root root 10 2011-01-25 17:44 dm-uuid-LVM-62OpijodUQGb53MakeIg5G90M1zLCHBwqJtDR3l5Jd5WneucyD9aLcJFB9T8grWy -> ../../dm-9
lrwxrwxrwx 1 root root 10 2011-01-25 17:44 dm-uuid-LVM-62OpijodUQGb53MakeIg5G90M1zLCHBwTtquQHFbdJCg5THe23ckYT5x5q4jcSJr -> ../../dm-8
lrwxrwxrwx 1 root root 10 2011-01-25 17:44 dm-uuid-LVM-62OpijodUQGb53MakeIg5G90M1zLCHBwus1RoWZ80dQpKwh736k1r2Ymsz0H0b7B -> ../../dm-7
lrwxrwxrwx 1 root root 10 2011-01-25 17:44 dm-uuid-LVM-62OpijodUQGb53MakeIg5G90M1zLCHBwYvneUOpYDdxLuF5uO9t9cDp73y8q2Rmd -> ../../dm-4
lrwxrwxrwx 1 root root 10 2011-01-25 17:44 dm-uuid-LVM-jeEt9SF7ZoVppf1beEckaa7fWWn7qqTj37bSE81k7aSDnlWAesRWN7EE3dDbfVY8 -> ../../dm-1
lrwxrwxrwx 1 root root 10 2011-01-25 17:44 dm-uuid-LVM-jeEt9SF7ZoVppf1beEckaa7fWWn7qqTjbV9VpcTtuIo85wxQMNA0R8S5W3jDJ17u -> ../../dm-0
lrwxrwxrwx 1 root root 10 2011-01-25 17:44 dm-uuid-LVM-jeEt9SF7ZoVppf1beEckaa7fWWn7qqTjLrKJjy1vmBuimJUUidjw3LJCPbcZOTXp -> ../../dm-2
lrwxrwxrwx 1 root root 11 2011-01-25 17:44 md-name-hausfrau:boot -> ../../md127
lrwxrwxrwx 1 root root 11 2011-01-25 17:44 md-name-hausfrau:system -> ../../md126
lrwxrwxrwx 1 root root 11 2011-01-25 17:44 md-uuid-0a2ef562:31107259:8fe9b719:29d2266f -> ../../md126
lrwxrwxrwx 1 root root 11 2011-01-25 17:44 md-uuid-bc81d9f7:82254925:60de4ee5:0da97039 -> ../../md127
lrwxrwxrwx 1 root root  9 2011-01-25 17:44 scsi-SATA_WDC_WD20EARS-00_WD-WMAZA3098999 -> ../../sda
lrwxrwxrwx 1 root root 10 2011-01-25 17:44 scsi-SATA_WDC_WD20EARS-00_WD-WMAZA3098999-part1 -> ../../sda1
lrwxrwxrwx 1 root root 10 2011-01-25 17:44 scsi-SATA_WDC_WD20EARS-00_WD-WMAZA3098999-part2 -> ../../sda2
lrwxrwxrwx 1 root root  9 2011-01-25 17:44 scsi-SATA_WDC_WD20EARS-00_WD-WMAZA3122350 -> ../../sdc
lrwxrwxrwx 1 root root 10 2011-01-25 17:44 scsi-SATA_WDC_WD20EARS-00_WD-WMAZA3122350-part1 -> ../../sdc1
lrwxrwxrwx 1 root root 10 2011-01-25 17:44 scsi-SATA_WDC_WD20EARS-00_WD-WMAZA3122350-part2 -> ../../sdc2
lrwxrwxrwx 1 root root  9 2011-01-25 17:44 scsi-SATA_WDC_WD20EARS-00_WD-WMAZA3177709 -> ../../sdb
lrwxrwxrwx 1 root root 10 2011-01-25 17:44 scsi-SATA_WDC_WD20EARS-00_WD-WMAZA3177709-part1 -> ../../sdb1
lrwxrwxrwx 1 root root 10 2011-01-25 17:44 scsi-SATA_WDC_WD20EARS-00_WD-WMAZA3177709-part2 -> ../../sdb2
lrwxrwxrwx 1 root root  9 2011-01-25 17:44 wwn-0x50014ee6ab6758c9 -> ../../sdb
lrwxrwxrwx 1 root root 10 2011-01-25 17:44 wwn-0x50014ee6ab6758c9-part1 -> ../../sdb1
lrwxrwxrwx 1 root root 10 2011-01-25 17:44 wwn-0x50014ee6ab6758c9-part2 -> ../../sdb2
lrwxrwxrwx 1 root root  9 2011-01-25 17:44 wwn-0x50014ee6ab67669b -> ../../sda
lrwxrwxrwx 1 root root 10 2011-01-25 17:44 wwn-0x50014ee6ab67669b-part1 -> ../../sda1
lrwxrwxrwx 1 root root 10 2011-01-25 17:44 wwn-0x50014ee6ab67669b-part2 -> ../../sda2
lrwxrwxrwx 1 root root  9 2011-01-25 17:44 wwn-0x50014ee6ab67670d -> ../../sdc
lrwxrwxrwx 1 root root 10 2011-01-25 17:44 wwn-0x50014ee6ab67670d-part1 -> ../../sdc1
lrwxrwxrwx 1 root root 10 2011-01-25 17:44 wwn-0x50014ee6ab67670d-part2 -> ../../sdc2

/dev/disk/by-label:
total 0
lrwxrwxrwx 1 root root 11 2011-01-25 17:44 SYSBOOT -> ../../md127

/dev/disk/by-path:
total 0
lrwxrwxrwx 1 root root  9 2011-01-25 17:44 pci-0000:00:12.0-scsi-0:0:0:0 -> ../../sda
lrwxrwxrwx 1 root root 10 2011-01-25 17:44 pci-0000:00:12.0-scsi-0:0:0:0-part1 -> ../../sda1
lrwxrwxrwx 1 root root 10 2011-01-25 17:44 pci-0000:00:12.0-scsi-0:0:0:0-part2 -> ../../sda2
lrwxrwxrwx 1 root root  9 2011-01-25 17:44 pci-0000:00:12.0-scsi-1:0:0:0 -> ../../sdb
lrwxrwxrwx 1 root root 10 2011-01-25 17:44 pci-0000:00:12.0-scsi-1:0:0:0-part1 -> ../../sdb1
lrwxrwxrwx 1 root root 10 2011-01-25 17:44 pci-0000:00:12.0-scsi-1:0:0:0-part2 -> ../../sdb2
lrwxrwxrwx 1 root root  9 2011-01-25 17:44 pci-0000:00:12.0-scsi-2:0:0:0 -> ../../sdc
lrwxrwxrwx 1 root root 10 2011-01-25 17:44 pci-0000:00:12.0-scsi-2:0:0:0-part1 -> ../../sdc1
lrwxrwxrwx 1 root root 10 2011-01-25 17:44 pci-0000:00:12.0-scsi-2:0:0:0-part2 -> ../../sdc2

/dev/disk/by-uuid:
total 0
lrwxrwxrwx 1 root root 11 2011-01-25 17:44 09629552-71db-466a-b54b-a88181dd4e96 -> ../../dm-10
lrwxrwxrwx 1 root root 11 2011-01-25 17:44 323c78aa-3be8-4a90-8caf-7be64e819f66 -> ../../md127
lrwxrwxrwx 1 root root 10 2011-01-25 17:44 4f2f3ddf-d829-4b4d-a748-aee417c1da00 -> ../../dm-1
lrwxrwxrwx 1 root root 10 2011-01-25 17:44 533bbed6-61f7-4c5b-b3f2-c9bfe93bc979 -> ../../dm-5
lrwxrwxrwx 1 root root 10 2011-01-25 17:44 588ea9fe-c73f-414a-b1ee-30c41c929b4d -> ../../dm-8
lrwxrwxrwx 1 root root 10 2011-01-25 17:44 7f597aef-dcd0-49b3-a510-8c29b39c3178 -> ../../dm-9
lrwxrwxrwx 1 root root 10 2011-01-25 17:44 905d6dc6-6800-4f09-8bff-836264a19832 -> ../../dm-2
lrwxrwxrwx 1 root root 11 2011-01-25 17:44 a0d8975b-3c37-4e99-9799-e50c65d797bc -> ../../dm-11
lrwxrwxrwx 1 root root 10 2011-01-25 17:44 a5de564c-90d4-450a-9153-36738806cc4c -> ../../dm-6
lrwxrwxrwx 1 root root 10 2011-01-25 17:44 b7aadd8a-ea5c-4cc2-88f2-ca86a01f757f -> ../../dm-4
lrwxrwxrwx 1 root root 10 2011-01-25 17:44 bb1392bc-d5a3-486f-919f-b351f233dbc1 -> ../../dm-7
lrwxrwxrwx 1 root root 10 2011-01-25 17:44 c19136db-409b-494e-a899-31e4e6f9863e -> ../../dm-0

/dev/md:
total 0
lrwxrwxrwx 1 root root 8 2011-01-25 17:44 boot -> ../md127
lrwxrwxrwx 1 root root 8 2011-01-25 17:44 system -> ../md126

Auto-generated on Wed, 26 Jan 2011 00:57:09 +0100
by mdadm bugscript 3.1.4-1+8efb9d1
