Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754661Ab0E3ULh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 May 2010 16:11:37 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:38254 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754456Ab0E3ULe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 May 2010 16:11:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=suPOEnxegv+pdG4LVBlWvSjQBq7T3lP+vj23/TlIT9GKuXIGFWXon9h3WnljuDlMy4
         ftROMQ2zggd3PrWLVtVQctGJj+/AA5NoIg2pWRDE51hmTlO5fgjmVs9hwfrR8i50NYzB
         4EzigfyLKh+677G6BtEpsaE7uI9dzYqAJ5Kfk=
Subject: Re: Subject: [PATCH] net/ipv6: Use GFP_ATOMIC when a lock is held
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Julia Lawall <julia@diku.dk>
Cc: "David S. Miller" <davem@davemloft.net>,
       Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
       "Pekka Savola (ipv6)" <pekkas@netcore.fi>,
       James Morris <jmorris@namei.org>,
       Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
       Patrick McHardy <kaber@trash.net>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.1005302147310.19253@ask.diku.dk>
References: <Pine.LNX.4.64.1005302147310.19253@ask.diku.dk>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 30 May 2010 22:11:28 +0200
Message-ID: <1275250288.2472.21.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le dimanche 30 mai 2010 à 21:48 +0200, Julia Lawall a écrit :
> From: Julia Lawall <julia@diku.dk>
> 
> A spin lock is taken near the beginning of the enclosing function.
> 
> The semantic patch that makes this change is as follows:
> (http://coccinelle.lip6.fr/)
> 
> // <smpl>
> @@
> @@
> 
> spin_lock(...)
> ... when != spin_unlock(...)
> -GFP_KERNEL
> +GFP_ATOMIC
> // </smpl>
> 
> Signed-off-by: Julia Lawall <julia@diku.dk>
> 
> ---
>  net/ipv6/sit.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff -u -p a/net/ipv6/sit.c b/net/ipv6/sit.c
> --- a/net/ipv6/sit.c
> +++ b/net/ipv6/sit.c
> @@ -358,7 +358,7 @@ ipip6_tunnel_add_prl(struct ip_tunnel *t
>  		goto out;
>  	}
>  
> -	p = kzalloc(sizeof(struct ip_tunnel_prl_entry), GFP_KERNEL);
> +	p = kzalloc(sizeof(struct ip_tunnel_prl_entry), GFP_ATOMIC);
>  	if (!p) {
>  		err = -ENOBUFS;
>  		goto out;

Nice catch, but what about allocating this outside of the locked
section ?

diff --git a/net/ipv6/sit.c b/net/ipv6/sit.c
index e51e650..ff3dd84 100644
--- a/net/ipv6/sit.c
+++ b/net/ipv6/sit.c
@@ -340,6 +340,10 @@ ipip6_tunnel_add_prl(struct ip_tunnel *t, struct ip_tunnel_prl *a, int chg)
 	if (a->addr == htonl(INADDR_ANY))
 		return -EINVAL;
 
+	p = kzalloc(sizeof(struct ip_tunnel_prl_entry), GFP_KERNEL);
+	if (!p)
+		return -ENOBUFS;
+
 	spin_lock(&ipip6_prl_lock);
 
 	for (p = t->prl; p; p = p->next) {
@@ -358,19 +362,16 @@ ipip6_tunnel_add_prl(struct ip_tunnel *t, struct ip_tunnel_prl *a, int chg)
 		goto out;
 	}
 
-	p = kzalloc(sizeof(struct ip_tunnel_prl_entry), GFP_KERNEL);
-	if (!p) {
-		err = -ENOBUFS;
-		goto out;
-	}
 
 	p->next = t->prl;
 	p->addr = a->addr;
 	p->flags = a->flags;
 	t->prl_count++;
 	rcu_assign_pointer(t->prl, p);
+	p = NULL;
 out:
 	spin_unlock(&ipip6_prl_lock);
+	kfree(p);
 	return err;
 }
 


