Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754211Ab1FKK1h (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jun 2011 06:27:37 -0400
Received: from am1ehsobe002.messaging.microsoft.com ([213.199.154.205]:27123
	"EHLO AM1EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753905Ab1FKK1e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jun 2011 06:27:34 -0400
X-SpamScore: -18
X-BigFish: VPS-18(zz1432N98dKzz1202hzz15d4Rz32i668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LMMFPS-01-715-02
X-M-MSG: 
Date: Sat, 11 Jun 2011 12:27:54 +0200
From: "Roedel, Joerg" <Joerg.Roedel@amd.com>
To: Chris Wright <chrisw@sous-sol.org>
CC: "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/9] x86/amd-iommu: Introduce global dev_data_list
Message-ID: <20110611102754.GB29908@amd.com>
References: <1307707729-29767-1-git-send-email-joerg.roedel@amd.com>
 <1307707729-29767-3-git-send-email-joerg.roedel@amd.com>
 <20110610173604.GM23047@sequoia.sous-sol.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20110610173604.GM23047@sequoia.sous-sol.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 10, 2011 at 01:36:04PM -0400, Chris Wright wrote:
> * Joerg Roedel (joerg.roedel@amd.com) wrote:
> > +static struct iommu_dev_data *alloc_dev_data(void)
> > +{
> > +	struct iommu_dev_data *dev_data;
> > +	unsigned long flags;
> > +
> > +	dev_data = kzalloc(sizeof(*dev_data), GFP_KERNEL);
> > +	if (!dev_data)
> > +		return NULL;
> > +
> > +	atomic_set(&dev_data->bind, 0);
> > +
> > +	spin_lock_irqsave(&dev_data_list_lock, flags);
> > +	list_add_tail(&dev_data->dev_data_list, &dev_data_list);
> > +	spin_unlock_irqrestore(&dev_data_list_lock, flags);
> 
> Globally visible but only paritially initiailized.  I didn't see any, but
> would this ever cause an issue?

I don't think so. Everything allocated here goes into iommu_init_device
where the alias-part of the struct is initialized. As long as this is
the only place that calls find_dev_data everything is fine.

> > +static void free_dev_data(struct iommu_dev_data *dev_data)
> > +{
> > +	unsigned long flags;
> > +
> > +	spin_lock_irqsave(&dev_data_list_lock, flags);
> > +	list_del(&dev_data->dev_data_list);
> > +	spin_unlock_irqrestore(&dev_data_list_lock, flags);
> > +
> > +	kfree(dev_data);
> <snip>
> > +	/* Free all of our dev_data structures */
> > +	list_for_each_entry_safe(dev_data, n, &dev_data_list, dev_data_list)
> > +		free_dev_data(dev_data);
> 
> Given that it's not actually contended in early init, should be fine...but
> typically full list traversal would be protected by lock rather than
> repeatedly acquiring and releasing the lock.

Well, the lock shouldn't be necessary here at all. This function is
called in the error-path to clean up. Otherwise the dev_data structures
are never freed, so the lock can probably be removed from free_dev_data.

	Joerg

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

