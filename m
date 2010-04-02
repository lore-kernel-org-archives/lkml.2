Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752041Ab0DBP4m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Apr 2010 11:56:42 -0400
Received: from mail.vyatta.com ([76.74.103.46]:38997 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751222Ab0DBP4e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Apr 2010 11:56:34 -0400
Date: Fri, 2 Apr 2010 08:55:56 -0700
From: Stephen Hemminger <shemminger@vyatta.com>
To: xiaohui.xin@intel.com
Cc: netdev@vger.kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       mingo@elte.hu, mst@redhat.com, jdike@c2.user-mode-linux.org,
       davem@davemloft.net
Subject: Re: [RFC] [PATCH v2 3/3] Let host NIC driver to DMA to guest user
 space.
Message-ID: <20100402085556.75a8ff7c@nehalam>
In-Reply-To: <1270193410-6877-1-git-send-email-xiaohui.xin@intel.com>
References: <1270193410-6877-1-git-send-email-xiaohui.xin@intel.com>
Organization: Vyatta
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri,  2 Apr 2010 15:30:10 +0800
xiaohui.xin@intel.com wrote:

> From: Xin Xiaohui <xiaohui.xin@intel.com>
> 
> The patch let host NIC driver to receive user space skb,
> then the driver has chance to directly DMA to guest user
> space buffers thru single ethX interface.
> We want it to be more generic as a zero copy framework.
> 
> Signed-off-by: Xin Xiaohui <xiaohui.xin@intel.com>
> Signed-off-by: Zhao Yu <yzhao81@gmail.com>
> Sigend-off-by: Jeff Dike <jdike@c2.user-mode-linux.org>
> ---
> 
> We consider 2 way to utilize the user buffres, but not sure which one
> is better. Please give any comments.
> 
> One:    Modify __alloc_skb() function a bit, it can only allocate a
>         structure of sk_buff, and the data pointer is pointing to a
>         user buffer which is coming from a page constructor API.
>         Then the shinfo of the skb is also from guest.
>         When packet is received from hardware, the skb->data is filled
>         directly by h/w. What we have done is in this way.
> 
>         Pros:   We can avoid any copy here.
>         Cons:   Guest virtio-net driver needs to allocate skb as almost
>                 the same method with the host NIC drivers, say the size
>                 of netdev_alloc_skb() and the same reserved space in the
>                 head of skb. Many NIC drivers are the same with guest and
>                 ok for this. But some lastest NIC drivers reserves special
>                 room in skb head. To deal with it, we suggest to provide
>                 a method in guest virtio-net driver to ask for parameter
>                 we interest from the NIC driver when we know which device
>                 we have bind to do zero-copy. Then we ask guest to do so.
>                 Is that reasonable?
> 
> Two:    Modify driver to get user buffer allocated from a page constructor
>         API(to substitute alloc_page()), the user buffer are used as payload
>         buffers and filled by h/w directly when packet is received. Driver
>         should associate the pages with skb (skb_shinfo(skb)->frags). For
>         the head buffer side, let host allocates skb, and h/w fills it.
>         After that, the data filled in host skb header will be copied into
>         guest header buffer which is submitted together with the payload buffer.
> 
>         Pros:   We could less care the way how guest or host allocates their
>                 buffers.
>         Cons:   We still need a bit copy here for the skb header.
> 
> We are not sure which way is the better here. This is the first thing we want
> to get comments from the community. We wish the modification to the network
> part will be generic which not used by vhost-net backend only, but a user
> application may use it as well when the zero-copy device may provides async
> read/write operations later.
> 
> 
> Thanks
> Xiaohui

How do you deal with the DoS problem of hostile user space app posting huge
number of receives and never getting anything. 
