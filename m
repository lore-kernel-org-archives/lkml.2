Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754992Ab0HQOkB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 10:40:01 -0400
Received: from relay1.sgi.com ([192.48.179.29]:37472 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753635Ab0HQOjy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 10:39:54 -0400
Date: Tue, 17 Aug 2010 09:39:49 -0500
From: Jack Steiner <steiner@sgi.com>
To: ykzhao <yakui.zhao@intel.com>
Cc: "mingo@elte.hu" <mingo@elte.hu>, "tglx@linutronix.de" <tglx@linutronix.de>,
        "lenb@kernel.org" <lenb@kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] - Mapping ACPI tables as CACHED
Message-ID: <20100817143948.GA14091@sgi.com>
References: <20100722152220.GA18290@sgi.com> <1279849573.13929.28.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1279849573.13929.28.camel@localhost.localdomain>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 23, 2010 at 09:46:13AM +0800, ykzhao wrote:
> On Thu, 2010-07-22 at 23:22 +0800, Jack Steiner wrote:
> > I'd like feedback on the following performance problem &
> > suggestions for a proper solution.
> > 
> > 
> > Large SGI UV systems (3072p, 5TB) take a long time to boot. A significant
> > part of the boot time is scanning ACPI tables. ACPI tables on UV systems
> > are located in RAM memory that is physically attached to node 0.
> > 
> > User programs (ex., acpidump) read the ACPI tables by mapping them thru
> > /dev/mem.  Although mmap tries to map the tables as CACHED, there are
> > existing kernel UNCACHED mapping that conflict and the tables end up as
> > being mapped UNCACHED.  (See the call to track_pfn_vma_new() in
> > remap_pfn_range()).
> > 
> > Much of the access is to small fields (bytes (checksums), shorts, etc).
> > Late in boot, there is significant scanning of the ACPI tables that take
> > place from nodes other than zero. Since the tables are not cached, each
> > reference accesses physical memory that is attached to remote nodes. These
> > memory requests must cross the numalink interconnect which adds several
> > hundred nsec to each access. This slows the boot process.  Access from
> > node 0, although faster, is still very slow.
> > 
> > 
> > 
> > The following experimental patch changes the kernel mapping for ACPI tables
> > to CACHED. This eliminates the page attibute conflict & allows users to map
> > the tables CACHEABLE. This significantly speeds up boot:
> > 
> > 	38 minutes without the patch
> > 	27 minutes with the patch
> > 		~30% improvement
> > 
> > Time to run ACPIDUMP on a large system:
> > 	527 seconds without the patch
> > 	  8 seconds with the patch
> > 
> > 
> Hi, Jack
>    From the above data it seems that the performance is improved
> significantly after using cached type for ACPI region. 
> 
> But some ACPI region will be used for the communication between OS and
> BIOS. Maybe it is inappropriate to map them as cached. 
> 
> ACPI spec have the following two types of ACPI address range.
>    
>     a. AddressRangeACPI(E820_ACPI): This belongs to the ACPI Reclaim
> Memory. This range is available RAM usable by the OS after it reads the
> ACPI tables.
>     
>     b. AddressRangeNVS(E820_NVS): This belongs to the ACPI NVS Memory.
> This range of addresses is in use or reserved by the system and must not
> be used by the operating system. And this region will also be used for
> the communication between OS and BIOS.  

(Sorry for taking so long to reply. I've been fighting a different set
of fires).

I don't see any issue here for platforms that actually place the ACPI tables
(both E820_ACPI & E820_NVS) in WB memory. This is definitely platform
specific & many platforms wont do this! However, on UV platforms all ACPI
memory is real WB memory.  In fact, the BIOS references it as WB memory
during BIOS initialization.

If the platform supports it, what is the issue in having the OS reference
both E820_ACPI & E820_NVS ACPI tables as WB memory?


> 
> >From the above description maybe the E820_ACPI region can be mapped as
> cached. But this still depends on the BIOS. If the some shared data
> resides in the E820_ACPI region on some BIOS, maybe we can't map the
> E820_ACPI region as cached again. 

Agree. All of this is dependent on the BIOS. Whatever we do needs to
use the memory attributes set by BIOS for the memory regions.

AFAICT linux never reuses the E820_ACPI memory. It remains
reserved and is never reclaimed.  Programs like "acpidump" expect the
E820_ACPI memory to remain intact.


