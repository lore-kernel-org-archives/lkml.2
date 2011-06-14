Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752945Ab1FNRkc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 13:40:32 -0400
Received: from mail.perches.com ([173.55.12.10]:3015 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750899Ab1FNRka (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 13:40:30 -0400
Subject: Re: [PATCH v2] x86, efi: Do not reserve boot services regions
 within reserved areas
From: Joe Perches <joe@perches.com>
To: Maarten Lankhorst <m.b.lankhorst@gmail.com>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, Yinghai Lu <yinghai@kernel.org>,
        Jim Bos <jim876@xs4all.nl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <4DF799A9.8080109@gmail.com>
References: <4DF78A22.8060405@gmail.com>
	 <1308071118.21026.16.camel@Joe-Laptop>  <4DF799A9.8080109@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 14 Jun 2011 10:40:28 -0700
Message-ID: <1308073228.21026.20.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-06-14 at 19:26 +0200, Maarten Lankhorst wrote:
> Op 14-06-11 19:05, Joe Perches schreef:
> > On Tue, 2011-06-14 at 18:19 +0200, Maarten Lankhorst wrote:
> >> Commit 916f676f8dc started reserving boot service code since some systems
> >> require you to keep that code around until SetVirtualAddressMap is called.
> > []
> >> Signed-off-by: Maarten Lankhorst <m.b.lankhorst@gmail.com>
> > Hello Maarten, just trivia.
> >
> >> diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
> > []
> >> +			memblock_dbg(PFX "Could not reserve boot area "
> >> +				"[0x%llx-0x%llx)\n", start, start+size);
> > I believe this should be:
> >
> > 			memblock_dbg(PFX "Could not reserve boot area 0x%llx-0x%llx)\n",
> > 				     start, start + size - 1);
> Erm, no. [x...y) means the range of x to y without including y.
> 
> Other efi code followed that convention, and the e820 code does the same, silently.
> 
> [    0.000000] BIOS-provided physical RAM map:
> [    0.000000]  BIOS-e820: 0000000000000000 - 00000000000a0000 (usable)
> ...
> [    0.000000] EFI: mem00: type=3, attr=0xf, range=[0x0000000000000000-0x0000000000008000) (0MB)
> 
> ~Maarten

The other memblock_dbg uses with range seem to disagree

$ grep -A1 -rP --include=*.[ch] "memblock_dbg.*\%.*llx" *
arch/x86/mm/memblock.c:		memblock_dbg("  [%010llx-%010llx]\n", (u64)r->base, (u64)r->base + r->size - 1);
arch/x86/mm/memblock.c-		final_start = PFN_DOWN(r->base);
--
arch/x86/mm/memblock.c:	memblock_dbg("    memblock_x86_reserve_range: [%#010llx-%#010llx] %16s\n", start, end - 1, name);
arch/x86/mm/memblock.c-
--
arch/x86/mm/memblock.c:	memblock_dbg("       memblock_x86_free_range: [%#010llx-%#010llx]\n", start, end - 1);
arch/x86/mm/memblock.c-
--
mm/memblock.c:	memblock_dbg("memblock: %s array is doubled to %ld at [%#010llx-%#010llx]",
mm/memblock.c-		 memblock_type_name(type), type->max * 2, (u64)addr, (u64)addr + new_size - 1);



