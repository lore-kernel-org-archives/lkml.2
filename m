Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751833Ab0LFJ1x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 04:27:53 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:51107 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751035Ab0LFJ1v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 04:27:51 -0500
MIME-Version: 1.0
In-Reply-To: <201010252025.24128.arnd@arndb.de>
References: <20101025085812.25275.55757.stgit@e102109-lin.cambridge.arm.com>
	<201010251525.09002.arnd@arndb.de>
	<1288023534.14756.109.camel@e102109-lin.cambridge.arm.com>
	<201010252025.24128.arnd@arndb.de>
Date: Mon, 6 Dec 2010 10:27:50 +0100
X-Google-Sender-Auth: BWHmelpJqqnbHM5LwMG68YpderE
Message-ID: <AANLkTimEdNj71v-oiKKho27DWcZbxOWtO6M4eLg2NDRE@mail.gmail.com>
Subject: Re: [RFC PATCH 06/18] ARM: LPAE: Introduce the 3-level page table
 format definitions
From: Christoffer Dall <cdall@cs.columbia.edu>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for jumping in here at such a late hour...

>> You can look at the IPA as the virtual address translation set up by the
>> hypervisor (stage 2 translation). The guest OS only sets up stage 1
>> translations but can use 40-bit physical addresses (via stage 1) with or
>> without the hypervisor. The input to the stage 1 translations is always
>> 32-bit.
>
>
> Right, that's what I thought.
>
>> > Are there any significant differences to Linux between setting up page
>> > tables for a 32 bit VA space or a 40 bit IPA space, other than the
>> > size of the PGD?
>>
>> I think I get what you were asking :).
>>
>> >From KVM you could indeed set up stage 2 translations that a guest OS
>> can use (you need some code running in hypervisor mode to turn this on).
>> The format is pretty close to the stage 1 tables, so the Linux macros
>> could be reused. The PGD size would be different (depending on whether
>> you want to emulate 40-bit physical address space or a 32-bit one).
>> There are also a few bits (memory attributes) that may differ but you
>> could handle them in KVM.
>>
>> If KVM would reuse the existing pgd/pmd/pte Linux macros, it would
>> indeed be restricted to 32-bit IPA (sizeof(long)). You may need to
>> define different macros to use either a pfn or long long as address
>> input.

I'm not even sure it would be a big advantage to re-use the macros for
KVM. Sure, creating separate macros may duplicate some bit-shifting
logic, but my guess is that code will be easier to read if using
separate macros for the 2-nd stage translation in KVM. One might also
imagine specific virtualization-oriented bits which could be
explicitly names or directly targeted in macros that don't have to
handle both standard non-virt tables and 2-nd stage translation
tables.

At least from my experience writing KVM code, it's difficult enough to
make it clear to anyone reading the code which address space exactly
is being referenced at which time.

>> But if KVM uses qemu for platform emulation, this may only support
>> 32-bit physical address space so the guest OS could only generate 32-bit
>> IPA.
>
> Good point. At the very least, qemu would need a way to get at the highmem
> portion of the guest that is not normally part of the qemu virtual address
> space. In fact this would already be required without LPAE in order to run
> a VM with 4GB guest physical addressing.
>
> There are probable (slow) ways of doing that, e.g. remap_file_pages or
> a new syscall for accessing high guest memory. It's not entirely clear
> to me how useful that is, the most sensible way to start here is certainly
> to start out with a 32-bit IPA as you suggested and see how badly that
> limits guests in real-world setups.

So this depends on what the use would be. True, if you wanted a guest
that used more than 4GB of memory AND you wanted QEMU to be able to
readily access all of that, then yes, it would be difficult on a
32-bit architecture.

But QEMU doesn't really use the mmap'ed areas backing physical memory
for anything - it's merely a way of telling KVM how much physical
memory should be given to the guest, and the kernel side conveniently
uses get_user_pages() to access that memory. Instead, QEMU could
simply call an IOCTL to KVM telling it something like
register_user_memory(long long base_phys_addr, long long size); and
KVM could just allocate physical pages to back that without them being
mapped on the host side. An individual page could be mapped in as
needed for emulation and mapped out again. I don't see a huge
performance hit for such a solution.

But as you both suggest, 32-bit physical address space is probably
going to be more than needed for initial uses of ARM virtual machines.

-Christoffer
