Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754837Ab2KEUhk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 15:37:40 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:55051 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754009Ab2KEUhj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 15:37:39 -0500
Date: Mon, 5 Nov 2012 12:37:38 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Xi Wang <xi.wang@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: fix NULL checking in dma_pool_create()
Message-Id: <20121105123738.0a0490a7.akpm@linux-foundation.org>
In-Reply-To: <1352097996-25808-1-git-send-email-xi.wang@gmail.com>
References: <1352097996-25808-1-git-send-email-xi.wang@gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon,  5 Nov 2012 01:46:36 -0500
Xi Wang <xi.wang@gmail.com> wrote:

> First, `dev' is dereferenced in dev_to_node(dev), suggesting that it
> must be non-null.  Later `dev' is checked against NULL, suggesting
> the opposite.  This patch adds a NULL check before its use.
> 
> ...
>
> @@ -159,7 +160,9 @@ struct dma_pool *dma_pool_create(const char *name, struct device *dev,
>  		return NULL;
>  	}
>  
> -	retval = kmalloc_node(sizeof(*retval), GFP_KERNEL, dev_to_node(dev));
> +	node = dev ? dev_to_node(dev) : -1;
> +
> +	retval = kmalloc_node(sizeof(*retval), GFP_KERNEL, node);
>  	if (!retval)
>  		return retval;

Well, the dma_pool_create() kerneldoc does not describe dev==NULL to be
acceptable usage and given the lack of oops reports, we can assume that
no code is calling this function with dev==NULL.

So I think we can just remove the code which handles dev==NULL?
