Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754334Ab1EJHGu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 03:06:50 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:58731 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754194Ab1EJHGt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 03:06:49 -0400
Date: Tue, 10 May 2011 03:06:46 -0400
From: Christoph Hellwig <hch@infradead.org>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org, Haiyang Zhang <haiyangz@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: Re: [PATCH 115/206] Staging: hv: Use completion abstraction in
 struct netvsc_device
Message-ID: <20110510070646.GB13847@infradead.org>
References: <1304978242-22958-1-git-send-email-kys@microsoft.com>
 <1304978288-22999-1-git-send-email-kys@microsoft.com>
 <1304978288-22999-115-git-send-email-kys@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1304978288-22999-115-git-send-email-kys@microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -	net_device->wait_condition = 0;
>  	ret = vmbus_sendpacket(device->channel, init_packet,
>  			       sizeof(struct nvsp_message),
>  			       (unsigned long)init_packet,
> @@ -272,10 +272,8 @@ static int netvsc_init_recv_buf(struct hv_device *device)
>  		goto cleanup;
>  	}
>  
> -	wait_event_timeout(net_device->channel_init_wait,
> -			net_device->wait_condition,
> -			msecs_to_jiffies(1000));
> -	BUG_ON(net_device->wait_condition == 0);
> +	t = wait_for_completion_timeout(&net_device->channel_init_wait, HZ);
> +	BUG_ON(t == 0);

I don't think you want a BUG_ON here, but rather fail the
initialization.

Also I think you really should add synchronous versions of
vmbus_sendpacket*, to the vmbus core so that all the synchronous waiting
can be consolidated into a few helpers instead of needing to opencode
it everywhere.

