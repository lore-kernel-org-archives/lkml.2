Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752244Ab1CWAtg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 20:49:36 -0400
Received: from ja.ssi.bg ([178.16.129.10]:58246 "EHLO ja.ssi.bg"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751634Ab1CWAte (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 20:49:34 -0400
X-Greylist: delayed 573 seconds by postgrey-1.27 at vger.kernel.org; Tue, 22 Mar 2011 20:49:34 EDT
Date: Wed, 23 Mar 2011 02:45:26 +0200
Message-Id: <201103230045.p2N0jQjL011728@ja.ssi.bg>
MIME-Version: 1.0
From: Julian Anastasov <ja@ssi.bg>
To: Greg Kroah-Hartman <gregkh@suse.de>
CC: linux-kernel@vger.kernel.org
Subject: [PATCH] tty: fix tty->ldisc leak on ENODEV from driver install
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	When a USB serial device is not attached I see
open() to leak 8-byte structures:

modprobe usbserial
[ -e /dev/ttyUSB0 ] && cat /dev/ttyUSB0
cat: /dev/ttyUSB0: No such device

	Note that error must be ENODEV with usbserial
loaded and when name exists, not ENXIO.

	kmemleak shows such output:

unreferenced object 0xc0e19860 (size 8):
  comm cat, pid 1226, jiffies 4294919464 (age 287.476s)
  hex dump (first 8 bytes):
    44 de 2d c1 01 00 00 00                          D.-.....
  backtrace:
    [<c1065a74>] create_object+0x109/0x1ad
    [<c1063d2b>] kmem_cache_alloc+0x60/0x68
    [<c113505c>] tty_ldisc_get+0x54/0x76
    [<c11358c9>] tty_ldisc_init+0xa/0x20
    [<c1130ab4>] initialize_tty_struct+0x2d/0x1ac
    [<c1130c8c>] tty_init_dev+0x59/0x10d
    [<c113136d>] tty_open+0x24a/0x3a2
    [<c1069516>] chrdev_open+0xd1/0xef
    [<c106d2d5>] nameidata_drop_rcu_last+0x3b/0x49
    [<c1069445>] chrdev_open+0x0/0xef
    [<c1065d42>] __dentry_open.clone.15+0xec/0x1c3
    [<c10669a5>] nameidata_to_filp+0x2a/0x33
    [<c106f7c7>] finish_open+0x6e/0xfc
    [<c106fbda>] do_filp_open+0x144/0x4af
    [<c1076f55>] alloc_fd+0x41/0xa5
    [<c10669ef>] do_sys_open+0x41/0xc3

	Looking at tty_init_dev() it seems initialize_tty_struct()
attaches tty->ldisc via tty_ldisc_init() but on
tty_driver_install_tty() failure (-ENODEV) we call free_tty_struct()
which does nothing with tty->ldisc.

	The appended patch fixes the leak but I'm not
sure what tty->ldisc value we can see in release_one_tty(),
I assume if ldisc is freed tty->ldisc should be NULL, so
free_tty_struct() will not try to double-free the ldisc.

Signed-off-by: Julian Anastasov <ja@ssi.bg>
---
 drivers/tty/tty_io.c |    1 +
 1 file changed, 1 insertion(+)

--- linux-2.6.38/drivers/tty/tty_io.c
+++ linux-2.6.38/drivers/tty/tty_io.c
@@ -188,6 +188,7 @@ void free_tty_struct(struct tty_struct *
 		put_device(tty->dev);
 	kfree(tty->write_buf);
 	tty_buffer_free_all(tty);
+	kfree(tty->ldisc);
 	kfree(tty);
 }
 
