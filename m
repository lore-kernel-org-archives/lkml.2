Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754650Ab0LJIJZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 03:09:25 -0500
Received: from mail.lixom.net ([70.86.134.90]:49818 "EHLO mail.lixom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754579Ab0LJIJX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 03:09:23 -0500
Date: Fri, 10 Dec 2010 02:09:23 -0600
From: Olof Johansson <olof@lixom.net>
To: Michal Marek <mmarek@suse.cz>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Sam Ravnborg <sam@ravnborg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, raymes@google.com
Subject: [PATCH] modpost: Fix address calculation in reloc_location()
Message-ID: <20101210080923.GA13474@lixom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes a segfault in modpost that is observed when the gold
linker is used to link the input objects.

The problem is that reloc_location (modpost.c) is computing the
address of the relocation target incorrectly. Here, elf->hdr points
to the beginning of the ELF file in memory, sechdr points to the
relocation section header, section is the index of the section
being relocated, and sechdrs[section].sh_offset would be the offset
of that section, relative to the beginning of the ELF file. Adding
elf->hdr + sechdrs[section].sh_offset gives you the address of the
beginning of the section, and adding r->r_offset to that gives you the
address of the location to be relocated. You do not need to subtract
sechdrs[section].sh_addr from that -- the result of this is an address
outside the file, and causes the segfault when addend_386_rel tries to
dereference it.

This bug is not observed when GNU ld is used to link the inputs. The
object file ubuntu/omnibook/omnibook.o is the result of an ld -r of
several other files.  When GNU ld does an ld -r, it sets the vaddr
field for each section to 0, but gold lays out the section addresses
sequentially instead:

Section Headers:
 [Nr] Name              Type            Addr     Off    Size   ES Flg Lk Inf Al
 [ 0]                   NULL            00000000 000000 000000 00      0   0  0
 [ 1] .text             PROGBITS        00000000 000034 004794 00  AX  0   0  4
 [ 2] .data             PROGBITS        0000b9d0 0047c8 0009c0 00  WA  0   0  4
 [ 3] .bss              NOBITS          000162f8 005188 00013c 00  WA  0   0  4
 [ 4] .rodata.str1.1    PROGBITS        00004f2d 0052c4 001b1a 01 AMS  0   0  1
 [ 5] .init.text        PROGBITS        00004794 006dde 0005fa 00  AX  0   0  1
 [ 6] .exit.text        PROGBITS        00004d8e 0073d8 00018a 00  AX  0   0  1
  ...

So the bug in the tool remained undiscovered because the section's vaddr
always happened to be 0.

Signed-off-by: Raymes Khoury <raymes@google.com>
Signed-off-by: Olof Johansson <olof@lixom.net>

---
 scripts/mod/modpost.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
index 1ec7158..623bffc 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -1438,7 +1438,7 @@ static unsigned int *reloc_location(struct elf_info *elf,
 	int section = shndx2secindex(sechdr->sh_info);
 
 	return (void *)elf->hdr + sechdrs[section].sh_offset +
-		r->r_offset - sechdrs[section].sh_addr;
+		r->r_offset;
 }
 
 static int addend_386_rel(struct elf_info *elf, Elf_Shdr *sechdr, Elf_Rela *r)
