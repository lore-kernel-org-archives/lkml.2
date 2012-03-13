Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759516Ab2CMDWl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 23:22:41 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:45843 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754434Ab2CMDWi convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 23:22:38 -0400
MIME-Version: 1.0
In-Reply-To: <1331362837-10740-24-git-send-email-yinghai@kernel.org>
References: <1331362837-10740-1-git-send-email-yinghai@kernel.org> <1331362837-10740-24-git-send-email-yinghai@kernel.org>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Mon, 12 Mar 2012 21:22:16 -0600
Message-ID: <CAErSpo5cCC4HySedQ85BFKkPQ0VuYWX+NTjZLd4GpcATh1ix3g@mail.gmail.com>
Subject: Re: [PATCH v2 23/37] PCI, ACPI: Add pci_root_hp hot add hotplug notification
To: Yinghai Lu <yinghai@kernel.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, x86 <x86@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 10, 2012 at 12:00 AM, Yinghai Lu <yinghai@kernel.org> wrote:
> It is from acpiphp_glue.c
>
> How to use it?
> Find out root bus number to acpi root name mapping from dmesg or /sys
>
>  echo "\_SB.PCIB 0" > /proc/acpi/sci/notify
> to add it back

Nope.  That might be a way to exercise this for debug purposes (and it
only works when /proc/acpi/sci/notify is compiled in), but we
definitely don't want normal users to deal with ACPI pathnames like
this.

Most of this functionality belongs in the ACPI core, not here.  The
core should be handling these notify events and turning them into
.add() and .remove() calls to the driver.

But since the ACPI core doesn't do that yet, we have to do it in the
driver, like we do for CPU, memory, etc.  That part is fine.  But I
think it at least belongs *in* the driver, i.e., in pci_root.c, not in
a new pci_root_hp.c file.

There definitely should not be another acpi_walk_namespace() and
another list of ACPI host bridges.  The core *does* already walk the
namespace and call acpi_pci_root_add() for us.  And the driver already
has a list of host bridges (acpi_pci_roots).

> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> Cc: Len Brown <lenb@kernel.org>
> Cc: linux-acpi@vger.kernel.org
> ---
>  drivers/acpi/Makefile      |    1 +
>  drivers/acpi/pci_root_hp.c |  237 ++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 238 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/acpi/pci_root_hp.c
>
> diff --git a/drivers/acpi/Makefile b/drivers/acpi/Makefile
> index 1567028..bc6e53f 100644
> --- a/drivers/acpi/Makefile
> +++ b/drivers/acpi/Makefile
> @@ -36,6 +36,7 @@ acpi-y                                += processor_core.o
>  acpi-y                         += ec.o
>  acpi-$(CONFIG_ACPI_DOCK)       += dock.o
>  acpi-y                         += pci_root.o pci_link.o pci_irq.o pci_bind.o
> +acpi-$(CONFIG_HOTPLUG)         += pci_root_hp.o
>  acpi-y                         += power.o
>  acpi-y                         += event.o
>  acpi-y                         += sysfs.o
> diff --git a/drivers/acpi/pci_root_hp.c b/drivers/acpi/pci_root_hp.c
> new file mode 100644
> index 0000000..dc11e81
> --- /dev/null
> +++ b/drivers/acpi/pci_root_hp.c
> @@ -0,0 +1,237 @@
> +/*
> + * Separated from drivers/pci/hotplug/acpiphp_glue.c
> + *     only support root bridge
> + */
> +
> +#include <linux/init.h>
> +#include <linux/module.h>
> +
> +#include <linux/kernel.h>
> +#include <linux/pci.h>
> +#include <linux/mutex.h>
> +#include <linux/slab.h>
> +#include <linux/acpi.h>
> +
> +static LIST_HEAD(acpi_root_bridge_list);
> +struct acpi_root_bridge {
> +       struct list_head list;
> +       acpi_handle handle;
> +       u32 flags;
> +};
> +
> +/* bridge flags */
> +#define ROOT_BRIDGE_HAS_EJ0    (0x00000002)
> +#define ROOT_BRIDGE_HAS_PS3    (0x00000080)
> +
> +#define ACPI_STA_FUNCTIONING   (0x00000008)
> +
> +static struct acpi_root_bridge *acpi_root_handle_to_bridge(acpi_handle handle)
> +{
> +       struct acpi_root_bridge *bridge;
> +
> +       list_for_each_entry(bridge, &acpi_root_bridge_list, list)
> +               if (bridge->handle == handle)
> +                       return bridge;
> +
> +       return NULL;
> +}
> +
> +/* allocate and initialize host bridge data structure */
> +static void add_acpi_root_bridge(acpi_handle handle)
> +{
> +       struct acpi_root_bridge *bridge;
> +       acpi_handle dummy_handle;
> +       acpi_status status;
> +
> +       /* if the bridge doesn't have _STA, we assume it is always there */
> +       status = acpi_get_handle(handle, "_STA", &dummy_handle);
> +       if (ACPI_SUCCESS(status)) {
> +               unsigned long long tmp;
> +
> +               status = acpi_evaluate_integer(handle, "_STA", NULL, &tmp);
> +               if (ACPI_FAILURE(status)) {
> +                       printk(KERN_DEBUG "%s: _STA evaluation failure\n",
> +                                                __func__);
> +                       return;
> +               }
> +               if ((tmp & ACPI_STA_FUNCTIONING) == 0)
> +                       /* don't register this object */
> +                       return;
> +       }
> +
> +       bridge = kzalloc(sizeof(struct acpi_root_bridge), GFP_KERNEL);
> +       if (!bridge)
> +               return;
> +
> +       bridge->handle = handle;
> +
> +       if (ACPI_SUCCESS(acpi_get_handle(handle, "_EJ0", &dummy_handle)))
> +               bridge->flags |= ROOT_BRIDGE_HAS_EJ0;
> +       if (ACPI_SUCCESS(acpi_get_handle(handle, "_PS3", &dummy_handle)))
> +               bridge->flags |= ROOT_BRIDGE_HAS_PS3;
> +
> +       list_add(&bridge->list, &acpi_root_bridge_list);
> +}
> +
> +struct acpi_root_hp_work {
> +       struct work_struct work;
> +       acpi_handle handle;
> +       u32 type;
> +       void *context;
> +};
> +
> +static void alloc_acpi_root_hp_work(acpi_handle handle, u32 type,
> +                                       void *context,
> +                                       void (*func)(struct work_struct *work))
> +{
> +       struct acpi_root_hp_work *hp_work;
> +       int ret;
> +
> +       hp_work = kmalloc(sizeof(*hp_work), GFP_KERNEL);
> +       if (!hp_work)
> +               return;
> +
> +       hp_work->handle = handle;
> +       hp_work->type = type;
> +       hp_work->context = context;
> +
> +       INIT_WORK(&hp_work->work, func);
> +       ret = queue_work(kacpi_hotplug_wq, &hp_work->work);
> +       if (!ret)
> +               kfree(hp_work);
> +}
> +
> +/* Program resources in newly inserted bridge */
> +static void acpi_root_configure_bridge(acpi_handle handle)
> +{
> +       struct acpi_pci_root *root = acpi_pci_find_root(handle);
> +
> +       pci_assign_unassigned_bus_resources(root->bus);
> +}
> +
> +static void handle_root_bridge_insertion(acpi_handle handle)
> +{
> +       struct acpi_device *device, *pdevice;
> +       acpi_handle phandle;
> +       int ret_val;
> +
> +       acpi_get_parent(handle, &phandle);
> +       if (acpi_bus_get_device(phandle, &pdevice)) {
> +               printk(KERN_DEBUG "no parent device, assuming NULL\n");
> +               pdevice = NULL;
> +       }
> +       if (!acpi_bus_get_device(handle, &device)) {
> +               /* check if  pci root_bus is removed */
> +               struct acpi_pci_root *root = acpi_driver_data(device);
> +               if (pci_find_bus(root->segment, root->secondary.start))
> +                       return;
> +
> +               printk(KERN_DEBUG "bus exists... trim\n");
> +               /* this shouldn't be in here, so remove
> +                * the bus then re-add it...
> +                */
> +               ret_val = acpi_bus_trim(device, 1);
> +               printk(KERN_DEBUG "acpi_bus_trim return %x\n", ret_val);
> +       }
> +       if (acpi_bus_add(&device, pdevice, handle, ACPI_BUS_TYPE_DEVICE)) {
> +               printk(KERN_ERR "cannot add bridge to acpi list\n");
> +               return;
> +       }
> +       acpi_root_configure_bridge(handle);
> +       if (acpi_bus_start(device))
> +               printk(KERN_ERR "cannot start bridge\n");
> +}
> +
> +static void _handle_hotplug_event_root(struct work_struct *work)
> +{
> +       struct acpi_root_bridge *bridge;
> +       char objname[64];
> +       struct acpi_buffer buffer = { .length = sizeof(objname),
> +                                     .pointer = objname };
> +       struct acpi_root_hp_work *hp_work;
> +       acpi_handle handle;
> +       u32 type;
> +
> +       hp_work = container_of(work, struct acpi_root_hp_work, work);
> +       handle = hp_work->handle;
> +       type = hp_work->type;
> +
> +       bridge = acpi_root_handle_to_bridge(handle);
> +
> +       acpi_get_name(handle, ACPI_FULL_PATHNAME, &buffer);
> +
> +       switch (type) {
> +       case ACPI_NOTIFY_BUS_CHECK:
> +               /* bus enumerate */
> +               printk(KERN_DEBUG "%s: Bus check notify on %s\n", __func__,
> +                                objname);
> +               if (!bridge) {
> +                       handle_root_bridge_insertion(handle);
> +                       add_acpi_root_bridge(handle);
> +               }
> +
> +               break;
> +
> +       case ACPI_NOTIFY_DEVICE_CHECK:
> +               /* device check */
> +               printk(KERN_DEBUG "%s: Device check notify on %s\n", __func__,
> +                                objname);
> +               if (!bridge) {
> +                       handle_root_bridge_insertion(handle);
> +                       add_acpi_root_bridge(handle);
> +               }
> +               break;
> +
> +       default:
> +               printk(KERN_WARNING "notify_handler: unknown event type 0x%x for %s\n",
> +                                type, objname);
> +               break;
> +       }
> +
> +       kfree(hp_work); /* allocated in handle_hotplug_event_bridge */
> +}
> +
> +static void handle_hotplug_event_root(acpi_handle handle, u32 type,
> +                                       void *context)
> +{
> +       alloc_acpi_root_hp_work(handle, type, context,
> +                               _handle_hotplug_event_root);
> +}
> +
> +static acpi_status __init
> +find_root_bridges(acpi_handle handle, u32 lvl, void *context, void **rv)
> +{
> +       char objname[64];
> +       struct acpi_buffer buffer = { .length = sizeof(objname),
> +                                     .pointer = objname };
> +       int *count = (int *)context;
> +
> +       if (!acpi_is_root_bridge(handle))
> +               return AE_OK;
> +
> +       (*count)++;
> +
> +       acpi_get_name(handle, ACPI_FULL_PATHNAME, &buffer);
> +
> +       acpi_install_notify_handler(handle, ACPI_SYSTEM_NOTIFY,
> +                               handle_hotplug_event_root, NULL);
> +       printk(KERN_DEBUG "acpi root: %s notify handler installed\n", objname);
> +
> +       add_acpi_root_bridge(handle);
> +
> +       return AE_OK;
> +}
> +
> +static int __init acpi_pci_root_hp_init(void)
> +{
> +       int num = 0;
> +
> +       acpi_walk_namespace(ACPI_TYPE_DEVICE, ACPI_ROOT_OBJECT,
> +               ACPI_UINT32_MAX, find_root_bridges, NULL, &num, NULL);
> +
> +       printk(KERN_DEBUG "Found %d acpi root devices\n", num);
> +
> +       return 0;
> +}
> +
> +subsys_initcall(acpi_pci_root_hp_init);
> --
> 1.7.7
>
