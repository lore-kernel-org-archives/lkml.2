Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756545Ab1FJRgQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 13:36:16 -0400
Received: from sous-sol.org ([216.99.217.87]:37568 "EHLO sequoia.sous-sol.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753107Ab1FJRgN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 13:36:13 -0400
Date: Fri, 10 Jun 2011 10:36:04 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/9] x86/amd-iommu: Introduce global dev_data_list
Message-ID: <20110610173604.GM23047@sequoia.sous-sol.org>
References: <1307707729-29767-1-git-send-email-joerg.roedel@amd.com>
 <1307707729-29767-3-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1307707729-29767-3-git-send-email-joerg.roedel@amd.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Joerg Roedel (joerg.roedel@amd.com) wrote:
> +static struct iommu_dev_data *alloc_dev_data(void)
> +{
> +	struct iommu_dev_data *dev_data;
> +	unsigned long flags;
> +
> +	dev_data = kzalloc(sizeof(*dev_data), GFP_KERNEL);
> +	if (!dev_data)
> +		return NULL;
> +
> +	atomic_set(&dev_data->bind, 0);
> +
> +	spin_lock_irqsave(&dev_data_list_lock, flags);
> +	list_add_tail(&dev_data->dev_data_list, &dev_data_list);
> +	spin_unlock_irqrestore(&dev_data_list_lock, flags);

Globally visible but only paritially initiailized.  I didn't see any, but
would this ever cause an issue?

> +static void free_dev_data(struct iommu_dev_data *dev_data)
> +{
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&dev_data_list_lock, flags);
> +	list_del(&dev_data->dev_data_list);
> +	spin_unlock_irqrestore(&dev_data_list_lock, flags);
> +
> +	kfree(dev_data);
<snip>
> +	/* Free all of our dev_data structures */
> +	list_for_each_entry_safe(dev_data, n, &dev_data_list, dev_data_list)
> +		free_dev_data(dev_data);

Given that it's not actually contended in early init, should be fine...but
typically full list traversal would be protected by lock rather than
repeatedly acquiring and releasing the lock.
