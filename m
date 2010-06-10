Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758671Ab0FJXIY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 19:08:24 -0400
Received: from khc.piap.pl ([195.187.100.11]:56123 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753351Ab0FJXIX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 19:08:23 -0400
From: Krzysztof Halasa <khc@pm.waw.pl>
To: Alan <alan@clueserver.org>
Cc: Michal Marek <mmarek@suse.cz>,
       =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Additional info on modpost segfault
References: <Pine.LNX.4.64.1006032008220.30918@blackbox.fnordora.org>
	<20100604045118.GC5167@cr0.nay.redhat.com> <4C08A9D0.8000505@suse.cz>
	<1275929979.2923.0.camel@zowie.clueserver.org>
Date: Fri, 11 Jun 2010 01:08:20 +0200
In-Reply-To: <1275929979.2923.0.camel@zowie.clueserver.org>
	(alan@clueserver.org's message of "Mon, 07 Jun 2010 09:59:39 -0700")
Message-ID: <m37hm6zdsr.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan <alan@clueserver.org> writes:

> program: /home/alan/GitTrees/linux-2.6-mid-ref/scripts/mod/modpost -o
> Module.symvers -S vmlinux.o
>
> Program received signal SIGSEGV, Segmentation fault.

It just hit me.
It's the offset calculation in reloc_location() which overflows:
        return (void *)elf->hdr + sechdrs[section].sh_offset +
               (r->r_offset - sechdrs[section].sh_addr);

E.g. for the first rodata r entry:
r->r_offset < sechdrs[section].sh_addr
and the expression in the parenthesis produces 0xFFFFFFE0 or something
equally wise.

Does the attached patch fix it?

Signed-off-by: Krzysztof Hałasa <khc@pm.waw.pl>

--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -1317,8 +1317,8 @@ static unsigned int *reloc_location(struct elf_info *elf,
 	Elf_Shdr *sechdrs = elf->sechdrs;
 	int section = sechdr->sh_info;
 
 	return (void *)elf->hdr + sechdrs[section].sh_offset +
-		(r->r_offset - sechdrs[section].sh_addr);
+		r->r_offset - sechdrs[section].sh_addr;
 }
 
 static int addend_386_rel(struct elf_info *elf, Elf_Shdr *sechdr, Elf_Rela *r)
