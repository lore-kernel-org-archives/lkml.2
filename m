Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932583Ab0JVSt3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 14:49:29 -0400
Received: from kroah.org ([198.145.64.141]:45764 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756837Ab0JVSim (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 14:38:42 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Oct 22 11:35:59 2010
Message-Id: <20101022183559.335906536@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 22 Oct 2010 11:35:02 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Ulrich Weber <uweber@astaro.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [35/66] xfrm4: strip ECN and IP Precedence bits in policy lookup
In-Reply-To: <20101022183711.GA23214@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------


From: Ulrich Weber <uweber@astaro.com>

[ Upstream commit 94e2238969e89f5112297ad2a00103089dde7e8f ]

dont compare ECN and IP Precedence bits in find_bundle
and use ECN bit stripped TOS value in xfrm_lookup

Signed-off-by: Ulrich Weber <uweber@astaro.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 net/ipv4/xfrm4_policy.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/ipv4/xfrm4_policy.c
+++ b/net/ipv4/xfrm4_policy.c
@@ -71,7 +71,7 @@ __xfrm4_find_bundle(struct flowi *fl, st
 		if (xdst->u.rt.fl.oif == fl->oif &&	/*XXX*/
 		    xdst->u.rt.fl.fl4_dst == fl->fl4_dst &&
 		    xdst->u.rt.fl.fl4_src == fl->fl4_src &&
-		    xdst->u.rt.fl.fl4_tos == fl->fl4_tos &&
+                    !((xdst->u.rt.fl.fl4_tos ^ fl->fl4_tos) & IPTOS_RT_MASK) &&
 		    xfrm_bundle_ok(policy, xdst, fl, AF_INET, 0)) {
 			dst_clone(dst);
 			break;
@@ -83,7 +83,7 @@ __xfrm4_find_bundle(struct flowi *fl, st
 
 static int xfrm4_get_tos(struct flowi *fl)
 {
-	return fl->fl4_tos;
+	return IPTOS_RT_MASK & fl->fl4_tos; /* Strip ECN bits */
 }
 
 static int xfrm4_init_path(struct xfrm_dst *path, struct dst_entry *dst,


