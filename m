Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752430Ab0C0JQz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Mar 2010 05:16:55 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:41629 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752260Ab0C0JQx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Mar 2010 05:16:53 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sat, 27 Mar 2010 10:16:26 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH] firewire: char device files are not seekable (BKL removal)
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
       Kristian Hoegsberg <krh@bitplanet.net>,
       Jay Fenlason <fenlason@redhat.com>
In-Reply-To: <4BAD4795.2040700@s5r6.in-berlin.de>
Message-ID: <tkrat.97e3b5cd68881a29@s5r6.in-berlin.de>
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

The <linux/firewire-cdev.h> character device file ABI is based on
  - ioctl() to initiate actions,
  - read() to consume events,
  - mmap() for isochronous I/O DMA buffers.
lseek(), pread(), pwrite() (or any kind of write() at all) on the other
hand are not applicable to /dev/fw* device files.

Alas, whereas for example file_operations.write == NULL causes write()
to be failed with an appropriate error, file_operations.llseek == NULL
causes fs/read_write.c::default_llseek to be called on lseek() per
default.

This looks like not doing any harm, but it grabs the Big Kernel Lock.
We don't want that, and we should return an error on lseek() and
friends.  This is provided by fs/read_write.c::no_llseek which we get if
we clear the FMODE_LSEEK (and FMODE_PREAD, FMODE_PWRITE) flag by means
of nonseekable_open().

Side note:  The firewire-cdev interface has always been free of any BKL
usage apart from this oversight regarding default_llseek (and from
involuntary BKL usage by open() in older kernels).

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---

Somebody correct me if I got anything wrong in my patch description.

This patch is motivated by Arnd's
"bkl removal: make unlocked_ioctl mandatory"
http://git.kernel.org/?p=linux/kernel/git/arnd/playground.git;a=blobdiff;f=drivers/firewire/core-cdev.c;h=4464b9dc01a8c69258a1e8880e9a390f17420b6c;hp=4eeaed57e2197a0dd5f0cab7cffa4713eaf2ec96;hb=05e7753338045e9ee3950b2da032c5e5774efa90;hpb=03165e1d096afb4b1d9cfccdad66eed038121cec
"BKL removal: mark remaining users as 'depends on BKL'"
http://git.kernel.org/?p=linux/kernel/git/arnd/playground.git;a=blobdiff;f=drivers/firewire/Kconfig;h=ae6d45900230dfbdc32c099d6a026ecfd0a6f5c2;hp=a9371b36a9b9c3074f5b31d7bdacf1bda72a15dd;hb=abb83d8fe5f8dcc8fca09bd9117429f73e1417e0;hpb=33c014b118f45516113d4b6823e40ea6f834dc6a


 drivers/firewire/core-cdev.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: b/drivers/firewire/core-cdev.c
===================================================================
--- a/drivers/firewire/core-cdev.c
+++ b/drivers/firewire/core-cdev.c
@@ -226,7 +226,7 @@ static int fw_device_op_open(struct inod
 	list_add_tail(&client->link, &device->client_list);
 	mutex_unlock(&device->client_list_mutex);
 
-	return 0;
+	return nonseekable_open(inode, file);
 }
 
 static void queue_event(struct client *client, struct event *event,

-- 
Stefan Richter
-=====-==-=- --== ==-==
http://arcgraph.de/sr/

