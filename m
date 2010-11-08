Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755567Ab0KHVQB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 16:16:01 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:40966 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755181Ab0KHVP7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 16:15:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=wFs1DSX0hY/JpjrOUdeIjH5zn6A2hNyinbnRhwT9PNQJqc1SdcwxDWbwX7c1SYjYJK
         h48rYGkJSjv6H5A7ZlGGlnjCN6tzxTn79e6RUB81+Q3L6UJyEztOeZw56fNcnZCsGXda
         7AZMTHKF6tH7BcswdXkb9LwYRkLMdC5J5YDR8=
Subject: [PATCH] inet: fix ip_mc_drop_socket()
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Markus Trippelsdorf <markus@trippelsdorf.de>,
        David Miller <davem@davemloft.net>
Cc: paulmck@linux.vnet.ibm.com, Miles Lane <miles.lane@gmail.com>,
        ilpo.jarvinen@helsinki.fi, LKML <linux-kernel@vger.kernel.org>,
        Len Brown <lenb@kernel.org>, netdev@vger.kernel.org
In-Reply-To: <20101108205511.GB1585@arch.trippelsdorf.de>
References: <AANLkTinVyf4CpxdzEWUn7zTyOrAMKY3H9Dct-HfopiSD@mail.gmail.com>
	 <20101108200600.GG4032@linux.vnet.ibm.com>
	 <1289248166.2790.1.camel@edumazet-laptop>
	 <20101108204240.GA1585@arch.trippelsdorf.de>
	 <1289249191.2790.3.camel@edumazet-laptop>
	 <20101108205511.GB1585@arch.trippelsdorf.de>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 08 Nov 2010 22:15:54 +0100
Message-ID: <1289250954.2790.11.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hmm, I believe I found the bug.

Thanks guys !

[PATCH] inet: fix ip_mc_drop_socket()

commit 8723e1b4ad9be4444 (inet: RCU changes in inetdev_by_index())
forgot one call site in ip_mc_drop_socket()

We should not decrease idev refcount after inetdev_by_index() call,
since refcount is not increased anymore.

Reported-by: Markus Trippelsdorf <markus@trippelsdorf.de>
Reported-by: Miles Lane <miles.lane@gmail.com>
Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
---
 net/ipv4/igmp.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/net/ipv4/igmp.c b/net/ipv4/igmp.c
index c8877c6..3c53c2d 100644
--- a/net/ipv4/igmp.c
+++ b/net/ipv4/igmp.c
@@ -2306,10 +2306,8 @@ void ip_mc_drop_socket(struct sock *sk)
 
 		in_dev = inetdev_by_index(net, iml->multi.imr_ifindex);
 		(void) ip_mc_leave_src(sk, iml, in_dev);
-		if (in_dev != NULL) {
+		if (in_dev != NULL)
 			ip_mc_dec_group(in_dev, iml->multi.imr_multiaddr.s_addr);
-			in_dev_put(in_dev);
-		}
 		/* decrease mem now to avoid the memleak warning */
 		atomic_sub(sizeof(*iml), &sk->sk_omem_alloc);
 		call_rcu(&iml->rcu, ip_mc_socklist_reclaim);


