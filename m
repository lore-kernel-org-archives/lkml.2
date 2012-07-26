Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752810Ab2GZVDq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 17:03:46 -0400
Received: from g1t0028.austin.hp.com ([15.216.28.35]:41830 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752642Ab2GZVDm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 17:03:42 -0400
Message-ID: <1343336330.3010.496.camel@misato.fc.hp.com>
Subject: Re: [PATCH v3 1/4] ACPI: Add acpi_pr_<level>() interfaces
From: Toshi Kani <toshi.kani@hp.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: lenb@kernel.org, linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        joe@perches.com, isimatu.yasuaki@jp.fujitsu.com, liuj97@gmail.com,
        srivatsa.bhat@linux.vnet.ibm.com, prarit@redhat.com,
        imammedo@redhat.com, vijaymohan.pandarathil@hp.com
Date: Thu, 26 Jul 2012 14:58:50 -0600
In-Reply-To: <CAErSpo4=HDaWTusKf+tRU6aXmj-mC1i7CswnDzDLZii21i9NaQ@mail.gmail.com>
References: <1343257978-7085-1-git-send-email-toshi.kani@hp.com>
	 <1343257978-7085-2-git-send-email-toshi.kani@hp.com>
	 <CAErSpo4=HDaWTusKf+tRU6aXmj-mC1i7CswnDzDLZii21i9NaQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-1.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-07-26 at 13:22 -0600, Bjorn Helgaas wrote:
> On Wed, Jul 25, 2012 at 5:12 PM, Toshi Kani <toshi.kani@hp.com> wrote:
> > This patch introduces acpi_pr_<level>(), where <level> is a kernel
> > message level such as err/warn/info, to support improved logging
> > messages for ACPI, esp. in hotplug operations.  acpi_pr_<level>()
> > appends "ACPI" prefix and ACPI object path to the messages.  This
> > improves diagnostics in hotplug operations since it identifies an
> > object that caused an issue in a log file.
> >
> > acpi_pr_<level>() takes acpi_handle as an argument, which is passed
> > to ACPI hotplug notify handlers from the ACPICA.  Therefore, it is
> > always available unlike other kernel objects, such as device.
> >
> > For example, the statement below
> >   acpi_pr_err(handle, "Device don't exist, dropping EJECT\n");
> > logs an error message like this at KERN_ERR.
> >   ACPI: \_SB_.SCK4.CPU4: Device don't exist, dropping EJECT
> >
> > ACPI drivers can use acpi_pr_<level>() when they need to identify
> > a target ACPI object in their messages, such as error messages.
> 
> It's definitely an improvement to have *something* that identifies a
> device in these messages.  But the ACPI namespace path is not really
> intended to be user-consumable, so I don't think we should expose it
> indiscriminately.  I think we should be using the ACPI device name
> ("PNP0C02:00") whenever possible.  Given the device name, we can get
> the path from the sysfs "path" file.

Hi Bjorn,

Thanks for reviewing!  Yes, ACPI device path is not good for regular
users to analyze from the info.  I also agree with you that device name
is a better choice when users always diagnose issues by themselves right
after they performed an operation.  However, there are also cases that
users ask someone to diagnose an issue remotely from the log files, and
hotplug operations are performed automatically.  In such cases, using
ACPI device name alone is problematic for hotplug operations since a
device name comes with an instance number that continues to change with
hot-add/remove operations.  Here is one example scenario.  Let's say,
user has automatic load-balancer or power-saving that can trigger
hundreds of CPU hotplug operations per a day.  This user then found that
there were multiple hotplug errors logged in the past few days, and
asked an IT guy to look at the error messages.  When this user found the
issue, all device names are gone from sysfs after repeated hotplug
operations.  This IT guy would have no idea if those errors were
happening on a particular device or not from the error messages since
their instance numbers continue to change.

> > The usage model is similar to dev_<level>().  acpi_pr_<level>() can
> > be used when device is not created/valid, which may be the case for
> > ACPI hotplug handlers.  ACPI drivers can continue to use dev_<level>()
> > when device is valid.
> 
> I'd argue that ACPI driver code should never be called unless the
> device is valid, so drivers should *always* be able to use
> dev_<level>.  Obviously, ACPI hotplug is currently screwed up (it's
> mostly handled in drivers rather than in the ACPI core), so in some of
> those hotplug paths in the drivers, we may not have a device yet.  But
> those cases should be minimal.

I think it makes sense for ACPI hotplug notify handlers to use
acpi_pr_<level>() for their error messages since ACPI device names are
static on the platform.  This info greatly helps in the scenario I
described above.  In the outside of the hotplug notify handlers, I agree
with you that dev_<level>() should be used.

> Another possible approach to this is to add a %p extension rather than
> adding acpi_printk().  Then you could do, e.g., 'printk("%pA ...\n",
> handle)', and printk could interpolate the namespace path.  But I
> really think there should be very few places where we need the path,
> so I'm not sure it's worth it.

Address of handle is not very helpful either when someone needs to
analyze from log files.

Thanks,
-Toshi


