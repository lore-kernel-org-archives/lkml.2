Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751982Ab2GSQew (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 12:34:52 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:59675 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751300Ab2GSQes (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 12:34:48 -0400
Message-ID: <1342715687.1988.16.camel@joe2Laptop>
Subject: Re: [PATCH 1/4] ACPI: Add acpi_pr_<level>() interfaces
From: Joe Perches <joe@perches.com>
To: shuah.khan@hp.com, "Moore, Robert" <robert.moore@intel.com>
Cc: Toshi Kani <toshi.kani@hp.com>, lenb@kernel.org,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        bhelgaas@google.com, isimatu.yasuaki@jp.fujitsu.com, liuj97@gmail.com,
        srivatsa.bhat@linux.vnet.ibm.com, prarit@redhat.com,
        imammedo@redhat.com, vijaymohan.pandarathil@hp.com,
        shuahkhan@gmail.com
Date: Thu, 19 Jul 2012 09:34:47 -0700
In-Reply-To: <1342714515.3100.27.camel@lorien2>
References: <1342644027-19559-1-git-send-email-toshi.kani@hp.com>
	 <1342644027-19559-2-git-send-email-toshi.kani@hp.com>
	 <1342648771.5138.37.camel@lorien2>
	 <1342650386.3010.55.camel@misato.fc.hp.com>
	 <1342651257.5138.44.camel@lorien2>
	 <1342651966.3010.66.camel@misato.fc.hp.com>
	 <1342653482.5138.56.camel@lorien2>
	 <1342658296.3010.136.camel@misato.fc.hp.com>
	 <1342714515.3100.27.camel@lorien2>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-07-19 at 10:15 -0600, Shuah Khan wrote:
> On Wed, 2012-07-18 at 18:38 -0600, Toshi Kani wrote:
> 
> > 
> > This interface is defined in acpi/acpi_bus.h, which is intended for ACPI
> > drivers which make many ACPI calls to proceed when they are called at
> > run-time today.  This interface does not change that, and I believe
> > acpi_get_name() is much faster compared to ACPI method calls these ACPI
> > drivers make in their normal code path.  The extra work to call
> > acpi_get_name() is simply a noise in this case (if you try to measure),
> > and the use of this interface is limited in error paths of such ACPI
> > drivers.
> 
> I understand the scope of the usage of this new interface. I don't think
> I am able to explain the problem I see with this interface as it gets
> used more and more from acpi drivers. Let me try another way.
> 
> If understand the this patch set, if and when acpi drivers that
> currently use pr_* interfaces switch to using acpi_pr_*, the execution
> path goes from a what printk() does to the following:
> 
> acpi_pr_*
> - setup static buffer
> - calls acpi_get_name()
> - acpi_get_name() calls acpi_ut_validate_buffer() and then calls
>   acpi_ns_handle_to_pathname()
> - acpi_ns_handle_to_pathname() calls acpi_ns_validate_handle() followed
>   by acpi_ns_get_pathname_length() and so on.
> 
> I think this should give you a good idea of my concern. I think
> acpi_pr_* full functionality should be enabled under special cases such
> as some acpi_debug level setting or some other way, and not for default
> case. I propose the following:
> 
> Make acpi_pr_* versions execute the full path to do acpi_get_name()
> conditionally and not as a default case.

or maybe cache one or two.

> To illustrate my point further, I currently see the following ACPI
> messages in my dmesg buffer on my laptop. I haven't taken the time to
> evaluate how many of them originate from acpi drivers, however I would
> not want to see all of these becoming acpi_pr_* versions that do more
> than what pr_* does today. I hope this explains my concern clearly.
> 
> [    0.000000] ACPI: RSDP 00000000000fc600 00024 (v02 HPQOEM)
> [    0.000000] ACPI: XSDT 00000000bb7fe120 00084 (v01 HPQOEM SLIC-MPC
> 0000000F      01000013)

[120+ lines of ACPI stuff]

> [    0.739844] ACPI: ACPI bus type pnp unregistered

I think ACPI is the noisiest subsystem.

I'd rather see this logging made quieter by conversion to
KERN_DEBUG or another selective mechanism.

There just aren't many ACPI_INFO calls around and that why
I thought it reasonable to convert the macro to call a
different named function.

