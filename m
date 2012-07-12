Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161847Ab2GLWkx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 18:40:53 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:60450 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161803Ab2GLWkj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 18:40:39 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Mandeep Singh Baines <msb@chromium.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: [ 089/187] PM / Sleep: Prevent waiting forever on asynchronous suspend after abort
Date: Thu, 12 Jul 2012 15:34:05 -0700
Message-Id: <20120712191530.650387086@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120712191522.742634173@linuxfoundation.org>
References: <20120712192421.GA28926@kroah.com>
 <20120712191522.742634173@linuxfoundation.org>
User-Agent: quilt/0.60-20.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mandeep Singh Baines <msb@chromium.org>

commit 1f758b23177d588a71b96ad02990e715949bb82f upstream.

__device_suspend() must always send a completion. Otherwise, parent
devices will wait forever.

Commit 1e2ef05b, "PM: Limit race conditions between runtime PM and
system sleep (v2)", introduced a regression by short-circuiting the
complete_all() for certain error cases.

This patch fixes the bug by always signalling a completion.

Addresses http://crosbug.com/31972

Tested by injecting an abort.

Signed-off-by: Mandeep Singh Baines <msb@chromium.org>
Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/base/power/main.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/base/power/main.c
+++ b/drivers/base/power/main.c
@@ -1021,7 +1021,7 @@ static int __device_suspend(struct devic
 	dpm_wait_for_children(dev, async);
 
 	if (async_error)
-		return 0;
+		goto Complete;
 
 	pm_runtime_get_noresume(dev);
 	if (pm_runtime_barrier(dev) && device_may_wakeup(dev))
@@ -1030,7 +1030,7 @@ static int __device_suspend(struct devic
 	if (pm_wakeup_pending()) {
 		pm_runtime_put_sync(dev);
 		async_error = -EBUSY;
-		return 0;
+		goto Complete;
 	}
 
 	device_lock(dev);
@@ -1087,6 +1087,8 @@ static int __device_suspend(struct devic
 	}
 
 	device_unlock(dev);
+
+ Complete:
 	complete_all(&dev->power.completion);
 
 	if (error) {


