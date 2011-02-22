Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752334Ab1BVRI7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 12:08:59 -0500
Received: from anubis.se.axis.com ([195.60.68.12]:51229 "EHLO
	anubis.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750985Ab1BVRI5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 12:08:57 -0500
Date: Tue, 22 Feb 2011 18:08:49 +0100
From: Jesper Nilsson <jesper.nilsson@axis.com>
To: Dmitry Torokhov <dtor@vmware.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        David Miller <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "geert@linux-m68k.org" <geert@linux-m68k.org>,
        "linux-m68k@vger.kernel.org" <linux-m68k@vger.kernel.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        Mikael Starvik <starvik@axis.com>
Subject: Re: [PATCH 1/3] module: deal with alignment issues in built-in
	module versions
Message-ID: <20110222170849.GW13204@axis.com>
References: <20110217.140119.39175251.davem@davemloft.net> <20110217221957.GA11244@dtor-ws.eng.vmware.com> <20110217.142320.102554706.davem@davemloft.net> <AANLkTinMfTss+9K7fPQbxoMD7d-U_AyCc29_RRPRija3@mail.gmail.com> <AANLkTikd-OBhe6-wK7-Xvv-asNSeVKs+0-a0d3FF2KVu@mail.gmail.com> <1298074455.2460.85.camel@pasglop> <87pqqmrq9q.fsf@rustcorp.com.au> <1298339909.8833.135.camel@pasglop> <AANLkTimyaA+JdBHekm69R5Y2A2DEdPdndFLrKJAaz=vt@mail.gmail.com> <20110222070240.GA21765@dtor-ws.eng.vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110222070240.GA21765@dtor-ws.eng.vmware.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 22, 2011 at 08:02:40AM +0100, Dmitry Torokhov wrote:
> On Mon, Feb 21, 2011 at 06:03:16PM -0800, Linus Torvalds wrote:
> > On Mon, Feb 21, 2011 at 5:58 PM, Benjamin Herrenschmidt
> > <benh@kernel.crashing.org> wrote:
> > >
> > > The only sane thing I can see is make sure that such structures that
> > > we put into sections "arrays" like that are naturally aligned with
> > > padding.
> > 
> > The sad part is, that assuming I read the gcc sources correctly (see
> > the earlier emails where David pointed to it), that alignment is:
> >  - architecture-specific
> >  - depends on the size of the structure
> >  - seems to depend on the version of gcc itself.
> > 
> > The _one_ safe case is likely to be "structure size is a power of
> > two". And it does look like using a pointer is going to be safe, not
> > only because the gcc auto-alignment only triggers for things like
> > structs/unions/arrays, but because at least the x86 code only does it
> > if the structure was bigger than the alignment size itself.
> > 
> > So using pointer indirection is likely to be safe. It's still ugly and
> > annoying as heck, though.
> > 
> 
> Regardless the approach we'll take I think the following patch is also
> needed (for cris architecture). I am not sure why __param section is
> inly defined for one specific subarch

That's probably just a legacy from when I combined the linkscripts
for the two architectures. If I remember correctly, RODATA brings
in RO_DATA_SECTION which in turn brings in __param and __modver
for both architectures. CRISv32 then duplicates the __param stuff
for some historical reason.

> but I they need __param they'll
> need __modev as well.

True, at least until I've made sure that there isn't any
underlying reason for CRISv32 to put __param in a different place...

Acked-by: Jesper Nilsson <jesper.nilsson@axis.com>

> Thanks,
> 
> Dmitry

/Jesper

> >From a567280f900c15891a55e7ea4e2919b38e1d1a01 Mon Sep 17 00:00:00 2001
> From: Dmitry Torokhov <dtor@vmware.com>
> Date: Thu, 17 Feb 2011 13:12:26 -0800
> Subject: [PATCH] cris: add missing __modver section
> 
> Commit e94965ed5beb23c6fabf7ed31f625e66d7ff28de added a new __modver
> section to store module version information for drivers built into the
> kernel, but missed the fact that cris does some additional steps to
> set up sections.
> 
> Signed-off-by: Dmitry Torokhov <dtor@vmware.com>
> ---
>  arch/cris/kernel/vmlinux.lds.S |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/cris/kernel/vmlinux.lds.S b/arch/cris/kernel/vmlinux.lds.S
> index 4422189..fae1b7b 100644
> --- a/arch/cris/kernel/vmlinux.lds.S
> +++ b/arch/cris/kernel/vmlinux.lds.S
> @@ -73,6 +73,10 @@ SECTIONS
>  	.init.data : { INIT_DATA }
>  	.init.setup : { INIT_SETUP(16) }
>  #ifdef CONFIG_ETRAX_ARCH_V32
> +	__start___modver = .;
> +	__modver : { *(__modver) }
> +	__stop___modver = .;
> +
>  	__start___param = .;
>  	__param : { *(__param) }
>  	__stop___param = .;
> -- 
> 1.7.3.2
/^JN - Jesper Nilsson
-- 
               Jesper Nilsson -- jesper.nilsson@axis.com
