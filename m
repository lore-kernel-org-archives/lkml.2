Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933635Ab0HXXOq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 19:14:46 -0400
Received: from kroah.org ([198.145.64.141]:41162 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755758Ab0HXXCp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 19:02:45 -0400
X-Mailbox-Line: From gregkh@clark.site Tue Aug 24 15:45:06 2010
Message-Id: <20100824224506.635112644@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 24 Aug 2010 15:45:07 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Dmitry Popov <dp@highloadlab.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [062/114] tcp: cookie transactions setsockopt memory leak
In-Reply-To: <20100824224610.GA5424@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------


From: Dmitry Popov <dp@highloadlab.com>

[ Upstream commit a3bdb549e30e7a263f7a589747c40e9c50110315 ]

There is a bug in do_tcp_setsockopt(net/ipv4/tcp.c),
TCP_COOKIE_TRANSACTIONS case.
In some cases (when tp->cookie_values == NULL) new tcp_cookie_values
structure can be allocated (at cvp), but not bound to
tp->cookie_values. So a memory leak occurs.

Signed-off-by: Dmitry Popov <dp@highloadlab.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 net/ipv4/tcp.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -2176,6 +2176,8 @@ static int do_tcp_setsockopt(struct sock
 				      GFP_KERNEL);
 			if (cvp == NULL)
 				return -ENOMEM;
+
+			kref_init(&cvp->kref);
 		}
 		lock_sock(sk);
 		tp->rx_opt.cookie_in_always =
@@ -2190,12 +2192,11 @@ static int do_tcp_setsockopt(struct sock
 				 */
 				kref_put(&tp->cookie_values->kref,
 					 tcp_cookie_values_release);
-				kref_init(&cvp->kref);
-				tp->cookie_values = cvp;
 			} else {
 				cvp = tp->cookie_values;
 			}
 		}
+
 		if (cvp != NULL) {
 			cvp->cookie_desired = ctd.tcpct_cookie_desired;
 
@@ -2209,6 +2210,8 @@ static int do_tcp_setsockopt(struct sock
 				cvp->s_data_desired = ctd.tcpct_s_data_desired;
 				cvp->s_data_constant = 0; /* false */
 			}
+
+			tp->cookie_values = cvp;
 		}
 		release_sock(sk);
 		return err;


