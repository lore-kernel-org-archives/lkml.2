Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752632Ab0LOGCf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 01:02:35 -0500
Received: from qmta06.emeryville.ca.mail.comcast.net ([76.96.30.56]:51978 "EHLO
	qmta06.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751256Ab0LOGCd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 01:02:33 -0500
Date: Tue, 14 Dec 2010 23:02:27 -0700
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, Len Brown <lenb@kernel.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@sisk.pl>, linux-acpi@vger.kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, Adam Belay <abelay@mit.edu>
Subject: Re: [PATCH 5/5] PNP: HP nx6325 fixup: reserve unreported resources
Message-ID: <20101215060227.GA2728@helgaas.com>
References: <20101208213606.13026.47657.stgit@bob.kio>
 <20101208213627.13026.18854.stgit@bob.kio>
 <AANLkTinhHkqpVQp10y6uRp9ug73iXRuF4Bed2okPOdit@mail.gmail.com>
 <20101212061743.GA4974@helgaas.com>
 <AANLkTikogB78xPGiQZpg6nWKYVffr61A_Adm0a+C3mbR@mail.gmail.com>
 <AANLkTi=a4kOssPYfdYHW5yn9q03=2_6v4bZeCj4iGsUi@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi=a4kOssPYfdYHW5yn9q03=2_6v4bZeCj4iGsUi@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 14, 2010 at 12:44:51PM -0800, Linus Torvalds wrote:
> On Tue, Dec 14, 2010 at 12:34 PM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> >
> > That's a maintainable approach. But it's maintainable ONLY if we then
> > don't do other random changes that invalidates all the years of
> > testing we've had.
> 
> Btw, looking at all the x86-specific commits that have gone in, I'm
> *extremely* unhappy that they apparently stopped honoring that
> "resource_alloc_from_bottom" flag that I explicitly asked for.
> 
> So it looks like it's not enough to just set that flag. We have to
> actually revert all the commits in this area as broken.
> 
> Which is sad, but since they clearly *are* broken and don't honor the
> flag that was there explicitly to avoid this problem and make it easy
> to test reverting it, I'm really pissed off. The WHOLE POINT of that
> flag was to give people an option to say "use the old resource
> allocation order because the new one doesn't work for me".
> 
> So at this point the only question is whether I should just revert the
> whole effing lot, or whether there are patches to fix the code to
> honor the "allocate from bottom" bit and then just set it by default
> again.

I'm not sure there's value in having both "pci=nocrs" and
"resource_alloc_from_bottom" flags.  What if I made it so
we allocate top-down if and only if we're using _CRS?

Then old boxes where we don't look at _CRS would use the same
bottom-up behavior they always have (this is another major
screwup in the current tree -- we currently do top-down on
these boxes for no good reason).

And on new boxes, we default to using _CRS and allocating
top-down, but if that doesn't work, we can use "pci=nocrs"
and go back to the old "ignore _CRS and allocate bottom-up"
behavior.

Here's a sample patch which I will test and document if you
think it's a reasonable approach:


commit e39250083dbdd0b42e886aa858d0ffbc86e618c4
Author: Bjorn Helgaas <bjorn.helgaas@hp.com>
Date:   Tue Dec 14 22:10:16 2010 -0700

diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 21c6746..85268f8 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -769,7 +769,6 @@ void __init setup_arch(char **cmdline_p)
 
 	x86_init.oem.arch_setup();
 
-	resource_alloc_from_bottom = 0;
 	iomem_resource.end = (1ULL << boot_cpu_data.x86_phys_bits) - 1;
 	setup_memory_map();
 	parse_setup_data();
diff --git a/arch/x86/pci/acpi.c b/arch/x86/pci/acpi.c
index 0972315..ca770fc 100644
--- a/arch/x86/pci/acpi.c
+++ b/arch/x86/pci/acpi.c
@@ -68,6 +68,9 @@ void __init pci_acpi_crs_quirks(void)
 	       "if necessary, use \"pci=%s\" and report a bug\n",
 	       pci_use_crs ? "Using" : "Ignoring",
 	       pci_use_crs ? "nocrs" : "use_crs");
