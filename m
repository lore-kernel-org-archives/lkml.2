Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753399Ab2LQPlB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 10:41:01 -0500
Received: from mx1.redhat.com ([209.132.183.28]:57276 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752668Ab2LQPk7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 10:40:59 -0500
Message-ID: <50CF3CFD.9080001@redhat.com>
Date: Mon, 17 Dec 2012 10:40:45 -0500
From: Vlad Yasevich <vyasevic@redhat.com>
Reply-To: vyasevic@redhat.com
Organization: Red Hat
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Simon Arlott <simon@fire.lp0.eu>
CC: David Miller <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH] ipv6: Fix Makefile offload objects
References: <50CDFB36.1020604@simon.arlott.org.uk>
In-Reply-To: <50CDFB36.1020604@simon.arlott.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/16/2012 11:47 AM, Simon Arlott wrote:
> The following commit breaks IPv6 TCP transmission for me:
> 	Commit 75fe83c32248d99e6d5fe64155e519b78bb90481
> 	Author: Vlad Yasevich <vyasevic@redhat.com>
> 	Date:   Fri Nov 16 09:41:21 2012 +0000
> 	ipv6: Preserve ipv6 functionality needed by NET
>
> This patch fixes the typo "ipv6_offload" which should be
> "ipv6-offload".
>
> I don't know why not including the offload modules should
> break TCP. Disabling all offload options on the NIC didn't
> help. Outgoing pulseaudio traffic kept stalling.

Did you restart your application to restart the socket?\

The trouble is that whe GSO is turned on, we try to perform
it on output.  If the output path can't find the gso handler
for the protocol (in your case tcp over IPv6), it drops the
packet.  This causes tcp to retransmit eventually withough GSO.

If you were in a VM, GSO is always used even though you might
disable it on the interface with ethtool.  The only way I've been
able to disable it when using virtio driver is by passing gso=0
parameter to the module.

-vlad

>
> Signed-off-by: Simon Arlott <simon@fire.lp0.eu>
> ---
>   net/ipv6/Makefile |    2 +-
>   1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/net/ipv6/Makefile b/net/ipv6/Makefile
> index 2068ac4..4ea2448 100644
> --- a/net/ipv6/Makefile
> +++ b/net/ipv6/Makefile
> @@ -41,6 +41,6 @@ obj-$(CONFIG_IPV6_TUNNEL) += ip6_tunnel.o
>   obj-$(CONFIG_IPV6_GRE) += ip6_gre.o
>
>   obj-y += addrconf_core.o exthdrs_core.o
> -obj-$(CONFIG_INET) += output_core.o protocol.o $(ipv6_offload)
> +obj-$(CONFIG_INET) += output_core.o protocol.o $(ipv6-offload)
>
>   obj-$(subst m,y,$(CONFIG_IPV6)) += inet6_hashtables.o
>

