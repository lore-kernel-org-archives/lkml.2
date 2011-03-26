Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753788Ab1CZJUC (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Mar 2011 05:20:02 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:64710 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751906Ab1CZJT7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Mar 2011 05:19:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=x5Qkna2Z3p+CNEq6ZbIMcIp6IFQM5VwT2z8fc33x0D28tv/dfx+PEU1PtmWp2OLqHe
         fETSXMMAIfMlGGiiD0nNjh0HHKQjSknBmekDNe6yyH0bnbOCjKGle1ZVn4IVU9nglZFQ
         Lynsg5DgE+yvb/Fjm5ks18BMpf5Qqn9gABvwc=
MIME-Version: 1.0
In-Reply-To: <m1k4fmxtyk.fsf@fess.ebiederm.org>
References: <m1k4fmxtyk.fsf@fess.ebiederm.org>
Date: Sat, 26 Mar 2011 02:19:58 -0700
X-Google-Sender-Auth: lUBKKxGZF-87nf8YbVLuFcPWlcI
Message-ID: <AANLkTikqDbY+W7cXRwFrQg5DSToZYgXn8xGVQK9g3D4R@mail.gmail.com>
Subject: Re: [PATCH] x86_64: Fix page table building regression
From: Yinghai Lu <yinghai@kernel.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>, greg@kroah.com,
        stable@kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 25, 2011 at 11:43 PM, Eric W. Biederman
<ebiederm@xmission.com> wrote:
>
> Recently I had cause to enable PAGE_ALLOC_DEBUG and I discovered my
> kdump kernel would not boot.  After some investigation it turns out that
> in commit 80989ce064 "x86: clean up and and print out initial max_pfn_mapped"
> that a limitation of the 32bit page table setup was unnecessarily
> applied to the 64bit code.  The initial 64bit page table setup code is
> careful to map in it's initial page table pages and unmap then when done
> so they can live anywhere in memory, so we don't need to limit ourselves
> to using pages that are already mapped into memory.
>
> In my case I hit this because the first 512M was not usable by the
> kdump kernel.

We have one completed fix in mainline already.

We need that patch for 2.6.38 stable tree.

that patch is supposed to be for 2.6.38, but is delayed to 2.6.39.

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=4b239f458c229de044d6905c2b0f9fe16ed9e01e

x86-64, mm: Put early page table high

While dubug kdump, found current kernel will have problem with crashkernel=512M.

It turns out that initial mapping is to 512M, and later initial mapping to 4G
(acutally is 2040M in my platform), will put page table near 512M.
then initial mapping to 128g will be near 2g.

before this patch:
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] init_memory_mapping: [0x00000000000000-0x0000007f74ffff]
[    0.000000]  0000000000 - 007f600000 page 2M
[    0.000000]  007f600000 - 007f750000 page 4k
[    0.000000] kernel direct mapping tables up to 7f750000 @
[0x1fffc000-0x1fffffff]
[    0.000000]     memblock_x86_reserve_range: [0x1fffc000-0x1fffdfff]
         PGTABLE
[    0.000000] init_memory_mapping: [0x00000100000000-0x0000207fffffff]
[    0.000000]  0100000000 - 2080000000 page 2M
[    0.000000] kernel direct mapping tables up to 2080000000 @
[0x7bc01000-0x7bc83fff]
[    0.000000]     memblock_x86_reserve_range: [0x7bc01000-0x7bc7efff]
         PGTABLE
[    0.000000] RAMDISK: 7bc84000 - 7f745000
[    0.000000] crashkernel reservation failed - No suitable area found.

after patch:
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] init_memory_mapping: [0x00000000000000-0x0000007f74ffff]
[    0.000000]  0000000000 - 007f600000 page 2M
[    0.000000]  007f600000 - 007f750000 page 4k
[    0.000000] kernel direct mapping tables up to 7f750000 @
[0x7f74c000-0x7f74ffff]
[    0.000000]     memblock_x86_reserve_range: [0x7f74c000-0x7f74dfff]
         PGTABLE
[    0.000000] init_memory_mapping: [0x00000100000000-0x0000207fffffff]
[    0.000000]  0100000000 - 2080000000 page 2M
[    0.000000] kernel direct mapping tables up to 2080000000 @
[0x207ff7d000-0x207fffffff]
[    0.000000]     memblock_x86_reserve_range:
[0x207ff7d000-0x207fffafff]          PGTABLE
[    0.000000] RAMDISK: 7bc84000 - 7f745000
[    0.000000]     memblock_x86_reserve_range: [0x17000000-0x36ffffff]
    CRASH KERNEL
[    0.000000] Reserving 512MB of memory at 368MB for crashkernel
(System RAM: 133120MB)

It means with the patch, page table for [0, 2g) will need 2g, instead
of under 512M,
page table for [4g, 128g) will be near 128g, instead of under 2g.

That would good, if we have lots of memory above 4g, like 1024g, or
2048g or 16T, will not put
related page table under 2g. that would be have chance to fill the
under 2g if 1G or 2M page is
not used.

the code change will use add map_low_page() and update
unmap_low_page() for 64bit, and use them
to get access the corresponding high memory for page table setting.

...
