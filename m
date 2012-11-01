Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932176Ab2KADw1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 23:52:27 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:42164 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757184Ab2KADwZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 23:52:25 -0400
MIME-Version: 1.0
In-Reply-To: <1351668471-31436-2-git-send-email-tangchen@cn.fujitsu.com>
References: <1351668471-31436-1-git-send-email-tangchen@cn.fujitsu.com>
	<1351668471-31436-2-git-send-email-tangchen@cn.fujitsu.com>
Date: Wed, 31 Oct 2012 20:52:22 -0700
X-Google-Sender-Auth: uZu9m5JlMysbttHWXpKeQqsXLjA
Message-ID: <CAE9FiQWZ=Xgnw-U=4v2a5W7OwBkA3gT63qDnNYGT9p8Rn0O3fg@mail.gmail.com>
Subject: Re: [PATCH v3 1/3] Use acpi_os_hotplug_execute() instead of alloc_acpi_hp_work().
From: Yinghai Lu <yinghai@kernel.org>
To: Tang Chen <tangchen@cn.fujitsu.com>
Cc: bhelgaas@google.com, lenb@kernel.org, jiang.liu@huawei.com,
        izumi.taku@jp.fujitsu.com, isimatu.yasuaki@jp.fujitsu.com,
        linux-acpi@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 31, 2012 at 12:27 AM, Tang Chen <tangchen@cn.fujitsu.com> wrote:
> Hi Yinghai,
>
> alloc_acpi_hp_work() just puts the hutplug work onto kacpi_hotplug_wq.
> As mentioned by Toshi Kani, this job has been done in acpi_os_hotplug_execute().
> So we should use it instead of alloc_acpi_hp_work().
>
> This patch adds a acpi_hp_cb_data struct, which encapsulates the hotplug
> event notifier's parameters:
>         struct acpi_hp_cb_data {
>                 acpi_handle handle;
>                 u32 type;
>                 void *context;
>         };
>
> And also a function alloc_acpi_hp_work(), which calls acpi_os_hotplug_execute()
> to put the hotplug job onto kacpi_hotplug_wq.
>
> This patch is based on Lu Yinghai's tree:
> git://git.kernel.org/pub/scm/linux/kernel/git/yinghai/linux-yinghai.git for-pci-split-pci-root-hp-2
>
> Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
> ---
>  drivers/acpi/osl.c                 |   28 ++++++++++++------------
>  drivers/acpi/pci_root_hp.c         |   25 +++++++++++++++-------
>  drivers/pci/hotplug/acpiphp_glue.c |   39 +++++++++++++++++++----------------
>  include/acpi/acpiosxf.h            |    7 ++---
>  4 files changed, 55 insertions(+), 44 deletions(-)
>
> diff --git a/drivers/acpi/osl.c b/drivers/acpi/osl.c
> index 311a921..d441b16 100644
> --- a/drivers/acpi/osl.c
> +++ b/drivers/acpi/osl.c
> @@ -52,6 +52,7 @@
>  #include <acpi/acpi.h>
>  #include <acpi/acpi_bus.h>
>  #include <acpi/processor.h>
> +#include <acpi/acpiosxf.h>

not needed.

