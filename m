Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759957Ab0FKAGg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 20:06:36 -0400
Received: from clueserver.org ([65.102.45.174]:36359 "EHLO clueserver.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755647Ab0FKAGf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 20:06:35 -0400
Date: Thu, 10 Jun 2010 17:06:34 -0700 (PDT)
From: alan <alan@clueserver.org>
X-X-Sender: alan@blackbox.fnordora.org
To: Krzysztof Halasa <khc@pm.waw.pl>
cc: Michal Marek <mmarek@suse.cz>,
       =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Additional info on modpost segfault
In-Reply-To: <m37hm6zdsr.fsf@intrepid.localdomain>
Message-ID: <Pine.LNX.4.64.1006101648190.20583@blackbox.fnordora.org>
References: <Pine.LNX.4.64.1006032008220.30918@blackbox.fnordora.org>
 <20100604045118.GC5167@cr0.nay.redhat.com> <4C08A9D0.8000505@suse.cz>
 <1275929979.2923.0.camel@zowie.clueserver.org> <m37hm6zdsr.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-1841603011-1276214794=:20583"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1841603011-1276214794=:20583
Content-Type: TEXT/PLAIN; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT

On Fri, 11 Jun 2010, Krzysztof Halasa wrote:

> Alan <alan@clueserver.org> writes:
>
>> program: /home/alan/GitTrees/linux-2.6-mid-ref/scripts/mod/modpost -o
>> Module.symvers -S vmlinux.o
>>
>> Program received signal SIGSEGV, Segmentation fault.
>
> It just hit me.
> It's the offset calculation in reloc_location() which overflows:
>        return (void *)elf->hdr + sechdrs[section].sh_offset +
>               (r->r_offset - sechdrs[section].sh_addr);
>
> E.g. for the first rodata r entry:
> r->r_offset < sechdrs[section].sh_addr
> and the expression in the parenthesis produces 0xFFFFFFE0 or something
> equally wise.
>
> Does the attached patch fix it?

YES!

Thank you!

Now the big question is why does this compile on older versions of gcc?

This needs to get added into 2.6.35-rc2.


>
> Signed-off-by: Krzysztof Haÿÿasa <khc@pm.waw.pl>
>
> --- a/scripts/mod/modpost.c
> +++ b/scripts/mod/modpost.c
> @@ -1317,8 +1317,8 @@ static unsigned int *reloc_location(struct elf_info *elf,
> 	Elf_Shdr *sechdrs = elf->sechdrs;
> 	int section = sechdr->sh_info;
>
> 	return (void *)elf->hdr + sechdrs[section].sh_offset +
> -		(r->r_offset - sechdrs[section].sh_addr);
> +		r->r_offset - sechdrs[section].sh_addr;
> }
>
> static int addend_386_rel(struct elf_info *elf, Elf_Shdr *sechdr, Elf_Rela *r)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

-- 
Truth is stranger than fiction because fiction has to make sense.
--8323328-1841603011-1276214794=:20583--
