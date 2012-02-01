Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755018Ab2BAGWd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 01:22:33 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:59101 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753605Ab2BAGWb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 01:22:31 -0500
Date: Wed, 1 Feb 2012 14:21:45 +0800
From: Ram Pai <linuxram@us.ibm.com>
To: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Cc: Ram Pai <linuxram@us.ibm.com>, Jesse Barnes <jbarnes@virtuousgeek.org>,
        Yinghai Lu <yinghai.lu@oracle.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [BUGFIX][PATCH] pci: check for 4k resource_size alignment in
 sriov_init
Message-ID: <20120201062145.GA11505@ram-ThinkPad-T61>
Reply-To: Ram Pai <linuxram@us.ibm.com>
References: <20120127191032.GA22999@dirshya.in.ibm.com>
 <20120130031845.GA2359@ram-ThinkPad-T61>
 <20120131174402.GA6172@dirshya.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120131174402.GA6172@dirshya.in.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12020106-5112-0000-0000-0000049853B3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 31, 2012 at 11:14:02PM +0530, Vaidyanathan Srinivasan wrote:
> * Ram Pai <linuxram@us.ibm.com> [2012-01-30 11:18:45]:
> 
> > On Sat, Jan 28, 2012 at 12:40:32AM +0530, Vaidyanathan Srinivasan wrote:
> > > Hi Ram and Jesse,
> > > 
> > > I found a trivial issue with page size alignment check on IBM POWER
> > > box with 64k base page size.  In sriov_init(), changing the check from
> > > PAGE_SIZE (arch and config dependent) to HW_PAGE_SIZE (always 4k) was
> > > required to use one of the sriov adapter as PF since the
> > > resource_size() comes up as 0x8000 and PAGE_SIZE would be 0x10000 for
> > > pseries boxes.
> > > 
> > > I think resource_size() could be less than SystemPageSize, but I would
> > > like your comments/ack/nack on any consequences of checking for only
> > > 4k alignment here in a system with larger base page size.
> > 
> > As per the SRIOV specs, the  resource has to be System page size aligned.
> > 
> > PFs are required to support 4-KB, 8-KB, 64-KB, 256-KB, 1-MB, and 4-MB
> > page sizes. In your case if your adapter's PF is not supporting 64K page size
> > then I think it is not conforming to the PCI SRIOV spec.
> 
> Hi Ram,
> 
> Thanks for the pointer.  I did some more experiments and found that
> the card does support 64k page size, but the PCI_SRIOV_SYS_PGSIZE was
> set to default 4k when we do the query and check resource_size().
> 
> You were correct, the resource_size() has to come up with 64k on 64k
> PAGE_SIZE system.  We should not change that check.  I was able to
> get a working solution by setting PCI_SRIOV_SYS_PGSIZE to 64k before
> we do the query.
> 
> This was the case in the original code before you moved these to
> sriov_enable().  If it is ok to leave the SYS_PGSIZE setting in
> sriov_init(), then I have the following fix that works for me.
> 
> Please review and let me know your comments.
> 
> Thanks,
> Vaidy
> ---
> 
>     	pci: set pci sriov page size before reading sriov bar
>     
>     	For an SRIOV device, PCI_SRIOV_SYS_PGSIZE should be set before
>     	the PCI_SRIOV_BAR is queried.  The sys pagesize defaults to 4k,
>     	so this change is required on powerpc box with 64k base page size.
>     
>     	This is a regression caused due to moving SRIOV init to sriov_enable().
>     
>     	| commit afd24ece5c76af87f6fc477f2747b83a764f161c
>     	| Author: Ram Pai <linuxram@us.ibm.com>
>     
>     	| PCI: delay configuration of SRIOV capability
>     	| The SRIOV capability, namely page size and total_vfs of a device are
>     	| configured during enumeration phase of the device.  This can potentially
>     	| interfere with the PCI operations of the platform, if the IOV capability
>     	| of the device is not enabled.
>     
>     Signed-off-by: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
> 
> diff --git a/drivers/pci/iov.c b/drivers/pci/iov.c
> index 0321fa3..0dab5ec 100644
> --- a/drivers/pci/iov.c
> +++ b/drivers/pci/iov.c
> @@ -347,8 +347,6 @@ static int sriov_enable(struct pci_dev *dev, int nr_virtfn)
>  			return rc;
>  	}
> 
> -	pci_write_config_dword(dev, iov->pos + PCI_SRIOV_SYS_PGSIZE, iov->pgsz);
> -
>  	iov->ctrl |= PCI_SRIOV_CTRL_VFE | PCI_SRIOV_CTRL_MSE;
>  	pci_cfg_access_lock(dev);
>  	pci_write_config_word(dev, iov->pos + PCI_SRIOV_CTRL, iov->ctrl);
> @@ -466,6 +464,7 @@ found:
>  		return -EIO;
> 
>  	pgsz &= ~(pgsz - 1);
> +	pci_write_config_dword(dev, pos + PCI_SRIOV_SYS_PGSIZE, pgsz);
> 
>  	nres = 0;
>  	for (i = 0; i < PCI_SRIOV_NUM_BARS; i++) {


ACK. I think it is better to revert  afd24ece5c76af87f6fc477f2747b83a764f161c.

RP

