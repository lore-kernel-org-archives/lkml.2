Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932673Ab1BWUxt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 15:53:49 -0500
Received: from www.tglx.de ([62.245.132.106]:60820 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755801Ab1BWUxs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 15:53:48 -0500
Date: Wed, 23 Feb 2011 21:53:05 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Haiyang Zhang <haiyangz@microsoft.com>
cc: hjanssen@microsoft.com, kys@microsoft.com, v-abkane@microsoft.com,
        gregkh@suse.de, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, virtualization@lists.osdl.org
Subject: Re: [PATCH 2/4] staging: hv: Fix the code depending on struct
 netvsc_driver_context data order
In-Reply-To: <1298492398-16522-2-git-send-email-haiyangz@microsoft.com>
Message-ID: <alpine.LFD.2.00.1102232128100.2701@localhost6.localdomain6>
References: <1298492398-16522-1-git-send-email-haiyangz@microsoft.com> <1298492398-16522-2-git-send-email-haiyangz@microsoft.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Feb 2011, Haiyang Zhang wrote:
> @@ -137,8 +135,8 @@ static int netvsc_start_xmit(struct sk_buff *skb, struct net_device *net)
>  	struct net_device_context *net_device_ctx = netdev_priv(net);
>  	struct driver_context *driver_ctx =
>  	    driver_to_driver_context(net_device_ctx->device_ctx->device.driver);
> -	struct netvsc_driver_context *net_drv_ctx =
> -		(struct netvsc_driver_context *)driver_ctx;
> +	struct netvsc_driver_context *net_drv_ctx = container_of(driver_ctx,
> +		struct netvsc_driver_context, drv_ctx);

While the code is correct, it's still horrible to read.

  	struct net_device_context *dev_ctx = netdev_priv(net);
	struct netvsc_drv_ctx *net_drv_ctx;
  	struct netvsc_driver *net_drv_obj;
  	struct driver_context *drv_ctx;
  	struct hv_netvsc_packet *packet;
  	int ret;

	drv_ctx = driver_to_driver_context(dev_ctx->device_ctx->device.driver);
	net_drv_ctx = container_of(driver_ctx, struct netvsc_drv_ctx, drv_ctx);
	net_drv_obj = &net_drv_ctx->drv_obj;

Line breaking code just to fulfil the 80 chars requirement is a
horrible idea.

I just explained somewhere else, that these line breaks are equaly
inefficient to parse by the human eye as the extra wide lines. Have
you ever seen a newspaper which uses a column width which spawns the
whole size of the paper? Probably not, simply because nobody can read
it fluently and fast.

So just mechanically converting existing code which was written based
on that horrible though popular codingstyle which requires wide screen
monitors is not going to result in readable code.

You need to do more than just inserting random line breaks as you see fit.

	struct netvsc_driver_context *net_drv_ctx = container_of(driver_ctx,
		struct netvsc_driver_context, drv_ctx);

is a total horrible construct.

So
     	struct netvsc_driver_context *net_drv_ctx;

	net_drv_ctx = container_of(driver_ctx, struct netvsc_driver_context,
                                   drv_ctx);

is way better, as you can cleary see, that the extra line belongs to
the arguments of container_of(). Try to decode that in the above
original code w/o looking twice or more.

It's still not perfect but way better to read. So when converting (or
writing new) code think whether your struct names or variable names
need to be that long

     	struct netvsc_driver_context *net_drv_ctx;
vs.
	struct netsvc_drv_ctx *net_drv_ctx;

carries exact the same amount of information, but more condensed and lets

	net_drv_ctx = container_of(driver_ctx, struct netvsc_drv_ctx, drv_ctx);

fit into one line.

So yes, it's more work for you in the first place, but in the end it's
better readable code and you make it way easier for those who are
spending their (quality) time to review it.

Thanks,

	tglx
