Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753042Ab1DUTKo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 15:10:44 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:56940 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752376Ab1DUTKn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 15:10:43 -0400
Date: Thu, 21 Apr 2011 13:10:41 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Neil Horman <nhorman@tuxdriver.com>
Cc: linux-kernel@vger.kernel.org, Jesse Barnes <jbarnes@virtuousgeek.org>,
        linux-pci@vger.kernel.org
Subject: Re: [PATCH] pci: Export pci device msi table via sysfs
Message-ID: <20110421191041.GE31296@parisc-linux.org>
References: <1303412267-1948-1-git-send-email-nhorman@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1303412267-1948-1-git-send-email-nhorman@tuxdriver.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 21, 2011 at 02:57:47PM -0400, Neil Horman wrote:
> b) msi_table - populated only if msi(x) is enabled, it lists the irqs allocated
> to the pci device

You're not the first one to try this ... the problem is, you can easily
overflow a single 4k page.  A device can have up to 2k MSI-X entries,
and we might take up to 5 bytes for each one, so we'd need a 10k buffer.

> +#ifdef CONFIG_PCI_MSI
> +static ssize_t msi_list_show(struct device *dev,
> +			struct device_attribute *attr, char *buf)
> +{
> +	struct pci_dev *pdev = to_pci_dev(dev);
> +	struct msi_desc *entry;
> +	int first, last;
> +	ssize_t count = 0;
> +
> +	if (!(pdev->msi_enabled || pdev->msix_enabled))
> +		return 0;
> +
> +	list_for_each_entry(entry, &pdev->msi_list, list)
> +		count += sprintf(&buf[count], "%d ", entry->irq);
> +
> +	return count;
> +}
> +#endif

The fundamental problem is that the way Linux uses MSI-X is completely
bollocks.  I've got a few hours to myself on a plane coming up in six
weeks, and I hope to rewrite it then (I've already written my talk, so
what else am I going to do?  :-)

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
