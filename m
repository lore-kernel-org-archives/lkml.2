Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753477Ab2A2BJj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jan 2012 20:09:39 -0500
Received: from mga14.intel.com ([143.182.124.37]:30515 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752156Ab2A2BJg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jan 2012 20:09:36 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="100735687"
Message-ID: <1327799372.7922.49.camel@yhuang-dev>
Subject: Re: [PATCH 2/3] ACPI, APEI: Add RAM mapping support to ACPI
From: Huang Ying <ying.huang@intel.com>
To: Thomas Renninger <trenn@suse.de>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Myron Stowe <myron.stowe@redhat.com>,
        lenb@kernel.org, linux-acpi@vger.kernel.org, rjw@sisk.pl,
        linux-kernel@vger.kernel.org, Tony Luck <tony.luck@intel.com>,
        linux-ia64@vger.kernel.org
Date: Sun, 29 Jan 2012 09:09:32 +0800
In-Reply-To: <201201231651.23270.trenn@suse.de>
References: <201201231651.23270.trenn@suse.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Thomas,

Sorry for late.  Just return from Chinese new year holiday.

On Mon, 2012-01-23 at 16:51 +0100, Thomas Renninger wrote:
> Hi,
> 
> Please ignore my previous mail, my mailer wrongly formatted
> it with html tags and it got filtered out from the lists.
> 
> Firstly: This has to get in quickly if it shouldn't miss
> 3.3 (again). Tiny adjustings (I don't see any, beside the
> issue Bjorn brought up) can still be done later, but I
> guess this rather big one gets rejected by Linus after
> the merge window closed.
> 
> Here again:
> 
> On Saturday, January 21, 2012 09:38:27 PM Bjorn Helgaas wrote:
> > +cc Tony, linux-ia64
> > 
> ...
> > >>  {
> > >> @@ -353,7 +385,7 @@ acpi_os_map_memory(acpi_physical_address phys, acpi_size size)
> > >>
> > >>        pg_off = round_down(phys, PAGE_SIZE);
> > >>        pg_sz = round_up(phys + size, PAGE_SIZE) - pg_off;
> > >> -       virt = acpi_os_ioremap(pg_off, pg_sz);
> > >> +       virt = acpi_map(pg_off, pg_sz);
> Ok, that worked before, also on IA64.
> That means that typically/normally/always io mem is tried to be mapped.
> 
> It's due to the new APEI infrastructure/features that ram could
> get mapped via acpi_os_map_memory.
> 
> Is there any Itanium out there implementing any APEI table?
> Will there ever be one?
> Even if, isn't it a BIOS bug if such stuff is declared in ram and not
> in reserved memory (also on X86)?
> Especially on an Enterprise Itanium platform,
> I guess the vendor should or better has to fix it up.

The reason for this patch can be found in description of my original
patch: 

    ACPI, Add RAM mapping support to ACPI atomic IO support
    
    On one of our testing machine, the following EINJ command lines:
    
      # echo 0x10000000 > param1
      # echo 0xfffffffffffff000 > param2
      # echo 0x8 > error_type
      # echo 1 > error_inject
    
    Will get:
    
      echo: write error: Input/output error
    
    The EIO comes from:
    
        rc = apei_exec_pre_map_gars(&trigger_ctx);
    
    The root cause is as follow.  Normally, ACPI atomic IO support is used
    to access IO memory.  But in EINJ of that machine, it is used to
    access RAM to trigger the injected error.  And the ioremap() called by
    apei_exec_pre_map_gars() can not map the RAM.
    
    This patch add RAM mapping support to ACPI atomic IO support to
    satisfy EINJ requirement.


I think that is reasonable to access the injected address to trigger
some memory error.  So it is hard to say this is a BIOS bug.

Best Regards,
Huang Ying

