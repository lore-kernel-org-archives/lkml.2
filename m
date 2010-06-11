Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760576Ab0FKWty (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 18:49:54 -0400
Received: from cantor.suse.de ([195.135.220.2]:45631 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755801Ab0FKWtw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 18:49:52 -0400
Date: Sat, 12 Jun 2010 00:49:47 +0200
From: Michal Marek <mmarek@suse.cz>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Krzysztof Halasa <khc@pm.waw.pl>, Alan <alan@clueserver.org>,
       =?iso-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Additional info on modpost segfault
Message-ID: <20100611224947.GA17453@sepie.suse.cz>
References: <Pine.LNX.4.64.1006032008220.30918@blackbox.fnordora.org>
 <20100604045118.GC5167@cr0.nay.redhat.com>
 <4C08A9D0.8000505@suse.cz>
 <1275929979.2923.0.camel@zowie.clueserver.org>
 <m37hm6zdsr.fsf@intrepid.localdomain>
 <4C129FC7.8070308@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4C129FC7.8070308@zytor.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 11, 2010 at 01:42:47PM -0700, H. Peter Anvin wrote:
> Michal, are you sending this to Linus?

I'll, once Linus takes another pull request I sent a couple of hours
ago. Thanks for the patch Krzysztof!

Michal

> 
> 	-hpa
> 
> 
> On 06/10/2010 04:08 PM, Krzysztof Halasa wrote:
> > Alan <alan@clueserver.org> writes:
> > 
> >> program: /home/alan/GitTrees/linux-2.6-mid-ref/scripts/mod/modpost -o
> >> Module.symvers -S vmlinux.o
> >>
> >> Program received signal SIGSEGV, Segmentation fault.
> > 
> > It just hit me.
> > It's the offset calculation in reloc_location() which overflows:
> >         return (void *)elf->hdr + sechdrs[section].sh_offset +
> >                (r->r_offset - sechdrs[section].sh_addr);
> > 
> > E.g. for the first rodata r entry:
> > r->r_offset < sechdrs[section].sh_addr
> > and the expression in the parenthesis produces 0xFFFFFFE0 or something
> > equally wise.
> > 
> > Does the attached patch fix it?
> > 
> > Signed-off-by: Krzysztof Hałasa <khc@pm.waw.pl>
> > 
> > --- a/scripts/mod/modpost.c
> > +++ b/scripts/mod/modpost.c
> > @@ -1317,8 +1317,8 @@ static unsigned int *reloc_location(struct elf_info *elf,
> >  	Elf_Shdr *sechdrs = elf->sechdrs;
> >  	int section = sechdr->sh_info;
> >  
> >  	return (void *)elf->hdr + sechdrs[section].sh_offset +
> > -		(r->r_offset - sechdrs[section].sh_addr);
> > +		r->r_offset - sechdrs[section].sh_addr;
> >  }
> >  
> >  static int addend_386_rel(struct elf_info *elf, Elf_Shdr *sechdr, Elf_Rela *r)
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
