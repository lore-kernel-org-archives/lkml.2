Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758479Ab0EMRna (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 13:43:30 -0400
Received: from sous-sol.org ([216.99.217.87]:54956 "EHLO sequoia.sous-sol.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755915Ab0EMRn2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 13:43:28 -0400
Date: Thu, 13 May 2010 10:43:07 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Chris Wright <chrisw@sous-sol.org>, greg@kroah.com,
       jbarnes@virtuousgeek.org, matthew@wil.cx, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org, kvm@vger.kernel.org, ddutile@redhat.com,
       alex.williamson@redhat.com
Subject: [PATCH 2/2 v2] pci: check caps from sysfs file open to read device
 dependent config space
Message-ID: <20100513174307.GH28034@sequoia.sous-sol.org>
References: <20100513012857.GA28034@sequoia.sous-sol.org>
 <20100513012957.GB28034@sequoia.sous-sol.org>
 <20100513105911.6469c434@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100513105911.6469c434@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Alan Cox (alan@lxorguk.ukuu.org.uk) wrote:
> I agree with the problem - but IMHO the fix is to require opening the file
> checks CAP_SYS_something instead: not to hack the read method and make it
> even weirder and more un-Linux than it is now.

This patch does that.  Not as convenient from the KVM/libvirt point of view
because it is not prepared to do this setup before dropping privileges
and launching the VM.

thanks,
-chris
--

From: Chris Wright <chrisw@sous-sol.org>
Subject: [PATCH 2/2 v2] pci: check caps from sysfs file open to read device dependent config space

The PCI config space bin_attr read handler has a hardcoded CAP_SYS_ADMIN
check to verify privileges before allowing a user to read device
dependent config space.  This is meant to protect from an unprivileged
user potentially locking up the box.

When assigning a PCI device directly to a guest with libvirt and KVM,
the sysfs config space file is chown'd to the unprivileged user that
the KVM guest will run as.  The guest needs to have full access to the
device's config space since it's responsible for driving the device.
However, despite being the owner of the sysfs file, the CAP_SYS_ADMIN
check will not allow read access beyond the config header.

With this patch we check privileges against the capabilities used when
openining the sysfs file.  The allows a privileged process to open the
file and hand it to an unprivileged process, and the unprivileged process
can still read all of the config space.

Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 drivers/pci/pci-sysfs.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
index ad44557..6309c5a 100644
--- a/drivers/pci/pci-sysfs.c
+++ b/drivers/pci/pci-sysfs.c
@@ -21,6 +21,7 @@
 #include <linux/stat.h>
 #include <linux/topology.h>
 #include <linux/mm.h>
+#include <linux/fs.h>
 #include <linux/capability.h>
 #include <linux/pci-aspm.h>
 #include <linux/slab.h>
@@ -367,7 +368,7 @@ pci_read_config(struct file *filp, struct kobject *kobj,
 	u8 *data = (u8*) buf;
 
 	/* Several chips lock up trying to read undefined config space */
-	if (capable(CAP_SYS_ADMIN)) {
+	if (cap_raised(filp->f_cred->cap_effective, CAP_SYS_ADMIN)) {
 		size = dev->cfg_size;
 	} else if (dev->hdr_type == PCI_HEADER_TYPE_CARDBUS) {
 		size = 128;
-- 
1.6.5.2
