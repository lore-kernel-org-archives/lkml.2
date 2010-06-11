Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932657Ab0FKUm6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 16:42:58 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55613 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756917Ab0FKUm5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 16:42:57 -0400
Message-ID: <4C129FC7.8070308@zytor.com>
Date: Fri, 11 Jun 2010 13:42:47 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-3.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Krzysztof Halasa <khc@pm.waw.pl>
CC: Alan <alan@clueserver.org>, Michal Marek <mmarek@suse.cz>,
       =?UTF-8?B?QW3DqXJpY28gV2FuZw==?= <xiyou.wangcong@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Additional info on modpost segfault
References: <Pine.LNX.4.64.1006032008220.30918@blackbox.fnordora.org>	<20100604045118.GC5167@cr0.nay.redhat.com> <4C08A9D0.8000505@suse.cz>	<1275929979.2923.0.camel@zowie.clueserver.org> <m37hm6zdsr.fsf@intrepid.localdomain>
In-Reply-To: <m37hm6zdsr.fsf@intrepid.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michal, are you sending this to Linus?

	-hpa


On 06/10/2010 04:08 PM, Krzysztof Halasa wrote:
> Alan <alan@clueserver.org> writes:
> 
>> program: /home/alan/GitTrees/linux-2.6-mid-ref/scripts/mod/modpost -o
>> Module.symvers -S vmlinux.o
>>
>> Program received signal SIGSEGV, Segmentation fault.
> 
> It just hit me.
> It's the offset calculation in reloc_location() which overflows:
>         return (void *)elf->hdr + sechdrs[section].sh_offset +
>                (r->r_offset - sechdrs[section].sh_addr);
> 
> E.g. for the first rodata r entry:
> r->r_offset < sechdrs[section].sh_addr
> and the expression in the parenthesis produces 0xFFFFFFE0 or something
> equally wise.
> 
> Does the attached patch fix it?
> 
> Signed-off-by: Krzysztof Hałasa <khc@pm.waw.pl>
> 
> --- a/scripts/mod/modpost.c
> +++ b/scripts/mod/modpost.c
> @@ -1317,8 +1317,8 @@ static unsigned int *reloc_location(struct elf_info *elf,
>  	Elf_Shdr *sechdrs = elf->sechdrs;
>  	int section = sechdr->sh_info;
>  
>  	return (void *)elf->hdr + sechdrs[section].sh_offset +
> -		(r->r_offset - sechdrs[section].sh_addr);
> +		r->r_offset - sechdrs[section].sh_addr;
>  }
>  
>  static int addend_386_rel(struct elf_info *elf, Elf_Shdr *sechdr, Elf_Rela *r)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

