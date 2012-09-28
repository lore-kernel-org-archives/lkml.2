Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422746Ab2I1U3c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 16:29:32 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:55300 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1032757Ab2I1U3X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 16:29:23 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Dave Airlie <airlied@redhat.com>, Josh Boyer <jwboyer@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 145/218] fbcon: fix race condition between console lock and cursor timer (v1.1)
Date: Fri, 28 Sep 2012 13:16:02 -0700
Message-Id: <20120928201518.139294738@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.1.428.g652398a
In-Reply-To: <20120928201501.208384923@linuxfoundation.org>
References: <20120928201501.208384923@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Acked-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
Tested-by: Josh Boyer <jwboyer@gmail.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/video/console/fbcon.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/drivers/video/console/fbcon.c
+++ b/drivers/video/console/fbcon.c
@@ -372,8 +372,15 @@ static void fb_flashcursor(struct work_s
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
 


