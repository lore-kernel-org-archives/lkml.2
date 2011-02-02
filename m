Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753438Ab1BBBDs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 20:03:48 -0500
Received: from mga03.intel.com ([143.182.124.21]:11107 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753082Ab1BBAny (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 19:43:54 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,412,1291622400"; 
   d="scan'208";a="382960519"
From: Andi Kleen <andi@firstfloor.org>
References: <20110201443.618138584@firstfloor.org>
In-Reply-To: <20110201443.618138584@firstfloor.org>
To: nanditad@google.com, davem@davemloft.net, gregkh@suse.de,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [48/139] tcp: Bug fix in initialization of receive window.
Message-Id: <20110202004404.177413E09BD@tassilo.jf.intel.com>
Date: Tue,  1 Feb 2011 16:44:04 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Nandita Dukkipati <nanditad@google.com>

[ Upstream commit b1afde60f2b9ee8444fba4e012dc99a3b28d224d ]

The bug has to do with boundary checks on the initial receive window.
If the initial receive window falls between init_cwnd and the
receive window specified by the user, the initial window is incorrectly
brought down to init_cwnd. The correct behavior is to allow it to
remain unchanged.

Signed-off-by: Nandita Dukkipati <nanditad@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 net/ipv4/tcp_output.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

Index: linux-2.6.35.y/net/ipv4/tcp_output.c
===================================================================
--- linux-2.6.35.y.orig/net/ipv4/tcp_output.c
+++ linux-2.6.35.y/net/ipv4/tcp_output.c
@@ -237,11 +237,10 @@ void tcp_select_initial_window(int __spa
 		/* when initializing use the value from init_rcv_wnd
 		 * rather than the default from above
 		 */
-		if (init_rcv_wnd &&
-		    (*rcv_wnd > init_rcv_wnd * mss))
-			*rcv_wnd = init_rcv_wnd * mss;
-		else if (*rcv_wnd > init_cwnd * mss)
-			*rcv_wnd = init_cwnd * mss;
+		if (init_rcv_wnd)
+			*rcv_wnd = min(*rcv_wnd, init_rcv_wnd * mss);
+		else
+			*rcv_wnd = min(*rcv_wnd, init_cwnd * mss);
 	}
 
 	/* Set the clamp no higher than max representable value */
