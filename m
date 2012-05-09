Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757969Ab2EIGKy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 02:10:54 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:38969 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756271Ab2EIFxc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 01:53:32 -0400
Message-Id: <20120509055038.720368023@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Wed, 09 May 2012 06:51:33 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Thomas Graf <tgraf@infradead.org>,
        Thomas Graf <tgraf@suug.ch>, Vlad Yasevich <vladislav.yasevich@hp.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 064/167] [PATCH 04/26] sctp: Allow struct sctp_event_subscribe to grow
 without breaking binaries
In-Reply-To: <20120509055029.588587017@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Graf <tgraf@infradead.org>

[ Upstream commit acdd5985364f8dc511a0762fab2e683f29d9d692 ]

getsockopt(..., SCTP_EVENTS, ...) performs a length check and returns
an error if the user provides less bytes than the size of struct
sctp_event_subscribe.

Struct sctp_event_subscribe needs to be extended by an u8 for every
new event or notification type that is added.

This obviously makes getsockopt fail for binaries that are compiled
against an older versions of <net/sctp/user.h> which do not contain
all event types.

This patch changes getsockopt behaviour to no longer return an error
if not enough bytes are being provided by the user. Instead, it
returns as much of sctp_event_subscribe as fits into the provided buffer.

This leads to the new behavior that users see what they have been aware
of at compile time.

The setsockopt(..., SCTP_EVENTS, ...) API is already behaving like this.

Signed-off-by: Thomas Graf <tgraf@suug.ch>
Acked-by: Vlad Yasevich <vladislav.yasevich@hp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/sctp/socket.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 54a7cd2..0075554 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -4133,9 +4133,10 @@ static int sctp_getsockopt_disable_fragments(struct sock *sk, int len,
 static int sctp_getsockopt_events(struct sock *sk, int len, char __user *optval,
 				  int __user *optlen)
 {
-	if (len < sizeof(struct sctp_event_subscribe))
+	if (len <= 0)
 		return -EINVAL;
-	len = sizeof(struct sctp_event_subscribe);
+	if (len > sizeof(struct sctp_event_subscribe))
+		len = sizeof(struct sctp_event_subscribe);
 	if (put_user(len, optlen))
 		return -EFAULT;
 	if (copy_to_user(optval, &sctp_sk(sk)->subscribe, len))
-- 
1.7.10



