Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754075Ab2KHBXS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 20:23:18 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:40671 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750720Ab2KHBXQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 20:23:16 -0500
Date: Wed, 7 Nov 2012 20:10:06 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Matthew Fioravante <matthew.fioravante@jhuapl.edu>
Cc: Kent Yoder <key@linux.vnet.ibm.com>, "mail@srajiv.net" <mail@srajiv.net>,
        "jeremy@goop.org" <jeremy@goop.org>,
        "tpmdd-devel@lists.sourceforge.net" 
	<tpmdd-devel@lists.sourceforge.net>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] add tpm_xenu.ko: Xen Virtual TPM frontend driver
Message-ID: <20121108011006.GC21302@phenom.dumpdata.com>
References: <1352128197-1539-1-git-send-email-matthew.fioravante@jhuapl.edu>
 <20121107144625.GA14628@ennui.austin.ibm.com>
 <509AA501.1090701@jhuapl.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <509AA501.1090701@jhuapl.edu>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 07, 2012 at 01:14:25PM -0500, Matthew Fioravante wrote:
> On 11/07/2012 09:46 AM, Kent Yoder wrote:
> >Hi Matthew,
> >
> >On Mon, Nov 05, 2012 at 10:09:57AM -0500, Matthew Fioravante wrote:
> >>This patch ports the xen vtpm frontend driver for linux
> >>from the linux-2.6.18-xen.hg tree to linux-stable.
> >>
> >>Signed-off-by: Matthew Fioravante <matthew.fioravante@jhuapl.edu>
> >>---
> >>  drivers/char/tpm/Kconfig         |    9 +
> >>  drivers/char/tpm/Makefile        |    2 +
> >>  drivers/char/tpm/tpm.h           |   15 +
> >>  drivers/char/tpm/tpm_vtpm.c      |  543 ++++++++++++++++++++++++++++++
> >>  drivers/char/tpm/tpm_vtpm.h      |   55 +++
> >>  drivers/char/tpm/tpm_xen.c       |  690 ++++++++++++++++++++++++++++++++++++++
> >>  include/xen/interface/io/tpmif.h |   77 +++++
> >>  7 files changed, 1391 insertions(+)
> >>  create mode 100644 drivers/char/tpm/tpm_vtpm.c
> >>  create mode 100644 drivers/char/tpm/tpm_vtpm.h
> >>  create mode 100644 drivers/char/tpm/tpm_xen.c
> >>  create mode 100644 include/xen/interface/io/tpmif.h
> >>
> >>diff --git a/drivers/char/tpm/Kconfig b/drivers/char/tpm/Kconfig
> >>index 915875e..08c1010 100644
> >>--- a/drivers/char/tpm/Kconfig
> >>+++ b/drivers/char/tpm/Kconfig
> >>@@ -81,4 +81,13 @@ config TCG_IBMVTPM
> >>  	  will be accessible from within Linux.  To compile this driver
> >>  	  as a module, choose M here; the module will be called tpm_ibmvtpm.
> >>
> >>+config TCG_XEN
> >>+	tristate "XEN TPM Interface"
> >>+	depends on TCG_TPM && XEN
> >>+	---help---
> >>+	  If you want to make TPM support available to a Xen user domain,
> >>+	  say Yes and it will be accessible from within Linux.
> >>+	  To compile this driver as a module, choose M here; the module
> >>+	  will be called tpm_xenu.
> >>+
> >>  endif # TCG_TPM
> >>diff --git a/drivers/char/tpm/Makefile b/drivers/char/tpm/Makefile
> >>index 5b3fc8b..16911c5 100644
> >>--- a/drivers/char/tpm/Makefile
> >>+++ b/drivers/char/tpm/Makefile
> >>@@ -17,3 +17,5 @@ obj-$(CONFIG_TCG_NSC) += tpm_nsc.o
> >>  obj-$(CONFIG_TCG_ATMEL) += tpm_atmel.o
> >>  obj-$(CONFIG_TCG_INFINEON) += tpm_infineon.o
> >>  obj-$(CONFIG_TCG_IBMVTPM) += tpm_ibmvtpm.o
> >>+obj-$(CONFIG_TCG_XEN) += tpm_xenu.o
> >>+tpm_xenu-y = tpm_xen.o tpm_vtpm.o
> >  Let's match the naming convention of the other drivers if we can, so this
> >would be something like tpm_xenvtpm.c. tpm_vtpm is too generic...
> Makes sense, fixed.
> >
> >>diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
> >>index 8ef7649..2e5a47a 100644
> >>--- a/drivers/char/tpm/tpm.h
> >>+++ b/drivers/char/tpm/tpm.h
> >>@@ -130,6 +130,9 @@ struct tpm_chip {
> >>
> >>  	struct list_head list;
> >>  	void (*release) (struct device *);
> >>+#if CONFIG_XEN
> >>+	void *priv;
> >>+#endif
> >  Can you use the chip->vendor.data pointer here instead? tpm_ibmvtpm is
> >already using that as a priv pointer. I should probably change that name
> >to make it more obvious what that's used for.
> That makes more sense. I'm guessing your data pointer didn't exist
> during the 2.6.18 kernel which is why they added their own priv
> pointer.
> >
> >>  };
> >>
> >>  #define to_tpm_chip(n) container_of(n, struct tpm_chip, vendor)
> >>@@ -310,6 +313,18 @@ struct tpm_cmd_t {
> >>
> >>  ssize_t	tpm_getcap(struct device *, __be32, cap_t *, const char *);
> >>
> >>+#ifdef CONFIG_XEN
> >>+static inline void *chip_get_private(const struct tpm_chip *chip)
> >>+{
> >>+	return chip->priv;
> >>+}
> >>+
> >>+static inline void chip_set_private(struct tpm_chip *chip, void *priv)
> >>+{
> >>+	chip->priv = priv;
> >>+}
> >>+#endif
> >  Can you put these in tpm_vtpm.c please?  One less #define. :-)
> Agreed, I'd rather not have to modify your shared tpm.h interface at all.
> >
> >[cut]
> >>+#ifndef __XEN_PUBLIC_IO_TPMIF_H__
> >>+#define __XEN_PUBLIC_IO_TPMIF_H__
> >>+
> >>+#include "../grant_table.h"
> >>+
> >>+struct tpmif_tx_request {
> >>+	unsigned long addr;   /* Machine address of packet.   */
> >>+	grant_ref_t ref;      /* grant table access reference */
> >>+	uint16_t unused;
> >>+	uint16_t size;        /* Packet size in bytes.        */
> >>+};
> >>+typedef struct tpmif_tx_request tpmif_tx_request_t;
> >   checkpatch warned on this new typedef - please run through checkpatch
> >and fix up that stuff.
> tpmif.h has a couple of typedefs which do trigger checkpatch
> warnings. However it looks like the paradigm for xen is to have
> these interface/io/<dev>if.h files and all of them have typedefs. I
> think in this case the typedef should probably stay.
> 
> Konrad your thoughts here?

Rip them out plea

> >
> >>+
> >>+/*
> >>+ * The TPMIF_TX_RING_SIZE defines the number of pages the
> >>+ * front-end and backend can exchange (= size of array).
> >>+ */
> >>+typedef uint32_t TPMIF_RING_IDX;
> >>+
> >>+#define TPMIF_TX_RING_SIZE 1
> >>+
> >>+/* This structure must fit in a memory page. */
> >>+
> >>+struct tpmif_ring {
> >>+	struct tpmif_tx_request req;
> >>+};
> >>+typedef struct tpmif_ring tpmif_ring_t;
> >>+
> >>+struct tpmif_tx_interface {
> >>+	struct tpmif_ring ring[TPMIF_TX_RING_SIZE];
> >>+};
> >>+typedef struct tpmif_tx_interface tpmif_tx_interface_t;
> >>+
> >>+#endif
> >>+
> >>+/*
> >>+ * Local variables:
> >>+ * mode: C
> >>+ * c-set-style: "BSD"
> >>+ * c-basic-offset: 4
> >>+ * tab-width: 4
> >>+ * indent-tabs-mode: nil
> >>+ * End:
> >>+ */
> >   Please take this comment out, see Documentation/CodingStyle.
> Fixed
> >
> >Thanks,
> >Kent
> >
> >>-- 
> >>1.7.10.4
> >>
> >>
> 
> 


