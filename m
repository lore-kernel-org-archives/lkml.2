Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754288Ab1DUUAv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 16:00:51 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:53644 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751218Ab1DUUAt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 16:00:49 -0400
Date: Thu, 21 Apr 2011 16:00:39 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-kernel@vger.kernel.org, Jesse Barnes <jbarnes@virtuousgeek.org>,
        linux-pci@vger.kernel.org
Subject: Re: [PATCH] pci: Export pci device msi table via sysfs
Message-ID: <20110421200039.GC18449@hmsreliant.think-freely.org>
References: <1303412267-1948-1-git-send-email-nhorman@tuxdriver.com>
 <20110421191041.GE31296@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110421191041.GE31296@parisc-linux.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-Score: -2.6 (--)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 21, 2011 at 01:10:41PM -0600, Matthew Wilcox wrote:
> On Thu, Apr 21, 2011 at 02:57:47PM -0400, Neil Horman wrote:
> > b) msi_table - populated only if msi(x) is enabled, it lists the irqs allocated
> > to the pci device
> 
> You're not the first one to try this ... the problem is, you can easily
> overflow a single 4k page.  A device can have up to 2k MSI-X entries,
> and we might take up to 5 bytes for each one, so we'd need a 10k buffer.
> 
Yeah, I was a bit worried about that - but I didn't think any sane device would
allocate en entire 2048 irqs (not that thats an excuse).  I had considered doing
an export format like local_cpulist where consecutive irq allocations are listed
as first-last, which would save space and keep us inside a page.  Thoughts?

> > +#ifdef CONFIG_PCI_MSI
> > +static ssize_t msi_list_show(struct device *dev,
> > +			struct device_attribute *attr, char *buf)
> > +{
> > +	struct pci_dev *pdev = to_pci_dev(dev);
> > +	struct msi_desc *entry;
> > +	int first, last;
> > +	ssize_t count = 0;
> > +
> > +	if (!(pdev->msi_enabled || pdev->msix_enabled))
> > +		return 0;
> > +
> > +	list_for_each_entry(entry, &pdev->msi_list, list)
> > +		count += sprintf(&buf[count], "%d ", entry->irq);
> > +
> > +	return count;
> > +}
> > +#endif
> 
> The fundamental problem is that the way Linux uses MSI-X is completely
> bollocks.  I've got a few hours to myself on a plane coming up in six
> weeks, and I hope to rewrite it then (I've already written my talk, so
> what else am I going to do?  :-)
> 
Fair enough, I assume when you say 'it' you are referring to (or including) the
way the sysfs attributes are exported, so that we can use seq_file more
flexibly, and break the page limitation?

Regards
Neil

> -- 
> Matthew Wilcox				Intel Open Source Technology Centre
> "Bill, look, we understand that you're interested in selling us this
> operating system, but compare it to ours.  We can't possibly take such
> a retrograde step."
> 
