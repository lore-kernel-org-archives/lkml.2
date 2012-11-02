Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756745Ab2KBBMQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 21:12:16 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:51571 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760019Ab2KBBMK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 21:12:10 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Toshi Kani <toshi.kani@hp.com>, ZhangRui <rui.zhang@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>, Len Brown <lenb@kernel.org>,
        Tang Chen <tangchen@cn.fujitsu.com>, bhelgaas@google.com,
        jiang.liu@huawei.com, izumi.taku@jp.fujitsu.com,
        isimatu.yasuaki@jp.fujitsu.com, linux-acpi@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 3/3] Improve container_notify_cb() to support container hot-remove.
Date: Fri, 02 Nov 2012 02:16:16 +0100
Message-ID: <2818025.UWNJpCeffI@vostro.rjw.lan>
User-Agent: KMail/4.8.5 (Linux/3.7.0-rc3; KDE/4.8.5; x86_64; ; )
In-Reply-To: <CAE9FiQW4ONas+m2HWq_xs457xZu3VJ6Nxsq320MD72Khb+sqJg@mail.gmail.com>
References: <1351668471-31436-1-git-send-email-tangchen@cn.fujitsu.com> <1920067.RxMJtDGai1@vostro.rjw.lan> <CAE9FiQW4ONas+m2HWq_xs457xZu3VJ6Nxsq320MD72Khb+sqJg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, November 01, 2012 04:39:50 PM Yinghai Lu wrote:
> On Thu, Nov 1, 2012 at 4:15 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > Subject: ACPI: Make seemingly useless check in osl.c more understandable
> >
> > There is a seemingly useless check in drivers/acpi/osl.c added by
> > commit bc73675 (ACPI: fixes a false alarm from lockdep), which really
> > is necessary to avoid false positive lockdep complaints.  Document
> > this and rearrange the code related to it so that it makes fewer
> > checks.
> >
> > Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > ---
> >  drivers/acpi/osl.c |   21 ++++++++++++++-------
> >  1 file changed, 14 insertions(+), 7 deletions(-)
> >
> > Index: linux/drivers/acpi/osl.c
> > ===================================================================
> > --- linux.orig/drivers/acpi/osl.c
> > +++ linux/drivers/acpi/osl.c
> > @@ -944,17 +944,24 @@ static acpi_status __acpi_os_execute(acp
> >          * because the hotplug code may call driver .remove() functions,
> >          * which invoke flush_scheduled_work/acpi_os_wait_events_complete
> >          * to flush these workqueues.
> > +        *
> > +        * To prevent lockdep from complaining unnecessarily, make sure that
> > +        * there is a different static lockdep key for each workqueue by using
> > +        * INIT_WORK() for each of them separately.
> >          */
> > -       queue = hp ? kacpi_hotplug_wq :
> > -               (type == OSL_NOTIFY_HANDLER ? kacpi_notify_wq : kacpid_wq);
> > -       dpc->wait = hp ? 1 : 0;
> > -
> > -       if (queue == kacpi_hotplug_wq)
> > +       if (hp) {
> > +               queue = kacpi_hotplug_wq;
> > +               dpc->wait = 1;
> >                 INIT_WORK(&dpc->work, acpi_os_execute_deferred);
> > -       else if (queue == kacpi_notify_wq)
> > +       } else if (type == OSL_NOTIFY_HANDLER) {
> > +               queue = kacpi_notify_wq;
> > +               dpc->wait = 0;
> 
> yes, much clear.
> 
> at the same can you changne
> dpc allocation from kmalloc with kzalloc instead.
> 
> then we save two lines for dpc->wait = 0

Good idea. :-)

> After that
> 
> Acked-by: Yinghai Lu <yinghai@kernel.org>

For completeness:

---
From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Subject: ACPI: Make seemingly useless check in osl.c more understandable

There is a seemingly useless check in drivers/acpi/osl.c added by
commit bc73675 (ACPI: fixes a false alarm from lockdep), which really
is necessary to avoid false positive lockdep complaints.  Document
this and rearrange the code related to it so that it makes fewer
checks.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Acked-by: Yinghai Lu <yinghai@kernel.org>
---
 drivers/acpi/osl.c |   21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

Index: linux/drivers/acpi/osl.c
===================================================================
--- linux.orig/drivers/acpi/osl.c
+++ linux/drivers/acpi/osl.c
@@ -932,7 +932,7 @@ static acpi_status __acpi_os_execute(acp
 	 * having a static work_struct.
 	 */
 
-	dpc = kmalloc(sizeof(struct acpi_os_dpc), GFP_ATOMIC);
+	dpc = kzalloc(sizeof(struct acpi_os_dpc), GFP_ATOMIC);
 	if (!dpc)
 		return AE_NO_MEMORY;
 
@@ -944,17 +944,22 @@ static acpi_status __acpi_os_execute(acp
 	 * because the hotplug code may call driver .remove() functions,
 	 * which invoke flush_scheduled_work/acpi_os_wait_events_complete
 	 * to flush these workqueues.
+	 *
+	 * To prevent lockdep from complaining unnecessarily, make sure that
+	 * there is a different static lockdep key for each workqueue by using
+	 * INIT_WORK() for each of them separately.
 	 */
-	queue = hp ? kacpi_hotplug_wq :
-		(type == OSL_NOTIFY_HANDLER ? kacpi_notify_wq : kacpid_wq);
-	dpc->wait = hp ? 1 : 0;
-
-	if (queue == kacpi_hotplug_wq)
+	if (hp) {
+		queue = kacpi_hotplug_wq;
+		dpc->wait = 1;
 		INIT_WORK(&dpc->work, acpi_os_execute_deferred);
-	else if (queue == kacpi_notify_wq)
+	} else if (type == OSL_NOTIFY_HANDLER) {
+		queue = kacpi_notify_wq;
 		INIT_WORK(&dpc->work, acpi_os_execute_deferred);
-	else
+	} else {
+		queue = kacpid_wq;
 		INIT_WORK(&dpc->work, acpi_os_execute_deferred);
+	}
 
 	/*
 	 * On some machines, a software-initiated SMI causes corruption unless


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
