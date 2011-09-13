Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751450Ab1IMJ32 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 05:29:28 -0400
Received: from darkcity.gna.ch ([195.226.6.51]:33058 "EHLO mail.gna.ch"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751231Ab1IMJ31 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Sep 2011 05:29:27 -0400
Subject: Re: [BUG] drm/radeon: locking problems with page_flip
From: Michel =?ISO-8859-1?Q?D=E4nzer?= <michel@daenzer.net>
To: Witold Baryluk <baryluk@smp.if.uj.edu.pl>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
Date: Tue, 13 Sep 2011 11:29:12 +0200
In-Reply-To: <20110913034955.GJ23706@smp.if.uj.edu.pl>
References: <20110913034955.GJ23706@smp.if.uj.edu.pl>
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAAXNSR0IArs4c6QAAADBQTFRFDg4OHh4eLCwsOzs7S0tLWlpaa2treXl5hISEjY2NmJiYqKiotLS0xsbG1dXV/Pz81CO0SQAAArtJREFUOMtd1M9P01AcAHCI/4AtGq/QDfDHRfraEX8eaNeJFw1rO/DCYet7mxc1ZG0x3sStHQkmZpqtHDwAi+tMiFEzbZdwNWEJR48cjPG4g5HhELUbrHvjpYe2n7zvt++977cD/7rjsCry8uNG93Gge9OKUyAAgLB1AlpTZICmAzR15QTEiQAPAKADYLMPfhNnEJR4HvD0tT5YI2KGUcyqihQN7mDwZ3hMN4q2N4ol+gEGTSLWhorrjYXrGPwc0jTDOoKP4xi8G0W6adl2Gz6zGDwag5p5PMON7vZgJuSB976+3U6y2QdeKNet1+uum9/qwVQHvEjtKesY0EIb7CNYe+7DIRXCID/vQ4tksVAY7JFBD7yvqrWTL93xoUmOQsPIddbnuk8v+bBPsigB2KRlFxS4nL/owwEpKBSg2MU3UcDf+nATyyHEQwrHzJZFNpXeuOHDC0qW4sMhEHESFGOUrvgQpWUYFVNQdjQxca8abnSB55CmehdcLSxa1ifoQ4JBpmGYWbhsly3X0fxQ7xmkW3Y5CztLcXI+fAu2oWho3nbV6s5rH35xSC/aBR2tOpVa/Utv25tcTDPL6aT21kG17WrvaFtMBJmFhJCsVF4uu9VG76DWBaRnEiNs7pU659pYlfwtQSRy9GCYlwR7C6/dPQgBw3MsTPNWA4d9SeMDDC9JYdnqq/amdF+diGnVhXFztQ/2lJSWjulOxjRX+uC7EkOqhLRk2ejrqHVBEqCqJLO5cmEXgx8TrBiWVQh1u2DhzQlPsyIveU2YLGorGBxODoR5notlpcUieoLB1/NEmGc4AalGJpLe8WF/8txMWASAkVVViQjzP
 jycPrvgA
	R1goSzOnkp14YCYHsp7QJHAS5QcXDqG1jBxdSITVgBNkBTFloj88Q/gMkFcuItYiQPUCBGc2xh5drsD/wGZrgsgDOE4ZAAAAABJRU5ErkJggg==
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1315906152.17617.24.camel@thor.local>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Die, 2011-09-13 at 05:49 +0200, Witold Baryluk wrote: 
> 
> I yeasterday discovered pretty nasty issue in radeon / drm code,
> and page_flip locking code on my ThinkPad T43.

Does the patch below fix the problem?


>From ed7cf809c4fb737fa486b24004ee47056bf0e797 Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Michel=20D=C3=A4nzer?= <michel.daenzer@amd.com>
Date: Thu, 8 Sep 2011 17:36:22 +0200
Subject: [PATCH] drm/radeon: Unreference GEM object outside of spinlock
 in page flip error path.
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Should fix https://bugzilla.redhat.com/show_bug.cgi?id=726277 .

Signed-off-by: Michel Dänzer <michel.daenzer@amd.com>
---
 drivers/gpu/drm/radeon/radeon_display.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/gpu/drm/radeon/radeon_display.c b/drivers/gpu/drm/radeon/radeon_display.c
index 6cc17fb..6adb3e5 100644
--- a/drivers/gpu/drm/radeon/radeon_display.c
+++ b/drivers/gpu/drm/radeon/radeon_display.c
@@ -473,8 +473,8 @@ pflip_cleanup:
 	spin_lock_irqsave(&dev->event_lock, flags);
 	radeon_crtc->unpin_work = NULL;
 unlock_free:
-	drm_gem_object_unreference_unlocked(old_radeon_fb->obj);
 	spin_unlock_irqrestore(&dev->event_lock, flags);
+	drm_gem_object_unreference_unlocked(old_radeon_fb->obj);
 	radeon_fence_unref(&work->fence);
 	kfree(work);
 
-- 
1.7.5.4

-- 
Earthling Michel Dänzer           |                   http://www.amd.com
Libre software enthusiast         |          Debian, X and DRI developer