>
>  #define _COMPONENT             ACPI_OS_SERVICES
>  ACPI_MODULE_NAME("osl");
> @@ -1592,23 +1593,22 @@ void acpi_os_set_prepare_sleep(int (*func)(u8 sleep_state,
>         __acpi_os_prepare_sleep = func;
>  }
>
> -void alloc_acpi_hp_work(acpi_handle handle, u32 type, void *context,
> -                       void (*func)(struct work_struct *work))
> +void acpi_hp_cb_execute(acpi_handle handle, u32 type, void *context,
> +                       acpi_osd_exec_callback function)
>  {
> -       struct acpi_hp_work *hp_work;
> -       int ret;
> +       acpi_status status;
> +       struct acpi_hp_cb_data *cb_data;
>
> -       hp_work = kmalloc(sizeof(*hp_work), GFP_KERNEL);
> -       if (!hp_work)
> +       cb_data = kmalloc(sizeof(struct acpi_hp_cb_data), GFP_KERNEL);
> +       if (!cb_data)
>                 return;
>
> -       hp_work->handle = handle;
> -       hp_work->type = type;
> -       hp_work->context = context;
> +       cb_data->handle = handle;
> +       cb_data->type = type;
> +       cb_data->context = context;
>
> -       INIT_WORK(&hp_work->work, func);
> -       ret = queue_work(kacpi_hotplug_wq, &hp_work->work);
> -       if (!ret)
> -               kfree(hp_work);
> +       status = acpi_os_hotplug_execute(function, cb_data);
> +       if (ACPI_FAILURE(status))
> +               kfree(cb_data);
>  }
> -EXPORT_SYMBOL(alloc_acpi_hp_work);
> +EXPORT_SYMBOL(acpi_hp_cb_execute);
> diff --git a/drivers/acpi/pci_root_hp.c b/drivers/acpi/pci_root_hp.c
> index 7d427e6..2ff83f4 100644
> --- a/drivers/acpi/pci_root_hp.c
> +++ b/drivers/acpi/pci_root_hp.c
> @@ -75,19 +75,20 @@ static void handle_root_bridge_removal(struct acpi_device *device)
>         acpi_bus_hot_remove_device(ej_event);
>  }
>
> -static void _handle_hotplug_event_root(struct work_struct *work)
> +/* This function is of type acpi_osd_exec_callback */
> +static void _handle_hotplug_event_root(void *context)
>  {
>         struct acpi_pci_root *root;
>         char objname[64];
>         struct acpi_buffer buffer = { .length = sizeof(objname),
>                                       .pointer = objname };
> -       struct acpi_hp_work *hp_work;
> +       struct acpi_hp_cb_data *cb_data;
>         acpi_handle handle;
>         u32 type;
>
> -       hp_work = container_of(work, struct acpi_hp_work, work);
> -       handle = hp_work->handle;
> -       type = hp_work->type;
> +       cb_data = (struct acpi_hp_cb_data *)context;
> +       handle = cb_data->handle;
> +       type = cb_data->type;
>
>         root = acpi_pci_find_root(handle);
>
> @@ -124,14 +125,22 @@ static void _handle_hotplug_event_root(struct work_struct *work)
>                 break;
>         }
>
> -       kfree(hp_work); /* allocated in handle_hotplug_event_bridge */
> +       kfree(context); /* allocated in handle_hotplug_event_bridge */
>  }
>
>  static void handle_hotplug_event_root(acpi_handle handle, u32 type,
>                                         void *context)
>  {
> -       alloc_acpi_hp_work(handle, type, context,
> -                               _handle_hotplug_event_root);
> +       /*
> +        * Currently the code adds all hotplug events to the kacpid_wq
> +        * queue when it should add hotplug events to the kacpi_hotplug_wq.
> +        * The proper way to fix this is to reorganize the code so that
> +        * drivers (dock, etc.) do not call acpi_os_execute(), etc.
> +        * For now just re-add this work to the kacpi_hotplug_wq so we
> +        * don't deadlock on hotplug actions.
> +        */
> +       acpi_hp_cb_execute(handle, type, context,
> +                       _handle_hotplug_event_root);
>  }
>
>  static bool acpi_is_root_bridge_object(acpi_handle handle)
> diff --git a/drivers/pci/hotplug/acpiphp_glue.c b/drivers/pci/hotplug/acpiphp_glue.c
> index 0833d2e..b30fc37 100644
> --- a/drivers/pci/hotplug/acpiphp_glue.c
> +++ b/drivers/pci/hotplug/acpiphp_glue.c
> @@ -50,6 +50,8 @@
>  #include <linux/slab.h>
>  #include <linux/acpi.h>
>
> +#include <acpi/acpiosxf.h>
> +

not needed.