> 
> Thanks.
>    Yakui
> > I don't know if the patch in it's current form is the correct solution. I'm
> > interested in feedback on how this should be solved. I expect there
> > are issues on other platforms so for now, the patch uses x86_platform_ops
> > to change mappings only on UV platforms (I'm paranoid :-).
> > 
> > I also need to experiment with early_ioremap'ing of the ACPI tables. I suspect
> > this is also mapped UNCACHED. There may be additional improvements if this
> > could be mapped CACHED. However, the potential performance gain is much
> > less since these references all occur from node 0.
> > 
> > 
> > 
> > Signed-off-by: Jack Steiner <steiner@sgi.com>
> > 
> > 
> > ---
> >  arch/x86/include/asm/x86_init.h    |    2 ++
> >  arch/x86/kernel/apic/x2apic_uv_x.c |    6 ++++++
> >  arch/x86/kernel/x86_init.c         |    3 +++
> >  drivers/acpi/osl.c                 |   12 +++++++++---
> >  4 files changed, 20 insertions(+), 3 deletions(-)
> > 
> > Index: linux/arch/x86/include/asm/x86_init.h
> > ===================================================================
> > --- linux.orig/arch/x86/include/asm/x86_init.h	2010-07-21 16:53:30.226241589 -0500
> > +++ linux/arch/x86/include/asm/x86_init.h	2010-07-21 16:57:46.614872338 -0500
> > @@ -113,6 +113,7 @@ struct x86_cpuinit_ops {
> >  
> >  /**
> >   * struct x86_platform_ops - platform specific runtime functions
> > + * @is_wb_acpi_tables		E820 ACPI table are in WB memory
> >   * @is_untracked_pat_range	exclude from PAT logic
> >   * @calibrate_tsc:		calibrate TSC
> >   * @get_wallclock:		get time from HW clock like RTC etc.
> > @@ -120,6 +121,7 @@ struct x86_cpuinit_ops {
> >   * @nmi_init			enable NMI on cpus
> >   */
> >  struct x86_platform_ops {
> > +	int (*is_wb_acpi_tables)(void);
> >  	int (*is_untracked_pat_range)(u64 start, u64 end);
> >  	unsigned long (*calibrate_tsc)(void);
> >  	unsigned long (*get_wallclock)(void);
> > Index: linux/arch/x86/kernel/apic/x2apic_uv_x.c
> > ===================================================================
> > --- linux.orig/arch/x86/kernel/apic/x2apic_uv_x.c	2010-07-21 16:53:30.226241589 -0500
> > +++ linux/arch/x86/kernel/apic/x2apic_uv_x.c	2010-07-21 16:54:46.358866486 -0500
> > @@ -58,6 +58,11 @@ static int uv_is_untracked_pat_range(u64
> >  	return is_ISA_range(start, end) || is_GRU_range(start, end);
> >  }
> >  
> > +static int uv_is_wb_acpi_tables(void)
> > +{
> > +	return 1;
> > +}
> > +
> >  static int early_get_nodeid(void)
> >  {
> >  	union uvh_node_id_u node_id;
> > @@ -81,6 +86,7 @@ static int __init uv_acpi_madt_oem_check
> >  		nodeid = early_get_nodeid();
> >  		x86_platform.is_untracked_pat_range =  uv_is_untracked_pat_range;
> >  		x86_platform.nmi_init = uv_nmi_init;
> > +		x86_platform.is_wb_acpi_tables = uv_is_wb_acpi_tables;
> >  		if (!strcmp(oem_table_id, "UVL"))
> >  			uv_system_type = UV_LEGACY_APIC;
> >  		else if (!strcmp(oem_table_id, "UVX"))
> > Index: linux/arch/x86/kernel/x86_init.c
> > ===================================================================
> > --- linux.orig/arch/x86/kernel/x86_init.c	2010-07-21 16:53:30.226241589 -0500
> > +++ linux/arch/x86/kernel/x86_init.c	2010-07-21 16:58:17.106240870 -0500
> > @@ -71,7 +71,10 @@ struct x86_cpuinit_ops x86_cpuinit __cpu
> >  
> >  static void default_nmi_init(void) { };
> >  
> > +static int default_wb_acpi_tables(void) {return 0;}
> > +
> >  struct x86_platform_ops x86_platform = {
> > +	.is_wb_acpi_tables		= default_wb_acpi_tables,
> >  	.is_untracked_pat_range		= default_is_untracked_pat_range,
> >  	.calibrate_tsc			= native_calibrate_tsc,
> >  	.get_wallclock			= mach_get_cmos_time,
> > Index: linux/drivers/acpi/osl.c
> > ===================================================================
> > --- linux.orig/drivers/acpi/osl.c	2010-07-21 16:53:30.226241589 -0500
> > +++ linux/drivers/acpi/osl.c	2010-07-21 17:58:20.370414172 -0500
> > @@ -293,12 +293,18 @@ acpi_os_map_memory(acpi_physical_address
> >  		printk(KERN_ERR PREFIX "Cannot map memory that high\n");
> >  		return NULL;
> >  	}
> > -	if (acpi_gbl_permanent_mmap)
> > +	if (acpi_gbl_permanent_mmap) {
> >  		/*
> >  		* ioremap checks to ensure this is in reserved space
> >  		*/
> > -		return ioremap((unsigned long)phys, size);
> > -	else
> > +		if (x86_platform.is_wb_acpi_tables() &&
> > +				(e820_all_mapped(phys, phys + size, E820_RAM) ||
> > +				e820_all_mapped(phys, phys + size, E820_ACPI) ||
> > +				e820_all_mapped(phys, phys + size, E820_NVS)))
> > +			return ioremap_cache((unsigned long)phys, size);
> > +		else
> > +			return ioremap((unsigned long)phys, size);
> > +	} else
> >  		return __acpi_map_table((unsigned long)phys, size);
> >  }
> >  EXPORT_SYMBOL_GPL(acpi_os_map_memory);
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
