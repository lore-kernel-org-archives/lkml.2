Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754144Ab2KMPLg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 10:11:36 -0500
Received: from ogre.sisk.pl ([193.178.161.156]:41015 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751643Ab2KMPLc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 10:11:32 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: mathias.nyman@linux.intel.com, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, lenb@kernel.org,
        rafael.j.wysocki@intel.com, broonie@opensource.wolfsonmicro.com,
        grant.likely@secretlab.ca, linus.walleij@linaro.org,
        khali@linux-fr.org, Bjorn Helgaas <bhelgaas@google.com>,
        "Moore, Robert" <robert.moore@intel.com>
Subject: Re: [Replacement][PATCH 3/3]
Date: Tue, 13 Nov 2012 16:15:51 +0100
Message-ID: <1956273.aTIDahOxd1@vostro.rjw.lan>
User-Agent: KMail/4.8.5 (Linux/3.7.0-rc5; KDE/4.8.5; x86_64; ; )
In-Reply-To: <20121113141642.GJ31759@intel.com>
References: <1351928793-14375-1-git-send-email-mika.westerberg@linux.intel.com> <1440764.Vb4SkUrF9O@vostro.rjw.lan> <20121113141642.GJ31759@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, November 13, 2012 04:16:42 PM Mika Westerberg wrote:
> On Tue, Nov 13, 2012 at 01:06:59PM +0100, Rafael J. Wysocki wrote:
> > > I don't know any better option.
> > 
> > Well, a better option would be to convince ACPICA to provide us different
> > interfaces. :-)
> 
> Heh, indeed.
> 
> > We might actually try to do that in the future, but for now we still need
> > _CRS to be evaluated centrally rather than by every interested party in
> > isolation.  So below is a replacement for my original [3/3] patch that
> > approaches the problem from a different angle (on top of [1/3] and
> > updated [2/3] sent yesterday).  Please let me know what you think.
> > 
> > Thanks,
> > Rafael
> > 
> > 
> > ---
> > From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > Subject: ACPI: Centralized processing of ACPI device resources
> > 
> > Currently, whoever wants to use ACPI device resources has to call
> > acpi_walk_resources() to browse the buffer returned by the _CRS
> > method for the given device and create filters passed to that
> > routine to apply to the individual resource items.  This generally
> > is cumbersome, time-consuming and inefficient.  Moreover, it may
> > be problematic if resource conflicts need to be resolved, because
> > the different users of _CRS will need to do that in a consistent
> > way.  However, if there are resource conflicts, the ACPI core
> > should be able to resolve them centrally instead of relying on
> > various users of acpi_walk_resources() to handle them correctly
> > together.
> > 
> > For this reason, introduce a new function, acpi_dev_get_resources(),
> > that can be used by subsystems to obtain a list of struct resource
> > objects corresponding to the ACPI device resources returned by
> > _CRS and, if necessary, to apply additional preprocessing routine
> > to the ACPI resources before converting them to the struct resource
> > format.
> > 
> > Make the ACPI code that creates platform device objects use
> > acpi_dev_get_resources() for resource processing instead of executing
> > acpi_walk_resources() twice by itself, which causes it to be much
> > more straightforward and easier to follow.
> > 
> > In the future, acpi_dev_get_resources() can be extended to meet
> > the needs of the ACPI PNP subsystem and other users of _CRS in
> > the kernel.
> > 
> > Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> 
> I found one problem which resulted failure (see below) but once that was
> fixed devices were enumerated correctly. I tested this also with modified
> SPI/I2C/GPIO patches and they also work as expected on my test machine.
> 
> Nice work, thanks.

Well, thanks! :-)

