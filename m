Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753728Ab1BMCC4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Feb 2011 21:02:56 -0500
Received: from mx1.redhat.com ([209.132.183.28]:46565 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752717Ab1BMCCt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Feb 2011 21:02:49 -0500
Message-ID: <4D573BBB.6090200@redhat.com>
Date: Sun, 13 Feb 2011 03:02:35 +0100
From: Milan Broz <mbroz@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101213 Thunderbird/3.1.7
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Jens Axboe <axboe@kernel.dk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: block device read-only handling regression in 2.6.38-rc4 (bisected)
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tejun,

Seems this commit cause regressions:

commit 75f1dc0d076d1c1168f2115f1941ea627d38bd5a
Author: Tejun Heo <tj@kernel.org>
Date:   Sat Nov 13 11:55:17 2010 +0100

    block: check bdev_read_only() from blkdev_get()
    
    bdev read-only status can be queried using bdev_read_only() and may
    change while the device is being opened.  Enforce it by checking it
    from blkdev_get() after open succeeds.


1) loop device once set read-only is not able to be used read-write afterward

touch /x1.img
losetup -r /dev/loop0 /x1.img
losetup -d /dev/loop0
losetup /dev/loop0 /x1.img
/dev/loop0: Permission denied


2) it breaks read-only dm-snapshots
(Fedora LiveCD operations is broken by this as well.)

(x.img is backing device, xs.img is prepared COW, you can simply run it
once in read-write to create dm-snap header and then re-run this commands)

losetup -r /dev/loop0 /x.img
losetup -r /dev/loop1 /xs.img
dmsetup create x --readonly --table '0 131072 snapshot /dev/loop0 /dev/loop1 p 8'
device-mapper: reload ioctl failed: Permission denied

Milan
