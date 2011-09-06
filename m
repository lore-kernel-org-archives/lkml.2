Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753489Ab1IFIDl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 04:03:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19120 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753343Ab1IFIDf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 04:03:35 -0400
Date: Tue, 6 Sep 2011 11:04:10 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, Brian King <brking@us.ibm.com>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        "Hans J. Koch" <hjk@hansjkoch.de>, Greg Kroah-Hartman <gregkh@suse.de>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [RFC] pci: Rework config space blocking services
Message-ID: <20110906080410.GD13286@redhat.com>
References: <20110829150552.GA6851@redhat.com>
 <4E5BB358.3060705@siemens.com>
 <4E5BDEAB.5000405@siemens.com>
 <20110829191858.GA9415@redhat.com>
 <4E608A51.70509@siemens.com>
 <20110906055810.GA13286@redhat.com>
 <4E65C935.9000803@siemens.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E65C935.9000803@siemens.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 06, 2011 at 09:18:13AM +0200, Jan Kiszka wrote:
> >> @@ -401,36 +403,58 @@ int pci_vpd_truncate(struct pci_dev *dev, size_t size)
> >>  EXPORT_SYMBOL(pci_vpd_truncate);
> >>
> >>  /**
> >> - * pci_block_user_cfg_access - Block userspace PCI config reads/writes
> >> + * pci_block_cfg_access - Block PCI config reads/writes
> > 
> > This comment seems confusing. We don't in fact block all config
> > reads writes. Instead we block userspace accesses and
> > concurrent block requests.
> 
> I'm open for a better suggestion that summarize the more verbose (and
> hopefully clearer) explanation below.

I think the problem is, it doesn't block config access
and we call it pci_block_cfg_access.

Thinking about it, doesn't this behave somewhat like a lock?
How about

pci_user_cfg_access_trylock
pci_user_cfg_access_lock
pci_user_cfg_access_unlock

And then:
 * pci_user_cfg_access_lock - Lock userspace PCI config access
 *
 * When locked, any userspace reads or writes to config space
 * and concurrent lock requests will sleep, and trylock requests
 * will fail, until pci_user_cfg_access_unlock is called.

I had a brief thought of using an rwsem internally, but
this would make trylock fail if userspace does config read,
changing semantics.

-- 
MST
