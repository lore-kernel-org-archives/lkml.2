Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752817Ab2LQWdw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 17:33:52 -0500
Received: from mail-wg0-f47.google.com ([74.125.82.47]:34938 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750989Ab2LQWdv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 17:33:51 -0500
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Mon, 17 Dec 2012 17:33:51 EST
Date: Mon, 17 Dec 2012 23:26:38 +0100
From: "Dae S. Kim" <dae@velatum.com>
To: arnd@arndb.de
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org
Subject: [PATCH] char/misc.c: misc_register: Do not loop on misc_list
 unconditionally
Message-ID: <20121217222638.GA3747@Delta>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the minor number is assigned dynamically, there is no need to
search for misc->minor in misc_list, since misc->minor == 
MISC_DYNAMIC_MINOR.

Signed-off-by: Dae S. Kim <dae@velatum.com>
---
 drivers/char/misc.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/char/misc.c b/drivers/char/misc.c
index 522136d..7b262b6 100644
--- a/drivers/char/misc.c
+++ b/drivers/char/misc.c
@@ -190,12 +190,6 @@ int misc_register(struct miscdevice * misc)
 	INIT_LIST_HEAD(&misc->list);
 
 	mutex_lock(&misc_mtx);
-	list_for_each_entry(c, &misc_list, list) {
-		if (c->minor == misc->minor) {
-			mutex_unlock(&misc_mtx);
-			return -EBUSY;
-		}
-	}
 
 	if (misc->minor == MISC_DYNAMIC_MINOR) {
 		int i = find_first_zero_bit(misc_minors, DYNAMIC_MINORS);
@@ -205,6 +199,13 @@ int misc_register(struct miscdevice * misc)
 		}
 		misc->minor = DYNAMIC_MINORS - i - 1;
 		set_bit(i, misc_minors);
+	} else {
+		list_for_each_entry(c, &misc_list, list) {
+			if (c->minor == misc->minor) {
+				mutex_unlock(&misc_mtx);
+				return -EBUSY;
+			}
+		}
 	}
 
 	dev = MKDEV(MISC_MAJOR, misc->minor);
-- 
1.7.9.5

