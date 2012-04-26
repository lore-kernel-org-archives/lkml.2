Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756231Ab2DZMNI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 08:13:08 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:8746 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753504Ab2DZMNG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 08:13:06 -0400
X-Authority-Analysis: v=2.0 cv=IaEFqBWa c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=c1khG7T9Jk8A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=20KFwNOVAAAA:8 a=YXh-FDCKiTybpZebJ0kA:9 a=E1Tf4cGF47W5jjAFiAkA:7 a=PUjeQqilurYA:10 a=jEp0ucaQiEUA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1335442382.28106.176.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH 4/5] ftrace/x86: Have arch x86_64 use breakpoints
 instead of stop machine
From: Steven Rostedt <rostedt@goodmis.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, yrl.pp-manager.tt@hitachi.com
Date: Thu, 26 Apr 2012 08:13:02 -0400
In-Reply-To: <4F9926E2.4010100@hitachi.com>
References: <20120425184830.325105778@goodmis.org>
	 <20120425184930.873468066@goodmis.org> <4F9926E2.4010100@hitachi.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-04-26 at 19:43 +0900, Masami Hiramatsu wrote:
> (2012/04/26 3:48), Steven Rostedt wrote:
> > From: Steven Rostedt <srostedt@redhat.com>
> > 
> > This method changes x86 to add a breakpoint to the mcount locations
> > instead of calling stop machine.
> > 
> > Now that iret can be handled by NMIs, we perform the following to
> > update code:
> > 
> > 1) Add a breakpoint to all locations that will be modified
> > 
> > 2) Sync all cores
> > 
> > 3) Update all locations to be either a nop or call (except breakpoint
> >    op)
> > 
> > 4) Sync all cores
> > 
> > 5) Remove the breakpoint with the new code.
> > 
> > 6) Sync all cores
> > 
> > [
> >   Added updates that Masami suggested:
> >    Use unlikely(modifying_ftrace_code) in int3 trap to keep kprobes efficient.
> >    Don't use NOTIFY_* in ftrace handler in int3 as it is not a notifier.
> > ]
> 
> I just have a few comments :)
> 

Thanks Masami,

below is the changes I made. I'll post a v2.

-- Steve

diff --git a/arch/x86/include/asm/ftrace.h b/arch/x86/include/asm/ftrace.h
index f866c10..18d9005 100644
--- a/arch/x86/include/asm/ftrace.h
+++ b/arch/x86/include/asm/ftrace.h
@@ -51,8 +51,7 @@ struct dyn_arch_ftrace {
 	/* No extra data needed for x86 */
 };
 
-int ftrace_int3_handler(int cmd, const char *str,
-		struct pt_regs *regs, long err, int trap, int sig);
+int ftrace_int3_handler(struct pt_regs *regs);
 
 #endif /*  CONFIG_DYNAMIC_FTRACE */
 #endif /* __ASSEMBLY__ */
diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
index 24108af..80af347 100644
--- a/arch/x86/kernel/ftrace.c
+++ b/arch/x86/kernel/ftrace.c
@@ -344,10 +344,9 @@ int modifying_ftrace_code __read_mostly;
  * call to a nop. While the change is taking place, we treat
  * it just like it was a nop.
  */
-int ftrace_int3_handler(int cmd, const char *str,
-		 struct pt_regs *regs, long err, int trap, int sig)
+int ftrace_int3_handler(struct pt_regs *regs)
 {
-	if (!modifying_ftrace_code || cmd != DIE_INT3 || !regs)
+	if (WARN_ON_ONCE(!regs))
 		return 0;
 
 	if (!ftrace_location(regs->ip - 1))
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index 1712485..92d5756 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -306,10 +306,9 @@ gp_in_kernel:
 /* May run on IST stack. */
 dotraplinkage void __kprobes notrace do_int3(struct pt_regs *regs, long error_code)
 {
-#ifdef CONFIG_FUNCTION_TRACER
+#ifdef CONFIG_DYNAMIC_FTRACE
 	/* ftrace must be first, everything else may cause a recursive crash */
-	if (unlikely(modifying_ftrace_code) &&
-	    ftrace_int3_handler(DIE_INT3, "int3", regs, error_code, 3, SIGTRAP))
+	if (unlikely(modifying_ftrace_code) && ftrace_int3_handler(regs))
 		return;
 #endif
 #ifdef CONFIG_KGDB_LOW_LEVEL_TRAP


