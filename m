Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161632Ab1FAILy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 04:11:54 -0400
Received: from cantor.suse.de ([195.135.220.2]:43446 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161604Ab1FAILf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 04:11:35 -0400
X-Mailbox-Line: From linux@blue.kroah.org Wed Jun  1 17:03:22 2011
Message-Id: <20110601080321.311877896@blue.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 01 Jun 2011 16:59:56 +0900
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        =?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@helsinki.fi>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [060/146] tcp: len check is unnecessarily devastating, change to WARN_ON
In-Reply-To: <20110601080606.GA522@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------


From: =?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@helsinki.fi>

[ Upstream commit 2fceec13375e5d98ef033c6b0ee03943fc460950 ]

All callers are prepared for alloc failures anyway, so this error
can safely be boomeranged to the callers domain without super
bad consequences. ...At worst the connection might go into a state
where each RTO tries to (unsuccessfully) re-fragment with such
a mis-sized value and eventually dies.

Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@helsinki.fi>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 net/ipv4/tcp_output.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -1003,7 +1003,8 @@ int tcp_fragment(struct sock *sk, struct
 	int nlen;
 	u8 flags;
 
-	BUG_ON(len > skb->len);
+	if (WARN_ON(len > skb->len))
+		return -EINVAL;
 
 	nsize = skb_headlen(skb) - len;
 	if (nsize < 0)


