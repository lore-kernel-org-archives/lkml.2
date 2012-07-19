Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755561Ab2GSCIV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 22:08:21 -0400
Received: from mail-wi0-f202.google.com ([209.85.212.202]:37389 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751776Ab2GSCIT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 22:08:19 -0400
From: Colin Cross <ccross@android.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Colin Cross <ccross@android.com>, Pavel Machek <pavel@ucw.cz>,
        Len Brown <len.brown@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] PM / Sleep: call early resume handlers when suspend_noirq fails
Date: Wed, 18 Jul 2012 19:08:14 -0700
Message-Id: <1342663694-3645-1-git-send-email-ccross@android.com>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit cf579dfb82550e34de7ccf3ef090d8b834ccd3a9 (PM / Sleep: Introduce
"late suspend" and "early resume" of devices) introduced a bug where
suspend_late handlers would be called, but if dpm_suspend_noirq returned
an error the early_resume handlers would never be called.  All devices
would end up on the dpm_late_early_list, and would never be resumed
again.

Fix it by calling dpm_resume_early when dpm_suspend_noirq returns
an error.

Signed-off-by: Colin Cross <ccross@android.com>
---
 drivers/base/power/main.c |   10 +++++++++-
 1 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/drivers/base/power/main.c b/drivers/base/power/main.c
index 9cb845e..742fcbe 100644
--- a/drivers/base/power/main.c
+++ b/drivers/base/power/main.c
@@ -989,8 +989,16 @@ static int dpm_suspend_late(pm_message_t state)
 int dpm_suspend_end(pm_message_t state)
 {
 	int error = dpm_suspend_late(state);
+	if (error)
+		return error;
 
-	return error ? : dpm_suspend_noirq(state);
+	error = dpm_suspend_noirq(state);
+	if (error) {
+		dpm_resume_early(state);
+		return error;
+	}
+
+	return 0;
 }
 EXPORT_SYMBOL_GPL(dpm_suspend_end);
 
-- 
1.7.7.3

