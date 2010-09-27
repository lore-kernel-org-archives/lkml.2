Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759392Ab0I0Nlw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 09:41:52 -0400
Received: from mail.solarflare.com ([216.237.3.220]:27427 "EHLO
	exchange.solarflare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759373Ab0I0Nlv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 09:41:51 -0400
Subject: Re: [PATCH v11 02/17] Add a new struct for device to manipulate
 external buffer.
From: Ben Hutchings <bhutchings@solarflare.com>
To: xiaohui.xin@intel.com
Cc: netdev@vger.kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        mingo@elte.hu, davem@davemloft.net, herbert@gondor.hengli.com.au,
        jdike@linux.intel.com
In-Reply-To: <c6751a0126ef4d3d1ce75e596ccf9cebd9757052.1285385607.git.xiaohui.xin@intel.com>
References: <1285388855-27410-1-git-send-email-xiaohui.xin@intel.com>
	 <c6751a0126ef4d3d1ce75e596ccf9cebd9757052.1285385607.git.xiaohui.xin@intel.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Solarflare Communications
Date: Mon, 27 Sep 2010 14:41:47 +0100
Message-ID: <1285594907.2263.3.camel@achroite.uk.solarflarecom.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 (2.30.2-4.fc13) 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 27 Sep 2010 13:41:50.0765 (UTC) FILETIME=[BD0E5DD0:01CB5E49]
X-TM-AS-Product-Ver: SMEX-8.0.0.1181-6.500.1024-17668.005
X-TM-AS-Result: No--26.400900-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-09-25 at 12:27 +0800, xiaohui.xin@intel.com wrote:
> From: Xin Xiaohui <xiaohui.xin@intel.com>
> 
> Signed-off-by: Xin Xiaohui <xiaohui.xin@intel.com>
> Signed-off-by: Zhao Yu <yzhao81new@gmail.com>
> Reviewed-by: Jeff Dike <jdike@linux.intel.com>
> ---
>  include/linux/netdevice.h |   22 +++++++++++++++++++++-
>  1 files changed, 21 insertions(+), 1 deletions(-)
> 
> diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> index fa8b476..ba582e1 100644
> --- a/include/linux/netdevice.h
> +++ b/include/linux/netdevice.h
> @@ -530,6 +530,25 @@ struct netdev_queue {
>  	unsigned long		tx_dropped;
>  } ____cacheline_aligned_in_smp;
>  
> +/* Add a structure in structure net_device, the new field is
> + * named as mp_port. It's for mediate passthru (zero-copy).

That belongs in the commit message.

> + * It contains the capability for the net device driver,
> + * a socket, and an external buffer creator, external means
> + * skb buffer belongs to the device may not be allocated from
> + * kernel space.

Who sets which fields in this structure?  Can you make this a kernel-doc
comment specifying the use of each field?

Ben.

> + */
> +struct mpassthru_port	{
> +	int		hdr_len;
> +	int		data_len;
> +	int		npages;
> +	unsigned	flags;
> +	struct socket	*sock;
> +	int		vnet_hlen;
> +	struct skb_ext_page *(*ctor)(struct mpassthru_port *,
> +				struct sk_buff *, int);
> +	struct skb_ext_page *(*hash)(struct net_device *,
> +				struct page *);
> +};
>  
>  /*
>   * This structure defines the management hooks for network devices.
> @@ -952,7 +971,8 @@ struct net_device {
>  	struct macvlan_port	*macvlan_port;
>  	/* GARP */
>  	struct garp_port	*garp_port;
> -
> +	/* mpassthru */
> +	struct mpassthru_port	*mp_port;
>  	/* class/net/name entry */
>  	struct device		dev;
>  	/* space for optional device, statistics, and wireless sysfs groups */

-- 
Ben Hutchings, Senior Software Engineer, Solarflare Communications
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

