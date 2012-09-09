Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755979Ab2IIXQU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2012 19:16:20 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51196 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755860Ab2IIXQN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2012 19:16:13 -0400
Message-Id: <20120909224201.448022288@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 09 Sep 2012 23:43:09 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Szymon Janc <szymon.janc@tieto.com>,
        Gustavo Padovan <gustavo.padovan@collabora.co.uk>
Subject: [ 79/95] Bluetooth: Fix using uninitialized option in RFCMode
In-Reply-To: <20120909224150.641491654@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Szymon Janc <szymon.janc@tieto.com>

commit 8f321f853ea33330c7141977cd34804476e2e07e upstream.

If remote device sends bogus RFC option with invalid length,
undefined options values are used. Fix this by using defaults when
remote misbehaves.

This also fixes the following warning reported by gcc 4.7.0:

net/bluetooth/l2cap_core.c: In function 'l2cap_config_rsp':
net/bluetooth/l2cap_core.c:3302:13: warning: 'rfc.max_pdu_size' may be used uninitialized in this function [-Wmaybe-uninitialized]
net/bluetooth/l2cap_core.c:3266:24: note: 'rfc.max_pdu_size' was declared here
net/bluetooth/l2cap_core.c:3298:25: warning: 'rfc.monitor_timeout' may be used uninitialized in this function [-Wmaybe-uninitialized]
net/bluetooth/l2cap_core.c:3266:24: note: 'rfc.monitor_timeout' was declared here
net/bluetooth/l2cap_core.c:3297:25: warning: 'rfc.retrans_timeout' may be used uninitialized in this function [-Wmaybe-uninitialized]
net/bluetooth/l2cap_core.c:3266:24: note: 'rfc.retrans_timeout' was declared here
net/bluetooth/l2cap_core.c:3295:2: warning: 'rfc.mode' may be used uninitialized in this function [-Wmaybe-uninitialized]
net/bluetooth/l2cap_core.c:3266:24: note: 'rfc.mode' was declared here

Signed-off-by: Szymon Janc <szymon.janc@tieto.com>
Signed-off-by: Gustavo Padovan <gustavo.padovan@collabora.co.uk>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/bluetooth/l2cap_core.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
index 8394e36..4554e80 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -2915,12 +2915,14 @@ static void l2cap_conf_rfc_get(struct l2cap_chan *chan, void *rsp, int len)
 	while (len >= L2CAP_CONF_OPT_SIZE) {
 		len -= l2cap_get_conf_opt(&rsp, &type, &olen, &val);
 
-		switch (type) {
-		case L2CAP_CONF_RFC:
-			if (olen == sizeof(rfc))
-				memcpy(&rfc, (void *)val, olen);
-			goto done;
-		}
+		if (type != L2CAP_CONF_RFC)
+			continue;
+
+		if (olen != sizeof(rfc))
+			break;
+
+		memcpy(&rfc, (void *)val, olen);
+		goto done;
 	}
 
 	/* Use sane default values in case a misbehaving remote device


