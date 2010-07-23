Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758684Ab0GWQif (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 12:38:35 -0400
Received: from relay1.sgi.com ([192.48.179.29]:50953 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751125Ab0GWQid (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 12:38:33 -0400
Date: Fri, 23 Jul 2010 11:38:27 -0500
From: Jack Steiner <steiner@sgi.com>
To: Len Brown <lenb@kernel.org>
Cc: mingo@elte.hu, tglx@linutronix.de, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC] - Mapping ACPI tables as CACHED
Message-ID: <20100723163827.GB17159@sgi.com>
References: <20100722152220.GA18290@sgi.com> <alpine.LFD.2.00.1007221150360.3164@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1007221150360.3164@localhost.localdomain>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 22, 2010 at 11:52:02AM -0400, Len Brown wrote:
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
> 
> Interesting.
> 
> Can you detect a performance differene on a 1-node machine
> that doesn't magnify the penalty of the remote uncached access?


I timed acpidump on a smaller system running from both node 0 & a higher
node.
        Serial number: UV-00000041
        Partition number: 0
        4 Blades
        8 Nodes (Nehalem-EX sockets)
        64 CPUs
        60.87 Gb Memory Total


Times to run acpidump are (aver of 100 runs) show that cached runs 4X to 14X
faster than uncached, depending on the node it is running from. Since the
system is small, the total runtime is small.

        baseline
                .143 sec node 0
                .479 sec node 7

        ACPI tables mapped cached
                .034 sec node 0
                .037 sec node 7


I added trace code to remap_pfn_range() to see what ranges are mmapped.
The ranges are (first number is the number of times the range was mapped):

      2 : paddr 0x78d1c000 - 0x79d1c000         DSDT @ 0x78d1c000
      2 : paddr 0x78d1c000 - 0x9bd1c000         DSDT @ 0x78d1c000 << ???
      4 : paddr 0x78d3f000 - 0x79d3f000         FACS @ 0x78d3f000
      4 : paddr 0x78d6f000 - 0x79d6f000         DMAR @ 0x78d6f000
      4 : paddr 0x78d70000 - 0x79d70000         SPCR @ 0x78d70000
      4 : paddr 0x78d71000 - 0x79d71000         MCFG @ 0x78d71000
      4 : paddr 0x78d72000 - 0x79d72000         SRAT @ 0x78d72000
      4 : paddr 0x78d74000 - 0x79d74000         APIC @ 0x78d74000
      4 : paddr 0x78d76000 - 0x79d76000         SLIT @ 0x78d76000
      4 : paddr 0x78d78000 - 0x79d78000         HPET @ 0x78d78000
      2 : paddr 0x78d79000 - 0x79d79000         SSDT @ 0x78d79000
      2 : paddr 0x78d79000 - 0x7ed79000         SSDT @ 0x78d79000
      4 : paddr 0x78d7f000 - 0x79d7f000         FACP @ 0x78d7f000
      5 : paddr 0x78d80000 - 0x79d80000         ???



These ranges correspond to the following E820 entries

[    0.000000]  BIOS-e820: 000000000008f000 - 0000000000090000 (ACPI NVS)
[    0.000000]  BIOS-e820: 0000000078c61000 - 0000000078cd6000 (ACPI NVS)
[    0.000000]  BIOS-e820: 0000000078cd6000 - 0000000078d3f000 (ACPI data)
[    0.000000]  BIOS-e820: 0000000078d3f000 - 0000000078d61000 (ACPI NVS)
[    0.000000]  BIOS-e820: 0000000078d61000 - 0000000078d81000 (ACPI data)
[    0.000000]  BIOS-e820: 0000000078d81000 - 000000007cde1000 (usable)

and EFI entries:
[    0.000000] EFI: mem136: type=9, attr=0xf, range=[0x0000000078cd6000-0x0000000078d3f000) (0MB)
[    0.000000] EFI: mem137: type=10, attr=0xf, range=[0x0000000078d3f000-0x0000000078d61000) (0MB)
[    0.000000] EFI: mem138: type=9, attr=0xf, range=[0x0000000078d61000-0x0000000078d6f000) (0MB)
[    0.000000] EFI: mem139: type=9, attr=0xf, range=[0x0000000078d6f000-0x0000000078d81000) (0MB)

        attr = 0xf  ==> WB memory (UC WC WT also supported)
        type  9     ==> EFI_ACPI_RECLAIM_MEMORY
        type 10     ==> EFI_ACPI_MEMORY_NVS

