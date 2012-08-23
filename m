Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030408Ab2HWKw2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 06:52:28 -0400
Received: from david.siemens.de ([192.35.17.14]:24258 "EHLO david.siemens.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030369Ab2HWKwX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 06:52:23 -0400
Message-ID: <50360B4D.5070403@siemens.com>
Date: Thu, 23 Aug 2012 12:51:57 +0200
From: Jan Kiszka <jan.kiszka@siemens.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Wen Congyang <wency@cn.fujitsu.com>
CC: kvm list <kvm@vger.kernel.org>, qemu-devel <qemu-devel@nongnu.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Avi Kivity <avi@redhat.com>,
        "Daniel P. Berrange" <berrange@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Gleb Natapov <gleb@redhat.com>, Blue Swirl <blauwirbel@gmail.com>,
        Eric Blake <eblake@redhat.com>, Andrew Jones <drjones@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
Subject: Re: [PATCH v9 5/6] introduce a new qom device to deal with panicked
 event
References: <50359561.9070001@cn.fujitsu.com> <5035962D.8050907@cn.fujitsu.com>
In-Reply-To: <5035962D.8050907@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-08-23 04:32, Wen Congyang wrote:
> If the target is x86/x86_64, the guest's kernel will write 0x01 to the
> port KVM_PV_EVENT_PORT when it is panciked. This patch introduces a new
> qom device kvm_pv_ioport to listen this I/O port, and deal with panicked
> event according to panicked_action's value. The possible actions are:
> 1. emit QEVENT_GUEST_PANICKED only
> 2. emit QEVENT_GUEST_PANICKED and pause the guest
> 3. emit QEVENT_GUEST_PANICKED and poweroff the guest
> 4. emit QEVENT_GUEST_PANICKED and reset the guest
> 
> I/O ports does not work for some targets(for example: s390). And you
> can implement another qom device, and include it's code into pv_event.c
> for such target.
> 
> Note: if we emit QEVENT_GUEST_PANICKED only, and the management
> application does not receive this event(the management may not
> run when the event is emitted), the management won't know the
> guest is panicked.
> 
> Signed-off-by: Wen Congyang <wency@cn.fujitsu.com>
> ---
>  hw/kvm/Makefile.objs |    2 +-
>  hw/kvm/pv_event.c    |  190 ++++++++++++++++++++++++++++++++++++++++++++++++++
>  hw/pc_piix.c         |    9 +++
>  kvm.h                |    2 +
>  4 files changed, 202 insertions(+), 1 deletions(-)
>  create mode 100644 hw/kvm/pv_event.c
> 
> diff --git a/hw/kvm/Makefile.objs b/hw/kvm/Makefile.objs
> index 226497a..23e3b30 100644
> --- a/hw/kvm/Makefile.objs
> +++ b/hw/kvm/Makefile.objs
> @@ -1 +1 @@
> -obj-$(CONFIG_KVM) += clock.o apic.o i8259.o ioapic.o i8254.o
> +obj-$(CONFIG_KVM) += clock.o apic.o i8259.o ioapic.o i8254.o pv_event.o
> diff --git a/hw/kvm/pv_event.c b/hw/kvm/pv_event.c
> new file mode 100644
> index 0000000..c03dd22
> --- /dev/null
> +++ b/hw/kvm/pv_event.c
> @@ -0,0 +1,190 @@
> +/*
> + * QEMU KVM support, paravirtual event device
> + *
> + * Copyright Fujitsu, Corp. 2012
> + *
> + * Authors:
> + *     Wen Congyang <wency@cn.fujitsu.com>
> + *
> + * This work is licensed under the terms of the GNU GPL, version 2 or later.
> + * See the COPYING file in the top-level directory.
> + *
> + */
> +
> +#include <linux/kvm_para.h>
> +#include <asm/kvm_para.h>
> +#include <qobject.h>
> +#include <qjson.h>
> +#include <monitor.h>
> +#include <sysemu.h>
> +#include <kvm.h>
> +
> +/* Possible values for action parameter. */
> +#define PANICKED_REPORT     1   /* emit QEVENT_GUEST_PANICKED only */
> +#define PANICKED_PAUSE      2   /* emit QEVENT_GUEST_PANICKED and pause VM */
> +#define PANICKED_POWEROFF   3   /* emit QEVENT_GUEST_PANICKED and quit VM */
> +#define PANICKED_RESET      4   /* emit QEVENT_GUEST_PANICKED and reset VM */
> +
> +#define PV_EVENT_DRIVER     "kvm_pv_event"
> +
> +struct PVEventAction {
> +    char *panicked_action;
> +    int panicked_action_value;
> +};
> +
> +#define DEFINE_PV_EVENT_PROPERTIES(_state, _conf)   \
> +    DEFINE_PROP_STRING("panicked_action", _state, _conf.panicked_action)
> +
> +static void panicked_mon_event(const char *action)
> +{
> +    QObject *data;
> +
> +    data = qobject_from_jsonf("{ 'action': %s }", action);
> +    monitor_protocol_event(QEVENT_GUEST_PANICKED, data);
> +    qobject_decref(data);
> +}
> +
> +static void panicked_perform_action(uint32_t panicked_action)
> +{
> +    switch (panicked_action) {
> +    case PANICKED_REPORT:
> +        panicked_mon_event("report");
> +        break;
> +
> +    case PANICKED_PAUSE:
> +        panicked_mon_event("pause");
> +        vm_stop(RUN_STATE_GUEST_PANICKED);
> +        break;
> +
> +    case PANICKED_POWEROFF:
> +        panicked_mon_event("poweroff");
> +        qemu_system_shutdown_request();
> +        break;
> +
> +    case PANICKED_RESET:
> +        panicked_mon_event("reset");
> +        qemu_system_reset_request();
> +        break;
> +    }
> +}
> +
> +static uint64_t supported_event(void)
> +{
> +    return 1 << KVM_PV_FEATURE_PANICKED;
> +}
> +
> +static void handle_event(int event, struct PVEventAction *conf)
> +{
> +    if (event == KVM_PV_EVENT_PANICKED) {
> +        panicked_perform_action(conf->panicked_action_value);
> +    }
> +}
> +
> +static int pv_event_init(struct PVEventAction *conf)
> +{
> +    if (!conf->panicked_action) {
> +        conf->panicked_action_value = PANICKED_REPORT;
> +    } else if (strcasecmp(conf->panicked_action, "none") == 0) {
> +        conf->panicked_action_value = PANICKED_REPORT;
> +    } else if (strcasecmp(conf->panicked_action, "pause") == 0) {
> +        conf->panicked_action_value = PANICKED_PAUSE;
> +    } else if (strcasecmp(conf->panicked_action, "poweroff") == 0) {
> +        conf->panicked_action_value = PANICKED_POWEROFF;
> +    } else if (strcasecmp(conf->panicked_action, "reset") == 0) {
> +        conf->panicked_action_value = PANICKED_RESET;
> +    } else {
> +        return -1;
> +    }
> +
> +    return 0;
> +}
> +
> +#if defined(KVM_PV_EVENT_PORT)
> +
> +#include "hw/isa.h"
> +
> +typedef struct {
> +    ISADevice dev;
> +    struct PVEventAction conf;
> +    MemoryRegion ioport;
> +} PVIOPortState;
> +
> +static uint64_t pv_io_read(void *opaque, target_phys_addr_t addr, unsigned size)
> +{
> +    return supported_event();
> +}
> +
> +static void pv_io_write(void *opaque, target_phys_addr_t addr, uint64_t val,
> +                        unsigned size)
> +{
> +    PVIOPortState *s = opaque;
> +
> +    handle_event(val, &s->conf);
> +}
> +
> +static const MemoryRegionOps pv_io_ops = {
> +    .read = pv_io_read,
> +    .write = pv_io_write,
> +    .impl = {
> +        .min_access_size = 4,
> +        .max_access_size = 4,
> +    },
> +};
> +
> +static int pv_ioport_initfn(ISADevice *dev)
> +{
> +    PVIOPortState *s = DO_UPCAST(PVIOPortState, dev, dev);
> +
> +    if (pv_event_init(&s->conf) < 0) {
> +        return -1;
> +    }
> +
> +    memory_region_init_io(&s->ioport, &pv_io_ops, s, "pv_event", 1);
> +    isa_register_ioport(dev, &s->ioport, KVM_PV_EVENT_PORT);
> +
> +    return 0;
> +}
> +
> +static Property pv_ioport_properties[] = {
> +    DEFINE_PV_EVENT_PROPERTIES(PVIOPortState, conf),
> +    DEFINE_PROP_END_OF_LIST(),
> +};
> +
> +static void pv_ioport_class_init(ObjectClass *klass, void *data)
> +{
> +    DeviceClass *dc = DEVICE_CLASS(klass);
> +    ISADeviceClass *ic = ISA_DEVICE_CLASS(klass);
> +
> +    ic->init = pv_ioport_initfn;
> +    dc->no_user = 1;
> +    dc->props = pv_ioport_properties;
> +}
> +
> +static TypeInfo pv_ioport_info = {
> +    .name          = PV_EVENT_DRIVER,
> +    .parent        = TYPE_ISA_DEVICE,
> +    .instance_size = sizeof(PVIOPortState),
> +    .class_init    = pv_ioport_class_init,
> +};
> +
> +static void pv_ioport_register_types(void)
> +{
> +    type_register_static(&pv_ioport_info);
> +}
> +
> +type_init(pv_ioport_register_types)
> +
> +void kvm_pv_event_init(void *opaque)
> +{
> +    ISABus *bus = opaque;
> +    ISADevice *dev;
> +
> +    dev = isa_create(bus, PV_EVENT_DRIVER);
> +    qdev_init_nofail(&dev->qdev);
> +}
> +
> +#else
> +void kvm_pv_event_init(void *opaque)
> +{

Some comment that this stub requires an implementation whenever it is
actually built would be helpful. Something that explains a different
transport than PIO will be needed.

> +}
> +#endif
> diff --git a/hw/pc_piix.c b/hw/pc_piix.c
> index 88ff041..f73fb85 100644
> --- a/hw/pc_piix.c
> +++ b/hw/pc_piix.c
> @@ -46,6 +46,9 @@
>  #ifdef CONFIG_XEN
>  #  include <xen/hvm/hvm_info_table.h>
>  #endif
> +#ifdef CONFIG_KVM
> +#   include <asm/kvm_para.h>
> +#endif
>  
>  #define MAX_IDE_BUS 2
>  
> @@ -285,6 +288,12 @@ static void pc_init1(MemoryRegion *system_memory,
>      if (pci_enabled) {
>          pc_pci_device_init(pci_bus);
>      }
> +
> +#ifdef KVM_PV_EVENT_PORT

This file is x86-only, and there we have KVM_PV_EVENT_PORT
unconditionally. So drop the #ifdef.

> +    if (kvm_enabled()) {
> +        kvm_pv_event_init(isa_bus);

But you are missing a kvm-stub entry for kvm_pv_event_init. A
--disable-kvm build should be broken for that reason.

> +    }
> +#endif
>  }
>  
>  static void pc_init_pci(ram_addr_t ram_size,
> diff --git a/kvm.h b/kvm.h
> index 5b8f588..41ce1b2 100644
> --- a/kvm.h
> +++ b/kvm.h
> @@ -276,4 +276,6 @@ int kvm_irqchip_add_irqfd(KVMState *s, int fd, int virq);
>  int kvm_irqchip_remove_irqfd(KVMState *s, int fd, int virq);
>  int kvm_irqchip_add_irq_notifier(KVMState *s, EventNotifier *n, int virq);
>  int kvm_irqchip_remove_irq_notifier(KVMState *s, EventNotifier *n, int virq);
> +
> +void kvm_pv_event_init(void *opaque);
>  #endif
> 

Jan

-- 
Siemens AG, Corporate Technology, CT RTC ITP SDP-DE
Corporate Competence Center Embedded Linux
