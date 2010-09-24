Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754291Ab0IXAYc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 20:24:32 -0400
Received: from mailgw01.dd24.net ([193.46.215.41]:57533 "EHLO
	mailgw01.dd24.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753032Ab0IXAYb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 20:24:31 -0400
X-Greylist: delayed 548 seconds by postgrey-1.27 at vger.kernel.org; Thu, 23 Sep 2010 20:24:30 EDT
MIME-Version: 1.0
Date: Fri, 24 Sep 2010 00:15:11 +0000
From: Christoph Anton Mitterer <calestyo@scientia.net>
To: <linux-kernel@vger.kernel.org>
Subject: strange fs corruptions when doing:
 virtualbox-image->fuse->losetup->lvm->ext3/4 (on dm-crypted fs)
Message-ID: <e49481bcdbe21ffbf2184574955f3a5c@imap.dd24.net>
User-Agent: RoundCube Webmail/0.3.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

I seem to have found some very strange problem:

Using the following system setup:
- Debian sid, except the kernel which is version 2.6.35-1~experimental.3
from experimental using a custom .config (can send in case you need).
- The system itself is fully encrypted with dm-crypt/LUKS (booting from an
USB stick), on top of it an ext4 filesystem with that Debian.

Under that Debian I've installed VirtualBox and created 4 Debian template
images, I'm going to use for server installations in the faculty
(amd64/i386 each with stable/unstable Debian).
The images are on the (dm-crypted) ext4, using the dynamic vdi format.
Each Image itself has a msdos parition table, with one partition (sda1)
and bootlader in MBR (sda).
sda1 (inside the images) are used as LVM PV with, belonging to some VG,
providing a LV which contains the root-fs for the images.
As filesystem I've used ext3 (on the stable Debians) and ext4 (on the
unstables).

Inside the VirtualBox, everything seems to be fine (especially the file
user/group owner seem to be correct, see later).


I then wanted to actually deploy the image on one server and did the
following:
- stopped the VMs
- extracted the contents of the image using virtualbox-ose-fuse):
# vdfuse -r -f image.vdi tmp/
# ls tmp/
EntireDisk  Partition1
# losetup -f tmp/Partition1
# vgchange -ay
# mount /dev/vg_system/root img/
- looking around in the filesystem, e.g. creating a tarball of it or so
# ls img/var/lib


With ext3 I get the following kernel messages:
[  510.357266] EXT3-fs: barriers not enabled
[  510.370686] Buffer I/O error on device dm-1, logical block 0
[  510.370960] lost page write due to I/O error on dm-1
[  510.371214] EXT3-fs (dm-1): using internal journal
[  510.371778] EXT3-fs (dm-1): mounted filesystem with ordered data mode
[  510.372678] kjournald starting.  Commit interval 5 seconds
[  530.720143] Buffer I/O error on device dm-1, logical block 1245698
[  530.720537] lost page write due to I/O error on dm-1
[  530.720881] Aborting journal on device dm-1.
[  530.721159] ------------[ cut here ]------------
[  530.721477] WARNING: at fs/buffer.c:1151 mark_buffer_dirty+0x74/0x90()
[  530.721788] Hardware name: LIFEBOOK E8410
[  530.722069] Modules linked in: ext3 jbd cpufreq_stats fuse nvidia(P)
btusb bluetooth joydev pcmcia sdhci_pci sdhci yenta_socket serio_raw
pcmcia_rsrc mmc_core pcmcia_core irda ata_generic crc_ccitt tpm_tis tpm
ata_piix tpm_bios btrfs crc32c libcrc32c
[  530.727494] Pid: 4951, comm: kjournald Tainted: P           
2.6.35-heisenberg #1
[  530.727865] Call Trace:
[  530.728159]  [<ffffffff81047d8b>] ? warn_slowpath_common+0x7b/0xc0
[  530.728478]  [<ffffffff8113fe34>] ? mark_buffer_dirty+0x74/0x90
[  530.728767]  [<ffffffffa008f822>] ? journal_update_superblock+0x82/0xf0
[jbd]
[  530.729069]  [<ffffffffa008fa31>] ? __journal_abort_soft+0xb1/0xf0
[jbd]
[  530.729402]  [<ffffffffa0091318>] ? journal_put_journal_head+0xb8/0x110
[jbd]
[  530.729696]  [<ffffffffa008c67e>] ?
journal_commit_transaction+0xa4e/0x12f0 [jbd]
[  530.730094]  [<ffffffff81057183>] ? lock_timer_base+0x33/0x70
[  530.730418]  [<ffffffff81057eb6>] ? try_to_del_timer_sync+0x76/0xf0
[  530.730709]  [<ffffffffa0090681>] ? kjournald+0xe1/0x230 [jbd]
[  530.730988]  [<ffffffff81066bd0>] ? autoremove_wake_function+0x0/0x30
[  530.731291]  [<ffffffffa00905a0>] ? kjournald+0x0/0x230 [jbd]
[  530.731606]  [<ffffffffa00905a0>] ? kjournald+0x0/0x230 [jbd]
[  530.731902]  [<ffffffff8106663e>] ? kthread+0x8e/0xa0
[  530.732200]  [<ffffffff81003d14>] ? kernel_thread_helper+0x4/0x10
[  530.732519]  [<ffffffff810665b0>] ? kthread+0x0/0xa0
[  530.732801]  [<ffffffff81003d10>] ? kernel_thread_helper+0x0/0x10
[  530.733100] ---[ end trace 6bd8a0673ff77673 ]---
[  530.733436] Buffer I/O error on device dm-1, logical block 1245698
[  530.733719] lost page write due to I/O error on dm-1
[  557.994085] EXT3-fs (dm-1): error: ext3_journal_start_sb: Detected
aborted journal
[  557.994856] EXT3-fs (dm-1): error: remounting filesystem read-only
[  578.223552] EXT3-fs (dm-1): error: ext3_put_super: Couldn't clean up
the journal
(point where I unmounted img/)


