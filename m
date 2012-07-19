Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751912Ab2GSU4V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 16:56:21 -0400
Received: from g1t0026.austin.hp.com ([15.216.28.33]:42290 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751596Ab2GSU4R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 16:56:17 -0400
Message-ID: <1342731093.3010.245.camel@misato.fc.hp.com>
Subject: Re: [PATCH 1/4] ACPI: Add acpi_pr_<level>() interfaces
From: Toshi Kani <toshi.kani@hp.com>
To: shuah.khan@hp.com
Cc: lenb@kernel.org, linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        bhelgaas@google.com, isimatu.yasuaki@jp.fujitsu.com, liuj97@gmail.com,
        srivatsa.bhat@linux.vnet.ibm.com, prarit@redhat.com,
        imammedo@redhat.com, vijaymohan.pandarathil@hp.com,
        shuahkhan@gmail.com
Date: Thu, 19 Jul 2012 14:51:33 -0600
In-Reply-To: <1342725950.5599.7.camel@lorien2>
References: <1342644027-19559-1-git-send-email-toshi.kani@hp.com>
	 <1342644027-19559-2-git-send-email-toshi.kani@hp.com>
	 <1342648771.5138.37.camel@lorien2>
	 <1342650386.3010.55.camel@misato.fc.hp.com>
	 <1342651257.5138.44.camel@lorien2>
	 <1342651966.3010.66.camel@misato.fc.hp.com>
	 <1342653482.5138.56.camel@lorien2>
	 <1342658296.3010.136.camel@misato.fc.hp.com>
	 <1342714515.3100.27.camel@lorien2>
	 <1342718897.3010.188.camel@misato.fc.hp.com>
	 <1342725950.5599.7.camel@lorien2>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-1.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-07-19 at 13:25 -0600, Shuah Khan wrote:
> On Thu, 2012-07-19 at 11:28 -0600, Toshi Kani wrote:
> > On Thu, 2012-07-19 at 10:15 -0600, Shuah Khan wrote:
> > > On Wed, 2012-07-18 at 18:38 -0600, Toshi Kani wrote:
> > > 
> > > > 
> > > > This interface is defined in acpi/acpi_bus.h, which is intended for ACPI
> > > > drivers which make many ACPI calls to proceed when they are called at
> > > > run-time today.  This interface does not change that, and I believe
> > > > acpi_get_name() is much faster compared to ACPI method calls these ACPI
> > > > drivers make in their normal code path.  The extra work to call
> > > > acpi_get_name() is simply a noise in this case (if you try to measure),
> > > > and the use of this interface is limited in error paths of such ACPI
> > > > drivers.
> > > 
> > > I understand the scope of the usage of this new interface. I don't think
> > > I am able to explain the problem I see with this interface as it gets
> > > used more and more from acpi drivers. Let me try another way.
> > > 
> > > If understand the this patch set, if and when acpi drivers that
> > > currently use pr_* interfaces switch to using acpi_pr_*, the execution
> > > path goes from a what printk() does to the following:
> > > 
> > > acpi_pr_*
> > > - setup static buffer
> > > - calls acpi_get_name()
> > > - acpi_get_name() calls acpi_ut_validate_buffer() and then calls
> > >   acpi_ns_handle_to_pathname()
> > > - acpi_ns_handle_to_pathname() calls acpi_ns_validate_handle() followed
> > >   by acpi_ns_get_pathname_length() and so on.
> > > 
> > > I think this should give you a good idea of my concern. I think
> > > acpi_pr_* full functionality should be enabled under special cases such
> > > as some acpi_debug level setting or some other way, and not for default
> > > case. I propose the following:
> > > 
> > > Make acpi_pr_* versions execute the full path to do acpi_get_name()
> > > conditionally and not as a default case.
> > > 
> > > To illustrate my point further, I currently see the following ACPI
> > > messages in my dmesg buffer on my laptop. I haven't taken the time to
> > > evaluate how many of them originate from acpi drivers, however I would
> > > not want to see all of these becoming acpi_pr_* versions that do more
> > > than what pr_* does today. I hope this explains my concern clearly.
> > 
> > I agree that there are many ACPI messages at boot, and I understand that
> > you concerned with them, but that is a different issue.  It requires a
> > different project to address them.  Changing my patchset won't make any
> > difference.
> 
> On the contrary, your patch set could make the existing problems worse
> by introducing lot of complexity (makes the execution path very long for
> each and every one these messages) in the path that prints messages. As
> more and more acpi code paths start using the new interfaces, it will
> keep getting worse.
> 
> I am not questioning the usefulness of the additional information, I am
> questioning the complexity your patch set adds. The added complexity
> isn't desirable.

That's good.  In the last email, you suggested to make the interface
debug-only, and make it non-default case.  This totally defeats the
purpose, which is why I explained it.  When someone reported an issue,
we do not want to tell him that he will need to reproduce it again with
debug kernel/option.  I am glad to know that you understand this point.

> The design in this patch set needs refinement so it doesn't add to the
> execution path.

I am not sure why you are so much concerned about the complexity.
Frankly, acpi_get_name() is one of the simplest and lightest interfaces
in the ACPI CA.  It does not execute AML at all.  The slowness or
complexity of ACPI comes when it executes AML due to the way ACPI is
defined.  acpi_get_name() simply builds a path info and copies it to an
allocated buffer.

One possible optimization is, like Joe suggested, to avoid a buffer
allocation.  I prefer not to use stack space as I explained to Joe.  We
could statically allocate per-CPU buffer for this, but I do not think it
is worth doing it.  After all, such optimization makes the code
complicated, and does not make any difference in performance.  At
run-time, ACPI is only used when GPE occurs (or accessed from sysfs),
which is infrequent event and has nothing to compare with the
performance paths like syscall and I/Os.  And acpi_pr_<level>() is used
in the error paths of such infrequent events.

If your concern is actually a performance bottleneck in acpi_get_name()
you found in the code, you should report it to the ACPI CA team.

Thanks,
-Toshi

> -- Shuah
> 
> 


