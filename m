Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964945Ab1DNR6T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 13:58:19 -0400
Received: from mail.windriver.com ([147.11.1.11]:41698 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964825Ab1DNR6A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 13:58:00 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Nandita Dukkipati <nanditad@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 140/209] tcp: Bug fix in initialization of receive window.
Date: Thu, 14 Apr 2011 13:54:58 -0400
Message-Id: <1302803767-9715-27-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1302803767-9715-1-git-send-email-paul.gortmaker@windriver.com>
References: <1302803039-9400-1-git-send-email-paul.gortmaker@windriver.com>
 <1302803767-9715-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nandita Dukkipati <nanditad@google.com>

  =====================================================================
  | This is a commit scheduled for the next v2.6.34 longterm release. |
  | If you see a problem with using this for longterm, please comment.|
  =====================================================================

commit b1afde60f2b9ee8444fba4e012dc99a3b28d224d upstream

The bug has to do with boundary checks on the initial receive window.
If the initial receive window falls between init_cwnd and the
receive window specified by the user, the initial window is incorrectly
brought down to init_cwnd. The correct behavior is to allow it to
remain unchanged.

Signed-off-by: Nandita Dukkipati <nanditad@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 net/ipv4/tcp_output.c |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index a5cf575..e1819aa 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -237,11 +237,10 @@ void tcp_select_initial_window(int __space, __u32 mss,
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
-- 
1.7.4.4

