Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753961Ab0JYIqQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 04:46:16 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:34362 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753814Ab0JYIqP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 04:46:15 -0400
Date: Mon, 25 Oct 2010 10:45:53 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Huang Ying <ying.huang@intel.com>
Cc: Len Brown <lenb@kernel.org>, linux-kernel@vger.kernel.org,
        Andi Kleen <andi@firstfloor.org>, linux-acpi@vger.kernel.org,
        Borislav Petkov <petkovbb@googlemail.com>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Don Zickus <dzickus@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [NAK] Re: [PATCH -v2 9/9] ACPI, APEI, Generic Hardware Error Source
 POLL/IRQ/NMI notification type support
Message-ID: <20101025084553.GA27119@elte.hu>
References: <1287992610-14996-1-git-send-email-ying.huang@intel.com>
 <1287992610-14996-10-git-send-email-ying.huang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1287992610-14996-10-git-send-email-ying.huang@intel.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Huang Ying <ying.huang@intel.com> wrote:

> Generic Hardware Error Source provides a way to report platform
> hardware errors (such as that from chipset). It works in so called
> "Firmware First" mode, that is, hardware errors are reported to
> firmware firstly, then reported to Linux by firmware. This way, some
> non-standard hardware error registers or non-standard hardware link
> can be checked by firmware to produce more valuable hardware error
> information for Linux.
> 
> This patch adds POLL/IRQ/NMI notification types support.
> 
> Because the memory area used to transfer hardware error information
> from BIOS to Linux can be determined only in NMI, IRQ or timer
> handler, but general ioremap can not be used in atomic context, so a
> special version of atomic ioremap is implemented for that.
> 
> Signed-off-by: Huang Ying <ying.huang@intel.com>
> Reviewed-by: Andi Kleen <ak@linux.intel.com>
> ---
>  arch/x86/kernel/acpi/boot.c |    1 
>  arch/x86/kernel/dumpstack.c |    1 
>  drivers/acpi/apei/ghes.c    |  397 ++++++++++++++++++++++++++++++++++++--------
>  kernel/panic.c              |    1 
>  lib/ioremap.c               |    2 
>  mm/vmalloc.c                |    1 
>  6 files changed, 333 insertions(+), 70 deletions(-)

WTF?

Sigh, please integrate all this into EDAC (drivers/edac/) properly, instead of 
turning it into YET ANOTHER hardware vendor special hw-errors thing. We can do 
better than this. EDAC is almost there: it has support for Nehalem, AMD, a couple
of older chips.

Guys, instead of carving out a special driver area where you can produce crap 
without anyone looking too much, and pretending that the EDAC code does not exist, 
please try to work with others who are aiming higher and who are using saner 
interfaces.

Just look at the higher level structure in drivers/acpi/apei/:

  apei-base.c  apei-internal.h  cper.c  einj.c  erst.c  erst-dbg.c  ghes.c  hest.c  Kconfig  Makefile

ghes, einj, cper, erst? Someone's been abbreviating too much.

einj.c: it's about the 3rd separate 'error injection' concept that got introduced 
...

Please _THINK_ for goodness's sake and try to get some usable, coherent, generic 
interface to users - instead of just directly implementing whatever crap hw 
designers came up with.

So unless Linus or Andrew overrules me i'll NAK this before the insanity spreads too 
much:

 NAKed-by: Ingo Molnar <mingo@elte.hu>

(Someone should have NAK-ed it when the first iteration was merged.)

Thanks,

	Ingo
