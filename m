Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752221Ab1IVNSQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 09:18:16 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:45421 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752475Ab1IVNSM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 09:18:12 -0400
Date: Thu, 22 Sep 2011 09:17:30 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
        Jesse Barnes <jbarnes@virtuousgeek.org>, linux-pci@vger.kernel.org
Subject: Re: [PATCH] sysfs: add per pci device msi[x] irq listing (v3)
Message-ID: <20110922131649.GA13359@shamino.rdu.redhat.com>
References: <1316025413-5855-1-git-send-email-nhorman@tuxdriver.com>
 <1316447235-31345-1-git-send-email-nhorman@tuxdriver.com>
 <20110922104902.GA23513@phenom.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110922104902.GA23513@phenom.oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-Score: -2.9 (--)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 22, 2011 at 06:49:02AM -0400, Konrad Rzeszutek Wilk wrote:
> On Mon, Sep 19, 2011 at 11:47:15AM -0400, Neil Horman wrote:
> > So a while back, I wanted to provide a way for irqbalance (and other apps) to
> > definitively map irqs to devices, which, for msi[x] irqs is currently not really
> > possible in user space.  My first attempt wen't not so well:
> > https://lkml.org/lkml/2011/4/21/308
> > 
> > It was plauged by the same issues that prior attempts were, namely that it
> > violated the one-file-one-value sysfs rule.  I wandered off but have recently
> > come back to this.  I've got a new implementation here that exports a new
> > subdirectory for every pci device,  called msi_irqs.  This subdirectory contanis
> > a variable number of numbered subdirectories, in which the number represents an
> > msi irq.  Each numbered subdirectory contains attributes for that irq, which
> > currently is only the mode it is operating in (msi vs. msix).  I think fits
> > within the constraints sysfs requires, and will allow irqbalance to properly map
> > msi irqs to devices without having to rely on rickety, best guess methods like
> > interface name matching.
> 
> Are there irqbalance patches that correspond to this? Where would they be available?
> 
Sorry, missed your other in-line comments, responses below

><snip>
> > +static int populate_msi_sysfs(struct pci_dev *pdev)
> 
> So,  are there any cases where CONFIG_SYSFS is turned off and
> CONFIG_MSI is set? Should there be some #ifdef CONFIG_SYSFS
> magic tricks?
> 
Its not needed.  The kobject calls are always built in unconditionally and are
used to generate udev events.  As part of that kobject registration, sysfs files
are created, and the ifdefs for sysfs dependencies are handled internally at the
sysfs api calls.  Even if their not defined though, we still want to create the
kobjects for the uevent generation.

> > +
> 
> That is rather draconian way of doing it. I mean if the SysFS entries
> can't be created, then abonden the whole thing? Why not just WARN
> and continue on without creating the SysFS entries?
> 
Because it just seems like its asking for trouble.  If a system is so memory
constrained that it can't create kobjects for an msi interrupt, we're going to
run into other problems anyway, I'd rather not have the device being setup as a
warning, than a quiet missing set of irqs in sysfs.

> >  	/* Set MSI enabled bits	 */
> >  	pci_intx_for_msi(dev, 0);
> >  	msi_set_enable(dev, pos, 1);
> > @@ -573,6 +674,12 @@ static int msix_capability_init(struct pci_dev *dev,
> >  
> >  	msix_program_entries(dev, entries);
> >  
> > +	ret = populate_msi_sysfs(dev);
> > +	if (ret) {
> > +		ret = 0;
> 
> Why the reset to zero?
> 
look at the meaning of the return code.  As I noted above, I didn't want to be
able to allocate the msi interrupts at all if the sysfs setup failed.  Zero is
the proper value to jump to the error label with there to indicate that.  It
means we we didn't allocate any msi interrupts.

> > +++ b/include/linux/pci.h
> > @@ -332,6 +332,7 @@ struct pci_dev {
> >  	struct bin_attribute *res_attr_wc[DEVICE_COUNT_RESOURCE]; /* sysfs file for WC mapping of resources */
> >  #ifdef CONFIG_PCI_MSI
> >  	struct list_head msi_list;
> > +	struct kset *msi_kset;
> 
> Probably should be guarded by CONFIG_SYSFS
> 
Nope, see above.

