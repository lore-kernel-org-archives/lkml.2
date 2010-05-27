Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757552Ab0E0IY5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 04:24:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8635 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750860Ab0E0IYy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 04:24:54 -0400
Date: Thu, 27 May 2010 11:20:25 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: "Xin, Xiaohui" <xiaohui.xin@intel.com>
Cc: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Herbert Xu <herbert@gondor.hengli.com.au>
Subject: Re: issue about virtio-net driver to suppoprt vhost mergeable
	buffer with zero-copy to support PS mode
Message-ID: <20100527082025.GA5579@redhat.com>
References: <F2E9EB7348B8264F86B6AB8151CE2D790B7958E740@shsmsx502.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <F2E9EB7348B8264F86B6AB8151CE2D790B7958E740@shsmsx502.ccr.corp.intel.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 27, 2010 at 09:21:02AM +0800, Xin, Xiaohui wrote:
> Michael,
> I'm now looking into the vhost mergeable buffer, and I tried to use it to support PS mode with zero-copy. And I found an issue there that I have to modify the guest virito-net driver.
> 
> When guest virtio-net driver submits mergeable buffers, it submits multiple pages outside. In zero-copy case, vhost cannot know which page is used to put header, and which page is used to put payload. Then vhost can only reserves 12 bytes for each page. That means, the page_offset of the payload DMAed into the guest buffer is always 12 bytes. But guest virtio-net driver always use offset 0 to put the data (See receive_mergeable()). That's where the zero-copy use mergeable buffer must modify.
> 
> Have I missed something here? And how do you think about it?
> 
> Thanks 
> Xiaohui 

Maybe you can teach the hardware skip the first 12 bytes: qemu will
call an ioctl telling hardware what the virtio header size is.
This is how we plan to do it for tap.

Alternatively, buffers can be used in any order.
So we can have hardware use N buffers for the packet, and then
have vhost put the header in buffer N+1.

-- 
MST
