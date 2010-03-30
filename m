Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932548Ab0C3XWr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 19:22:47 -0400
Received: from kroah.org ([198.145.64.141]:46765 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756948Ab0C3XVy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 19:21:54 -0400
X-Mailbox-Line: From linux@linux.site Tue Mar 30 15:48:49 2010
Message-Id: <20100330224848.859143100@linux.site>
User-Agent: quilt/0.47-14.9
Date: Tue, 30 Mar 2010 15:42:50 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>,
       "David S. Miller" <davem@davemloft.net>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [136/156] ipv6: Dont drop cache route entry unless timer actually expired.
In-Reply-To: <20100330230630.GA28824@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------

From: YOSHIFUJI Hideaki / 吉藤英明 <yoshfuji@linux-ipv6.org>

[ Upstream commit 54c1a859efd9fd6cda05bc700315ba2519c14eba ]

This is ipv6 variant of the commit 5e016cbf6.. ("ipv4: Don't drop
redirected route cache entry unless PTMU actually expired")
by Guenter Roeck <guenter.roeck@ericsson.com>.

Remove cache route entry in ipv6_negative_advice() only if
the timer is expired.

Signed-off-by: YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/ipv6/route.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -897,12 +897,17 @@ static struct dst_entry *ip6_negative_ad
 	struct rt6_info *rt = (struct rt6_info *) dst;
 
 	if (rt) {
-		if (rt->rt6i_flags & RTF_CACHE)
-			ip6_del_rt(rt);
-		else
+		if (rt->rt6i_flags & RTF_CACHE) {
+			if (rt6_check_expired(rt)) {
+				ip6_del_rt(rt);
+				dst = NULL;
+			}
+		} else {
 			dst_release(dst);
+			dst = NULL;
+		}
 	}
-	return NULL;
+	return dst;
 }
 
 static void ip6_link_failure(struct sk_buff *skb)


