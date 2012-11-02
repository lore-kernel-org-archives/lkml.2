Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933287Ab2KBRxY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 13:53:24 -0400
Received: from smtp.snhosting.dk ([87.238.248.203]:54710 "EHLO
	smtp.domainteam.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932260Ab2KBRxX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 13:53:23 -0400
Date: Fri, 2 Nov 2012 18:53:21 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Andreas Larsson <andreas@gaisler.com>
Cc: Grant Likely <grant.likely@secretlab.ca>, davem@davemloft.net,
        Rob Herring <rob.herring@calxeda.com>, sparclinux@vger.kernel.org,
        software@gaisler.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] of/address: sparc: Declare of_address_to_resource() as
	an extern function for sparc again
Message-ID: <20121102175321.GA6720@merkur.ravnborg.org>
References: <1351854236-14230-1-git-send-email-andreas@gaisler.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1351854236-14230-1-git-send-email-andreas@gaisler.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andreas.
On Fri, Nov 02, 2012 at 12:03:56PM +0100, Andreas Larsson wrote:
> This bug-fix makes sure that of_address_to_resource is defined extern for sparc
> so that the sparc-specific implementation of of_address_to_resource() is once
> again used when including include/linux/of_address.h in a sparc context. A
> number of drivers in mainline relies on this function working for sparc.

How about following (untested) approach.
diff --git a/arch/sparc/include/asm/prom.h b/arch/sparc/include/asm/prom.h
index c287651..8194801 100644
--- a/arch/sparc/include/asm/prom.h
+++ b/arch/sparc/include/asm/prom.h
@@ -63,5 +63,8 @@ extern char *of_console_options;
 extern void irq_trans_init(struct device_node *dp);
 extern char *build_path_component(struct device_node *dp);
 
+/* SPARC has a local implementation */
+#define of_address_to_resource of_address_to_resource
+
 #endif /* __KERNEL__ */
 #endif /* _SPARC_PROM_H */
diff --git a/include/linux/of_address.h b/include/linux/of_address.h
index a1984dd..e20e3af 100644
--- a/include/linux/of_address.h
+++ b/include/linux/of_address.h
@@ -28,11 +28,13 @@ static inline unsigned long pci_address_to_pio(phys_addr_t addr) { return -1; }
 #endif
 
 #else /* CONFIG_OF_ADDRESS */
+#ifndef of_address_to_resource
 static inline int of_address_to_resource(struct device_node *dev, int index,
 					 struct resource *r)
 {
 	return -EINVAL;
 }
+#endif
 static inline struct device_node *of_find_matching_node_by_address(
 					struct device_node *from,
 					const struct of_device_id *matches,

We use prom.h to teach the general of layer what SPARC provides.
In prom.h we define the symbol of_address_to_resource which tell
of_address.h that we have a local definition of this function, and
the static version is skipped.

This looks more elegant as we do not have to hardcode SPARC in of_address.h
and this is easy to re-use the sme pattern in other places.

Also pci_address_to_pio already uses the same approach in the same file.
pci_address_to_pio is defined if it was not defined before - I see no
reason to do so which is why I omitted it in the above.

	Sam
