Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756439Ab1JCPL4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 11:11:56 -0400
Received: from cantor2.suse.de ([195.135.220.15]:59286 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755995Ab1JCPLt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 11:11:49 -0400
Date: Mon, 3 Oct 2011 17:11:47 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Josh Boyer <jwboyer@redhat.com>
Cc: Nicolas Pitre <nicolas.pitre@linaro.org>, Andrew Morton <akpm00@gmail.com>,
        Ingo Molnar <mingo@elte.hu>, hongjiu.lu@intel.com,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Russell King <rmk@arm.linux.org.uk>
Subject: [PATCH v2] binfmt_elf: Fix PIE execution with randomization disabled
 (was Re: [RFC PATCH] binfmt_elf: Fix PIE execution with randomization
 disabled)
In-Reply-To: <20111003150345.GP16720@zod.bos.redhat.com>
Message-ID: <alpine.LNX.2.00.1110031709230.31654@pobox.suse.cz>
References: <20110929195359.GJ16720@zod.bos.redhat.com> <20110929141929.43df799d.akpm00@gmail.com> <alpine.LFD.2.02.1109291958210.9106@xanadu.home> <20110930021629.GL16720@zod.bos.redhat.com> <alpine.LNX.2.00.1110031651400.31654@pobox.suse.cz>
 <20111003150345.GP16720@zod.bos.redhat.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 3 Oct 2011, Josh Boyer wrote:

> > > Perhaps another check here for randomize?  Something like:
> > > 
> > > #if defined(CONFIG_X86) || defined(CONFIG_ARM)
> > > 		if (current->flags & PF_RANDOMIZE)
> > > 			load_bias = 0;
> > > 		else if (vaddr)
> > > 			load_bias = 0;
> > > 		else
> > > 			load_bias = ELF_PAGESTART(ELF_ET_DYN_BASE);
> > > #else
> > > 		load_bias = ELF_PAGESTART(ELF_ET_DYN_BASE - vaddr);
> > > #endif
> > > 
> > > If that's stupid, then feel free to tell me.  I won't pretend like I
> > > understand what is going on here yet, but based on the explanation you
> > > provided that might work.
> > 
> > I have just verified my hunch that the original patch from H.J. / Josh 
> > breaks ASLR completely, so Andrew, please drop it for now.
> 
> Yes, please drop the original.

Thanks.

> > I am now looking into how to fix things properly.
> > 
> > Josh, looking at what you are proposing -- do you see any reason to make 
> > the behavior different in #else branch and in !(current->flags & 
> > PF_RANDOMIZE) case?
> 
> I was mostly just trying to adapt H.J.'s patch to account for the
> PF_RANDOMIZE case.  Looking at it a bit more, I'm not sure why they
> would need to be different.  H.J., do you recall why you made that
> change originally?

How about the patch below instead? It survives my testing, and I believe 
it handles both cases properly.

Confirmation from the original bug reporter would obviously be a nice 
bonus too :)




From: Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH] binfmt_elf: fix PIE execution with randomization disabled

The case of address space randomization being disabled in runtime through
randomize_va_space sysctl is not treated properly in load_elf_binary(),
resulting in SIGKILL coming at exec() time for certain PIE-linked binaries
in case the randomization has been disabled at runtime prior to calling
exec().

Handle the randomize_va_space == 0 case the same way as if we were not
supporting .text randomization at all.

Based on original patch by H.J. Lu <hongjiu.lu@intel.com> and
Josh Boyer <jwboyer@redhat.com>

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Jiri Kosina <jkosina@suse.cz>
Cc: Nicolas Pitre <nicolas.pitre@linaro.org>
Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
---
 fs/binfmt_elf.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index dd0fdfc..bb11fe4 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -795,7 +795,10 @@ static int load_elf_binary(struct linux_binprm *bprm, struct pt_regs *regs)
 			 * might try to exec.  This is because the brk will
 			 * follow the loader, and is not movable.  */
 #if defined(CONFIG_X86) || defined(CONFIG_ARM)
-			load_bias = 0;
+			if (current->flags & PF_RANDOMIZE)
+				load_bias = 0;
+			else
+				load_bias = ELF_PAGESTART(ELF_ET_DYN_BASE - vaddr);
 #else
 			load_bias = ELF_PAGESTART(ELF_ET_DYN_BASE - vaddr);
 #endif