+
+	if (pci_use_crs)
+		resource_alloc_from_top = 1;
 }
 
 static acpi_status
diff --git a/arch/x86/pci/i386.c b/arch/x86/pci/i386.c
index c4bb261..57a1374 100644
--- a/arch/x86/pci/i386.c
+++ b/arch/x86/pci/i386.c
@@ -65,9 +65,16 @@ pcibios_align_resource(void *data, const struct resource *res,
 			resource_size_t size, resource_size_t align)
 {
 	struct pci_dev *dev = data;
-	resource_size_t start = round_down(res->end - size + 1, align);
+	resource_size_t start;
+
+	if (resource_alloc_from_top)
+		start = round_down(res->end - size + 1, align);
+	else
+		start = res->start;
 
 	if (res->flags & IORESOURCE_IO) {
+		if (skip_isa_ioresource_align(dev))
+			return start;
 
 		/*
 		 * If we're avoiding ISA aliases, the largest contiguous I/O
@@ -75,11 +82,18 @@ pcibios_align_resource(void *data, const struct resource *res,
 		 * all 256-byte and smaller alignments, so the result will
 		 * still be correctly aligned.
 		 */
-		if (!skip_isa_ioresource_align(dev))
+		if (resource_alloc_from_top)
 			start &= ~0x300;
+		else if (start & 0x300)
+			start = (start + 0x3ff) & ~0x3ff;
+
 	} else if (res->flags & IORESOURCE_MEM) {
-		if (start < BIOS_END)
-			start = res->end;	/* fail; no space */
+		if (start < BIOS_END) {
+			if (resource_alloc_from_top)
+				start = res->end;	/* fail; no space */
+			else
+				start = BIOS_END;
+		}
 	}
 	return start;
 }
