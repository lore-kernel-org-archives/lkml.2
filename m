Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752955Ab1HYXag (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 19:30:36 -0400
Received: from mga01.intel.com ([192.55.52.88]:60588 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752107Ab1HYXaf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 19:30:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,282,1312182000"; 
   d="scan'208";a="45163086"
Subject: Re: [PATCH 1/2] x86, ioapic: Reserve only 128 bytes for IOAPICs
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "RalfJungralfjung-e@gmx.de" <RalfJungralfjung-e@gmx.de>,
        Cyrill Gorcunov <gorcunov@openvz.org>, Yinghai Lu <yinghai@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 25 Aug 2011 16:33:44 -0700
In-Reply-To: <20110825230539.5355.13851.stgit@bhelgaas.mtv.corp.google.com>
References: <20110825230539.5355.13851.stgit@bhelgaas.mtv.corp.google.com>
Organization: Intel Corp
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.1 (3.0.1-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1314315225.16133.30.camel@sbsiddha-desk.sc.intel.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-08-25 at 16:05 -0700, Bjorn Helgaas wrote:
> Previously we reserved 1024 bytes, but that's more space than the IOAPIC
> consumes, and it can cause conflicts with nearby devices.  The known
> requirement is 68 bytes (sizeof(struct io_apic)), and rounding up to a
> power-of-2 gives us 128.
> 

Bjorn, Given the info from Intel that most of its io-apic
implementations has registers up to 0xff offset (reserved), does
reserving just the 128 bytes for the io-apic cause any address conflicts
if the next 128 bytes are allocated (by the OS) for any other device.

Or OS doesn't allocate this range to any other device and its only the
bios which allocates the addresses in this range and OS just ensures
that there are no conflicts?

thanks,
suresh

> The bug reported below is caused by the following assignments (the IOAPIC
> power-on default and the watchdog address recommended in the AMD SP5100
> BIOS Developer's Guide):
> 
>   IOAPIC[0]        at [mem 0xfec00000-0xfec003ff]
>   SP5100 TCO timer at [mem 0xfec000f0-0xfec000f7]
> 
> Reported-by: Ralf Jung ralfjung-e@gmx.de
> Reference: http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=638863
> Cc: Cyrill Gorcunov <gorcunov@openvz.org>
> Cc: Yinghai Lu <yinghai@kernel.org>
> Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
> ---
>  arch/x86/include/asm/apicdef.h |    7 ++++---
>  1 files changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/include/asm/apicdef.h b/arch/x86/include/asm/apicdef.h
> index 34595d5..855a18a 100644
> --- a/arch/x86/include/asm/apicdef.h
> +++ b/arch/x86/include/asm/apicdef.h
> @@ -12,10 +12,11 @@
>  #define	APIC_DEFAULT_PHYS_BASE		0xfee00000
>  
>  /*
> - * This is the IO-APIC register space as specified
> - * by Intel docs:
> + * I/O APICs are accessed indirectly via an index/data pair and an EOI
> + * register.  For example, see sec 13.5.1, "APIC Register Map," in the
> + * Intel ICH10 datasheet and the struct io_apic definition.
>   */
> -#define IO_APIC_SLOT_SIZE		1024
> +#define IO_APIC_SLOT_SIZE		128
>  
>  #define	APIC_ID		0x20
>  
> 


