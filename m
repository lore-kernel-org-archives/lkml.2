Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934361Ab1JEOJa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 10:09:30 -0400
Received: from smtp-out.google.com ([216.239.44.51]:40497 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751351Ab1JEOJ3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 10:09:29 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:date:
	message-id:subject:from:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=eW4em6EwX1Ecd05EA7zuQ6dRKSXJ2CVU9egmPY1vNTPaHdxQ2OGgIiEzzzYtWS2g6
	WzXgNy/rLk2+3htGTiDSQ==
MIME-Version: 1.0
In-Reply-To: <1317807270.2473.35.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
References: <1317324162-21621-1-git-send-email-muralira@google.com>
	<20110929.153259.169108824599752228.davem@davemloft.net>
	<CAP3iWTTYk7tErsCVdeytdpiu0fo-7B8cNZZk0EpR_rj-VOGi-g@mail.gmail.com>
	<1317807270.2473.35.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Date: Wed, 5 Oct 2011 07:09:24 -0700
Message-ID: <CAP3iWTSsY0a5p_NEq_xnpgT3y5Qg2PXsG1RdvcSxcXWiGwYM0Q@mail.gmail.com>
Subject: Re: [PATCH] net-proc: expose the tos values in /proc/net/[tcp|udp]
From: MuraliRaja Muniraju <muralira@google.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: David Miller <davem@davemloft.net>, kuznet@ms2.inr.ac.ru,
        jmorris@namei.org, yoshfuji@linux-ipv6.org, kaber@trash.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Eric,
     I am trying one more approach of adding a new attribute to the
inet_diag extension to expose the tos values. Hence with this approach
tcp tos problem would be solved. When  udp would also be supported via
netlink and will be using inet_diag, it would be just be publishing
the tos values in the new extension added. Can you let me know your
thoughts on the following patch.

--- a/include/linux/inet_diag.h
+++ b/include/linux/inet_diag.h
@@ -97,9 +97,10 @@ enum {
        INET_DIAG_INFO,
        INET_DIAG_VEGASINFO,
        INET_DIAG_CONG,
+       INET_DIAG_TOS,
 };

-#define INET_DIAG_MAX INET_DIAG_CONG
+#define INET_DIAG_MAX INET_DIAG_TOS


 /* INET_DIAG_MEM */
@@ -120,6 +121,13 @@ struct tcpvegas_info {
        __u32   tcpv_minrtt;
 };

+/* INET_DIAG_TOS */
+
+struct inet_diag_tos {
+       __u8    idiag_tos;
+       __u8    idiag_reserved[3];
+};
+
 #ifdef __KERNEL__
 struct sock;
 struct inet_hashinfo;
diff --git a/net/ipv4/inet_diag.c b/net/ipv4/inet_diag.c
index e5fa2dd..abdd606 100644
--- a/net/ipv4/inet_diag.c
+++ b/net/ipv4/inet_diag.c
@@ -82,6 +82,7 @@ static int inet_csk_diag_fill(struct sock *sk,
        struct nlmsghdr  *nlh;
        void *info = NULL;
        struct inet_diag_meminfo  *minfo = NULL;
+       struct inet_diag_tos *tos = NULL;
        unsigned char    *b = skb_tail_pointer(skb);
        const struct inet_diag_handler *handler;

@@ -108,6 +109,9 @@ static int inet_csk_diag_fill(struct sock *sk,
                       icsk->icsk_ca_ops->name);
        }

+       if (ext & (1 << (INET_DIAG_TOS - 1)))
+               tos = INET_DIAG_PUT(skb, INET_DIAG_TOS, sizeof(*tos));
+
        r->idiag_family = sk->sk_family;
        r->idiag_state = sk->sk_state;
        r->idiag_timer = 0;
@@ -169,6 +173,9 @@ static int inet_csk_diag_fill(struct sock *sk,
            icsk->icsk_ca_ops && icsk->icsk_ca_ops->get_info)
                icsk->icsk_ca_ops->get_info(sk, ext, skb);

+       if (tos)
+               tos->idiag_tos = inet->tos;
+
        nlh->nlmsg_len = skb_tail_pointer(skb) - b;
        return skb->len;


Thanks,
Murali

On Wed, Oct 5, 2011 at 2:34 AM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
> Le mardi 04 octobre 2011 à 10:38 -0700, MuraliRaja Muniraju a écrit :
>> I shall make the changes by exposing the tos values via the
>> netlink as suggested. I had a doubt is I have to modify the
>> inet_diag_sockid or export it via a new option. I am considering
>> that adding into inet_diag_sockid is better because the latter is a
>> bit of a over kill for a single value to be exposed and it also seems
>> to be logical fit.
>> Can you let me know your thoughts on this.
>
> I believe you could add one "u32 tos" to struct tcp_info
>
> [ It wont solve the UDP case, since "ss -u" still dumps /proc/net/udp
> and /proc/net/udp6 ]
>
> Following patch should handle tcp/dccp ipv4/ipv6
>
> diff --git a/include/linux/tcp.h b/include/linux/tcp.h
> index 7f59ee9..eec6f3b 100644
> --- a/include/linux/tcp.h
> +++ b/include/linux/tcp.h
> @@ -167,6 +167,7 @@ struct tcp_info {
>        __u32   tcpi_rcv_space;
>
>        __u32   tcpi_total_retrans;
> +       __u32   tos;
>  };
>
>  /* for TCP_MD5SIG socket option */
> diff --git a/net/dccp/diag.c b/net/dccp/diag.c
> index b21f261..70d9498 100644
> --- a/net/dccp/diag.c
> +++ b/net/dccp/diag.c
> @@ -37,6 +37,7 @@ static void dccp_get_info(struct sock *sk, struct tcp_info *info)
>
>        if (dp->dccps_hc_tx_ccid != NULL)
>                ccid_hc_tx_get_info(dp->dccps_hc_tx_ccid, sk, info);
> +       info->tos = inet_sk(sk)->tos;
>  }
>
>  static void dccp_diag_get_info(struct sock *sk, struct inet_diag_msg *r,
> diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
> index 4c0da24..b24c3d8 100644
> --- a/net/ipv4/tcp.c
> +++ b/net/ipv4/tcp.c
> @@ -2493,6 +2493,7 @@ void tcp_get_info(struct sock *sk, struct tcp_info *info)
>        info->tcpi_rcv_space = tp->rcvq_space.space;
>
>        info->tcpi_total_retrans = tp->total_retrans;
> +       info->tos = inet_sk(sk)->tos;
>  }
>  EXPORT_SYMBOL_GPL(tcp_get_info);
>
>
>
>



-- 
Thanks,
Murali
