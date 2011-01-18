Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751577Ab1ARNXW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jan 2011 08:23:22 -0500
Received: from racecourse.oldelvet.net ([93.93.128.81]:58815 "EHLO
	racecourse.oldelvet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751018Ab1ARNXV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jan 2011 08:23:21 -0500
Subject: Re: R_SPARC_13
From: Richard Mortimer <richm@oldelvet.org.uk>
To: David Miller <davem@davemloft.net>
Cc: richm@oldelvet.org.uk, 609371@bugs.debian.org, ben@decadent.org.uk,
        sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org,
        rostedt@goodmis.org, fweisbec@gmail.com, mingo@redhat.com,
        Jesper.Nilsson@axis.com, jeffm@suse.com
In-Reply-To: <4D3570D7.2090000@oldelvet.org.uk>
References: <20110117.130238.245404805.davem@davemloft.net>
	 <1295307243.32152.106.camel@duncow>
	 <20110117.163709.15244083.davem@davemloft.net>
	 <20110117.225022.59651505.davem@davemloft.net>
	 <4D3570D7.2090000@oldelvet.org.uk>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 18 Jan 2011 13:23:14 +0000
Message-ID: <1295356994.20446.3.camel@duncow>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-01-18 at 10:52 +0000, Richard Mortimer wrote:
> 
> On 18/01/2011 06:50, David Miller wrote:
> > From: David Miller<davem@davemloft.net>
> > Date: Mon, 17 Jan 2011 16:37:09 -0800 (PST)
> >
> >> So we do end up seeing the R_SPARC_LO10 + R_SPARC_13 sequences in the
> >> final module object.
> >>
> >> Therefore, we really should handle R_SPARC_13 in the sparc module loader.
> >
> > Ok, I now feel like I'm hallucinating.
> >
> > davem@sunset:~/src/GIT/linux-2.6-stable$ uname -a
> > Linux sunset 2.6.37 #1 SMP Wed Jan 12 20:14:59 PST 2011 sparc64 GNU/Linux
> > davem@sunset:~/src/GIT/linux-2.6-stable$ objdump --reloc /lib/modules/2.6.37/kernel/net/ipv6/ipv6.ko | grep R_SPARC_13
> > 0000000000000c7c R_SPARC_13        *ABS*+0x0000000000000004
> > 0000000000001ae4 R_SPARC_13        *ABS*+0x0000000000000018
> > 0000000000001b0c R_SPARC_13        *ABS*+0x0000000000000008
> >   ...
> > davem@sunset:~/src/GIT/linux-2.6-stable$ lsmod | grep ipv6
> > ipv6                  240422  12
> > davem@sunset:~/src/GIT/linux-2.6-stable$
> >
> > I must be missing something obvious.
> >
> 
> I think objdump may be distorting the truth a little. I found the 
> following in binutils gas/config/tc-sparc.c tc-gen_reloc(). I wonder if 
> it is displaying rewritten records rather than displaying the raw 
> contents. I haven't traced it through the code but the fact that it is 
> obviously working for you means that something like this is going on.
> 
>    /* We expand R_SPARC_OLO10 to R_SPARC_LO10 and R_SPARC_13
>       on the same location.  */
>    if (code == BFD_RELOC_SPARC_OLO10)
>      {
>        relocs[1] = reloc = (arelent *) xmalloc (sizeof (arelent));
>        relocs[2] = NULL;
> 
>        reloc->sym_ptr_ptr = (asymbol **) xmalloc (sizeof (asymbol *));
>        *reloc->sym_ptr_ptr
>          = symbol_get_bfdsym (section_symbol (absolute_section));
>        reloc->address = fixp->fx_frag->fr_address + fixp->fx_where;
>        reloc->howto = bfd_reloc_type_lookup (stdoutput, BFD_RELOC_SPARC13);
>        reloc->addend = fixp->tc_fix_data;
>      }
> 

Dave,

To close this off as a non-issue as far as my boot failures are
concerned I did some further checking and objdump is displaying
R_SPARC_OLO10 as two separate entries. I checked the scsi_mod.ko binary
and found the appropriate Elf64_Rela entry. That has 0x21 as the LSB of
r_info and that is the proper code for R_SPARC_OLO10 which is what you
expected in the first place!
 
objdump displays

0000000000001618 R_SPARC_LO10      __tracepoint_module_get
0000000000001618 R_SPARC_13        *ABS*+0x0000000000000008

The binary contains

0505140 00 00 00 00 00 00 16 18 00 00 04 0b 00 00 08 21
                                                     ^^
0505160 00 00 00 00 00 00 00 00

which corresponds to

typedef struct elf64_rela {
  Elf64_Addr r_offset;  /* Location at which to apply the action */
  Elf64_Xword r_info;   /* index and type of relocation */
  Elf64_Sxword r_addend;        /* Constant addend used to compute value */
} Elf64_Rela;

Regards

Richard

> I will try your alignment patch without any R_SPARC_13 related changes 
> and see how that goes.
> 
> Regards
> 
> Richard
> --
> To unsubscribe from this list: send the line "unsubscribe sparclinux" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


