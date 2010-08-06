Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965040Ab0HFSjf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 14:39:35 -0400
Received: from kroah.org ([198.145.64.141]:48690 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964936Ab0HFSgA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 14:36:00 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Aug  6 11:32:02 2010
Message-Id: <20100806183202.256024022@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 06 Aug 2010 11:30:46 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [25/38] iwlwifi: fix scan abort
In-Reply-To: <20100806183250.GA23019@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Stanislaw Gruszka <sgruszka@redhat.com>

commit d28232b461b8d54b09e59325dbac8b0913ce2049 upstream.

Fix possible double priv->mutex lock introduced by commit
a69b03e941abae00380fc6bc1877fb797a1b31e6
"iwlwifi: cancel scan watchdog in iwl_bg_abort_scan" .
We can not call cancel_delayed_work_sync(&priv->scan_check) with
priv->mutex locked because workqueue function iwl_bg_scan_check()
take that lock internally.

We do not need to synchronize when canceling priv->scan_check work.
We can avoid races (sending double abort command or send no
command at all) using STATUS_SCAN_ABORT bit. Moreover
current iwl_bg_scan_check() code seems to be broken, as
we should not send abort commands when currently aborting.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/iwlwifi/iwl-scan.c |   18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

--- a/drivers/net/wireless/iwlwifi/iwl-scan.c
+++ b/drivers/net/wireless/iwlwifi/iwl-scan.c
@@ -420,11 +420,10 @@ void iwl_bg_scan_check(struct work_struc
 		return;
 
 	mutex_lock(&priv->mutex);
-	if (test_bit(STATUS_SCANNING, &priv->status) ||
-	    test_bit(STATUS_SCAN_ABORTING, &priv->status)) {
-		IWL_DEBUG_SCAN(priv, "Scan completion watchdog resetting "
-			"adapter (%dms)\n",
-			jiffies_to_msecs(IWL_SCAN_CHECK_WATCHDOG));
+	if (test_bit(STATUS_SCANNING, &priv->status) &&
+	    !test_bit(STATUS_SCAN_ABORTING, &priv->status)) {
+		IWL_DEBUG_SCAN(priv, "Scan completion watchdog (%dms)\n",
+			       jiffies_to_msecs(IWL_SCAN_CHECK_WATCHDOG));
 
 		if (!test_bit(STATUS_EXIT_PENDING, &priv->status))
 			iwl_send_scan_abort(priv);
@@ -489,12 +488,11 @@ void iwl_bg_abort_scan(struct work_struc
 	    !test_bit(STATUS_GEO_CONFIGURED, &priv->status))
 		return;
 
-	mutex_lock(&priv->mutex);
-
-	cancel_delayed_work_sync(&priv->scan_check);
-	set_bit(STATUS_SCAN_ABORTING, &priv->status);
-	iwl_send_scan_abort(priv);
+	cancel_delayed_work(&priv->scan_check);
 
+	mutex_lock(&priv->mutex);
+	if (test_bit(STATUS_SCAN_ABORTING, &priv->status))
+		iwl_send_scan_abort(priv);
 	mutex_unlock(&priv->mutex);
 }
 EXPORT_SYMBOL(iwl_bg_abort_scan);


