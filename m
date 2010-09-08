Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754348Ab0IHNtT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 09:49:19 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:33348 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751065Ab0IHNtQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 09:49:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=T2D7sJt9nk0T5W9wJZBJBsKjjLjhn1goHonYUlxJlnudkfQqW9W1BIlUAD2DO8vj0+
         8/QBTuRCOcP4lwRYosvSvg/s9hUIfi+iZEYvgYBW1N9pCa8dwBHyOUQLWK92HGD4erIY
         rayfwnVfUPp50Q5gSqjJH+06zPXs6gWva6650=
From: Namhyung Kim <namhyung@gmail.com>
To: "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] net/core: add lock context change annotations in net/core/sock.c
Date: Wed,  8 Sep 2010 22:48:48 +0900
Message-Id: <1283953728-15302-2-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <1283953728-15302-1-git-send-email-namhyung@gmail.com>
References: <1283953728-15302-1-git-send-email-namhyung@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__lock_sock() and __release_sock() releases and regrabs lock but
were missing proper annotations. Add it. This removes following
warning from sparse. (Currently __lock_sock() does not emit any
warning about it but I think it is better to add also.)

 net/core/sock.c:1580:17: warning: context imbalance in '__release_sock' - unexpected unlock

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 net/core/sock.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/net/core/sock.c b/net/core/sock.c
index b05b9b6..f3a06c4 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -1557,6 +1557,8 @@ struct sk_buff *sock_alloc_send_skb(struct sock *sk, unsigned long size,
 EXPORT_SYMBOL(sock_alloc_send_skb);
 
 static void __lock_sock(struct sock *sk)
+	__releases(&sk->sk_lock.slock)
+	__acquires(&sk->sk_lock.slock)
 {
 	DEFINE_WAIT(wait);
 
@@ -1573,6 +1575,8 @@ static void __lock_sock(struct sock *sk)
 }
 
 static void __release_sock(struct sock *sk)
+	__releases(&sk->sk_lock.slock)
+	__acquires(&sk->sk_lock.slock)
 {
 	struct sk_buff *skb = sk->sk_backlog.head;
 
-- 
1.7.2.2

