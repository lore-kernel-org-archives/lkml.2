Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992536Ab2KAUMN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 16:12:13 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:51097 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992524Ab2KAUMI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 16:12:08 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Toshi Kani <toshi.kani@hp.com>, ZhangRui <rui.zhang@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>, Len Brown <lenb@kernel.org>,
        Tang Chen <tangchen@cn.fujitsu.com>, bhelgaas@google.com,
        jiang.liu@huawei.com, izumi.taku@jp.fujitsu.com,
        isimatu.yasuaki@jp.fujitsu.com, linux-acpi@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 3/3] Improve container_notify_cb() to support container hot-remove.
Date: Thu, 01 Nov 2012 21:16:13 +0100
Message-ID: <2190235.LV034OX9Ij@vostro.rjw.lan>
User-Agent: KMail/4.8.5 (Linux/3.7.0-rc3; KDE/4.8.5; x86_64; ; )
In-Reply-To: <CAE9FiQXxHz_RntOc2gxxDscv8+mDQ2XBL0sHSrptj_arwUb8-A@mail.gmail.com>
References: <1351668471-31436-1-git-send-email-tangchen@cn.fujitsu.com> <1351788194.19172.98.camel@misato.fc.hp.com> <CAE9FiQXxHz_RntOc2gxxDscv8+mDQ2XBL0sHSrptj_arwUb8-A@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, November 01, 2012 11:28:25 AM Yinghai Lu wrote:
> On Thu, Nov 1, 2012 at 9:43 AM, Toshi Kani <toshi.kani@hp.com> wrote:
> >
> > Rafael pointed out in my CPU hot-remove patch that
> > acpi_bus_hot_remove_device() was not exported for modules.  Looks like
> > you have the same problem here.  FYI, I just sent the following patch
> > that exports acpi_bus_hot_remove_device() and acpi_os_hotplug_execute().
> >
> > https://lkml.org/lkml/2012/11/1/225
> 
> acpi_os_hotplug_execute() does not like having good quality yet.
> 
> c02256be (Zhang Rui           2009-06-23 10:20:29 +0800  941)   /*
> c02256be (Zhang Rui           2009-06-23 10:20:29 +0800  942)    * We
> can't run hotplug code in keventd_wq/kacpid_wq/kacpid_notify_wq
> c02256be (Zhang Rui           2009-06-23 10:20:29 +0800  943)    *
> because the hotplug code may call driver .remove() functions,
> c02256be (Zhang Rui           2009-06-23 10:20:29 +0800  944)    *
> which invoke flush_scheduled_work/acpi_os_wait_events_complete
> c02256be (Zhang Rui           2009-06-23 10:20:29 +0800  945)    * to
> flush these workqueues.
> c02256be (Zhang Rui           2009-06-23 10:20:29 +0800  946)    */
> c02256be (Zhang Rui           2009-06-23 10:20:29 +0800  947)   queue
> = hp ? kacpi_hotplug_wq :
> c02256be (Zhang Rui           2009-06-23 10:20:29 +0800  948)
>  (type == OSL_NOTIFY_HANDLER ? kacpi_notify_wq : kacpid_wq);
> 9ac61856 (Bjorn Helgaas       2009-08-31 22:32:10 +0000  949)
> dpc->wait = hp ? 1 : 0;
> bc73675b (Zhang Rui           2010-03-22 15:48:54 +0800  950)
> bc73675b (Zhang Rui           2010-03-22 15:48:54 +0800  951)   if
> (queue == kacpi_hotplug_wq)
> bc73675b (Zhang Rui           2010-03-22 15:48:54 +0800  952)
>  INIT_WORK(&dpc->work, acpi_os_execute_deferred);
> bc73675b (Zhang Rui           2010-03-22 15:48:54 +0800  953)   else
> if (queue == kacpi_notify_wq)
> bc73675b (Zhang Rui           2010-03-22 15:48:54 +0800  954)
>  INIT_WORK(&dpc->work, acpi_os_execute_deferred);
> bc73675b (Zhang Rui           2010-03-22 15:48:54 +0800  955)   else
> bc73675b (Zhang Rui           2010-03-22 15:48:54 +0800  956)
>  INIT_WORK(&dpc->work, acpi_os_execute_deferred);
> bc73675b (Zhang Rui           2010-03-22 15:48:54 +0800  957)
> 
> really don't know why checking queue and call same code in every branch.
> 
> from comm:
> 
> commit bc73675b99fd9850dd914be01d71af99c5d2a1ae
> Author: Zhang Rui <rui.zhang@intel.com>
> Date:   Mon Mar 22 15:48:54 2010 +0800
> 
>     ACPI: fixes a false alarm from lockdep
> 
>     fixes a false alarm from lockdep, as acpi hotplug workqueue waits other
>     workqueues.
>     http://bugzilla.kernel.org/show_bug.cgi?id=14553
>     https://bugzilla.kernel.org/show_bug.cgi?id=15521
> 
>     Original-patch-from: Andrew Morton <akpm@linux-foundation.org>
>     Signed-off-by: Shaohua Li <shaohua.li@intel.com>
>     Signed-off-by: Zhang Rui <rui.zhang@intel.com>
>     Signed-off-by: Len Brown <len.brown@intel.com>
> 
> diff --git a/drivers/acpi/osl.c b/drivers/acpi/osl.c
> index 8e6d866..900da68 100644
> --- a/drivers/acpi/osl.c
> +++ b/drivers/acpi/osl.c
> @@ -758,7 +758,14 @@ static acpi_status
> __acpi_os_execute(acpi_execute_type type,
>         queue = hp ? kacpi_hotplug_wq :
>                 (type == OSL_NOTIFY_HANDLER ? kacpi_notify_wq : kacpid_wq);
>         dpc->wait = hp ? 1 : 0;
> -       INIT_WORK(&dpc->work, acpi_os_execute_deferred);
> +
> +       if (queue == kacpi_hotplug_wq)
> +               INIT_WORK(&dpc->work, acpi_os_execute_deferred);
> +       else if (queue == kacpi_notify_wq)
> +               INIT_WORK(&dpc->work, acpi_os_execute_deferred);
> +       else
> +               INIT_WORK(&dpc->work, acpi_os_execute_deferred);
> +
>         ret = queue_work(queue, &dpc->work);
> 
>         if (!ret) {
> 
> 
> Len or Rafael,
> can you just revert that silly patch?

We're removing this as per:

http://git.kernel.org/?p=linux/kernel/git/rafael/linux-pm.git;a=commit;h=77f1966ec9763e85e5f1a9202802e90c297b4c21

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
