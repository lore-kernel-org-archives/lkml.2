Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759949Ab2EPMSA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 08:18:00 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:39936 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751117Ab2EPMR7 convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:5:1>);
	Wed, 16 May 2012 08:17:59 -0400
Message-Id: <4FB3B734020000780008415D@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Wed, 16 May 2012 13:18:28 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "Matthew Garrett" <mjg59@srcf.ucam.org>
Cc: <mingo@elte.hu>, <tglx@linutronix.de>, <matt.fleming@linux.intel.com>,
        <linux-kernel@vger.kernel.org>, <hpa@zytor.com>
Subject: Re: [PATCH] x86-64: use EFI to deal with platform wall clock
References: <4FB265AB0200007800083CC5@nat28.tlf.novell.com>
 <20120515124707.GB25248@srcf.ucam.org>
 <4FB273EB0200007800083D32@nat28.tlf.novell.com>
 <20120515132006.GA26196@srcf.ucam.org>
In-Reply-To: <20120515132006.GA26196@srcf.ucam.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 15.05.12 at 15:20, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> On Tue, May 15, 2012 at 02:19:07PM +0100, Jan Beulich wrote:
> 
>> I would have expected that things work that way, but they
>> don't. In particular is the function in efi_64.c that's being
>> modified here called from efi_call_phys_{pro,epi}log(), and at
>> that point we can't expect virtual addresses to be uniformly
>> set yet. So it's a physical call that requires the fixup done
>> here, as efi_set_executable() simply expects ->virt_addr to
>> be valid. I suspect that no physical calls other than
>> phys_efi_set_virtual_address_map() were being done so far
>> at all on 64-bit, hiding the problem.
> 
> In that case we need to split the mapping code into two chunks and 
> configure the memory map earlier. You can't depend on __va() doing 
> anything useful on runtime addresses.

Okay, looks like calling efi_ioremap() at this point is possible.
But why is efi_enter_virtual_mode() being called as late as is
the case currently for x86 anyway?

And then again the current logic in efi_enter_virtual_mode()
looks flawed (it assumes two contiguous pieces of direct
mappings, and while on systems with dis-contiguous physical
memory this currently appears to be true, it's not correct - the
holes could have MMIO assignments in them - and hence
shouldn't be relied upon), and I wouldn't want to copy this
elsewhere.

Similarly for efi_ioremap() itself - it neither honors the
cacheability requested by the firmware (calling
set_memory_uc() subsequently isn't sufficient, as the already
established mappings may be used in prefetches already),
nor does its self-recursion look very reliable (why would
init_memory_mapping() do any better on a second call,
and the code doesn't deal with last_map_pfn pointing below
or precisely at phys_addr at all).

Plus the use of set_virtual_address_map is bogus in the first
place, as it makes it impossible for a kexec-ed kernel to also
use EFI services (as it would have to call the function a
second and possibly third time, yet it is not permitted to be
called more than once). Imo all calls have to happen in
physical mode.

So I'm afraid if the patch as I provided it isn't acceptable, and
if the call to efi_enter_virtual_mode() can't be moved ahead
of the one to timekeeping_init(), this winds down to the whole
logic needing a re-write.

Jan

