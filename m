Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755362Ab0IJXqQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 19:46:16 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33286 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755007Ab0IJXqO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 19:46:14 -0400
Date: Fri, 10 Sep 2010 16:45:56 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] acpi: handle ACPI0007 Device in acpi_early_set_pdc
Message-Id: <20100910164556.b72d848e.akpm@linux-foundation.org>
In-Reply-To: <4C8A8504.9000606@kernel.org>
References: <4C89906B.1050406@kernel.org>
	<201009101210.31942.bjorn.helgaas@hp.com>
	<4C8A8504.9000606@kernel.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Sep 2010 12:20:36 -0700
Yinghai Lu <yinghai@kernel.org> wrote:

> On 09/10/2010 11:10 AM, Bjorn Helgaas wrote:
> > On Thursday, September 09, 2010 07:56:59 pm Yinghai Lu wrote:
> >>
> >> When bios switch to use Device object instead of Processor statement.
> >>
> >> the SSDT for Pstate/Cstate/Tstate can not be loaded dynamically.
> >>
> >> So try to scan ACPI0007 in addition to Processor.
> >>
> >> this fix regression: 2.6.32 is ok.
> > 
> > Can you include the URL of the regression bug report?  And maybe
> > the commit that introduced the regression?
> 
> the commit should be
> 
> commit d8191fa4a33fdc817277da4f2b7f771ff605a41c
> Author: Alex Chiang <achiang@hp.com>
> Date:   Mon Feb 22 12:11:39 2010 -0700
> 
>     ACPI: processor: driver doesn't need to evaluate _PDC
>     
>     Now that the early _PDC evaluation path knows how to correctly
>     evaluate _PDC on only physically present processors, there's no
>     need for the processor driver to evaluate it later when it loads.
>     
>     To cover the hotplug case, push _PDC evaluation down into the
>     hotplug paths.
>     
>     Cc: x86@kernel.org
>     Cc: Tony Luck <tony.luck@intel.com>
>     Acked-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
>     Signed-off-by: Alex Chiang <achiang@hp.com>
>     Signed-off-by: Len Brown <len.brown@intel.com>
> 
> that is between 2.6.34-rc1 and 2.6.34-rc2.
> 
> So we need put this patch in stable tree for 2.6.34, .35, .36
> 

Maybe.  But first can you please address Bjorn's suggestions below?

> 
> > 
> >> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> >>
> >> ---
> >>  drivers/acpi/processor_core.c |    1 +
> >>  1 file changed, 1 insertion(+)
> >>
> >> Index: linux-2.6/drivers/acpi/processor_core.c
> >> ===================================================================
> >> --- linux-2.6.orig/drivers/acpi/processor_core.c
> >> +++ linux-2.6/drivers/acpi/processor_core.c
> >> @@ -352,4 +352,5 @@ void __init acpi_early_processor_set_pdc
> >>  	acpi_walk_namespace(ACPI_TYPE_PROCESSOR, ACPI_ROOT_OBJECT,
> >>  			    ACPI_UINT32_MAX,
> >>  			    early_init_pdc, NULL, NULL, NULL);
> >> +	acpi_get_devices("ACPI0007", early_init_pdc, NULL, NULL);
> > 
> > I hate having to walk the namespace.  Usually that's a clue that
> > there's something wrong with our ACPI device model, because it'd
> > be better to handle everything in a driver .add() method.  But
> > maybe this early _PDC thing is so special that it can't be helped
> > in this case.
> > 
> > But I do think you could probably fix this to walk the namespace
> > once rather than twice.  Maybe you could use something like
> > acpi_walk_namespace(ACPI_TYPE_ANY, ...) with a callback that
> > recognizes both ACPI_TYPE_PROCESSOR and "ACPI_TYPE_DEVICE with
> > HID ACPI0007".
> > 
> > Bjorn
