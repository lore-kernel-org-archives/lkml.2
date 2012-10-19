Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758115Ab2JSDRv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 23:17:51 -0400
Received: from mail.kernel.org ([198.145.19.201]:54623 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758084Ab2JSDRo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 23:17:44 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Jan Engelhardt <jengelh@inai.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        David Miller <davem@davemloft.net>
Subject: [ 28/37] netfilter: xt_limit: have r->cost != 0 case work
Date: Thu, 18 Oct 2012 20:16:51 -0700
Message-Id: <20121019031307.381417622@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <20121019031302.789593147@linuxfoundation.org>
References: <20121019031302.789593147@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Engelhardt <jengelh@inai.de>

commit 82e6bfe2fbc4d48852114c4f979137cd5bf1d1a8 upstream.

Commit v2.6.19-rc1~1272^2~41 tells us that r->cost != 0 can happen when
a running state is saved to userspace and then reinstated from there.

Make sure that private xt_limit area is initialized with correct values.
Otherwise, random matchings due to use of uninitialized memory.

Signed-off-by: Jan Engelhardt <jengelh@inai.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Acked-by: David Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/netfilter/xt_limit.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/net/netfilter/xt_limit.c
+++ b/net/netfilter/xt_limit.c
@@ -117,11 +117,11 @@ static int limit_mt_check(const struct x
 
 	/* For SMP, we only want to use one set of state. */
 	r->master = priv;
+	/* User avg in seconds * XT_LIMIT_SCALE: convert to jiffies *
+	   128. */
+	priv->prev = jiffies;
+	priv->credit = user2credits(r->avg * r->burst); /* Credits full. */
 	if (r->cost == 0) {
-		/* User avg in seconds * XT_LIMIT_SCALE: convert to jiffies *
-		   128. */
-		priv->prev = jiffies;
-		priv->credit = user2credits(r->avg * r->burst); /* Credits full. */
 		r->credit_cap = priv->credit; /* Credits full. */
 		r->cost = user2credits(r->avg);
 	}


