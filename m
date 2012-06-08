Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762159Ab2FHQmG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 12:42:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50514 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751931Ab2FHQmB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 12:42:01 -0400
Message-ID: <1339173706.26976.91.camel@ul30vt>
Subject: Re: [PATCH] uio_pci_generic does not export memory resources
From: Alex Williamson <alex.williamson@redhat.com>
To: Andreas Hartmann <andihartmann@01019freenet.de>
Cc: Dominic Eschweiler <eschweiler@fias.uni-frankfurt.de>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        "Hans J. Koch" <hjk@hansjkoch.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Fri, 08 Jun 2012 10:41:46 -0600
In-Reply-To: <4FD22552.6090609@01019freenet.de>
References: <1339156616.3870.9.camel@blech>
	  <20120608130351.GB1964@redhat.com> <4FD1FB49.3020905@siemens.com>
	  <1339165009.26976.60.camel@ul30vt> <1339166867.3870.29.camel@blech>
	 <4FD22552.6090609@01019freenet.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-06-08 at 18:16 +0200, Andreas Hartmann wrote:
> Hi Dominic,
> 
> Dominic Eschweiler wrote:
> > Am Freitag, den 08.06.2012, 08:16 -0600 schrieb Alex Williamson:
> >> Yes, thanks Jan.  This is exactly what VFIO does.  VFIO provides
> >> secure config space access, resource access, DMA mapping services, and
> >> full interrupt support to userspace.  
> > 
> > I know about VFIO, but we need some support for that stuff relatively
> > soon. That's the reason why I'm currently working on it to make UIO DMA
> > capable. My extensions probably do not play well with IOMMUs and they
> > therefore won't make it to mainline anyhow (i learned that today ;-).
> 
> I'm not sure if vfio covers your needs completely, but I tested it here
> very successfully. I was able to create a patch, which can be applied to
> opensuse 3.4.1 kernel and which seams to run well.
> 
> I even managed to integrate it into libvirt :-). So it is usable as
> every other traditional VM, too.

Oh, please post the patch for libvirt!

> Besides the problem with AMD IOMMU, which requires to unbind a whole
> group of devices in some cases (PCI passthrough - not PCIe), it's really
> cool! And it's usable now!

If you're feeling adventurous (and know that this may not make it
upstream), you can do something like this:

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index ab0dba0..5c26804 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -3161,11 +3161,22 @@ struct pci_dev *pci_get_dma_source(struct pci_dev *dev)
        return pci_dev_get(dev);
 }
 
+static int pci_func_supports_acs(struct pci_dev *dev, u16 acs_flags)
+{
+       return 1;
+}
+
 static const struct pci_dev_acs_enabled {
        u16 vendor;
        u16 device;
        int (*acs_enabled)(struct pci_dev *dev, u16 acs_flags);
 } pci_dev_acs_enabled[] = {
+       { 0x1002, 0x4385, pci_func_supports_acs },
+       { 0x1002, 0x439c, pci_func_supports_acs },
+       { 0x1002, 0x4383, pci_func_supports_acs },
+       { 0x1002, 0x439d, pci_func_supports_acs },
+       { 0x1002, 0x4384, pci_func_supports_acs },
+       { 0x1002, 0x4399, pci_func_supports_acs },
        { 0 }
 };

Hmm, I wonder if we should make a kernel boot parameter that allows
whitelisting some devices.  I think it would have to taint the kernel
but there's probably sufficient interest for usability vs
supportability.  Thanks,

Alex

