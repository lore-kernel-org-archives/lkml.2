Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754809Ab0JNHPL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 03:15:11 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:42602 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754565Ab0JNHPK convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com:7:1>);
	Thu, 14 Oct 2010 03:15:10 -0400
Message-Id: <4CB6CA1A020000780001D161@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Thu, 14 Oct 2010 08:15:06 +0100
From: "Jan Beulich" <JBeulich@novell.com>
To: "Konrad Rzeszutek Wilk" <konrad@kernel.org>,
        "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>
Cc: "Ryan Wilson" <hap9@darnok.org>,
        "Stefano Stabellini" <stefano.stabellini@eu.citrix.com>,
        "Jeremy Fitzhardinge" <jeremy@goop.org>,
        <xen-devel@lists.xensource.com>, <linux-kernel@vger.kernel.org>
Subject: [Xen-devel] Re: [PATCH 20/23] xen-pcifront: Xen PCI frontend
	 driver.
References: <1286898271-32018-1-git-send-email-konrad.wilk@oracle.com>
 <1286898271-32018-21-git-send-email-konrad.wilk@oracle.com>
 <4CB599DB020000780001CC60@vpn.id2.novell.com>
 <201010130953.45283.konrad@darnok.org>
 <20101013161636.GA19872@dumpdata.com>
In-Reply-To: <20101013161636.GA19872@dumpdata.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 13.10.10 at 18:16, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:
> On Wed, Oct 13, 2010 at 09:53:44AM -0400, Konrad Rzeszutek Wilk wrote:
>> Hey Jan,
>> 
>> Thank you for taking your time to look at this patch. Will fix up, test it, 
>> and if there are no issues, have it ready tomorrow.
> 
> Attached (and inline) is the updated version of this patch. If I missed 
> anything
> please do point it out to me!

There's one more missing "static", and one incorrect change to
free_pdev() you did.

Also, any word on the pdev_lock you dropped from the original
implementation?

> If this is to your satisfaction, can I put a Reviewed-by tag on the patch?

Feel free to do so.

> --- /dev/null
> +++ b/drivers/pci/xen-pcifront.c
>...
> +int __devinit pcifront_scan_bus(struct pcifront_device *pdev,

static?

>...
> +static void free_pdev(struct pcifront_device *pdev)
> +{
> +	dev_dbg(&pdev->xdev->dev, "freeing pdev @ 0x%p\n", pdev);
> +
> +	pcifront_free_roots(pdev);
> +
> +	/*For PCIE_AER error handling job*/
> +	flush_scheduled_work();
> +
> +	if (pdev->irq)

	if (pdev->irq > 0)

It gets initialized to -1 in alloc_pdev(). It may be debatable whether
it should be >= 0 - I'm not sure if the pv-ops code allows IRQ 0 to
be used. If it doesn't, initializing to 0 in alloc_pdev() would be an
alternative.

> +		unbind_from_irqhandler(pdev->irq, pdev);
> +
> +	if (pdev->evtchn != INVALID_EVTCHN)
> +		xenbus_free_evtchn(pdev->xdev, pdev->evtchn);
> +
> +	if (pdev->gnt_ref != INVALID_GRANT_REF)
> +		gnttab_end_foreign_access(pdev->gnt_ref, 0 /* r/w page */,
> +					  (unsigned long)pdev->sh_info);
> +	else
> +		free_page((unsigned long)pdev->sh_info);
> +
> +	dev_set_drvdata(&pdev->xdev->dev, NULL);
> +
> +	kfree(pdev);
> +}
> +
> +static int pcifront_publish_info(struct pcifront_device *pdev)
> +{
> +	int err = 0;
> +	struct xenbus_transaction trans;
> +
> +	err = xenbus_grant_ring(pdev->xdev, virt_to_mfn(pdev->sh_info));
> +	if (err < 0)
> +		goto out;
> +
> +	pdev->gnt_ref = err;
> +
> +	err = xenbus_alloc_evtchn(pdev->xdev, &pdev->evtchn);
> +	if (err)
> +		goto out;
> +
> +	err = bind_evtchn_to_irqhandler(pdev->evtchn, pcifront_handler_aer,
> +		0, "pcifront", pdev);
> +	if (err < 0) {
> +		/*
> +		xenbus_free_evtchn(pdev->xdev, pdev->evtchn);
> +		xenbus_dev_fatal(pdev->xdev, err, "Failed to bind evtchn to "
> +				 "irqhandler.\n");
> +		*/

Why are you commenting it out rather than removing it?

Jan

