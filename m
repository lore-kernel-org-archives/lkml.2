Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934195Ab1JEJeS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 05:34:18 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:52598 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933583Ab1JEJeR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 05:34:17 -0400
Subject: Re: [PATCH] net-proc: expose the tos values in /proc/net/[tcp|udp]
From: Eric Dumazet <eric.dumazet@gmail.com>
To: MuraliRaja Muniraju <muralira@google.com>
Cc: David Miller <davem@davemloft.net>, kuznet@ms2.inr.ac.ru,
        jmorris@namei.org, yoshfuji@linux-ipv6.org, kaber@trash.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <CAP3iWTTYk7tErsCVdeytdpiu0fo-7B8cNZZk0EpR_rj-VOGi-g@mail.gmail.com>
References: <1317324162-21621-1-git-send-email-muralira@google.com>
	 <20110929.153259.169108824599752228.davem@davemloft.net>
	 <CAP3iWTTYk7tErsCVdeytdpiu0fo-7B8cNZZk0EpR_rj-VOGi-g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 05 Oct 2011 11:34:29 +0200
Message-ID: <1317807270.2473.35.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mardi 04 octobre 2011 à 10:38 -0700, MuraliRaja Muniraju a écrit :
> I shall make the changes by exposing the tos values via the
> netlink as suggested. I had a doubt is I have to modify the
> inet_diag_sockid or export it via a new option. I am considering
> that adding into inet_diag_sockid is better because the latter is a
> bit of a over kill for a single value to be exposed and it also seems
> to be logical fit.
> Can you let me know your thoughts on this.

I believe you could add one "u32 tos" to struct tcp_info

[ It wont solve the UDP case, since "ss -u" still dumps /proc/net/udp
and /proc/net/udp6 ]

Following patch should handle tcp/dccp ipv4/ipv6

diff --git a/include/linux/tcp.h b/include/linux/tcp.h
index 7f59ee9..eec6f3b 100644
--- a/include/linux/tcp.h
+++ b/include/linux/tcp.h
@@ -167,6 +167,7 @@ struct tcp_info {
 	__u32	tcpi_rcv_space;
 
 	__u32	tcpi_total_retrans;
+	__u32	tos;
 };
 
 /* for TCP_MD5SIG socket option */
diff --git a/net/dccp/diag.c b/net/dccp/diag.c
index b21f261..70d9498 100644
--- a/net/dccp/diag.c
+++ b/net/dccp/diag.c
@@ -37,6 +37,7 @@ static void dccp_get_info(struct sock *sk, struct tcp_info *info)
 
 	if (dp->dccps_hc_tx_ccid != NULL)
 		ccid_hc_tx_get_info(dp->dccps_hc_tx_ccid, sk, info);
+	info->tos = inet_sk(sk)->tos;
 }
 
 static void dccp_diag_get_info(struct sock *sk, struct inet_diag_msg *r,
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 4c0da24..b24c3d8 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -2493,6 +2493,7 @@ void tcp_get_info(struct sock *sk, struct tcp_info *info)
 	info->tcpi_rcv_space = tp->rcvq_space.space;
 
 	info->tcpi_total_retrans = tp->total_retrans;
+	info->tos = inet_sk(sk)->tos;
 }
 EXPORT_SYMBOL_GPL(tcp_get_info);
 


