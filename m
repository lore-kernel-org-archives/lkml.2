Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758398Ab0GIRNJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 13:13:09 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:44252 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757555Ab0GIRNF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 13:13:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Q8csSldAjoRDioopHG25a1Mtkt7ITUVn1VjfHq39x5/ePqkeW1Cyy8lA9JrCRYP8sb
         Xj0YjfotOFLqtNEj3Uw+eOlS+I6A+XIMEFlP7TBwPB9zpoZ/tGhr34ovrpWcgB+d5ouy
         ueOM3SgrnU4Xo/ET0Kog0sT1w1JW2iTofwTTw=
Subject: [PATCH] tproxy: nf_tproxy_assign_sock() can handle tw sockets
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Felipe W Damasio <felipewd@gmail.com>, David Miller <davem@davemloft.net>,
       Patrick McHardy <kaber@trash.net>
Cc: linux-kernel@vger.kernel.org, netdev <netdev@vger.kernel.org>
In-Reply-To: <AANLkTiliBClahTfb41M5BDi1etg5pgkqEz_VfGrn_mK4@mail.gmail.com>
References: <AANLkTimn8A0cYZmwNZYitRkBHKKFe4HQ5GU626DLugkk@mail.gmail.com>
	 <AANLkTil49m6Ul2bauiH4Pwn-6ykrYTFmSO6_SxqQgD_e@mail.gmail.com>
	 <1278626921.2435.73.camel@edumazet-laptop>
	 <AANLkTiliBClahTfb41M5BDi1etg5pgkqEz_VfGrn_mK4@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 09 Jul 2010 19:13:00 +0200
Message-ID: <1278695580.2696.55.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le vendredi 09 juillet 2010 à 12:03 -0300, Felipe W Damasio a écrit :
> Hi,
> 
> 2010/7/8 Eric Dumazet <eric.dumazet@gmail.com>:
> > Please try to reproduce a new report.
> >
> > It looks like a memory corruption, and it would be good to see if a
> > common pattern is occurring.
> 
> I'm trying..the thing is the freeze occured on the machine that sits
> on a 200Mbps ISP in bridge-mode. Since the machine frooze, and the
> whole ISP went down for a few minutes, I'm not allowed to run any
> tests on it.
> 
> I've setup the same scenario on a lab, but since last night been
> unable to reproduce the bug. Maybe there's a clue on the this crash
> below that can help me write some program to trigger the problem?
> 

Reviewing tproxy stuff I spotted a problem in nf_tproxy_assign_sock()
but I could not see how it could explain your crash.

We can read uninitialized memory and trigger a fault in
nf_tproxy_assign_sock(), not later in tcp_recvmsg()...

David, Patrick, what do you think ?

Thanks

[PATCH] tproxy: nf_tproxy_assign_sock() can handle tw sockets

transparent field of a socket is either inet_twsk(sk)->tw_transparent
for timewait sockets, or inet_sk(sk)->transparent for other sockets
(TCP/UDP).

Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
---
diff --git a/net/netfilter/nf_tproxy_core.c b/net/netfilter/nf_tproxy_core.c
index 5490fc3..daab8c4 100644
--- a/net/netfilter/nf_tproxy_core.c
+++ b/net/netfilter/nf_tproxy_core.c
@@ -70,7 +70,11 @@ nf_tproxy_destructor(struct sk_buff *skb)
 int
 nf_tproxy_assign_sock(struct sk_buff *skb, struct sock *sk)
 {
-	if (inet_sk(sk)->transparent) {
+	bool transparent = (sk->sk_state == TCP_TIME_WAIT) ?
+				inet_twsk(sk)->tw_transparent :
+				inet_sk(sk)->transparent;
+
+	if (transparent) {
 		skb_orphan(skb);
 		skb->sk = sk;
 		skb->destructor = nf_tproxy_destructor;


