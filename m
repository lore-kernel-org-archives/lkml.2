Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753439Ab3ACPQx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 10:16:53 -0500
Received: from mail-la0-f54.google.com ([209.85.215.54]:35943 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753052Ab3ACPQv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 10:16:51 -0500
MIME-Version: 1.0
In-Reply-To: <16168955.038G1kVfN2@vostro.rjw.lan>
References: <16168955.038G1kVfN2@vostro.rjw.lan>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Thu, 3 Jan 2013 08:16:26 -0700
Message-ID: <CAErSpo7tiCn5jBKorO7UjNQbceObAg_uGqtzpBfALBcCUMe1Yw@mail.gmail.com>
Subject: Re: [PATCH] PCI / ACPI: Rework ACPI device nodes lookup for the PCI
 bus type
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Len Brown <lenb@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Peter Wu <lekensteyn@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 28, 2012 at 2:29 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>
> As the kernel Bugzilla report #42696 indicates, it generally is not
> sufficient to use _ADR to get an ACPI device node corresponding to
> the given PCI device, because there may be multiple objects with
> matching _ADR in the ACPI namespace (this probably is against the
> spec, but it evidently happens in practice).

I don't see anything in sec 6.1.1 (_ADR) that precludes having
multiple objects that contain the same _ADR.  Do you have any other
pointers?

> One possible way to improve the situation is to use the presence of
> another ACPI method to distinguish between the matching namespace
> nodes.  For example, if the presence of _INI is checked in addition
> to the return value of _ADR, bug #42696 goes away on the affected
> machines.  Of course, this is somewhat arbitrary, but it may be
> argued that executing _INI for an ACPI device node kind of means that
> we are going to use that device node going forward, so we should
> generally prefer the nodes where we have executed _INI to "competing"
> nodes without _INI.

I consider this a purely ACPI issue, and hence something that you own
completely.

That said, my opinion is that this heuristic doesn't sound reliable to
me.  It feels like an ad hoc solution that works for the case at hand,
but I don't have any reason to think BIOS writers will unconsciously
make the same assumptions or that other OSes will contain the same
algorithm.

The existence of acpi_get_child_device() means we're assuming there
can only be a single child with matching _ADR.  Since that assumption
turned out to be false, maybe we need a way to deal with several
children.  Maybe we need a list of matching children, or maybe we
search matching children for a method at the time we need it instead
of trying to pick one child up front.

> In that case, though, we shouldn't take the nodes where we haven't
> executed _INI into account, but that's quite straightforwad to
> achieve.  Namely, we only need to check nodes that we created struct
> acpi_device objects for.  This also makes sense for a different
> reason, which is that the result of acpi_pci_find_device() is used
> to get a struct acpi_device object (not just an ACPI handle)
> corresponding to the given PCI device.
>
> Accordingly, introduce acpi_get_child_device() that finds a struct
> acpi_device corresponding to the given address by walking the
> children of the ACPI device node whose handle is its first argument.
> The lookup is carried out by evaluating _ADR for every child and
> comparing the result with the given address.  If there's a match and
> that child has _INI defined, it is returned as a result.  If _INI is
> not present, the search continues until (a) there are no more matches
> or (b) there is another matching child whose _INI is present (in
> which case that child is returned instead of the first matching one).
>
> The walk of the list of children is done in the reverse direction for
> two reasons.  The first reason is for compatibility with
> acpi_get_child() that returns the handle of the last matching child
> of the given parent.  The second one is to get the last device whose
> _INI was executed first (that _INI might have overriden whatever _INI
> for the other matching device nodes had done).
>
> To fix bug #42696, modify acpi_pci_find_device() to use
> acpi_get_child_device() instead of acpi_get_child() for ACPI device
> node lookup.
>
> References: https://bugzilla.kernel.org/show_bug.cgi?id=42696
> Reported-by: Peter Wu <lekensteyn@gmail.com>
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> ---
>  drivers/acpi/glue.c     |   45 +++++++++++++++++++++++++++++++++++++++++++++
>  drivers/acpi/internal.h |    4 ++++
>  drivers/acpi/proc.c     |    1 +
>  drivers/acpi/sleep.h    |    1 -
>  drivers/pci/pci-acpi.c  |    7 +++++--
>  include/acpi/acpi_bus.h |    1 +
>  6 files changed, 56 insertions(+), 3 deletions(-)
>
> Index: linux/drivers/acpi/glue.c
> ===================================================================
> --- linux.orig/drivers/acpi/glue.c
> +++ linux/drivers/acpi/glue.c
> @@ -93,6 +93,51 @@ static int acpi_find_bridge_device(struc
>         return ret;
>  }
>
> +/**
> + * acpi_get_child_device - Find specific child of an ACPI device.
> + * @phandle: ACPI handle of the parent device to find a child of.
> + * @address: Address of the child to find (as returned by _ADR).
> + *
> + * Find the child of the ACPI device node represented by @phandle whose _ADR
> + * method's return value is equal to @address.  If there are more children with
> + * matching _ADR return values, take the (last) one having _INI defined.
> + */
> +struct acpi_device *acpi_get_child_device(acpi_handle phandle, u64 address)
> +{
> +       struct acpi_device *parent, *adev, *ret = NULL;
> +
> +       if (acpi_bus_get_device(phandle, &parent))
> +               return NULL;
> +
> +       mutex_lock(&acpi_device_lock);
> +       /* Use reverse direction for compatibility with acpi_get_child(). */
> +       list_for_each_entry_reverse(adev, &parent->children, node) {
> +               unsigned long long addr;
> +               acpi_status status;
> +               acpi_handle out;
> +
> +               status = acpi_evaluate_integer(adev->handle, METHOD_NAME__ADR,
> +                                              NULL, &addr);
> +               if (ACPI_FAILURE(status) || addr != address)
> +                       continue;
> +
> +               if (ret)
> +                       acpi_handle_warn(adev->handle,
> +                                        "_ADR conflict with device %s\n",
> +                                        dev_name(&ret->dev));
> +
> +               status = acpi_get_handle(adev->handle, "_INI", &out);
> +               if (ACPI_SUCCESS(status)) {
> +                       ret = adev;
> +                       break;
> +               } else if (!ret) {
> +                       ret = adev;
> +               }
> +       }
> +       mutex_unlock(&acpi_device_lock);
> +       return ret;
> +}
> +
>  /* Get device's handler per its address under its parent */
>  struct acpi_find_child {
>         acpi_handle handle;
> Index: linux/drivers/acpi/internal.h
> ===================================================================
> --- linux.orig/drivers/acpi/internal.h
> +++ linux/drivers/acpi/internal.h
> @@ -21,8 +21,12 @@
>  #ifndef _ACPI_INTERNAL_H_
>  #define _ACPI_INTERNAL_H_
>
> +#include <linux/mutex.h>
> +
>  #define PREFIX "ACPI: "
>
> +extern struct mutex acpi_device_lock;
> +
>  int init_acpi_device_notify(void);
>  int acpi_scan_init(void);
>  int acpi_sysfs_init(void);
> Index: linux/drivers/acpi/sleep.h
> ===================================================================
> --- linux.orig/drivers/acpi/sleep.h
> +++ linux/drivers/acpi/sleep.h
> @@ -5,4 +5,3 @@ extern void acpi_enable_wakeup_devices(u
>  extern void acpi_disable_wakeup_devices(u8 sleep_state);
>
>  extern struct list_head acpi_wakeup_device_list;
> -extern struct mutex acpi_device_lock;
> Index: linux/drivers/acpi/proc.c
> ===================================================================
> --- linux.orig/drivers/acpi/proc.c
> +++ linux/drivers/acpi/proc.c
> @@ -12,6 +12,7 @@
>  #include <linux/mc146818rtc.h>
>  #endif
>
> +#include "internal.h"
>  #include "sleep.h"
>
>  #define _COMPONENT             ACPI_SYSTEM_COMPONENT
> Index: linux/include/acpi/acpi_bus.h
> ===================================================================
> --- linux.orig/include/acpi/acpi_bus.h
> +++ linux/include/acpi/acpi_bus.h
> @@ -400,6 +400,7 @@ struct acpi_pci_root {
>  };
>
>  /* helper */
> +struct acpi_device *acpi_get_child_device(acpi_handle phandle, u64 address);
>  acpi_handle acpi_get_child(acpi_handle, u64);
>  int acpi_is_root_bridge(acpi_handle);
>  struct acpi_pci_root *acpi_pci_find_root(acpi_handle handle);
> Index: linux/drivers/pci/pci-acpi.c
> ===================================================================
> --- linux.orig/drivers/pci/pci-acpi.c
> +++ linux/drivers/pci/pci-acpi.c
> @@ -291,14 +291,17 @@ static struct pci_platform_pm_ops acpi_p
>  static int acpi_pci_find_device(struct device *dev, acpi_handle *handle)
>  {
>         struct pci_dev * pci_dev;
> +       struct acpi_device *adev;
>         u64     addr;
>
>         pci_dev = to_pci_dev(dev);
>         /* Please ref to ACPI spec for the syntax of _ADR */
>         addr = (PCI_SLOT(pci_dev->devfn) << 16) | PCI_FUNC(pci_dev->devfn);
> -       *handle = acpi_get_child(DEVICE_ACPI_HANDLE(dev->parent), addr);
> -       if (!*handle)
> +       adev = acpi_get_child_device(ACPI_HANDLE(dev->parent), addr);
> +       if (!adev)
>                 return -ENODEV;
> +
> +       *handle = adev->handle;
>         return 0;
>  }
>
>
