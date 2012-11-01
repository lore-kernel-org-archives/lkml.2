Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761322Ab2KAXjy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 19:39:54 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:41424 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756360Ab2KAXjw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 19:39:52 -0400
MIME-Version: 1.0
In-Reply-To: <1920067.RxMJtDGai1@vostro.rjw.lan>
References: <1351668471-31436-1-git-send-email-tangchen@cn.fujitsu.com>
	<11976302.Ya3MGGIAsU@vostro.rjw.lan>
	<CAE9FiQVGPP3+97D2SatH_CBPBpqBZyCe7We=9=x5ZEq8_d0fWQ@mail.gmail.com>
	<1920067.RxMJtDGai1@vostro.rjw.lan>
Date: Thu, 1 Nov 2012 16:39:50 -0700
X-Google-Sender-Auth: A6wsdj6QXmbwvs3kEG5OTEF79Xg
Message-ID: <CAE9FiQW4ONas+m2HWq_xs457xZu3VJ6Nxsq320MD72Khb+sqJg@mail.gmail.com>
Subject: Re: [PATCH v3 3/3] Improve container_notify_cb() to support container hot-remove.
From: Yinghai Lu <yinghai@kernel.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Toshi Kani <toshi.kani@hp.com>, ZhangRui <rui.zhang@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>, Len Brown <lenb@kernel.org>,
        Tang Chen <tangchen@cn.fujitsu.com>, bhelgaas@google.com,
        jiang.liu@huawei.com, izumi.taku@jp.fujitsu.com,
        isimatu.yasuaki@jp.fujitsu.com, linux-acpi@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 1, 2012 at 4:15 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> Subject: ACPI: Make seemingly useless check in osl.c more understandable
>
> There is a seemingly useless check in drivers/acpi/osl.c added by
> commit bc73675 (ACPI: fixes a false alarm from lockdep), which really
> is necessary to avoid false positive lockdep complaints.  Document
> this and rearrange the code related to it so that it makes fewer
> checks.
>
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> ---
>  drivers/acpi/osl.c |   21 ++++++++++++++-------
>  1 file changed, 14 insertions(+), 7 deletions(-)
>
> Index: linux/drivers/acpi/osl.c
> ===================================================================
> --- linux.orig/drivers/acpi/osl.c
> +++ linux/drivers/acpi/osl.c
> @@ -944,17 +944,24 @@ static acpi_status __acpi_os_execute(acp
>          * because the hotplug code may call driver .remove() functions,
>          * which invoke flush_scheduled_work/acpi_os_wait_events_complete
>          * to flush these workqueues.
> +        *
> +        * To prevent lockdep from complaining unnecessarily, make sure that
> +        * there is a different static lockdep key for each workqueue by using
> +        * INIT_WORK() for each of them separately.
>          */
> -       queue = hp ? kacpi_hotplug_wq :
> -               (type == OSL_NOTIFY_HANDLER ? kacpi_notify_wq : kacpid_wq);
> -       dpc->wait = hp ? 1 : 0;
> -
> -       if (queue == kacpi_hotplug_wq)
> +       if (hp) {
> +               queue = kacpi_hotplug_wq;
> +               dpc->wait = 1;
>                 INIT_WORK(&dpc->work, acpi_os_execute_deferred);
> -       else if (queue == kacpi_notify_wq)
> +       } else if (type == OSL_NOTIFY_HANDLER) {
> +               queue = kacpi_notify_wq;
> +               dpc->wait = 0;

yes, much clear.

at the same can you changne
dpc allocation from kmalloc with kzalloc instead.

then we save two lines for dpc->wait = 0

After that

Acked-by: Yinghai Lu <yinghai@kernel.org>

>                 INIT_WORK(&dpc->work, acpi_os_execute_deferred);
> -       else
> +       } else {
> +               queue = kacpid_wq;
> +               dpc->wait = 0;
>                 INIT_WORK(&dpc->work, acpi_os_execute_deferred);
> +       }
>
>         /*
>          * On some machines, a software-initiated SMI causes corruption unless
>
> --
