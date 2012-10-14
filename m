Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754599Ab2JNOmn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2012 10:42:43 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46353 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754586Ab2JNOmk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2012 10:42:40 -0400
Message-Id: <20121014143547.834371336@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 14 Oct 2012 15:37:17 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Martin Michlmayr <tbm@cyrius.com>,
        Jonathan Nieder <jrnieder@gmail.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 104/147] drivers/scsi/atp870u.c: fix bad use of udelay
In-Reply-To: <20121014143533.742627615@decadent.org.uk>
X-SA-Exim-Connect-IP: 77.75.106.1
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Martin Michlmayr <tbm@cyrius.com>

commit 0f6d93aa9d96cc9022b51bd10d462b03296be146 upstream.

The ACARD driver calls udelay() with a value > 2000, which leads to to
the following compilation error on ARM:

  ERROR: "__bad_udelay" [drivers/scsi/atp870u.ko] undefined!
  make[1]: *** [__modpost] Error 1

This is because udelay is defined on ARM, roughly speaking, as

	#define udelay(n) ((n) > 2000 ? __bad_udelay() : \
		__const_udelay((n) * ((2199023U*HZ)>>11)))

The argument to __const_udelay is the number of jiffies to wait divided
by 4, but this does not work unless the multiplication does not
overflow, and that is what the build error is designed to prevent.  The
intended behavior can be achieved by using mdelay to call udelay
multiple times in a loop.

[jrnieder@gmail.com: adding context]
Signed-off-by: Martin Michlmayr <tbm@cyrius.com>
Signed-off-by: Jonathan Nieder <jrnieder@gmail.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/scsi/atp870u.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/atp870u.c b/drivers/scsi/atp870u.c
index 68ce085..a540162 100644
--- a/drivers/scsi/atp870u.c
+++ b/drivers/scsi/atp870u.c
@@ -1173,7 +1173,16 @@ wait_io1:
 	outw(val, tmport);
 	outb(2, 0x80);
 TCM_SYNC:
-	udelay(0x800);
+	/*
+	 * The funny division into multiple delays is to accomodate
+	 * arches like ARM where udelay() multiplies its argument by
+	 * a large number to initialize a loop counter.  To avoid
+	 * overflow, the maximum supported udelay is 2000 microseconds.
+	 *
+	 * XXX it would be more polite to find a way to use msleep()
+	 */
+	mdelay(2);
+	udelay(48);
 	if ((inb(tmport) & 0x80) == 0x00) {	/* bsy ? */
 		outw(0, tmport--);
 		outb(0, tmport);


