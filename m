Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752790Ab2BTJjc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 04:39:32 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:36289 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752192Ab2BTJjb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 04:39:31 -0500
Date: Mon, 20 Feb 2012 14:55:40 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        jkenisto@us.ibm.com, a.p.zijlstra@chello.nl, ananth@in.ibm.com,
        anton@redhat.com, masami.hiramatsu.pt@hitachi.com, acme@infradead.org,
        tglx@linutronix.de, oleg@redhat.com
Subject: Re: [tip:perf/uprobes] uprobes/core: Clean up, refactor and
 improve the code
Message-ID: <20120220092540.GB22680@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <tip-ewbwhb8o6navvllsauu7k07p@git.kernel.org>
 <20120217104958.GA21998@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20120217104958.GA21998@elte.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12022009-4242-0000-0000-000000D15445
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> FYI, I created a new -tip topic branch for uprobes commits 
> [tip:perf/uprobes], with two patches applied so far:
> 
>  - your v10 #1/9 patch
>  - the above clean-ups and restructurings above it
> 
> ( Please have a good look at the code flow clean-ups I have 
>   performed, I have only build-tested the result. )

Okay, Will do accordingly.

> 
> As you can see it from the diffstat, there were many small 
> details that hindered code cleanliness, and there's at least one 
> bigger item that still needs to be addressed, which I have not 
> done in the above patch:
> 
> The arch methods and structures need to be better separated from 
> core uprobes code. Right now there's uprobes.h which exports 
> 'struct uprobe' to the rest of the kernel, such as 
> arch/x86/kernel/uprobes.c.
> 
> What we want instead is a clean separation of core code from 
> architecture code:
> 
>  - 'struct arch_uprobe' which includes all fields that 
>    'struct uprobe_arch_info' contains today. In the first 
>    approximation this is a rename.
> 
>  - please rename uprobe->arch_info to uprobe->arch - it's 
>    already clear that it's information.
> 

Okay.

>  - uprobe->insn[] needs to move from struct uprobe to
>    uprobe->arch.insn
> 
>  - The uprobes_arch_*() method(s) should be passed a
>    'struct arch_uprobe *', not a 'struct uprobe *'.
> 
>  - Once this is done, 'struct uprobe' can move to the head of 
>    kernel/uprobes.c, without any ugly #ifdefs and wrappery - 
>    that code only compiles if uprobes are enabled and if the 
>    architecture supports it.
> 
>  - asm/uprobes.h defines 'struct arch_uprobe' and the arch 
>    method(s) - nothing else.
> 
>  - write_opcode() and any similar functions should be renamed to 
>    the arch_uprobes_write_opcode() pattern

Currently the kernel/uprobes.c code handles insn as arch agnostic in
some cases and uses arch specific stuff for analysis, verification and
to set up fixups. The analysis, verification, and fixups is only done at
the probe insertion only.

The copy_insn code, write_opcode is mostly arch agnostic except for
the maximum length of any supported instruction for that architecture.
If we move the insn to arch_uprobe, then we would have to duplicate this 
code in arch specific files to do the copying of the instruction.
(not only at registration/unregistration times and also at probe hit
time to copy into the slot).
So I am still tempted to keep insn in struct uprobe rather than
arch_uprobe.

> 
>  - unless uprobe_opcode_t is non-byte on any architecture this 
>    typedef should probably be go away and be char * or void *.
> 

For architectures like powerpc, uprobe_opcode_t would be non-byte.
But I think we could still manage to remove uprobe_opcode_t.

> These changes should be done on top of latest -tip, in a single 
> patch or a small series, it's mostly pretty straightforward.
> 
> Please keep an eye on stylistic details for future patches - the 
> above patch gives a laundry list of what details were wrong in 
> the existing code.
> 
> Once this is done can we add #2, #3, etc. patches in a clean 
> manner.
> 

Okay.

> I'd suggest you don't send a full series but send small, edible 
> steps on top of the minimal (and right now not yet functional) 
> uprobes core code I've already applied, in series of 1-3 
> patches.
> 
> I'm sure there will be other small details we'll have to change 
> in these patches as we go forward, so not porting the full 
> series straight away would save you time and effort that the 
> inevitable conflicts create.

Okay. 

> 
> As an additional benefit, if you do it in such a workflow then I 
> can apply your new patches to tip:perf/uprobes pretty much the 
> moment you send them out, reviewing and testing them quickly - 
> without the time-consuming review of a long and interdependent 
> patch series and the resulting churn on your side.
> 
> I believe we could iterate this through in a couple of days and 
> arrive to a working 'perf probe' prototype.

Okay.

-- 
Thanks and Regards
Srikar

