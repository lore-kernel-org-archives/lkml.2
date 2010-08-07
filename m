Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753443Ab0HGTRz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Aug 2010 15:17:55 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:34831 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752728Ab0HGTRy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Aug 2010 15:17:54 -0400
MIME-Version: 1.0
X-Originating-IP: [94.237.226.193]
Date: Sat, 7 Aug 2010 23:17:52 +0400
Message-ID: <AANLkTimHMAwi158ycRh_nRYPYUTSkww-psdFai-LsTsb@mail.gmail.com>
Subject: [PATCH] tcp: no md5sig option size check bug
From: Dmitry Popov <dp@highloadlab.com>
To: "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        James Morris <jmorris@namei.org>, Patrick McHardy <kaber@trash.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Cc: "Pekka Savola (ipv6)" <pekkas@netcore.fi>,
        Gilad Ben-Yossef <gilad@codefidence.com>,
        Yony Amit <yony@comsleep.com>, Ori Finkelman <ori@comsleep.com>,
        =?ISO-8859-1?Q?Ilpo_J=E4rvinen?= <ilpo.jarvinen@helsinki.fi>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dmitry Popov <dp@highloadlab.com>

tcp_parse_md5sig_option doesn't check md5sig option (TCPOPT_MD5SIG)
length, but tcp_v[46]_inbound_md5_hash assume that it's at least 16
bytes long.

Signed-off-by: Dmitry Popov <dp@highloadlab.com>
---
 net/ipv4/tcp_input.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 3c426cb..e663b78 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -3930,7 +3930,7 @@ u8 *tcp_parse_md5sig_option(struct tcphdr *th)
 			if (opsize < 2 || opsize > length)
 				return NULL;
 			if (opcode == TCPOPT_MD5SIG)
-				return ptr;
+				return opsize == TCPOLEN_MD5SIG ? ptr : NULL;
 		}
 		ptr += opsize - 2;
 		length -= opsize;
