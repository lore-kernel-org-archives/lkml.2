Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756055Ab1K1C46 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Nov 2011 21:56:58 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:36449 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755905Ab1K1C44 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Nov 2011 21:56:56 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Mon, 28 Nov 2011 11:55:41 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Glauber Costa <glommer@parallels.com>
Cc: linux-kernel@vger.kernel.org, lizf@cn.fujitsu.com, ebiederm@xmission.com,
        davem@davemloft.net, paul@paulmenage.org, gthelen@google.com,
        netdev@vger.kernel.org, linux-mm@kvack.org, kirill@shutemov.name,
        avagin@parallels.com, devel@openvz.org, eric.dumazet@gmail.com,
        cgroups@vger.kernel.org
Subject: Re: [PATCH v6 02/10] foundations of per-cgroup memory pressure
 controlling.
Message-Id: <20111128115541.bc8f2ffa.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1322242696-27682-3-git-send-email-glommer@parallels.com>
References: <1322242696-27682-1-git-send-email-glommer@parallels.com>
	<1322242696-27682-3-git-send-email-glommer@parallels.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 Nov 2011 15:38:08 -0200
Glauber Costa <glommer@parallels.com> wrote:

> This patch replaces all uses of struct sock fields' memory_pressure,
> memory_allocated, sockets_allocated, and sysctl_mem to acessor
> macros. Those macros can either receive a socket argument, or a mem_cgroup
> argument, depending on the context they live in.
> 
> Since we're only doing a macro wrapping here, no performance impact at all is
> expected in the case where we don't have cgroups disabled.
> 
> Signed-off-by: Glauber Costa <glommer@parallels.com>
> CC: David S. Miller <davem@davemloft.net>
> CC: Hiroyouki Kamezawa <kamezawa.hiroyu@jp.fujitsu.com>
> CC: Eric W. Biederman <ebiederm@xmission.com>
> CC: Eric Dumazet <eric.dumazet@gmail.com>

I have some comments on the style. Maybe a nitpick but many patches were
sent for fixing conding style in memcg recently.

+static inline int *sk_memory_pressure(const struct sock *sk)
+{
+	return sk->sk_prot->memory_pressure;
+}
+
+static inline long sk_prot_mem(const struct sock *sk, int index)
+{
+	long *prot = sk->sk_prot->sysctl_mem;
+	return prot[index];
+}
+

I don't think sk_prot_mem() is an easy to undestand name.
sk_prot_memory_limit() ?

> +static inline int
> +kcg_sockets_allocated_sum_positive(struct proto *prot, struct mem_cgroup *cg)
> +{
> +	return percpu_counter_sum_positive(prot->sockets_allocated);
> +}
> +
> +static inline long
> +kcg_memory_allocated(struct proto *prot, struct mem_cgroup *cg)
> +{
> +	return atomic_long_read(prot->memory_allocated);
> +}
>  

I don't like 'kcg'. What it means ? 
memory_cgrou_prot_socekts_allocated() ? and
memory_cgroup_prot_memory_allocated() ?

And the variable for memory cgroup should be 'memcg'.
http://www.spinics.net/lists/linux-mm/msg26781.html
So, please rename.



>  #ifdef CONFIG_PROC_FS
>  /* Called with local bh disabled */
> diff --git a/include/net/tcp.h b/include/net/tcp.h
> index e147f42..ccaa3b6 100644
<snip>

 	seq_printf(seq, "RAW: inuse %d\n",
> diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
> index 34f5db1..89a2bfe 100644
> --- a/net/ipv4/tcp.c
> +++ b/net/ipv4/tcp.c
> @@ -319,9 +319,11 @@ EXPORT_SYMBOL(tcp_memory_pressure);
>  
>  void tcp_enter_memory_pressure(struct sock *sk)
>  {
> -	if (!tcp_memory_pressure) {
> +	int *memory_pressure = sk_memory_pressure(sk);
> +

Don't you need !memory_pressure check here ?

Hmm, can this function be

+static inline int *sk_memory_pressure(const struct sock *sk)
+{
+	return sk->sk_prot->memory_pressure;
+}

as

static inline bool sk_under_prot_memory_pressure(const struct sock *sk)
{
	if (sk->sk_prot->memory_pressure &&
	    *sk->sk_prot->memory_pressure)
		return true;

	return false;
}

and have sk_set/unset_prot_memory_pressure(),  ?



> +	if (!*memory_pressure) {
>  		NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPMEMORYPRESSURES);
> -		tcp_memory_pressure = 1;
> +		*memory_pressure = 1;
>  	}
>  }
>  EXPORT_SYMBOL(tcp_enter_memory_pressure);
> diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
> index 52b5c2d..3df862d 100644
> --- a/net/ipv4/tcp_input.c
> +++ b/net/ipv4/tcp_input.c
> @@ -322,7 +322,7 @@ static void tcp_grow_window(struct sock *sk, const struct sk_buff *skb)
>  	/* Check #1 */
>  	if (tp->rcv_ssthresh < tp->window_clamp &&
>  	    (int)tp->rcv_ssthresh < tcp_space(sk) &&
> -	    !tcp_memory_pressure) {
> +	    !sk_memory_pressure(sk)) {

Don't you need to check !*sk_memory_pressure(sk) ?



>  		int incr;
>  
>  		/* Check #2. Increase window, if skb with such overhead
> @@ -411,8 +411,8 @@ static void tcp_clamp_window(struct sock *sk)
>  
>  	if (sk->sk_rcvbuf < sysctl_tcp_rmem[2] &&
>  	    !(sk->sk_userlocks & SOCK_RCVBUF_LOCK) &&
> -	    !tcp_memory_pressure &&
> -	    atomic_long_read(&tcp_memory_allocated) < sysctl_tcp_mem[0]) {
> +	    !sk_memory_pressure(sk) &&
> +	    sk_memory_allocated(sk) < sk_prot_mem(sk, 0)) {
>  		sk->sk_rcvbuf = min(atomic_read(&sk->sk_rmem_alloc),
>  				    sysctl_tcp_rmem[2]);
>  	}
> @@ -4864,7 +4864,7 @@ static int tcp_prune_queue(struct sock *sk)
>  
>  	if (atomic_read(&sk->sk_rmem_alloc) >= sk->sk_rcvbuf)
>  		tcp_clamp_window(sk);
> -	else if (tcp_memory_pressure)
> +	else if (sk_memory_pressure(sk))
>  		tp->rcv_ssthresh = min(tp->rcv_ssthresh, 4U * tp->advmss);

Ditto.


>  
>  	tcp_collapse_ofo_queue(sk);
> @@ -4930,11 +4930,11 @@ static int tcp_should_expand_sndbuf(const struct sock *sk)
>  		return 0;
>  
>  	/* If we are under global TCP memory pressure, do not expand.  */
> -	if (tcp_memory_pressure)
> +	if (sk_memory_pressure(sk))
>  		return 0;

again.

Thanks,
-Kame

