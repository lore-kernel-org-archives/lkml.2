Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752765Ab2HUGkn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 02:40:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18278 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751036Ab2HUGkl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 02:40:41 -0400
From: Dave Airlie <airlied@redhat.com>
To: linux-fbdev@vger.kernel.org
Cc: dri-devel@lists.sf.net, linux-kernel@vger.kernel.org,
        Linus <torvalds@linux-foundation.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Randy Dunlap <rdunlap@xenotime.net>, Josh Boyer <jwboyer@gmail.com>,
        Dave Airlie <airlied@redhat.com>
Subject: [PATCH] fbcon: fix race condition between console lock and cursor timer
Date: Tue, 21 Aug 2012 16:40:07 +1000
Message-Id: <1345531207-24926-1-git-send-email-airlied@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

Signed-off-by: David Airlie <airlied@redhat.com>
---
 drivers/video/console/fbcon.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/video/console/fbcon.c b/drivers/video/console/fbcon.c
index 2e471c2..f8a79fc 100644
--- a/drivers/video/console/fbcon.c
+++ b/drivers/video/console/fbcon.c
@@ -372,8 +372,12 @@ static void fb_flashcursor(struct work_struct *work)
 	struct vc_data *vc = NULL;
 	int c;
 	int mode;
+	int ret;
+
+	ret = console_trylock();
+	if (ret == 0)
+		return;
 
-	console_lock();
 	if (ops && ops->currcon != -1)
 		vc = vc_cons[ops->currcon].d;
 
-- 
1.7.10.2

