Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757514Ab0HQOmn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 10:42:43 -0400
Received: from relay2.sgi.com ([192.48.179.30]:33513 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757257Ab0HQOmj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 10:42:39 -0400
Date: Tue, 17 Aug 2010 09:42:37 -0500
From: Jack Steiner <steiner@sgi.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: ykzhao <yakui.zhao@intel.com>, "tglx@linutronix.de" <tglx@linutronix.de>,
        "lenb@kernel.org" <lenb@kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC] - Mapping ACPI tables as CACHED
Message-ID: <20100817144237.GB14091@sgi.com>
References: <20100722152220.GA18290@sgi.com> <1279849573.13929.28.camel@localhost.localdomain> <20100723072301.GC23461@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100723072301.GC23461@elte.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 23, 2010 at 09:23:01AM +0200, Ingo Molnar wrote:
> 
> * ykzhao <yakui.zhao@intel.com> wrote:
> 
> > From the above description maybe the E820_ACPI region can be mapped as 
> > cached. But this still depends on the BIOS. If the some shared data resides 
> > in the E820_ACPI region on some BIOS, maybe we can't map the E820_ACPI 
> > region as cached again.
> 
> I dont think we can do this safely unless some other OS (Windows) does it as 
> well. (the reason is that if some BIOS messes this up then it will cause nasty 
> bugs/problems only on Linux.)
> 
> But the benefits of caching are very clear and well measured by Jack, so we 
> want the feature. What we can do is to add an exception for 'known good' hw 
> vendors - i.e. something quite close to Jack's RFC patch, but implemented a 
> bit more cleanly:
> 
> Exposing x86_platform and e820 details to generic ACPI code isnt particularly 
> clean - there should be an ACPI accessor function for that or so: a new 
> acpi_table_can_be_cached(table) function or so.

Agree. I am looking for the right set of abstractions for this.


> 
> In fact since __acpi_map_table(addr,size) is defined by architectures already, 
> this could be done purely within x86 code.

No. Unfortunately the function __acpi_map_tables()  is not called on the
path that does the permanent mappings. The code is (somewhat simplified):

        drivers/acpi/osl.c:

        acpi_os_map_memory(acpi_physical_address phys, acpi_size size)
        {
                if (acpi_gbl_permanent_mmap)
                        return ioremap((unsigned long)phys, size);
                else
                        return __acpi_map_table((unsigned long)phys, size);
        }

Early in boot before "acpi_gbl_permanent_mmap" is set, __acpi_map_table()
is called to map tables.  __acpi_map_table() calls early_iomap() and all
early mappings are subsequently unmapped.

For the permanent mappings, we need a way to make the acpi code call
ioremap_cache() instead of ioremap() for all tables that are actually
in WB memory.

Timings made during boot show only a small benefit __acpi_map_table()
mapping tables cacheable. (I didn't check, but perhaps the early mapping
are only checking table IDs - not the full table).

The performance benefit of WB is for the permanent mapping made after
acpi_gbl_permanent_mmap is set. For some reason, most of the time
consuming references occur after this point. In addition ALL offnode
references occur after this point.


--- jack
