Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753733Ab0LMAaT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 19:30:19 -0500
Received: from one.firstfloor.org ([213.235.205.2]:44687 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753683Ab0LLXpW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 18:45:22 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <201012131244.547034648@firstfloor.org>
In-Reply-To: <201012131244.547034648@firstfloor.org>
To: chunkeey@googlemail.com, linville@tuxdriver.com, gregkh@suse.de,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [25/223] mac80211: don't sanitize invalid rates
Message-Id: <20101212234521.2CCBBB27C0@basil.firstfloor.org>
Date: Mon, 13 Dec 2010 00:45:21 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Christian Lamparter <chunkeey@googlemail.com>

commit 5f4e6b2d3c74c1adda1cbfd9d9d30da22c7484fc upstream.

I found this bug while poking around with a pure-gn AP.

Commit:
cfg80211/mac80211: Use more generic bitrate mask for rate control

Added some sanity checks to ensure that each tx rate index
is included in the configured mask and it would change any
rate indexes if it wasn't.

But, the current implementation doesn't take into account
that the invalid rate index "-1" has a special meaning
(= no further attempts) and it should not be "changed".

Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 net/mac80211/rate.c |    3 +++
 1 file changed, 3 insertions(+)

Index: linux/net/mac80211/rate.c
===================================================================
--- linux.orig/net/mac80211/rate.c
+++ linux/net/mac80211/rate.c
@@ -326,6 +326,9 @@ void rate_control_get_rate(struct ieee80
 		 * if needed.
 		 */
 		for (i = 0; i < IEEE80211_TX_MAX_RATES; i++) {
+			/* Skip invalid rates */
+			if (info->control.rates[i].idx < 0)
+				break;
 			/* Rate masking supports only legacy rates for now */
 			if (info->control.rates[i].flags & IEEE80211_TX_RC_MCS)
 				continue;
