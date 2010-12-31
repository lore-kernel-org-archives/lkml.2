Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752618Ab0LaKAh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Dec 2010 05:00:37 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:39804 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750894Ab0LaKAg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Dec 2010 05:00:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=h9UIkoHKBBc9TagVyRe/PgYzv9yvbRkgz4KjNHtSjVnrdxYovhVG6rbYVc7NebfwBA
         JyqR7q0shLhCry0Z/iD0hplDb1MmTU+XgLeJStz05Oj0pD4AG3z5IGOkrfQtGIUNUVNM
         WgtB+8IjZhjLzMzJhbCzUI7t76rAdFhuNydWw=
Subject: Re: [PATCH] UDPCP Communication Protocol
From: Eric Dumazet <eric.dumazet@gmail.com>
To: stefani@seibold.net
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        davem@davemloft.net, netdev@vger.kernel.org
In-Reply-To: <1293787785-3834-1-git-send-email-stefani@seibold.net>
References: <1293787785-3834-1-git-send-email-stefani@seibold.net>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 31 Dec 2010 11:00:29 +0100
Message-ID: <1293789629.2973.26.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le vendredi 31 décembre 2010 à 10:29 +0100, stefani@seibold.net a
écrit :
> From: Stefani Seibold <stefani@seibold.net>
> 
> UDPCP is a communication protocol specified by the Open Base Station
> Architecture Initiative Special Interest Group (OBSAI SIG). The
> protocol is based on UDP and is designed to meet the needs of "Mobile
> Communcation Base Station" internal communications. It is widely used by
> the major networks infrastructure supplier.
> 
> The UDPCP communication service supports the following features:
> 
> -Connectionless communication for serial mode data transfer
> -Acknowledged and unacknowledged transfer modes
> -Retransmissions Algorithm
> -Checksum Algorithm using Adler32
> -Fragmentation of long messages (disassembly/reassembly) to match to the MTU
>  during transport:
> -Broadcasting and multicasting messages to multiple peers in unacknowledged
>  transfer mode
> 
> UDPCP supports application level messages up to 64 KBytes (limited by 16-bit
> packet data length field). Messages that are longer than the MTU will be
> fragmented to the MTU.
> 
> UDPCP provides a reliable transport service that will perform message
> retransmissions in case transport failures occur.
> 
> The code is also a nice example how to implement a UDP based protocol as
> a kernel socket modules.
> 
> Due the nature of UDPCP which has no sliding windows support, the latency has a
> huge impact. The perfomance increase by implementing as a kernel module is
> about the factor 10, because there are no context switches and data packets or
> ACKs will be handled in the interrupt service.
> 
> There are no side effects to the network subsystems so i ask for merge it
> into linux-next. Hope you like it.
> 
> Wish a happy new year. Keep on hacking.
> 
> - Stefani
> 
> Signed-off-by: Stefani Seibold <stefani@seibold.net>
> ---
>  include/linux/socket.h |    5 +-
>  include/net/udpcp.h    |   47 +
>  net/Kconfig            |    1 +
>  net/Makefile           |    1 +
>  net/ipv4/ip_output.c   |    2 +
>  net/ipv4/ip_sockglue.c |    2 +
>  net/ipv4/udp.c         |    2 +-
>  net/udpcp/Kconfig      |   34 +
>  net/udpcp/Makefile     |    5 +
>  net/udpcp/udpcp.c      | 2883 ++++++++++++++++++++++++++++++++++++++++++++++++
>  10 files changed, 2980 insertions(+), 2 deletions(-)
>  create mode 100644 include/net/udpcp.h
>  create mode 100644 net/udpcp/Kconfig
>  create mode 100644 net/udpcp/Makefile
>  create mode 100644 net/udpcp/udpcp.c
> 
> diff --git a/include/linux/socket.h b/include/linux/socket.h
> index 86b652f..624c5ed 100644
> --- a/include/linux/socket.h
> +++ b/include/linux/socket.h
> @@ -193,7 +193,8 @@ struct ucred {
>  #define AF_PHONET	35	/* Phonet sockets		*/
>  #define AF_IEEE802154	36	/* IEEE802154 sockets		*/
>  #define AF_CAIF		37	/* CAIF sockets			*/
> -#define AF_MAX		38	/* For now.. */
> +#define	AF_UDPCP	38	/* UDPCP sockets		*/
> +#define AF_MAX		39	/* For now.. */
>  
>  /* Protocol families, same as address families. */
>  #define PF_UNSPEC	AF_UNSPEC
> @@ -234,6 +235,7 @@ struct ucred {
>  #define PF_PHONET	AF_PHONET
>  #define PF_IEEE802154	AF_IEEE802154
>  #define PF_CAIF		AF_CAIF
> +#define	PF_UDPCP	AF_UDPCP
>  #define PF_MAX		AF_MAX
>  
>  /* Maximum queue length specifiable by listen.  */
> @@ -307,6 +309,7 @@ struct ucred {
>  #define SOL_RDS		276
>  #define SOL_IUCV	277
>  #define SOL_CAIF	278
> +#define SOL_UDPCP	279
>  
>  /* IPX options */
>  #define IPX_TYPE	1
> diff --git a/include/net/udpcp.h b/include/net/udpcp.h
> new file mode 100644
> index 0000000..ba199b9
> --- /dev/null
> +++ b/include/net/udpcp.h
> @@ -0,0 +1,47 @@
> +/* Definitions for UDPCP sockets. */
> +
> +#ifndef __LINUX_IF_UDPCP
> +#define __LINUX_IF_UDPCP
> +
> +#include "linux/ioctl.h"
> +
> +#define UDPCP_MAX_MSGSIZE	65487
> +
> +#define	UDPCP_MAX_WAIT_SEC	60
> +
> +#define UDPCP_OPT_TRANSFER_MODE		0
> +#define UDPCP_OPT_CHECKSUM_MODE		1
> +#define UDPCP_OPT_TX_TIMEOUT		2
> +#define UDPCP_OPT_RX_TIMEOUT		3
> +#define UDPCP_OPT_MAXTRY		4
> +#define	UDPCP_OPT_OUTSTANDING_ACKS	5
> +
> +#define	UDPCP_NOACK		0
> +#define	UDPCP_ACK		1
> +#define	UDPCP_SINGLE_ACK	2
> +#define	UDPCP_NOCHECKSUM	3
> +#define	UDPCP_CHECKSUM		4
> +
> +#define UDPCP_IOC_MAGIC  251
> +
> +#define UDPCP_IOCTL_GET_STATISTICS \
> +	_IOR(UDPCP_IOC_MAGIC, 0x01, struct udpcp_statistics *)
> +#define UDPCP_IOCTL_RESET_STATISTICS \
> +	_IO(UDPCP_IOC_MAGIC, 0x02)
> +#define UDPCP_IOCTL_SYNC \
> +	_IOR(UDPCP_IOC_MAGIC, 0x03, unsigned long)
> +
> +struct udpcp_statistics {
> +	unsigned int txMsgs;		/* Num of transmitted messages */
> +	unsigned int rxMsgs;		/* Num of received messages */
> +	unsigned int txNodes;		/* Num of receiver nodes */
> +	unsigned int rxNodes;		/* Num of transmitter nodes */
> +	unsigned int txTimeout;		/* Num of unsuccessful transmissions */
> +	unsigned int rxTimeout;		/* Num of partial message receptions */
> +	unsigned int txRetries;		/* Num of resends */
> +	unsigned int rxDiscardedFrags;	/* Num of discarded fragments */
> +	unsigned int crcErrors;		/* Num of crc errors detected */
> +};
> +
> +#endif
> +
> diff --git a/net/Kconfig b/net/Kconfig
> index 55fd82e..4a206fc 100644
> --- a/net/Kconfig
> +++ b/net/Kconfig
> @@ -294,6 +294,7 @@ source "net/rfkill/Kconfig"
>  source "net/9p/Kconfig"
>  source "net/caif/Kconfig"
>  source "net/ceph/Kconfig"
> +source "net/udpcp/Kconfig"
>  
> 
>  endif   # if NET
> diff --git a/net/Makefile b/net/Makefile
> index 6b7bfd7..a17ae27 100644
> --- a/net/Makefile
> +++ b/net/Makefile
> @@ -69,3 +69,4 @@ endif
>  obj-$(CONFIG_WIMAX)		+= wimax/
>  obj-$(CONFIG_DNS_RESOLVER)	+= dns_resolver/
>  obj-$(CONFIG_CEPH_LIB)		+= ceph/
> +obj-$(CONFIG_UDPCP)		+= udpcp/
> diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
> index 439d2a3..55b2d0c 100644
> --- a/net/ipv4/ip_output.c
> +++ b/net/ipv4/ip_output.c
> @@ -1085,6 +1085,7 @@ error:
>  	IP_INC_STATS(sock_net(sk), IPSTATS_MIB_OUTDISCARDS);
>  	return err;
>  }
> +EXPORT_SYMBOL(ip_append_data);
>  
>  ssize_t	ip_append_page(struct sock *sk, struct page *page,
>  		       int offset, size_t size, int flags)
> @@ -1341,6 +1342,7 @@ error:
>  	IP_INC_STATS(net, IPSTATS_MIB_OUTDISCARDS);
>  	goto out;
>  }
> +EXPORT_SYMBOL(ip_push_pending_frames);
>  
>  /*
>   *	Throw away all pending data on the socket.
> diff --git a/net/ipv4/ip_sockglue.c b/net/ipv4/ip_sockglue.c
> index 3948c86..310369c 100644
> --- a/net/ipv4/ip_sockglue.c
> +++ b/net/ipv4/ip_sockglue.c
> @@ -226,6 +226,7 @@ int ip_cmsg_send(struct net *net, struct msghdr *msg, struct ipcm_cookie *ipc)
>  	}
>  	return 0;
>  }
> +EXPORT_SYMBOL(ip_cmsg_send);
>  
> 
>  /* Special input handler for packets caught by router alert option.
> @@ -369,6 +370,7 @@ void ip_local_error(struct sock *sk, int err, __be32 daddr, __be16 port, u32 inf
>  	if (sock_queue_err_skb(sk, skb))
>  		kfree_skb(skb);
>  }
> +EXPORT_SYMBOL(ip_local_error);
>  
>  /*
>   *	Handle MSG_ERRQUEUE
> diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
> index 2d3ded4..f9890a2 100644
> --- a/net/ipv4/udp.c
> +++ b/net/ipv4/udp.c
> @@ -1310,7 +1310,7 @@ static int __udp_queue_rcv_skb(struct sock *sk, struct sk_buff *skb)
>  	if (inet_sk(sk)->inet_daddr)
>  		sock_rps_save_rxhash(sk, skb->rxhash);
>  
> -	rc = ip_queue_rcv_skb(sk, skb);
> +	rc = sock_queue_rcv_skb(sk, skb);

Ouch... Care to explain why you changed this part ???

You just destroyed commit f84af32cbca70a intent, without any word in
your changelog. Making UDP slower, while others try to speed it must be
explained and advertised.
 
In general, we prefer a preliminary patch introducing all the changes in
current stack, then another one with the new protocol.



