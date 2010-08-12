Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933103Ab0HLARx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 20:17:53 -0400
Received: from kroah.org ([198.145.64.141]:60514 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932748Ab0HLAIM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 20:08:12 -0400
X-Mailbox-Line: From gregkh@clark.site Wed Aug 11 17:06:14 2010
Message-Id: <20100812000614.505816950@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 11 Aug 2010 17:05:35 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jiri Slaby <jslaby@suse.cz>, Alan Cox <alan@linux.intel.com>
Subject: [20/67] Char: nozomi, set tty->driver_data appropriately
In-Reply-To: <20100812000641.GA6348@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jiri Slaby <jslaby@suse.cz>

commit bf9c1fca9ae9a79ed209e7ab2c10b3862f3f6f72 upstream.

Sorry, one more fix, this one depends on the other, so this is rather 2/2.
--

tty->driver_data is used all over the code, but never set. This
results in oopses like:
BUG: unable to handle kernel NULL pointer dereference at 0000000000000130
IP: [<ffffffff814a0040>] mutex_lock+0x10/0x40
...
Pid: 2157, comm: modem-manager Not tainted 2.6.34.1-0.1-desktop #1 2768DR7/2768DR7
RIP: 0010:[<ffffffff814a0040>]  [<ffffffff814a0040>] mutex_lock+0x10/0x40
RSP: 0018:ffff88007b16fa50  EFLAGS: 00010286
RAX: 0000000000000000 RBX: 0000000000000130 RCX: 0000000000000003
RDX: 0000000000000003 RSI: 0000000000000286 RDI: 0000000000000130
RBP: 0000000000001000 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000001 R11: 0000000000000000 R12: 0000000000000130
R13: 0000000000000001 R14: 0000000000000000 R15: ffff88007b16feb4
...
Call Trace:
 [<ffffffffa077690d>] ntty_write_room+0x4d/0x90 [nozomi]
...

Set tty->driver_data to the computed port in .install to not recompute it in
every place where needed. Switch .open to use driver_data too.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Alan Cox <alan@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/char/nozomi.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/char/nozomi.c
+++ b/drivers/char/nozomi.c
@@ -1612,6 +1612,7 @@ static int ntty_install(struct tty_drive
 	if (ret == 0) {
 		tty_driver_kref_get(driver);
 		tty->count++;
+		tty->driver_data = port;
 		driver->ttys[tty->index] = tty;
 	}
 	return ret;
@@ -1640,7 +1641,7 @@ static int ntty_activate(struct tty_port
 
 static int ntty_open(struct tty_struct *tty, struct file *filp)
 {
-	struct port *port = get_port_by_tty(tty);
+	struct port *port = tty->driver_data;
 	return tty_port_open(&port->port, tty, filp);
 }
 


