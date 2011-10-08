Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753509Ab1JHWfl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Oct 2011 18:35:41 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35769 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750735Ab1JHWfk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Oct 2011 18:35:40 -0400
Date: Sun, 9 Oct 2011 00:35:38 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Andrew Morton <akpm00@gmail.com>
Cc: Josh Boyer <jwboyer@redhat.com>, Nicolas Pitre <nicolas.pitre@linaro.org>,
        Ingo Molnar <mingo@elte.hu>, hongjiu.lu@intel.com,
        linux-kernel@vger.kernel.org, Russell King <rmk@arm.linux.org.uk>
Subject: Re: [PATCH v2] binfmt_elf: Fix PIE execution with randomization
 disabled (was Re: [RFC PATCH] binfmt_elf: Fix PIE execution with randomization
 disabled)
In-Reply-To: <20111003150305.936fc46e.akpm00@gmail.com>
Message-ID: <alpine.LNX.2.00.1110090033561.14901@pobox.suse.cz>
References: <20110929195359.GJ16720@zod.bos.redhat.com> <20110929141929.43df799d.akpm00@gmail.com> <alpine.LFD.2.02.1109291958210.9106@xanadu.home> <20110930021629.GL16720@zod.bos.redhat.com> <alpine.LNX.2.00.1110031651400.31654@pobox.suse.cz>
 <20111003150345.GP16720@zod.bos.redhat.com> <alpine.LNX.2.00.1110031709230.31654@pobox.suse.cz> <20111003150305.936fc46e.akpm00@gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 3 Oct 2011, Andrew Morton wrote:

> > Signed-off-by: Jiri Kosina <jkosina@suse.cz>
> > ---
> >  fs/binfmt_elf.c |    5 ++++-
> >  1 files changed, 4 insertions(+), 1 deletions(-)
> > 
> > diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
> > index dd0fdfc..bb11fe4 100644
> > --- a/fs/binfmt_elf.c
> > +++ b/fs/binfmt_elf.c
> > @@ -795,7 +795,10 @@ static int load_elf_binary(struct linux_binprm *bprm, struct pt_regs *regs)
> >  			 * might try to exec.  This is because the brk will
> >  			 * follow the loader, and is not movable.  */
> >  #if defined(CONFIG_X86) || defined(CONFIG_ARM)
> > -			load_bias = 0;
> > +			if (current->flags & PF_RANDOMIZE)
> > +				load_bias = 0;
> > +			else
> > +				load_bias = ELF_PAGESTART(ELF_ET_DYN_BASE - vaddr);
> >  #else
> >  			load_bias = ELF_PAGESTART(ELF_ET_DYN_BASE - vaddr);
> >  #endif
> 
> Guys, it took several people several days and 10+ emails to work out
> what's happening in there, and the first attempt to fix it was buggy. 
> This is all a huuuuge signal that the code is unobvious, hard to
> understand, hard to maintain.
> 
> Please, let's get a good code comment in there while it's fresh in your
> minds.  So the next person who comes along doesn't have the same amount
> of difficulty?

BTW, after thinking about this a little bit more, maybe the patch below 
would be worthwile and could save some mis-routed e-mails and bugreports 
in the future ...


From: Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH] MAINTAINERS: add ASLR maintainer

Since achieving the full ASLR by merging the PIE randomization in commit 
cc503c1b43 ("x86: PIE executable randomization"), I have been dealing with 
most (if not all) of the bugreports reported against userspace address 
space randomization, so it might be a good idea to provide a decent 
contact point in MAINTAINERS.

Signed-off-by: Jiri Kosina <jkosina@suse.cz>
---
 MAINTAINERS |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index ace8f9c..c362845 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -317,6 +317,10 @@ W:	http://wiki.analog.com/AD7879
 S:	Supported
 F:	drivers/input/touchscreen/ad7879.c
 
+ADDRESS SPACE LAYOUT RANDOMIZATION (ASLR)
+M:	Jiri Kosina <jkosina@suse.cz>
+S:	Maintained
+
 ADM1025 HARDWARE MONITOR DRIVER
 M:	Jean Delvare <khali@linux-fr.org>
 L:	lm-sensors@lm-sensors.org
-- 
1.7.3.1

