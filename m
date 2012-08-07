Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756544Ab2HGUu7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 16:50:59 -0400
Received: from mga11.intel.com ([192.55.52.93]:6321 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755857Ab2HGUu5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 16:50:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="194378605"
Subject: Re: IRQ remapping problem on Macbook Air 5,1
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Joerg Roedel <joro@8bytes.org>
Cc: Seth Forshee <seth.forshee@canonical.com>, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, x86@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Len Brown <lenb@kernel.org>,
        Joerg Roedel <joerg.roedel@amd.com>, Yinghai Lu <yinghai@kernel.org>
Date: Tue, 07 Aug 2012 13:47:52 -0700
In-Reply-To: <20120807201030.GJ1917@8bytes.org>
References: <20120807194837.GB23829@thinkpad-t410>
	 <20120807201030.GJ1917@8bytes.org>
Organization: Intel Corp
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1344372472.27383.8.camel@sbsiddha-desk.sc.intel.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-08-07 at 22:10 +0200, Joerg Roedel wrote:
> Hi Seth,
> 
> On Tue, Aug 07, 2012 at 02:48:37PM -0500, Seth Forshee wrote:
> > This machine has a bug in its ACPI tables that's causing it to fail to
> > boot unless intremap=off is passed to the kernel. The MADT defines a
> > single IOAPIC with id 2, but the remapping unit defined in DMAR matches
> > id 0. Thus interrupt remapping fails, and the kernel panics with the
> > message "timer doesn't work through Interrupt-remapped IO-APIC." If I
> > force the use of the non-matching ir hardware for the IOAPIC everything
> > seems to works fine. dmesg for the working boot is below.
> 
> There are AMD systems with similar problems. For example I had a system
> with 2 IO-APICs but only one was described in the IOMMU ACPI table.

This issue should be caught by the current check in
parse_ioapics_under_ir()

if (ir_supported && ir_ioapic_num != nr_ioapics) {
...

> 
> > I'm looking at how to make this machine able to boot by default. OS X
> > obviously boots, and Windows presumably boots as well since Apple
> > officially supports running Windows on its hardware.
> 
> These operating systems probably don't support interrupt remapping, or
> the IOMMU at all.

Some of them use interrupt-remapping only if the bios has pre-enabled
x2apic/interrupt-remapping etc. But Linux tries to enable
x2apic/interrupt-remapping even if bios doesn't.

> 
> > I've got a patch to leave IRQ remapping disabled whenever any IOAPIC
> > does not have a matching ir hardware unit. This gets it to boot, but I
> > thought I'd check and see whether anyone had any better ideas for how to
> > fix this.
> 
> This is exactly how I fixed this issue on the AMD side too. Mind to
> submit the patch?

yes, we should be able to extend the check in parse_ioapics_under_ir()
to check for this condition.

thanks,
suresh

