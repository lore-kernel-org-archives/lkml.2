Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754574Ab1AFAwd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 19:52:33 -0500
Received: from kroah.org ([198.145.64.141]:35693 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754201Ab1AFA3s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 19:29:48 -0500
X-Mailbox-Line: From gregkh@clark.site Wed Jan  5 16:23:02 2011
Message-Id: <20110106002301.959353029@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 05 Jan 2011 16:22:35 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Nandita Dukkipati <nanditad@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [056/152] tcp: Bug fix in initialization of receive window.
In-Reply-To: <20110106002500.GA3172@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

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
---
 net/ipv4/tcp_output.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
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


