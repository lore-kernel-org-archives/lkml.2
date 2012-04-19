Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756329Ab2DSSsO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 14:48:14 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55354 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754164Ab2DSSsN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 14:48:13 -0400
Date: Thu, 19 Apr 2012 11:48:11 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Roland Dreier <roland@kernel.org>
Cc: Joerg Roedel <joerg.roedel@amd.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dma-debug: Fix deadlock with netconsole or other
 drivers that use the DMA API
Message-Id: <20120419114811.9e77accb.akpm@linux-foundation.org>
In-Reply-To: <1334859173-9446-1-git-send-email-roland@kernel.org>
References: <1334859173-9446-1-git-send-email-roland@kernel.org>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Apr 2012 11:12:53 -0700
Roland Dreier <roland@kernel.org> wrote:

> From: Roland Dreier <roland@purestorage.com>
> 
> If we exhaust the free_entries list, then we print the error message
> 
>     DMA-API: debugging out of memory - disabling
> 
> to the kernel log, while holding free_entries_lock.  Unfortunately, if
> the console driver ends up calling back into the DMA API to map a
> buffer, as eg a NIC driver is quite likely to for the packet netconsole
> asks it to send, this will deadlock on free_entries_lock.
> 
> A fix is pretty simple: if we flip the order of setting global_disable
> to be before we print the error message, then the nested call into the
> DMA API will bail out before trying to get free_entries_lock.
> 
> Signed-off-by: Roland Dreier <roland@purestorage.com>
> ---
>  lib/dma-debug.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/lib/dma-debug.c b/lib/dma-debug.c
> index 13ef233..f198b4e 100644
> --- a/lib/dma-debug.c
> +++ b/lib/dma-debug.c
> @@ -436,8 +436,8 @@ static struct dma_debug_entry *dma_entry_alloc(void)
>  	spin_lock_irqsave(&free_entries_lock, flags);
>  
>  	if (list_empty(&free_entries)) {
> -		pr_err("DMA-API: debugging out of memory - disabling\n");
>  		global_disable = true;
> +		pr_err("DMA-API: debugging out of memory - disabling\n");
>  		goto out;
>  	}

So *any* printk can deadlock if free_entries_lock is held and
global_disable==false?

In that case we're going to need much sterner fixes.  Any list_head
operation can do a printk if list_head debugging is enabled. 
dma_debug_resize_entries() does a kfree() under free_entries_lock(!).

Methinks we need a more general fix?
