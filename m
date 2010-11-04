Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755150Ab0KDF7o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 01:59:44 -0400
Received: from que01.suddenlink.net ([208.180.40.86]:41517 "EHLO
	que01.suddenlink.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754847Ab0KDF7m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 01:59:42 -0400
X-Greylist: delayed 331 seconds by postgrey-1.27 at vger.kernel.org; Thu, 04 Nov 2010 01:59:42 EDT
Message-ID: <4CD24A64.3080503@suddenlinkmail.com>
Date: Thu, 04 Nov 2010 00:53:40 -0500
From: "David C. Rankin" <drankinatty@suddenlinkmail.com>
Organization: Rankin Law Firm, PLLC
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101026 SUSE/3.1.6 Thunderbird/3.1.6
MIME-Version: 1.0
To: kernel <linux-kernel@vger.kernel.org>
Subject: Upgrade to recent 2.6.35 & 2.6.36 kernel causing boot failure with
 nv dmraid
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Cloudmark-Analysis: v=1.1 cv=1ySWNNja79c/jgOHmXRKbmV/BjW144TMdFddqTN+fW0= c=1 sm=0 a=OL7lo7QTkQAA:10 a=8nJEP1OIZ-IA:10 a=Jl21X7VrAAAA:8 a=Br9LfDWDAAAA:8 a=VwQbUJbxAAAA:8 a=3gq0ZD_ce0tRoPEAe1oA:9 a=bT05QF8A42Tdlf4U2pAA:7 a=eQVkgemhMsa-zMqrspph7vwvM18A:4 a=wPNLvfGTeEIA:10 a=HEdnscJc8mAA:10 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(slightly long post -- trying to provide all relevant info)

Guys,

    I am experiencing boot failures with the newer 2.6.35 and 2.6.36 kernels
with dmraid on an MSI K9N2 SLI Platinum board. (MS-7374) What follows is a
collection of information gained from the Arch Linux list and in discussion with
the redhat guys on the dm-devel (dmraid) list.

    I'll start by providing links to the hardware information on the box and
then summarize the problem. Bottom line is kernel 2.6.35-8 (and newer on Arch
Linux) result in one of two grub errors and the boot hangs. This box has run in
this dmraid config with everything from SuSE 10X to Arch without issue prior to
this. I did see a similar issue with a couple of earlier 2.6.35-x kernels, but
the next two (2.6.36-6 & 7) booted fine. Downgrading to 2.6.35-7, the box boots
fine. The box also currently boots fine with the Arch LTS kernel (2.6.32) and
the box boots the SuSE 11.0 kernels fine (2.6.20). So whatever the issue is, it
has showed up in the past few kernels and is a Russian-roulette type problem.
There are no problems with the 2 dmraid arrays on the box.

Hardware:

  lspci -vv info

    http://www.3111skyline.com/dl/bugs/dmraid/lspci-vv.txt

  dmidecode info

    http://www.3111skyline.com/dl/bugs/Archlinux/aa-dmidecode.txt

  dmraid metadata and fdisk info

    http://www.3111skyline.com/dl/bugs/dmraid/dmraid.nvidia/

    http://www.3111skyline.com/dl/bugs/dmraid/fdisk-l-info-20100817.txt


The problem and boot errors:

    I am no kernel guru, but here is the best explanation of the problem I can
give you. I updated the MSI x86_64 box to 2.6.35.8-1 and the boot hangs at the
very start with the following error:

Booting 'Arch Linux on Archangel'

root (hd1,5)
  Filesystem type is ext2fs, Partition type 0x83
Kernel /vmlinuz26 root=/dev/mapper/nvidia_baacca_jap5 ro vga=794

Error 24: Attempt to access block outside partition

Press any key to continue...

    This is the same/similar boot problem seen with one or two of the recent
kernels. It was report to the Arch bug list at:
	
	https://bugs.archlinux.org/task/20918?
	(closed because the next kernel update worked)

	All of the information in bug 20918 is current for this box.

    From all the discussion it has something to do with the kernel and/or dmraid
because older kernels boot just fine with the same menu.lst and same hardware,
but upgrading to 2.6.35.8-1 kills the box. I know it looks like grub, but all
kernels except 2.6.35.8-1 (and newer) work with the same config??

    Here is another twist. After upgrading to device-mapper-2.02.75-1 and
reinstalling kernel26-2.6.35.8-1, the error completely changed to:

Error 5: Partition table invalid or corrupt

    The partition and partition table are fine on the arrays.

Thoughts from the Arch Devs:

  post 1:

    These error are semi-random, they probably depend on where the kernel and
initramfs files are physically located in the file system.

    Grub (and all other bootloaders for that matter) use BIOS calls to access
files on the hard drive - they rely on the BIOS (and in your case, the jmicron
dmraid BIOS) for file access. This access seems to fail for certain areas on
your file system.

  post 2:

    Aah, it just hit me: the problem may in fact be fairly random in that it may
depend on where the initramfs is stored.  So, if the BIOS is broken, you may be
lucky to be able to boot under one kernel, and the next upgrade places things in
a place on disk where the BIOS bug kicks in, and you're screwed.  So it has
nothing to do with the kernel version, grub or dmraid in this case.  Do I
understand this correctly?

  post 3:

    I guess there has been something changed in the kernel26 2.6.35.8 and above
which doesn't work with your BIOS or your RAID. Either this is a bug in kernel26
2.6.35.8 and newer or it is not a bug but a new feature or a change which
doesn't work with your probably outdated BIOS.

    I'd suggest asking kernel upstream by either filing a bug report at
kernel.org or asking on their mailing list.

    It definitely must have something to do with the kernel. Otherwise it
wouldn't work again after a kernel downgrade.

Thoughts from the redhat dm-devel folks:

    ...because you're able to access your config fine with some arch LTS
kernels, it doesn't make sense to analyze your metadata upfront and the
following reasons may cause the failures:

    - initramfs issue not activating ATARAID mappings properly via dmraid

    - drivers missing to access the mappings

    - host protected area changes going together with the kernel changes
    (eg. the "Error 24: Attempt to access block outside partition");
    try the libata.ignore_hpa kernel paramaters described
    in the kernel source Documentation/kernel-parameters.txt
    to test for this one

    FYI: in general dmraid doesn't rely on a particular controller, just
    metadata signatures it discovers. You could attach the disks to some
    other SATA controller and still access your RAID sets.

Further tests I've done:

    Per the suggestions of the dm-devel guys, I have tested with both
libata.ignore_hpa=0 (default) and libata.ignore_hpa=1 (ignore limits, using full
disk), but there is no change. I still get grub Error 24: (this is with the
2.6.36-3 kernel)

    I did another test starting with 2.6.35-7 (working), upgrade to 2.6.35-8
(expect failure -- it did), then upgrade directly to 2.6.36-3 and (expect
success if it was an initramfs location issue -- it failed too). Just to be
sure, I re-made the initramfs a couple of times and tried booting with them -
they all failed as well.

    Then downgraded to 2.6.35-7 -> it works like a champ -- no matter what order
it gets installed in. I'll follow up with the kernel folks.

The conundrum:

    So basically, I don't know what the heck is going on with this other than
something got broke with the way the kernel inits the dmraid arrays resulting in
grub thinking it is reading beyond some partition boundary or a corrupt
partition table. Neither are correct, because simply booting an older kernel
works fine.

    So, I'm asking the smart guys here, what could have changed in the kernel
that might cause this behavior? If you look at the lspci data (link above), the
controller used for both arrays is the nVidia MCP78S [GeForce 8200] SATA
Controller (RAID mode) (rev a2). Maybe a module alias change or ahci issue?

    I don't know exactly what you might need to look at or what additional data
you want, but just let me know and I'm happy to get it for you.

    So what say the gurus?


-- 
David C. Rankin, J.D.,P.E.

