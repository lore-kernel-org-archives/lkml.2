Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753259Ab1CERzZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Mar 2011 12:55:25 -0500
Received: from mail.surcouf.co.uk ([212.9.28.201]:33391 "EHLO
	mail.surcouf.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752170Ab1CERzY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Mar 2011 12:55:24 -0500
X-Greylist: delayed 612 seconds by postgrey-1.27 at vger.kernel.org; Sat, 05 Mar 2011 12:55:23 EST
From: Mike Surcouf <mike@surcouf.co.uk>
To: Ian Campbell <Ian.Campbell@eu.citrix.com>, Greg KH <gregkh@suse.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@kernel.org" <stable@kernel.org>,
        "stable-review@kernel.org" <stable-review@kernel.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: RE: [17/18] arp_notify: unconditionally send gratuitous ARP for NETDEV_NOTIFY_PEERS.
Thread-Topic: [17/18] arp_notify: unconditionally send gratuitous ARP for NETDEV_NOTIFY_PEERS.
Thread-Index: AQHL2tFivLbhrkeL3EG28Uqu7gpVQ5QefBCAgACDjKA=
Date: Sat, 5 Mar 2011 17:45:07 +0000
Message-ID: <2197768425D7F5479A0FFB3FEC212F7F1DA257EB@aesmail.surcouf.local>
References: <20110305010353.482533027@clark.kroah.org>,<1299317809.13328.42.camel@localhost.localdomain>
In-Reply-To: <1299317809.13328.42.camel@localhost.localdomain>
Accept-Language: en-GB, en-US
Content-Language: en-GB
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [212.9.31.24]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 05 Mar 2011 17:45:08.0987 (UTC) FILETIME=[11F484B0:01CBDB5D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ian/Greg

I just tested your patch with a custom kernel Greg compiled for me and it works for hyperv too as one would expect.
I can now see that a GARP is sent (using wireshark) and that my switch tables are updating.  

Many thanks for your work on this and Thanks to Greg for his help.

Regards

Mike

________________________________________
From: Ian Campbell [Ian.Campbell@eu.citrix.com]
Sent: 05 March 2011 09:36
To: Greg KH
Cc: linux-kernel@vger.kernel.org; stable@kernel.org; stable-review@kernel.org; torvalds@linux-foundation.org; akpm@linux-foundation.org; alan@lxorguk.ukuu.org.uk; David S. Miller; Haiyang Zhang; Mike Surcouf; Hank Janssen
Subject: Re: [17/18] arp_notify: unconditionally send gratuitous ARP for NETDEV_NOTIFY_PEERS.

On Sat, 2011-03-05 at 01:03 +0000, Greg KH wrote:
> 2.6.32-longterm review patch.  If anyone has any objections, please let us know.
>
> ------------------
>
> From: Ian Campbell <Ian.Campbell@citrix.com>
>
> commit d11327ad6695db8117c78d70611e71102ceec2ac upstream.
>
> NETDEV_NOTIFY_PEER is an explicit request by the driver to send a link
> notification while NETDEV_UP/NETDEV_CHANGEADDR generate link
> notifications as a sort of side effect.
>
> In the later cases the sysctl option is present because link
> notification events can have undesired effects e.g. if the link is
> flapping. I don't think this applies in the case of an explicit
> request from a driver.
>
> This patch makes NETDEV_NOTIFY_PEER unconditional, if preferred we
> could add a new sysctl for this case which defaults to on.
>
> This change causes Xen post-migration ARP notifications (which cause
> switches to relearn their MAC tables etc) to be sent by default.
>
> Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
> Signed-off-by: David S. Miller <davem@davemloft.net>
> [reported to solve hyperv live migration problem - gkh]

I hadn't spotted this second caller of netif_notify_peers under
drivers/staging but, yes, I rather suspect it will help hyperv as well
as Xen given that 7c161d0b900ea9bd9fc5ea5d3fa9916e9eb0dd88 "staging: hv:
Enable sending GARP packet after live migration" is already in the
stable and longterm trees.

Ian.

> Cc: Haiyang Zhang <haiyangz@microsoft.com>
> Cc: Mike Surcouf <mike@surcouf.co.uk>
> Cc: Hank Janssen <hjanssen@microsoft.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
>
> ---
>  net/ipv4/devinet.c |   30 ++++++++++++++++++++----------
>  1 file changed, 20 insertions(+), 10 deletions(-)
>
> --- a/net/ipv4/devinet.c
> +++ b/net/ipv4/devinet.c
> @@ -1025,6 +1025,21 @@ static inline bool inetdev_valid_mtu(uns
>       return mtu >= 68;
>  }
>
> +static void inetdev_send_gratuitous_arp(struct net_device *dev,
> +                                     struct in_device *in_dev)
> +
> +{
> +     struct in_ifaddr *ifa = in_dev->ifa_list;
> +
> +     if (!ifa)
> +             return;
> +
> +     arp_send(ARPOP_REQUEST, ETH_P_ARP,
> +              ifa->ifa_address, dev,
> +              ifa->ifa_address, NULL,
> +              dev->dev_addr, NULL);
> +}
> +
>  /* Called only under RTNL semaphore */
>
>  static int inetdev_event(struct notifier_block *this, unsigned long event,
> @@ -1076,18 +1091,13 @@ static int inetdev_event(struct notifier
>               }
>               ip_mc_up(in_dev);
>               /* fall through */
> -     case NETDEV_NOTIFY_PEERS:
>       case NETDEV_CHANGEADDR:
> +             if (!IN_DEV_ARP_NOTIFY(in_dev))
> +                     break;
> +             /* fall through */
> +     case NETDEV_NOTIFY_PEERS:
>               /* Send gratuitous ARP to notify of link change */
> -             if (IN_DEV_ARP_NOTIFY(in_dev)) {
> -                     struct in_ifaddr *ifa = in_dev->ifa_list;
> -
> -                     if (ifa)
> -                             arp_send(ARPOP_REQUEST, ETH_P_ARP,
> -                                      ifa->ifa_address, dev,
> -                                      ifa->ifa_address, NULL,
> -                                      dev->dev_addr, NULL);
> -             }
> +             inetdev_send_gratuitous_arp(dev, in_dev);
>               break;
>       case NETDEV_DOWN:
>               ip_mc_down(in_dev);
>
>

----------------------------------------------------------------------
A E Surcouf and Sons Ltd. - Privacy, Security and Confidentiality Notice

This e-mail and any attachments may contain confidential and privileged
information. If you have received this e-mail in error please notify us
immediately and delete it from your system. You must not copy, distribute,
disclose or otherwise use any part of it. This email has been scanned
by current virus software, however it is the responsibility of the 
recipient to ensure that this e-mail is virus free and no responsibility
is accepted by A E Surcouf and Sons Ltd. for any loss or damage arising in
any way from receipt or use of it. Unencrypted electronic mail is not 
secure and may not be authentic.
-----------------------------------------------------------------------

 


