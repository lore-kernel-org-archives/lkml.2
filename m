Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752248Ab2AZTNy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 14:13:54 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:57779 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751410Ab2AZTNx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 14:13:53 -0500
Message-ID: <4F21A5AF.6010605@linux.vnet.ibm.com>
Date: Thu, 26 Jan 2012 11:12:47 -0800
From: Dave Hansen <dave@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111109 Lightning/1.0b2 Thunderbird/3.1.16
MIME-Version: 1.0
To: Seth Jennings <sjenning@linux.vnet.ibm.com>
CC: Greg Kroah-Hartman <gregkh@suse.de>, Nitin Gupta <ngupta@vflare.org>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Brian King <brking@linux.vnet.ibm.com>,
        Konrad Wilk <konrad.wilk@oracle.com>, linux-mm@kvack.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] staging: zsmalloc: zsmalloc memory allocation library
References: <1326149520-31720-1-git-send-email-sjenning@linux.vnet.ibm.com> <1326149520-31720-2-git-send-email-sjenning@linux.vnet.ibm.com>
In-Reply-To: <1326149520-31720-2-git-send-email-sjenning@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12012619-2398-0000-0000-000003B56CB1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/09/2012 02:51 PM, Seth Jennings wrote:
> +	area = &get_cpu_var(zs_map_area);
> +	if (off + class->size <= PAGE_SIZE) {
> +		/* this object is contained entirely within a page */
> +		area->vm_addr = kmap_atomic(page);
> +	} else {
> +		/* this object spans two pages */
> +		struct page *nextp;
> +
> +		nextp = get_next_page(page);
> +		BUG_ON(!nextp);
> +
> +
> +		set_pte(area->vm_ptes[0], mk_pte(page, PAGE_KERNEL));
> +		set_pte(area->vm_ptes[1], mk_pte(nextp, PAGE_KERNEL));
> +
> +		/* We pre-allocated VM area so mapping can never fail */
> +		area->vm_addr = area->vm->addr;
> +	}

This bit appears to be trying to make kmap_atomic() variant that can map
two pages in to contigious virtual addresses.  Instead of open-coding it
in a non-portable way like this, should we just make a new kmap_atomic()
variant that does this?

>From the way it's implemented, I _think_ you're guaranteed to get two
contiguous addresses if you do two adjacent kmap_atomics() on the same CPU:

void *kmap_atomic_prot(struct page *page, pgprot_t prot)
{
...
        type = kmap_atomic_idx_push();
        idx = type + KM_TYPE_NR*smp_processor_id();
        vaddr = __fix_to_virt(FIX_KMAP_BEGIN + idx);

I think if you do a get_cpu()/put_cpu() or just a preempt_disable()
across the operations you'll be guaranteed to get two contiguous addresses.

