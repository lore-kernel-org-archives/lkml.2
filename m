Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752346Ab2BQKuc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 05:50:32 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:60980 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752042Ab2BQKub (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 05:50:31 -0500
Date: Fri, 17 Feb 2012 11:49:58 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        jkenisto@us.ibm.com, a.p.zijlstra@chello.nl, ananth@in.ibm.com,
        anton@redhat.com, masami.hiramatsu.pt@hitachi.com, acme@infradead.org,
        srikar@linux.vnet.ibm.com, tglx@linutronix.de, oleg@redhat.com
Subject: Re: [tip:perf/uprobes] uprobes/core: Clean up, refactor and improve
 the code
Message-ID: <20120217104958.GA21998@elte.hu>
References: <tip-ewbwhb8o6navvllsauu7k07p@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tip-ewbwhb8o6navvllsauu7k07p@git.kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Srikar,

* tip-bot for Ingo Molnar <mingo@elte.hu> wrote:

> Commit-ID:  7b2d81d48a2d8e37efb6ce7b4d5ef58822b30d89
> Gitweb:     http://git.kernel.org/tip/7b2d81d48a2d8e37efb6ce7b4d5ef58822b30d89
> Author:     Ingo Molnar <mingo@elte.hu>
> AuthorDate: Fri, 17 Feb 2012 09:27:41 +0100
> Committer:  Ingo Molnar <mingo@elte.hu>
> CommitDate: Fri, 17 Feb 2012 10:18:07 +0100
> 
> uprobes/core: Clean up, refactor and improve the code
> 
> Make the uprobes code readable to me:
> 
>  - improve the Kconfig text so that a mere mortal gets some idea
>    what CONFIG_UPROBES=y is really about
> 
>  - do trivial renames to standardize around the uprobes_*() namespace
> 
>  - clean up and simplify various code flow details
> 
>  - separate basic blocks of functionality
> 
>  - line break artifact and white space related removal
> 
>  - use standard local varible definition blocks
> 
>  - use vertical spacing to make things more readable
> 
>  - remove unnecessary volatile
> 
>  - restructure comment blocks to make them more uniform and
>    more readable in general
> 
> Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
> Cc: Jim Keniston <jkenisto@us.ibm.com>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Oleg Nesterov <oleg@redhat.com>
> Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> Cc: Arnaldo Carvalho de Melo <acme@infradead.org>
> Cc: Anton Arapov <anton@redhat.com>
> Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
> Link: http://lkml.kernel.org/n/tip-ewbwhb8o6navvllsauu7k07p@git.kernel.org
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> ---
>  arch/Kconfig                   |   14 ++-
>  arch/x86/include/asm/uprobes.h |   17 ++--
>  arch/x86/kernel/uprobes.c      |  129 ++++++++++++-----------
>  include/linux/uprobes.h        |   28 +++---
>  kernel/uprobes.c               |  219 +++++++++++++++++++++++-----------------
>  mm/mmap.c                      |   12 +-
>  6 files changed, 233 insertions(+), 186 deletions(-)

FYI, I created a new -tip topic branch for uprobes commits 
[tip:perf/uprobes], with two patches applied so far:

 - your v10 #1/9 patch
 - the above clean-ups and restructurings above it

( Please have a good look at the code flow clean-ups I have 
  performed, I have only build-tested the result. )

As you can see it from the diffstat, there were many small 
details that hindered code cleanliness, and there's at least one 
bigger item that still needs to be addressed, which I have not 
done in the above patch:

The arch methods and structures need to be better separated from 
core uprobes code. Right now there's uprobes.h which exports 
'struct uprobe' to the rest of the kernel, such as 
arch/x86/kernel/uprobes.c.

What we want instead is a clean separation of core code from 
architecture code:

 - 'struct arch_uprobe' which includes all fields that 
   'struct uprobe_arch_info' contains today. In the first 
   approximation this is a rename.

 - please rename uprobe->arch_info to uprobe->arch - it's 
   already clear that it's information.

 - uprobe->insn[] needs to move from struct uprobe to
   uprobe->arch.insn

 - The uprobes_arch_*() method(s) should be passed a
   'struct arch_uprobe *', not a 'struct uprobe *'.

 - Once this is done, 'struct uprobe' can move to the head of 
   kernel/uprobes.c, without any ugly #ifdefs and wrappery - 
   that code only compiles if uprobes are enabled and if the 
   architecture supports it.

 - asm/uprobes.h defines 'struct arch_uprobe' and the arch 
   method(s) - nothing else.

 - unless uprobe_opcode_t is non-byte on any architecture this 
   typedef should probably be go away and be char * or void *.

 - write_opcode() and any similar functions should be renamed to 
   the arch_uprobes_write_opcode() pattern

These changes should be done on top of latest -tip, in a single 
patch or a small series, it's mostly pretty straightforward.

Please keep an eye on stylistic details for future patches - the 
above patch gives a laundry list of what details were wrong in 
the existing code.

Once this is done can we add #2, #3, etc. patches in a clean 
manner.

I'd suggest you don't send a full series but send small, edible 
steps on top of the minimal (and right now not yet functional) 
uprobes core code I've already applied, in series of 1-3 
patches.

I'm sure there will be other small details we'll have to change 
in these patches as we go forward, so not porting the full 
series straight away would save you time and effort that the 
inevitable conflicts create.

As an additional benefit, if you do it in such a workflow then I 
can apply your new patches to tip:perf/uprobes pretty much the 
moment you send them out, reviewing and testing them quickly - 
without the time-consuming review of a long and interdependent 
patch series and the resulting churn on your side.

I believe we could iterate this through in a couple of days and 
arrive to a working 'perf probe' prototype.

Thanks,

	Ingo
