Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755288Ab1CUXPL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 19:15:11 -0400
Received: from kroah.org ([198.145.64.141]:49228 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755221Ab1CUXPD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 19:15:03 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Mar 21 16:07:09 2011
Message-Id: <20110321230709.791490708@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Mon, 21 Mar 2011 16:06:05 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Joakim Tjernlund <Joakim.Tjernlund@transmode.se>,
        Michael Cashwell <mboards@prograde.net>,
        Stefan Bigler <stefan.bigler@keymile.com>,
        Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
        David Woodhouse <David.Woodhouse@intel.com>
Subject: [06/87] mtd: fix race in cfi_cmdset_0001 driver
In-Reply-To: <20110321230732.GA26510@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Joakim Tjernlund <Joakim.Tjernlund@transmode.se>

commit ecf3fde07c8dcb92a1bf3fbdfe70905d85cd00e1 upstream.

As inval_cache_and_wait_for_operation() drop and reclaim the lock
to invalidate the cache, some other thread may suspend the operation
before reaching the for(;;) loop. Therefore the loop must start with
checking the chip->state before reading status from the chip.

Signed-off-by: Joakim Tjernlund <Joakim.Tjernlund@transmode.se>
Acked-by: Michael Cashwell <mboards@prograde.net>
Acked-by: Stefan Bigler <stefan.bigler@keymile.com>
Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/mtd/chips/cfi_cmdset_0001.c |   43 ++++++++++++++++++------------------
 1 file changed, 22 insertions(+), 21 deletions(-)

--- a/drivers/mtd/chips/cfi_cmdset_0001.c
+++ b/drivers/mtd/chips/cfi_cmdset_0001.c
@@ -1229,10 +1229,32 @@ static int inval_cache_and_wait_for_oper
 	sleep_time = chip_op_time / 2;
 
 	for (;;) {
+		if (chip->state != chip_state) {
+			/* Someone's suspended the operation: sleep */
+			DECLARE_WAITQUEUE(wait, current);
+			set_current_state(TASK_UNINTERRUPTIBLE);
+			add_wait_queue(&chip->wq, &wait);
+			mutex_unlock(&chip->mutex);
+			schedule();
+			remove_wait_queue(&chip->wq, &wait);
+			mutex_lock(&chip->mutex);
+			continue;
+		}
+
 		status = map_read(map, cmd_adr);
 		if (map_word_andequal(map, status, status_OK, status_OK))
 			break;
 
+		if (chip->erase_suspended && chip_state == FL_ERASING)  {
+			/* Erase suspend occured while sleep: reset timeout */
+			timeo = reset_timeo;
+			chip->erase_suspended = 0;
+		}
+		if (chip->write_suspended && chip_state == FL_WRITING)  {
+			/* Write suspend occured while sleep: reset timeout */
+			timeo = reset_timeo;
+			chip->write_suspended = 0;
+		}
 		if (!timeo) {
 			map_write(map, CMD(0x70), cmd_adr);
 			chip->state = FL_STATUS;
@@ -1256,27 +1278,6 @@ static int inval_cache_and_wait_for_oper
 			timeo--;
 		}
 		mutex_lock(&chip->mutex);
-
-		while (chip->state != chip_state) {
-			/* Someone's suspended the operation: sleep */
-			DECLARE_WAITQUEUE(wait, current);
-			set_current_state(TASK_UNINTERRUPTIBLE);
-			add_wait_queue(&chip->wq, &wait);
-			mutex_unlock(&chip->mutex);
-			schedule();
-			remove_wait_queue(&chip->wq, &wait);
-			mutex_lock(&chip->mutex);
-		}
-		if (chip->erase_suspended && chip_state == FL_ERASING)  {
-			/* Erase suspend occured while sleep: reset timeout */
-			timeo = reset_timeo;
-			chip->erase_suspended = 0;
-		}
-		if (chip->write_suspended && chip_state == FL_WRITING)  {
-			/* Write suspend occured while sleep: reset timeout */
-			timeo = reset_timeo;
-			chip->write_suspended = 0;
-		}
 	}
 
 	/* Done and happy. */


