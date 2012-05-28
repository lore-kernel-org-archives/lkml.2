Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754864Ab2E1DjT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2012 23:39:19 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52069 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754037Ab2E1D3m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2012 23:29:42 -0400
Message-Id: <20120528031210.621282534@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 28 May 2012 04:12:58 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
        Oliver Neukum <oneukum@suse.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [ 056/117] USB: cdc-wdm: add debug messages on cleanup
In-Reply-To: <20120528031202.829379252@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bjørn Mork <bjorn@mork.no>

commit 880bca3a2a6f159d7453e0cbcbfe2f1d8204d907 upstream.

Device state cleanup is done in either wdm_disconnect or
wdm_release depending on the order they are called. Adding
a couple of debug messages to document the program flow.

Signed-off-by: Bjørn Mork <bjorn@mork.no>
Acked-by: Oliver Neukum <oneukum@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/class/cdc-wdm.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/usb/class/cdc-wdm.c
+++ b/drivers/usb/class/cdc-wdm.c
@@ -588,10 +588,12 @@
 	if (!desc->count) {
 		dev_dbg(&desc->intf->dev, "wdm_release: cleanup");
 		kill_urbs(desc);
-		if (!test_bit(WDM_DISCONNECTING, &desc->flags))
+		if (!test_bit(WDM_DISCONNECTING, &desc->flags)) {
 			desc->intf->needs_remote_wakeup = 0;
-		else
+		} else {
+			dev_dbg(&desc->intf->dev, "%s: device gone - cleaning up\n", __func__);
 			cleanup(desc);
+		}
 	}
 	mutex_unlock(&wdm_mutex);
 	return 0;
@@ -807,6 +809,8 @@
 	mutex_unlock(&desc->rlock);
 	if (!desc->count)
 		cleanup(desc);
+	else
+		dev_dbg(&intf->dev, "%s: %d open files - postponing cleanup\n", __func__, desc->count);
 	mutex_unlock(&wdm_mutex);
 }
 


