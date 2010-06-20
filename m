Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751946Ab0FTLYn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jun 2010 07:24:43 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:48724 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751051Ab0FTLYk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jun 2010 07:24:40 -0400
Date: Sun, 20 Jun 2010 13:24:35 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 1/2] drivers/hid: Eliminate a double lock
Message-ID: <Pine.LNX.4.64.1006201324170.4366@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

The path around the loop ends with the lock held, so the call to mutex_lock
is moved before the beginning of the loop.

A simplified version of the semantic match that finds this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@locked@
expression E1;
position p;
@@

read_lock(E1@p,...);

@r exists@
expression x <= locked.E1;
expression locked.E1;
expression E2;
identifier lock;
position locked.p,p1,p2;
@@

*lock@p1 (E1@p,...);
... when != E1
    when != \(x = E2\|&x\)
*lock@p2 (E1,...);
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
Compile tested only.

 drivers/hid/hid-debug.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hid/hid-debug.c b/drivers/hid/hid-debug.c
index c940267..850d02a 100644
--- a/drivers/hid/hid-debug.c
+++ b/drivers/hid/hid-debug.c
@@ -949,8 +949,8 @@ static ssize_t hid_debug_events_read(struct file *file, char __user *buffer,
 	int ret = 0, len;
 	DECLARE_WAITQUEUE(wait, current);
 
+	mutex_lock(&list->read_mutex);
 	while (ret == 0) {
-		mutex_lock(&list->read_mutex);
 		if (list->head == list->tail) {
 			add_wait_queue(&list->hdev->debug_wait, &wait);
 			set_current_state(TASK_INTERRUPTIBLE);
