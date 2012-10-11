Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933585Ab2JKCNT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 22:13:19 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:58868 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933360Ab2JKCNN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 22:13:13 -0400
X-Sasl-enc: u49BanBRFJM0NYUgYmSodd1Zz4qgMtz6tXh/DI+RschI 1349921591
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Mathias Krause <minipli@googlemail.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Martin Willi <martin@revosec.ch>,
        Ben Hutchings <bhutchings@solarflare.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 19/84] xfrm_user: ensure user supplied esn replay window is valid
Date: Thu, 11 Oct 2012 11:03:03 +0900
Message-Id: <20121011015420.524760782@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <20121011015417.017144658@linuxfoundation.org>
References: <20121011015417.017144658@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Mathias Krause <minipli@googlemail.com>

[ Upstream commit ecd7918745234e423dd87fcc0c077da557909720 ]

The current code fails to ensure that the netlink message actually
contains as many bytes as the header indicates. If a user creates a new
state or updates an existing one but does not supply the bytes for the
whole ESN replay window, the kernel copies random heap bytes into the
replay bitmap, the ones happen to follow the XFRMA_REPLAY_ESN_VAL
netlink attribute. This leads to following issues:

1. The replay window has random bits set confusing the replay handling
   code later on.

2. A malicious user could use this flaw to leak up to ~3.5kB of heap
   memory when she has access to the XFRM netlink interface (requires
   CAP_NET_ADMIN).

Known users of the ESN replay window are strongSwan and Steffen's
iproute2 patch (<http://patchwork.ozlabs.org/patch/85962/>). The latter
uses the interface with a bitmap supplied while the former does not.
strongSwan is therefore prone to run into issue 1.

To fix both issues without breaking existing userland allow using the
XFRMA_REPLAY_ESN_VAL netlink attribute with either an empty bitmap or a
fully specified one. For the former case we initialize the in-kernel
bitmap with zero, for the latter we copy the user supplied bitmap. For
state updates the full bitmap must be supplied.

To prevent overflows in the bitmap length calculation the maximum size
of bmp_len is limited to 128 by this patch -- resulting in a maximum
replay window of 4096 packets. This should be sufficient for all real
life scenarios (RFC 4303 recommends a default replay window size of 64).

Signed-off-by: Mathias Krause <minipli@googlemail.com>
Cc: Steffen Klassert <steffen.klassert@secunet.com>
Cc: Martin Willi <martin@revosec.ch>
Cc: Ben Hutchings <bhutchings@solarflare.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/xfrm.h |    2 ++
 net/xfrm/xfrm_user.c |   31 +++++++++++++++++++++++++------
 2 files changed, 27 insertions(+), 6 deletions(-)

--- a/include/linux/xfrm.h
+++ b/include/linux/xfrm.h
@@ -84,6 +84,8 @@ struct xfrm_replay_state {
 	__u32	bitmap;
 };
 
+#define XFRMA_REPLAY_ESN_MAX	4096
+
 struct xfrm_replay_state_esn {
 	unsigned int	bmp_len;
 	__u32		oseq;
--- a/net/xfrm/xfrm_user.c
+++ b/net/xfrm/xfrm_user.c
@@ -123,9 +123,21 @@ static inline int verify_replay(struct x
 				struct nlattr **attrs)
 {
 	struct nlattr *rt = attrs[XFRMA_REPLAY_ESN_VAL];
+	struct xfrm_replay_state_esn *rs;
 
-	if ((p->flags & XFRM_STATE_ESN) && !rt)
-		return -EINVAL;
+	if (p->flags & XFRM_STATE_ESN) {
+		if (!rt)
+			return -EINVAL;
+
+		rs = nla_data(rt);
+
+		if (rs->bmp_len > XFRMA_REPLAY_ESN_MAX / sizeof(rs->bmp[0]) / 8)
+			return -EINVAL;
+
+		if (nla_len(rt) < xfrm_replay_state_esn_len(rs) &&
+		    nla_len(rt) != sizeof(*rs))
+			return -EINVAL;
+	}
 
 	if (!rt)
 		return 0;
@@ -370,14 +382,15 @@ static inline int xfrm_replay_verify_len
 					 struct nlattr *rp)
 {
 	struct xfrm_replay_state_esn *up;
+	int ulen;
 
 	if (!replay_esn || !rp)
 		return 0;
 
 	up = nla_data(rp);
+	ulen = xfrm_replay_state_esn_len(up);
 
-	if (xfrm_replay_state_esn_len(replay_esn) !=
-			xfrm_replay_state_esn_len(up))
+	if (nla_len(rp) < ulen || xfrm_replay_state_esn_len(replay_esn) != ulen)
 		return -EINVAL;
 
 	return 0;
@@ -388,22 +401,28 @@ static int xfrm_alloc_replay_state_esn(s
 				       struct nlattr *rta)
 {
 	struct xfrm_replay_state_esn *p, *pp, *up;
+	int klen, ulen;
 
 	if (!rta)
 		return 0;
 
 	up = nla_data(rta);
+	klen = xfrm_replay_state_esn_len(up);
+	ulen = nla_len(rta) >= klen ? klen : sizeof(*up);
 
-	p = kmemdup(up, xfrm_replay_state_esn_len(up), GFP_KERNEL);
+	p = kzalloc(klen, GFP_KERNEL);
 	if (!p)
 		return -ENOMEM;
 
-	pp = kmemdup(up, xfrm_replay_state_esn_len(up), GFP_KERNEL);
+	pp = kzalloc(klen, GFP_KERNEL);
 	if (!pp) {
 		kfree(p);
 		return -ENOMEM;
 	}
 
+	memcpy(p, up, ulen);
+	memcpy(pp, up, ulen);
+
 	*replay_esn = p;
 	*preplay_esn = pp;
 