With ext4:
Sep 24 02:03:50 heisenberg kernel: [ 1869.089309] Buffer I/O error on
device dm-1, logical block 0
Sep 24 02:03:50 heisenberg kernel: [ 1869.089313] lost page write due to
I/O error on dm-1
Sep 24 02:03:50 heisenberg kernel: [ 1869.089684] EXT4-fs (dm-1): mounted
filesystem with ordered data mode. Opts: (null)
Sep 24 02:04:23 heisenberg kernel: [ 1902.720137] Buffer I/O error on
device dm-1, logical block 1081344
Sep 24 02:04:23 heisenberg kernel: [ 1902.720146] lost page write due to
I/O error on dm-1
Sep 24 02:04:23 heisenberg kernel: [ 1902.720152] JBD2: I/O error detected
when updating journal superblock for dm-1-8.
Sep 24 02:04:23 heisenberg kernel: [ 1902.720231] Aborting journal on
device dm-1-8.
Sep 24 02:04:23 heisenberg kernel: [ 1902.720240] Buffer I/O error on
device dm-1, logical block 1081344
Sep 24 02:04:23 heisenberg kernel: [ 1902.720245] lost page write due to
I/O error on dm-1
Sep 24 02:04:23 heisenberg kernel: [ 1902.720249] JBD2: I/O error detected
when updating journal superblock for dm-1-8.
Sep 24 02:04:50 heisenberg kernel: [ 1929.144344] EXT4-fs error (device
dm-1): ext4_put_super: Couldn't clean up the journal
Sep 24 02:04:50 heisenberg kernel: [ 1929.144357] EXT4-fs (dm-1):
Remounting filesystem read-only
(point where I unmounted img/)


An interesting effect is, that the file-data seems to be correct (well at
least an image made of a tarball created from img/ booted), but (at least)
the user/group owners get corrupted:
Take an excerpt from ls -al img/var/lib
drwxrwsr-x  2 libuuid    crontab    4,1k Aug  8  2009 libuuid
drwxr-xr-x  3 root       root       4,1k Aug 10  2009 libxml-sax-perl
drwxrwx---  2 privoxy    Debian-gdm 4,1k Sep 22 16:44 logcheck
drwxr-xr-x  2 root       root       4,1k Aug 10  2009 logrotate
drwxr-xr-x  2 root       root       4,1k Sep 21 12:03 mdadm
drwxr-xr-x  2 root       root       4,1k Feb  6  2010 misc
drwxr-xr-x  2 root       root       4,1k Feb  9  2010 mlocate
drwxr-xr-x  2 root       root       4,1k Sep 20 15:20 msttcorefonts
drwxr-xr-x  5 ntp        root       4,1k Aug 10  2009 nfs
drwxr-xr-x  2 clamav     ssh        4,1k Sep 22 16:16 ntp
drwxr-xr-x  2 root       root       4,1k Jun 12  2009 ntpdate
drwxr-xr-x  2 root       root       4,1k Sep 21 11:30 pam
drwx------  3 root       root       4,1k Feb  6  2010 polkit-1
drwxr-xr-x  2 messagebus ssl-cert   4,1k Aug 11  2009 postfix

This should read about like that (and the user/group are correct from
inside the VirtualBox):
drwxrwsr-x  2 libuuid    libuuid    4,1k Aug  8  2009 libuuid
drwxr-xr-x  3 root       root       4,1k Aug 10  2009 libxml-sax-perl
drwxrwx---  2 logcheck   logcheck   4,1k Sep 22 16:44 logcheck
drwxr-xr-x  2 root       root       4,1k Aug 10  2009 logrotate
drwxr-xr-x  2 root       root       4,1k Sep 21 12:03 mdadm
drwxr-xr-x  2 root       root       4,1k Feb  6  2010 misc
drwxr-xr-x  2 root       root       4,1k Feb  9  2010 mlocate
drwxr-xr-x  2 root       root       4,1k Sep 20 15:20 msttcorefonts
drwxr-xr-x  5 stadt      root       4,1k Aug 10  2009 nfs
drwxr-xr-x  2 ntp        ntp        4,1k Sep 22 16:16 ntp
drwxr-xr-x  2 root       root       4,1k Jun 12  2009 ntpdate
drwxr-xr-x  2 root       root       4,1k Sep 21 11:30 pam
drwx------  3 root       root       4,1k Feb  6  2010 polkit-1
drwxr-xr-x  2 postfix    postfix    4,1k Aug 11  2009 postfix

At a first glance it looked (when looking at UIDs/GIDs) that simply the
UID was also used as GID (the same number) which don't however correspond
to the same user/group pair.
But that turned out to be different at a 2nd try.


Any ideas? Please ask if you need additional info/etc.

Cheers,
Chris.
