Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933929Ab2JKBTn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 21:19:43 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:51738 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933914Ab2JKBTh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 21:19:37 -0400
X-Sasl-enc: nit/Ld8wRFcUF4dV4LTInNZt+FolsPkN9jsYMzmUuky4 1349918376
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Mathias Krause <minipli@googlemail.com>,
        Brad Spengler <spender@grsecurity.net>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 030/120] xfrm_user: fix info leak in copy_to_user_tmpl()
Date: Thu, 11 Oct 2012 09:59:42 +0900
Message-Id: <20121011005831.083883510@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <20121011005825.364610894@linuxfoundation.org>
References: <20121011005825.364610894@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Mathias Krause <minipli@googlemail.com>

[ Upstream commit 1f86840f897717f86d523a13e99a447e6a5d2fa5 ]

The memory used for the template copy is a local stack variable. As
struct xfrm_user_tmpl contains multiple holes added by the compiler for
alignment, not initializing the memory will lead to leaking stack bytes
to userland. Add an explicit memset(0) to avoid the info leak.

Initial version of the patch by Brad Spengler.

Signed-off-by: Mathias Krause <minipli@googlemail.com>
Cc: Brad Spengler <spender@grsecurity.net>
Acked-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/xfrm/xfrm_user.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/xfrm/xfrm_user.c
+++ b/net/xfrm/xfrm_user.c
@@ -1405,6 +1405,7 @@ static int copy_to_user_tmpl(struct xfrm
 		struct xfrm_user_tmpl *up = &vec[i];
 		struct xfrm_tmpl *kp = &xp->xfrm_vec[i];
 
+		memset(up, 0, sizeof(*up));
 		memcpy(&up->id, &kp->id, sizeof(up->id));
 		up->family = kp->encap_family;
 		memcpy(&up->saddr, &kp->saddr, sizeof(up->saddr));


