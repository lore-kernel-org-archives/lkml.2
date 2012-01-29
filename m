Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752954Ab2A2NL4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jan 2012 08:11:56 -0500
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:51340 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752134Ab2A2NLy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jan 2012 08:11:54 -0500
Date: Sun, 29 Jan 2012 18:41:39 +0530
From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ram Pai <linuxram@us.ibm.com>, Jesse Barnes <jbarnes@virtuousgeek.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [BUGFIX][PATCH] pci: check for 4k resource_size alignment in
 sriov_init
Message-ID: <20120129131139.GA19049@dirshya.in.ibm.com>
Reply-To: svaidy@linux.vnet.ibm.com
References: <20120127191032.GA22999@dirshya.in.ibm.com>
 <CAE9FiQVKLmrryoOhyjr_rGucGGZLW=PSD=s_AjW0Za6vHCvOtg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAE9FiQVKLmrryoOhyjr_rGucGGZLW=PSD=s_AjW0Za6vHCvOtg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 12012913-5564-0000-0000-00000125CBCD
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Yinghai Lu <yinghai@kernel.org> [2012-01-27 13:05:41]:

> On Fri, Jan 27, 2012 at 11:10 AM, Vaidyanathan Srinivasan
> <svaidy@linux.vnet.ibm.com> wrote:
> > Hi Ram and Jesse,
> >
> > I found a trivial issue with page size alignment check on IBM POWER
> > box with 64k base page size.  In sriov_init(), changing the check from
> > PAGE_SIZE (arch and config dependent) to HW_PAGE_SIZE (always 4k) was
> > required to use one of the sriov adapter as PF since the
> > resource_size() comes up as 0x8000 and PAGE_SIZE would be 0x10000 for
> > pseries boxes.
> >
> > I think resource_size() could be less than SystemPageSize, but I would
> > like your comments/ack/nack on any consequences of checking for only
> > 4k alignment here in a system with larger base page size.
> >
> > Thanks,
> > Vaidy
> >
> > ---
> >
> >    pci: check for 4k resource_size alignment in sriov_init
> >
> >    pci sriov_init should check for 4k page size alignment of resource_size
> >    even if base page size is larger -- like 64k in powerpc.
> >
> >    Signed-off-by: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
> >
> > diff --git a/drivers/pci/iov.c b/drivers/pci/iov.c
> > index 0321fa3..5816fa0 100644
> > --- a/drivers/pci/iov.c
> > +++ b/drivers/pci/iov.c
> > @@ -474,7 +474,7 @@ found:
> >                                     pos + PCI_SRIOV_BAR + i * 4);
> >                if (!res->flags)
> >                        continue;
> > -               if (resource_size(res) & (PAGE_SIZE - 1)) {
> > +               if (resource_size(res) & (HW_PAGE_SIZE - 1)) {
> >                        rc = -EIO;
> >                        goto failed;
> >                }
> >
> 
> but HW_PAGE_SIZE is only defined for powerpc.

My bad, I picked the #define used in other powerpc code.

> also there is PAGE_SHIFT around in that function.

This gets defined correctly if CONFIG_PPC_64K_PAGES=y.  But the actual
problem is the need for a generic 4K #define for x86 and other archs.

> maybe you can just define another MARCO according to IOV spec?

This is a good idea.  I could not find an IOV specific requirement.
The resource size has to be a multiple of 4K so that the overall
resource-size() * PCI_SRIOV_TOTAL_VF will be a multiple of 4K or more.

Let me share a patch that has a simple #define in drivers/pci/pci.h,
which is needed to get SRIOV cards started on powerpc box.

--Vaidy

---

    pci: check for 4k resource_size alignment in sriov_init
    
    pci sriov_init should check for 4k page size alignment of resource_size
    even if base page size is larger like 64k in powerpc.
    
    Signed-off-by: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>

diff --git a/drivers/pci/iov.c b/drivers/pci/iov.c
index 0321fa3..10adede 100644
--- a/drivers/pci/iov.c
+++ b/drivers/pci/iov.c
@@ -474,7 +474,7 @@ found:
 				     pos + PCI_SRIOV_BAR + i * 4);
 		if (!res->flags)
 			continue;
-		if (resource_size(res) & (PAGE_SIZE - 1)) {
+		if (resource_size(res) & (HW_PAGE_SIZE_4K - 1)) {
 			rc = -EIO;
 			goto failed;
 		}
diff --git a/drivers/pci/pci.h b/drivers/pci/pci.h
index 1009a5e..68703ab 100644
--- a/drivers/pci/pci.h
+++ b/drivers/pci/pci.h
@@ -6,6 +6,9 @@
 #define PCI_CFG_SPACE_SIZE	256
 #define PCI_CFG_SPACE_EXP_SIZE	4096
 
+/* Constants used in the PCI core code */
+#define HW_PAGE_SIZE_4K		0x1000
+
 /* Functions internal to the PCI core code */
 
 extern int pci_uevent(struct device *dev, struct kobj_uevent_env *env);

