Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755838Ab0LLX5q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 18:57:46 -0500
Received: from one.firstfloor.org ([213.235.205.2]:36610 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755822Ab0LLXsB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 18:48:01 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <201012131244.547034648@firstfloor.org>
In-Reply-To: <201012131244.547034648@firstfloor.org>
To: u.kleine-koenig@pengutronix.de, u.kleine-koenig@pengutronix.de,
        u.kleine-koenig@pengutronix.de, rpurdie@linux.intel.com,
        akpm@linux-foundation.org, torvalds@linux-foundation.org,
        gregkh@suse.de, ak@linux.intel.com, linux-kernel@vger.kernel.org,
        stable@kernel.org
Subject: [PATCH] [175/223] backlight: grab ops_lock before testing bd->ops
Message-Id: <20101212234800.114FAB27BF@basil.firstfloor.org>
Date: Mon, 13 Dec 2010 00:48:00 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>

commit d1d73578e053b981c3611e5a211534290d24a5eb upstream.

According to the comment describing ops_lock in the definition of struct
backlight_device and when comparing with other functions in backlight.c
the mutex must be hold when checking ops to be non-NULL.

Fixes a problem added by c835ee7f4154992e6 ("backlight: Add suspend/resume
support to the backlight core") in Jan 2009.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Acked-by: Richard Purdie <rpurdie@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/video/backlight/backlight.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

Index: linux/drivers/video/backlight/backlight.c
===================================================================
--- linux.orig/drivers/video/backlight/backlight.c
+++ linux/drivers/video/backlight/backlight.c
@@ -197,12 +197,12 @@ static int backlight_suspend(struct devi
 {
 	struct backlight_device *bd = to_backlight_device(dev);
 
-	if (bd->ops->options & BL_CORE_SUSPENDRESUME) {
-		mutex_lock(&bd->ops_lock);
+	mutex_lock(&bd->ops_lock);
+	if (bd->ops && bd->ops->options & BL_CORE_SUSPENDRESUME) {
 		bd->props.state |= BL_CORE_SUSPENDED;
 		backlight_update_status(bd);
-		mutex_unlock(&bd->ops_lock);
 	}
+	mutex_unlock(&bd->ops_lock);
 
 	return 0;
 }
@@ -211,12 +211,12 @@ static int backlight_resume(struct devic
 {
 	struct backlight_device *bd = to_backlight_device(dev);
 
-	if (bd->ops->options & BL_CORE_SUSPENDRESUME) {
-		mutex_lock(&bd->ops_lock);
+	mutex_lock(&bd->ops_lock);
+	if (bd->ops && bd->ops->options & BL_CORE_SUSPENDRESUME) {
 		bd->props.state &= ~BL_CORE_SUSPENDED;
 		backlight_update_status(bd);
-		mutex_unlock(&bd->ops_lock);
 	}
+	mutex_unlock(&bd->ops_lock);
 
 	return 0;
 }
