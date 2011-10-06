Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759268Ab1JFUUm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 16:20:42 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:51907 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759163Ab1JFUUk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 16:20:40 -0400
Subject: Re: [PATCH] staging: zcache: fix crash on cpu remove
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Seth Jennings <sjenning@linux.vnet.ibm.com>
Cc: gregkh@suse.de, cascardo@holoscopio.com, dan.magenheimer@oracle.com,
        rdunlap@xenotime.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, rcj@linux.vnet.ibm.com,
        brking@linux.vnet.ibm.com, ngupta@vflare.org
In-Reply-To: <1317929306-18471-1-git-send-email-sjenning@linux.vnet.ibm.com>
References: <1317929306-18471-1-git-send-email-sjenning@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 06 Oct 2011 13:17:32 -0700
Message-ID: <1317932252.15807.69.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
x-cbid: 11100620-5112-0000-0000-000000D7525C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-10-06 at 14:28 -0500, Seth Jennings wrote:
> 
> +               if (kp->obj) {
> +                       kmem_cache_free(zcache_obj_cache, kp->obj);
> +                       kp->obj = NULL;
> +               }
> +               if (kp->page) {
> +                       free_page((unsigned long)kp->page);
> +                       kp->page = NULL;
> +               } 

Getting back from my preempt tangent... :)

I'm not sure how free_page() can oops.  If kp->page is NULL free_pages()
will rescue you:
        
        void free_pages(unsigned long addr, unsigned int order)
        {
                if (addr != 0) {
                        VM_BUG_ON(!virt_addr_valid((void *)addr));
                        __free_pages(virt_to_page((void *)addr), order);
                }
        }

I *thought* we did some of the same for kmem_cache_free(), but maybe
it's just kmalloc/kfree().  Anyway, it's all good.  I don't like relying
on the allocators to be nice when freeing NULL pointers anyway.

Acked-by: Dave Hansen <dave@linux.vnet.ibm.com>

-- Dave


