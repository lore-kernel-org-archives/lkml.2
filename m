Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758462Ab0E1PCT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 11:02:19 -0400
Received: from ojjektum.uhulinux.hu ([62.112.194.64]:55767 "EHLO
	ojjektum.uhulinux.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751526Ab0E1PCR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 11:02:17 -0400
X-Greylist: delayed 403 seconds by postgrey-1.27 at vger.kernel.org; Fri, 28 May 2010 11:02:17 EDT
Date: Fri, 28 May 2010 16:55:33 +0200
From: Pozsar Balazs <pozsy@uhulinux.hu>
To: linux-kernel@vger.kernel.org
Subject: device mapper wierdness
Message-ID: <20100528145533.GE13853@ojjektum.uhulinux.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi all,

I found a wierd caching problem, and would like to ask if this is a bug, 
and how to avoid this behaviour properly.

First of all, I have a lvm device:

root:~# ls -l /dev/dm-2 /dev/bela/gazsi
lrwxrwxrwx 1 root root       7 2010-05-28 16:17 /dev/bela/gazsi -> ../dm-2
brw-rw---- 1 root media 254, 2 2010-05-28 16:17 /dev/dm-2
root:~# dmsetup info bela-gazsi
Name:              bela-gazsi
State:             ACTIVE
Read Ahead:        256
Tables present:    LIVE
Open count:        1
Event number:      0
Major, minor:      254, 2
Number of targets: 1
UUID: 
LVM-LrFvCCU7QzeyBsiXl2RC2VMnWvxGdS4n7xugPDcPzx1vD6SVElPELv0a8vf4mzH0

root:~# dmsetup table bela-gazsi
0 15114240 linear 8:4 384


Above that, I have another device mapper device, just a simple linear 
one:

brw-rw---- 1 root media 254, 1 2010-05-28 16:27 /dev/dm-1
root:~# ls -l /dev/dm-1 /dev/mapper/live
brw-rw---- 1 root media 254, 1 2010-05-28 16:27 /dev/dm-1
lrwxrwxrwx 1 root root       7 2010-05-28 16:17 /dev/mapper/live -> ../dm-1
root:~# dmsetup info live
Name:              live
State:             ACTIVE
Read Ahead:        256
Tables present:    LIVE
Open count:        1
Event number:      0
Major, minor:      254, 1
Number of targets: 1

root:~# dmsetup table live
0 15114240 linear 254:2 0


Because of the linear mapping, we can see the fs uuid is the same on the 
two
dm devices:
root:~# blkid /dev/mapper/live /dev/bela/gazsi
/dev/mapper/live: LABEL="UHU" UUID="3452e43d-d40a-4c13-b24d-07d4b1793e9b" TYPE="ext4"
/dev/bela/gazsi: LABEL="UHU" UUID="3452e43d-d40a-4c13-b24d-07d4b1793e9b" TYPE="ext4"


Now if I change the uuid of the filesystem with tune2fs, I cannot see 
this change on the /dev/bela/gazsi device, even if I do a sync:
root:~# tune2fs -U random /dev/mapper/live
tune2fs 1.41.11 (14-Mar-2010)
root:~# blkid /dev/mapper/live /dev/bela/gazsi
/dev/mapper/live: LABEL="UHU" UUID="f3fad2d6-451a-4ef6-98f8-5fcf51571b07" TYPE="ext4"
/dev/bela/gazsi: LABEL="UHU" UUID="3452e43d-d40a-4c13-b24d-07d4b1793e9b" TYPE="ext4"
root:~# sync
root:~# blkid /dev/mapper/live /dev/bela/gazsi
/dev/mapper/live: LABEL="UHU" UUID="f3fad2d6-451a-4ef6-98f8-5fcf51571b07" TYPE="ext4"
/dev/bela/gazsi: LABEL="UHU" UUID="3452e43d-d40a-4c13-b24d-07d4b1793e9b" TYPE="ext4"


But if drop caches, it gets into the proper state:
root:~# echo 1 >/proc/sys/vm/drop_caches
root:~# blkid /dev/mapper/live /dev/bela/gazsi
/dev/mapper/live: LABEL="UHU" UUID="f3fad2d6-451a-4ef6-98f8-5fcf51571b07" TYPE="ext4"
/dev/bela/gazsi: LABEL="UHU" UUID="f3fad2d6-451a-4ef6-98f8-5fcf51571b07" TYPE="ext4"


I fail to see why a sync is not enough and how this drop cache operation
helps. Could anyone enlighten me please?


I am using kernel 2.6.33.3.

Thanks,
Balazs Pozsar