> > ---
> >  drivers/acpi/acpi_platform.c |   94 +++++-------------------------
> >  drivers/acpi/resource.c      |  132 +++++++++++++++++++++++++++++++++++++++++++
> >  include/linux/acpi.h         |   10 +++
> >  3 files changed, 159 insertions(+), 77 deletions(-)
> > 
> > Index: linux/include/linux/acpi.h
> > ===================================================================
> > --- linux.orig/include/linux/acpi.h
> > +++ linux/include/linux/acpi.h
> > @@ -261,6 +261,16 @@ unsigned long acpi_dev_irq_flags(u8 trig
> >  bool acpi_dev_resource_interrupt(struct acpi_resource *ares, int index,
> >  				 struct resource *res);
> >  
> > +struct resource_list_entry {
> > +	struct list_head node;
> > +	struct resource res;
> > +};
> > +
> > +void acpi_dev_free_resource_list(struct list_head *list);
> > +int acpi_dev_get_resources(struct acpi_device *adev, struct list_head *list,
> > +			   int (*preproc)(struct acpi_resource *, void *),
> > +			   void *preproc_data);
> > +
> >  int acpi_check_resource_conflict(const struct resource *res);
> >  
> >  int acpi_check_region(resource_size_t start, resource_size_t n,
> > Index: linux/drivers/acpi/resource.c
> > ===================================================================
> > --- linux.orig/drivers/acpi/resource.c
> > +++ linux/drivers/acpi/resource.c
> > @@ -26,6 +26,7 @@
> >  #include <linux/device.h>
> >  #include <linux/export.h>
> >  #include <linux/ioport.h>
> > +#include <linux/slab.h>
> >  
> >  #ifdef CONFIG_X86
> >  #define valid_IRQ(i) (((i) != 0) && ((i) != 2))
> > @@ -391,3 +392,134 @@ bool acpi_dev_resource_interrupt(struct
> >  	return true;
> >  }
> >  EXPORT_SYMBOL_GPL(acpi_dev_resource_interrupt);
> > +
> > +/**
> > + * acpi_dev_free_resource_list - Free resource from %acpi_dev_get_resources().
> > + * @list: The head of the resource list to free.
> > + */
> > +void acpi_dev_free_resource_list(struct list_head *list)
> > +{
> > +	struct resource_list_entry *rentry, *re;
> > +
> > +	list_for_each_entry_safe(rentry, re, list, node) {
> > +		list_del(&rentry->node);
> > +		kfree(rentry);
> > +	}
> > +}
> > +EXPORT_SYMBOL_GPL(acpi_dev_free_resource_list);
> > +
> > +struct res_proc_context {
> > +	struct list_head *list;
> > +	int (*preproc)(struct acpi_resource *, void *);
> > +	void *preproc_data;
> > +	int count;
> > +	int error;
> > +};
> > +
> > +static acpi_status acpi_dev_new_resource_entry(struct resource *r,
> > +					       struct res_proc_context *c)
> > +{
> > +	struct resource_list_entry *rentry;
> > +
> > +	rentry = kmalloc(sizeof(*rentry), GFP_KERNEL);
> > +	if (!rentry) {
> > +		c->error = -ENOMEM;
> > +		return AE_NO_MEMORY;
> > +	}
> > +	INIT_LIST_HEAD(&rentry->node);
> > +	rentry->res = *r;
> > +	list_add_tail(&rentry->node, c->list);
> > +	c->count++;
> > +	return AE_OK;
> > +}
> > +
> > +static acpi_status acpi_dev_process_resource(struct acpi_resource *ares,
> > +					     void *context)
> > +{
> > +	struct res_proc_context *c = context;
> > +	struct resource r;
> 
> We should initialize this to zero, otherwise insert_resource() will fail as
> parent, sibling etc. pointers are garbage.

Ah, sorry for overlooking that.

I'll resend the whole [1-3/3] series later today with this bug fixed (hopefully).

> > +	int i;
> > +
> > +	if (c->preproc) {
> > +		int ret;
> > +
> > +		ret = c->preproc(ares, c->preproc_data);
> > +		if (ret < 0) {
> > +			c->error = ret;
> > +			return AE_ABORT_METHOD;
> > +		} else if (ret > 0) {
> > +			return AE_OK;
> > +		}
> > +	}
> > +
> > +	if (acpi_dev_resource_memory(ares, &r)
> > +	    || acpi_dev_resource_io(ares, &r)
> > +	    || acpi_dev_resource_address_space(ares, &r)
> > +	    || acpi_dev_resource_ext_address_space(ares, &r))
> > +		return acpi_dev_new_resource_entry(&r, c);
> > +
> > +	for (i = 0; acpi_dev_resource_interrupt(ares, i, &r); i++) {
> > +		acpi_status status;
> > +
> > +		status = acpi_dev_new_resource_entry(&r, c);
> > +		if (ACPI_FAILURE(status))
> > +			return status;
> > +	}
> > +
> > +	return AE_OK;
> > +}
> > +
> > +/**
> > + * acpi_dev_get_resources - Get current resources of a device.
> > + * @adev: ACPI device node to get the resources for.
> > + * @list: Head of the resultant list of resources (must be empty).
> > + * @preproc: The caller's preprocessing routine.
> > + * @preproc_data: Pointer passed to the caller's preprocessing routine.
> > + *
> > + * Evaluate the _CRS method for the given device node and process its output by
> > + * (1) executing the @preproc() rountine provided by the caller, passing the
> > + * resource pointer and @preproc_data to it as arguments, for each ACPI resource
> > + * returned and (2) converting all of the returned ACPI resources into struct
> > + * resource objects if possible.  If the return value of @preproc() in step (1)
> > + * is different from 0, step (2) is not applied to the given ACPI resource and
> > + * if that value is negative, the whole processing is aborted and that value is
> > + * returned as the final error code.
> > + *
> > + * The resultant struct resource objects are put on the list pointed to by
> > + * @list, that must be empty initially, as members of struct resource_list_entry
> > + * objects.  Callers of this routine should use %acpi_dev_free_resource_list() to
> > + * free that list.
> > + *
> > + * The number of resources in the output list is returned on success, an error
> > + * code reflecting the error condition is returned otherwise.
> > + */
> > +int acpi_dev_get_resources(struct acpi_device *adev, struct list_head *list,
> > +			   int (*preproc)(struct acpi_resource *, void *),
> > +			   void *preproc_data)
> 
> Could we change this so that you can pass NULL list as well (provided that
> the preproc is given)?
> 
> This is useful in case when we try to find the SPI/I2C device handle based
> on the ACPI serial bus resource address. In that case we are not interested
> in any other resources (and hence there is no need to allocate memory for
> them etc.)

I'd prefer to have a separate helper function for that, if that's not a
problem.  It should be clear when we ask for resources of a given device
and when we only want to poke things like that.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
