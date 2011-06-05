Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753852Ab1FERGy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jun 2011 13:06:54 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:47916 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753343Ab1FERGx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jun 2011 13:06:53 -0400
X-Originating-IP: 217.70.178.134
X-Originating-IP: 50.43.15.19
Date: Sun, 5 Jun 2011 10:06:39 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Sam Ravnborg <sam@ravnborg.org>, Jeremy Fitzhardinge <jeremy@goop.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Unhide DEBUG_BUGVERBOSE when EXPERT=y, even if
 DEBUG_KERNEL=n
Message-ID: <20110605170639.GA739@leaf>
References: <20110605083230.GA18260@leaf>
 <20110605093445.GA19927@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110605093445.GA19927@elte.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 05, 2011 at 11:34:45AM +0200, Ingo Molnar wrote:
> 
> * Josh Triplett <josh@joshtriplett.org> wrote:
> 
> >  config DEBUG_BUGVERBOSE
> > -	bool "Verbose BUG() reporting (adds 70K)" if DEBUG_KERNEL && EXPERT
> > +	bool "Verbose BUG() reporting (adds 70K)" if DEBUG_KERNEL || EXPERT
> 
> Well, DEBUG_KERNEL really means two things:
> 
>   - make more debugging options available
>   - allow the *disabling* of existing (default-enabled) debug options

As well as one more: a quick "git grep DEBUG_KERNEL" turns up a few uses
in actual kernel source code, to control debugging features.  Those
should likely use separately selectable debug options, but they
currently don't.

~/src/linux-2.6$ find * -not -name 'Kconfig*' -not -name '*defconfig' | xargs grep -n DEBUG_KERNEL
arch/parisc/mm/init.c:653:#ifdef CONFIG_DEBUG_KERNEL /* double-sanity-check paranoia */
arch/powerpc/kernel/sysfs.c:229:#ifdef CONFIG_DEBUG_KERNEL
arch/powerpc/kernel/sysfs.c:258:#endif /* CONFIG_DEBUG_KERNEL */
arch/powerpc/kernel/sysfs.c:299:#ifdef CONFIG_DEBUG_KERNEL
arch/powerpc/kernel/sysfs.c:328:#endif /* CONFIG_DEBUG_KERNEL */
arch/blackfin/include/asm/entry.h:53:/* As a debugging aid - we save IPEND when DEBUG_KERNEL is on,
arch/blackfin/include/asm/entry.h:56:# ifndef CONFIG_DEBUG_KERNEL
arch/blackfin/include/asm/entry.h:65:# else /* CONFIG_DEBUG_KERNEL */
arch/blackfin/include/asm/entry.h:77:# endif /* CONFIG_DEBUG_KERNEL */
arch/blackfin/include/asm/context.S:208:#ifdef CONFIG_DEBUG_KERNEL
drivers/usb/musb/musb_core.c:557:                * REVISIT:  do delays from lots of DEBUG_KERNEL checks

> So i think the right solution would be to select DEBUG_KERNEL if 
> EXPERT is enabled - this would simplify things and would allow the 
> removal of a lot of EXPERT conditions from the debug options.
> 
> Ok?

I could live with that, as long as CONFIG_DEBUG_KERNEL never directly
enables any debugging code like it does above, and just acts like
CONFIG_EXPERT in hiding a pile of unnecessary options.  DEBUG_KERNEL
should probably also have some text saying it doesn't actually enable
any kernel debugging on its own, once that becomes true.

- Josh Triplett
