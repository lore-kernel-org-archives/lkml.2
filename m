Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1769316Ab2K3T36 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 14:29:58 -0500
Received: from mail.kernel.org ([198.145.19.201]:58164 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031460Ab2K3S4I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 13:56:08 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Szymon Janc <szymon.janc@tieto.com>,
        Gustavo Padovan <gustavo.padovan@collabora.co.uk>
Subject: [ 03/56] Bluetooth: Fix using uninitialized option in RFCMode
Date: Fri, 30 Nov 2012 10:54:55 -0800
Message-Id: <20121130185118.673014753@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.197.g5a90748
In-Reply-To: <20121130185118.302752929@linuxfoundation.org>
References: <20121130185118.302752929@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/bluetooth/l2cap_core.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -2585,12 +2585,14 @@ static void l2cap_conf_rfc_get(struct l2
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


