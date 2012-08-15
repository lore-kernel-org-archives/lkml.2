Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752240Ab2HOWpY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 18:45:24 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:35796 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751006Ab2HOWpW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 18:45:22 -0400
Date: Wed, 15 Aug 2012 15:45:20 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Haavard Skinnemoen <hskinnemoen@gmail.com>,
        Hans-Christian Egtvedt <egtvedt@samfundet.no>,
        Mike Frysinger <vapier@gentoo.org>, Mark Salter <msalter@redhat.com>,
        Mikael Starvik <starvik@axis.com>,
        Jesper Nilsson <jesper.nilsson@axis.com>,
        David Howells <dhowells@redhat.com>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Richard Kuo <rkuo@codeaurora.org>,
        Hirokazu Takata <takata@linux-m32r.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Michal Simek <monstr@monstr.eu>,
        Koichi Yasutake <yasutake.koichi@jp.panasonic.com>,
        Jonas Bonn <jonas@southpole.se>, Chen Liqin <liqin.chen@sunplusct.com>,
        Lennox Wu <lennox.wu@gmail.com>, Paul Mundt <lethal@linux-sh.org>,
        "David S. Miller" <davem@davemloft.net>,
        Chris Zankel <chris@zankel.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [RFC] cross-arch: don't corrupt personality flags upon
 exec()
Message-Id: <20120815154520.f9cf4e24.akpm@linux-foundation.org>
In-Reply-To: <alpine.LNX.2.00.1208131518520.29827@pobox.suse.cz>
References: <alpine.LNX.2.00.1208031143320.29827@pobox.suse.cz>
	<alpine.LNX.2.00.1208131518520.29827@pobox.suse.cz>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 Aug 2012 15:19:40 +0200 (CEST)
Jiri Kosina <jkosina@suse.cz> wrote:

> On Fri, 3 Aug 2012, Jiri Kosina wrote:
> 
> > Historically, the top three bytes of personality have been used for things 
> > such as ADDR_NO_RANDOMIZE, which made sense only for specific 
> > architectures.
> > 
> > We now, however, have a flag there that is general no matter the 
> > architecture (UNAME26); generally we have to be careful to preserve the 
> > personality flags across exec().
> > 
> > This patch tries to fix all architectures that forcefully overwrite
> > personality flags during exec() (ppc32 and s390 have been fixed recently 
> > by commits f9783ec86 and 59e4c3a2f in a similar way already).
> > 
> > Signed-off-by: Jiri Kosina <jkosina@suse.cz>
> > ---
> > 
> > Untested, as I don't own the hardware.
> 
> Ping, Acks, Nacks, anyone?

Silence means "I'll fix it if you broke it" ;)

> Andrew, if noone has any objections, I guess this should perhaps go 
> through -mm.

Sure.  But..


> > --- a/arch/blackfin/include/asm/elf.h
> > +++ b/arch/blackfin/include/asm/elf.h
> > @@ -132,6 +132,7 @@ do {											\
> >  
> >  #define ELF_PLATFORM  (NULL)
> >  
> > -#define SET_PERSONALITY(ex) set_personality(PER_LINUX)
> > +#define SET_PERSONALITY(ex) \
> > +	set_personality(PER_LINUX | (current->personality & (~PER_MASK)))

This is repeated soooo many times.  Could we not just delete it and, in
include/linux/elf.h, do:

#ifndef SET_PERSONALITY
<that stuff>
#endif

?

If any SET_PERSONALITY-using code is including asm/elf.h directly then
it will reliably break and will get fixed.

Extra marks will be awarded if you can work out whether to use
PER_LINUX_32BIT ;)

