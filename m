Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754789Ab0F2Jnu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 05:43:50 -0400
Received: from cantor.suse.de ([195.135.220.2]:42632 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754658Ab0F2Jns (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 05:43:48 -0400
Date: Tue, 29 Jun 2010 11:43:42 +0200
From: Michal Marek <mmarek@suse.cz>
To: stable@kernel.org
Cc: Krzysztof =?utf-8?Q?Ha=C5=82asa?= <khc@pm.waw.pl>,
       Alan <alan@clueserver.org>, linux-kernel@vger.kernel.org
Subject: [PATCH for stable] kbuild: Fix modpost segfault
Message-ID: <20100629094341.GA26045@sepie.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

please add this to stable, it's a bug that started showing up with newer
gcc. The upstream commit is 1c938663d58b5b2965976a6f54cc51b5d6f691aa.

Thanks,
Michal

From: Krzysztof Halasa <khc@pm.waw.pl>

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

Reported-by: Alan <alan@clueserver.org>
Signed-off-by: Krzysztof Hałasa <khc@pm.waw.pl>
Tested-by: Alan <alan@clueserver.org>
Signed-off-by: Michal Marek <mmarek@suse.cz>


diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
index 3318692..f877900 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -1342,7 +1342,7 @@ static unsigned int *reloc_location(struct elf_info *elf,
 	int section = sechdr->sh_info;
 
 	return (void *)elf->hdr + sechdrs[section].sh_offset +
-		(r->r_offset - sechdrs[section].sh_addr);
+		r->r_offset - sechdrs[section].sh_addr;
 }
 
 static int addend_386_rel(struct elf_info *elf, Elf_Shdr *sechdr, Elf_Rela *r)
