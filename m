Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759493Ab2CMDO2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 23:14:28 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:65432 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757210Ab2CMDOZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 23:14:25 -0400
MIME-Version: 1.0
In-Reply-To: <1331362837-10740-23-git-send-email-yinghai@kernel.org>
References: <1331362837-10740-1-git-send-email-yinghai@kernel.org> <1331362837-10740-23-git-send-email-yinghai@kernel.org>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Mon, 12 Mar 2012 21:14:03 -0600
Message-ID: <CAErSpo4=pL_y0q=1-4GMGenOmKmLFgtAbpYi3GNrErGVZqCcBg@mail.gmail.com>
Subject: Re: [PATCH v2 22/37] PCI, acpiphp: remove hot-add support of pci host bridge
To: Yinghai Lu <yinghai@kernel.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, x86 <x86@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 10, 2012 at 12:00 AM, Yinghai Lu <yinghai@kernel.org> wrote:
> It causes confusing.

"causes confusion."

> We may only need acpi hp for pci host bridge.
>
> Split host bridge hot-add support to another file, and keep acpiphp simple.

I think it's a good thing to remove host bridge hotplug from acpiphp;
thanks for doing that.

However, I think you removed it here, but didn't add it elsewhere
until a different patch.  That means we can't bisect across this.  It
would be better to do the entire move in a single patch.

