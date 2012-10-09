Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752466Ab2JIToy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 15:44:54 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54838 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750810Ab2JITov (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 15:44:51 -0400
Date: Tue, 9 Oct 2012 12:44:49 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        andi@firstfloor.org
Subject: Re: [PATCH 2/2] Drivers: hv: Add Hyper-V balloon driver
Message-Id: <20121009124449.f54bf8cb.akpm@linux-foundation.org>
In-Reply-To: <1349654386-18378-2-git-send-email-kys@microsoft.com>
References: <1349654347-18337-1-git-send-email-kys@microsoft.com>
	<1349654386-18378-1-git-send-email-kys@microsoft.com>
	<1349654386-18378-2-git-send-email-kys@microsoft.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun,  7 Oct 2012 16:59:46 -0700
"K. Y. Srinivasan" <kys@microsoft.com> wrote:

> Add the basic balloon driver.

hm, how many balloon drivers does one kernel need?

Although I see that the great majority of this code is hypervisor-specific.

> Windows hosts dynamically manage the guest
> memory allocation via a combination memory hot add and ballooning. Memory
> hot add is used to grow the guest memory upto the maximum memory that can be
> allocatted to the guest. Ballooning is used to both shrink as well as expand
> up to the max memory. Supporting hot add needs additional support from the
> host. We will support hot add when this support is available. For now,
> by setting the VM startup memory to the VM  max memory, we can use
> ballooning alone to dynamically manage memory allocation amongst
> competing guests on a given host.
> 
>
> ...
>
> +static int  alloc_balloon_pages(struct hv_dynmem_device *dm, int num_pages,
> +			 struct dm_balloon_response *bl_resp, int alloc_unit,
> +			 bool *alloc_error)
> +{
> +	int i = 0;
> +	struct page *pg;
> +
> +	if (num_pages < alloc_unit)
> +		return 0;
> +
> +	for (i = 0; (i * alloc_unit) < num_pages; i++) {
> +		if (bl_resp->hdr.size + sizeof(union dm_mem_page_range) >
> +			PAGE_SIZE)
> +			return i * alloc_unit;
> +
> +		pg = alloc_pages(GFP_HIGHUSER | __GFP_NORETRY | GFP_ATOMIC |
> +				__GFP_NOMEMALLOC | __GFP_NOWARN,
> +				get_order(alloc_unit << PAGE_SHIFT));

This choice of GFP flags is basically impossible to understand, so I
suggest that a comment be added explaining it all.

I'm a bit surprised at the inclusion of GFP_ATOMIC as it will a) dip
into page reserves, whcih might be undesirable and b) won't even
reclaim clean pages, which seems desirable.  I suggest this also be
covered in the forthcoming code comment.

drivers/misc/vmw_balloon.c seems to me to have used better choices here.

> +		if (!pg) {
> +			*alloc_error = true;
> +			return i * alloc_unit;
> +		}
> +
> +		totalram_pages -= alloc_unit;

Well, I'd consider totalram_pages to be an mm-private thing which drivers
shouldn't muck with.  Why is this done?

drivers/xen/balloon.c and drivers/virtio/virtio_balloon.c also alter
totalram_pages, also without explaining why. 
drivers/misc/vmw_balloon.c does not.

> +		dm->num_pages_ballooned += alloc_unit;
> +
> +		bl_resp->range_count++;
> +		bl_resp->range_array[i].finfo.start_page =
> +			page_to_pfn(pg);
> +		bl_resp->range_array[i].finfo.page_cnt = alloc_unit;
> +		bl_resp->hdr.size += sizeof(union dm_mem_page_range);
> +
> +	}
> +
> +	return num_pages;
> +}
>
> ...
>

