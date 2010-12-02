Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757605Ab0LBN4m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 08:56:42 -0500
Received: from blade3.isti.cnr.it ([194.119.192.19]:60568 "EHLO
	BLADE3.ISTI.CNR.IT" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757253Ab0LBN4k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 08:56:40 -0500
Date: Thu, 02 Dec 2010 14:55:05 +0100
From: Spelic <spelic@shiftmail.org>
Subject: Bugs in mkfs.xfs, device mapper, xfs, and /dev/ram
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        xfs@oss.sgi.com, linux-lvm@redhat.com
Message-id: <4CF7A539.1050206@shiftmail.org>
MIME-version: 1.0
Content-type: text/plain; format=flowed; charset=ISO-8859-1
Content-transfer-encoding: 7bit
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11)
 Gecko/20100713 Thunderbird/3.0.6
X-INSM-ip-source: 155.253.6.254 Auth Done
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello all

I noticed what seem to be 4 bugs.
(kernel v2.6.37-rc4 but probably also before)

First two are one in mkfs.xfs and one in device mapper (lvm mailing list 
I suppose, otherwise pls forward it):

Steps to reproduce:

Boot with a large ramdisk, like ramdisk_size=2097152
(actually I had 14GB ramdisk when I tried this but I don't think it will 
make a difference)

Now partition it with a 1GB partition:
   fdisk /dev/ram0
   n
   p
   1
   1
   +1G
   w
(only one 1GB physical partition)

Make a devmapper mapping for the partition
   kpartx -av /dev/ram0

mkfs.xfs -f /dev/mapper/ram0p1
     meta-data=/dev/mapper/ram0p1     isize=256    agcount=4, 
agsize=66266 blks
             =                       sectsz=512   attr=2
     data     =                       bsize=4096   blocks=265064, imaxpct=25
             =                       sunit=0      swidth=0 blks
     naming   =version 2              bsize=4096   ascii-ci=0
     log      =internal log           bsize=4096   blocks=2560, version=2
             =                       sectsz=512   sunit=0 blks, lazy-count=1
     realtime =none                   extsz=4096   blocks=0, rtextents=0

Now, lo and behold, partition is gone!
   fdisk  /dev/ram0
   p
will show no partitions!

you can also check with
   dd if=/dev/ram bs=1M count=1 | hexdump -C
All first MB of /dev/ram is zeroed!!

also
   mount /dev/ram0p1 /mnt
will fail. Unknown filesystem

I think this shows 2 bugs: firstly mkfs.xfs dares to do stuff before the 
beginning of the device on which it should work.
Secondly, device mapper does not constrain access within the boundaries 
of the device, which I think it should do.

Then I have 2 more bugs for you. Please see my thread in linux-rdma called:
     "NFS-RDMA hangs: connection closed (-103)"
     in particular this post 
http://www.mail-archive.com/linux-rdma@vger.kernel.org/msg06632.html
with NFS over <RDMA or IPoIB> over Infiniband over XFS over ramdisk it 
is possible to write a file (2.3GB) which is larger than the size of the 
device (1.5GB): one bug I think is for XFS people (because I think XFS 
should check if the space on the filesystem is finished), and another 
one I think is for /dev/ram people (what mailing list? I am adding 
lkml), because I think the device should check if someone is writing 
beyond the end of it.

Thank you
PS: I am not subscribed to lkml so please do not reply ONLY to lkml.
