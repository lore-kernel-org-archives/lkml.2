Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932949Ab0IXQfB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 12:35:01 -0400
Received: from kroah.org ([198.145.64.141]:37000 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932342Ab0IXQet (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 12:34:49 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Sep 24 09:33:44 2010
Message-Id: <20100924163344.098490614@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 24 Sep 2010 09:31:25 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Dan Rosenberg <dan.j.rosenberg@gmail.com>
Subject: [01/68] USB: serial/mos*: prevent reading uninitialized stack memory
In-Reply-To: <20100924163357.GA15741@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Dan Rosenberg <drosenberg@vsecurity.com>

commit a0846f1868b11cd827bdfeaf4527d8b1b1c0b098 upstream.

The TIOCGICOUNT device ioctl in both mos7720.c and mos7840.c allows
unprivileged users to read uninitialized stack memory, because the
"reserved" member of the serial_icounter_struct struct declared on the
stack is not altered or zeroed before being copied back to the user.
This patch takes care of it.

Signed-off-by: Dan Rosenberg <dan.j.rosenberg@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/serial/mos7720.c |    3 +++
 drivers/usb/serial/mos7840.c |    3 +++
 2 files changed, 6 insertions(+)

--- a/drivers/usb/serial/mos7720.c
+++ b/drivers/usb/serial/mos7720.c
@@ -1466,6 +1466,9 @@ static int mos7720_ioctl(struct tty_stru
 
 	case TIOCGICOUNT:
 		cnow = mos7720_port->icount;
+
+		memset(&icount, 0, sizeof(struct serial_icounter_struct));
+
 		icount.cts = cnow.cts;
 		icount.dsr = cnow.dsr;
 		icount.rng = cnow.rng;
--- a/drivers/usb/serial/mos7840.c
+++ b/drivers/usb/serial/mos7840.c
@@ -2287,6 +2287,9 @@ static int mos7840_ioctl(struct tty_stru
 	case TIOCGICOUNT:
 		cnow = mos7840_port->icount;
 		smp_rmb();
+
+		memset(&icount, 0, sizeof(struct serial_icounter_struct));
+
 		icount.cts = cnow.cts;
 		icount.dsr = cnow.dsr;
 		icount.rng = cnow.rng;