>  #include "../pci.h"
>  #include "acpiphp.h"
>
> @@ -1209,7 +1211,8 @@ check_sub_bridges(acpi_handle handle, u32 lvl, void *context, void **rv)
>         return AE_OK ;
>  }
>
> -static void _handle_hotplug_event_bridge(struct work_struct *work)
> +/* This function is of type acpi_osd_exec_callback */
> +static void _handle_hotplug_event_bridge(void *context)
>  {
>         struct acpiphp_bridge *bridge;
>         char objname[64];
> @@ -1217,13 +1220,13 @@ static void _handle_hotplug_event_bridge(struct work_struct *work)
>                                       .pointer = objname };
>         struct acpi_device *device;
>         int num_sub_bridges = 0;
> -       struct acpi_hp_work *hp_work;
> +       struct acpi_hp_cb_data *cb_data;
>         acpi_handle handle;
>         u32 type;
>
> -       hp_work = container_of(work, struct acpi_hp_work, work);
> -       handle = hp_work->handle;
> -       type = hp_work->type;
> +       cb_data = (struct acpi_hp_cb_data *)context;
> +       handle = cb_data->handle;
> +       type = cb_data->type;
>
>         if (acpi_bus_get_device(handle, &device)) {
>                 /* This bridge must have just been physically inserted */
> @@ -1302,7 +1305,7 @@ static void _handle_hotplug_event_bridge(struct work_struct *work)
>         }
>
>  out:
> -       kfree(hp_work); /* allocated in handle_hotplug_event_bridge */
> +       kfree(context); /* allocated in handle_hotplug_event_bridge */
>  }
>
>  /**
> @@ -1324,29 +1327,28 @@ static void handle_hotplug_event_bridge(acpi_handle handle, u32 type,
>          * For now just re-add this work to the kacpi_hotplug_wq so we
>          * don't deadlock on hotplug actions.
>          */
> -       alloc_acpi_hp_work(handle, type, context, _handle_hotplug_event_bridge);
> +       acpi_hp_cb_execute(handle, type, context,
> +                               _handle_hotplug_event_bridge);
>  }
>
> -static void _handle_hotplug_event_func(struct work_struct *work)
> +/* This function is of type acpi_osd_exec_callback */
> +static void _handle_hotplug_event_func(void *context)
>  {
>         struct acpiphp_func *func;
>         char objname[64];
>         struct acpi_buffer buffer = { .length = sizeof(objname),
>                                       .pointer = objname };
> -       struct acpi_hp_work *hp_work;
> +       struct acpi_hp_cb_data *cb_data;
>         acpi_handle handle;
>         u32 type;
> -       void *context;
>
> -       hp_work = container_of(work, struct acpi_hp_work, work);
> -       handle = hp_work->handle;
> -       type = hp_work->type;
> -       context = hp_work->context;
> +       cb_data = (struct acpi_hp_cb_data *)context;
> +       handle = cb_data->handle;
> +       type = cb_data->type;
> +       func = (struct acpiphp_func *)cb_data->context;

too many context looks confusing.

>
>         acpi_get_name(handle, ACPI_FULL_PATHNAME, &buffer);
>
> -       func = (struct acpiphp_func *)context;
> -
>         switch (type) {
>         case ACPI_NOTIFY_BUS_CHECK:
>                 /* bus re-enumerate */
> @@ -1377,7 +1379,7 @@ static void _handle_hotplug_event_func(struct work_struct *work)
>                 break;
>         }
>
> -       kfree(hp_work); /* allocated in handle_hotplug_event_func */
> +       kfree(context); /* allocated in handle_hotplug_event_func */
>  }
>
>  /**
> @@ -1399,7 +1401,8 @@ static void handle_hotplug_event_func(acpi_handle handle, u32 type,
>          * For now just re-add this work to the kacpi_hotplug_wq so we
>          * don't deadlock on hotplug actions.
>          */
> -       alloc_acpi_hp_work(handle, type, context, _handle_hotplug_event_func);
> +       acpi_hp_cb_execute(handle, type, context,
> +                       _handle_hotplug_event_func);
>  }
>
>  static struct acpi_pci_driver acpi_pci_hp_driver = {
> diff --git a/include/acpi/acpiosxf.h b/include/acpi/acpiosxf.h
> index 9f68f69..8825891 100644
> --- a/include/acpi/acpiosxf.h
> +++ b/include/acpi/acpiosxf.h
> @@ -194,14 +194,13 @@ void acpi_os_fixed_event_count(u32 fixed_event_number);
>  /*
>   * Threads and Scheduling
>   */
> -struct acpi_hp_work {
> -       struct work_struct work;
> +struct acpi_hp_cb_data {
>         acpi_handle handle;
>         u32 type;
>         void *context;
>  };
> -void alloc_acpi_hp_work(acpi_handle handle, u32 type, void *context,
> -                       void (*func)(struct work_struct *work));
> +void acpi_hp_cb_execute(acpi_handle handle, u32 type, void *context,
> +                       acpi_osd_exec_callback function);
>
>  acpi_thread_id acpi_os_get_thread_id(void);

Please check if you can just fold
   acpi_hp_cb_execute
callers, and use acpi_os_hotplug_execute directly.

and have two local conext struct too.

>
> --
> 1.7.1
>
