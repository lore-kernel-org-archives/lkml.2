Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754196Ab0JSSNp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 14:13:45 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:65241 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751783Ab0JSSNo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 14:13:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=ANQxuTNk0QKWyieZK6tKy3BydqDYZOmmiYM2Lf1fkBFeMbDFNmjNYkV8orbP9lrX2H
         PNp/ETLNnAew+fkU3fQ0qFewhM9wu4S7d/6hilI7MlW/kweX5Q9XgcKRj36RaNIM3s2G
         ErSfgaGou9l85bszbR3KN8+rmyQA8bVBAPn24=
MIME-Version: 1.0
Date: Wed, 20 Oct 2010 02:13:41 +0800
Message-ID: <AANLkTi=SA6w6DaM=9HojUDsosTXDhrdXLk7cRAa=hUHo@mail.gmail.com>
Subject: dm-snap-mv update
From: McPacino <mcpacino@gmail.com>
To: linux-kernel@vger.kernel.org,
        device-mapper development <dm-devel@redhat.com>,
        linux-fsdevel@vger.kernel.org
Cc: Mike Snitzer <snitzer@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I removed the dependence on my block-size kernel patch by calling
set_blocksize(cow_dev, 4096). Ext FS does something like this
too while mounting if the blocksize of FS is not equal to the
blocksize of block device.

Now, dm-snap-mv can well run in kernel >= 2.6.33.

I built KMP rpm packages for the origin kernels of OpenSUSE 11.3
and Fedora 13 in opnesuse build service. Ubuntu and Debian are
on the way.

Hi Mike, Is it possible and how could I make my code included in
upstream device-mapper? Desire your reply and thanks in advance.

The built rpm can be downloaded on:
https://build.opensuse.org/package/show?package=dm-snap-mv&project=home%3Amcpacino
or
http://download.opensuse.org/repositories/home:/mcpacino/


The new home page of dm-snap-mv is:
http://mcpacino.github.com/dm-snap-mv/


Following is some usage examples to illustrate what does dm-snap-mv do:

(origin device: sdb1     COW device: sdc1)

# Init COW device, bind origin device to it. Create orig dm_dev
    # dms create orig sdb1 sdc1 -bF
    # mount /dev/mapper/orig /mnt/orig
    # touch /mnt/orig/this-is-orig
    # ll /mnt/orig/
    -rw-r--r-- 1 root root 0 2010-10-19 21:39 this-is-orig


# Take a snapshot of origin. Create snap1 dm_dev
    # dms snapshot orig -m snap1
    # dms create snap1 sdb1 sdc1 1
    # mount /dev/mapper/snap1 /mnt/snap1/
    # touch /mnt/snap1/this-is-snap1
    # ll /mnt/snap1/
    -rw-r--r-- 1 root root 0 2010-10-19 21:39 this-is-orig
    -rw-r--r-- 1 root root 0 2010-10-19 21:42 this-is-snap1


# Take a snapshot of snap1. Create snap2 dm_dev
    # dms snapshot orig 1 -m snap2
    # dms create snap2 sdb1 sdc1 2
    # mount /dev/mapper/snap2 /mnt/snap2/
    # touch /mnt/snap2/this-is-snap2
    # ll /mnt/snap2/
    -rw-r--r-- 1 root root 0 2010-10-19 21:39 this-is-orig
    -rw-r--r-- 1 root root 0 2010-10-19 21:42 this-is-snap1
    -rw-r--r-- 1 root root 0 2010-10-19 21:43 this-is-snap2


# List all snapshots
    # dms list
          origin-device : sdb1 (8:17)
             cow-device : sdc1 (8:33)
             chunk-size : 1 page(s)
          used-versions : 0% (3/640)
            used-chunks : 0% (946/7865817)
             cow-status : valid
               cleaning : no
            rollbacking : no
    YYYY/MM/DD HH:MM:SS   Tag   R   Chunks   DM_Dev   Memo
    2010/10/19 21:38:37   0     .   0        orig     "ORIGIN"
    2010/10/19 21:41:28   1     .   5        snap1    "snap1"
    2010/10/19 21:42:57   2     .   5        snap2    "snap2"


# Rollback snap2 to origin
    # umount /mnt/orig
    # dms remove orig
    # dms rollback snap2 2
    # dms create orig sdb1 sdc1
    # mount /dev/mapper/orig /mnt/orig
    # touch /mnt/orig/this-is-orig-after-rollback
    # ll /mnt/orig
    -rw-r--r-- 1 root root 0 2010-10-19 21:39 this-is-orig
    -rw-r--r-- 1 root root 0 2010-10-19 22:04 this-is-orig-after-rollback
    -rw-r--r-- 1 root root 0 2010-10-19 21:42 this-is-snap1
    -rw-r--r-- 1 root root 0 2010-10-19 21:43 this-is-snap2


# Stop dm-snap-mv. Take a look at origin device sdb2
    # umount /mnt/orig /mnt/snap1 /mnt/snap2
    # dmsetup remove_all
    # mount /dev/sdb1 /mnt/
    # ll /mnt/
    -rw-r--r-- 1 root root 0 2010-10-19 21:39 this-is-orig
    -rw-r--r-- 1 root root 0 2010-10-19 22:04 this-is-orig-after-rollback
    -rw-r--r-- 1 root root 0 2010-10-19 21:42 this-is-snap1
    -rw-r--r-- 1 root root 0 2010-10-19 21:43 this-is-snap2


Regards.

cong meng
