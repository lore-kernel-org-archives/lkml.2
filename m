Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756747Ab0F3R5p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 13:57:45 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:20423 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755100Ab0F3R5o (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Wed, 30 Jun 2010 13:57:44 -0400
Date: Wed, 30 Jun 2010 13:55:52 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: stefano@stabellini.net
Cc: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
       Stefano.Stabellini@eu.citrix.com, sheng@linux.intel.com,
       ddutile@redhat.com, jeremy@goop.org
Subject: Re: [PATCH 04/13] Xen PCI platform device driver
Message-ID: <20100630175552.GB16488@phenom.dumpdata.com>
References: <alpine.DEB.2.00.1006211456360.18470@kaball-desktop>
 <1277136847-13266-4-git-send-email-stefano@stabellini.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1277136847-13266-4-git-send-email-stefano@stabellini.net>
User-Agent: Mutt/1.5.20 (2009-12-10)
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.4C2B8586.00B4:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> @@ -476,9 +503,28 @@ static int gnttab_map(unsigned int start_idx, unsigned int end_idx)
>  
>  int gnttab_resume(void)
>  {
> -	if (max_nr_grant_frames() < nr_grant_frames)
> +	unsigned int max_nr_gframes;
> +
> +	max_nr_gframes = max_nr_grant_frames();
> +	if (max_nr_gframes < nr_grant_frames)
>  		return -ENOSYS;
> -	return gnttab_map(0, nr_grant_frames - 1);
> +
> +	if (xen_pv_domain())
> +		return gnttab_map(0, nr_grant_frames - 1);
> +
> +	if (!hvm_pv_resume_frames) {
> +		hvm_pv_resume_frames = alloc_xen_mmio(PAGE_SIZE * max_nr_gframes);
> +		shared = ioremap(hvm_pv_resume_frames, PAGE_SIZE * max_nr_gframes);
> +		if (shared == NULL) {
> +			printk(KERN_WARNING
> +					"Fail to ioremap gnttab share frames\n");

I would say: "Failed to ioremap gnttab share frames!\n".

.. snip ..

> +	if (request_region(ioaddr, iolen, DRV_NAME) == NULL) {
> +		dev_err(&pdev->dev, "I/O resource 0x%lx @ 0x%lx busy\n",
> +		       iolen, ioaddr);
> +		ret = -EBUSY;
> +		goto out;
> +	}
> +
> +	platform_mmio = mmio_addr;
> +	platform_mmiolen = mmio_len;
> +
> +	if (!xen_have_vector_callback) {
> +		ret = xen_allocate_irq(pdev);
> +		if (ret) {
> +			printk(KERN_WARNING "request_irq failed err=%d\n", ret);
Use dev_warn here.
> +			goto out;
> +		}
> +		callback_via = get_callback_via(pdev);
> +		ret = xen_set_callback_via(callback_via);
> +		if (ret) {
> +			printk(KERN_WARNING
> +					"Unable to set the evtchn callback err=%d\n", ret);
ditto.
> +			goto out;
> +		}
> +	}
> +
> +	ret = gnttab_init();
> +	if (ret)
> +		goto out;
> +	xenbus_probe(NULL);
> +
> +out:
> +	if (ret) {
> +		release_mem_region(mmio_addr, mmio_len);
> +		release_region(ioaddr, iolen);
> +		pci_disable_device(pdev);
> +	}
> +
> +	return ret;
> +}
> +
> +static struct pci_device_id platform_pci_tbl[] __devinitdata = {
> +	{PCI_VENDOR_ID_XEN, PCI_DEVICE_ID_XEN_PLATFORM,
> +		PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
> +	{0,}
> +};
> +
> +MODULE_DEVICE_TABLE(pci, platform_pci_tbl);
> +
> +static struct pci_driver platform_driver = {
> +	.name =           DRV_NAME,
> +	.probe =          platform_pci_init,
> +	.id_table =       platform_pci_tbl,
> +};
> +
> +static int __init platform_pci_module_init(void)
> +{
> +	int rc;
> +
> +	rc = pci_register_driver(&platform_driver);
> +	if (rc) {
> +		printk(KERN_INFO DRV_NAME
> +		       ": No platform pci device model found\n");

No need for that. The pci_register_driver call to ->probe and
its subsequent setup, if it failed, should have displayed the
appropiate error+explanation?

How about just making it:

	return pci_register_driver(&platform_driver);


