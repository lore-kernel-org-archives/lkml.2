Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756934Ab2IXQBN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 12:01:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44576 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756185Ab2IXQBL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 12:01:11 -0400
Date: Mon, 24 Sep 2012 18:02:50 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Anton Arapov <anton@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] uprobes: Kill set_swbp()->is_swbp_at_addr()
Message-ID: <20120924160250.GA15999@redhat.com>
References: <20120923201921.GA27424@redhat.com> <20120923201945.GA27446@redhat.com> <20120924090858.GA2248@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120924090858.GA2248@in.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/24, Ananth N Mavinakayanahalli wrote:
>
> On Sun, Sep 23, 2012 at 10:19:45PM +0200, Oleg Nesterov wrote:
>
> > It doesn't matter if this "int3" was in fact
> > installed by gdb or application itself, we are going to "steal" this
> > breakpoint anyway and execute the original insn from vm_file even if
> > it no longer matches the memory.
>
> Wouldn't this text make more sense:
>
> It doesn't matter if this 'breakpoint' was in fact...
>
> 'int3' is still an x86 artifact.

Agreed, will update the changelog.

> On powerpc, we don't even get to install_breakpoint() ->set_swbp()
> ->is_swbp_at_addr() because arch_uprobe_analyze_insn() would've already
> caused install_breakpoint() to return -ENOTSUPP.
>
> > OTOH, handle_swbp()->find_active_uprobe() uses is_swbp_at_addr() to
> > figure out whether we need to send SIGTRAP or not if we can not find
> > uprobe, so in this case it should return true for all trap variants,
> > not only for UPROBE_SWBP_INSN.
>
> So, we will need a powerpc specific is_swbp_insn()... ok.

I think yes.

But again, we need 2 helpers. One for is_swbp_at_addr(), and another
for verify_opcode() which only checks UPROBE_SWBP_INSN. IOW, something
like the patch below (on top of this series).

Do you agree?

Oleg.

--- x/kernel/events/uprobes.c
+++ x/kernel/events/uprobes.c
@@ -178,6 +178,11 @@ static int __replace_page(struct vm_area
  * Default implementation of is_swbp_insn
  * Returns true if @insn is a breakpoint instruction.
  */
+static bool is_uprobe_opcode(uprobe_opcode_t *insn)
+{
+	return *insn == UPROBE_SWBP_INSN;
+}
+
 bool __weak is_swbp_insn(uprobe_opcode_t *insn)
 {
 	return *insn == UPROBE_SWBP_INSN;
@@ -196,9 +201,9 @@ static int verify_opcode(struct page *pa
 	bool is_swbp;
 
 	copy_opcode(page, vaddr, &old_opcode);
-	is_swbp = is_swbp_insn(&old_opcode);
+	is_swbp = is_uprobe_opcode(&old_opcode);
 
-	if (is_swbp_insn(new_opcode)) {
+	if (is_uprobe_opcode(new_opcode)) {
 		if (is_swbp)		/* register: already installed? */
 			return 0;
 	} else {
@@ -585,7 +590,7 @@ install_breakpoint(struct uprobe *uprobe
 		if (ret)
 			return ret;
 
-		if (is_swbp_insn((uprobe_opcode_t *)uprobe->arch.insn))
+		if (is_uprobe_opcode((uprobe_opcode_t *)uprobe->arch.insn))
 			return -ENOTSUPP;
 
 		ret = arch_uprobe_analyze_insn(&uprobe->arch, mm, vaddr);

