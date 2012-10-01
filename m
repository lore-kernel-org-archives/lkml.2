Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933627Ab2JAXcz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 19:32:55 -0400
Received: from 1wt.eu ([62.212.114.60]:35155 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757610Ab2JAXA1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 19:00:27 -0400
Message-Id: <20121001225203.502626725@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 02 Oct 2012 00:54:16 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Mathias Krause <minipli@googlemail.com>,
        Gerrit Renker <gerrit@erg.abdn.ac.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Willy Tarreau <w@1wt.eu>
Subject: [ 139/180] dccp: check ccid before dereferencing
In-Reply-To: <6a854f579a99b4fe2efaca1057e8ae22@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Mathias Krause <minipli@googlemail.com>

commit 276bdb82dedb290511467a5a4fdbe9f0b52dce6f upstream.

ccid_hc_rx_getsockopt() and ccid_hc_tx_getsockopt() might be called with
a NULL ccid pointer leading to a NULL pointer dereference. This could
lead to a privilege escalation if the attacker is able to map page 0 and
prepare it with a fake ccid_ops pointer.

Signed-off-by: Mathias Krause <minipli@googlemail.com>
Cc: Gerrit Renker <gerrit@erg.abdn.ac.uk>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 net/dccp/ccid.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/dccp/ccid.h b/net/dccp/ccid.h
index facedd2..ab260b0 100644
--- a/net/dccp/ccid.h
+++ b/net/dccp/ccid.h
@@ -214,7 +214,7 @@ static inline int ccid_hc_rx_getsockopt(struct ccid *ccid, struct sock *sk,
 					u32 __user *optval, int __user *optlen)
 {
 	int rc = -ENOPROTOOPT;
-	if (ccid->ccid_ops->ccid_hc_rx_getsockopt != NULL)
+	if (ccid != NULL && ccid->ccid_ops->ccid_hc_rx_getsockopt != NULL)
 		rc = ccid->ccid_ops->ccid_hc_rx_getsockopt(sk, optname, len,
 						 optval, optlen);
 	return rc;
@@ -225,7 +225,7 @@ static inline int ccid_hc_tx_getsockopt(struct ccid *ccid, struct sock *sk,
 					u32 __user *optval, int __user *optlen)
 {
 	int rc = -ENOPROTOOPT;
-	if (ccid->ccid_ops->ccid_hc_tx_getsockopt != NULL)
+	if (ccid != NULL && ccid->ccid_ops->ccid_hc_tx_getsockopt != NULL)
 		rc = ccid->ccid_ops->ccid_hc_tx_getsockopt(sk, optname, len,
 						 optval, optlen);
 	return rc;
-- 
1.7.2.1.45.g54fbc



