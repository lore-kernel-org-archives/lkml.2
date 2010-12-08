Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756318Ab0LHArv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 19:47:51 -0500
Received: from kroah.org ([198.145.64.141]:58516 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756286Ab0LHArr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 19:47:47 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:44:32 2010
Message-Id: <20101208004432.817309284@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 16:44:31 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        =?ISO-8859-15?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Richard Purdie <rpurdie@linux.intel.com>
Subject: [085/127] backlight: grab ops_lock before testing bd->ops
In-Reply-To: <20101208004456.GA23578@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

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

---
 drivers/video/backlight/backlight.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/drivers/video/backlight/backlight.c
+++ b/drivers/video/backlight/backlight.c
@@ -196,12 +196,12 @@ static int backlight_suspend(struct devi
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
@@ -210,12 +210,12 @@ static int backlight_resume(struct devic
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


