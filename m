Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932094Ab0HQOtX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 10:49:23 -0400
Received: from relay3.sgi.com ([192.48.152.1]:48923 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752380Ab0HQOtS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 10:49:18 -0400
Date: Tue, 17 Aug 2010 09:49:17 -0500
From: Jack Steiner <steiner@sgi.com>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: mingo@elte.hu, tglx@linutronix.de, lenb@kernel.org,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC] - Mapping ACPI tables as CACHED
Message-ID: <20100817144917.GD14091@sgi.com>
References: <20100722152220.GA18290@sgi.com> <20100724001449.GA9618@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100724001449.GA9618@khazad-dum.debian.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 23, 2010 at 09:14:50PM -0300, Henrique de Moraes Holschuh wrote:
> On Thu, 22 Jul 2010, Jack Steiner wrote:
> > Large SGI UV systems (3072p, 5TB) take a long time to boot. A significant
> > part of the boot time is scanning ACPI tables. ACPI tables on UV systems
> > are located in RAM memory that is physically attached to node 0.
> > 
> > User programs (ex., acpidump) read the ACPI tables by mapping them thru
> > /dev/mem.  Although mmap tries to map the tables as CACHED, there are
> > existing kernel UNCACHED mapping that conflict and the tables end up as
> > being mapped UNCACHED.  (See the call to track_pfn_vma_new() in
> > remap_pfn_range()).
> 
> Well, as it was raised in this thread, ACPI tables are likely to be near RAM
> regions used for IPC with the firmware or SMBIOS, and we have no idea of the
> kind of crap that could happen if we enable caching on those areas.

I'm certainly not suggesting that ALL platforms map ACPI tables as WB. That
would be a disaster. Only platforms where BIOS specifically reports that
that tables are in WB memory should be mapped as MB.


> 
> OTOH, we *know* of systems that force us to copy the ACPI tables to regular
> RAM, otherwise, the utterly broken BIOS corrupts the ACPI tables after the
> kernel has loaded.
> 
> Couldn't we simply always copy all tables to regular RAM and mark THAT as
> cacheable (since there will be no IPC regions in it)?  For the tables that
> are only used once, we can free the RAM later.

I'm really out of the area of the kernel that I understand   :-)

What are the implications of copying the ACPI tables to another location?
Does BIOS ever make changes to their tables that would make it necessary
to update the OS copy?

While copying tables might sound attractive, it seems like there is a
ripple effect.  For example, acpidump does the following:

        - opens /sys/firmware/efi/systable
        - reads the physical address of the ACPI20 table
                (strace)
                open("/sys/firmware/efi/systab", O_RDONLY) = 3
                read(3, "MPS=0x0\nACPI20=0x78d76014\nACPI=0"..., 4096) = 83
                (contents)
                ACPI20=0x78d76014
                SMBIOS=0x78c33000

        - opens /dev/mem
                (strace)
                open("/dev/mem", O_RDONLY) = 4
                mmap(NULL, 396, PROT_READ, MAP_PRIVATE, 4, 0x78d76000)

        - mmaps the physical address of the ACPI20 table
        - reads the table

If the ACPI tables are copied to a different location, I don't see a
clean/simple way to make this work.

It seems like the best approach would to provide platform specific hooks
in ACPI to map the tables as WB in the first place - IF the platform supports it.


--- jack
