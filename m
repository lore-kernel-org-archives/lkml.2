Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757225Ab0G2L7j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 07:59:39 -0400
Received: from mail-vw0-f66.google.com ([209.85.212.66]:54912 "EHLO
	mail-vw0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754149Ab0G2L7i convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 07:59:38 -0400
MIME-Version: 1.0
X-Originating-IP: [212.34.100.113]
Date: Thu, 29 Jul 2010 15:59:36 +0400
Message-ID: <AANLkTinHWJviHmhVcFQkobsgxa4-AaFUpHmd1wybiB+u@mail.gmail.com>
Subject: [PATCH] tcp: cookie transactions setsockopt memory leak
From: Dmitry Popov <dp@highloadlab.com>
To: "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        James Morris <jmorris@namei.org>, Patrick McHardy <kaber@trash.net>
Cc: "Pekka Savola (ipv6)" <pekkas@netcore.fi>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        =?ISO-8859-1?Q?Ilpo_J=E4rvinen?= <ilpo.jarvinen@helsinki.fi>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Steven J. Magnani" <steve@digidescorp.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        William Allen Simpson <william.allen.simpson@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dmitry Popov <dp@highloadlab.com>

There is a bug in do_tcp_setsockopt(net/ipv4/tcp.c),
TCP_COOKIE_TRANSACTIONS case.
In some cases (when tp->cookie_values == NULL) new tcp_cookie_values
structure can be allocated (at cvp), but not bound to
tp->cookie_values. So a memory leak occurs.

Signed-off-by: Dmitry Popov <dp@highloadlab.com>
---
tp->cookie_values can be NULL if socket was initialized with
sysctl_tcp_cookie_size == 0 (tcp_v4_init_sock, net/ipv4/tcp_ipv4.c)
Buggy releases: 2.6.33+ (since commit e56fb50f2b7958b931c8a2fc0966061b3f3c8f3a)

 net/ipv4/tcp.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 83d0213..9c490a1 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -2179,6 +2179,8 @@ static int do_tcp_setsockopt(struct sock *sk, int level,
 				      GFP_KERNEL);
 			if (cvp == NULL)
 				return -ENOMEM;
+
+			kref_init(&cvp->kref);
 		}
 		lock_sock(sk);
 		tp->rx_opt.cookie_in_always =
@@ -2193,12 +2195,11 @@ static int do_tcp_setsockopt(struct sock *sk, int level,
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

@@ -2212,6 +2213,8 @@ static int do_tcp_setsockopt(struct sock *sk, int level,
 				cvp->s_data_desired = ctd.tcpct_s_data_desired;
 				cvp->s_data_constant = 0; /* false */
 			}
+
+			tp->cookie_values = cvp;
 		}
 		release_sock(sk);
 		return err;
