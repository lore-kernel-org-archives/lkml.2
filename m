Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030782Ab2HHTi2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 15:38:28 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:44666 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758479Ab2HHTi0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 15:38:26 -0400
Subject: Re: NULL pointer dereference in selinux_ip_postroute_compat
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Paul Moore <paul@paul-moore.com>
Cc: John Stultz <johnstul@us.ibm.com>, "Serge E. Hallyn" <serge@hallyn.com>,
        lkml <linux-kernel@vger.kernel.org>,
        James Morris <james.l.morris@oracle.com>, selinux@tycho.nsa.gov,
        Eric Dumazet <edumazet@google.com>, john.johansen@canonical.com
In-Reply-To: <17464273.DGOeQvDGIE@sifl>
References: <50215A7E.8000701@linaro.org> <502198B4.8040503@linaro.org>
	 <5022BAA2.90606@us.ibm.com>  <17464273.DGOeQvDGIE@sifl>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 08 Aug 2012 21:38:21 +0200
Message-ID: <1344454701.28967.233.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-08-08 at 15:26 -0400, Paul Moore wrote:
> On Wednesday, August 08, 2012 12:14:42 PM John Stultz wrote:
> > So I bisected this down and it seems to be the following commit:
> > 
> > commit be9f4a44e7d41cee50ddb5f038fc2391cbbb4046
> > Author: Eric Dumazet <edumazet@google.com>
> > Date:   Thu Jul 19 07:34:03 2012 +0000
> > 
> >      ipv4: tcp: remove per net tcp_sock
> > 
> > 
> > It doesn't revert totally cleanly, but after fixing up the rejections
> > and booting with this patch removed on top of Linus' head the oops on
> > shutdown goes away.
> 
> Thanks!
> 
> It looks the like there is a bug in ip_send_unicast_reply() which uses a 
> inet_sock/sock struct which does not have the LSM data properly initialized. 
> 
> I'll put together a patch shortly.
> 

Something like this ?

diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
index ba39a52..027a331 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -1524,6 +1524,10 @@ void ip_send_unicast_reply(struct net *net, struct sk_buff *skb, __be32 daddr,
 	sk->sk_priority = skb->priority;
 	sk->sk_protocol = ip_hdr(skb)->protocol;
 	sk->sk_bound_dev_if = arg->bound_dev_if;
+#ifdef CONFIG_SECURITY
+	if (!sk->sk_security && security_sk_alloc(sk, PF_INET, GFP_ATOMIC))
+			goto out;
+#endif
 	sock_net_set(sk, net);
 	__skb_queue_head_init(&sk->sk_write_queue);
 	sk->sk_sndbuf = sysctl_wmem_default;
@@ -1539,7 +1543,7 @@ void ip_send_unicast_reply(struct net *net, struct sk_buff *skb, __be32 daddr,
 		skb_set_queue_mapping(nskb, skb_get_queue_mapping(skb));
 		ip_push_pending_frames(sk, &fl4);
 	}
-
+out:
 	put_cpu_var(unicast_sock);
 
 	ip_rt_put(rt);