> Also remove not used res_lock in the struct.
>
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> ---
>  drivers/pci/hotplug/acpiphp.h      |    9 +---
>  drivers/pci/hotplug/acpiphp_glue.c |  104 +++++++-----------------------------
>  2 files changed, 21 insertions(+), 92 deletions(-)
>
> diff --git a/drivers/pci/hotplug/acpiphp.h b/drivers/pci/hotplug/acpiphp.h
> index 7722108..1a62e7b 100644
> --- a/drivers/pci/hotplug/acpiphp.h
> +++ b/drivers/pci/hotplug/acpiphp.h
> @@ -79,18 +79,15 @@ struct acpiphp_bridge {
>        /* Ejectable PCI-to-PCI bridge (PCI bridge and PCI function) */
>        struct acpiphp_func *func;
>
> -       int type;
>        int nr_slots;
>
>        u32 flags;
>
> -       /* This bus (host bridge) or Secondary bus (PCI-to-PCI bridge) */
> +       /* Secondary bus (PCI-to-PCI bridge) */
>        struct pci_bus *pci_bus;
>
>        /* PCI-to-PCI bridge device */
>        struct pci_dev *pci_dev;
> -
> -       spinlock_t res_lock;
>  };
>
>
> @@ -148,10 +145,6 @@ struct acpiphp_attention_info
>  /* PCI bus bridge HID */
>  #define ACPI_PCI_HOST_HID              "PNP0A03"
>
> -/* PCI BRIDGE type */
> -#define BRIDGE_TYPE_HOST               0
> -#define BRIDGE_TYPE_P2P                        1
> -
>  /* ACPI _STA method value (ignore bit 4; battery present) */
>  #define ACPI_STA_PRESENT               (0x00000001)
>  #define ACPI_STA_ENABLED               (0x00000002)
> diff --git a/drivers/pci/hotplug/acpiphp_glue.c b/drivers/pci/hotplug/acpiphp_glue.c
> index 10b2122..1ca82ae 100644
> --- a/drivers/pci/hotplug/acpiphp_glue.c
> +++ b/drivers/pci/hotplug/acpiphp_glue.c
> @@ -283,7 +283,7 @@ static int detect_ejectable_slots(acpi_handle handle)
>        return found;
>  }
>
> -/* initialize miscellaneous stuff for both root and PCI-to-PCI bridge */
> +/* initialize miscellaneous stuff for PCI-to-PCI bridge */
>  static void init_bridge_misc(struct acpiphp_bridge *bridge)
>  {
>        acpi_status status;
> @@ -300,25 +300,21 @@ static void init_bridge_misc(struct acpiphp_bridge *bridge)
>        }
>
>        /* install notify handler */
> -       if (bridge->type != BRIDGE_TYPE_HOST) {
> -               if ((bridge->flags & BRIDGE_HAS_EJ0) && bridge->func) {
> -                       status = acpi_remove_notify_handler(bridge->func->handle,
> -                                               ACPI_SYSTEM_NOTIFY,
> -                                               handle_hotplug_event_func);
> -                       if (ACPI_FAILURE(status))
> -                               err("failed to remove notify handler\n");
> -               }
> -               status = acpi_install_notify_handler(bridge->handle,
> -                                            ACPI_SYSTEM_NOTIFY,
> -                                            handle_hotplug_event_bridge,
> -                                            bridge);
> -
> -               if (ACPI_FAILURE(status)) {
> -                       err("failed to register interrupt notify handler\n");
> -               }
> +       if ((bridge->flags & BRIDGE_HAS_EJ0) && bridge->func) {
> +               status = acpi_remove_notify_handler(bridge->func->handle,
> +                                       ACPI_SYSTEM_NOTIFY,
> +                                       handle_hotplug_event_func);
> +               if (ACPI_FAILURE(status))
> +                       err("failed to remove notify handler\n");
>        }
> -}
> +       status = acpi_install_notify_handler(bridge->handle,
> +                                    ACPI_SYSTEM_NOTIFY,
> +                                    handle_hotplug_event_bridge,
> +                                    bridge);
>
> +       if (ACPI_FAILURE(status))
> +               err("failed to register interrupt notify handler\n");
> +}
>
>  /* find acpiphp_func from acpiphp_bridge */
>  static struct acpiphp_func *acpiphp_bridge_handle_to_function(acpi_handle handle)
> @@ -375,28 +371,6 @@ static inline void config_p2p_bridge_flags(struct acpiphp_bridge *bridge)
>        }
>  }
>
> -
> -/* allocate and initialize host bridge data structure */
> -static void add_host_bridge(acpi_handle *handle)
> -{
> -       struct acpiphp_bridge *bridge;
> -       struct acpi_pci_root *root = acpi_pci_find_root(handle);
> -
> -       bridge = kzalloc(sizeof(struct acpiphp_bridge), GFP_KERNEL);
> -       if (bridge == NULL)
> -               return;
> -
> -       bridge->type = BRIDGE_TYPE_HOST;
> -       bridge->handle = handle;
> -
> -       bridge->pci_bus = root->bus;
> -
> -       spin_lock_init(&bridge->res_lock);
> -
> -       init_bridge_misc(bridge);
> -}
> -
> -
>  /* allocate and initialize PCI-to-PCI bridge data structure */
>  static void add_p2p_bridge(acpi_handle *handle)
>  {
> @@ -408,7 +382,6 @@ static void add_p2p_bridge(acpi_handle *handle)
>                return;
>        }
>
> -       bridge->type = BRIDGE_TYPE_P2P;
>        bridge->handle = handle;
>        config_p2p_bridge_flags(bridge);
>
> @@ -425,7 +398,6 @@ static void add_p2p_bridge(acpi_handle *handle)
>         * (which we access during module unload).
>         */
>        get_device(&bridge->pci_bus->dev);
> -       spin_lock_init(&bridge->res_lock);
>
>        init_bridge_misc(bridge);
>        return;
> @@ -485,12 +457,6 @@ static int add_bridge(acpi_handle handle)
>                        return 0;
>        }
>
> -       /* check if this bridge has ejectable slots */
> -       if (detect_ejectable_slots(handle) > 0) {
> -               dbg("found PCI host-bus bridge with hot-pluggable slots\n");
> -               add_host_bridge(handle);
> -       }
> -
>        /* search P2P bridges under this host bridge */
>        status = acpi_walk_namespace(ACPI_TYPE_DEVICE, handle, (u32)1,
>                                     find_p2p_bridge, NULL, NULL, NULL);
> @@ -524,8 +490,7 @@ static void cleanup_bridge(struct acpiphp_bridge *bridge)
>        if (ACPI_FAILURE(status))
>                err("failed to remove notify handler\n");
>
> -       if ((bridge->type != BRIDGE_TYPE_HOST) &&
> -           ((bridge->flags & BRIDGE_HAS_EJ0) && bridge->func)) {
> +       if ((bridge->flags & BRIDGE_HAS_EJ0) && bridge->func) {
>                status = acpi_install_notify_handler(bridge->func->handle,
>                                                ACPI_SYSTEM_NOTIFY,
>                                                handle_hotplug_event_func,
> @@ -1078,15 +1043,10 @@ static void acpiphp_sanitize_bus(struct pci_bus *bus)
>  static int acpiphp_configure_bridge (acpi_handle handle)
>  {
>        struct pci_bus *bus;
> +       struct pci_dev *pdev = acpi_get_pci_dev(handle);
>
> -       if (acpi_is_root_bridge(handle)) {
> -               struct acpi_pci_root *root = acpi_pci_find_root(handle);
> -               bus = root->bus;
> -       } else {
> -               struct pci_dev *pdev = acpi_get_pci_dev(handle);
> -               bus = pdev->subordinate;
> -               pci_dev_put(pdev);
> -       }
> +       bus = pdev->subordinate;
> +       pci_dev_put(pdev);
>
>        pci_bus_size_bridges(bus);
>        pci_bus_assign_resources(bus);
> @@ -1249,8 +1209,7 @@ static void _handle_hotplug_event_bridge(struct work_struct *work)
>        case ACPI_NOTIFY_EJECT_REQUEST:
>                /* request device eject */
>                dbg("%s: Device eject notify on %s\n", __func__, objname);
> -               if ((bridge->type != BRIDGE_TYPE_HOST) &&
> -                   (bridge->flags & BRIDGE_HAS_EJ0)) {
> +               if (bridge->flags & BRIDGE_HAS_EJ0) {
>                        struct acpiphp_slot *slot;
>                        slot = bridge->func->slot;
>                        if (!acpiphp_disable_slot(slot))
> @@ -1381,21 +1340,6 @@ static void handle_hotplug_event_func(acpi_handle handle, u32 type,
>                              _handle_hotplug_event_func);
>  }
>
> -static acpi_status
> -find_root_bridges(acpi_handle handle, u32 lvl, void *context, void **rv)
> -{
> -       int *count = (int *)context;
> -
> -       if (!acpi_is_root_bridge(handle))
> -               return AE_OK;
> -
> -       (*count)++;
> -       acpi_install_notify_handler(handle, ACPI_SYSTEM_NOTIFY,
> -                                   handle_hotplug_event_bridge, NULL);
> -
> -       return AE_OK ;
> -}
> -
>  static struct acpi_pci_driver acpi_pci_hp_driver = {
>        .add =          add_bridge,
>        .remove =       remove_bridge,
> @@ -1406,15 +1350,7 @@ static struct acpi_pci_driver acpi_pci_hp_driver = {
>  */
>  int __init acpiphp_glue_init(void)
>  {
> -       int num = 0;
> -
> -       acpi_walk_namespace(ACPI_TYPE_DEVICE, ACPI_ROOT_OBJECT,
> -                       ACPI_UINT32_MAX, find_root_bridges, NULL, &num, NULL);
> -
> -       if (num <= 0)
> -               return -1;
> -       else
> -               acpi_pci_register_driver(&acpi_pci_hp_driver);
> +       acpi_pci_register_driver(&acpi_pci_hp_driver);
>
>        return 0;
>  }
> --
> 1.7.7
>
