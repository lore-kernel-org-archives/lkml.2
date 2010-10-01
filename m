Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754410Ab0JAD1L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 23:27:11 -0400
Received: from smtp-out.google.com ([74.125.121.35]:41698 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753013Ab0JAD1J convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 23:27:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=KVUgoGTYc4MSzG8n1d5UqOXrI7zWzK4v2Kpg+2Lkt++lNhZwAuUNodRn649VmX7adC
         MXC1nIdcYaP30hMUxaXA==
MIME-Version: 1.0
In-Reply-To: <20101001124830.9c35d36f.sfr@canb.auug.org.au>
References: <20101001124830.9c35d36f.sfr@canb.auug.org.au>
Date: Thu, 30 Sep 2010 20:27:05 -0700
Message-ID: <AANLkTinsNEeTK=SrGpqEjF8VtZZWpiWydgSc+3M854pD@mail.gmail.com>
Subject: Re: linux-next: manual merge of the net tree with the net-current tree
From: Jerry Chu <hkchu@google.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Damian Lukowski <damian@tvk.rwth-aachen.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In tcp_write_timeout():

if (retransmits_timed_out(sk, retry_until,
            (1 << sk->sk_state) & (TCPF_SYN_SENT | TCPF_SYN_RECV) ? 0 :
            icsk->icsk_user_timeout, syn_set)) {

should be simplified to

if (retransmits_timed_out(sk, retry_until,
    syn_set ? 0 : icsk->icsk_user_timeout, syn_set)) {


Thanks,

Jerry

On Thu, Sep 30, 2010 at 7:48 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi all,
>
> Today's linux-next merge of the net tree got a conflict in
> net/ipv4/tcp_timer.c between commit
> 4d22f7d372f5769c6c0149e427ed6353e2dcfe61 ("net-2.6: SYN retransmits: Add
> new parameter to retransmits_timed_out()") from the net-current tree and
> commit dca43c75e7e545694a9dd6288553f55c53e2a3a3 ("tcp: Add
> TCP_USER_TIMEOUT socket option") from the net tree.
>
> I fixed it up (see below) and can carry the fix as necessary.
> --
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
>
> diff --cc net/ipv4/tcp_timer.c
> index 74c54b3,baea4a1..0000000
> --- a/net/ipv4/tcp_timer.c
> +++ b/net/ipv4/tcp_timer.c
> @@@ -140,11 -139,9 +140,11 @@@ static void tcp_mtu_probing(struct inet
>   */
>  static bool retransmits_timed_out(struct sock *sk,
>                                  unsigned int boundary,
>  -                                unsigned int timeout)
> ++                                unsigned int timeout,
>  +                                bool syn_set)
>  {
> -       unsigned int timeout, linear_backoff_thresh;
> -       unsigned int start_ts;
> +       unsigned int linear_backoff_thresh, start_ts;
>  +      unsigned int rto_base = syn_set ? TCP_TIMEOUT_INIT : TCP_RTO_MIN;
>
>        if (!inet_csk(sk)->icsk_retransmits)
>                return false;
> @@@ -154,14 -151,15 +154,16 @@@
>        else
>                start_ts = tcp_sk(sk)->retrans_stamp;
>
> -       linear_backoff_thresh = ilog2(TCP_RTO_MAX/rto_base);
> +       if (likely(timeout == 0)) {
>  -              linear_backoff_thresh = ilog2(TCP_RTO_MAX/TCP_RTO_MIN);
> ++              linear_backoff_thresh = ilog2(TCP_RTO_MAX/rto_base);
>
> -       if (boundary <= linear_backoff_thresh)
> -               timeout = ((2 << boundary) - 1) * rto_base;
> -       else
> -               timeout = ((2 << linear_backoff_thresh) - 1) * rto_base +
> -                         (boundary - linear_backoff_thresh) * TCP_RTO_MAX;
> +               if (boundary <= linear_backoff_thresh)
>  -                      timeout = ((2 << boundary) - 1) * TCP_RTO_MIN;
> ++                      timeout = ((2 << boundary) - 1) * rto_base;
> +               else
>  -                      timeout = ((2 << linear_backoff_thresh) - 1) * TCP_RTO_MIN +
> ++                      timeout = ((2 << linear_backoff_thresh) - 1) * rto_base +
> +                               (boundary - linear_backoff_thresh) * TCP_RTO_MAX;
>  +
> +       }
>        return (tcp_time_stamp - start_ts) >= timeout;
>  }
>
> @@@ -176,9 -174,8 +178,9 @@@ static int tcp_write_timeout(struct soc
>                if (icsk->icsk_retransmits)
>                        dst_negative_advice(sk);
>                retry_until = icsk->icsk_syn_retries ? : sysctl_tcp_syn_retries;
>  +              syn_set = 1;
>        } else {
> --              if (retransmits_timed_out(sk, sysctl_tcp_retries1, 0)) {
> ++              if (retransmits_timed_out(sk, sysctl_tcp_retries1, 0, 0)) {
>                        /* Black hole detection */
>                        tcp_mtu_probing(icsk, sk);
>
> @@@ -191,14 -188,16 +193,16 @@@
>
>                        retry_until = tcp_orphan_retries(sk, alive);
>                        do_reset = alive ||
> --                                 !retransmits_timed_out(sk, retry_until, 0);
> ++                                 !retransmits_timed_out(sk, retry_until, 0, 0);
>
>                        if (tcp_out_of_resources(sk, do_reset))
>                                return 1;
>                }
>        }
>
> -       if (retransmits_timed_out(sk, retry_until, syn_set)) {
> +       if (retransmits_timed_out(sk, retry_until,
> +           (1 << sk->sk_state) & (TCPF_SYN_SENT | TCPF_SYN_RECV) ? 0 :
>  -          icsk->icsk_user_timeout)) {
> ++          icsk->icsk_user_timeout, syn_set)) {
>                /* Has it gone just too far? */
>                tcp_write_err(sk);
>                return 1;
> @@@ -440,7 -439,7 +444,7 @@@ out_reset_timer
>                icsk->icsk_rto = min(icsk->icsk_rto << 1, TCP_RTO_MAX);
>        }
>        inet_csk_reset_xmit_timer(sk, ICSK_TIME_RETRANS, icsk->icsk_rto, TCP_RTO_MAX);
> --      if (retransmits_timed_out(sk, sysctl_tcp_retries1 + 1, 0))
> ++      if (retransmits_timed_out(sk, sysctl_tcp_retries1 + 1, 0, 0))
>                __sk_dst_reset(sk);
>
>  out:;
>
