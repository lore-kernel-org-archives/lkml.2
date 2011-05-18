Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932772Ab1ERB5l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 21:57:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32866 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932406Ab1ERB5j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 21:57:39 -0400
Subject: Re: [PATCH] pci, dmar: flush IOTLB before exit domain
From: Alex Williamson <alex.williamson@redhat.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Yinghai Lu <yinghai.lu@oracle.com>, Kalle Valo <kvalo@adurom.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>
In-Reply-To: <1305661262.29268.27.camel@x201>
References: <4DC34B21.9040203@oracle.com>
	 <1304952530.30435.16.camel@i7.infradead.org>
	 <1305558798.3146.48.camel@x201>  <1305661262.29268.27.camel@x201>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 17 May 2011 19:57:25 -0600
Message-ID: <1305683845.29268.34.camel@x201>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-05-17 at 13:41 -0600, Alex Williamson wrote:
> On Mon, 2011-05-16 at 09:13 -0600, Alex Williamson wrote:
> > On Mon, 2011-05-09 at 15:48 +0100, David Woodhouse wrote:
> > > On Thu, 2011-05-05 at 18:13 -0700, Yinghai Lu wrote:
> > > > @@ -3252,6 +3252,9 @@ static int device_notifier(struct notifi
> > > >                 return 0;
> > > >  
> > > >         if (action == BUS_NOTIFY_UNBOUND_DRIVER && !iommu_pass_through) {
> > > > +               /* before we remove dev with domain, flush IOTLB */
> > > > +               flush_unmaps();
> > > > +
> > > >                 domain_remove_one_dev_info(domain, pdev);
> > > >  
> > > >                 if (!(domain->flags & DOMAIN_FLAG_VIRTUAL_MACHINE) && 
> > > 
> > > That calls flush_unmaps() without the async_umap_flush_lock held,
> > > doesn't it? A few days ago I asked someone else to test this candidate
> > > patch for a similar issue:
> > > 
> > > http://david.woodhou.se/flush-unmaps-on-unbind.patch
> > 
> > Copying here:
> > 
> > > diff --git a/drivers/pci/intel-iommu.c b/drivers/pci/intel-iommu.c
> > > index d552d2c..7e606d6 100644
> > > --- a/drivers/pci/intel-iommu.c
> > > +++ b/drivers/pci/intel-iommu.c
> > > @@ -3256,8 +3259,10 @@ static int device_notifier(struct notifier_block *nb,
> > >  
> > >  		if (!(domain->flags & DOMAIN_FLAG_VIRTUAL_MACHINE) &&
> > >  		    !(domain->flags & DOMAIN_FLAG_STATIC_IDENTITY) &&
> > > -		    list_empty(&domain->devices))
> > > +		    list_empty(&domain->devices)) {
> > > +			flush_unmaps_timeout(0);
> > >  			domain_exit(domain);
> > > +		}
> > >  	}
> > >  
> > >  	return 0;
> > > @@ -3587,6 +3592,7 @@ static void intel_iommu_domain_destroy(struct iommu_domain *domain)
> > >  	struct dmar_domain *dmar_domain = domain->priv;
> > >  
> > >  	domain->priv = NULL;
> > > +	flush_unmaps_timeout(0);
> > >  	vm_domain_exit(dmar_domain);
> > > }
> > 
> > David, would it be worthwhile to push the unmaps into the
> > {vm_}domain_exit() functions to avoid races like this in the future?  I
> > can verify the above resolves a panic after unbinding a device from
> > snd_hda_intel that I hit recently.  Do you plan to push this for .39?
> 
> BTW, is this second chunk really needed?  VM iommu mappings don't seem
> to use the lazy unmap path.  Thanks,

David, what do you think of this instead?  Thanks,

Alex

intel-iommu: Flush unmaps at domain_exit

From: Alex Williamson <alex.williamson@redhat.com>

We typically batch unmaps to be lazily flushed out at
regular intervals.  When we destroy a domain, we need
to force a flush of these lazy unmaps to be sure none
reference the domain we're about to free.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---

 drivers/pci/intel-iommu.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)


diff --git a/drivers/pci/intel-iommu.c b/drivers/pci/intel-iommu.c
index d552d2c..b04f84e 100644
--- a/drivers/pci/intel-iommu.c
+++ b/drivers/pci/intel-iommu.c
@@ -1416,6 +1416,10 @@ static void domain_exit(struct dmar_domain *domain)
 	if (!domain)
 		return;
 
+	/* Flush any lazy unmaps that may reference this domain */
+	if (!intel_iommu_strict)
+		flush_unmaps_timeout(0);
+
 	domain_remove_dev_info(domain);
 	/* destroy iovas */
 	put_iova_domain(&domain->iovad);



