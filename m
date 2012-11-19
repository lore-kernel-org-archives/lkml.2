Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753455Ab2KSPph (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 10:45:37 -0500
Received: from g1t0029.austin.hp.com ([15.216.28.36]:45685 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753328Ab2KSPpe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 10:45:34 -0500
Message-ID: <1353339437.10939.37.camel@misato.fc.hp.com>
Subject: Re: [PATCH v5 RESEND 1/5] ACPI: Add acpi_pr_<level>() interfaces
From: Toshi Kani <toshi.kani@hp.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-acpi@vger.kernel.org, lenb@kernel.org, linux-kernel@vger.kernel.org,
        joe@perches.com, bhelgaas@google.com, isimatu.yasuaki@jp.fujitsu.com,
        vijaymohan.pandarathil@hp.com, imammedo@redhat.com, prarit@redhat.com
Date: Mon, 19 Nov 2012 08:37:17 -0700
In-Reply-To: <5543281.izkzCt1DyB@vostro.rjw.lan>
References: <1352214130-12055-1-git-send-email-toshi.kani@hp.com>
	 <1352214130-12055-2-git-send-email-toshi.kani@hp.com>
	 <5543281.izkzCt1DyB@vostro.rjw.lan>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-11-19 at 09:10 +0100, Rafael J. Wysocki wrote:
> On Tuesday, November 06, 2012 08:02:06 AM Toshi Kani wrote:
> > This patch introduces acpi_pr_<level>(), where <level> is a kernel
> > message level such as err/warn/info, to support improved logging
> > messages for ACPI, esp. for hotplug operations.  acpi_pr_<level>()
> > appends "ACPI" prefix and ACPI object path to the messages.  This
> > improves diagnosis of hotplug operations since an error message in
> > a log file identifies an object that caused an issue.
> > 
> > acpi_pr_<level>() takes acpi_handle as an argument, which is passed
> > to ACPI hotplug notify handlers from the ACPICA.  Therefore, it is
> > always available unlike other kernel objects, such as device.
> > 
> > For example:
> >   acpi_pr_err(handle, "Device don't exist, dropping EJECT\n");
> > logs an error message like this at KERN_ERR.
> >   ACPI: \_SB_.SCK4.CPU4: Device don't exist, dropping EJECT
> >
> > ACPI drivers can use acpi_pr_<level>() when they need to identify
> > a target ACPI object path in their messages, such as error cases.
> > The usage model is similar to dev_<level>().  acpi_pr_<level>() can
> > be used when device is not created/valid, which may be the case in
> > ACPI hotplug handlers.  ACPI object path is also consistent on the
> > platform, unlike device name that changes over hotplug operations.
> > 
> > ACPI drivers should use dev_<level>() when device is valid and
> > acpi_pr_<level>() is already used by the caller in its error path.
> > Device name provides more user friendly information.
> > 
> > ACPI drivers also continue to use pr_<level>() when messages do not
> > need to specify device information, such as boot-up messages.
> > 
> > Note: ACPI_[WARNING|INFO|ERROR]() are intended for the ACPICA and
> > are not associated with the kernel message level.
> 
> Well, the idea is generally good, but unfortunately acpi_get_name() is
> not a cheap operation.  Namely, it takes the global namespace mutex,
> so your acpi_printk() may be a source of serious contention on that
> lock if used excessively from concurrent threads.
> 
> Do you think you can address this problem?

Hi Rafael,

I agree with you that the interface name may sound too generic as if it
can be used for any way.  How about changing the interface name to
acpi_hp_<level>() to clarify that it is intended for hot-plug operations
only?  The key goal is to be able to identify a failed device in
hot-plug error messages, so that we can diagnose an issue.  When used in
hot-plug operations, especially in error paths, the lock contention is
not an issue.  In regular code path (i.e. non-hot-plug operations),
dev_<level>() should be used since device object is available.

Here is a measurement result for the interface.  When there is no
locking contention, acpi_get_name() is reasonably fast as it does not
execute AML.

Avg. acpi_get_name()             587 ns
Avg. printk()                   3420 ns
Avg. kfree()                     238 ns
Avg. acpi_get_time()+kfree()     825 ns


> Moreover, this also means that acpi_printk() cannot be used from interrupt
> context, so it is not a printk() replacement, which at least should be
> documented.

Right.  I will document it in the comment and change log.


Thanks,
-Toshi


