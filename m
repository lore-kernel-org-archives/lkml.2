Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753383Ab0GAVdj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 17:33:39 -0400
Received: from kroah.org ([198.145.64.141]:33131 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758931Ab0GAVPC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 17:15:02 -0400
X-Mailbox-Line: From gregkh@clark.site Thu Jul  1 10:43:00 2010
Message-Id: <20100701174300.245049802@clark.site>
User-Agent: quilt/0.48-10.1
Date: Thu, 01 Jul 2010 10:44:12 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Reinette Chatre <reinette.chatre@intel.com>,
       "John W. Linville" <linville@tuxdriver.com>
Subject: [162/200] iwlwifi: fix internal scan race
In-Reply-To: <20100701175201.GA2149@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Reinette Chatre <reinette.chatre@intel.com>

commit 073d5eab6fc85b6c278d507a5633b759a85dc878 upstream.

It is possible for internal scan to race against itself if the device is
not returning the scan results from first requests. What happens in this
case is the cleanup done during the abort of the first internal scan also
cleans up part of the new scan, causing it to access memory it shouldn't.

Here are details:
* First internal scan is triggered and scan command sent to device.
* After seven seconds there is no scan results so the watchdog timer
  triggers a scan abort.
* The scan abort succeeds and a SCAN_COMPLETE_NOTIFICATION is received for
 failed scan.
* During processing of SCAN_COMPLETE_NOTIFICATION we clear STATUS_SCANNING
  and queue the "scan_completed" work.
** At this time, since the problem that caused the internal scan in first
   place is still present, a new internal scan is triggered.
The behavior at this point is a bit different between 2.6.34 and 2.6.35
since 2.6.35 has a lot of this synchronized. The rest of the race
description will thus be generalized.
** As part of preparing for the scan "is_internal_short_scan" is set to
true.
* At this point the completion work for fist scan is run. As part of this
  there is some locking missing around the "is_internal_short_scan"
  variable and it is set to "false".
** Now the second scan runs and it considers itself a real (not internal0
   scan and thus causes problems with wrong memory being accessed.

The fix is twofold.
* Since "is_internal_short_scan" should be protected by mutex, fix this in
  scan completion work so that changes to it can be serialized.
* Do not queue a new internal scan if one is in progress.

This fixes https://bugzilla.kernel.org/show_bug.cgi?id=15824

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/iwlwifi/iwl-scan.c |   21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

--- a/drivers/net/wireless/iwlwifi/iwl-scan.c
+++ b/drivers/net/wireless/iwlwifi/iwl-scan.c
@@ -561,6 +561,11 @@ static void iwl_bg_start_internal_scan(s
 
 	mutex_lock(&priv->mutex);
 
+	if (priv->is_internal_short_scan == true) {
+		IWL_DEBUG_SCAN(priv, "Internal scan already in progress\n");
+		goto unlock;
+	}
+
 	if (!iwl_is_ready_rf(priv)) {
 		IWL_DEBUG_SCAN(priv, "not ready or exit pending\n");
 		goto unlock;
@@ -958,17 +963,27 @@ void iwl_bg_scan_completed(struct work_s
 {
 	struct iwl_priv *priv =
 	    container_of(work, struct iwl_priv, scan_completed);
+	bool internal = false;
 
 	IWL_DEBUG_SCAN(priv, "SCAN complete scan\n");
 
 	cancel_delayed_work(&priv->scan_check);
 
-	if (!priv->is_internal_short_scan)
-		ieee80211_scan_completed(priv->hw, false);
-	else {
+	mutex_lock(&priv->mutex);
+	if (priv->is_internal_short_scan) {
 		priv->is_internal_short_scan = false;
 		IWL_DEBUG_SCAN(priv, "internal short scan completed\n");
+		internal = true;
 	}
+	mutex_unlock(&priv->mutex);
+
+	/*
+	 * Do not hold mutex here since this will cause mac80211 to call
+	 * into driver again into functions that will attempt to take
+	 * mutex.
+	 */
+	if (!internal)
+		ieee80211_scan_completed(priv->hw, false);
 
 	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
 		return;


