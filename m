Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762095Ab2COVU4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 17:20:56 -0400
Received: from mga03.intel.com ([143.182.124.21]:41528 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756405Ab2COVUy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 17:20:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="78101512"
Subject: Re: [PATCH] Use x2apic_supported() in the default_apic_id_valid()
 function.
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Steffen Persvold <sp@numascale.com>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Daniel J Blueman <daniel@numascale-asia.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org
Date: Thu, 15 Mar 2012 14:21:44 -0700
In-Reply-To: <CAE9FiQUh-kEcLLAZYiy90UJY8-WmXTKhYrjS7HQ40U+Ah2dwNg@mail.gmail.com>
References: <CAE9FiQXC7T7JQRfiry8nHaRYN3ggy9vfzc2jDUzar80hv6pEvw@mail.gmail.com>
	 <1331834583-16070-1-git-send-email-sp@numascale.com>
	 <CAE9FiQUh-kEcLLAZYiy90UJY8-WmXTKhYrjS7HQ40U+Ah2dwNg@mail.gmail.com>
Organization: Intel Corp
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1331846504.16101.12.camel@sbsiddha-desk.sc.intel.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-03-15 at 13:23 -0700, Yinghai Lu wrote:
> On Thu, Mar 15, 2012 at 11:03 AM, Steffen Persvold <sp@numascale.com> wrote:
> > Use x2apic_supported() in the default_apic_id_valid() function. If x2apic mode is disabled (via nox2apic for example), x2apic_supported() will return false.
> >
> > This allows us to substitute the check in arch/x86/kernel/acpi/boot.c::acpi_parse_x2apic and avoid feigning the x2apic cpu feature in the NumaChip apic code.
> >
> > Signed-off-by: Steffen Persvold <sp@numascale.com>
> > Reviewed-by: Daniel J Blueman <daniel@numascale-asia.com>
> 
> I double checked on system with x2apic preenabled,
> nox2apic in boot command line still works well and it
> skips starting APs with apic id > 255.
> 
> Acked-by: Yinghai Lu <yinghai@kernel.org>

This breaks the smpboot check if enabling interrupt-remapping/x2apic
fails on a platform. We will be in xapic mode and we don't clear the
x2apic cpufeature bit in this case and as such smpboot check will fail.

So this change breaks the commit
c284b42abadbb22083bfde24d308899c08d44ffa.

I think the right thing is to have two different apid_id_valid checks
one for xapic driver (apic_flat_64.c) and another for x2apic driver
(x2apic_phys/cluster.c) and that way, x2apic MADT entries will be parsed
only if bios has handed over the OS in x2apic mode or if we have
selected the numachip model.

thanks,
suresh


