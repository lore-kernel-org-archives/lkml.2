Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756538Ab2HGUCe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 16:02:34 -0400
Received: from mail.pripojeni.net ([178.22.112.14]:36549 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756438Ab2HGT7p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 15:59:45 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: alan@linux.intel.com, linux-kernel@vger.kernel.org, jirislaby@gmail.com
Subject: [PATCH 12/41] mxser: allow overlapping vector
Date: Tue,  7 Aug 2012 21:47:37 +0200
Message-Id: <1344368886-24033-13-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1344368886-24033-1-git-send-email-jslaby@suse.cz>
References: <1344368886-24033-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For many cards, this saves some IO space because interrupt status port
has precedence over the rest of ports on the card. Hence it can be
mapped to a hole in I/O ports.

Here we add a kernel parameter which allows that if a user wants to.
But they need to explicitly enable it by a module parameter.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/tty/mxser.c |   35 +++++++++++++++++++++++++++++++----
 1 file changed, 31 insertions(+), 4 deletions(-)

diff --git a/drivers/tty/mxser.c b/drivers/tty/mxser.c
index c162ee9..e64fe40 100644
--- a/drivers/tty/mxser.c
+++ b/drivers/tty/mxser.c
@@ -2337,11 +2337,36 @@ static struct tty_port_operations mxser_port_ops = {
  * The MOXA Smartio/Industio serial driver boot-time initialization code!
  */
 
+static bool allow_overlapping_vector;
+module_param(allow_overlapping_vector, bool, 444);
+MODULE_PARM_DESC(allow_overlapping_vector, "whether we allow ISA cards to be configured such that vector overlabs IO ports (default=no)");
+
+static bool mxser_overlapping_vector(struct mxser_board *brd)
+{
+	return allow_overlapping_vector &&
+		brd->vector >= brd->ports[0].ioaddr &&
+		brd->vector < brd->ports[0].ioaddr + 8 * brd->info->nports;
+}
+
+static int mxser_request_vector(struct mxser_board *brd)
+{
+	if (mxser_overlapping_vector(brd))
+		return 0;
+	return request_region(brd->vector, 1, "mxser(vector)") ? 0 : -EIO;
+}
+
+static void mxser_release_vector(struct mxser_board *brd)
+{
+	if (mxser_overlapping_vector(brd))
+		return;
+	release_region(brd->vector, 1);
+}
+
 static void mxser_release_ISA_res(struct mxser_board *brd)
 {
 	free_irq(brd->irq, brd);
 	release_region(brd->ports[0].ioaddr, 8 * brd->info->nports);
-	release_region(brd->vector, 1);
+	mxser_release_vector(brd);
 }
 
 static int __devinit mxser_initbrd(struct mxser_board *brd,
@@ -2396,7 +2421,7 @@ static int __devinit mxser_initbrd(struct mxser_board *brd,
 
 static int __init mxser_get_ISA_conf(int cap, struct mxser_board *brd)
 {
-	int id, i, bits;
+	int id, i, bits, ret;
 	unsigned short regs[16], irq;
 	unsigned char scratch, scratch2;
 
@@ -2492,13 +2517,15 @@ static int __init mxser_get_ISA_conf(int cap, struct mxser_board *brd)
 				8 * brd->info->nports - 1);
 		return -EIO;
 	}
-	if (!request_region(brd->vector, 1, "mxser(vector)")) {
+
+	ret = mxser_request_vector(brd);
+	if (ret) {
 		release_region(brd->ports[0].ioaddr, 8 * brd->info->nports);
 		printk(KERN_ERR "mxser: can't request interrupt vector region: "
 				"0x%.8lx-0x%.8lx\n",
 				brd->ports[0].ioaddr, brd->ports[0].ioaddr +
 				8 * brd->info->nports - 1);
-		return -EIO;
+		return ret;
 	}
 	return brd->info->nports;
 
-- 
1.7.10.4


