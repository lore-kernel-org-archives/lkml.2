Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753580Ab1CHKLc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 05:11:32 -0500
Received: from mga09.intel.com ([134.134.136.24]:10405 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751809Ab1CHKLa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 05:11:30 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.62,283,1297065600"; 
   d="scan'208";a="717592377"
From: "Ferraton, Jean RegisX" <jean.regisx.ferraton@intel.com>
To: "marcel@holtmann.org" <marcel@holtmann.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "eric.dumazet@gmail.com" <eric.dumazet@gmail.com>,
        "xiaosuo@gmail.com" <xiaosuo@gmail.com>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Date: Tue, 8 Mar 2011 10:10:10 +0000
Subject: [PATCH] Fix "possible circular locking dependency" in rfcomm
Thread-Topic: [PATCH] Fix "possible circular locking dependency" in rfcomm
Thread-Index: AcvdeQJAdM7f5EpATZi+XtLC5BHGPw==
Message-ID: <6E42A1B4DD2F7B4D80A1F26BB498BF9F8C9F86D162@irsmsx501.ger.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes in sock.c in function __rfcomm_sock_close, to release sock before calling rfcomm_dlc_close to avoid possible deadlock when calling rfcomm_lock (in rfcomm_dlc_close).

Signed-off-by: Jean Regis Ferraton <jrferraton@gmail.com>

---
 net/bluetooth/rfcomm/sock.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/net/bluetooth/rfcomm/sock.c b/net/bluetooth/rfcomm/sock.c
index 66cc1f0..3b5ec09 100644
--- a/net/bluetooth/rfcomm/sock.c
+++ b/net/bluetooth/rfcomm/sock.c
@@ -234,7 +234,10 @@ static void __rfcomm_sock_close(struct sock *sk)
 	case BT_CONNECT2:
 	case BT_CONFIG:
 	case BT_CONNECTED:
+		/* release_sock to avoid deadlock when calling rfcomm_lock() */
+		release_sock(sk);
 		rfcomm_dlc_close(d, 0);
+		lock_sock(sk);
 
 	default:
 		sock_set_flag(sk, SOCK_ZAPPED);
-- 
1.6.2.5

---------------------------------------------------------------------
Intel Corporation SAS (French simplified joint stock company)
Registered headquarters: "Les Montalets"- 2, rue de Paris, 
92196 Meudon Cedex, France
Registration Number:  302 456 199 R.C.S. NANTERRE
Capital: 4,572,000 Euros

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

