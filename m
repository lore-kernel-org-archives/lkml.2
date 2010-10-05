Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758005Ab0JEJvE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 05:51:04 -0400
Received: from proxy.DResearch.DE ([87.193.137.100]:50141 "EHLO
	mail.dresearch.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754854Ab0JEJvB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 05:51:01 -0400
X-Greylist: delayed 1078 seconds by postgrey-1.27 at vger.kernel.org; Tue, 05 Oct 2010 05:51:01 EDT
From: Mario Schuknecht <m.schuknecht@dresearch.de>
To: linux-kernel@vger.kernel.org
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-net@vger.kernel.org,
        Mario Schuknecht <m.schuknecht@dresearch.de>
Subject: [PATCH] tcp: ioctl type SIOCOUTQNSD returns amount of data not sent
Date: Tue,  5 Oct 2010 11:32:34 +0200
Message-Id: <1286271154-18600-1-git-send-email-m.schuknecht@dresearch.de>
X-Mailer: git-send-email 1.7.1
X-OriginalArrivalTime: 05 Oct 2010 09:33:01.0444 (UTC) FILETIME=[4DCAC440:01CB6470]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In contrast to SIOCOUTQ which returns the amount of data sent
but not yet acknowledged plus data not yet sent this patch only
returns the data not sent.

For various methods of live streaming bitrate control it may
be helpful to know how much data are in the tcp outqueue are
not sent yet.

Signed-off-by: Mario Schuknecht <m.schuknecht@dresearch.de>
---
 include/asm-generic/ioctls.h |    1 +
 include/linux/sockios.h      |    1 +
 net/ipv4/tcp.c               |    9 +++++++++
 3 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/include/asm-generic/ioctls.h b/include/asm-generic/ioctls.h
index a321665..b87115b 100644
--- a/include/asm-generic/ioctls.h
+++ b/include/asm-generic/ioctls.h
@@ -72,6 +72,7 @@
 #define TCSETXF		0x5434
 #define TCSETXW		0x5435
 #define TIOCSIG		_IOW('T', 0x36, int)  /* pty: generate signal */
+#define TIOCOUTQNSD	0x5437
 
 #define FIONCLEX	0x5450
 #define FIOCLEX		0x5451
diff --git a/include/linux/sockios.h b/include/linux/sockios.h
index 241f179..4c5ca47 100644
--- a/include/linux/sockios.h
+++ b/include/linux/sockios.h
@@ -23,6 +23,7 @@
 /* Linux-specific socket ioctls */
 #define SIOCINQ		FIONREAD
 #define SIOCOUTQ	TIOCOUTQ
+#define SIOCOUTQNSD	TIOCOUTQNSD
 
 /* Routing table calls. */
 #define SIOCADDRT	0x890B		/* add routing table entry	*/
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 1664a05..c2d52e8 100644
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

