Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031299Ab2HGWr2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 18:47:28 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:60358 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031272Ab2HGWrP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 18:47:15 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Hangbin Liu <liuhangbin@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 35/49] tcp: Add TCP_USER_TIMEOUT negative value check
Date: Tue,  7 Aug 2012 15:44:53 -0700
Message-Id: <20120807222030.012580131@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120807222026.848194739@linuxfoundation.org>
References: <20120807222026.848194739@linuxfoundation.org>
User-Agent: quilt/0.60-20.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Hangbin Liu <liuhangbin@gmail.com>

[ Upstream commit 42493570100b91ef663c4c6f0c0fdab238f9d3c2 ]

TCP_USER_TIMEOUT is a TCP level socket option that takes an unsigned int. But
patch "tcp: Add TCP_USER_TIMEOUT socket option"(dca43c75) didn't check the negative
values. If a user assign -1 to it, the socket will set successfully and wait
for 4294967295 miliseconds. This patch add a negative value check to avoid
this issue.

Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/tcp.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -2394,7 +2394,10 @@ static int do_tcp_setsockopt(struct sock
 		/* Cap the max timeout in ms TCP will retry/retrans
 		 * before giving up and aborting (ETIMEDOUT) a connection.
 		 */
-		icsk->icsk_user_timeout = msecs_to_jiffies(val);
+		if (val < 0)
+			err = -EINVAL;
+		else
+			icsk->icsk_user_timeout = msecs_to_jiffies(val);
 		break;
 	default:
 		err = -ENOPROTOOPT;


