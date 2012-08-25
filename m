Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751386Ab2HYE0C (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2012 00:26:02 -0400
Received: from db3ehsobe001.messaging.microsoft.com ([213.199.154.139]:51743
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750830Ab2HYEZ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2012 00:25:57 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: 5
X-BigFish: VPS5(z37d4l1036lz98dI9371I1432Izz1202hzz8275bh8275dhz2dh668h839h944hd25hd2bhf0ah107ah1155h)
X-WSS-ID: 0M9AMZ2-01-1J3-02
X-M-MSG: 
Date: Fri, 24 Aug 2012 23:25:48 -0500
From: Jacob Shin <jacob.shin@amd.com>
To: Yinghai Lu <yinghai@kernel.org>
CC: X86-ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Tejun Heo <tj@kernel.org>,
        Dave Young <dyoung@redhat.com>, Chao Wang <chaowang@redhat.com>,
        Vivek Goyal <vgoyal@redhat.com>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: Re: [PATCH 5/5] x86: if kernel .text .data .bss are not marked as
 E820_RAM, complain and fix
Message-ID: <20120825042541.GE26127@jshin-Toonie>
References: <1345852516-3125-1-git-send-email-jacob.shin@amd.com>
 <1345852516-3125-6-git-send-email-jacob.shin@amd.com>
 <CAE9FiQXhtEEyGnd1sHjcSDHiC6ZQ77rQDo-nSCHpjcjvMCzPDg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CAE9FiQXhtEEyGnd1sHjcSDHiC6ZQ77rQDo-nSCHpjcjvMCzPDg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 24, 2012 at 06:23:48PM -0700, Yinghai Lu wrote:
> On Fri, Aug 24, 2012 at 4:55 PM, Jacob Shin <jacob.shin@amd.com> wrote:
> > There could be cases where user supplied memmap=exactmap memory
> > mappings do not mark the region where the kernel .text .data and
> > .bss reside as E820_RAM as reported here:
> >
> > https://lkml.org/lkml/2012/8/14/86
> >
> > Handle it by complaining, and adding the range back into the e820.
> >
> > Signed-off-by: Jacob Shin <jacob.shin@amd.com>
> > ---
> >  arch/x86/kernel/setup.c |   15 +++++++++++++++
> >  1 file changed, 15 insertions(+)
> >
> > diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
> > index 4217fb4..b84aceb5 100644
> > --- a/arch/x86/kernel/setup.c
> > +++ b/arch/x86/kernel/setup.c
> > @@ -926,6 +926,21 @@ void __init setup_arch(char **cmdline_p)
> >         insert_resource(&iomem_resource, &data_resource);
> >         insert_resource(&iomem_resource, &bss_resource);
> >
> > +       /*
> > +        * Complain if .text .data and .bss are not marked as E820_RAM and
> > +        * attempt to fix it by adding the range. We may have a confused BIOS,
> > +        * or the user may have incorrectly supplied it via memmap=exactmap. If
> > +        * we really are running on top non-RAM, we will crash later anyways.
> > +        */
> > +       if (!e820_all_mapped(code_resource.start, bss_resource.end, E820_RAM)) {
> > +               pr_warn(".text .data .bss are not marked as E820_RAM!\n");
> > +
> > +               e820_add_region(code_resource.start,
> > +                               bss_resource.end - code_resource.start + 1,
> > +                               E820_RAM);
> > +               sanitize_e820_map(e820.map, ARRAY_SIZE(e820.map), &e820.nr_map);
> 
>            this sanitze_e820_map could be spared. trim_bios_range will
> that always.

Ah. okay

> 
> > +       }
> > +
> >         trim_bios_range();
> >  #ifdef CONFIG_X86_32
> >         if (ppro_with_ram_bug()) {
> 
> also should use brk_limit instead of bss_resource.end. aka need to
> keep the map for brk area.

Okay.. will fix on Monday

> 
> Thanks
> 
> Yinghai
> 

