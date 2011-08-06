Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756792Ab1HFWJP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Aug 2011 18:09:15 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:60953 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754709Ab1HFWJO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Aug 2011 18:09:14 -0400
MIME-Version: 1.0
Date: Sat, 6 Aug 2011 23:09:12 +0100
Message-ID: <CAPweEDyrD2VE4DQ6rp=rfJ-MGa_rz4=c3-_+FVNMf3MHhAQZVA@mail.gmail.com>
Subject: linux kernel 2.6.39 LVM2 rootfs initrd kernel panic "no rootfs found"
 with userspace dmsetup+libdevmapper <= 1.02.48
From: Luke Kenneth Casson Leighton <luke.leighton@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-lvm@redhat.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

folks on lkml and linux-lvm, hi:

firstly - apologies for using LKML for an issue that's come up on the
debian gnu/linux distribution, but bear with me there's a reason why,
which will become clear with a little bit of explanation.  secondly -
i've got a working system [so this is not a "request by uh usah askin
fuh help on da LKML" :) ] it's about resolving what the heck's going
on, so that gnu/linux distros don't end up putting out combinations of
packages that will cause systems to keel over sideways.

the issue: on a system which has its root filesystem on an LVM2
partition, i've just upgraded [nothing but] linux kernel 2.6.32
(amd64) to 2.6.39.  debian's initramfs-tools happily rebuilt the
initrd, which involves stuffing libdevmapper and a boat-load of other
stuff into it, in order to detect and understand LVM2 partitions.

on a reboot, after showing only about 5-8 lines of kernel messages,
the system said it failed to find a root filesystem.  kernel panic, me
panic, lovely shiny expensive mac which, using EFI, is a bugger to
rescue, i reboot and select the older 2.6.32 kernel, and it's
absolutely fine.  whew.  can begin investigating.

so at this point i'm puzzled, because it's userspace-kernelspace
interaction and yet there's no recognition of this inter-dependency in
the debian package specs.  2.6.32 works yet 2.6.39 doesn't, with
versions of dmsetup and libdevmapper from debian-sid - numbers shown
here:

# squeeze (stable) (libs): The Linux Kernel Device Mapper userspace library
2:1.02.48-5: amd64 armel i386 ia64 mips mipsel powerpc s390 sparc

now, just on a long shot, i upgraded grub (and i think lvm2 as well,
or it was a part-dependency).  this resulted in dmsetup as well as
libdevmapper1.02 also being upgraded, to the following version:

# wheezy (testing) (libs): The Linux Kernel Device Mapper userspace library
2:1.02.63-3: amd64 armel i386 ia64 mips mipsel powerpc s390 sparc

[for people not familiar with debian numbering, 1.02.63 and 1.02.48
are the "original" i.e. upstream package version numbers - the bit
after the dash is a debian numbering that covers the debian packaging
(i.e. they've had to do 5 versions of 1.02.48 packaging, with little
tweaks and/or patches to suit debian) and for the most part can be
ignored].

at this point - 2.6.39 kernel and with dmsetup and libdevmapper
1.02.63 - the resultant initrd *successfully* recognised the LVM2 root
filesystem at boot time, and the debian gnu/linux distro happily
booted.  just for kicks i tested 2.6.32 as well with the new version
of libdevmapper, and that was happy too.

so, we have an unusual situation in which the linux kernel appears to
require a dependency on a specific version of a userspace library for
booting a system (which the debian linux kernel maintainer quite
rightly objected to "fixing" by adding random dependencies for random
userspace libraries.  as they said in Galaxy Quest, "ohhh.  that's not
riiiight"...)

so, with that as background, one debian user raised an interesting
question: has any _other_ gnu/linux distro encountered this issue, and
if so, how was it resolved?

on the basis that there are dozens of gnu/linux distros out there, it
being somewhat impractical to go round asking them all "hey, there's
this weird issue, like...", and on the technically-justifiable excuse
that it's a kernelspace-userspace interaction, i thought it ok to
raise this to a wide audience i.e. LKML to see if anyone's come across
this as well (redhat, suse, fedora, arch etc.)

aside from that, does anyone else know what the heck's actually going
on, here? :)

other bits of info which might or might not be relevant: yes it's a
mac with EFI boot, but yes grub2-efi does actually work.  yes the root
partition is on LVM2 but the /boot i put onto its own (ext2)
partition.  not sure if that makes any difference: i _think_ i'm glad
i did that.  the only other thing is that the upgrade recommended that
partitions be renamed to use UUIDs, to which i went "yep, sure, why
not".  the only visible change i yet determined occurred through that
decision was that /etc/fstab was modified (the /boot partition
/dev/sda3) to a UUID but of course the LVM2 partitions in /etc/fstab
were left alone.  can't see how that might be relevant, but someone
else might, hence why i'm mentioning it.

l.
