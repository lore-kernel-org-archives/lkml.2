Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752615Ab0L0XxI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Dec 2010 18:53:08 -0500
Received: from nat.scz.novell.com ([213.151.88.252]:38848 "EHLO pobox.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751530Ab0L0XxH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Dec 2010 18:53:07 -0500
Date: Tue, 28 Dec 2010 00:53:05 +0100
From: Michal Marek <mmarek@suse.cz>
To: Olof Johansson <olof@lixom.net>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Sam Ravnborg <sam@ravnborg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, raymes@google.com
Subject: Re: [PATCH] modpost: Fix address calculation in reloc_location()
Message-ID: <20101227235305.GG21436@pobox.suse.cz>
References: <20101210080923.GA13474@lixom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101210080923.GA13474@lixom.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 10, 2010 at 02:09:23AM -0600, Olof Johansson wrote:
> This patch fixes a segfault in modpost that is observed when the gold
> linker is used to link the input objects.
> 
> The problem is that reloc_location (modpost.c) is computing the
> address of the relocation target incorrectly. Here, elf->hdr points
> to the beginning of the ELF file in memory, sechdr points to the
> relocation section header, section is the index of the section
> being relocated, and sechdrs[section].sh_offset would be the offset
> of that section, relative to the beginning of the ELF file. Adding
> elf->hdr + sechdrs[section].sh_offset gives you the address of the
> beginning of the section, and adding r->r_offset to that gives you the
> address of the location to be relocated. You do not need to subtract
> sechdrs[section].sh_addr from that -- the result of this is an address
> outside the file, and causes the segfault when addend_386_rel tries to
> dereference it.
> 
> This bug is not observed when GNU ld is used to link the inputs. The
> object file ubuntu/omnibook/omnibook.o is the result of an ld -r of
> several other files.  When GNU ld does an ld -r, it sets the vaddr
> field for each section to 0, but gold lays out the section addresses
> sequentially instead:
> 
> Section Headers:
>  [Nr] Name              Type            Addr     Off    Size   ES Flg Lk Inf Al
>  [ 0]                   NULL            00000000 000000 000000 00      0   0  0
>  [ 1] .text             PROGBITS        00000000 000034 004794 00  AX  0   0  4
>  [ 2] .data             PROGBITS        0000b9d0 0047c8 0009c0 00  WA  0   0  4
>  [ 3] .bss              NOBITS          000162f8 005188 00013c 00  WA  0   0  4
>  [ 4] .rodata.str1.1    PROGBITS        00004f2d 0052c4 001b1a 01 AMS  0   0  1
>  [ 5] .init.text        PROGBITS        00004794 006dde 0005fa 00  AX  0   0  1
>  [ 6] .exit.text        PROGBITS        00004d8e 0073d8 00018a 00  AX  0   0  1
>   ...
> 
> So the bug in the tool remained undiscovered because the section's vaddr
> always happened to be 0.
> 
> Signed-off-by: Raymes Khoury <raymes@google.com>
> Signed-off-by: Olof Johansson <olof@lixom.net>
> 
> ---
>  scripts/mod/modpost.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)

Thanks, applied to kbuild-2.6.git#kbuild.

Michal