diff --git a/drivers/pci/bus.c b/drivers/pci/bus.c
index 003170e..bd59bc5 100644
--- a/drivers/pci/bus.c
+++ b/drivers/pci/bus.c
@@ -160,7 +160,7 @@ pci_bus_alloc_resource(struct pci_bus *bus, struct resource *res,
 					  resource_size_t),
 		void *alignf_data)
 {
-	int ret = -ENOMEM;
+	int i, ret = -ENOMEM;
 	struct resource *r;
 	resource_size_t max = -1;
 	unsigned int type = res->flags & IORESOURCE_TYPE_BITS;
@@ -171,26 +171,51 @@ pci_bus_alloc_resource(struct pci_bus *bus, struct resource *res,
 	if (!(res->flags & IORESOURCE_MEM_64))
 		max = PCIBIOS_MAX_MEM_32;
 
-	/* Look for space at highest addresses first */
-	r = pci_bus_find_resource_prev(bus, type, NULL);
-	for ( ; r; r = pci_bus_find_resource_prev(bus, type, r)) {
-		/* type_mask must match */
-		if ((res->flags ^ r->flags) & type_mask)
-			continue;
-
-		/* We cannot allocate a non-prefetching resource
-		   from a pre-fetching area */
-		if ((r->flags & IORESOURCE_PREFETCH) &&
-		    !(res->flags & IORESOURCE_PREFETCH))
-			continue;
-
-		/* Ok, try it out.. */
-		ret = allocate_resource(r, res, size,
-					r->start ? : min,
-					max, align,
-					alignf, alignf_data);
-		if (ret == 0)
-			break;
+	if (resource_alloc_from_top) {
+		/* Look for space at highest addresses first */
+		r = pci_bus_find_resource_prev(bus, type, NULL);
+		for ( ; r; r = pci_bus_find_resource_prev(bus, type, r)) {
+			/* type_mask must match */
+			if ((res->flags ^ r->flags) & type_mask)
+				continue;
+
+			/* We cannot allocate a non-prefetching resource
+			   from a pre-fetching area */
+			if ((r->flags & IORESOURCE_PREFETCH) &&
+			    !(res->flags & IORESOURCE_PREFETCH))
+				continue;
+
+			/* Ok, try it out.. */
+			ret = allocate_resource(r, res, size,
+						r->start ? : min,
+						max, align,
+						alignf, alignf_data);
+			if (ret == 0)
+				break;
+		}
+	} else {
+		pci_bus_for_each_resource(bus, r, i) {
+			if (!r)
+				continue;
+
+			/* type_mask must match */
+			if ((res->flags ^ r->flags) & type_mask)
+				continue;
+
+			/* We cannot allocate a non-prefetching resource
+			   from a pre-fetching area */
+			if ((r->flags & IORESOURCE_PREFETCH) &&
+			    !(res->flags & IORESOURCE_PREFETCH))
+				continue;
+
+			/* Ok, try it out.. */
+			ret = allocate_resource(r, res, size,
+						r->start ? : min,
+						max, align,
+						alignf, alignf_data);
+			if (ret == 0)
+				break;
+		}
 	}
 	return ret;
 }
diff --git a/include/linux/ioport.h b/include/linux/ioport.h
index d377ea8..d427cd5 100644
--- a/include/linux/ioport.h
+++ b/include/linux/ioport.h
@@ -112,7 +112,7 @@ struct resource_list {
 /* PC/ISA/whatever - the normal PC address spaces: IO and memory */
 extern struct resource ioport_resource;
 extern struct resource iomem_resource;
-extern int resource_alloc_from_bottom;
+extern int resource_alloc_from_top;
 
 extern struct resource *request_resource_conflict(struct resource *root, struct resource *new);
 extern int request_resource(struct resource *root, struct resource *new);
diff --git a/kernel/resource.c b/kernel/resource.c
index 9fad33e..275b414 100644
--- a/kernel/resource.c
+++ b/kernel/resource.c
@@ -41,21 +41,13 @@ EXPORT_SYMBOL(iomem_resource);
 static DEFINE_RWLOCK(resource_lock);
 
 /*
- * By default, we allocate free space bottom-up.  The architecture can request
- * top-down by clearing this flag.  The user can override the architecture's
- * choice with the "resource_alloc_from_bottom" kernel boot option, but that
- * should only be a debugging tool.
+ * By default, we allocate free space bottom-up, as we have done in the past.
+ * Architectures can request top-down by setting "resource_alloc_from_top".
+ * On x86, we do this when we use PCI host bridge ACPI _CRS information.
+ * If the user turns off _CRS with "pci=nocrs", we use the default bottom-up
+ * allocation strategy.
  */
-int resource_alloc_from_bottom = 1;
-
-static __init int setup_alloc_from_bottom(char *s)
-{
-	printk(KERN_INFO
-	       "resource: allocating from bottom-up; please report a bug\n");
-	resource_alloc_from_bottom = 1;
-	return 0;
-}
-early_param("resource_alloc_from_bottom", setup_alloc_from_bottom);
+int resource_alloc_from_top;
 
 static void *r_next(struct seq_file *m, void *v, loff_t *pos)
 {
@@ -545,10 +537,10 @@ int allocate_resource(struct resource *root, struct resource *new,
 		alignf = simple_align_resource;
 
 	write_lock(&resource_lock);
-	if (resource_alloc_from_bottom)
-		err = find_resource(root, new, size, min, max, align, alignf, alignf_data);
-	else
+	if (resource_alloc_from_top)
 		err = find_resource_from_top(root, new, size, min, max, align, alignf, alignf_data);
+	else
+		err = find_resource(root, new, size, min, max, align, alignf, alignf_data);
 	if (err >= 0 && __request_resource(root, new))
 		err = -EBUSY;
 	write_unlock(&resource_lock);
