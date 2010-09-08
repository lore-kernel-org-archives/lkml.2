Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756638Ab0IHAcp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 20:32:45 -0400
Received: from sous-sol.org ([216.99.217.87]:34573 "EHLO sequoia.sous-sol.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752292Ab0IHAco (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 20:32:44 -0400
X-Greylist: delayed 392 seconds by postgrey-1.27 at vger.kernel.org; Tue, 07 Sep 2010 20:32:43 EDT
Date: Tue, 7 Sep 2010 17:25:20 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Cam Macdonell <cam@cs.ualberta.ca>
Cc: Avi Kivity <avi@redhat.com>,
        "qemu-devel@nongnu.org Developers" <qemu-devel@nongnu.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Chris Wright <chrisw@redhat.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>, linux-pci@vger.kernel.org
Subject: [PATCH] pci: fix pci_resource_alignment prototype
Message-ID: <20100908002520.GM30129@sequoia.sous-sol.org>
References: <AANLkTimk19OmkNYvVemxgyFfgByNDDq6R2fa6=FQ8H9L@mail.gmail.com>
 <4C83CA5A.7030404@redhat.com>
 <AANLkTimtATH7JvBRXBbnr0hJ5bFrtOa_3vsZRe4a_rfR@mail.gmail.com>
 <AANLkTim9EOUVuSq6Z3q6-j-x2w+JDD8F-_xH614uDFi8@mail.gmail.com>
 <AANLkTimGui3atGAa-FE=6JhF1rM7BU0xtN-T4mZKqD8_@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTimGui3atGAa-FE=6JhF1rM7BU0xtN-T4mZKqD8_@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cam Macdonell <cam@cs.ualberta.ca>

* Cam Macdonell (cam@cs.ualberta.ca) wrote:
> It seems it was the alignment value being passed back from
> pci_resource_alignment().  The return type is an int, which was
> causing value of 2GB to be sign extended to to 0xffffffff80000000.
> Changing the return type to resource_size_t allows BAR values >= 2GB
> to be successfully assigned.
<snip>
> -static inline int pci_resource_alignment(struct pci_dev *dev,
> +static inline resource_size_t pci_resource_alignment(struct pci_dev *dev,
>                                          struct resource *res)

Yes, that's my mistake.  Thanks for debugging the issue Cam.
This fixes the prototype for both pci_resource_alignment() and
pci_sriov_resource_alignment().

Patch started as debugging effort from Cam Macdonell.

Cc: Cam Macdonell <cam@cs.ualberta.ca>
Cc: Avi Kivity <avi@redhat.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
[chrisw: add iov bits]
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 drivers/pci/iov.c |    2 +-
 drivers/pci/pci.h |    5 +++--
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/pci/iov.c b/drivers/pci/iov.c
index ce6a366..553d8ee 100644
--- a/drivers/pci/iov.c
+++ b/drivers/pci/iov.c
@@ -608,7 +608,7 @@ int pci_iov_resource_bar(struct pci_dev *dev, int resno,
  * the VF BAR size multiplied by the number of VFs.  The alignment
  * is just the VF BAR size.
  */
-int pci_sriov_resource_alignment(struct pci_dev *dev, int resno)
+resource_size_t pci_sriov_resource_alignment(struct pci_dev *dev, int resno)
 {
 	struct resource tmp;
 	enum pci_bar_type type;
diff --git a/drivers/pci/pci.h b/drivers/pci/pci.h
index 679c39d..5d0aeb1 100644
--- a/drivers/pci/pci.h
+++ b/drivers/pci/pci.h
@@ -262,7 +262,8 @@ extern int pci_iov_init(struct pci_dev *dev);
 extern void pci_iov_release(struct pci_dev *dev);
 extern int pci_iov_resource_bar(struct pci_dev *dev, int resno,
 				enum pci_bar_type *type);
-extern int pci_sriov_resource_alignment(struct pci_dev *dev, int resno);
+extern resource_size_t pci_sriov_resource_alignment(struct pci_dev *dev,
+						    int resno);
 extern void pci_restore_iov_state(struct pci_dev *dev);
 extern int pci_iov_bus_range(struct pci_bus *bus);
 
@@ -318,7 +319,7 @@ static inline int pci_ats_enabled(struct pci_dev *dev)
 }
 #endif /* CONFIG_PCI_IOV */
 
-static inline int pci_resource_alignment(struct pci_dev *dev,
+static inline resource_size_t pci_resource_alignment(struct pci_dev *dev,
 					 struct resource *res)
 {
 #ifdef CONFIG_PCI_IOV

