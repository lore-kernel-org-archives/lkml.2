Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760021Ab2D0OBj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 10:01:39 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:30149 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758636Ab2D0OBi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 10:01:38 -0400
X-Authority-Analysis: v=2.0 cv=V/z/IJbi c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=d4WCelsBmbgA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=20KFwNOVAAAA:8 a=3nbZYyFuAAAA:8 a=meVymXHHAAAA:8 a=gKiKcZ1bwD_wT8OAni8A:9 a=u1DFdZfNmoxei8QvFs8A:7 a=PUjeQqilurYA:10 a=jEp0ucaQiEUA:10 a=EvKJbDF4Ut8A:10 a=jeBq3FmKZ4MA:10 a=HSsERQRiEpcdP7J7:21 a=gQITwH-R2CXobBiV:21 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1335535294.28106.206.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH 6/6][RFC] kprobes: Allow probe on ftrace reserved text
 (but move it)
From: Steven Rostedt <rostedt@goodmis.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        yrl.pp-manager.tt@hitachi.com
Date: Fri, 27 Apr 2012 10:01:34 -0400
In-Reply-To: <4F991F99.8050301@hitachi.com>
References: <20120426022922.683707508@goodmis.org>
	 <20120426023708.577576476@goodmis.org> <4F991F99.8050301@hitachi.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-04-26 at 19:12 +0900, Masami Hiramatsu wrote:

> Hmm, I think you'd better introduce a flag(KPROBE_FLAG_MOVED) for
> adjustment of probed IP address. Caller or handler can fixup its IP
> or kprobes itself can do it.
> 

> And also, you may need to use ftrace_text_reserved() here,
> or need a void ftrace_location() function for CONFIG_DYNAMIC_FTRACE=n.

Hi Masami,

What do you think of this patch?

-- Steve

commit 648bb05a49dcf95b9dddd07e361023124357ea36
Author: Steven Rostedt <srostedt@redhat.com>
Date:   Wed Apr 25 14:28:22 2012 -0400

    kprobes: Allow probe on ftrace reserved text (but move it)
    
    If a probe is placed on a ftrace nop (or ftrace_caller), simply move the
    probe to the next instruction instead of rejecting it. This will allow
    kprobes not to be affected by ftrace using the -mfentry gcc option which
    will put the ftrace nop at the beginning of the function. As a very common
    case for kprobes is to add a probe to the very beginning of a function
    we need a way to handle the case when ftrace takes the first instruction.
    
    Added KPROBE_FLAG_MOVED (as suggested by Masami) that is set when the address
    is moved to get around an ftrace nop.
    
    Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
    Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index 9310993..211ae45 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -414,6 +414,8 @@ static inline int ftrace_text_reserved(void *start, void *end)
 #define ftrace_set_notrace(ops, buf, len, reset) ({ -ENODEV; })
 #define ftrace_free_filter(ops) do { } while (0)
 
+static inline unsigned long ftrace_location(unsigned long ip) { return 0; }
+
 static inline ssize_t ftrace_filter_write(struct file *file, const char __user *ubuf,
 			    size_t cnt, loff_t *ppos) { return -ENODEV; }
 static inline ssize_t ftrace_notrace_write(struct file *file, const char __user *ubuf,
diff --git a/include/linux/kprobes.h b/include/linux/kprobes.h
index b6e1f8c..23cf41e 100644
--- a/include/linux/kprobes.h
+++ b/include/linux/kprobes.h
@@ -128,6 +128,7 @@ struct kprobe {
 				   * NOTE:
 				   * this flag is only for optimized_kprobe.
 				   */
+#define KPROBE_FLAG_MOVED	8 /* probe was moved passed ftrace nop */
 
 /* Has this kprobe gone ? */
 static inline int kprobe_gone(struct kprobe *p)
diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index c62b854..952619b 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -1319,10 +1319,22 @@ int __kprobes register_kprobe(struct kprobe *p)
 	struct kprobe *old_p;
 	struct module *probed_mod;
 	kprobe_opcode_t *addr;
+	unsigned long ftrace_addr;
 
 	addr = kprobe_addr(p);
 	if (IS_ERR(addr))
 		return PTR_ERR(addr);
+
+	/*
+	 * If the address is located on a ftrace nop, set the
+	 * breakpoint to the following instruction.
+	 */
+	ftrace_addr = ftrace_location((unsigned long)addr);
+	if (unlikely(ftrace_addr)) {
+		addr = (kprobe_opcode_t *)(ftrace_addr + MCOUNT_INSN_SIZE);
+		p->flags |= KPROBE_FLAG_MOVED;
+	}
+
 	p->addr = addr;
 
 	ret = check_kprobe_rereg(p);
@@ -1333,7 +1345,6 @@ int __kprobes register_kprobe(struct kprobe *p)
 	preempt_disable();
 	if (!kernel_text_address((unsigned long) p->addr) ||
 	    in_kprobes_functions((unsigned long) p->addr) ||
-	    ftrace_text_reserved(p->addr, p->addr) ||
 	    jump_label_text_reserved(p->addr, p->addr)) {
 		ret = -EINVAL;
 		goto cannot_probe;


