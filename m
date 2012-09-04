Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932780Ab2IDVk3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 17:40:29 -0400
Received: from g1t0027.austin.hp.com ([15.216.28.34]:29622 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932503Ab2IDVk1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 17:40:27 -0400
Message-ID: <1346794495.4732.221.camel@misato.fc.hp.com>
Subject: Re: [PATCH] ACPI: Enable SCI_EMULATE to manually simulate physical
 hotplug testing.
From: Toshi Kani <toshi.kani@hp.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ashok Raj <ashok.raj@intel.com>
Date: Tue, 04 Sep 2012 15:34:55 -0600
In-Reply-To: <CAE9FiQXN1kDwSPTH5UWvDPbrtqGgcEKR4dWwYrP57H4aSA-UMA@mail.gmail.com>
References: <1346707623-31476-1-git-send-email-yinghai@kernel.org>
	 <1346776024.4732.196.camel@misato.fc.hp.com>
	 <CAE9FiQXN1kDwSPTH5UWvDPbrtqGgcEKR4dWwYrP57H4aSA-UMA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-1.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-09-04 at 12:17 -0700, Yinghai Lu wrote:
> On Tue, Sep 4, 2012 at 9:27 AM, Toshi Kani <toshi.kani@hp.com> wrote:
> > On Mon, 2012-09-03 at 14:27 -0700, Yinghai Lu wrote:
> >> From: Ashok Raj <ashok.raj@intel.com>
> >>
> >> Emulate an ACPI SCI interrupt to emulate a hot-plug event. Useful
> >> for testing ACPI based hot-plug on systems that don't have the
> >> necessary firmware support.
> >>
> >> Enable CONFIG_ACPI_SCI_EMULATE on kernel compile.
> >>
> >> Now you will notice /sys/kernel/debug/acpi/sci_notify when new kernel is
> >> booted.
> >>
> >> echo "\_SB.PCIB 1" > /sys/kernel/debug/acpi/sci_notify to trigger a hot-add
> >> of root bus that is corresponding to PCIB.
> >>
> >> echo "\_SB.PCIB 3" > /sys/kernel/debug/acpi/sci_notify to trigger a hot-remove
> >> of root bus that is corresponding to PCIB.
> >
> > Hi Yinghai,
> >
> > This feature has been very useful.  Thanks for working on this change.
> > I have a few comments below.
> >
> >
> >> -v2: Update to current upstream, and remove not related stuff.
> >> -v3: According to Len's request, update it to use debugfs.  - Yinghai Lu
> >>
> >> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> >> Cc: Len Brown <lenb@kernel.org>
> >> Cc: linux-acpi@vger.kernel.org
> >>
> >> ===================================================================
> >> ---
> >>  drivers/acpi/Kconfig   |   10 +++
> >>  drivers/acpi/Makefile  |    1
> >>  drivers/acpi/sci_emu.c |  145 +++++++++++++++++++++++++++++++++++++++++++++++++
> >>  3 files changed, 156 insertions(+)
> >>
> >> Index: linux-2.6/drivers/acpi/Kconfig
> >> ===================================================================
> >> --- linux-2.6.orig/drivers/acpi/Kconfig
> >> +++ linux-2.6/drivers/acpi/Kconfig
> >> @@ -272,6 +272,16 @@ config ACPI_BLACKLIST_YEAR
> >>         Enter 0 to disable this mechanism and allow ACPI to
> >>         run by default no matter what the year.  (default)
> >>
> >> +config ACPI_SCI_EMULATE
> >> +        bool "ACPI SCI Event Emulation Support"
> >> +        depends on DEBUG_FS
> >> +     default n
> >> +     help
> >> +       This will enable your system to emulate sci hotplug event
> >> +       notification through proc file system. For example user needs to
> >> +       echo "XXX 0" > /sys/kernel/debug/acpi/sci_notify (where, XXX is
> >> +       a target ACPI device object name present under \_SB scope).
> >> +
> >>  config ACPI_DEBUG
> >>       bool "Debug Statements"
> >>       default n
> >> Index: linux-2.6/drivers/acpi/sci_emu.c
> >> ===================================================================
> >> --- /dev/null
> >> +++ linux-2.6/drivers/acpi/sci_emu.c
> >> @@ -0,0 +1,145 @@
> >> +/*
> >> + *  Code to emulate SCI interrupt for Hotplug node insertion/removal
> >> + */
> >> +#include <linux/init.h>
> >> +#include <linux/module.h>
> >> +#include <linux/kernel.h>
> >> +#include <linux/uaccess.h>
> >> +#include <linux/debugfs.h>
> >> +#include <acpi/acpi_drivers.h>
> >> +
> >> +#include "internal.h"
> >> +
> >> +#include "acpica/accommon.h"
> >> +#include "acpica/acnamesp.h"
> >> +#include "acpica/acevents.h"
> >> +
> >> +#define _COMPONENT           ACPI_SYSTEM_COMPONENT
> >> +ACPI_MODULE_NAME("sci_emu");
> >> +MODULE_LICENSE("GPL");
> >> +
> >> +static struct dentry *sci_notify_dentry;
> >> +
> >> +static void sci_notify_client(char *acpi_name, u32 event)
> >> +{
> >> +     struct acpi_namespace_node *node;
> >> +     acpi_status status, status1;
> >> +     acpi_handle hlsb, hsb;
> >> +     union acpi_operand_object *obj_desc;
> >> +
> >> +     status = acpi_get_handle(NULL, "\\_SB", &hsb);
> >> +     status1 = acpi_get_handle(hsb, acpi_name, &hlsb);
> >
> > Why do you obtain hsb for \_SB when acpi_name is supposed to be a full
> > path name?  Can you simply specify a NULL like this?
> >   status = acpi_get_handle(NULL, acpi_name, &hlsb);
> 
> assume those two main function is from ashok.
> 
> but assume that could make user omit \_SB_?

I looked at the ACPICA code and found that:
 - If a full path is specified in acpi_name, it ignores the arg hsb
("\_SB").
 - If a relative path is specified in acpi_name, it appends the arg hsb.

So, the code looks good to me; assuming that is the intent.

However, the error message below will show up like "\_SB.\_SB.PCIB" when
a full path is specified.

> >
> >> +     if (ACPI_FAILURE(status) || ACPI_FAILURE(status1)) {
> >> +             pr_err(PREFIX
> >> +     "acpi getting handle to <\\_SB.%s> failed inside notify_client\n",
> >> +                     acpi_name);
> >> +             return;
> >> +     }
> >> +
> >> +     status = acpi_ut_acquire_mutex(ACPI_MTX_NAMESPACE);
> >> +     if (ACPI_FAILURE(status)) {
> >> +             pr_err(PREFIX "Acquiring acpi namespace mutext failed\n");
> >> +             return;
> >> +     }
> >> +
> >> +     node = acpi_ns_validate_handle(hlsb);
> >> +     if (!node) {
> >> +             acpi_ut_release_mutex(ACPI_MTX_NAMESPACE);
> >> +             pr_err(PREFIX "Mapping handle to node failed\n");
> >> +             return;
> >> +     }
> >> +
> >> +     /*
> >> +      * Check for internal object and make sure there is a handler
> >> +      * registered for this object
> >> +      */
> >> +     obj_desc = acpi_ns_get_attached_object(node);
> >> +     if (obj_desc) {
> >> +             if (obj_desc->common_notify.notify_list[0]) {
> >
> > Is the above check necessary?  acpi_ev_queue_notify_request() sets up to
> > call the global handler, acpi_gbl_global_notify[0], even if the object
> > does not have a local handler registered.
> 
> Not sure.
> 
> maybe Len or other acpi guyes could answer your questions.

I think this check should be removed, but would like someone to
verify...

Thanks,
-Toshi


> Thanks
> 
> Yinghai Lu
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


