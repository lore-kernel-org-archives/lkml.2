Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752554Ab0C0JUc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Mar 2010 05:20:32 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:41641 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752452Ab0C0JUb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Mar 2010 05:20:31 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sat, 27 Mar 2010 10:20:18 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH] ieee1394: char device files are not seekable (BKL removal)
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
       Dan Dennedy <dan@dennedy.org>
In-Reply-To: <4BAD4795.2040700@s5r6.in-berlin.de>
Message-ID: <tkrat.3d0d526ea7cecc39@s5r6.in-berlin.de>
References: <201003242240.54907.arnd@arndb.de>
 <alpine.LRH.2.00.1003251354200.16443@twin.jikos.cz>
 <201003251406.10177.arnd@arndb.de> <201003251438.59062.arnd@arndb.de>
 <4BAD4795.2040700@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The raw1394 character device file ABI is based on
  - write() or ioctl() to initiate actions,
    with write being used exactly like _IOW ioctls,
  - read() to consume events,
  - mmap() for isochronous I/O DMA buffers.

The video1394 character device file ABI is based on
  - ioctl() to initiate actions,
  - mmap() for isochronous I/O DMA buffers.

The dv1394 character device file ABI is based on
  - ioctl() to initiate actions,
  - read() and write() for simple serial reception and transmission of
    DV streams with a copy_to/from_user,
  - mmap() for isochronous I/O DMA buffers for I/O without user copy.

lseek(), pread(), pwrite() on the other hand are not applicable to
/dev/raw1394, /dev/video1394/*, and /dev/dv1394/* device files.

Alas, file_operations.llseek == NULL causes lseek() to call
fs/read_write.c::default_llseek per default.  This looks like not doing
any harm in either of the three drivers, but it grabs the Big Kernel
Lock.  We don't want that, and we should return an error on lseek() and
friends.  This is provided by fs/read_write.c::no_llseek which we get if
we clear the FMODE_LSEEK (and FMODE_PREAD, FMODE_PWRITE) flag by means
of nonseekable_open().

Side note:  Apart from this oversight regarding default_llseek, the
raw1394, video1394, and dv1394 interfaces have been converted away from
BKL usage some time ago.  Although all this is legacy code which should
be left in peace until it is eventually removed (as it is superseded by
firewire-core's <linux/firewire-cdev.h> ABI), this change seems still
worth doing to further minimize the presence of BKL usage in the kernel.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---

Somebody correct me if I misunderstood anything of these ABIs.

This patch is motivated by Arnd's
"bkl removal: make unlocked_ioctl mandatory"
http://git.kernel.org/?p=linux/kernel/git/arnd/playground.git;a=blobdiff;f=drivers/ieee1394/raw1394.c;h=7c312331fc14facd8d3e2f8cf05daf090fd88e71;hp=8aa56ac07e2920d371a5af41eca7f09c8b752380;hb=05e7753338045e9ee3950b2da032c5e5774efa90;hpb=03165e1d096afb4b1d9cfccdad66eed038121cec
etc., and
"BKL removal: mark remaining users as 'depends on BKL'"
http://git.kernel.org/?p=linux/kernel/git/arnd/playground.git;a=blobdiff;f=drivers/ieee1394/Kconfig;h=0d4954c2615233ccdd8ed28ba2e7b36ed1c7941d;hp=e02096cf7d95bfa383bddb703bbfbff6b782e688;hb=abb83d8fe5f8dcc8fca09bd9117429f73e1417e0;hpb=33c014b118f45516113d4b6823e40ea6f834dc6a


 drivers/ieee1394/dv1394.c    |    2 +-
 drivers/ieee1394/raw1394.c   |    2 +-
 drivers/ieee1394/video1394.c |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

Index: b/drivers/ieee1394/dv1394.c
===================================================================
--- a/drivers/ieee1394/dv1394.c
+++ b/drivers/ieee1394/dv1394.c
@@ -1824,7 +1824,7 @@ static int dv1394_open(struct inode *ino
 	       "and will not be available in the new firewire driver stack. "
 	       "Try libraw1394 based programs instead.\n", current->comm);
 
-	return 0;
+	return nonseekable_open(inode, file);
 }
 
 
Index: b/drivers/ieee1394/raw1394.c
===================================================================
--- a/drivers/ieee1394/raw1394.c
+++ b/drivers/ieee1394/raw1394.c
@@ -2834,7 +2834,7 @@ static int raw1394_open(struct inode *in
 
 	file->private_data = fi;
 
-	return 0;
+	return nonseekable_open(inode, file);
 }
 
 static int raw1394_release(struct inode *inode, struct file *file)
Index: b/drivers/ieee1394/video1394.c
===================================================================
--- a/drivers/ieee1394/video1394.c
+++ b/drivers/ieee1394/video1394.c
@@ -1239,7 +1239,7 @@ static int video1394_open(struct inode *
 	ctx->current_ctx = NULL;
 	file->private_data = ctx;
 
-	return 0;
+	return nonseekable_open(inode, file);
 }
 
 static int video1394_release(struct inode *inode, struct file *file)

-- 
Stefan Richter
-=====-==-=- --== ==-==
http://arcgraph.de/sr/

