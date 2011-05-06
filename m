Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756305Ab1EFN10 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 09:27:26 -0400
Received: from mx1.vsecurity.com ([209.67.252.12]:53824 "EHLO
	mx1.vsecurity.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755021Ab1EFN1Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 09:27:25 -0400
Subject: [PATCH] dccp: handle invalid feature options length
From: Dan Rosenberg <drosenberg@vsecurity.com>
To: gerrit@erg.abdn.ac.uk, davem@davemloft.net
Cc: dccp@vger.kernel.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        security@kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 06 May 2011 09:27:18 -0400
Message-ID: <1304688438.29544.16.camel@dan>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A length of zero (after subtracting two for the type and len fields) for
the DCCPO_{CHANGE,CONFIRM}_{L,R} options will cause an underflow due to
the subtraction.  The subsequent code may read past the end of the
options value buffer when parsing.  I'm unsure of what the consequences
of this might be, but it's probably not good.

Signed-off-by: Dan Rosenberg <drosenberg@vsecurity.com>
Cc: stable@kernel.org
---
 net/dccp/options.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/net/dccp/options.c b/net/dccp/options.c
index f06ffcf..4b2ab65 100644
--- a/net/dccp/options.c
+++ b/net/dccp/options.c
@@ -123,6 +123,8 @@ int dccp_parse_options(struct sock *sk, struct dccp_request_sock *dreq,
 		case DCCPO_CHANGE_L ... DCCPO_CONFIRM_R:
 			if (pkt_type == DCCP_PKT_DATA)      /* RFC 4340, 6 */
 				break;
+			if (len == 0)
+				goto out_invalid_option;
 			rc = dccp_feat_parse_options(sk, dreq, mandatory, opt,
 						    *value, value + 1, len - 1);
 			if (rc)


