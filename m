Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762253Ab2KAUQ1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 16:16:27 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:62370 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758502Ab2KAUQY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 16:16:24 -0400
MIME-Version: 1.0
In-Reply-To: <1748725.QBg5LLmPOx@vostro.rjw.lan>
References: <1351668471-31436-1-git-send-email-tangchen@cn.fujitsu.com>
	<CAE9FiQXxHz_RntOc2gxxDscv8+mDQ2XBL0sHSrptj_arwUb8-A@mail.gmail.com>
	<1351797478.19172.103.camel@misato.fc.hp.com>
	<1748725.QBg5LLmPOx@vostro.rjw.lan>
Date: Thu, 1 Nov 2012 13:16:22 -0700
X-Google-Sender-Auth: jEHiGmh9_5BCjDGOHr_sY3WGGVg
Message-ID: <CAE9FiQV0gAJabpcoSHhTYq19m-YmaC0O6HH_dFKXUTuvUMG4Fg@mail.gmail.com>
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

On Thu, Nov 1, 2012 at 1:17 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Thursday, November 01, 2012 01:17:58 PM Toshi Kani wrote:
>> On Thu, 2012-11-01 at 11:28 -0700, Yinghai Lu wrote:
>> > On Thu, Nov 1, 2012 at 9:43 AM, Toshi Kani <toshi.kani@hp.com> wrote:
>> > >
>> > > Rafael pointed out in my CPU hot-remove patch that
>> > > acpi_bus_hot_remove_device() was not exported for modules.  Looks like
>> > > you have the same problem here.  FYI, I just sent the following patch
>> > > that exports acpi_bus_hot_remove_device() and acpi_os_hotplug_execute().
>> > >
>> > > https://lkml.org/lkml/2012/11/1/225
>> >
>> > acpi_os_hotplug_execute() does not like having good quality yet.
>> >
>> > c02256be (Zhang Rui           2009-06-23 10:20:29 +0800  941)   /*
>> > c02256be (Zhang Rui           2009-06-23 10:20:29 +0800  942)    * We
>> > can't run hotplug code in keventd_wq/kacpid_wq/kacpid_notify_wq
>> > c02256be (Zhang Rui           2009-06-23 10:20:29 +0800  943)    *
>> > because the hotplug code may call driver .remove() functions,
>> > c02256be (Zhang Rui           2009-06-23 10:20:29 +0800  944)    *
>> > which invoke flush_scheduled_work/acpi_os_wait_events_complete
>> > c02256be (Zhang Rui           2009-06-23 10:20:29 +0800  945)    * to
>> > flush these workqueues.
>> > c02256be (Zhang Rui           2009-06-23 10:20:29 +0800  946)    */
>> > c02256be (Zhang Rui           2009-06-23 10:20:29 +0800  947)   queue
>> > = hp ? kacpi_hotplug_wq :
>> > c02256be (Zhang Rui           2009-06-23 10:20:29 +0800  948)
>> >  (type == OSL_NOTIFY_HANDLER ? kacpi_notify_wq : kacpid_wq);
>> > 9ac61856 (Bjorn Helgaas       2009-08-31 22:32:10 +0000  949)
>> > dpc->wait = hp ? 1 : 0;
>> > bc73675b (Zhang Rui           2010-03-22 15:48:54 +0800  950)
>> > bc73675b (Zhang Rui           2010-03-22 15:48:54 +0800  951)   if
>> > (queue == kacpi_hotplug_wq)
>> > bc73675b (Zhang Rui           2010-03-22 15:48:54 +0800  952)
>> >  INIT_WORK(&dpc->work, acpi_os_execute_deferred);
>> > bc73675b (Zhang Rui           2010-03-22 15:48:54 +0800  953)   else
>> > if (queue == kacpi_notify_wq)
>> > bc73675b (Zhang Rui           2010-03-22 15:48:54 +0800  954)
>> >  INIT_WORK(&dpc->work, acpi_os_execute_deferred);
>> > bc73675b (Zhang Rui           2010-03-22 15:48:54 +0800  955)   else
>> > bc73675b (Zhang Rui           2010-03-22 15:48:54 +0800  956)
>> >  INIT_WORK(&dpc->work, acpi_os_execute_deferred);
>> > bc73675b (Zhang Rui           2010-03-22 15:48:54 +0800  957)
>> >
>> > really don't know why checking queue and call same code in every branch.
>> >
>> > from comm:
>> >
>> > commit bc73675b99fd9850dd914be01d71af99c5d2a1ae
>> > Author: Zhang Rui <rui.zhang@intel.com>
>> > Date:   Mon Mar 22 15:48:54 2010 +0800
>> >
>> >     ACPI: fixes a false alarm from lockdep
>> >
>> >     fixes a false alarm from lockdep, as acpi hotplug workqueue waits other
>> >     workqueues.
>> >     http://bugzilla.kernel.org/show_bug.cgi?id=14553
>> >     https://bugzilla.kernel.org/show_bug.cgi?id=15521
>> >
>> >     Original-patch-from: Andrew Morton <akpm@linux-foundation.org>
>> >     Signed-off-by: Shaohua Li <shaohua.li@intel.com>
>> >     Signed-off-by: Zhang Rui <rui.zhang@intel.com>
>> >     Signed-off-by: Len Brown <len.brown@intel.com>
>> >
>> > diff --git a/drivers/acpi/osl.c b/drivers/acpi/osl.c
>> > index 8e6d866..900da68 100644
>> > --- a/drivers/acpi/osl.c
>> > +++ b/drivers/acpi/osl.c
>> > @@ -758,7 +758,14 @@ static acpi_status
>> > __acpi_os_execute(acpi_execute_type type,
>> >         queue = hp ? kacpi_hotplug_wq :
>> >                 (type == OSL_NOTIFY_HANDLER ? kacpi_notify_wq : kacpid_wq);
>> >         dpc->wait = hp ? 1 : 0;
>> > -       INIT_WORK(&dpc->work, acpi_os_execute_deferred);
>> > +
>> > +       if (queue == kacpi_hotplug_wq)
>> > +               INIT_WORK(&dpc->work, acpi_os_execute_deferred);
>> > +       else if (queue == kacpi_notify_wq)
>> > +               INIT_WORK(&dpc->work, acpi_os_execute_deferred);
>> > +       else
>> > +               INIT_WORK(&dpc->work, acpi_os_execute_deferred);
>> > +
>> >         ret = queue_work(queue, &dpc->work);
>> >
>> >         if (!ret) {
>> >
>> >
>> > Len or Rafael,
>> > can you just revert that silly patch?
>>
>> Hi Yinghai,
>>
>> Per the following thread, the code seems to be written in this way to
>> allocate a separate lock_class_key for each work queue.  It should have
>> had some comment to explain this, though.
>>
>> https://lkml.org/lkml/2009/12/13/304
>
> The code has evolved since then, however, so that it doesn't make sense
> any more.
>

oh, no, that commit should not be reverted. instead we should add some
comment for it...

that mean : three path, will have three separated static lock dep key
from every INIT_WORK.
