Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753582Ab2KLU7l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 15:59:41 -0500
Received: from ogre.sisk.pl ([193.178.161.156]:39350 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753392Ab2KLU7i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 15:59:38 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: mathias.nyman@linux.intel.com, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, lenb@kernel.org,
        rafael.j.wysocki@intel.com, broonie@opensource.wolfsonmicro.com,
        grant.likely@secretlab.ca, linus.walleij@linaro.org,
        khali@linux-fr.org, Bjorn Helgaas <bhelgaas@google.com>,
        "Moore, Robert" <robert.moore@intel.com>
Subject: Re: [PATCH 3/3] ACPI: Evaluate _CRS while creating device node objects
Date: Mon, 12 Nov 2012 22:03:56 +0100
Message-ID: <1935553.kFsUz07opN@vostro.rjw.lan>
User-Agent: KMail/4.8.5 (Linux/3.7.0-rc5; KDE/4.8.5; x86_64; ; )
In-Reply-To: <20121112144621.GE31759@intel.com>
References: <1351928793-14375-1-git-send-email-mika.westerberg@linux.intel.com> <11281928.0BBlrNprhI@vostro.rjw.lan> <20121112144621.GE31759@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, November 12, 2012 04:46:21 PM Mika Westerberg wrote:
> On Mon, Nov 12, 2012 at 01:02:11PM +0100, Rafael J. Wysocki wrote:
> > From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > 
> > Currently, whoever wants to use ACPI device resources has to call
> > acpi_walk_resources() to browse the buffer returned by the _CRS
> > method for the given device and create filters passed to that
> > routine to apply to the individual resource items.  This generally
> > is cumbersome, time-consuming and inefficient.  Moreover, it may
> > be problematic if resource conflicts need to be resolved, because
> > the different users of _CRS will need to do that in a consistent
> > way.
> > 
> > For this reason, add code to the ACPI core to execute _CRS once,
> > when the struct acpi_device object is created for a given device
> > node, and attach a list of ACPI resources returned by _CRS to that
> > object for future processing.
> > 
> > Convert the ACPI code that creates platform device objects to using
> > the new resources list instead of executing acpi_walk_resources() by
> > itself, which makes it much more straightforward and easier to
> > follow.
> > 
> > Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > ---
> >  drivers/acpi/acpi_platform.c |   90 ++++++++++++-------------------------------
> >  drivers/acpi/resource.c      |   12 +++++
> >  drivers/acpi/scan.c          |   56 ++++++++++++++++++++++++++
> >  include/acpi/acpi_bus.h      |    6 ++
> >  include/linux/acpi.h         |    1 
> >  5 files changed, 102 insertions(+), 63 deletions(-)
> > 
> > Index: linux/include/acpi/acpi_bus.h
> > ===================================================================
> > --- linux.orig/include/acpi/acpi_bus.h
> > +++ linux/include/acpi/acpi_bus.h
> > @@ -259,6 +259,11 @@ struct acpi_device_physical_node {
> >  	struct device *dev;
> >  };
> >  
> > +struct acpi_resource_list_entry {
> > +	struct list_head node;
> > +	struct acpi_resource resource;
> > +};
> > +
> >  /* set maximum of physical nodes to 32 for expansibility */
> >  #define ACPI_MAX_PHYSICAL_NODE	32
> >  
> > @@ -268,6 +273,7 @@ struct acpi_device {
> >  	acpi_handle handle;		/* no handle for fixed hardware */
> >  	struct acpi_device *parent;
> >  	struct list_head children;
> > +	struct list_head resources;	/* Device resources. */
> >  	struct list_head node;
> >  	struct list_head wakeup_list;
> >  	struct acpi_device_status status;
> > Index: linux/drivers/acpi/scan.c
> > ===================================================================
> > --- linux.orig/drivers/acpi/scan.c
> > +++ linux/drivers/acpi/scan.c
> > @@ -382,6 +382,52 @@ static void acpi_device_remove_files(str
> >  			ACPI Bus operations
> >     -------------------------------------------------------------------------- */
> >  
> > +static void acpi_bus_drop_resources(struct acpi_device *adev)
> > +{
> > +	struct acpi_resource_list_entry *entry, *s;
> > +
> > +	list_for_each_entry_safe(entry, s, &adev->resources, node) {
> > +		list_del(&entry->node);
> > +		kfree(entry);
> > +	}
> > +}
> > +
> > +static acpi_status acpi_bus_add_resource(struct acpi_resource *res,
> > +					 void *context)
> > +{
> > +	struct list_head *list = context;
> > +	struct acpi_resource_list_entry *entry;
> > +
> > +	entry = kzalloc(sizeof(*entry), GFP_KERNEL);
> > +	if (!entry)
> > +		return AE_NO_MEMORY;
> > +
> > +	entry->resource = *res;
> 
> This does not work well with all resource types - specifically those that
> contain pointers, like acpi_resource_gpio and acpi_resource_source.

Good point.

Well, this pretty much means we can't copy those things.

> The memory for the resources gets freed once acpi_walk_resources() is done.

I know that.

Having to evaluate _CRS and creating a buffer, converting the output into
ACPI resources and so on every time we need to look into the device's current
resources is totally inefficient.  We _need_ to cache the _CRS output.

Now, because of the pointers in certain types of resources, we can't
make copies of the resource objects used by acpi_walk_resources() which
makes that function totally unuseful to us.

I suppose we can just do acpi_get_current_resources() and play with the
buffer returned by it.  That won't be nice, but still better than what we
have.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
