Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932114Ab0LHA7z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 19:59:55 -0500
Received: from kroah.org ([198.145.64.141]:48632 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932096Ab0LHA7w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 19:59:52 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:57:27 2010
Message-Id: <20101208005727.226790459@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 16:57:16 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Christian Lamparter <chunkeey@googlemail.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [059/289] mac80211: dont sanitize invalid rates
In-Reply-To: <20101208005821.GA2922@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

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

---
 net/mac80211/rate.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/net/mac80211/rate.c
+++ b/net/mac80211/rate.c
@@ -328,6 +328,9 @@ void rate_control_get_rate(struct ieee80
 		 * if needed.
 		 */
 		for (i = 0; i < IEEE80211_TX_MAX_RATES; i++) {
+			/* Skip invalid rates */
+			if (info->control.rates[i].idx < 0)
+				break;
 			/* Rate masking supports only legacy rates for now */
 			if (info->control.rates[i].flags & IEEE80211_TX_RC_MCS)
 				continue;


