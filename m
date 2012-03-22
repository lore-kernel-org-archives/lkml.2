Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754925Ab2CVFf4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 01:35:56 -0400
Received: from gate.crashing.org ([63.228.1.57]:50664 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754488Ab2CVFfx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 01:35:53 -0400
Message-ID: <1332394515.2982.76.camel@pasglop>
Subject: Re: [PATCH] EEH: remove eeh device from OF node
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Gavin Shan <shangw@linux.vnet.ibm.com>
Cc: sfr@canb.auug.org.au, grant.likely@secretlab.ca,
        linux-kernel@vger.kernel.org, linux-next@vger.kernel.org,
        paulus@samba.org, linuxppc-dev@lists.ozlabs.org
Date: Thu, 22 Mar 2012 16:35:15 +1100
In-Reply-To: <20120322032819.GA4689@shangw>
References: <1331721086-4314-1-git-send-email-shangw@linux.vnet.ibm.com>
	 <1332288866.2982.33.camel@pasglop> <20120322032819.GA4689@shangw>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-03-22 at 11:28 +0800, Gavin Shan wrote:

> > 1- ASAP so we can still get that into 3.4, move the eeh_dev pointer to
> >struct pci_dn instead of struct device_node. This structure is
> >accessible directly via dn->data and is ppc specific, that will be a
> >better temporary solution and and adding stuff to the generic struct
> >device_node.
> >
> 
> I've sent patch again it and please take a look when you have time.

All I see is your patch that does the lookup, I missed the patch to move
it to pci_dn, can you re-send that to me directly ?

Thanks !

Cheers,
Ben.

> > 2- Then, what we need to do is generalize the use of eeh_dev rather
> >than device_node as the main object being worked on in the eeh layer and
> >thus as the argument to most functions.
> >
> >Cheers,
> >Ben.
> >
> 
> Thanks,
> Gavin
> 
> >> Signed-off-by: Gavin Shan <shangw@linux.vnet.ibm.com>
> >> ---
> >>  arch/powerpc/include/asm/eeh.h           |    7 +++++++
> >>  arch/powerpc/platforms/pseries/eeh_dev.c |   29 ++++++++++++++++++++++++++++-
> >>  include/linux/of.h                       |   10 ----------
> >>  3 files changed, 35 insertions(+), 11 deletions(-)
> >> 
> >> diff --git a/arch/powerpc/include/asm/eeh.h b/arch/powerpc/include/asm/eeh.h
> >> index d60f998..591e0a1 100644
> >> --- a/arch/powerpc/include/asm/eeh.h
> >> +++ b/arch/powerpc/include/asm/eeh.h
> >> @@ -56,6 +56,7 @@ struct eeh_dev {
> >>  	struct pci_controller *phb;	/* Associated PHB		*/
> >>  	struct device_node *dn;		/* Associated device node	*/
> >>  	struct pci_dev *pdev;		/* Associated PCI device	*/
> >> +	struct list_head list;		/* Form the global link list	*/
> >>  };
> >>  
> >>  static inline struct device_node *eeh_dev_to_of_node(struct eeh_dev *edev)
> >> @@ -115,6 +116,7 @@ extern int eeh_subsystem_enabled;
> >>   */
> >>  #define EEH_MAX_ALLOWED_FREEZES 5
> >>  
> >> +struct eeh_dev *eeh_dev_from_of_node(struct device_node *dn);
> >>  void * __devinit eeh_dev_init(struct device_node *dn, void *data);
> >>  void __devinit eeh_dev_phb_init_dynamic(struct pci_controller *phb);
> >>  void __init eeh_dev_phb_init(void);
> >> @@ -132,6 +134,11 @@ void eeh_add_device_tree_early(struct device_node *);
> >>  void eeh_add_device_tree_late(struct pci_bus *);
> >>  void eeh_remove_bus_device(struct pci_dev *);
> >>  
> >> +static inline struct eeh_dev *of_node_to_eeh_dev(struct device_node *dn)
> >> +{
> >> +	return eeh_dev_from_of_node(dn);
> >> +}
> >> +
> >>  /**
> >>   * EEH_POSSIBLE_ERROR() -- test for possible MMIO failure.
> >>   *
> >> diff --git a/arch/powerpc/platforms/pseries/eeh_dev.c b/arch/powerpc/platforms/pseries/eeh_dev.c
> >> index f3aed7d..925d3a3 100644
> >> --- a/arch/powerpc/platforms/pseries/eeh_dev.c
> >> +++ b/arch/powerpc/platforms/pseries/eeh_dev.c
> >> @@ -34,6 +34,7 @@
> >>  #include <linux/export.h>
> >>  #include <linux/gfp.h>
> >>  #include <linux/init.h>
> >> +#include <linux/list.h>
> >>  #include <linux/kernel.h>
> >>  #include <linux/pci.h>
> >>  #include <linux/string.h>
> >> @@ -41,6 +42,30 @@
> >>  #include <asm/pci-bridge.h>
> >>  #include <asm/ppc-pci.h>
> >>  
> >> +/* eeh device list */
> >> +static LIST_HEAD(eeh_dev_list);
> >> +
> >> +/**
> >> + * eeh_dev_from_of_node - Retrieve EEH device according to OF node
> >> + * @dn: OF node
> >> + *
> >> + * All existing eeh devices have been put into the global list.
> >> + * In addition, the eeh device is tracing the corresponding
> >> + * OF node. The function is used to retrieve the corresponding
> >> + * eeh device according to the given OF node.
> >> + */
> >> +struct eeh_dev *eeh_dev_from_of_node(struct device_node *dn)
> >> +{
> >> +	struct eeh_dev *edev = NULL;
> >> +
> >> +	list_for_each_entry(edev, &eeh_dev_list, list) {
> >> +		if (edev->dn && edev->dn == dn)
> >> +			return edev;
> >> +	}
> >> +
> >> +	return NULL;
> >> +}
> >> +
> >>  /**
> >>   * eeh_dev_init - Create EEH device according to OF node
> >>   * @dn: device node
> >> @@ -62,10 +87,12 @@ void * __devinit eeh_dev_init(struct device_node *dn, void *data)
> >>  	}
> >>  
> >>  	/* Associate EEH device with OF node */
> >> -	dn->edev  = edev;
> >>  	edev->dn  = dn;
> >>  	edev->phb = phb;
> >>  
> >> +	/* Add to global list */
> >> +	list_add_tail(&edev->list, &eeh_dev_list);
> >> +
> >>  	return NULL;
> >>  }
> >>  
> >> diff --git a/include/linux/of.h b/include/linux/of.h
> >> index 3e710d8..a75a831 100644
> >> --- a/include/linux/of.h
> >> +++ b/include/linux/of.h
> >> @@ -58,9 +58,6 @@ struct device_node {
> >>  	struct	kref kref;
> >>  	unsigned long _flags;
> >>  	void	*data;
> >> -#if defined(CONFIG_EEH)
> >> -	struct eeh_dev *edev;
> >> -#endif
> >>  #if defined(CONFIG_SPARC)
> >>  	char	*path_component_name;
> >>  	unsigned int unique_id;
> >> @@ -75,13 +72,6 @@ struct of_phandle_args {
> >>  	uint32_t args[MAX_PHANDLE_ARGS];
> >>  };
> >>  
> >> -#if defined(CONFIG_EEH)
> >> -static inline struct eeh_dev *of_node_to_eeh_dev(struct device_node *dn)
> >> -{
> >> -	return dn->edev;
> >> -}
> >> -#endif
> >> -
> >>  #if defined(CONFIG_SPARC) || !defined(CONFIG_OF)
> >>  /* Dummy ref counting routines - to be implemented later */
> >>  static inline struct device_node *of_node_get(struct device_node *node)
> >
> >


