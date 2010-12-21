Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933476Ab0LUBl7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 20:41:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:38262 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933464Ab0LUBl6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 20:41:58 -0500
From: Dave Airlie <airlied@gmail.com>
To: linux-fbdev@vger.kernel.org
Cc: dri-devel@lists.sf.net, linux-kernel@vger.kernel.org,
        Dave Airlie <airlied@redhat.com>
Subject: [PATCH 3/3] fbcon: fix situation where fbcon gets deinitialised and can't reinit.
Date: Tue, 21 Dec 2010 11:41:17 +1000
Message-Id: <1292895677-4242-4-git-send-email-airlied@gmail.com>
In-Reply-To: <1292895677-4242-1-git-send-email-airlied@gmail.com>
References: <1292895677-4242-1-git-send-email-airlied@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dave Airlie <airlied@redhat.com>

Situation as follow:
2 GPUs + vesafb + kms.

GPU 1 is primary, vesafb binds to it as fb0
radeon loads
GPU 0 loads as fb1
GPU 1 loads, vesafb gets kicked off which causes fb0 to unbind
console, which causes the dummy console to rebind.

this means fbcon_deinit gets called, which calls fbcon_exit
since the console isn't bound anymore and we set fbcon_has_exited.

GPU 1 creates a new fb0 which is primary and we want to be console.
fbcon_fb_registered gets called sets the primary up and calls set_con2fb_map,
however as fbcon_has_exited is set nothing further ever happens.

This patch bypasses the fbcon_has_exited and checks if the console is unbound,
if its unbound it calls the fbcon_takeover which calls the vt layer to
call the fbcon_startup method and everthing works.

Signed-off-by: Dave Airlie <airlied@redhat.com>
---
 drivers/video/console/fbcon.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/video/console/fbcon.c b/drivers/video/console/fbcon.c
index 7ccc967..6662687 100644
--- a/drivers/video/console/fbcon.c
+++ b/drivers/video/console/fbcon.c
@@ -823,10 +823,10 @@ static int set_con2fb_map(int unit, int newidx, int user)
 	if (oldidx == newidx)
 		return 0;
 
-	if (!info || fbcon_has_exited)
+	if (!info)
 		return -EINVAL;
 
- 	if (!err && !search_for_mapped_con()) {
+	if (!search_for_mapped_con() || !con_is_bound(&fb_con)) {
 		info_idx = newidx;
 		return fbcon_takeover(0);
 	}
-- 
1.7.1

