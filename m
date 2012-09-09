Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756071Ab2IIXQd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2012 19:16:33 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51261 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755421Ab2IIXQ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2012 19:16:26 -0400
Message-Id: <20120909224200.264589118@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 09 Sep 2012 23:43:00 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Dave Airlie <airlied@redhat.com>
Subject: [ 70/95] fbcon: fix race condition between console lock and cursor timer
 (v1.1)
In-Reply-To: <20120909224150.641491654@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Airlie <airlied@redhat.com>

commit d8636a2717bb3da2a7ce2154bf08de90bb8c87b0 upstream.

So we've had a fair few reports of fbcon handover breakage between
efi/vesafb and i915 surface recently, so I dedicated a couple of
days to finding the problem.

Essentially the last thing we saw was the conflicting framebuffer
message and that was all.

So after much tracing with direct netconsole writes (printks
under console_lock not so useful), I think I found the race.

Thread A (driver load)    Thread B (timer thread)
  unbind_con_driver ->              |
  bind_con_driver ->                |
  vc->vc_sw->con_deinit ->          |
  fbcon_deinit ->                   |
  console_lock()                    |
      |                             |
      |                       fbcon_flashcursor timer fires
      |                       console_lock() <- blocked for A
      |
      |
fbcon_del_cursor_timer ->
  del_timer_sync
  (BOOM)

Of course because all of this is under the console lock,
we never see anything, also since we also just unbound the active
console guess what we never see anything.

Hopefully this fixes the problem for anyone seeing vesafb->kms
driver handoff.

v1.1: add comment suggestion from Alan.

Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/video/console/fbcon.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/video/console/fbcon.c b/drivers/video/console/fbcon.c
index 2e471c2..88e9204 100644
--- a/drivers/video/console/fbcon.c
+++ b/drivers/video/console/fbcon.c
@@ -372,8 +372,15 @@ static void fb_flashcursor(struct work_struct *work)
 	struct vc_data *vc = NULL;
 	int c;
 	int mode;
+	int ret;
+
+	/* FIXME: we should sort out the unbind locking instead */
+	/* instead we just fail to flash the cursor if we can't get
+	 * the lock instead of blocking fbcon deinit */
+	ret = console_trylock();
+	if (ret == 0)
+		return;
 
-	console_lock();
 	if (ops && ops->currcon != -1)
 		vc = vc_cons[ops->currcon].d;
 


