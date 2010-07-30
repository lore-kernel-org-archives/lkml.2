Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755990Ab0G3REM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 13:04:12 -0400
Received: from kroah.org ([198.145.64.141]:35590 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755702Ab0G3RDo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 13:03:44 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Jul 30 09:59:55 2010
Message-Id: <20100730165955.213082095@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 30 Jul 2010 09:57:32 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        =?ISO-8859-15?q?Krzysztof=20Ha=C5=82asa?= <khc@pm.waw.pl>,
        Michal Marek <mmarek@suse.cz>
Subject: [16/17] kbuild: Fix modpost segfault
In-Reply-To: <20100730170054.GA7736@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Krzysztof Halasa <khc@pm.waw.pl>

commit 1c938663d58b5b2965976a6f54cc51b5d6f691aa upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 scripts/mod/modpost.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -1292,7 +1292,7 @@ static unsigned int *reloc_location(stru
 	int section = sechdr->sh_info;
 
 	return (void *)elf->hdr + sechdrs[section].sh_offset +
-		(r->r_offset - sechdrs[section].sh_addr);
+		r->r_offset - sechdrs[section].sh_addr;
 }
 
 static int addend_386_rel(struct elf_info *elf, Elf_Shdr *sechdr, Elf_Rela *r)


