Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758186Ab2CMARy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 20:17:54 -0400
Received: from mail.windriver.com ([147.11.1.11]:46694 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756673Ab2CMARr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 20:17:47 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Dan Rosenberg <drosenberg@vsecurity.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 022/196] irda: prevent heap corruption on invalid nickname
Date: Mon, 12 Mar 2012 20:12:30 -0400
Message-Id: <1331597724-31358-23-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.3
In-Reply-To: <1331597724-31358-1-git-send-email-paul.gortmaker@windriver.com>
References: <1331597724-31358-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dan Rosenberg <drosenberg@vsecurity.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit d50e7e3604778bfc2dc40f440e0742dbae399d54 upstream.

Invalid nicknames containing only spaces will result in an underflow in
a memcpy size calculation, subsequently destroying the heap and
panicking.

v2 also catches the case where the provided nickname is longer than the
buffer size, which can result in controllable heap corruption.

Signed-off-by: Dan Rosenberg <drosenberg@vsecurity.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 net/irda/irnet/irnet_ppp.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/irda/irnet/irnet_ppp.c b/net/irda/irnet/irnet_ppp.c
index 6a1a202..ab5bee2 100644
--- a/net/irda/irnet/irnet_ppp.c
+++ b/net/irda/irnet/irnet_ppp.c
@@ -106,6 +106,9 @@ irnet_ctrl_write(irnet_socket *	ap,
 	      while(isspace(start[length - 1]))
 		length--;
 
+	      DABORT(length < 5 || length > NICKNAME_MAX_LEN + 5,
+		     -EINVAL, CTRL_ERROR, "Invalid nickname.\n");
+
 	      /* Copy the name for later reuse */
 	      memcpy(ap->rname, start + 5, length - 5);
 	      ap->rname[length - 5] = '\0';
-- 
1.7.9.3

