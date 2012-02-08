Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756491Ab2BHIfW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 03:35:22 -0500
Received: from merlin.infradead.org ([205.233.59.134]:54412 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756035Ab2BHIfV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 03:35:21 -0500
Message-ID: <4F323388.7040902@kernel.dk>
Date: Wed, 08 Feb 2012 09:34:16 +0100
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: integer overflows in kernel/relay.c
References: <20120207141155.GA16184@elgon.mountain>
In-Reply-To: <20120207141155.GA16184@elgon.mountain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/07/2012 03:11 PM, Dan Carpenter wrote:
> My static checker is warning about integer overflows in kernel/relay.c
> 
> relay_create_buf()
>    170  
>    171          buf->padding = kmalloc(chan->n_subbufs * sizeof(size_t *), GFP_KERNEL);
>                                        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> This can only overflow on 32bit systems.

Correct

>    172          if (!buf->padding)
>    173                  goto free_buf;
>    174  
> 
> relay_open()
>    582          chan->version = RELAYFS_CHANNEL_VERSION;
>    583          chan->n_subbufs = n_subbufs;
>    584          chan->subbuf_size = subbuf_size;
>    585          chan->alloc_size = FIX_SIZE(subbuf_size * n_subbufs);
>                                             ^^^^^^^^^^^^^^^^^^^^^^^
>    586          chan->parent = parent;
> 
> These come from the user in blk_trace_setup() and they aren't capped.
> I'm not sure what the maximum size to use is.

They are both u32 types, so can overflow on 32-bit as well. By default,
blktrace is using 4 for n_subbufs and 512k for subbuf_size, but they are
configurable. As a fix, I would suggest just checking if the products
overflow, and if they do, return an error. That's better than imposing
some hard limits. In reality, only a malicious users would trigger
these.

-- 
Jens Axboe

