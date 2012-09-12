Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760076Ab2ILPIm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 11:08:42 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:56430 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759895Ab2ILPHQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 11:07:16 -0400
From: Peter Senna Tschudin <peter.senna@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: kernel-janitors@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 7/9] drivers/char/mmtimer.c: Remove useless kfree
Date: Wed, 12 Sep 2012 17:06:45 +0200
Message-Id: <1347462407-13499-7-git-send-email-peter.senna@gmail.com>
X-Mailer: git-send-email 1.7.11.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Senna Tschudin <peter.senna@gmail.com>

Remove useless kfree() and clean up code related to the removal.

The semantic patch that finds this problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@r exists@
position p1,p2;
expression x;
@@

if (x@p1 == NULL) { ... kfree@p2(x); ... return ...; }

@unchanged exists@
position r.p1,r.p2;
expression e <= r.x,x,e1;
iterator I;
statement S;
@@

if (x@p1 == NULL) { ... when != I(x,...) S
                        when != e = e1
                        when != e += e1
                        when != e -= e1
                        when != ++e
                        when != --e
                        when != e++
                        when != e--
                        when != &e
   kfree@p2(x); ... return ...; }

@ok depends on unchanged exists@
position any r.p1;
position r.p2;
expression x;
@@

... when != true x@p1 == NULL
kfree@p2(x);

@depends on !ok && unchanged@
position r.p2;
expression x;
@@

*kfree@p2(x);
// </smpl>

Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>

---
 drivers/char/mmtimer.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/char/mmtimer.c b/drivers/char/mmtimer.c
index 33dc229..3d6c067 100644
--- a/drivers/char/mmtimer.c
+++ b/drivers/char/mmtimer.c
@@ -826,7 +826,7 @@ static int __init mmtimer_init(void)
 
 	/* Allocate list of node ptrs to mmtimer_t's */
 	timers = kzalloc(sizeof(struct mmtimer_node)*maxn, GFP_KERNEL);
-	if (timers == NULL) {
+	if (!timers) {
 		printk(KERN_ERR "%s: failed to allocate memory for device\n",
 				MMTIMER_NAME);
 		goto out3;
@@ -848,7 +848,6 @@ static int __init mmtimer_init(void)
 	return 0;
 
 out3:
-	kfree(timers);
 	misc_deregister(&mmtimer_miscdev);
 out2:
 	free_irq(SGI_MMTIMER_VECTOR, NULL);

