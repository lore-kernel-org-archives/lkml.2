Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759547Ab2DJWDw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 18:03:52 -0400
Received: from nm18-vm0.access.bullet.mail.mud.yahoo.com ([66.94.236.23]:26854
	"HELO nm18-vm0.access.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755709Ab2DJWDu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 18:03:50 -0400
X-Yahoo-Newman-Id: 888803.14055.bm@smtp106.biz.mail.ne1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: TvdhZ34VM1mS0SYmU1A0JVcBlK3bmRoRXmqpiZpgW7GMWMw
 nGejDqzpFzUzhW7aBxmJEDXDdQ.y2vZv.kci6bqjHtnxIWic.m4EaploeqKP
 TcopwkIugA27DMsTZzPAp5kxmSVaN.k93q5L3QRLhEiim_V55HkcxWwNOoJ6
 XQRnSBE.g5ZbynXPzs14YFTZ6EIxk.bJwuw3JfzKM7QbdDtBEBLT8Wc0jy1c
 rQm2.iju.wdIPywnzCLL1EXj7Owufl.m2QOhmajZRrFSoxiZN6wxwXG1hIDV
 cIjMxbf9kmWlEde72LbyhLGL3q4gas9LJGFhBy5YVOHT7KyIvhX_TUzS0nQu
 rl1X7YKMc1IkaBVo2paFE9F6Qf6OrfaGEyPd771ggvlxlt5vDtpgCGTk.ayY
 m3MAbnmt22SfYo_lNvk3F3q2RaCmiipx.T6xFwQpBHI5_W5iXDI453PoRzb0
 PvjZghPdEtpdgbS0P6kfbn4xZx34XsorW.0MGmVNluLZPDUYGDWUbdpkJHUp
 xhy8MjlzESExgjw--
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
Message-ID: <4F84AE44.1020505@schaufler-ca.com>
Date: Tue, 10 Apr 2012 15:03:48 -0700
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
MIME-Version: 1.0
To: Kees Cook <keescook@chromium.org>
CC: linux-kernel@vger.kernel.org, James Morris <james.l.morris@oracle.com>,
        Eric Paris <eparis@redhat.com>, Paul Moore <paul.moore@hp.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Andi Kleen <ak@linux.intel.com>,
        linux-security-module@vger.kernel.org,
        Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: [PATCH] Smack: build when CONFIG_AUDIT not defined
References: <20120410202644.GA10466@www.outflux.net>
In-Reply-To: <20120410202644.GA10466@www.outflux.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/10/2012 1:26 PM, Kees Cook wrote:
> This fixes builds where CONFIG_AUDIT is not defined and
> CONFIG_SECURITY_SMACK=y.

This problem looks to have been introduced as part of
the "common_audit_data cleanup" from Eric Paris, or of
the integration of those changes from commit
a5149bf3fed59b94207809704b5d06fec337a771
This should probably be "[PATCH] Audit:" rather than
"[PATCH] Smack". I am not planning anything from
smack-next for 3.4.

>
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
>  security/smack/smack_lsm.c |   19 +++++++++++++++----
>  1 files changed, 15 insertions(+), 4 deletions(-)
>
> diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
> index 81c03a5..10056f2 100644
> --- a/security/smack/smack_lsm.c
> +++ b/security/smack/smack_lsm.c
> @@ -1939,18 +1939,19 @@ static int smack_netlabel_send(struct sock *sk, struct sockaddr_in *sap)
>  	char *hostsp;
>  	struct socket_smack *ssp = sk->sk_security;
>  	struct smk_audit_info ad;
> -	struct lsm_network_audit net;
>  
>  	rcu_read_lock();
>  	hostsp = smack_host_label(sap);
>  	if (hostsp != NULL) {
> -		sk_lbl = SMACK_UNLABELED_SOCKET;
>  #ifdef CONFIG_AUDIT
> +		struct lsm_network_audit net;
> +
>  		smk_ad_init_net(&ad, __func__, LSM_AUDIT_DATA_NET, &net);
>  		ad.a.u.net->family = sap->sin_family;
>  		ad.a.u.net->dport = sap->sin_port;
>  		ad.a.u.net->v4info.daddr = sap->sin_addr.s_addr;
>  #endif
> +		sk_lbl = SMACK_UNLABELED_SOCKET;
>  		rc = smk_access(ssp->smk_out, hostsp, MAY_WRITE, &ad);
>  	} else {
>  		sk_lbl = SMACK_CIPSO_SOCKET;
> @@ -2809,11 +2810,14 @@ static int smack_unix_stream_connect(struct sock *sock,
>  	struct socket_smack *osp = other->sk_security;
>  	struct socket_smack *nsp = newsk->sk_security;
>  	struct smk_audit_info ad;
> -	struct lsm_network_audit net;
>  	int rc = 0;
>  
> +#ifdef CONFIG_AUDIT
> +	struct lsm_network_audit net;
> +
>  	smk_ad_init_net(&ad, __func__, LSM_AUDIT_DATA_NET, &net);
>  	smk_ad_setfield_u_net_sk(&ad, other);
> +#endif
>  
>  	if (!capable(CAP_MAC_OVERRIDE))
>  		rc = smk_access(ssp->smk_out, osp->smk_in, MAY_WRITE, &ad);
> @@ -2842,11 +2846,14 @@ static int smack_unix_may_send(struct socket *sock, struct socket *other)
>  	struct socket_smack *ssp = sock->sk->sk_security;
>  	struct socket_smack *osp = other->sk->sk_security;
>  	struct smk_audit_info ad;
> -	struct lsm_network_audit net;
>  	int rc = 0;
>  
> +#ifdef CONFIG_AUDIT
> +	struct lsm_network_audit net;
> +
>  	smk_ad_init_net(&ad, __func__, LSM_AUDIT_DATA_NET, &net);
>  	smk_ad_setfield_u_net_sk(&ad, other->sk);
> +#endif
>  
>  	if (!capable(CAP_MAC_OVERRIDE))
>  		rc = smk_access(ssp->smk_out, osp->smk_in, MAY_WRITE, &ad);
> @@ -2993,7 +3000,9 @@ static int smack_socket_sock_rcv_skb(struct sock *sk, struct sk_buff *skb)
>  	char *csp;
>  	int rc;
>  	struct smk_audit_info ad;
> +#ifdef CONFIG_AUDIT
>  	struct lsm_network_audit net;
> +#endif
>  	if (sk->sk_family != PF_INET && sk->sk_family != PF_INET6)
>  		return 0;
>  
> @@ -3156,7 +3165,9 @@ static int smack_inet_conn_request(struct sock *sk, struct sk_buff *skb,
>  	char *sp;
>  	int rc;
>  	struct smk_audit_info ad;
> +#ifdef CONFIG_AUDIT
>  	struct lsm_network_audit net;
> +#endif
>  
>  	/* handle mapped IPv4 packets arriving via IPv6 sockets */
>  	if (family == PF_INET6 && skb->protocol == htons(ETH_P_IP))

