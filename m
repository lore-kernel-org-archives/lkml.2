Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932558Ab2HGW3R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 18:29:17 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:47022 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932538Ab2HGW3N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 18:29:13 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Colin Cross <ccross@android.com>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: [ 043/122] PM / Sleep: call early resume handlers when suspend_noirq fails
Date: Tue,  7 Aug 2012 15:25:31 -0700
Message-Id: <20120807221952.080156413@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120807221948.220495155@linuxfoundation.org>
References: <20120807221948.220495155@linuxfoundation.org>
User-Agent: quilt/0.60-20.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Colin Cross <ccross@android.com>

commit 064b021fbe470ecc9ca10f9f87af48c0fc0865fb upstream.

Commit cf579dfb82550e34de7ccf3ef090d8b834ccd3a9 (PM / Sleep: Introduce
"late suspend" and "early resume" of devices) introduced a bug where
suspend_late handlers would be called, but if dpm_suspend_noirq returned
an error the early_resume handlers would never be called.  All devices
would end up on the dpm_late_early_list, and would never be resumed
again.

Fix it by calling dpm_resume_early when dpm_suspend_noirq returns
an error.

Signed-off-by: Colin Cross <ccross@android.com>
Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/base/power/main.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/drivers/base/power/main.c
+++ b/drivers/base/power/main.c
@@ -989,8 +989,16 @@ static int dpm_suspend_late(pm_message_t
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
 


