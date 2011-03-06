Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754243Ab1CFUAf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Mar 2011 15:00:35 -0500
Received: from proxy.DResearch.DE ([87.193.137.100]:59170 "EHLO
	mail.dresearch.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753707Ab1CFUAQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Mar 2011 15:00:16 -0500
From: Steffen Sledz <sledz@dresearch.de>
To: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        "Pekka Savola (ipv6)" <pekkas@netcore.fi>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>,
        Mario Schuknecht <m.schuknecht@dresearch.de>,
        Steffen Sledz <sledz@dresearch.de>
Subject: [PATCH v3] tcp: ioctl type SIOCOUTQNSD returns amount of data not sent
Date: Sun,  6 Mar 2011 20:59:55 +0100
Message-Id: <1299441595-18455-1-git-send-email-sledz@dresearch.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <20110304123950.2c91ebd9@lxorguk.ukuu.org.uk>
References: <20110304123950.2c91ebd9@lxorguk.ukuu.org.uk>
X-OriginalArrivalTime: 06 Mar 2011 20:00:11.0229 (UTC) FILETIME=[19AE48D0:01CBDC39]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mario Schuknecht <m.schuknecht@dresearch.de>

In contrast to SIOCOUTQ which returns the amount of data sent
but not yet acknowledged plus data not yet sent this patch only
returns the data not sent.

For various methods of live streaming bitrate control it may
be helpful to know how much data are in the tcp outqueue are
not sent yet.

Signed-off-by: Mario Schuknecht <m.schuknecht@dresearch.de>
Signed-off-by: Steffen Sledz <sledz@dresearch.de>
---
 include/linux/sockios.h |    4 +++-
 net/ipv4/tcp.c          |    9 +++++++++
 2 files changed, 12 insertions(+), 1 deletions(-)

diff --git a/include/linux/sockios.h b/include/linux/sockios.h
index 241f179..7997a50 100644
--- a/include/linux/sockios.h
+++ b/include/linux/sockios.h
@@ -22,7 +22,7 @@
 
 /* Linux-specific socket ioctls */
 #define SIOCINQ		FIONREAD
-#define SIOCOUTQ	TIOCOUTQ
+#define SIOCOUTQ	TIOCOUTQ        /* output queue size (not sent + not acked) */
 
 /* Routing table calls. */
 #define SIOCADDRT	0x890B		/* add routing table entry	*/
@@ -83,6 +83,8 @@
 
 #define SIOCWANDEV	0x894A		/* get/set netdev parameters	*/
 
+#define SIOCOUTQNSD	0x894B		/* output queue size (not sent only) */
+
 /* ARP cache control calls. */
 		    /*  0x8950 - 0x8952  * obsolete calls, don't re-use */
 #define SIOCDARP	0x8953		/* delete ARP table entry	*/
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index a17a5a7..b22d450 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -505,6 +505,15 @@ int tcp_ioctl(struct sock *sk, int cmd, unsigned long arg)
 		else
 			answ = tp->write_seq - tp->snd_una;
 		break;
+	case SIOCOUTQNSD:
+		if (sk->sk_state == TCP_LISTEN)
+			return -EINVAL;
+
+		if ((1 << sk->sk_state) & (TCPF_SYN_SENT | TCPF_SYN_RECV))
+			answ = 0;
+		else
+			answ = tp->write_seq - tp->snd_nxt;
+		break;
 	default:
 		return -ENOIOCTLCMD;
 	}
-- 
1.7.1

