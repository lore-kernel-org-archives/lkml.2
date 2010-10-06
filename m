Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932243Ab0JFH2A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 03:28:00 -0400
Received: from smtp-out.google.com ([216.239.44.51]:14976 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932178Ab0JFH16 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 03:27:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:from:date:message-id:subject:to:cc:content-type;
        b=kvSF6ICbSajen65SOmS3oC8sZFYkPWdhFHqQeFD+bcKB6sWK62fUvIDISa8NYDWxHn
         6L1OFPcSKPHIB/790keQ==
MIME-Version: 1.0
From: =?UTF-8?B?Q2h1bmctWWloIFdhbmcgKOeOi+W0h+aHvyk=?= 
	<cywang@google.com>
Date: Wed, 6 Oct 2010 00:27:35 -0700
Message-ID: <AANLkTikkv4htP1f=KFwSaa8=K6LicDN0eusXctow-Efb@mail.gmail.com>
Subject: [PATCH] net: Fix sk_dst_check() to reset the obsolete dst_entry of a socket.
To: netdev <netdev@vger.kernel.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

    The issue is caused by the CL d11a4dc18bf41719c9f0d7ed494d295dd2973b92
    which will never reset the dst_entry of a socket if its current entry
    is freed(obsolete) for ipv4. This will block the socket's traffic
    instead of looking up a new dst_entry.

    Signed-off-by: Chung-yih Wang <cywang@google.com>
---
diff --git a/net/core/sock.c b/net/core/sock.c
index ef30e9d..b508819 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -382,7 +382,8 @@ struct dst_entry *__sk_dst_check(struct sock *sk,
u32 cookie)
 {
        struct dst_entry *dst = __sk_dst_get(sk);

-       if (dst && dst->obsolete && dst->ops->check(dst, cookie) == NULL) {
+       if (dst && dst->obsolete && ((dst->obsolete > 0) ||
+           (dst->ops->check(dst, cookie) == NULL))) {
                sk_tx_queue_clear(sk);
                rcu_assign_pointer(sk->sk_dst_cache, NULL);
                dst_release(dst);
@@ -397,7 +398,8 @@ struct dst_entry *sk_dst_check(struct sock *sk, u32 cookie)
 {
        struct dst_entry *dst = sk_dst_get(sk);

-       if (dst && dst->obsolete && dst->ops->check(dst, cookie) == NULL) {
+       if (dst && dst->obsolete && ((dst->obsolete > 0) ||
+           (dst->ops->check(dst, cookie) == NULL))) {
                sk_dst_reset(sk);
                dst_release(dst);
                return NULL;
