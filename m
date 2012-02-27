Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755271Ab2B0XR0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 18:17:26 -0500
Received: from mail1.windriver.com ([147.11.146.13]:58227 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754078Ab2B0XRZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 18:17:25 -0500
Message-ID: <4F4C0EF8.8010405@windriver.com>
Date: Mon, 27 Feb 2012 17:17:12 -0600
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111124 Thunderbird/8.0
MIME-Version: 1.0
To: Andrei Warkentin <andrey.warkentin@gmail.com>
CC: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Andrei Warkentin <andreiw@vmware.com>,
        <kgdb-bugreport@lists.sourceforge.net>, Matt Mackall <mpm@selenic.com>
Subject: Re: [PATCHv3 1/3] NETPOLL: Extend rx_hook support.
References: <1330137851-4716-1-git-send-email-andrey.warkentin@gmail.com> <1330313411-845-1-git-send-email-andrey.warkentin@gmail.com> <1330313411-845-2-git-send-email-andrey.warkentin@gmail.com>
In-Reply-To: <1330313411-845-2-git-send-email-andrey.warkentin@gmail.com>
X-Enigmail-Version: 1.3.4
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/26/2012 09:30 PM, Andrei Warkentin wrote:
> From: Andrei Warkentin <andreiw@vmware.com>
> 
> Pass down source information to rx_hook, useful
> for accepting connections from unspecified clients.
> 
> Cc: kgdb-bugreport@lists.sourceforge.net
> Cc: Jason Wessel <jason.wessel@windriver.com>
> Cc: Matt Mackall <mpm@selenic.com>
> Signed-off-by: Andrei Warkentin <andrey.warkentin@gmail.com>
> Signed-off-by: Andrei Warkentin <andreiw@vmware.com>
> ---
>  include/linux/netpoll.h |   10 +++++++++-
>  net/core/netpoll.c      |   10 ++++------
>  2 files changed, 13 insertions(+), 7 deletions(-)
> 
> diff --git a/include/linux/netpoll.h b/include/linux/netpoll.h
> index 5dfa091..9a9cfa1 100644
> --- a/include/linux/netpoll.h
> +++ b/include/linux/netpoll.h
> @@ -11,12 +11,19 @@
>  #include <linux/interrupt.h>
>  #include <linux/rcupdate.h>
>  #include <linux/list.h>
> +#include <linux/if_ether.h>
> +#include <net/tcp.h>
> +#include <net/udp.h>
>  
>  struct netpoll {
>  	struct net_device *dev;
>  	char dev_name[IFNAMSIZ];
>  	const char *name;
> -	void (*rx_hook)(struct netpoll *, int, char *, int);
> +	void (*rx_hook)(struct netpoll *,
> +			u8 *h_source,
> +			__be32 saddr,
> +			struct udphdr *,
> +			char *, int);


I am just now starting to look how this patch set compares to kgdboe.  For the kgdboe the patch is a bit different.  The kgdboe opted to just pass the skb so as to cut down on the number of arguments to the function call.

>From the kgdboe patch:

-       void (*rx_hook)(struct netpoll *, int, char *, int);
+       void (*rx_hook)(struct netpoll *, int, char *, int, struct sk_buff *);


>  
>  	__be32 local_ip, remote_ip;
>  	u16 local_port, remote_port;
> @@ -40,6 +47,7 @@ struct netpoll_info {
>  	struct netpoll *netpoll;
>  };
>  
> +void netpoll_poll_dev(struct net_device *dev);
>  void netpoll_send_udp(struct netpoll *np, const char *msg, int len);
>  void netpoll_print_options(struct netpoll *np);
>  int netpoll_parse_options(struct netpoll *np, char *opt);
> diff --git a/net/core/netpoll.c b/net/core/netpoll.c
> index 3d84fb9..c182bb2 100644
> --- a/net/core/netpoll.c
> +++ b/net/core/netpoll.c
> @@ -26,8 +26,6 @@
>  #include <linux/workqueue.h>
>  #include <linux/slab.h>
>  #include <linux/export.h>
> -#include <net/tcp.h>
> -#include <net/udp.h>
>  #include <asm/unaligned.h>
>  #include <trace/events/napi.h>
>  
> @@ -189,7 +187,7 @@ static void service_arp_queue(struct netpoll_info *npi)
>  	}
>  }
>  
> -static void netpoll_poll_dev(struct net_device *dev)
> +void netpoll_poll_dev(struct net_device *dev)


This is interesting and I will have to look into this further...  A large part of the reason kgdboe never went anywhere was all around the locking problems the ability to safely use the network hardware and restore the state when it was done.  It appears you made this change so as to make a lockless call directly instead of going through netpoll_poll().  I am not entirely sure you could safely do this.

In kgdboe we always had:

+static int eth_get_char(void)
+{
+	int chr;
+
+	while (atomic_read(&in_count) == 0)
+		netpoll_poll(&np);


If it is the case that you really can safely call the netpoll_poll_dev() without the locks then the horrible sync irq state etc... could go away in kgdboe, and then it would be worth considering digging up all the ethernet polling errata fixes that live of out the mainline and perhaps submit some for review.

Jason.
