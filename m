Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757031Ab2BQBAb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 20:00:31 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:48016 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756964Ab2BQBAY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 20:00:24 -0500
X-Sasl-enc: ICcy07W4F4L0OtFKu5WK/tQg2zJq8zV9o7TQA00OfGzQ 1329440423
X-Mailbox-Line: From gregkh@linuxfoundation.org Thu Feb 16 16:55:35 2012
Message-Id: <20120217005535.257381512@linuxfoundation.org>
User-Agent: quilt/0.51-15.1
Date: Thu, 16 Feb 2012 16:55:43 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Felix Fietkau <nbd@openwrt.org>,
        Seth Forshee <seth.forshee@canonical.com>,
        Marek Lindner <lindner_marek@yahoo.de>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [09/28] ath9k_hw: fix a RTS/CTS timeout regression
In-Reply-To: <20120217005609.GA17081@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Fietkau <nbd@openwrt.org>

commit 55a2bb4a6d5e8c7b324d003e130fd9aaf33be4e6 upstream.

commit adb5066 "ath9k_hw: do not apply the 2.4 ghz ack timeout
workaround to cts" reduced the hardware CTS timeout to the normal
values specified by the standard, but it turns out while it doesn't
need the same extra time that it needs for the ACK timeout, it
does need more than the value specified in the standard, but only
for 2.4 GHz.

This patch brings the CTS timeout value in sync with the initialization
values, while still allowing adjustment for bigger distances.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Reported-by: Seth Forshee <seth.forshee@canonical.com>
Reported-by: Marek Lindner <lindner_marek@yahoo.de>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/ath/ath9k/hw.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -1034,13 +1034,16 @@ void ath9k_hw_init_global_settings(struc
 
 	/*
 	 * Workaround for early ACK timeouts, add an offset to match the
-	 * initval's 64us ack timeout value.
+	 * initval's 64us ack timeout value. Use 48us for the CTS timeout.
 	 * This was initially only meant to work around an issue with delayed
 	 * BA frames in some implementations, but it has been found to fix ACK
 	 * timeout issues in other cases as well.
 	 */
-	if (conf->channel && conf->channel->band == IEEE80211_BAND_2GHZ)
+	if (conf->channel && conf->channel->band == IEEE80211_BAND_2GHZ) {
 		acktimeout += 64 - sifstime - ah->slottime;
+		ctstimeout += 48 - sifstime - ah->slottime;
+	}
+
 
 	ath9k_hw_set_sifs_time(ah, sifstime);
 	ath9k_hw_setslottime(ah, slottime);


