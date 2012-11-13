Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753963Ab2KMMCm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 07:02:42 -0500
Received: from ogre.sisk.pl ([193.178.161.156]:40708 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751556Ab2KMMCk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 07:02:40 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: mathias.nyman@linux.intel.com, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, lenb@kernel.org,
        rafael.j.wysocki@intel.com, broonie@opensource.wolfsonmicro.com,
        grant.likely@secretlab.ca, linus.walleij@linaro.org,
        khali@linux-fr.org, Bjorn Helgaas <bhelgaas@google.com>,
        "Moore, Robert" <robert.moore@intel.com>
Subject: [Replacement][PATCH 3/3]
Date: Tue, 13 Nov 2012 13:06:59 +0100
Message-ID: <1440764.Vb4SkUrF9O@vostro.rjw.lan>
User-Agent: KMail/4.8.5 (Linux/3.7.0-rc5; KDE/4.8.5; x86_64; ; )
In-Reply-To: <20121113071208.GF31759@intel.com>
References: <1351928793-14375-1-git-send-email-mika.westerberg@linux.intel.com> <1935553.kFsUz07opN@vostro.rjw.lan> <20121113071208.GF31759@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, November 13, 2012 09:12:09 AM Mika Westerberg wrote:
> On Mon, Nov 12, 2012 at 10:03:56PM +0100, Rafael J. Wysocki wrote:
> > > > +static acpi_status acpi_bus_add_resource(struct acpi_resource *res,
> > > > +					 void *context)
> > > > +{
> > > > +	struct list_head *list = context;
> > > > +	struct acpi_resource_list_entry *entry;
> > > > +
> > > > +	entry = kzalloc(sizeof(*entry), GFP_KERNEL);
> > > > +	if (!entry)
> > > > +		return AE_NO_MEMORY;
> > > > +
> > > > +	entry->resource = *res;
> > > 
> > > This does not work well with all resource types - specifically those that
> > > contain pointers, like acpi_resource_gpio and acpi_resource_source.
> > 
> > Good point.
> > 
> > Well, this pretty much means we can't copy those things.
> 
> Yeah. I only noticed this yesterday when I tested the GPIO translation in a
> custom driver (since it uses the acpi_resource_gpio).
> 
> > > The memory for the resources gets freed once acpi_walk_resources() is done.
> > 
> > I know that.
> > 
> > Having to evaluate _CRS and creating a buffer, converting the output into
> > ACPI resources and so on every time we need to look into the device's current
> > resources is totally inefficient.  We _need_ to cache the _CRS output.
> 
> I agree and besides having adev->resources is much easier to use than
> calling acpi_walk_resources() everytime.
> 
> > Now, because of the pointers in certain types of resources, we can't
> > make copies of the resource objects used by acpi_walk_resources() which
> > makes that function totally unuseful to us.
> >
> > I suppose we can just do acpi_get_current_resources() and play with the
> > buffer returned by it.  That won't be nice, but still better than what we
> > have.
> 
> I don't know any better option.

Well, a better option would be to convince ACPICA to provide us different
interfaces. :-)

We might actually try to do that in the future, but for now we still need
_CRS to be evaluated centrally rather than by every interested party in
isolation.  So below is a replacement for my original [3/3] patch that
approaches the problem from a different angle (on top of [1/3] and
updated [2/3] sent yesterday).  Please let me know what you think.

Thanks,
Rafael


---
From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Subject: ACPI: Centralized processing of ACPI device resources

Currently, whoever wants to use ACPI device resources has to call
acpi_walk_resources() to browse the buffer returned by the _CRS
method for the given device and create filters passed to that
routine to apply to the individual resource items.  This generally
is cumbersome, time-consuming and inefficient.  Moreover, it may
be problematic if resource conflicts need to be resolved, because
the different users of _CRS will need to do that in a consistent
way.  However, if there are resource conflicts, the ACPI core
should be able to resolve them centrally instead of relying on
various users of acpi_walk_resources() to handle them correctly
together.

For this reason, introduce a new function, acpi_dev_get_resources(),
that can be used by subsystems to obtain a list of struct resource
objects corresponding to the ACPI device resources returned by
_CRS and, if necessary, to apply additional preprocessing routine
to the ACPI resources before converting them to the struct resource
format.

Make the ACPI code that creates platform device objects use
acpi_dev_get_resources() for resource processing instead of executing
acpi_walk_resources() twice by itself, which causes it to be much
more straightforward and easier to follow.

In the future, acpi_dev_get_resources() can be extended to meet
the needs of the ACPI PNP subsystem and other users of _CRS in
the kernel.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/acpi/acpi_platform.c |   94 +++++-------------------------
 drivers/acpi/resource.c      |  132 +++++++++++++++++++++++++++++++++++++++++++
 include/linux/acpi.h         |   10 +++
 3 files changed, 159 insertions(+), 77 deletions(-)

Index: linux/include/linux/acpi.h
===================================================================
--- linux.orig/include/linux/acpi.h
+++ linux/include/linux/acpi.h
@@ -261,6 +261,16 @@ unsigned long acpi_dev_irq_flags(u8 trig
 bool acpi_dev_resource_interrupt(struct acpi_resource *ares, int index,
 				 struct resource *res);
 
+struct resource_list_entry {
+	struct list_head node;
+	struct resource res;
+};
+
+void acpi_dev_free_resource_list(struct list_head *list);
+int acpi_dev_get_resources(struct acpi_device *adev, struct list_head *list,
+			   int (*preproc)(struct acpi_resource *, void *),
+			   void *preproc_data);
+
 int acpi_check_resource_conflict(const struct resource *res);
 
 int acpi_check_region(resource_size_t start, resource_size_t n,
Index: linux/drivers/acpi/resource.c
===================================================================
--- linux.orig/drivers/acpi/resource.c
+++ linux/drivers/acpi/resource.c
@@ -26,6 +26,7 @@
 #include <linux/device.h>
 #include <linux/export.h>
 #include <linux/ioport.h>
+#include <linux/slab.h>
 
 #ifdef CONFIG_X86
 #define valid_IRQ(i) (((i) != 0) && ((i) != 2))
@@ -391,3 +392,134 @@ bool acpi_dev_resource_interrupt(struct
 	return true;
 }
 EXPORT_SYMBOL_GPL(acpi_dev_resource_interrupt);
+
+/**
+ * acpi_dev_free_resource_list - Free resource from %acpi_dev_get_resources().
+ * @list: The head of the resource list to free.
+ */
+void acpi_dev_free_resource_list(struct list_head *list)
+{
+	struct resource_list_entry *rentry, *re;
+
+	list_for_each_entry_safe(rentry, re, list, node) {
+		list_del(&rentry->node);
+		kfree(rentry);
+	}
+}
+EXPORT_SYMBOL_GPL(acpi_dev_free_resource_list);
+
+struct res_proc_context {
+	struct list_head *list;
+	int (*preproc)(struct acpi_resource *, void *);
+	void *preproc_data;
+	int count;
+	int error;
+};
+
+static acpi_status acpi_dev_new_resource_entry(struct resource *r,
+					       struct res_proc_context *c)
+{
+	struct resource_list_entry *rentry;
+
+	rentry = kmalloc(sizeof(*rentry), GFP_KERNEL);
+	if (!rentry) {
+		c->error = -ENOMEM;
+		return AE_NO_MEMORY;
+	}
+	INIT_LIST_HEAD(&rentry->node);
+	rentry->res = *r;
+	list_add_tail(&rentry->node, c->list);
+	c->count++;
+	return AE_OK;
+}
+
+static acpi_status acpi_dev_process_resource(struct acpi_resource *ares,
+					     void *context)
+{
+	struct res_proc_context *c = context;
+	struct resource r;
+	int i;
+
+	if (c->preproc) {
+		int ret;
+
+		ret = c->preproc(ares, c->preproc_data);
+		if (ret < 0) {
+			c->error = ret;
+			return AE_ABORT_METHOD;
+		} else if (ret > 0) {
+			return AE_OK;
+		}
+	}
+
+	if (acpi_dev_resource_memory(ares, &r)
+	    || acpi_dev_resource_io(ares, &r)
+	    || acpi_dev_resource_address_space(ares, &r)
+	    || acpi_dev_resource_ext_address_space(ares, &r))
+		return acpi_dev_new_resource_entry(&r, c);
+
+	for (i = 0; acpi_dev_resource_interrupt(ares, i, &r); i++) {
+		acpi_status status;
+
+		status = acpi_dev_new_resource_entry(&r, c);
+		if (ACPI_FAILURE(status))
+			return status;
+	}
+
+	return AE_OK;
+}
+
+/**
+ * acpi_dev_get_resources - Get current resources of a device.
+ * @adev: ACPI device node to get the resources for.
+ * @list: Head of the resultant list of resources (must be empty).
+ * @preproc: The caller's preprocessing routine.
+ * @preproc_data: Pointer passed to the caller's preprocessing routine.
+ *
+ * Evaluate the _CRS method for the given device node and process its output by
+ * (1) executing the @preproc() rountine provided by the caller, passing the
+ * resource pointer and @preproc_data to it as arguments, for each ACPI resource
+ * returned and (2) converting all of the returned ACPI resources into struct
+ * resource objects if possible.  If the return value of @preproc() in step (1)
+ * is different from 0, step (2) is not applied to the given ACPI resource and
+ * if that value is negative, the whole processing is aborted and that value is
+ * returned as the final error code.
+ *
+ * The resultant struct resource objects are put on the list pointed to by
+ * @list, that must be empty initially, as members of struct resource_list_entry
+ * objects.  Callers of this routine should use %acpi_dev_free_resource_list() to
+ * free that list.
+ *
+ * The number of resources in the output list is returned on success, an error
+ * code reflecting the error condition is returned otherwise.
+ */
+int acpi_dev_get_resources(struct acpi_device *adev, struct list_head *list,
+			   int (*preproc)(struct acpi_resource *, void *),
+			   void *preproc_data)
+{
+	struct res_proc_context c;
+	acpi_handle not_used;
+	acpi_status status;
+
+	if (!adev || !adev->handle || !list_empty(list))
+		return -EINVAL;
+
+	status = acpi_get_handle(adev->handle, METHOD_NAME__CRS, &not_used);
+	if (ACPI_FAILURE(status))
+		return 0;
+
+	c.list = list;
+	c.preproc = preproc;
+	c.preproc_data = preproc_data;
+	c.count = 0;
+	c.error = 0;
+	status = acpi_walk_resources(adev->handle, METHOD_NAME__CRS,
+				     acpi_dev_process_resource, &c);
+	if (ACPI_FAILURE(status)) {
+		acpi_dev_free_resource_list(list);
+		return c.error ? c.error : -EIO;
+	}
+
+	return c.count;
+}
+EXPORT_SYMBOL_GPL(acpi_dev_get_resources);
Index: linux/drivers/acpi/acpi_platform.c
===================================================================
--- linux.orig/drivers/acpi/acpi_platform.c
+++ linux/drivers/acpi/acpi_platform.c
@@ -19,61 +19,6 @@
 
 ACPI_MODULE_NAME("platform");
 
-struct resource_info {
-	struct device *dev;
-	struct resource *res;
-	size_t n, cur;
-};
-
-static acpi_status acpi_platform_count_resources(struct acpi_resource *res,
-						 void *data)
-{
-	struct acpi_resource_extended_irq *acpi_xirq;
-	struct acpi_resource_irq *acpi_irq;
-	struct resource_info *ri = data;
-
-	switch (res->type) {
-	case ACPI_RESOURCE_TYPE_IRQ:
-		acpi_irq = &res->data.irq;
-		ri->n += acpi_irq->interrupt_count;
-		break;
-	case ACPI_RESOURCE_TYPE_EXTENDED_IRQ:
-		acpi_xirq = &res->data.extended_irq;
-		ri->n += acpi_xirq->interrupt_count;
-		break;
-	default:
-		ri->n++;
-	}
-
-	return AE_OK;
-}
-
-static acpi_status acpi_platform_add_resources(struct acpi_resource *res,
-					       void *data)
-{
-	struct resource_info *ri = data;
-	struct resource *r;
-
-	r = ri->res + ri->cur;
-	if (acpi_dev_resource_memory(res, r)
-	    || acpi_dev_resource_io(res, r)
-	    || acpi_dev_resource_address_space(res, r)
-	    || acpi_dev_resource_ext_address_space(res, r)) {
-		ri->cur++;
-		return AE_OK;
-	}
-	if (acpi_dev_resource_interrupt(res, 0, r)) {
-		int i;
-
-		r++;
-		for (i = 1; acpi_dev_resource_interrupt(res, i, r); i++)
-			r++;
-
-		ri->cur += i;
-	}
-	return AE_OK;
-}
-
 /**
  * acpi_create_platform_device - Create platform device for ACPI device node
  * @adev: ACPI device node to create a platform device for.
@@ -89,35 +34,31 @@ struct platform_device *acpi_create_plat
 	struct platform_device *pdev = NULL;
 	struct acpi_device *acpi_parent;
 	struct device *parent = NULL;
-	struct resource_info ri;
-	acpi_status status;
+	struct resource_list_entry *rentry;
+	struct list_head resource_list;
+	struct resource *resources;
+	int count;
 
 	/* If the ACPI node already has a physical device attached, skip it. */
 	if (adev->physical_node_count)
 		return NULL;
 
-	memset(&ri, 0, sizeof(ri));
-	/* First, count the resources. */
-	status = acpi_walk_resources(adev->handle, METHOD_NAME__CRS,
-				     acpi_platform_count_resources, &ri);
-	if (ACPI_FAILURE(status) || !ri.n)
+	INIT_LIST_HEAD(&resource_list);
+	count = acpi_dev_get_resources(adev, &resource_list, NULL, NULL);
+	if (count <= 0)
 		return NULL;
 
-	/* Next, allocate memory for all the resources and populate it. */
-	ri.dev = &adev->dev;
-	ri.res = kzalloc(ri.n * sizeof(struct resource), GFP_KERNEL);
-	if (!ri.res) {
-		dev_err(&adev->dev,
-			"failed to allocate memory for resources\n");
+	resources = kmalloc(count * sizeof(struct resource), GFP_KERNEL);
+	if (!resources) {
+		dev_err(&adev->dev, "No memory for resources\n");
+		acpi_dev_free_resource_list(&resource_list);
 		return NULL;
 	}
+	count = 0;
+	list_for_each_entry(rentry, &resource_list, node)
+		resources[count++] = rentry->res;
 
-	status = acpi_walk_resources(adev->handle, METHOD_NAME__CRS,
-				     acpi_platform_add_resources, &ri);
-	if (ACPI_FAILURE(status)) {
-		dev_err(&adev->dev, "failed to walk resources\n");
-		goto out;
-	}
+	acpi_dev_free_resource_list(&resource_list);
 
 	/*
 	 * If the ACPI node has a parent and that parent has a physical device
@@ -140,7 +81,7 @@ struct platform_device *acpi_create_plat
 		mutex_unlock(&acpi_parent->physical_node_lock);
 	}
 	pdev = platform_device_register_resndata(parent, dev_name(&adev->dev),
-						 -1, ri.res, ri.cur, NULL, 0);
+						 -1, resources, count, NULL, 0);
 	if (IS_ERR(pdev)) {
 		dev_err(&adev->dev, "platform device creation failed: %ld\n",
 			PTR_ERR(pdev));
@@ -150,8 +91,7 @@ struct platform_device *acpi_create_plat
 			dev_name(&pdev->dev));
 	}
 
- out:
-	kfree(ri.res);
+	kfree(resources);
 	return pdev;
 }
 



-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
