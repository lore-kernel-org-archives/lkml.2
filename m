Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965345Ab2B1BPm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 20:15:42 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:33164 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965323Ab2B1BMc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 20:12:32 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of gregkh@linuxfoundation.org designates 10.68.129.73 as permitted sender) smtp.mail=gregkh@linuxfoundation.org
MIME-Version: 1.0
Message-Id: <20120228010434.307758543@linuxfoundation.org>
User-Agent: quilt/0.51-17.1
Date: Mon, 27 Feb 2012 17:05:25 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Pavel Roskin <proski@gnu.org>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 56/72] ath9k: stop on rates with idx -1 in ath9k rate controls .tx_status
In-Reply-To: <20120228010511.GA8453@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pavel Roskin <proski@gnu.org>

commit 2504a6423b9ab4c36df78227055995644de19edb upstream.

Rate control algorithms are supposed to stop processing when they
encounter a rate with the index -1.  Checking for rate->count not being
zero is not enough.

Allowing a rate with negative index leads to memory corruption in
ath_debug_stat_rc().

One consequence of the bug is discussed at
https://bugzilla.redhat.com/show_bug.cgi?id=768639

Signed-off-by: Pavel Roskin <proski@gnu.org>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/ath/ath9k/rc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/wireless/ath/ath9k/rc.c
+++ b/drivers/net/wireless/ath/ath9k/rc.c
@@ -1347,7 +1347,7 @@ static void ath_tx_status(void *priv, st
 	fc = hdr->frame_control;
 	for (i = 0; i < sc->hw->max_rates; i++) {
 		struct ieee80211_tx_rate *rate = &tx_info->status.rates[i];
-		if (!rate->count)
+		if (rate->idx < 0 || !rate->count)
 			break;
 
 		final_ts_idx = i;


