Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934329Ab1ESSiA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 14:38:00 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:39037 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934003Ab1ESSc1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 14:32:27 -0400
X-Sasl-enc: BsQS6goqb5ASrAKXqMl8/DrEBRuGC2z1cs8c4OIGY/0S 1305829946
X-Mailbox-Line: From gregkh@clark.kroah.org Thu May 19 11:31:26 2011
Message-Id: <20110519183126.073197618@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 19 May 2011 11:30:37 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Dan Rosenberg <drosenberg@vsecurity.com>,
        Gerrit Renker <gerrit@erg.abdn.ac.uk>,
        "David S. Miller" <davem@davemloft.net>
Subject: [05/24] dccp: handle invalid feature options length
In-Reply-To: <20110519182446.GA23751@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-longterm review patch.  If anyone has any objections, please let us know.

------------------
Content-Length: 1099
Lines: 31

From: Dan Rosenberg <drosenberg@vsecurity.com>

commit a294865978b701e4d0d90135672749531b9a900d upstream.

A length of zero (after subtracting two for the type and len fields) for
the DCCPO_{CHANGE,CONFIRM}_{L,R} options will cause an underflow due to
the subtraction.  The subsequent code may read past the end of the
options value buffer when parsing.  I'm unsure of what the consequences
of this might be, but it's probably not good.

Signed-off-by: Dan Rosenberg <drosenberg@vsecurity.com>
Acked-by: Gerrit Renker <gerrit@erg.abdn.ac.uk>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/dccp/options.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/dccp/options.c
+++ b/net/dccp/options.c
@@ -131,6 +131,8 @@ int dccp_parse_options(struct sock *sk,
 		case DCCPO_CHANGE_L ... DCCPO_CONFIRM_R:
 			if (pkt_type == DCCP_PKT_DATA)      /* RFC 4340, 6 */
 				break;
+			if (len == 0)
+				goto out_invalid_option;
 			rc = dccp_feat_parse_options(sk, dreq, mandatory, opt,
 						    *value, value + 1, len - 1);
 			if (rc)


