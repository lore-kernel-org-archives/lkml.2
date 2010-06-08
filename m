Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756129Ab0FHR6T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 13:58:19 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:53825 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755725Ab0FHR6S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 13:58:18 -0400
Date: Tue, 8 Jun 2010 23:21:20 +0530
From: Himanshu Chauhan <hschauhan@nulltrace.org>
To: David Daney <ddaney@caviumnetworks.com>
Cc: ralf@linux-mips.org, linux-kernel@vger.kernel.org,
       linux-mips@linux-mips.org
Subject: Re: [PATCH] MIPS: KProbes support v0.1
Message-ID: <20100608175118.GA2262@hschauhan-desktop>
References: <1275928440-21052-1-git-send-email-hschauhan@nulltrace.org>
 <1275928440-21052-2-git-send-email-hschauhan@nulltrace.org>
 <4C0D4B82.6020002@caviumnetworks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C0D4B82.6020002@caviumnetworks.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

Thanks for taking a look.

> >+#ifdef CONFIG_KPROBES
> >+	DIE_PAGE_FAULT,
> >+	DIE_BREAK,
> >+	DIE_SSTEPBP,
> >+#endif
> >  };
> >
> 
> It might be cleaner without the #ifdef.  These are enum value
> definitions, so it doesn't affect code size.
>
Hmm.. I will remove this.
 
> 
> Can you also explain how the die notifier chain interacts with
> KProbes and why it cannot be a seperate notifier chain?

Actually, looking at x86 and other code, this is not the proper way
to do it. I will try to comeup with common approach.

> 
> >  #endif /* _ASM_MIPS_KDEBUG_H */
> >diff --git a/arch/mips/include/asm/kprobes.h b/arch/mips/include/asm/kprobes.h
> >new file mode 100644
> >index 0000000..0f647bf
> >--- /dev/null
> >+++ b/arch/mips/include/asm/kprobes.h
> >@@ -0,0 +1,85 @@
> [...]
> >+
> >+#define BREAKPOINT_INSTRUCTION		0x0000000d
> >+
> >+/*
> >+ * We do not have hardware single-stepping on MIPS.
> >+ * So we implement software single-stepping with breakpoint
> >+ * trap 'break 5'.
> >+ */
> >+#define BREAKPOINT_INSTRUCTION_2	0x0000014d
> 
> The BREAK codes are defined in asm/break.h  This should be added
> there instead.
> 
> Why do you use codes (0 and 5) that are already kind of reserved for
> user space debuggers?

As said ealier, this patch was based on some very older patch of 2.6.16 from
Sony Corp, I didn't make much changes like this. But anyways, I wan't aware of
this either. What would be the best code then?

> 
> >+#define MAX_INSN_SIZE 			2
> >+
> >+#define flush_insn_slot(p)		do { \
> >+        /* invalidate I-cache */             \
> >+        asm volatile("cache 0, 0($0)");      \
> >+        /* invalidate D-cache */             \
> >+        asm volatile("cache 9, 0($0)");      \
> >+        } while(0);
> >+
> 
> You have to call a function in arch/mips/mm/c-* to do this, you
> cannot open code with CACHE instructions as you need to handle CPU
> quirks and SMP.  It is possible that flush_icache_range() or
> flush_cache_sigtramp() would work.  Or we might need something new.
> 
> I see you use flush_icache_range() below, why have this definition,
> it looks unused?

Framework needs you to define this.

> 
> Why this ugliness?  Can't you handle it in do_bp() or  do_trap_or_bp()?

Let me see what I can do about this.

> Need to add or otherwise handle:
> 
> 
> #ifdef CONFIG_CPU_CAVIUM_OCTEON
> 	case lwc2_op: /* This is bbit0 on Octeon */
> 	case ldc2_op: /* This is bbit032 on Octeon */
> 	case swc2_op: /* This is bbit1 on Octeon */
> 	case sdc2_op: /* This is bbit132 on Octeon */
> #endif

Though I have worked on octeon before but I don't remember nitty-gritties.
And I have no clue about these ops :) No way to test either!

With all that, I will soon send an updated patch.
Thanks for the review!

Regards
-Himanshu
