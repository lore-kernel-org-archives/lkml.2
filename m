Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755128Ab1AKAtb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 19:49:31 -0500
Received: from alternativer.internetendpunkt.de ([88.198.24.89]:44277 "EHLO
	geheimer.internetendpunkt.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752391Ab1AKAt2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 19:49:28 -0500
Date: Tue, 11 Jan 2011 01:49:26 +0100
From: Hagen Paul Pfeifer <hagen@jauu.net>
To: stefani@seibold.net
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        davem@davemloft.net, netdev@vger.kernel.org
Subject: Re: [PATCH] UDPCP Communication Protocol
Message-ID: <20110111004926.GA1604@nuttenaction>
References: <1293787785-3834-1-git-send-email-stefani@seibold.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1293787785-3834-1-git-send-email-stefani@seibold.net>
X-Key-Id: 98350C22
X-Key-Fingerprint: 490F 557B 6C48 6D7E 5706 2EA2 4A22 8D45 9835 0C22
X-GPG-Key: gpg --recv-keys --keyserver wwwkeys.eu.pgp.net 98350C22
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

find_dest() via new_dest() may return NULL

* stefani@seibold.net | 2010-12-31 10:29:45 [+0100]:

>+static int udpcp_sendmsg(struct kiocb *iocb, struct sock *sk,
>+			 struct msghdr *msg, size_t len)
>+{
>+	struct inet_sock *inet = inet_sk(sk);
>+	struct udpcp_sock *usk = udpcp_sk(sk);
>+	struct ipcm_cookie *ipc;
>+	struct rtable *rt = NULL;
>+	int free = 0;
>+	int connected = 0;
>+	__be32 daddr, faddr, saddr;
>+	__be16 dport;
>+	u8 tos;
>+	int err = 0;
>+	int corkreq = usk->udpsock.corkflag || msg->msg_flags & MSG_MORE;
>+	int (*getfrag) (void *, char *, int, int, int, struct sk_buff *);
>+	struct udpcp_dest *dest;
>+
>+	if (len > UDPCP_MAX_MSGSIZE)
>+		return -EMSGSIZE;
>+
>+	/*
>+	 * Check the flags.
>+	 */
>+	if (msg->msg_flags & MSG_OOB)
>+		return -EOPNOTSUPP;
>+
>+	/*
>+	 * check if socket is binded to a port
>+	 */
>+	if (!(sk->sk_userlocks & SOCK_BINDPORT_LOCK) || !inet->inet_num)
>+		return -ENOTCONN;
>+
>+	/*
>+	 * Get and verify the address.
>+	 */
>+	if (msg->msg_name) {
>+		struct sockaddr_in *usin = (struct sockaddr_in *)msg->msg_name;
>+		if (msg->msg_namelen < sizeof(*usin))
>+			return -EINVAL;
>+		if (usin->sin_family != AF_INET) {
>+			if (usin->sin_family != AF_UNSPEC)
>+				return -EAFNOSUPPORT;
>+		}
>+
>+		daddr = usin->sin_addr.s_addr;
>+		dport = usin->sin_port;
>+	} else {
>+		if (sk->sk_state != TCP_ESTABLISHED)
>+			return -EDESTADDRREQ;
>+		daddr = inet->inet_daddr;
>+		dport = inet->inet_dport;
>+		/* Open fast path for connected socket.
>+		   Route will not be used, if at least one option is set.
>+		 */
>+		connected = 1;
>+	}
>+
>+	if (dport == 0)
>+		return -EINVAL;
>+
>+	dest = find_dest(sk, daddr, dport);
    if (!dest)
			return -ENOBUFS;
