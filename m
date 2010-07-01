Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755295Ab0GALif (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 07:38:35 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:34886 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755219Ab0GALic (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 07:38:32 -0400
X-IronPort-AV: E=Sophos;i="4.53,519,1272844800"; 
   d="scan'208";a="690131"
Date: Thu, 1 Jul 2010 12:38:47 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: "stefano@stabellini.net" <stefano@stabellini.net>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
       Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
       "sheng@linux.intel.com" <sheng@linux.intel.com>,
       "ddutile@redhat.com" <ddutile@redhat.com>,
       "jeremy@goop.org" <jeremy@goop.org>
Subject: Re: [PATCH 04/13] Xen PCI platform device driver
In-Reply-To: <20100630175552.GB16488@phenom.dumpdata.com>
Message-ID: <alpine.DEB.2.00.1007011110550.30135@kaball-desktop>
References: <alpine.DEB.2.00.1006211456360.18470@kaball-desktop> <1277136847-13266-4-git-send-email-stefano@stabellini.net> <20100630175552.GB16488@phenom.dumpdata.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Jun 2010, Konrad Rzeszutek Wilk wrote:
> > @@ -476,9 +503,28 @@ static int gnttab_map(unsigned int start_idx, unsigned int end_idx)
> >  
> >  int gnttab_resume(void)
> >  {
> > -	if (max_nr_grant_frames() < nr_grant_frames)
> > +	unsigned int max_nr_gframes;
> > +
> > +	max_nr_gframes = max_nr_grant_frames();
> > +	if (max_nr_gframes < nr_grant_frames)
> >  		return -ENOSYS;
> > -	return gnttab_map(0, nr_grant_frames - 1);
> > +
> > +	if (xen_pv_domain())
> > +		return gnttab_map(0, nr_grant_frames - 1);
> > +
> > +	if (!hvm_pv_resume_frames) {
> > +		hvm_pv_resume_frames = alloc_xen_mmio(PAGE_SIZE * max_nr_gframes);
> > +		shared = ioremap(hvm_pv_resume_frames, PAGE_SIZE * max_nr_gframes);
> > +		if (shared == NULL) {
> > +			printk(KERN_WARNING
> > +					"Fail to ioremap gnttab share frames\n");
> 
> I would say: "Failed to ioremap gnttab share frames!\n".
> 
> .. snip ..
> 
> > +	if (request_region(ioaddr, iolen, DRV_NAME) == NULL) {
> > +		dev_err(&pdev->dev, "I/O resource 0x%lx @ 0x%lx busy\n",
> > +		       iolen, ioaddr);
> > +		ret = -EBUSY;
> > +		goto out;
> > +	}
> > +
> > +	platform_mmio = mmio_addr;
> > +	platform_mmiolen = mmio_len;
> > +
> > +	if (!xen_have_vector_callback) {
> > +		ret = xen_allocate_irq(pdev);
> > +		if (ret) {
> > +			printk(KERN_WARNING "request_irq failed err=%d\n", ret);
> Use dev_warn here.
> > +			goto out;
> > +		}
> > +		callback_via = get_callback_via(pdev);
> > +		ret = xen_set_callback_via(callback_via);
> > +		if (ret) {
> > +			printk(KERN_WARNING
> > +					"Unable to set the evtchn callback err=%d\n", ret);
> ditto.
> > +			goto out;
> > +		}
> > +	}
> > +
> > +	ret = gnttab_init();
> > +	if (ret)
> > +		goto out;
> > +	xenbus_probe(NULL);
> > +
> > +out:
> > +	if (ret) {
> > +		release_mem_region(mmio_addr, mmio_len);
> > +		release_region(ioaddr, iolen);
> > +		pci_disable_device(pdev);
> > +	}
> > +
> > +	return ret;
> > +}
> > +
> > +static struct pci_device_id platform_pci_tbl[] __devinitdata = {
> > +	{PCI_VENDOR_ID_XEN, PCI_DEVICE_ID_XEN_PLATFORM,
> > +		PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
> > +	{0,}
> > +};
> > +
> > +MODULE_DEVICE_TABLE(pci, platform_pci_tbl);
> > +
> > +static struct pci_driver platform_driver = {
> > +	.name =           DRV_NAME,
> > +	.probe =          platform_pci_init,
> > +	.id_table =       platform_pci_tbl,
> > +};
> > +
> > +static int __init platform_pci_module_init(void)
> > +{
> > +	int rc;
> > +
> > +	rc = pci_register_driver(&platform_driver);
> > +	if (rc) {
> > +		printk(KERN_INFO DRV_NAME
> > +		       ": No platform pci device model found\n");
> 
> No need for that. The pci_register_driver call to ->probe and
> its subsequent setup, if it failed, should have displayed the
> appropiate error+explanation?
> 
> How about just making it:
> 
> 	return pci_register_driver(&platform_driver);
> 
> 


Thanks for all the comments and suggestions, I'll make the changes.

