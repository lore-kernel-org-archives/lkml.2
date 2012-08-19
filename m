Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753472Ab2HSOpk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2012 10:45:40 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:58180 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751743Ab2HSOph (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2012 10:45:37 -0400
Subject: Re: IPv4 BUG: held lock freed!
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Lin Ming <mlin@ss.pku.edu.cn>
Cc: Fengguang Wu <fengguang.wu@intel.com>, David Miller <davem@davemloft.net>,
        networking <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <CAF1ivSaU_ur9BkKG3eAsNw7d+ND5xgYbPKutemVqNec3X9m4SA@mail.gmail.com>
References: <20120818021918.GA6499@localhost>
	 <1345380682.5158.201.camel@edumazet-glaptop>
	 <CAF1ivSaU_ur9BkKG3eAsNw7d+ND5xgYbPKutemVqNec3X9m4SA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 19 Aug 2012 16:45:32 +0200
Message-ID: <1345387532.5158.222.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2012-08-19 at 22:15 +0800, Lin Ming wrote:

> Will it still has problem if code goes here without sock_hold(sk)?

Not sure of what you mean.

At the time tcp_write_timer() runs, we own one reference on the socket.
(this reference was taken in sk_reset_timer())

On old kernels, if we found the socket locked by the user, we used to
rearm the timer for a 50ms delay (and thus did sock_hold() again)

Another way to avoid the bug would to make sure sk_reset_timer()
increases refcount _before_ setting the timer, but its adding one atomic
in fast path...

diff --git a/net/core/sock.c b/net/core/sock.c
index 8f67ced..d1745b7 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -2114,8 +2114,9 @@ EXPORT_SYMBOL(sk_send_sigurg);
 void sk_reset_timer(struct sock *sk, struct timer_list* timer,
 		    unsigned long expires)
 {
-	if (!mod_timer(timer, expires))
-		sock_hold(sk);
+	sock_hold(sk);
+	if (mod_timer(timer, expires))
+		__sock_put(sk);
 }
 EXPORT_SYMBOL(sk_reset_timer);
 


