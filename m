Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754675Ab0KERc5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Nov 2010 13:32:57 -0400
Received: from mailbackup.inode.at ([213.229.60.24]:55620 "EHLO
	mailbackup.inode.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753176Ab0KERc4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Nov 2010 13:32:56 -0400
X-Greylist: delayed 611 seconds by postgrey-1.27 at vger.kernel.org; Fri, 05 Nov 2010 13:32:55 EDT
To: linux-kernel@vger.kernel.org
Subject: Disk I/O stuck with KVM - no clue how to solve that
Content-Disposition: inline
From: Hermann Himmelbauer <dusty@qwer.tk>
Date: Fri, 5 Nov 2010 18:18:54 +0100
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201011051818.55020.dusty@qwer.tk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
I already tried to get some help on the KVM list for my problem but had no 
success, so the problem could be not KVM related at all, therefore maybe 
someone here has an idea:

I experience strange disk I/O stucks on my Linux Host + Guest with KVM, which 
make the system (especially the guests) almost unusable. These stucks come 
periodically, e.g. every 2 to 10 seconds and last between 3 and sometimes 
over 120 seconds, which trigger kernel messages like this (on host and/or 
guest):

INFO: task postgres:2195 blocked for more than 120 seconds

If the stucks are shorter, no error messages can be seen in any log file 
(neither on host, nor on guest).

On the other hand sometimes the system may remain responsive for e.g. half an 
hour, then the stucks come back.

I have the following configuration:

Host: 
Debian Lenny, Kernel 2.6.32-bpo and/or 2.6.36, qemu-kvm 0.12.5
The host has 6 SATA-disks, whereas 
Devices: md0/1/2, sda/sdc = WD Raptor
Devices md3: sdb/sdd WD Caviar Green
Devices md4: sde/sdf WD Caviar Green
On top of the md-devices I have LVM volumes.
The mainboard is an Asus Z8NR-D12 with 2 Xeon L5520 processors and 16 GB RAM. 
The chipset is a i5500/ICH10R.

Currently I have the following 2 guests: 
1) "vmUranos": Debian Lenny, Kernel 2.6.32-bpo with virtio-block, on a LVM 
partition in /dev/md2
2) "galemo": Debian Lenny, Kernel 2.6.32-bpo with virtio-block, on a qemu-file 
on LVM partition on /dev/md3

The KVM parameters are attached on the end of this mail in case this is 
important.

I did extensive disk-read I/O testing on the host without any guests started, 
e.g. on the devices itself (sda-sdf in parallel) and on the md-devices, then 
also on the LVM volumes, parallel, several combinations. The reads are all 
very fast and stable, no stucks, no problems, which leads me to the 
conclusion that the hardware is o.k.

Next in my test I start a KVM guest while performing read tests on all devices 
(sda-sdf). As soon as a KVM is started, the stucks begin to appear. So, if I 
start the virtual machine "galemo", which reads from /dev/md3, the read tests 
on sdb and sdd begin to have stucks, if I start "vmUranos", stucks happen on 
sda/sdc.

These stucks can be seen both on the host and in the guest, whereas they seem 
more severe in the guest.

If I shutdown/destroy the guests while performing read tests the stucks on the 
host persist, although the KVM process is gone, which leads me to the 
conclusion that the problem may be kernel related.

If I stop all read tests and wait for some time, I can restart the read tests 
and the stucks are gone, so the system seems to have recovered.

My impression is that KVM (and/or virtio-block) seems to affect the I/O 
subsystem in some way, so that it gets mixed up in some way, e.g. some 
scheduler does not know how to distribute I/O reads, or something like that.

I have absolutely no clue what to do to solve the problem, my last idea would 
be to change the mainboard, as my current one has the i5500 chipset instead 
of the more common i5000 server chipset, however, this is costly and there's 
no guarantee that the problem is solved then.

What's your opinion on this?
Any help is appreciated!

Best Regards,
Hermann

P.S.: Here are the KVM parameters, in case they are relevant:

/usr/bin/kvm -S -M pc-0.12 -enable-kvm -m 1024 -smp 
2,sockets=2,cores=1,threads=1 -name vmUranos -uuid 
8e5139ce-c561-c52f-35e1-07db9bc5045b -nodefaults -chardev 
socket,id=monitor,path=/var/lib/libvirt/qemu/vmUranos.monitor,server,nowait -mon 
chardev=monitor,mode=readline -rtc base=utc -boot c -drive 
if=none,media=cdrom,id=drive-ide0-1-0,readonly=on -device 
ide-drive,bus=ide.1,unit=0,drive=drive-ide0-1-0,id=ide0-1-0 -drive 
file=/dev/capella_raptor/UranosBase,if=none,id=drive-virtio-disk0,boot=on,cache=none -device 
virtio-blk-pci,bus=pci.0,addr=0x4,drive=drive-virtio-disk0,id=virtio-disk0 -device 
virtio-net-pci,vlan=0,id=net0,mac=54:52:00:03:f4:ca,bus=pci.0,addr=0x5 -net 
tap,fd=17,vlan=0,name=hostnet0 -chardev pty,id=serial0 -device 
isa-serial,chardev=serial0 -usb -vnc 127.0.0.1:0 -k de -vga cirrus -device 
virtio-balloon-pci,id=balloon0,bus=pci.0,addr=0x3

/usr/bin/kvm -S -M pc -enable-kvm -m 1024 -smp 
1,sockets=1,cores=1,threads=1 -name galemo -uuid 
171b4536-84ea-041d-d318-16b8fb20f855 -nodefaults -chardev 
socket,id=monitor,path=/var/lib/libvirt/qemu/galemo.monitor,server,nowait -mon 
chardev=monitor,mode=readline -rtc base=utc -boot c -drive 
if=none,media=cdrom,id=drive-ide0-1-0,readonly=on -device 
ide-drive,bus=ide.1,unit=0,drive=drive-ide0-1-0,id=ide0-1-0 -drive 
file=/dev/capella_data1/galemo,if=none,id=drive-virtio-disk0,boot=on -device 
virtio-blk-pci,bus=pci.0,addr=0x4,drive=drive-virtio-disk0,id=virtio-disk0 -device 
virtio-net-pci,vlan=0,id=net0,mac=54:52:00:45:9c:d9,bus=pci.0,addr=0x5 -net 
tap,fd=18,vlan=0,name=hostnet0 -chardev pty,id=serial0 -device 
isa-serial,chardev=serial0 -usb -vnc 127.0.0.1:1 -k de -vga cirrus -device 
virtio-balloon-pci,id=balloon0,bus=pci.0,addr=0x3


-- 
hermann@qwer.tk
GPG key ID: 299893C7 (on keyservers)
FP: 0124 2584 8809 EF2A DBF9  4902 64B4 D16B 2998 93C7
