Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965150Ab2CMAe1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 20:34:27 -0400
Received: from mail.windriver.com ([147.11.1.11]:48750 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965119Ab2CMAYg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 20:24:36 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Dan Rosenberg <drosenberg@vsecurity.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 170/196] dccp: handle invalid feature options length
Date: Mon, 12 Mar 2012 20:21:23 -0400
Message-Id: <1331598109-31424-125-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.3
In-Reply-To: <1331598109-31424-1-git-send-email-paul.gortmaker@windriver.com>
References: <1331597724-31358-1-git-send-email-paul.gortmaker@windriver.com>
 <1331598109-31424-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dan Rosenberg <drosenberg@vsecurity.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit a294865978b701e4d0d90135672749531b9a900d upstream.

A length of zero (after subtracting two for the type and len fields) for
the DCCPO_{CHANGE,CONFIRM}_{L,R} options will cause an underflow due to
the subtraction.  The subsequent code may read past the end of the
options value buffer when parsing.  I'm unsure of what the consequences
of this might be, but it's probably not good.

Signed-off-by: Dan Rosenberg <drosenberg@vsecurity.com>
Acked-by: Gerrit Renker <gerrit@erg.abdn.ac.uk>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 net/dccp/options.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/dccp/options.c b/net/dccp/options.c
index 1b08cae..b4a853e 100644
--- a/net/dccp/options.c
+++ b/net/dccp/options.c
@@ -131,6 +131,8 @@ int dccp_parse_options(struct sock *sk, struct dccp_request_sock *dreq,
 		case DCCPO_CHANGE_L ... DCCPO_CONFIRM_R:
 			if (pkt_type == DCCP_PKT_DATA)      /* RFC 4340, 6 */
 				break;
+			if (len == 0)
+				goto out_invalid_option;
 			rc = dccp_feat_parse_options(sk, dreq, mandatory, opt,
 						    *value, value + 1, len - 1);
 			if (rc)
-- 
1.7.9.3