> > ACPI drivers also continue to use pr_<level>() when ACPI device
> > path does not have to be appended to the messages, such as boot-up
> > messages.
> >
> > Note: ACPI_[WARNING|INFO|ERROR]() are intended for the ACPICA and
> > are not associated with the kernel message level.
> >
> > Signed-off-by: Toshi Kani <toshi.kani@hp.com>
> > Tested-by: Vijay Mohan Pandarathil <vijaymohan.pandarathil@hp.com>
> > ---
> >  drivers/acpi/utils.c    |   34 ++++++++++++++++++++++++++++++++++
> >  include/acpi/acpi_bus.h |   31 +++++++++++++++++++++++++++++++
> >  2 files changed, 65 insertions(+), 0 deletions(-)
> >
> > diff --git a/drivers/acpi/utils.c b/drivers/acpi/utils.c
> > index 3e87c9c..ec0c6f9 100644
> > --- a/drivers/acpi/utils.c
> > +++ b/drivers/acpi/utils.c
> > @@ -454,3 +454,37 @@ acpi_evaluate_hotplug_ost(acpi_handle handle, u32 source_event,
> >  #endif
> >  }
> >  EXPORT_SYMBOL(acpi_evaluate_hotplug_ost);
> > +
> > +/**
> > + * acpi_printk: Print messages with ACPI prefix and object path
> > + *
> > + * This function is intended to be called through acpi_pr_<level> macros.
> > + */
> > +void
> > +acpi_printk(const char *level, acpi_handle handle, const char *fmt, ...)
> > +{
> > +       struct va_format vaf;
> > +       va_list args;
> > +       struct acpi_buffer buffer = {
> > +               .length = ACPI_ALLOCATE_BUFFER,
> > +               .pointer = NULL
> > +       };
> > +       const char *path;
> > +       acpi_status ret;
> > +
> > +       va_start(args, fmt);
> > +       vaf.fmt = fmt;
> > +       vaf.va = &args;
> > +
> > +       ret = acpi_get_name(handle, ACPI_FULL_PATHNAME, &buffer);
> > +       if (ret == AE_OK)
> > +               path = buffer.pointer;
> > +       else
> > +               path = "<n/a>";
> > +
> > +       printk("%sACPI: %s: %pV", level, path, &vaf);
> > +
> > +       va_end(args);
> > +       kfree(buffer.pointer);
> > +}
> > +EXPORT_SYMBOL(acpi_printk);
> > diff --git a/include/acpi/acpi_bus.h b/include/acpi/acpi_bus.h
> > index bde976e..1c855b8 100644
> > --- a/include/acpi/acpi_bus.h
> > +++ b/include/acpi/acpi_bus.h
> > @@ -85,6 +85,37 @@ struct acpi_pld {
> >
> >  acpi_status
> >  acpi_get_physical_device_location(acpi_handle handle, struct acpi_pld *pld);
> > +
> > +void acpi_printk(const char *level, acpi_handle handle, const char *fmt, ...);
> > +
> > +#define acpi_pr_emerg(handle, fmt, ...)                                \
> > +       acpi_printk(KERN_EMERG, handle, fmt, ##__VA_ARGS__)
> > +#define acpi_pr_alert(handle, fmt, ...)                                \
> > +       acpi_printk(KERN_ALERT, handle, fmt, ##__VA_ARGS__)
> > +#define acpi_pr_crit(handle, fmt, ...)                         \
> > +       acpi_printk(KERN_CRIT, handle, fmt, ##__VA_ARGS__)
> > +#define acpi_pr_err(handle, fmt, ...)                          \
> > +       acpi_printk(KERN_ERR, handle, fmt, ##__VA_ARGS__)
> > +#define acpi_pr_warn(handle, fmt, ...)                         \
> > +       acpi_printk(KERN_WARNING, handle, fmt, ##__VA_ARGS__)
> > +#define acpi_pr_notice(handle, fmt, ...)                       \
> > +       acpi_printk(KERN_NOTICE, handle, fmt, ##__VA_ARGS__)
> > +#define acpi_pr_info(handle, fmt, ...)                         \
> > +       acpi_printk(KERN_INFO, handle, fmt, ##__VA_ARGS__)
> > +
> > +/* REVISIT: Need to support CONFIG_DYNAMIC_DEBUG */
> > +#if defined(DEBUG) || defined(CONFIG_DYNAMIC_DEBUG)
> > +#define acpi_pr_debug(handle, fmt, ...)                                        \
> > +       acpi_printk(KERN_DEBUG, handle, fmt, ##__VA_ARGS__)
> > +#else
> > +#define acpi_pr_debug(handle, fmt, ...)                                        \
> > +({                                                                     \
> > +       if (0)                                                          \
> > +               acpi_printk(KERN_DEBUG, handle, fmt, ##__VA_ARGS__);    \
> > +       0;                                                              \
> > +})
> > +#endif
> > +
> >  #ifdef CONFIG_ACPI
> >
> >  #include <linux/proc_fs.h>
> > --
> > 1.7.7.6
> >


