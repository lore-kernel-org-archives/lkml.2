Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756963Ab0DVTaA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 15:30:00 -0400
Received: from kroah.org ([198.145.64.141]:41537 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756895Ab0DVT3w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 15:29:52 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Thu Apr 22 12:09:23 2010
Message-Id: <20100422190923.333971365@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Thu, 22 Apr 2010 12:10:29 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Johannes Berg <johannes@sipsolutions.net>,
       "John W. Linville" <linville@tuxdriver.com>,
       Chase Douglas <chase.douglas@canonical.com>
Subject: [178/197] mac80211: fix deferred hardware scan requests
In-Reply-To: <20100422191857.GA13268@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Johannes Berg <johannes@sipsolutions.net>

commit c0ce77b8323c1a0d4eeef97caf16c0ea971222a9 upstream.

Reinette found the reason for the warnings that
happened occasionally when a hw-offloaded scan
finished; her description of the problem:

  mac80211 will defer the handling of scan requests if it is
  busy with management work at the time. The scan requests
  are deferred and run after the work has completed. When
  this occurs there are currently two problems.

  * The scan request for hardware scan is not fully populated
    with the band and channels to scan not initialized.

  * When the scan is queued the state is not correctly updated
    to reflect that a scan is in progress. The problem here is
    that when the driver completes the scan and calls
    ieee80211_scan_completed() a warning will be triggered
    since mac80211 was not aware that a scan was in progress.

The reason is that the queued scan work will start
the hw scan right away when the hw_scan_req struct
has already been allocated. However, in the first
pass it will not have been filled, which happens
at the same time as setting the bits. To fix this,
simply move the allocation after the pending work
test as well, so that the first iteration of the
scan work will call __ieee80211_start_scan() even
in the hardware scan case.

Bug-identified-by: Reinette Chatre <reinette.chatre@intel.com>
Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Cc: Chase Douglas <chase.douglas@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/mac80211/scan.c |   18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -408,6 +408,16 @@ static int __ieee80211_start_scan(struct
 	if (local->scan_req)
 		return -EBUSY;
 
+	if (req != local->int_scan_req &&
+	    sdata->vif.type == NL80211_IFTYPE_STATION &&
+	    !list_empty(&ifmgd->work_list)) {
+		/* actually wait for the work it's doing to finish/time out */
+		set_bit(IEEE80211_STA_REQ_SCAN, &ifmgd->request);
+		local->scan_req = req;
+		local->scan_sdata = sdata;
+		return 0;
+	}
+
 	if (local->ops->hw_scan) {
 		u8 *ies;
 		int ielen;
@@ -428,14 +438,6 @@ static int __ieee80211_start_scan(struct
 	local->scan_req = req;
 	local->scan_sdata = sdata;
 
-	if (req != local->int_scan_req &&
-	    sdata->vif.type == NL80211_IFTYPE_STATION &&
-	    !list_empty(&ifmgd->work_list)) {
-		/* actually wait for the work it's doing to finish/time out */
-		set_bit(IEEE80211_STA_REQ_SCAN, &ifmgd->request);
-		return 0;
-	}
-
 	if (local->ops->hw_scan)
 		__set_bit(SCAN_HW_SCANNING, &local->scanning);
 	else


