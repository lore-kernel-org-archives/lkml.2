Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756275Ab0LJNgE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 08:36:04 -0500
Received: from mail.in-telegence.net ([83.125.45.125]:38496 "EHLO
	amg.in-telegence.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755428Ab0LJNgB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 08:36:01 -0500
X-Greylist: delayed 463 seconds by postgrey-1.27 at vger.kernel.org; Fri, 10 Dec 2010 08:36:01 EST
Message-ID: <4D022A77.1080708@in-telegence.net>
Date: Fri, 10 Dec 2010 14:26:15 +0100
From: Dominik Klein <dk@in-telegence.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; de; rv:1.9.2.12) Gecko/20101027 Lightning/1.0b2 Thunderbird/3.1.6
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: aliguori@us.ibm.com
Subject: Possible race condition in net_cls (found in a qemu-kvm environment)
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

I may be seeing some sort of a race condition in net_cls. I am not a
programmer, I do not know any kernel code and I cannot really show any
logs proving what I am about to state. Actually, I don't even know
whether the bug is in iproute2, qemu-kvm or the kernel itself. Still, it
is happening. So if you want to read on: You have been warned. Thanks if
do you read on.

My goal is to run qemu-kvm virtual machines and limit their bandwidth.
The environment is as follows:

opensuse 11.3 64bit
vanilla kernel 2.6.36.1
iproute2 2.6.35
qemu-kvm 0.13.0

A neat way to do achieve this goal seems to be the net_cls cgroups
subsystem which one can put a PID into and have the processes' bandwidth
be limited by tc.

So I set up tc rules, mounted net_cls and put the qemu-kvm processes'
pid into the tasks file. The vm however happily kept using more than the
10MBit I assigned to it.

I kept looking for documentation on this and also do the old trial and
error thing but could not make it work. The vm is supposed to use a
network bridge on the host system btw. I tried putting the tc rules to
the tap device, to the physical device and to the bridge device, all at
once and each on their own. Nothing worked, the VM happily used the
entire bandwidth.

So while testing, I started to automate steps and formed the qemu-kvm
commandline into sth like

qemu-kvm <machine-definition> & echo $! > tasks

And all of a sudden, the machine was only using the bandwidth it was
supposed to use.

Here's the entire commands I use.

# step 1 net_cls
mkdir -p /dev/cgroup/network
mount -t cgroup net_cls -o net_cls /dev/cgroup/network
mkdir /dev/cgroup/network/A
mkdir /dev/cgroup/network/B
/bin/echo 0x00010001 > /dev/cgroup/network/A/net_cls.classid   # 1:1
/bin/echo 0x00010002 > /dev/cgroup/network/B/net_cls.classid   # 1:2

# step 2 start virtual machine (command is mostly taken from libvirt)
/usr/bin/qemu-kvm -M pc-0.13 -enable-kvm -m 512 -smp
1,sockets=1,cores=1,threads=1 -name cliff -uuid
7608c418-d0a1-290a-f703-61ec0435991f -nodefconfig -nodefaults -chardev
socket,id=monitor,path=/var/lib/libvirt/qemu/cliff.monitor,server,nowait
-mon chardev=monitor,mode=readline -rtc base=utc -boot c -drive
file=/opt/kvm/cliff.img,if=none,id=drive-virtio-disk0,boot=on,format=raw
-device
virtio-blk-pci,bus=pci.0,addr=0x4,drive=drive-virtio-disk0,id=virtio-disk0
-netdev tap,id=hostnet0 -device
e1000,netdev=hostnet0,id=net0,mac=52:54:00:03:38:bb,bus=pci.0,addr=0x3
-chardev pty,id=serial0 -device isa-serial,chardev=serial0 -vnc
127.0.0.1:0 -vga cirrus -device
virtio-balloon-pci,id=balloon0,bus=pci.0,addr=0x5 &

# step 3 tc
dev=eth0
tc qdisc del dev $dev root 2>/dev/null
tc qdisc add dev $dev root handle 1: htb
tc class add dev $dev parent 1: classid 1:1 htb rate 10mbit ceil 10mbit
tc class add dev $dev parent 1: classid 1:2 htb rate 20mbit ceil 20mbit
tc filter add dev $dev parent 1: protocol ip prio 1 handle 1: cgroup

# step 4 pid > tasks
pgrep qemu-kvm > /dev/cgroup/network/A/tasks

At this point, the VM happily keeps using the entire bandwidth.

So now my way to change things:

# step 1 unchanged
# step 2 start vm and directly afterwards echo its PID to tasks
/usr/bin/qemu-kvm -M pc-0.13 -enable-kvm -m 512 -smp
1,sockets=1,cores=1,threads=1 -name cliff -uuid
7608c418-d0a1-290a-f703-61ec0435991f -nodefconfig -nodefaults -chardev
socket,id=monitor,path=/var/lib/libvirt/qemu/cliff.monitor,server,nowait
-mon chardev=monitor,mode=readline -rtc base=utc -boot c -drive
file=/opt/kvm/cliff.img,if=none,id=drive-virtio-disk0,boot=on,format=raw
-device
virtio-blk-pci,bus=pci.0,addr=0x4,drive=drive-virtio-disk0,id=virtio-disk0
-netdev tap,id=hostnet0 -device
e1000,netdev=hostnet0,id=net0,mac=52:54:00:03:38:bb,bus=pci.0,addr=0x3
-chardev pty,id=serial0 -device isa-serial,chardev=serial0 -vnc
127.0.0.1:0 -vga cirrus -device
virtio-balloon-pci,id=balloon0,bus=pci.0,addr=0x5 & /bin/echo $! >
/dev/cgroup/network/A/tasks

# step 3 unchanged
# step 4 unchanged

Now, the limit configured in tc applies and the virtual machine only
uses 10 MBit.

This is 100% reproducible here.

On the other hand, echoing my current shell's pid into tasks and then
using s.th. like "scp" shows the reduced bandwidth usually works.

So I realize I may not be giving you a whole lot to actually work with,
but I am willing to provide more helpful information if you let me know
what would be helpful and how to extract that information.

Thanks in advance,
Dominik
