Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752561Ab2CCEJe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 23:09:34 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:47879 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751486Ab2CCEJd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 23:09:33 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of grant.likely@secretlab.ca designates 10.68.190.42 as permitted sender) smtp.mail=grant.likely@secretlab.ca
MIME-Version: 1.0
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH] devicetree: Add empty of_platform_populate() for !CONFIG_OF_ADDRESS (sparc)
To: Andrew Morton <akpm@linux-foundation.org>,
        "Cousson, Benoit" <b-cousson@ti.com>
Cc: linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        Samuel Ortiz <sameo@linux.intel.com>
In-Reply-To: <20120302170715.9f0a67ef.akpm@linux-foundation.org>
References: <1330121218-10442-1-git-send-email-grant.likely@secretlab.ca> <4F513990.1030401@ti.com> <20120302170715.9f0a67ef.akpm@linux-foundation.org>
Date: Fri, 02 Mar 2012 21:09:30 -0700
Message-Id: <20120303040930.1E9283E190C@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2 Mar 2012 17:07:15 -0800, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Fri, 2 Mar 2012 22:20:16 +0100
> "Cousson, Benoit" <b-cousson@ti.com> wrote:
> 
> > Hi Grant,
> > 
> > In fact this patch is not working for build without CONFIG_OF like x86.
> > 
> > On 2/24/2012 11:06 PM, Grant Likely wrote:
> > > --- a/include/linux/of_platform.h
> > > +++ b/include/linux/of_platform.h
> > > @@ -81,7 +81,7 @@ extern struct platform_device *of_device_alloc(struct device_node *np,
> > >   					 struct device *parent);
> > >   extern struct platform_device *of_find_device_by_node(struct device_node *np);
> > >
> > > -#if !defined(CONFIG_SPARC) /* SPARC has its own device registration method */
> > > +#ifdef CONFIG_OF_ADDRESS /* device reg helpers depend on OF_ADDRESS */
> > >   /* Platform devices and busses creation */
> > >   extern struct platform_device *of_platform_device_create(struct device_node *np,
> > >   						   const char *bus_id,
> > > @@ -94,7 +94,15 @@ extern int of_platform_populate(struct device_node *root,
> > >   				const struct of_device_id *matches,
> > >   				const struct of_dev_auxdata *lookup,
> > >   				struct device *parent);
> > > -#endif /* !CONFIG_SPARC */
> > > +#else
> > > +static inline int of_platform_populate(struct device_node *root,
> > > +					const struct of_device_id *matches,
> > > +					const struct of_dev_auxdata *lookup,
> > > +					struct device *parent)
> > > +{
> > > +	return -ENODEV;
> > > +}
> > > +#endif /* !CONFIG_OF_ADDRESS */
> > >
> > >   #endif /* CONFIG_OF_DEVICE */
> > 
> > Because if CONFIG_OF_DEVICE is not defined, then the stub for 
> > of_platform_populate will not be defined either. It should exist for any 
> > config without CONFIG_OF.
> > 
> > Building twl4030 for x86 is actually broken.
> > 
> 
> All twl is broken.  i386 allmodconfig with this monring's linux-next:
> 
> drivers/mfd/twl-core.c: In function 'twl_probe':
> drivers/mfd/twl-core.c:1357: error: implicit declaration of function 'of_platform_populate'
> 

This patch seems to solve it finally against irqdomain/next.  Benoit, with
your ack I'll push it out.

g.

---

commit 679946dfdbf990d3e75418fdaf92f3981ff1f4db
Author: Grant Likely <grant.likely@secretlab.ca>
Date:   Fri Mar 2 21:05:31 2012 -0700

    dt: fix twl4030 for non-dt compile on x86
    
    twl4030 still doesn't build correctly for x86 allmodconfig.  This
    fix solves the missing symbol errors.
    
    Signed-off-by: Grant Likely <grant.likely@secretlab.ca>

diff --git a/drivers/mfd/twl-core.c b/drivers/mfd/twl-core.c
index 4970d43..54727ef 100644
--- a/drivers/mfd/twl-core.c
+++ b/drivers/mfd/twl-core.c
@@ -38,6 +38,7 @@
 #include <linux/of.h>
 #include <linux/of_irq.h>
 #include <linux/of_platform.h>
+#include <linux/irq.h>
 #include <linux/irqdomain.h>
 
 #include <linux/regulator/machine.h>
diff --git a/include/linux/of_platform.h b/include/linux/of_platform.h
index 242fa35..b47d204 100644
--- a/include/linux/of_platform.h
+++ b/include/linux/of_platform.h
@@ -94,7 +94,12 @@ extern int of_platform_populate(struct device_node *root,
 				const struct of_device_id *matches,
 				const struct of_dev_auxdata *lookup,
 				struct device *parent);
-#else
+#endif /* CONFIG_OF_ADDRESS */
+
+#endif /* CONFIG_OF_DEVICE */
+
+#if !defined(CONFIG_OF_ADDRESS)
+struct of_dev_auxdata;
 static inline int of_platform_populate(struct device_node *root,
 					const struct of_device_id *matches,
 					const struct of_dev_auxdata *lookup,
@@ -104,6 +109,4 @@ static inline int of_platform_populate(struct device_node *root,
 }
 #endif /* !CONFIG_OF_ADDRESS */
 
-#endif /* CONFIG_OF_DEVICE */
-
 #endif	/* _LINUX_OF_PLATFORM_H */
-- 
email sent from notmuch.vim plugin
