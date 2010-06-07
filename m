Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752891Ab0FGFay (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 01:30:54 -0400
Received: from mailq1.tnnet.fi ([217.112.240.127]:55459 "EHLO mailq1.tnnet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751983Ab0FGFaw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 01:30:52 -0400
X-Greylist: delayed 620 seconds by postgrey-1.27 at vger.kernel.org; Mon, 07 Jun 2010 01:30:52 EDT
Message-ID: <4C0C819E.EA5D6A18@users.sourceforge.net>
Date: Mon, 07 Jun 2010 08:20:30 +0300
From: Jari Ruusu <jariruusu@users.sourceforge.net>
To: linux-kernel@vger.kernel.org
CC: Rusty Russell <rusty@rustcorp.com.au>, Al Viro <viro@zeniv.linux.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: 2.6.35-rc2 module reference counting broken
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Someone broke block device module reference counting. Problem occours when a
modular block device is mounted and unmounted. Not when it is directly read.
2.6.34 kernel works OK, but 2.6.35-rc2 kernel seems to increase usage count
by one for each mount + umount pair.

# uname -s -r -m
Linux 2.6.35-rc2 i686
# grep CONFIG_SMP /usr/src/linux-2.6.35-rc2/.config
# CONFIG_SMP is not set
# grep CONFIG_MODULE_UNLOAD /usr/src/linux-2.6.35-rc2/.config
CONFIG_MODULE_UNLOAD=y
# grep CONFIG_BLK_DEV_FD /usr/src/linux-2.6.35-rc2/.config
CONFIG_BLK_DEV_FD=m
# lsmod
Module                  Size  Used by
# modprobe floppy
# lsmod
Module                  Size  Used by
floppy                 40029  0
# mount -t ext2 /dev/fd0 /mnt
# umount /mnt
# lsmod
Module                  Size  Used by
floppy                 40029  1
# rmmod floppy
ERROR: Module floppy is in use
# echo $?
1
# 

(reboot)

# uname -s -r -m
Linux 2.6.35-rc2 i686
# lsmod
Module                  Size  Used by
# modprobe floppy
# lsmod
Module                  Size  Used by
floppy                 40029  0
# dd if=/dev/fd0 of=/dev/null bs=4096 count=1 conv=notrunc 2>/dev/null
# lsmod
Module                  Size  Used by
floppy                 40029  0
# rmmod floppy
# echo $?
0
# lsmod
Module                  Size  Used by
# 

-- 
Jari Ruusu  1024R/3A220F51 5B 4B F9 BB D3 3F 52 E9  DB 1D EB E3 24 0E A9 DD
