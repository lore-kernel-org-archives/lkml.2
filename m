Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758075Ab2C1Nw7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 09:52:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16445 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756854Ab2C1Nw6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 09:52:58 -0400
Date: Wed, 28 Mar 2012 10:52:12 -0300
From: Flavio Leitner <fbl@redhat.com>
To: Alexandru Copot <alex.mihai.c@gmail.com>
Cc: davem@davemloft.net, eric.dumazet@gmail.com, kuznet@ms2.inr.ac.ru,
        jmorris@namei.org, yoshfuji@linux-ipv6.org, kaber@trash.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Daniel Baluta <dbaluta@ixiacom.com>
Subject: Re: [PATCH] tcp: bind() use stronger condition for bind_conflict
Message-ID: <20120328105212.1cb8dfe5@asterix.rh>
In-Reply-To: <1332882712-10756-1-git-send-email-alex.mihai.c@gmail.com>
References: <1332882712-10756-1-git-send-email-alex.mihai.c@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Mar 2012 00:11:52 +0300
Alexandru Copot <alex.mihai.c@gmail.com> wrote:

> We must try harder to get unique (addr, port) pairs when
> doing port autoselection for sockets with SO_REUSEADDR
> option set.
> 
> We achieve this by adding a relaxation parameter to
> inet_csk_bind_conflict. When 'relax' parameter is off
> we return a conflict whenever the current searched
> pair (addr, port) is not unique.
> 
> This tries to address the problems reported in patch:
> 	8d238b25b1ec22a73b1c2206f111df2faaff8285
> 	Revert "tcp: bind() fix when many ports are bound"
> 
> Signed-off-by: Alexandru Copot <alex.mihai.c@gmail.com>
> Signed-off-by: Daniel Baluta <dbaluta@ixiacom.com>
> ---
>  include/net/inet6_connection_sock.h |    2 +-
>  include/net/inet_connection_sock.h  |    4 ++--
>  net/ipv4/inet_connection_sock.c     |   17 +++++++++++++----
>  net/ipv6/inet6_connection_sock.c    |    3 ++-
>  4 files changed, 18 insertions(+), 8 deletions(-)
> 
> diff --git a/include/net/inet6_connection_sock.h b/include/net/inet6_connection_sock.h
> index 3207e58..9d29ae2 100644
> --- a/include/net/inet6_connection_sock.h
> +++ b/include/net/inet6_connection_sock.h
> @@ -23,7 +23,7 @@ struct sock;
>  struct sockaddr;
>  
>  extern int inet6_csk_bind_conflict(const struct sock *sk,
> -				   const struct inet_bind_bucket *tb);
> +				   const struct inet_bind_bucket *tb, int relax);
>  
>  extern struct dst_entry* inet6_csk_route_req(struct sock *sk,
>  					     const struct request_sock *req);
> diff --git a/include/net/inet_connection_sock.h b/include/net/inet_connection_sock.h
> index dbf9aab..f05a032 100644
> --- a/include/net/inet_connection_sock.h
> +++ b/include/net/inet_connection_sock.h
> @@ -60,7 +60,7 @@ struct inet_connection_sock_af_ops {
>  #endif
>  	void	    (*addr2sockaddr)(struct sock *sk, struct sockaddr *);
>  	int	    (*bind_conflict)(const struct sock *sk,
> -				     const struct inet_bind_bucket *tb);
> +				     const struct inet_bind_bucket *tb, int relax);
>  };
>  
>  /** inet_connection_sock - INET connection oriented sock
> @@ -245,7 +245,7 @@ extern struct request_sock *inet_csk_search_req(const struct sock *sk,
>  						const __be32 raddr,
>  						const __be32 laddr);
>  extern int inet_csk_bind_conflict(const struct sock *sk,
> -				  const struct inet_bind_bucket *tb);
> +				  const struct inet_bind_bucket *tb, int relax);
>  extern int inet_csk_get_port(struct sock *sk, unsigned short snum);
>  
>  extern struct dst_entry* inet_csk_route_req(struct sock *sk,
> diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
> index 19d66ce..bf50e77 100644
> --- a/net/ipv4/inet_connection_sock.c
> +++ b/net/ipv4/inet_connection_sock.c
> @@ -53,7 +53,7 @@ void inet_get_local_port_range(int *low, int *high)
>  EXPORT_SYMBOL(inet_get_local_port_range);
>  
>  int inet_csk_bind_conflict(const struct sock *sk,
> -			   const struct inet_bind_bucket *tb)
> +			   const struct inet_bind_bucket *tb, int relax)
>  {
>  	struct sock *sk2;
>  	struct hlist_node *node;
> @@ -79,6 +79,13 @@ int inet_csk_bind_conflict(const struct sock *sk,
>  				    sk2_rcv_saddr == sk_rcv_saddr(sk))
>  					break;
>  			}
> +			if (!relax && reuse && sk2->sk_reuse &&
> +					sk2->sk_state != TCP_LISTEN) {
> +				const __be32 sk2_rcv_saddr = sk_rcv_saddr(sk2);
> +				if (!sk2_rcv_saddr || !sk_rcv_saddr(sk) ||
> +						sk2_rcv_saddr == sk_rcv_saddr(sk))

I am still checking the patch, but the above is out of coding style.
perhaps:
+				if (!sk2_rcv_saddr || !sk_rcv_saddr(sk) ||
+				    sk2_rcv_saddr == sk_rcv_saddr(sk))


> +					break;
> +			}
>  		}
>  	}
>  	return node != NULL;
> @@ -122,12 +129,13 @@ again:
>  					    (tb->num_owners < smallest_size || smallest_size == -1)) {
>  						smallest_size = tb->num_owners;
>  						smallest_rover = rover;
> -						if (atomic_read(&hashinfo->bsockets) > (high - low) + 1) {
> +						if (atomic_read(&hashinfo->bsockets) > (high - low) + 1 &&
> +							!inet_csk(sk)->icsk_af_ops->bind_conflict(sk, tb, 0)) {

Same above.

>  							snum = smallest_rover;
>  							goto tb_found;
>  						}
>  					}
> -					if (!inet_csk(sk)->icsk_af_ops->bind_conflict(sk, tb)) {
> +					if (!inet_csk(sk)->icsk_af_ops->bind_conflict(sk, tb, 0)) {
>  						snum = rover;
>  						goto tb_found;
>  					}
> @@ -178,12 +186,13 @@ tb_found:
>  			goto success;
>  		} else {
>  			ret = 1;
> -			if (inet_csk(sk)->icsk_af_ops->bind_conflict(sk, tb)) {
> +			if (inet_csk(sk)->icsk_af_ops->bind_conflict(sk, tb, 1)) {
>  				if (sk->sk_reuse && sk->sk_state != TCP_LISTEN &&
>  				    smallest_size != -1 && --attempts >= 0) {
>  					spin_unlock(&head->lock);
>  					goto again;
>  				}
> +
>  				goto fail_unlock;
>  			}
>  		}
> diff --git a/net/ipv6/inet6_connection_sock.c b/net/ipv6/inet6_connection_sock.c
> index 02dd203..dfc8bc3 100644
> --- a/net/ipv6/inet6_connection_sock.c
> +++ b/net/ipv6/inet6_connection_sock.c
> @@ -28,7 +28,8 @@
>  #include <net/inet6_connection_sock.h>
>  
>  int inet6_csk_bind_conflict(const struct sock *sk,
> -			    const struct inet_bind_bucket *tb)
> +			    const struct inet_bind_bucket *tb,
> +				int relax)

Same here
Maybe you can wait for more feedbacks before spin another patch 
version just to fix that.


fbl

>  {
>  	const struct sock *sk2;
>  	const struct hlist_node *node;

