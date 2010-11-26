Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755343Ab0KZSqI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 13:46:08 -0500
Received: from relay.cooperix.net ([67.23.6.41]:33639 "EHLO relay.sandelman.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753909Ab0KZSqG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 13:46:06 -0500
X-Greylist: delayed 590 seconds by postgrey-1.27 at vger.kernel.org; Fri, 26 Nov 2010 13:46:06 EST
From: Michael Richardson <mcr@sandelman.ca>
To: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org
cc: bart@jukie.net
Subject: odd behavior from /sys/block (sysfs)
X-Mailer: MH-E 8.1; nmh 1.1; XEmacs 21.4 (patch 21)
Date: Fri, 26 Nov 2010 13:36:06 -0500
Message-ID: <5108.1290796566@marajade.sandelman.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


{please CC me}

I was capturing data from my laptop's /sys file system as test input
for some code that needs to grovel through /sys a bit.  I found it weird
that tar got different answers than ls!  See below (at end) for original
observation.

It seems that this is because lstat64() on sysfs returns st_size=0 for
the link, and tar does not know how to deal with this, while ls does.
I don't know if it is tar that is wrong, or sysfs.
lstat64(3) suggests that it is sysfs that is at fault, that it should
set st_size.  The behaviour of ls, suggests that perhaps other systems
have worked around st_size=0 for symlinks.  (I'm on 2.6.32-bpo.5 from debian)

My investigation...

I noticed that ls does a series of readlink(2) operations, while tar
does only one.    Reading more about readlink(2), it seems that actually, 
ls is doing a double-size of buffer each time in order to get all the
data, while tar is only doing a single attempt, and getting only one
byte of the link data.

TAR:
lstat64("/sys/block/dm-0", {st_mode=S_IFLNK|0777, st_size=0, ...}) = 0
readlink("/sys/block/dm-0", "."..., 1)  = 1
lstat64("/sys/block/dm-1", {st_mode=S_IFLNK|0777, st_size=0, ...}) = 0
readlink("/sys/block/dm-1", "."..., 1)  = 1
...

LS:
lstat64("/sys/block/dm-0", {st_mode=S_IFLNK|0777, st_size=0, ...}) = 0
lgetxattr("/sys/block/dm-0", "security.selinux", 0x93331f0, 255) = -1 EOPNOTSUPP (Operation not supported)
readlink("/sys/block/dm-0", "."..., 1)  = 1
readlink("/sys/block/dm-0", "..", 2)    = 2
readlink("/sys/block/dm-0", "../d"..., 4) = 4
readlink("/sys/block/dm-0", "../devic"..., 8) = 8
readlink("/sys/block/dm-0", "../devices/virtu"..., 16) = 16
readlink("/sys/block/dm-0", "../devices/virtual/block/dm-0"..., 32) = 29
lstat64("/sys/block/dm-1", {st_mode=S_IFLNK|0777, st_size=0, ...}) = 0


Comparing this to reading from a regular file system, I see:

marajade-[snodecfg/testing/sys11/block] mcr 10079 %ln -s foo/bar/zzz/blog
marajade-[snodecfg/testing/sys11/block] mcr 10080 %ls -lta
total 8
drwxr-xr-x 2 mcr mcr 4096 Nov 26 13:27 ./
lrwxrwxrwx 1 mcr mcr   16 Nov 26 13:27 blog -> foo/bar/zzz/blog

marajade-[snodecfg/testing/sys11/block] mcr 10081 %strace -o /tmp/k3 tar cf /dev/null .

lstat64("./sr0", {st_mode=S_IFLNK|0777, st_size=1, ...}) = 0
readlink("./sr0", "."..., 2)            = 1
lstat64("./blog", {st_mode=S_IFLNK|0777, st_size=16, ...}) = 0
readlink("./blog", "foo/bar/zzz/blog"..., 17) = 16

the original observation:


marajade-[snodecfg/testing/sys11/block] mcr 10072 %ls -l /sys/block
total 0
lrwxrwxrwx 1 root root 0 Nov 26 13:11 dm-0 -> ../devices/virtual/block/dm-0/
lrwxrwxrwx 1 root root 0 Nov 26 13:11 dm-1 -> ../devices/virtual/block/dm-1/
lrwxrwxrwx 1 root root 0 Nov 26 13:11 dm-10 -> ../devices/virtual/block/dm-10/
lrwxrwxrwx 1 root root 0 Nov 26 13:11 dm-11 -> ../devices/virtual/block/dm-11/
lrwxrwxrwx 1 root root 0 Nov 26 13:11 dm-12 -> ../devices/virtual/block/dm-12/
lrwxrwxrwx 1 root root 0 Nov 26 13:11 dm-13 -> ../devices/virtual/block/dm-13/
lrwxrwxrwx 1 root root 0 Nov 26 13:11 dm-14 -> ../devices/virtual/block/dm-14/
lrwxrwxrwx 1 root root 0 Nov 26 13:11 dm-15 -> ../devices/virtual/block/dm-15/
lrwxrwxrwx 1 root root 0 Nov 26 13:11 dm-16 -> ../devices/virtual/block/dm-16/
lrwxrwxrwx 1 root root 0 Nov 26 13:11 dm-17 -> ../devices/virtual/block/dm-17/
lrwxrwxrwx 1 root root 0 Nov 26 13:11 dm-18 -> ../devices/virtual/block/dm-18/
lrwxrwxrwx 1 root root 0 Nov 26 13:11 dm-19 -> ../devices/virtual/block/dm-19/
lrwxrwxrwx 1 root root 0 Nov 26 13:11 dm-2 -> ../devices/virtual/block/dm-2/
lrwxrwxrwx 1 root root 0 Nov 26 13:11 dm-3 -> ../devices/virtual/block/dm-3/
lrwxrwxrwx 1 root root 0 Nov 26 13:11 dm-4 -> ../devices/virtual/block/dm-4/
lrwxrwxrwx 1 root root 0 Nov 26 13:11 dm-5 -> ../devices/virtual/block/dm-5/
lrwxrwxrwx 1 root root 0 Nov 26 13:11 dm-6 -> ../devices/virtual/block/dm-6/
lrwxrwxrwx 1 root root 0 Nov 26 13:11 dm-7 -> ../devices/virtual/block/dm-7/
lrwxrwxrwx 1 root root 0 Nov 26 13:11 dm-8 -> ../devices/virtual/block/dm-8/
lrwxrwxrwx 1 root root 0 Nov 26 13:11 dm-9 -> ../devices/virtual/block/dm-9/
lrwxrwxrwx 1 root root 0 Nov 26 13:11 loop0 -> ../devices/virtual/block/loop0/
lrwxrwxrwx 1 root root 0 Nov 26 13:11 loop1 -> ../devices/virtual/block/loop1/
lrwxrwxrwx 1 root root 0 Nov 26 13:11 loop2 -> ../devices/virtual/block/loop2/
lrwxrwxrwx 1 root root 0 Nov 26 13:11 loop3 -> ../devices/virtual/block/loop3/
lrwxrwxrwx 1 root root 0 Nov 26 13:11 loop4 -> ../devices/virtual/block/loop4/
lrwxrwxrwx 1 root root 0 Nov 26 13:11 loop5 -> ../devices/virtual/block/loop5/
lrwxrwxrwx 1 root root 0 Nov 26 13:11 loop6 -> ../devices/virtual/block/loop6/
lrwxrwxrwx 1 root root 0 Nov 26 13:11 loop7 -> ../devices/virtual/block/loop7/
lrwxrwxrwx 1 root root 0 Nov 26 13:11 sda -> ../devices/pci0000:00/0000:00:1f.1/host0/target0:0:0/0:0:0:0/block/sda/
lrwxrwxrwx 1 root root 0 Nov 26 13:11 sdb -> ../devices/pci0000:00/0000:00:1d.7/usb1/1-4/1-4:1.0/host9/target9:0:0/9:0:0:0/block/sdb/
lrwxrwxrwx 1 root root 0 Nov 26 13:11 sr0 -> ../devices/pci0000:00/0000:00:1f.1/host1/target1:0:0/1:0:0:0/block/sr0/
marajade-[snodecfg/testing/sys11/block] mcr 10073 %tar cf - /sys/block | tar tvf -           
tar: Removing leading `/' from member names
drwxr-xr-x root/root         0 2010-11-26 13:20 sys/block/
lrwxrwxrwx root/root         0 2010-11-26 13:20 sys/block/sda -> .
lrwxrwxrwx root/root         0 2010-11-26 13:20 sys/block/sr0 -> .
lrwxrwxrwx root/root         0 2010-11-26 13:20 sys/block/dm-0 -> .
lrwxrwxrwx root/root         0 2010-11-26 13:20 sys/block/dm-1 -> .
lrwxrwxrwx root/root         0 2010-11-26 13:20 sys/block/dm-2 -> .
lrwxrwxrwx root/root         0 2010-11-26 13:20 sys/block/dm-3 -> .
lrwxrwxrwx root/root         0 2010-11-26 13:20 sys/block/dm-4 -> .
lrwxrwxrwx root/root         0 2010-11-26 13:20 sys/block/dm-5 -> .
lrwxrwxrwx root/root         0 2010-11-26 13:20 sys/block/dm-6 -> .
lrwxrwxrwx root/root         0 2010-11-26 13:20 sys/block/dm-7 -> .
lrwxrwxrwx root/root         0 2010-11-26 13:20 sys/block/dm-8 -> .
lrwxrwxrwx root/root         0 2010-11-26 13:20 sys/block/dm-9 -> .
lrwxrwxrwx root/root         0 2010-11-26 13:20 sys/block/dm-10 -> .
lrwxrwxrwx root/root         0 2010-11-26 13:20 sys/block/dm-11 -> .
lrwxrwxrwx root/root         0 2010-11-26 13:20 sys/block/dm-12 -> .
lrwxrwxrwx root/root         0 2010-11-26 13:20 sys/block/dm-13 -> .
lrwxrwxrwx root/root         0 2010-11-26 13:20 sys/block/dm-14 -> .
lrwxrwxrwx root/root         0 2010-11-26 13:20 sys/block/dm-15 -> .
lrwxrwxrwx root/root         0 2010-11-26 13:20 sys/block/dm-16 -> .
lrwxrwxrwx root/root         0 2010-11-26 13:20 sys/block/dm-17 -> .
lrwxrwxrwx root/root         0 2010-11-26 13:20 sys/block/dm-18 -> .
lrwxrwxrwx root/root         0 2010-11-26 13:20 sys/block/dm-19 -> .
lrwxrwxrwx root/root         0 2010-11-26 13:20 sys/block/loop0 -> .
lrwxrwxrwx root/root         0 2010-11-26 13:20 sys/block/loop1 -> .
lrwxrwxrwx root/root         0 2010-11-26 13:20 sys/block/loop2 -> .
lrwxrwxrwx root/root         0 2010-11-26 13:20 sys/block/loop3 -> .
lrwxrwxrwx root/root         0 2010-11-26 13:20 sys/block/loop4 -> .
lrwxrwxrwx root/root         0 2010-11-26 13:20 sys/block/loop5 -> .
lrwxrwxrwx root/root         0 2010-11-26 13:20 sys/block/loop6 -> .
lrwxrwxrwx root/root         0 2010-11-26 13:20 sys/block/loop7 -> .
lrwxrwxrwx root/root         0 2010-11-26 13:20 sys/block/sdb -> .


