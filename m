Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753149Ab2H3I4N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2012 04:56:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59834 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752699Ab2H3I4M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2012 04:56:12 -0400
Date: Thu, 30 Aug 2012 11:57:24 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Frank Swiderski <fes@google.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, riel@redhat.com,
        Andrea Arcangeli <aarcange@redhat.com>,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org, mikew@google.com
Subject: Re: [PATCH] Add a page cache-backed balloon device driver.
Message-ID: <20120830085724.GF10269@redhat.com>
References: <1340742778-11282-1-git-send-email-fes@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1340742778-11282-1-git-send-email-fes@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 26, 2012 at 01:32:58PM -0700, Frank Swiderski wrote:
> +static void fill_balloon(struct virtio_balloon *vb, size_t num)
> +{
> +	int err;
> +
> +	/* We can only do one array worth at a time. */
> +	num = min(num, ARRAY_SIZE(vb->pfns));
> +
> +	for (vb->num_pfns = 0; vb->num_pfns < num; vb->num_pfns++) {
> +		struct page *page;
> +		unsigned long inode_pfn = find_available_inode_page(vb);
> +		/* Should always be able to find a page. */
> +		BUG_ON(!inode_pfn);
> +		page = read_mapping_page(the_inode.inode.i_mapping, inode_pfn,
> +					 NULL);
> +		if (IS_ERR(page)) {
> +			if (printk_ratelimit())
> +				dev_printk(KERN_INFO, &vb->vdev->dev,
> +					   "Out of puff! Can't get %zu pages\n",
> +					   num);
> +			break;
> +		}
> +
> +		/* Set the page to be dirty */
> +		set_page_dirty(page);
> +
> +		vb->pfns[vb->num_pfns] = page_to_pfn(page);
> +	}
> +
> +	/* Didn't get any?  Oh well. */
> +	if (vb->num_pfns == 0)
> +		return;

Went to look at this driver, and noticed caller will re-invoke
this immediately if this triggers, so we busy-wait
re-trying this. When does read_mapping_page fail?
Is there any condition we could wait on?

-- 
MST
