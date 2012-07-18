Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755994Ab2GRWlI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 18:41:08 -0400
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:27289 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751920Ab2GRWlD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 18:41:03 -0400
Message-ID: <1342651257.5138.44.camel@lorien2>
Subject: Re: [PATCH 1/4] ACPI: Add acpi_pr_<level>() interfaces
From: Shuah Khan <shuah.khan@hp.com>
Reply-To: shuah.khan@hp.com
To: Toshi Kani <toshi.kani@hp.com>
Cc: lenb@kernel.org, linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        bhelgaas@google.com, isimatu.yasuaki@jp.fujitsu.com, liuj97@gmail.com,
        srivatsa.bhat@linux.vnet.ibm.com, prarit@redhat.com,
        imammedo@redhat.com, vijaymohan.pandarathil@hp.com,
        shuahkhan@gmail.com
Date: Wed, 18 Jul 2012 16:40:57 -0600
In-Reply-To: <1342650386.3010.55.camel@misato.fc.hp.com>
References: <1342644027-19559-1-git-send-email-toshi.kani@hp.com>
	 <1342644027-19559-2-git-send-email-toshi.kani@hp.com>
	 <1342648771.5138.37.camel@lorien2>
	 <1342650386.3010.55.camel@misato.fc.hp.com>
Organization: ISS-Linux
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-07-18 at 16:26 -0600, Toshi Kani wrote:
> On Wed, 2012-07-18 at 15:59 -0600, Shuah Khan wrote:
> > On Wed, 2012-07-18 at 14:40 -0600, Toshi Kani wrote:
> > > This patch introduces acpi_pr_<level>(), where <level> is a message
> > > level such as err/warn/info, to support improved logging messages
> > > for ACPI, esp. in hotplug operations.  acpi_pr_<level>() appends
> > > "ACPI" prefix and ACPI object path to the messages.  This improves
> > > diagnostics in hotplug operations since it identifies an object that
> > > caused an issue in a log file.
> > > 
> > > acpi_pr_<level>() takes acpi_handle as an argument, which is passed
> > > to ACPI hotplug notify handlers from the ACPI CA.  Therefore, it is
> > > always available unlike other kernel objects, such as device.
> > > 
> > > For example, the statement below
> > >   acpi_pr_err(handle, "Device don't exist, dropping EJECT\n");
> > > logs an error message like this:
> > >   ACPI: \_SB_.SCK4.CPU4: Device don't exist, dropping EJECT
> > > 
> > > Signed-off-by: Toshi Kani <toshi.kani@hp.com>
> > > ---
> > >  drivers/acpi/utils.c    |   32 ++++++++++++++++++++++++++++++++
> > >  include/acpi/acpi_bus.h |   18 ++++++++++++++++++
> > >  2 files changed, 50 insertions(+), 0 deletions(-)
> > > 
> > > diff --git a/drivers/acpi/utils.c b/drivers/acpi/utils.c
> > > index 3e87c9c..4097266 100644
> > > --- a/drivers/acpi/utils.c
> > > +++ b/drivers/acpi/utils.c
> > > @@ -454,3 +454,35 @@ acpi_evaluate_hotplug_ost(acpi_handle handle, u32 source_event,
> > >  #endif
> > >  }
> > >  EXPORT_SYMBOL(acpi_evaluate_hotplug_ost);
> > > +
> > > +/**
> > > + * acpi_printk: Print messages with ACPI prefix and object path
> > > + *
> > > + * This function is intended to be called through acpi_pr_<level> macros.
> > > + */
> > > +void
> > > +acpi_printk(const char *level, acpi_handle handle, const char *fmt, ...)
> > > +{
> > > +	struct va_format vaf;
> > > +	va_list args;
> > > +	struct acpi_buffer buffer = {ACPI_ALLOCATE_BUFFER};
> > > +	char *path;
> > > +	acpi_status ret;
> > > +
> > > +	va_start(args, fmt);
> > > +
> > > +	vaf.fmt = fmt;
> > > +	vaf.va = &args;
> > > +
> > > +	ret = acpi_get_name(handle, ACPI_FULL_PATHNAME, &buffer);
> > 
> > One big problem I see with this approach is now each acpi_printk() will
> > result in a call to acpi_get_name() which will invoke several ACPI
> > calls, including a call to acpi_ut_initialize_buffer() which allocates
> > buffer. Is this really warranted? What is the performance impact of this
> > change?
> 
> Hi Shuah,
> 
> This interface is intended to be used by acpi_pr_<level>(), which is
> used for error, warning, debugging, etc.  It is not intended to be used
> in any performance path.
> 

How does one enable this interface to see errors, warns, debugging? Is
there a special mode kernel needs to run in? I am trying to understand
what you mean by "not intended to be used in any performance path". Does
one build a special kernel similar to CONFIG_VM_DEBUG (just happen to
the one I could think off) ?

-- Shuah

